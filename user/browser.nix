{ pkgs, ... }:
{
  # catppuccin.firefox.force = true;
  # programs.firefox = {
  #   enable = true;
  # };
  programs.librewolf = {
    enable = true;
    profiles.default = {
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          darkreader
          decentraleyes
          leechblock-ng
          privacy-badger
          ublock-origin
          vimium
        ];
      };
      isDefault = true;
      search = {
        force = true;
        default = "google";
        engines.google = {
          name = "Google";
          urls = [
            {
              template = "https://google.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };
      settings = {
        "browser.contentblocking.cryptomining.preferences.ui.enabled" = true;
        "browser.contentblocking.fingerprinting.preferences.ui.enabled" = true;
        "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.section.wallpaperfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.weatherfeed" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.startup.homepage" = "https://github.com/";
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
        "sidebar.verticalTabs" = true;
        "signon.rememberSignons" = false;
      };
    };
  };
}
