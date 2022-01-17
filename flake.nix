{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      zmk-python = pkgs.python3.withPackages (ps: with ps; [
        setuptools
        pip
        west
        # BASE: required to build or create images with zephyr
        #
        # While technically west isn't required it's considered in base since it's
        # part of the recommended workflow

        # used by various build scripts
        pyelftools

        # used by dts generation to parse binding YAMLs, also used by
        # twister to parse YAMLs, by west, zephyr_module,...
        pyyaml

        # YAML validation. Used by zephyr_module.
        pykwalify

        # used by west_commands
        canopen
        packaging
        progress
        psutil

        # for ram/rom reports
        anytree

        # intelhex used by mergehex.py
        intelhex

        west
      ]);
      gnuarmemb = pkgs.pkgsCross.arm-embedded.buildPackages.gcc;
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [ 
          gcc
          ninja
          dfu-util
          autoconf
          bzip2
          ccache
          libtool
          cmake
          xz
          dtc
          zmk-python
          gnuarmemb
        ];
        ZEPHYR_TOOLCHAIN_VARIANT = "gnuarmemb";
        GNUARMEMB_TOOLCHAIN_PATH = pkgs.gcc-arm-embedded;
        shellHook = ''
          git submodule update --init
          cd zmk
          west init -l /app/
          west update
          west zephyr-export
          cd ..
        '';
      };
    });
}
