# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
	
	# Enable Propriety packages
	nixpkgs.config.allowUnfree = true;
	
  # Use the systemd-boot EFI boot loader.
	boot.loader = {
		systemd-boot = {
			enable = true;
			configurationLimit = 5;
			editor = false;
		};
		efi.canTouchEfiVariables = true;
	};

  networking.hostName = "Sfnix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
	i18n = {
		defaultLocale = "en_US.UTF-8";		
		supportedLocales = [
			"en_US.UTF-8/UTF-8"
			"el_GR.UTF-8/UTF-8"
		];
	};

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  
  # Enable Wayland-Hyprland Compositor:
  programs = {
		hyprland = {
			enable = true;
			# nvidiaPatches = true;
			# xwayland.enable = true;  
		};
		zsh = {
			enable = true;
		};
  };

  environment.sessionVariables = {
		XDG_DATA_HOME ="$HOME/.local/share";
		XDG_STATE_HOME = "$HOME/.local/state";
		XDG_CONFIG_HOME = "$HOME/.config";

		# Change zsh default location
		ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
		HISTFILE = "$ZDOTFILE/.zsh_history";
		
		EDITOR = "hx";
		VISUAL = "hx";
		TERMINAL = "kitty";

		GDK_BACKEND = "wayland";
	 	# If cursor becomes invisible
		# WLR_NO_HARWARE_CURSORS = "1";
		# Hint electron apps to use wayland
		NIXOS_OZONE_WL = "1";
		# Hint firefox to use wayland
		MOZ_ENABLE_WAYLAND = "1";
  };
  
  hardware = {
		opengl = {
			enable = true;
			extraPackages = [
				#intel-media-driver
				#intel-compute-runtime
			];
		};	
		bluetooth.enable = true;
		# Most Wayland Compositors Need this:
		# nvidia.modesetting.enable = true;
  };
	

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound - Pipewire.
  sound.enable = true;
  services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
  };

  security = {
		rtkit.enable = true;
		polkit.enable = true;
	};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
		users.sfikas = {
			isNormalUser = true;
			extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
			packages = with pkgs; [
				# Binary Utilities
				git
				graphicsmagick
				vim
				killall
				bottom
				btop
				zip
				unzip
				ripgrep
				
				# Helix and LSPs
				helix
				rust-analyzer
				cmake-language-server 
				python311Packages.pylsp-mypy
				nodePackages.bash-language-server
				nodePackages.vscode-json-languageserver
						
				# Base packages
				xfce.thunar
				xfce.thunar-volman
				xfce.thunar-archive-plugin
				firefox-wayland
				logseq
				
				# Base Utilities
				wl-clipboard
				brightnessctl
				hyprpaper
				rofi-wayland
				polkit
				pavucontrol
				mako
				zsh
				kitty

				# Bluetooth
				bluetuith

				# Screenshot - Record
				grim
				slurp
				swappy

				# Nix
				nix-du
				nix-info
				nix-index

				# Unstable
				nwg-displays
				nwg-look

		  	# For workspaces to work correctly with HyprLand-Waybar (TBfixed) 
				(waybar.overrideAttrs ( oldAttrs: {
					mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
			  		})
				)
	 		];
		};
		extraUsers.sfikas = {
			shell = pkgs.zsh;
		};
	};

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
		# System Functionalities
		openssh
		lm_sensors
		bluez
		libnotify

		# Compilers
		gcc
		gdb
		libcxx
		libcxxabi
		libcxxStdenv
		gnumake
		llvmPackages_16.libcxxClang
		llvmPackages_16.libcxxStdenv
		llvmPackages_16.libcxxabi
		llvmPackages_16.libcxx
		llvmPackages_16.openmp
		clang-tools_16
		lldb_16
		rustup
		
		# Theming
		orchis-theme
		tela-circle-icon-theme
		bibata-cursors
  ];
  
  # Installing Fonts:
  fonts.packages = with pkgs; [
		noto-fonts
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Wayland - HyprLand Portals
  xdg = {
		portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-hyprland
				xdg-desktop-portal-gtk
			];
		};	
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

