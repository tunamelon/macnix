{ pkgs, lib, config, inputs, ... }:

{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  
  programs.zsh.enable = true;
  system.defaults.dock.autohide = true;
  
  users.users.tuna = {
    name = "tuna";
    home = "/Users/tuna";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.tuna = { pkgs, ... }: {
    
    # User home directory
    #home.username = "tuna";
    #home.homeDirectory = lib.mkForce "/Users/tuna/";
    
    # Home-manager pkgs version
    home.stateVersion = "22.11";

    # Shell session variables
    home.sessionVariables = {
      PATH = "/Users/tuna/.nix-profile/bin:/etc/profiles/per-user/tuna/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/homebrew/bin";
    };

     #############
    # Add packages
    home.packages = with pkgs; [
      htop
    ];
    
     #############
    # Add programs  

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark_v2";
        vim_keys = true;
      };
    };

    programs.home-manager.enable = true;

    programs.kitty.enable = true;

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

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
          #plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
      shellAliases  = {
        # May need to re-run after OS updates
        source-nix="echo 'if test -e /etc/static/zshrc; then . /etc/static/zshrc; fi' | sudo tee -a /etc/zshrc";
        # Rebuild home-manager hosts/host/default.nix
        nix-switch="darwin-rebuild switch --flake ~/macnix";
        # Update flake.lock
        nix-flake-update="nix flake update";
        # Update flake after updating 23.11 version in flake and home-manager manually
        nix-updated="nix-flake-update && nix-switch";
        # Edit default
        nix-default="nano ~/macnix/hosts/macnix/default.nix";
        # Edit and switch
        nix-default-switch="nix-default && nix-switch";
      };
    };
  
  };

  # Manage homebrew (GUI apps etc)
  
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      # Add below to auto-install, but requires manual uninstalling with: brew uninstall --cask iina
      # Can verify uninstalled with: brew list --cask
      # "iina"
    ];
  };

}
