{
  services.ollama = {
    acceleration = "rocm";
    enable = true;
    loadModels = [ "devstral" ];
  };
}
