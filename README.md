# NixOS
A linux distribution based on the **Nix package Manager**. The Nix Ecosystem is a collection of technologies designed to reproducibly build and declaratively configure and manage packages and systems as well as their dependencies.   Nix purpose is **reproducibility**, based on a functional, declarative and a pure language, it minimizes the deviation of builded packages between systems.  
  Packages throught the nix-env are installed at user level at **/nix/store**.   
Disclaiming: The following information will be customized and specific for my set-up process. Alternating the guide to your needs is advisable. 

## Starting up: The main resources that will be of use for the installation Guide
 
* [The Manual](https://nixos.org/manual/nixos/stable/index.html#nixos-manual)
* [Nix Wiki](https://nixos.wiki)
* [Nix Quick Cheatsheet](https://nixos.wiki/wiki/Cheatsheet)
* [The Nix Ecosystem](https://nixos.wiki/wiki/Nix_Ecosystem)
* [The Nix Language](https://nixos.wiki/wiki/Overview_of_the_Nix_Language)
* [Nix Package Manager](https://nixos.wiki/wiki/Nix_package_manager) / [Nix Detailed Manual](https://nixos.org/manual/nix/stable/)
* [YouTube: Installation Guide - Matthias Benaets](https://www.youtube.com/watch?v=AGVXJ-TIv3Y)
* [Youtube: Wil T Channel](https://www.youtube.com/user/wilfridtaylor)

## Installation Proccess

* [Mandatory] Default user will be nixos -> sudo su -> root user
* [Mandatory] Check for Internet Access ip -a. Check [Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation) for Wifi support
* [Optional] Initially set the timezone `timedatectl set-timezone Europe/Athens`
* [Mandatory] Setting up Βtrfs  
~~~

Partition Disk ( /dev/sda ) :
	1. lsblk -> List drives
	2. blkdiscard /dev/sda	->	Updates the drives firmware to signify that the drive is empty.
								Improves performance and disk longevity (SSD or NVME only).
	3. Any supported partition utility could be used. We will default to GNU parted -> parted
	4.Partition Table		->	
	
~~~


## Tips & Tricks
* <nixpkgs/path> -> path/to/nixpkgs/folder
* Almost Everything from /lib & /lib/usr & /bin /usr/bin -> /nix/store
	
				
