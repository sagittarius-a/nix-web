
{
  description = "CTF Web environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg:
              nixpkgs.lib.getName pkg == "burpsuite";
          };

          packages = import ./packages.nix { inherit pkgs; };
        in
        {
          default = pkgs.mkShell {
            name = "nix-web";
            packages = packages.common;
          };

          full = pkgs.mkShell {
            name = "nix-web-full";
            packages = packages.common ++ packages.full;

            SECLISTS = "${pkgs.seclists}/share/seclists";
            PAYLOADS = "${pkgs.payloadsallthethings}/share/payloadsallthethings";
          };
        }
      );

      homeModules.default = { pkgs, ... }:
        let
          packages = import ./packages.nix { inherit pkgs; };
        in
        {
          home.packages = packages.common;
        };
    };
}
