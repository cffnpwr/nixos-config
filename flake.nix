{
  description = "cffnpwr's nixos configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    personal = { url = "github:cffnpwr/nixpkgs"; };
  };

  outputs = inputs@{ nixpkgs, home-manager, personal, ... }: {
    nixosConfigurations = {
      cpwr-tpxy = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cffnpwr = import ./home.nix;

            home-manager.extraSpecialArgs = inputs // {
              personal = (builtins.getAttr system personal.packages);
            };
          }
        ];
      };
    };
  };
}
