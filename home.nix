{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "barak";
  home.homeDirectory = "/home/barak";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    vim
    wget
    curl
    google-chrome
    rustup
    jetbrains.rust-rover
    slack
    zoom-us
    pinentry-qt
    gnupg
    clang
    vlc
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.he
    
  ];


  # Enable GPG agent
  programs.gpg = {
    enable = true;
  };

  
  # Configure GPG agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-qt;
 };


  
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName  = "barakb";
    userEmail = "barak.bar@gmail.com";
    signing = {
      key = "2C4E9D8A942B012A";
      signByDefault = true;
    };
        extraConfig = {
      core = { whitespace = "trailing-space,space-before-tab"; };
      color = { ui = "auto"; };
      merge = { ff = "only"; };
      rerere = { enabled = "true"; };
      rebase = { autoSquash = "true"; };
      github = { user = "barakb"; };
    };

    ignores = [
      "*~"
      ".idea"
      ".ipr"
      "*.swp"
      ".ccls-cache"
      "shell.nix"
    ];
  };


  programs.ssh = {
    enable = true;
    matchBlocks."github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/github_ed25519";
    };
  };


  
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
    ];
    extraConfig = ''
        (set-face-attribute 'default nil :height 160)
    '';
  };


  programs.vscode = {
    enable = true;  # Enable VS Code
    enableUpdateCheck = false;  # Disable update check if desired
    enableExtensionUpdateCheck = false;  # Disable extension update check if desired
    mutableExtensionsDir = false;  # Prevent writing to the extensions directory

    # List of extensions to install for C and Rust development
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools  # C/C++ IntelliSense and debugging
#      rust-lang.rust  # Rust language support
      rust-lang.rust-analyzer  # Rust Analyzer for enhanced development
#      ms-vscode.rust-test  # Rust test runner
#      matklad.rust-analyzer  # Rust Analyzer for improved performance
      ms-vscode-remote.remote-ssh  # SSH support for remote development
      mhutchie.git-graph  # Visualize Git repositories
      pkief.material-icon-theme  # Icon theme for better file visibility
      bierner.markdown-emoji  # Emoji support in Markdown files
      # Add more extensions as needed
    ];

    # User settings for VS Code
    userSettings = {
      "editor.fontSize" = 16;  # Adjust font size for better readability
      "editor.fontFamily" = "'Jetbrains Mono', 'monospace'";  # Use a programming-friendly font
      "editor.formatOnSave" = true;  # Automatically format code on save
      "editor.tabSize" = 4;  # Set tab size for C and Rust code
      "rust-analyzer.cargo.loadOutDirsFromCheck" = true;  # Load output directories from Cargo
      "rust-analyzer.checkOnSave.command" = "clippy";  # Use Clippy for linting
      "window.zoomLevel" = 0;  # Default zoom level
      "workbench.startupEditor" = "none";  # No startup editor
      # Add more settings as needed
    };
  };


  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "agnoster";
  };

  programs.zsh.initExtra = ''
    POWERLEVEL9K_MODE='nerdfont-complete'
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
    POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
    POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
    POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="blue"
    POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="white"

'';


  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/barak/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
