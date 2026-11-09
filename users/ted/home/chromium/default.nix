{
  config,
  lib,
  pkgs,
  ...
}:

# ungoogled-chromium as the Google browser. Policies (blocking, privacy,
# uBlock Origin Lite config) are system-managed in machines/shared/chromium.nix.
#
# ungoogled-chromium never talks to the Chrome Web Store (no install, no
# update checks), so extensions are pinned .crx files installed through
# "External Extensions". They are store builds, so their IDs match the
# policy entries. To bump one, get the new blob URL + hash with:
#
#   id=<extension id>
#   curl -sL -o ext.crx -w '%{url_effective}\n' \
#     "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx3&prodversion=157.0&x=id%3D$id%26installsource%3Dondemand%26uc"
#   nix hash file --sri ext.crx
#
# and update url/hash/version below (version = manifest.json "version").
let
  cfg = config.veritas.configs.chromium;

  mkExtension =
    {
      id,
      version,
      url,
      hash,
    }:
    {
      inherit id version;
      crxPath = pkgs.fetchurl {
        name = "${id}-${version}.crx";
        inherit url hash;
      };
    };
in
{
  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;

      # ungoogled-only switches (docs/flags.md upstream). Wayland comes from
      # NIXOS_OZONE_WL.
      commandLineArgs = [
        # Anti-fingerprinting noise (canvas, text metrics, client rects).
        "--fingerprinting-canvas-image-data-noise"
        "--fingerprinting-canvas-measuretext-noise"
        "--fingerprinting-client-rects-noise"
        # No <a ping> hyperlink auditing.
        "--no-pings"
        # Show IDN domains as punycode (homograph phishing).
        "--force-punycode-hostnames"
        # Sites can't silently add themselves as search engines.
        "--disable-search-engine-collection"
        "--no-default-browser-check"
        "--popups-to-tabs"
        # Same as Firefox: closing the last tab keeps the window.
        "--close-window-with-last-tab=never"
      ];

      extensions = map mkExtension [
        # Vimium
        {
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
          version = "2.4.2";
          url = "https://clients2.googleusercontent.com/crx/blobs/ARGaeZJJ6DTUe1QgHl6AOB0PprpqTC6ittNkddGyyOLJDYrURlN0jY0oEQHcxTZB2VkR4GT30P6qw0uirl57NO0bKPyFf2lOXjUCEIJN5LqNdUnjrCJXwRrCZ6WYTS_krUsAxlKa5RZ4uUSsuuNE-5GuWM5H4XdNpJAT/DBEPGGEOGBAIBHGNHHNDOJPEPIIHCMEB_2_4_2_0.crx";
          hash = "sha256-MZjCaqcZvkYt6lhQUPvtm4uAYo1X6oihE7q/UzTFUXw=";
        }
        # uBlock Origin Lite
        {
          id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
          version = "2026.1103.1743";
          url = "https://clients2.googleusercontent.com/crx/blobs/ARGaeZJQkITxzrVcTdVAijadlhafrQbvDuyuajde9HxAapvNBOGwVPrZ31mtd2KytDg-6tZAHHhcpjxOB3CepxnJbhcEqRZfcUmnHoMCIzNnYVpWOfAllUq6E5GdBNPYIkjGAMZSmuVu6YW24Rnd3CmLq6N0xoS2nAkI4A/DDKJIAHEJLHFCAFBDDMGIAHCPHECMPFH_2026_1103_1743_0.crx";
          hash = "sha256-spD3fN6TARbPbRXIlCcJcgStSolYKBoJBhnfSc92Dko=";
        }
      ];
    };
  };
}
