{
  config,
  lib,
  pkgs,
  ...
}: let
  userCfg = config.module.rendering;
  cfg =
    userCfg
    // {
      opengl = userCfg.opengl || userCfg.nvidia;
    };
in {
  options.module.rendering = {
    renderer = lib.mkOption {
      default = "gnome";
      defaultText = "gnome";
      description = "Which renderer to use for user interface.";
      type = lib.types.nullOr (lib.types.enum ["gnome"]);
    };
    nvidia = lib.mkOption {
      default = false;
      defaultText = "false";
      description = "Whether to enable NVIDIA support.";
      type = lib.types.bool;
    };
    opengl = lib.mkOption {
      default = false;
      defaultText = "false";
      description = "Whether to enable OpenGL. Automatically enabled if using NVIDIA.";
      type = lib.types.bool;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.renderer == "gnome") {
      programs.dconf.enable = true;

      services = {
        xserver = {
          enable = true;
          displayManager.gdm = {
            enable = true;
            wayland = true;
          };
          desktopManager.gnome.enable = true;
        };
      };

      environment.systemPackages = [
        pkgs.gnome.adwaita-icon-theme
        pkgs.gnomeExtensions.forge
        pkgs.gnomeExtensions.vitals
      ];
    })
    (lib.mkIf cfg.nvidia {
      hardware = {
        nvidia = {
          open = false;
          modesetting.enable = true;
          nvidiaSettings = true;
        };
      };
      services.xserver.videoDrivers = ["nvidia"];
    })
    (lib.mkIf (cfg.nvidia || cfg.opengl) {
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        setLdLibraryPath = true;
      };
    })
  ];
}
