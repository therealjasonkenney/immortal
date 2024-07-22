{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, utils,...}:
    utils.lib.eachDefaultSystem (system:
      let 
        inherit (nixpkgs.lib) optional optionals;

        pkgs = nixpkgs.legacyPackages.${system};

        configureFlags = [ "--without-javac " ]
          ++ ["--with-ssl=${nixpkgs.lib.getOutput "out" pkgs.openssl} "]
          ++ ["--with-ssl-incl=${nixpkgs.lib.getDev pkgs.openssl} "]
          ++ optional pkgs.stdenv.isDarwin "--enable-darwin-64bit "
          ++ optional (pkgs.stdenv.isDarwin && pkgs.stdenv.isx86_64) "--disable-jit"
        ;

        asdf = pkgs.asdf-vm.outPath + "/bin/asdf";

        erl_plugin = "https://github.com/asdf-vm/asdf-erlang.git";
        elx_plugin = "https://github.com/asdf-vm/asdf-elixir.git";

        linuxDeps = optionals pkgs.stdenv.isLinux (with pkgs;
          [
            inotify-tools
          ]);

        macDeps = optionals pkgs.stdenv.isDarwin (
          with pkgs.darwin.apple_sdk.frameworks; [
            AGL
            Carbon
            Cocoa
            WebKit
          ]);

      in
      {

        devShells.default = pkgs.mkShell {
          # Elixir prefers ASDF so we will put the dependencies here.
          buildInputs = with pkgs; [
            asdf-vm
            autoconf
            git
            fop
            libxslt
            ncurses5
            openssl
            wxGTK32
          ] ++ linuxDeps ++ macDeps;

          env = {
            KERL_CONFIGURE_OPTIONS = pkgs.lib.concatStrings(configureFlags);
            PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
          };

          nativeBuildInputs = [ pkgs.pkg-config ];

          shellHook = "
            echo \$KERL_CONFIGURE_OPTIONS
            test `${asdf} plugin list | grep erlang` = erlang || ${asdf} plugin add erlang ${erl_plugin}

            test `${asdf} plugin list | grep elixir` = elixir || ${asdf} plugin add elixir ${elx_plugin}

            ${asdf} install

            source ${pkgs.asdf-vm.outPath}/share/asdf-vm/asdf.sh
          ";

        };
      }
    );
}
