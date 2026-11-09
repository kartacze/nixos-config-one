{
  config,
  lib,
  ...
}:

# ungoogled-chromium as the Google browser (Google search / accounts work
# here, unlike in Firefox). The browser and its extensions come from
# home-manager (users/ted/home/chromium); this module only writes managed
# policy to /etc/chromium/policies/managed, so none of it can be changed
# from the UI.
#
# Blocking is done by uBlock Origin Lite: Chromium dropped Manifest V2, so the
# full uBlock Origin no longer runs. Google's own trackers (Analytics,
# DoubleClick, Tag Manager, ...) are still blocked by EasyPrivacy/uBO filters;
# only first-party Google services are left alone.
#
# Already compiled out of ungoogled-chromium, so not set here: Safe
# Browsing, metrics/crash reporting, browser sign-in and sync.
let
  vimium = "dbepggeogbaibhgnhhndojpepiihcmeb";
  ublockLite = "ddkjiahejlhfcafbddmgiahcphecmpfh";
in
{
  config = lib.mkIf config.veritas.configs.chromium.enable {
    programs.chromium = {
      enable = true;

      extraOpts = {
        # --- Extensions ----------------------------------------------------
        # Only the two pinned extensions from home-manager may run.
        ExtensionInstallBlocklist = [ "*" ];
        ExtensionInstallAllowlist = [
          vimium
          ublockLite
        ];
        ExtensionSettings = lib.genAttrs [ vimium ublockLite ] (_: {
          toolbar_pin = "force_pinned";
        });

        # uBlock Origin Lite managed storage (schema: uBOL-home
        # chromium/managed_storage.json). Defaults (uBO filters, EasyList,
        # EasyPrivacy, Peter Lowe, badware, URLhaus) stay on; the rest is added.
        "3rdparty".extensions.${ublockLite} = {
          # "complete" = network + cosmetic + scriptlet filtering everywhere.
          defaultFiltering = "complete";
          strictBlockMode = true;
          popupBlockMode = true;
          disableFirstRunPage = true;
          showBlockedCount = true;
          rulesets = [
            "+adguard-spyware-url" # strip tracking params (utm_, gclid, fbclid, ...)
            "+block-lan" # public sites can't probe the LAN / localhost
            "+annoyances-cookies"
            "+annoyances-overlays"
            "+annoyances-social"
            "+annoyances-widgets"
            "+annoyances-notifications"
            "+annoyances-others"
            "+annoyances-ai"
            "+pol-0" # Polish filters
            "+pol-3" # CERT.PL warning list (phishing/scam domains)
          ];
        };

        # --- Google search ---------------------------------------------------
        # Pinned as default with suggestions; logging into Google websites
        # works normally.
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = "Google";
        DefaultSearchProviderKeyword = "google.com";
        DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
        DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
        SearchSuggestEnabled = true;

        # --- Tracking / cookies ---------------------------------------------
        BlockThirdPartyCookies = true;
        PrivacySandboxPromptEnabled = false;
        PrivacySandboxAdTopicsEnabled = false;
        PrivacySandboxSiteEnabledAdsEnabled = false;
        PrivacySandboxAdMeasurementEnabled = false;
        RelatedWebsiteSetsEnabled = false;
        # Don't leak the LAN IP over WebRTC behind Mullvad.
        WebRtcIPHandling = "default_public_interface_only";
        HttpsOnlyMode = "force_enabled";
        DefaultNotificationsSetting = 2; # block
        DefaultSensorsSetting = 2; # block
        DefaultSerialGuardSetting = 2;
        DefaultWebBluetoothGuardSetting = 2;
        DefaultWebHidGuardSetting = 2;
        DefaultWebUsbGuardSetting = 2;

        # --- Phoning home ---------------------------------------------------
        UrlKeyedAnonymizedDataCollectionEnabled = false;
        SpellCheckServiceEnabled = false;
        AlternateErrorPagesEnabled = false;
        # No prefetch/preconnect to links you never clicked.
        NetworkPredictionOptions = 2;
        ShoppingListEnabled = false;
        PromotionalTabsEnabled = false;
        PaymentMethodQueryEnabled = false;
        BackgroundModeEnabled = false;
        DefaultBrowserSettingEnabled = false;
        # Keep resolving through Mullvad's DNS (same as Firefox).
        DnsOverHttpsMode = "off";

        # --- Passwords / autofill: passage handles that ----------------------
        PasswordManagerEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
      };
    };
  };
}
