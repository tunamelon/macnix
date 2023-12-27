{ pkgs, ... }:

{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  
  programs.zsh.enable = true;
  system.defaults.dock.autohide = true;
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.tuna = { pkgs, ... }: {
    
    # User home directory
    home.homeDirectory = lib.mkForce "/Users/tuna/";
    
    # Home-manager pkgs version
    home.stateVersion = "22.11";

    # Add programs  
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
      historyLimit = 10000;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        gruvbox
      ];
      extraConfig = ''
        new-session -s main
        bind-key -n C-a send-prefix
      '';
    };
  
  };

  # Manage homebrew (GUI apps etc)
  homebrew = {
    enable = true;
    autoUpdate = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "iina"
    ];
  };

}
