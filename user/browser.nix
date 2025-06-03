{ username, ... }:
{
  programs.brave.enable = true;
  programs.librewolf = {
    enable = true;
    policies = {
      ExtensionSettings =
        with builtins;
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        listToAttrs [
          (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
          (extension "flagfox" "{1018e4d6-728f-4b20-ad56-37578a4de76b}")
          (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
          # (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
        ];
    };
    profiles.${username} = {
      settings = {
        "browser.contentblocking.cryptomining.preferences.ui.enabled" = true;
        "browser.contentblocking.fingerprinting.preferences.ui.enabled" = true;
        "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.section.wallpaperfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.weatherfeed" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.startup.homepage" = "https://search.nixos.org/packages";
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "signon.rememberSignons" = false;
      };
    };
  };
}
