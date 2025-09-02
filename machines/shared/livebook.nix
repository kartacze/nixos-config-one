{ pkgs, ... }:

{
  services.livebook = {
    enableUserService = true;
    package = pkgs.livebook;
    extraPackages = with pkgs; [ gcc gnumake ];
    environmentFile = "/var/lib/livebook.env";
  };
}
