# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Sets default shell
  users.defaultUserShell = pkgs.zsh;

  # Razer device configuration
  hardware.openrazer.enable = true;

  # Plasma
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  
  # NVIDIA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta; # for GNOME
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Create database
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_10;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
  };  

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tcardin = {
      isNormalUser = true;
      initialPassword = "qwerty123";
      extraGroups = [ "wheel" "plugdev" "openrazer" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget 
     vim
     chromium
     discord
     spotify
     gimp
     dropbox-cli
     vscode
     openrazer-daemon razergenie
     dbeaver postman
     libreoffice
     openconnect
     
     (vscode-with-extensions.override {
       vscodeExtensions = with vscode-extensions; [
           bbenoist.nix
           ms-vsliveshare.vsliveshare
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
         {
           name = "code-runner";
           publisher = "formulahendry";
           version = "0.6.33";
           sha256 = "166ia73vrcl5c9hm4q1a73qdn56m0jc7flfsk5p5q41na9f10lb0";
         }
	 {
    	    name = "theme-dracula";
    	    publisher = "dracula-theme";
            version = "2.24.1";
	    sha256 = "1lg038s2y3vygwcs47y37gp9dxd8zfvy6yfxi85zzl0lf8iynl1b";
	  }
	  {
	    name = "go";
	    publisher = "golang";
	    version = "0.31.1";
	    sha256 = "1x25x2dxcmi7h1q19qjxgnvdfzhsicq6sf6qig8jc0wg98g0gxry";
	  }
	  {
	    name = "protobuf";
	    publisher = "kangping";
	    version = "1.1.6";
	    sha256 = "0alhzr1amx3clz9vr2hqrkpd1wnvwb59rhzb4lipsqlnsjsmaz7r";
	  }
	  {
	    name = "python";
	    publisher = "ms-python";
	    version = "2022.3.10661003";
	    sha256 = "1h0d5p5p04r3k3s47n6b7m7y551prmg9021s1vv0jniv5q2b580r";
	  }
	  {
	    name = "vscode-pylance";
	    publisher = "ms-python";
	    version = "2022.3.0";
	    sha256 = "1s4cyrzqpb4ijwj942dqd86pcxwxdhshx80r2z80mc3q0l6gkhcd";
	  }
	  {
	    name = "jupyter";
	    publisher = "ms-toolsai";
	    version = "2022.3.1000690154";
	    sha256 = "14wj853dcxici5hav7pf93fdsvr1qfg4s9nqpbxp3qp9aj8ayqya";
	  }
	  {
	    name = "cargo";
	    publisher = "panicbit";
	    version = "0.2.3";
	    sha256 = "0idcbri4kpva0yxni0ql6l14knc3h6izxza5d49jidrh9xj0njh7";
	  }
	  {
	    name = "rust";
	    publisher = "rust-lang";
	    version = "0.7.8";
	    sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
	   }
       ];
     })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  system.stateVersion = "21.11"; # Did you read the comment?

}

