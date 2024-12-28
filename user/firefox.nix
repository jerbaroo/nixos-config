{ username, ... }:
let
  lock-false = { Value = false; Status = "locked"; };
  lock-true  = { Value = true;  Status = "locked"; };
in {
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = with builtins;
        let extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
        in listToAttrs [
          (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
          (extension "flagfox" "{1018e4d6-728f-4b20-ad56-37578a4de76b}")
          (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
        ];
    };
    profiles.${username} = {
      settings = {
        "browser.contentblocking.cryptomining.preferences.ui.enabled"   = lock-true;
        "browser.contentblocking.fingerprinting.preferences.ui.enabled" = lock-true;
        "browser.newtabpage.activity-stream.feeds.section.highlights"   = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories"   = lock-false;
        "browser.newtabpage.pinned" = [
          { title = "Hoogle"; url = "https://hoogle.haskell.org"; }
        ];
        "browser.startup.homepage"  = "https://search.nixos.org/packages";
        "extensions.pocket.enabled"                                     = lock-false;
        "privacy.donottrackheader.enabled"                              = lock-true;
        "privacy.trackingprotection.enabled"                            = lock-true;
        "privacy.trackingprotection.cryptomining.enabled"               = lock-true;
        "privacy.trackingprotection.socialtracking.enabled"             = lock-true;
        "signon.rememberSignons"                                        = lock-false;
      };
    };
  };
}
