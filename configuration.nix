# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, home-manager, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    home-manager.nixosModule
    ./cloudflare-warp.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [ "psmouse" ];

  networking.hostName = "cpwr-tpxy"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "jp";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "jp106";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cffnpwr = {
    isNormalUser = true;
    description = "CaffeinePower";
    extraGroups = [ "networkmanager" "wheel" "input" "docker" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      neovim
      libinput-gestures
      xdotool
      xsel
      blueman
      tailscale
      ibus
      ibus-engines.mozc
      ibus-qt
      home-manager
      xdg-utils
      xdg-user-dirs
      coreutils-full
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      virt-manager
    ];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ mozc ];
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.blueman.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  services.tailscale.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    zsh
    tmux
    noto-fonts
    noto-fonts-cjk-sans
    dig
    gnupg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = "gnome3";
  };

  services.cloudflare-warp.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

  security.pki.certificates = [''
    -----BEGIN CERTIFICATE-----
    MIIC6zCCAkygAwIBAgIUI7b68p0pPrCBoW4ptlyvVcPItscwCgYIKoZIzj0EAwQw
    gY0xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
    YW4gRnJhbmNpc2NvMRgwFgYDVQQKEw9DbG91ZGZsYXJlLCBJbmMxNzA1BgNVBAMT
    LkNsb3VkZmxhcmUgZm9yIFRlYW1zIEVDQyBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkw
    HhcNMjAwMjA0MTYwNTAwWhcNMjUwMjAyMTYwNTAwWjCBjTELMAkGA1UEBhMCVVMx
    EzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xGDAW
    BgNVBAoTD0Nsb3VkZmxhcmUsIEluYzE3MDUGA1UEAxMuQ2xvdWRmbGFyZSBmb3Ig
    VGVhbXMgRUNDIENlcnRpZmljYXRlIEF1dGhvcml0eTCBmzAQBgcqhkjOPQIBBgUr
    gQQAIwOBhgAEAVdXsX8tpA9NAQeEQalvUIcVaFNDvGsR69ysZxOraRWNGHLfq1mi
    P6o3wtmtx/C2OXG01Cw7UFJbKl5MEDxnT2KoAdFSynSJOF2NDoe5LoZHbUW+yR3X
    FDl+MF6JzZ590VLGo6dPBf06UsXbH7PvHH2XKtFt8bBXVNMa5a21RdmpD0Pho0Uw
    QzAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4EFgQU
    YBcQng1AEMMNteuRDAMG0/vgFe0wCgYIKoZIzj0EAwQDgYwAMIGIAkIBQU5OTA2h
    YqmFk8paan5ezHVLcmcucsfYw4L/wmeEjCkczRmCVNm6L86LjhWU0v0wER0e+lHO
    3efvjbsu8gIGSagCQgEBnyYMP9gwg8l96QnQ1khFA1ljFlnqc2XgJHDSaAJC0gdz
    +NV3JMeWaD2Rb32jc9r6/a7xY0u0ByqxBQ1OQ0dt7A==
    -----END CERTIFICATE-----
  ''];

}
