{ options, pkgs, config, lib, ... }:
let
  files     = config.file;
  fileType  = (import ./file-type.nix { inherit pkgs config lib; }).fileType;
  getMode   = file: if file.executable != null && file.executable then "755" else "644";
  git-add   = file:
    if file.git-add == null
      then ""
      else if file.git-add
        then "git add $target"
        else "";
  toName    = name: "dsf${lib.strings.sanitizeDerivationName name}";

  # Execute this script to update the project's files
  copy-file = name: file: pkgs.writeShellScriptBin "${toName name}" ''
    target="$PRJ_ROOT${file.target}"
    ${pkgs.coreutils}/bin/install -m ${getMode file} -D ${file.source} $target
    ${git-add file}
  '';
  cmd.command     = builtins.concatStringsSep "\n" startups;
  cmd.help        = "Recreate files";
  cmd.name        = "devshell-files";
  opt.default     = {};
  opt.description = "Attribute set of files to create into the project root.";
  opt.type        = fileType "<envar>PRJ_ROOT</envar>";
  startup.devshell-files.text = "$DEVSHELL_DIR/bin/devshell-files";
  startups  = map (name: "source $DEVSHELL_DIR/bin/${toName name}") (builtins.attrNames files);
  packages = lib.mapAttrsToList copy-file files;
in {
  options.file    = lib.mkOption opt;
  # Could this still be useful? Since even with this flag we'd need to do a check like below:
  #   builtins.hasAttr "devshell" options
  # in case devshell module have not been imported.
  # Or can we assume that if one imports devshell and devshell-files then they
  # want the integration enabled.
  # options.files.devshellEnable = lib.mkOption {
  #   type = lib.types.bool;
  #   default = true;
  #   description = "Enable devshell integration.";
  # };
  options.files.create-all = lib.mkOption {
    type = lib.types.package;
    description = "Package cotaining a script used to create all files.";
    default = pkgs.writers.writeBashBin "devshell-files-create-all" ''
      set -eu
      export PRJ_ROOT=''${PRJ_ROOT:-$(${pkgs.coreutils}/bin/pwd)}
      ${lib.concatStringsSep "\n" (map lib.getExe packages)}
    '';
  };
  # https://discourse.nixos.org/t/how-to-detect-whether-an-option-exists/21172
  config = lib.optionalAttrs (builtins.hasAttr "devshell" options)
    {
      commands = lib.mkIf (builtins.length startups > 0) [ cmd ];
      devshell = {
        packages = packages;
        startup  = lib.mkIf (builtins.length startups > 0) startup;
      };
    }
  ;
}
