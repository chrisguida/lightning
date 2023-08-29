{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      py3 = pkgs.python3.withPackages (p: [p.mako]);
    in {
      packages.default = with pkgs;
        stdenv.mkDerivation rec {
          pname = "clightning";
          version = "23.05";

          src = fetchFromGitHub {
            owner = "niftynei";
            repo = "lightning";
            rev = "44c5b523683160e8c20bda200c6a5a59ea40bc5e";
            sha256 = "sha256-tWxnuVHhXl7JWwMxQ46b+Jd7PeoMVr7pnWXv5Of5AeI=";
            #sha256 = "";
            fetchSubmodules = true;
          };

          # when building on darwin we need dawin.cctools to provide the correct libtool
          # as libwally-core detects the host as darwin and tries to add the -static
          # option to libtool, also we have to add the modified gsed package.
          nativeBuildInputs = with pkgs;
            [autoconf autogen automake gettext libtool lowdown protobuf py3 unzip which]
            ++ lib.optionals stdenv.isDarwin [darwin.cctools darwin.autoSignDarwinBinariesHook];

          buildInputs = [gmp libsodium sqlite zlib];

          # this causes some python trouble on a darwin host so we skip this step.
          # also we have to tell libwally-core to use sed instead of gsed.
          postPatch =
            if !stdenv.isDarwin
            then ''
              patchShebangs \
                tools/generate-wire.py \
                tools/update-mocks.sh \
                tools/mockup.sh \
                devtools/sql-rewrite.py
            ''
            else ''
              substituteInPlace external/libwally-core/tools/autogen.sh --replace gsed sed && \
              substituteInPlace external/libwally-core/configure.ac --replace gsed sed
            '';

          configureFlags = ["--disable-developer" "--disable-valgrind"];

          makeFlags = ["VERSION=v${version}"];

          enableParallelBuilding = true;

          meta = with pkgs.lib; {
            description = "A Bitcoin Lightning Network implementation in C";
            longDescription = ''
              c-lightning is a standard compliant implementation of the Lightning
              Network protocol. The Lightning Network is a scalability solution for
              Bitcoin, enabling secure and instant transfer of funds between any two
              parties for any amount.
            '';
            homepage = "https://github.com/ElementsProject/lightning";
            maintainers = with maintainers; [jb55 prusnak];
            license = licenses.mit;
            platforms = platforms.linux ++ platforms.darwin;
          };
        };
    });
}
