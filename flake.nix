{
  description = "cffnpwr's nixos configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    personal = { url = "git+file:/home/cffnpwr/git/nix-channel"; };
  };

  outputs = { self, nixpkgs, home-manager, personal, ... } @ attrs: {
    nixosConfigurations.cpwr-tpxy = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = attrs // { personal = (builtins.getAttr system personal.packages); };
          home-manager.users.cffnpwr = import ./home.nix;
        }
      ];
    };
  };
}
