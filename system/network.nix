{ hostname, ... }:
{
  networking.networkmanager.enable = true;
  networking.hostName = "${hostname}";
  # Enable wireless support via wpa_supplicant.
  # networking.wireless.enable = true;
}
