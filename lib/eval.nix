pkgs:
{
  # Single module for convenience
  module ? {},
  modules ? [],
  lib ? pkgs.lib,
  extraSpecialArgs ? {},
}:
let
  pkgsModule = {
    config._module.args.pkgs = pkgs.lib.mkDefault pkgs;
  };
  evalled = lib.evalModules {
    modules = [ pkgsModule module ] ++ modules;
    specialArgs = {
      dsfModulesPath = builtins.toString ../modules;
    } // extraSpecialArgs;
  };
in
{
  inherit (evalled) config options;
}
