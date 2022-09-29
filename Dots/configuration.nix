# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# The first line ({ config, pkgs, ... }:) denotes that this is actually a function that takes at least the two arguments config and pkgs.

{ config, pkgs, ... }:

{
	imports = [ # Include the results of the hardware scan.
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
			packages = with pkgs; [
				feh					/* Image viewer and Wallpaper Setter 	*/
				inxi					/* CLI System Information tool		*/
				kitty					/* Terminal Emulator			*/
				fish					/* Shell 				*/
				arandr					/* Gui frontend for xrandr		*/
				xdragon					/* Drag and Drop utility from terminal	*/
				pavucontrol				/* Gui for Pulseaudio Volume Control	*/
				copyq					/* Advanced Clipboard Manager		*/
				flameshot				/* Advanced Screenshot Utility		*/
				mpv					/* Video player				*/
				discord					/* Social Platform			*/
				brave					/* Browser				*/
				vscode-with-extensions			/* Proprietary Version of vscode	*/
			];
		};
		extraUsers.sfikas = {
			shell = pkgs.fish;
		};
	};
		
  # List packages installed in system profile. To search, run:
  # $ nix search wget

## Environment
	environment.variables = {
		SUDO_EDITOR = "nvim";
	};
	
	environment.systemPackages = with pkgs; [			/* System Packages:			*/
		neovim							/* Editor				*/
		wget2							/* Successor of GNU wget		*/
		zip							/* Compressor/Archiver			*/
		unzip							/* Zip extraction utility		*/
		unrar							/* Rar extraction utility		*/
		git							/* Distributed version control system	*/
		bspwm							/* Window Manager for X 		*/
		sxhkd							/* Bspwm Shortcuts Configuration	*/
		xclip							/* X terminal clipboard			*/
		xorg.xrandr						/* X display setup utility		*/
	];
   
## Sound
	sound.enable = true;
	hardware.pulseaudio.enable = true;
     
## Fonts
	fonts.fonts = with pkgs; [					/* Font Installation 			*/
		fira-code						/* Monospace font			*/
		fira-code-symbols					/* FiraCode unicode ligature glyphs     */
 	];
	fonts.fontDir.enable = true;					/* Ensures creation of X11/fonts dir    */

## Services
	services = {
		openssh.enable = true;					/* Enable the OpenSSH daemon.		*/
		xserver.enable = true;					/* Enable the X11 Windowing System.	*/
		xserver.autorun = true;					/* Xserver started at boot time		*/
		xserver.layout = "us";					/* Configure keymap in X11		*/
		xserver.windowManager.bspwm.enable = true;		/* BSPWM				*/
	#	xserver.libinput.enable = true;				/* Touchpad Support.			*/
	#	xserver.videoDrivers = [ "nvidia" ];			/* Proprietary Nvidia drivers		*/
	#	printing.enable = true;					/* Enables CUPS for printers Support.	*/
	};
## Programms
 	programs = {
		bash.enableCompletion = true;
	};
  
## Networking
	networking.hostName = "SF-nxos";
	networking.firewall = {
  		enable = false;						/* Disables the firewall altogether.	*/
    	#	allowedTCPPorts = [  ];					/* Open ports in the firewall.		*/
 	#	allowedUDPPorts = [  ];
	};

	networking.networkmanager.enable = true;			/* Enables networkManager.					*/
	# networking.wireless.enable = true;  				/* Enables wireless support via wpa_supplicant.			*/
  
	networking.useDHCP = false;					/* The global useDHCP flag is deprecated			*/
	networking.interfaces.enp2s0.useDHCP = true;			/* Per-interface useDHCP will be mandatory in the future.	*/
  
	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/"; 
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
## Bootloader
	boot.loader = {
		systemd-boot = {
			enable = true;					/* Enables the systemd-boot EFI boot loader.		*/
			configurationLimit = 5;				/* Number of configurations at Boot Time.		*/
			editor = false;					/* Disables editing of kernelparameters before Boot. 	*/
		};
		efi.canTouchEfiVariables = true;
	};


## System
	# system.autoUpgrade.enable = true;				/* Auto upgrades					*/
	# system.autoUpgrade.allowReboot = true;			/* After automatic update, if needed, reboot		*/
	system.stateVersion = "21.05"; 					/* Keep the default generated Value			*/




##	**NOTES**	##
/*
	Notes about NixOS Configuration:
	# `xserver.enable = true`  automatically configures the X Server and by default
	uses LightDM as a display manager. Configuring X server from the beggining
	look into sx package (alternative to xinit and startx) and at the [Wiki]
	(https://nixos.wiki/wiki/Using_X_without_a_Display_Manager).
	# `xserver.autorun = true;`service can be disabled and started through tty using
	`systemctl start display-manager.service`.
	# 
	
	Notes about Nix language:
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
