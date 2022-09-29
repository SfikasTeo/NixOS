# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# The first line ({ config, pkgs, ... }:) denotes that this is actually a function that takes at least the two arguments config and pkgs.
{ config, pkgs, ... }:

{
	imports =
    [ 	# Include the results of the hardware scan.
    	/etc/nixos/hardware-configuration.nix
    ];
    
	# Select internationalisation properties.
	# i18n.defaultLocale = "en_US.UTF-8";
	# console = {
	#   font = "Lat2-Terminus16";
	#   keyMap = "us";
	# };
  
	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };
  	
	nixpkgs.config.allowUnfree = true;
	time.timeZone = "Europe/Athens";
  
## User
	users = {
		users.sfikas = {
			isNormalUser = true;
			extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
			packages = with pkgs; {
				feh;						# Image viewer and Wallpaper Setter
				kitty;						# Terminal Emulator
				fish;						# Shell 
				xdragon;					# Drag and Drop utility from terminal
				pavucontrol;					# Gui for Pulseaudio Volume Control
				xclip;						# X Clipboard Manager
				mpv;						# Video player
				discord;					# Social Platform
				brave;						# Browser
				vscode-with-extensions;				# Proprietary Version of vscode
			};
		};
		extraUsers.nihar = {
			shell = pkgs.fish;
		};
	};
		
  # List packages installed in system profile. To search, run:
  # $ nix search wget

## Envorinment
	environment.variables = {
		SUDO_EDITOR = "nvim";
	};
	
	environment.systemPackages = with pkgs; {				# System Packages:
		neovim;								# Editor
		wget;								#
		zip;								#
		unzip;								#
		unrar;								#
		git;								#
		fira-code;							# Monospace font
		bspwm;								# Window Manager
		sxhkd;								# Bspwm Shortcuts Configuration
		
   };
   
## Sound.
	sound.enable = true;
	hardware.pulseaudio.enable = true;
     
## Fonts
	fonts.fonts = with pkgs; [
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];

## Services
	services = {
		openssh.enable = true;						# Enable the OpenSSH daemon.
		xserver.enable = true;						# Enable the X11 Windowing System.
		xserver.layout = "us";						# Configure keymap in X11
		xserver.windowManager.bspwm.enable = true;			# BSPWM
	#	xserver.libinput.enable = true;					# Touchpad Support.
	#	printing.enable = true;						# Enables CUPS for printers Support.
	};
  
## Networking
	networking.hostName = "SF-nxos"
	networking.firewall = {
  		enable = false;							# Disables the firewall altogether.
    #	allowedTCPPorts = [  ];							# Open ports in the firewall.
 	#	allowedUDPPorts = [  ];
	};

	networking.networkmanager.enable = true;				# Enables networkManager.
	# networking.wireless.enable = true;  					# Enables wireless support via wpa_supplicant.
  
	networking.useDHCP = false;						# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	networking.interfaces.enp2s0.useDHCP = true;				# Per-interface useDHCP will be mandatory in the future.
  
	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/"; 
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
## Bootloader
	boot.loader = {
		systemd-boot = {
			enable = true;						# Enables the systemd-boot EFI boot loader.
			configurationLimit = 5;					# Number of configurations at Boot Time.
			editor = false;						# Disables editing of kernelparameters before Boot. 
		};
		efi.canTouchEfiVariables = true;
	};


## System
	# system.autoUpgrade.enable = true;					# Auto upgrades
	# system.autoUpgrade.allowReboot = true;
	system.stateVersion = "21.05"; 						# Keep the default generated Value

##	**NOTES**	##
/*
	   Various notes about Nix language:
	 # `let` is recursive and lazy: `let x = x; in x` gives error about infinite
		recursion; `let x = x; in 5` just evaluates to `5`.
	 # `with foo; ...` still keeps `foo` visible inside the `...` code.
	 # `{ inherit (foo.bar) baz xyzzy; }` is shortcut for `{ baz = foo.bar.baz;
		xyzzy = foo.bar.xyzzy; }`.
	 # `import ./foo/bar.nix arg1 arg2` loads code from ./foo/bar.nix and then
		calls it as a function with arguments `arg1` and `arg2`.
	 # `foo.bar or baz` returns `foo.bar` if `foo` has attribute `bar`, or
		expression `baz` otherwise. In other words, `baz` is a "default value" if
		`.bar` is missing.
	 # `"foo ${bar.baz}"` evaluates to `bar.baz.outPath` string if present (see also
		builtins.toString and [nix pill 6]
		(http://lethalman.blogspot.com/2014/07/nix-pill-6-our-first-derivation.html)).
	 # `foo ? bar` returns true if foo contains attribute bar.
*/
}
