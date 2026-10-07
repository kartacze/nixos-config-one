{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.printing3D;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Slicers
      orca-slicer
      # CAD / modeling
      # freecad
      # openscad
      # blender
    ];
  };
}
