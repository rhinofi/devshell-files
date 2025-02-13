## Builtin Modules

Builtin Modules are modules defined with this same package.

They are already included when we use this package.

- `files.alias`, create bash script alias
- `files.cmds`, install packages from [nix repository](https://search.nixos.org/)
- `files.docs`, convert our modules file into markdown using [nmd](https://gitlab.com/rycee/nmd)
- `files.git`, configure git with file creation
- `files.gitignore`, copy .gitignore from [templates](https://github.com/github/gitignore/)
- `files.hcl`, create HCL files with nix syntax
- `files.json`, create JSON files with nix syntax
- `files.mdbook`, convert your markdown files to HTML using [mdbook](https://rust-lang.github.io/mdBook/)
- `files.nim`, similar to `files.alias`, but compiles [Nim](https://github.com/nim-lang/Nim/wiki#getting-started) code
- `files.nus`, similar to `files.alias`, but runs in [Nushell](https://www.nushell.sh/)
- `files.services`, process supervisor for development services using [s6](http://skarnet.org/software/s6)
- `files.rc` , WIP, process supervisor for development services using [s6-rc](http://skarnet.org/software/s6-rc)
- `files.spdx`, copy LICENSE from [templates](https://github.com/spdx/license-list-data/tree/master/text)
- `files.text`, create free text files with nix syntax
- `files.toml`, create TOML files with nix syntax
- `files.yaml`, create YAML files with nix syntax


Our [documentation](https://cruel-intentions.github.io/devshell-files/) is generated by `files.text`, `files.docs` and `files.mdbook`

