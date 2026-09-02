{
  description = "fakehttp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          fakehttp = pkgs.stdenv.mkDerivation {
            pname = "fakehttp";
            version = "unstable-filteripport";

            src = ./.;

            buildInputs = with pkgs; [
              libnetfilter_queue
              libnfnetlink
              libmnl
            ];

            installPhase = ''
              runHook preInstall

              make install PREFIX=$out

              runHook postInstall
            '';
          };
        in
        {
          inherit fakehttp;
          default = fakehttp;
        }
      );
    };
}
