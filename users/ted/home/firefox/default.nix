{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

# Firefox as the Google-free main browser. Google services live only in
# Brave; here every Google domain is blocked (first- and third-party) by
# uBlock Origin, and Firefox's own Google lookups (Safe Browsing,
# geolocation) are turned off.
let
  cfg = config.veritas.configs.firefox;
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

  # Search shortcut with a keyword alias, e.g. "@np ripgrep".
  mkEngine = name: alias: template: {
    inherit name;
    urls = [ { inherit template; } ];
    definedAliases = [ alias ];
  };

  googleDomains = [
    "google.com"
    "google.pl"
    "googleapis.com"
    "gstatic.com"
    "googleusercontent.com"
    "googlevideo.com"
    "googletagmanager.com"
    "googletagservices.com"
    "google-analytics.com"
    "googleadservices.com"
    "googlesyndication.com"
    "doubleclick.net"
    "youtube.com"
    "youtube-nocookie.com"
    "youtu.be"
    "ytimg.com"
    "ggpht.com"
    "recaptcha.net"
    "gvt1.com"
    "gvt2.com"
    "1e100.net"
  ];
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFormHistory = true;
        # Passwords live in passage, not in Firefox.
        OfferToSaveLogins = false;
        DNSOverHTTPS = {
          # Keep resolving through Mullvad's DNS.
          Enabled = false;
          Locked = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Cookies = {
          Behavior = "reject-tracker-and-partition-foreign";
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = true;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          Locked = true;
        };

        # Extensions are installed from the flake (profiles.default.extensions);
        # the policy only lets them run in private windows.
        ExtensionSettings =
          lib.genAttrs
            [
              addons.ublock-origin.addonId
              addons.vimium.addonId
            ]
            (_: {
              private_browsing = true;
            });

        # uBlock managed storage. Overwriting filterLists replaces the
        # selection, so the defaults are listed explicitly; "user-filters"
        # must stay in it for the filters below to apply.
        "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite = {
          filters = map (d: "||${d}^") googleDomains;
          filterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "plowe-0"
          ];
        };
      };

      # Fresh, HM-managed profile: the old ~/.mozilla profile directory is
      # left on disk (unlisted) and may still hold Google cookies.
      profiles.default = {
        isDefault = true;

        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          engines = {
            google.metaData.hidden = true;
            nix-packages =
              mkEngine "Nix Packages" "@np"
                "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            nixos-options =
              mkEngine "NixOS Options" "@no"
                "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            home-manager-options =
              mkEngine "Home Manager Options" "@hm"
                "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
            nixos-wiki = mkEngine "NixOS Wiki" "@nw" "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            noogle = mkEngine "Noogle" "@ng" "https://noogle.dev/q?term={searchTerms}";
            github-code = mkEngine "GitHub Code" "@gh" "https://github.com/search?type=code&q={searchTerms}";
          };
        };

        extensions.packages = with addons; [
          ublock-origin
          vimium
        ];

        # Slim UI: hide Firefox View and the "List all tabs" chevron.
        userChrome = ''
          #firefox-view-button,
          #alltabs-button {
            display: none !important;
          }
        '';

        settings = {
          "browser.contentblocking.category" = "strict";
          # Safe Browsing lists come from Google (safebrowsing.googleapis.com).
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          # Network geolocation is backed by Google's location API.
          "geo.provider.network.url" = "";
          "network.trr.mode" = 5;
          # Fingerprinting protection without resistFingerprinting's breakage
          # (forced UTC, letterboxing).
          "privacy.fingerprintingProtection" = true;
          # Don't leak the LAN IP over WebRTC behind Mullvad.
          "media.peerconnection.ice.default_address_only" = true;

          # Enable extensions installed into the profile without a prompt.
          "extensions.autoDisableScopes" = 0;
          # userChrome above + compact UI density.
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;

          "browser.quitShortcut.disabled" = true;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.aboutConfig.showWarning" = false;
        };
      };
    };
  };
}
