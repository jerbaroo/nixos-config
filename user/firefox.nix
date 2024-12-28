{ inputs, username, ... }: {
  programs.firefox = {
    enable = true;
    profiles.${username} = {
      # extensions = with inputs.nur.repos.rycee.firefox-addons; [
      #   decentraleyes
      #   flagfox
      #   privacy-badger
      #   ublock-origin
      #   vimium
      # ];
      settings = {
        "browser.contentblocking.cryptomining.preferences.ui.enabled"   = true;
        "browser.contentblocking.fingerprinting.preferences.ui.enabled" = true;
        "browser.newtabpage.activity-stream.feeds.section.topstories"   = false;
        "extensions.pocket.enabled"                                     = false;
        "privacy.donottrackheader.enabled"                              = true;
        "privacy.trackingprotection.enabled"                            = true;
        "privacy.trackingprotection.cryptomining.enabled"               = true;
        "privacy.trackingprotection.socialtracking.enabled"             = true;
        "signon.rememberSignons"                                        = false;
      };
    };
  };
}
