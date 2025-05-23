{ ... }: {
  programs.steam = {
    dedicatedServer.openFirewall = true;
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };
}
