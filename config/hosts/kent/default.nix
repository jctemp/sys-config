_:
{
  hostSpec = {
    device = "/dev/sda";
    loader = "grub";
    isMinimal = false;
    modules = {
      # server required modules
      virtualisation.enable = true;
      gnupg.enable = true;
      ssh.enable = true;
      sshd.enable = true;
      yubikey.enable = true;
      # non-server modules
      printing.enable = false;
      audio.enable = false;
      bluetooth.enable = false;
      graphics.enable = false;
      nvidia.enable = false;
    };
  };

  services.cloud-init.network.enable = true;
}
