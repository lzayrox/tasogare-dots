{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/hyprland?ref=v0.36.0";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    trcc-linux.url = "github:Lexonight1/thermalright-trcc-linux";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, trcc-linux, home-manager, nix-flatpak, nixvim, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	home-manager.nixosModules.home-manager
	trcc-linux.nixosModules.default
	nixvim.nixosModules.nixvim
      ];
    };
  };
}
