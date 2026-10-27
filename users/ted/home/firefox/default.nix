{
  config,
  lib,
  ...
}:

# Firefox as the Google-free main browser. Google services live only in
# Brave; here every Google domain is blocked (first- and third-party) by
# uBlock Origin, and Firefox's own Google lookups (Safe Browsing,
# geolocation) are turned off.
let
  cfg = config.veritas.configs.firefox;

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

        ExtensionSettings."uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          private_browsing = true;
        };

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
          engines.google.metaData.hidden = true;
        };

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
        };
      };
    };
  };
}
