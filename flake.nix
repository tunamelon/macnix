{
  description = "Tuna's Nix Darwin Flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
      home-manager.url = "github:nix-community/home-manager/release-23.11";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, home-manager, darwin }: {
    darwinConfigurations."macnix" = darwin.lib.darwinSystem {
    # you can have multiple darwinConfigurations per flake, one per hostname

      system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/macnix/default.nix
      ];
    };
  };

}
