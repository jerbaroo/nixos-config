{
  # Required to avoid '[bat warning]: Unknown theme' when using delta.
  programs.bat.enable = true;
  programs.git = {
    delta.enable = true;
    enable = true;
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
    userName = "jerbaroo";
    userEmail = "jerbaroo.work@pm.me";
  };
}
