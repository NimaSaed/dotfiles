{
 description = "Mac nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      #pythonEnv = pkgs.python313.withPackages (ps: with ps; [
      #  ps.pip
      #  ps.mkdocs-material
      #  ps.mkdocs-material-extensions
      #]);

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.git
          pkgs.jq
          pkgs.yq
          pkgs.bat
          pkgs.fzf
          pkgs.gnused
          pkgs.vim
          pkgs.aerospace
          pkgs.brave
          pkgs.logseq
          pkgs.monitorcontrol
          pkgs.openscad
          pkgs.podman
          pkgs.openfga
          pkgs.openfga-cli
          pkgs.mkalias
          pkgs.mkdocs
          pkgs.utm
          pkgs.pandoc
          #pkgs.python313
          #pythonEnv
          pkgs.qemu
          pkgs.semgrep
          pkgs.zoom-us
        ];


      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      homebrew = {
        enable = true;
        brews = [
          "mas"
          "coreutils"
        ];
        casks = [
          "1password"
          "1password-cli"
          "alacritty"
          "basictex"
          "burp-suite-professional"
          "grammarly-desktop"
          "font-jetbrains-mono"
          "bambu-studio"
          "qflipper"
          "microsoft-teams"
          "lm-studio"
          "slack"
        ];
        masApps = {
          "ikea desk remote" = 1509037746;
          "1password for safari" = 1569813296;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.defaults = {
        dock.autohide = true;
        dock.orientation = "left";
        dock.autohide-delay = 1000.0;
        dock.show-recents = false;
        dock.tilesize = 24;
        dock.expose-group-apps = true;
        dock.persistent-apps = [
        ];
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";

        loginwindow.GuestEnabled = false;
      };

      security.pam.services.sudo_local.touchIdAuth = true;
      security.pam.services.sudo_local.reattach = true;
      security.pam.services.sudo_local.watchIdAuth = true;


      #system.autoupgrade.enable = true;
      #system.autoUpgrade.enable = true;
      #system.autoupgrade.dates = "weekly";

      # Nix daemon and garbage collection settings
      # nix-daemon is managed automatically by nix-darwin when nix.enable is true

      # Automatic garbage collection
      nix.gc = {
        automatic = true;
        interval = { Weekday = 0; Hour = 2; Minute = 0; }; # Sunday at 2 AM
        options = "--delete-older-than 30d";
      };

      # Automatic store optimization
      nix.optimise.automatic = true;


      # Necessary for using flakes on this system.
      nix.settings = {
        experimental-features = "nix-command flakes";
        # Improve build performance
        max-jobs = "auto";
        cores = 0; # Use all available cores
        # Prevent disk space issues
        max-free = 1073741824; # 1GB
        min-free = 536870912;  # 512MB
        # Build users (should match your nixbld group size)
        build-users-group = "nixbld";
      };

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      #
      programs.bash = {
        enable = true;
        # Other bash settings...
      };

      programs.tmux = {
        enable = true;

        extraConfig = ''
          #set -g default-command ${pkgs.bash}/bin/bash
          set-window-option -g mode-keys vi
          set-option -g default-shell ${pkgs.bash}/bin/bash
          #set-option -g default-shell "/usr/bin/env bash"

          # Setup 'v' to begin selection as in Vim
          #bind-key -T copy-mode-vi 'v' send -X begin-selection
          #bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

          # Setup 'v' to begin selection as in Vim
          bind-key -T copy-mode-vi 'v' send -X begin-selection
          bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

          # Increase buffer size
          set-option -g history-limit 10000000

          # To change prefix key

          # To change prefix key to ctrl+g
          #unbind-key C-b
          #set-option -g prefix C-f
          #bind C-f send-prefix

          # To change prefix key to alt+a
          #unbind-key C-b
          #set-option -g prefix C-a
          #bind-key C-a send-prefix
          #
          # To fix vim syntax color in tmux
          set -g default-terminal screen-256color
          #set-option -sa terminal-overrides ", xterm*: Tc"

          # 0 is too far ;)
          set -g base-index 1

          #Panes
          set -g pane-border-style fg=colour15
          #set -g pane-border-style bg=""
          set -g pane-active-border-style fg=colour1
          #set -g pane-active-border-style bg=""

          #statusbar
          set-option -g status-style bg=default
          set-option -g status-style fg=default
          #set -g status-bg default
          #set -g status-fg default
          set -g status-left ""
          set -g status-right ""
          set -g status-interval 0
          set-option -g status-position bottom

          #reload tmux config
          bind r source-file ~/.tmux.conf

          #clear history
          bind-key L clear-history

          # Move pane to other windows
          bind m command-prompt "move-pane -t ':%%'"

          # Move window
          bind M command-prompt "move-window -t ':%%'"

          # Open new pane in current path
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"

          # Use vim-like keys for splits and windows
          bind-key v split-window -h -c "#{pane_current_path}"
          bind-key s split-window -v -c "#{pane_current_path}"

          # Moving between pane using vim keys
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

          # Resizing pane using vim keys
          unbind-key C-h
          unbind-key C-j
          unbind-key C-k
          unbind-key C-l
          bind-key C-h resize-pane -L 5
          bind-key C-j resize-pane -D 5
          bind-key C-k resize-pane -U 5
          bind-key C-l resize-pane -R 5

          # Selecting pane
          set -g pane-base-index 1
          bind-key C-q select-pane -t 1
          bind-key C-w select-pane -t 2
          bind-key C-e select-pane -t 3
          bind-key C-r select-pane -t 4
          # I am not using more than 4 panes

          #set-window-option -g visual-bell on
          #set-window-option -g bell-action any
        '';

        # Other tmux settings…
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.primaryUser = "nima";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        mac-app-util.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # apple silicon only
            enableRosetta = true;
            # User owning the homebrew prefix
            user = "nima";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
