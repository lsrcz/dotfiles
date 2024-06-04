{ pkgs, ... }: {
  imports = [
    ../darwin
  ];
  environment.systemPackages =
    with pkgs; [
      vim
      gnupg
    ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  users.users.siruilu.home = "/Users/siruilu";
  networking.hostName = "hera";

  homebrew = {
    enable = true;
    casks = [
      "arq"
      "1password"
      "cheatsheet"
      "dash"
      "displaylink"
      "garmin-express"
      "google-chrome"
      "iina"
      "istat-menus"
      "iterm2"
      "itsycal"
      "microsoft-office-businesspro"
      "notion"
      "raycast"
      "readdle-spark"
      "rectangle"
      "slack"
      "todesk"
      "visual-studio-code"
      "xquartz"
      "wechat"
      "zoom"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "GarageBand" = 682658836;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
    };
    onActivation.cleanup = "uninstall";
  };
}
