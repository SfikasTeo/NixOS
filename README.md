# NixOS
A linux distribution based on the **Nix package Manager**. The Nix Ecosystem is a collection of technologies designed to reproducibly build
and declaratively configure and manage packages and systems as well as their dependencies.
Nix purpose is **reproducibility**, based on a functional, declarative and a pure language,
it minimizes the deviation of builded packages between systems.  
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

* Default user will be nixos -> `sudo su` -> root user
* Check for Internet Access ip -a. Check [Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation) for Wifi support
* Configuring **Partitions** and **Filesystems**:
	* `lsblk -f` or `fdisk -l` -> List drives  
	* `blkdiscard /dev/sda` -> Updates the drives firmware to signify that the drive is empty (**SSD** or **NVME** only).  
  	* Partition Disk ( `/dev/sda` ):    
          Any supported partition utility could be used. We will default to GNU **parted** -> `parted`  
		* Create a **gpt** partition table -> `mklabel gpt`
		* Create the partitions:  
		```
		mkpart NIXBOOT fat32 4mb 1gb  
		mkpart NIXBTRFS btrfs 1gb 100%
		set 1 esp on
		```
	* Create the filesystems:
	```
	mkfs.fat -F32 -n NIXBOOT /dev/sda1
	mkfs.btrfs -L NIXBTRFS /dev/sda2
	```
	* Create the Btrfs subvolumes:
	```
	mount /dev/sda2 /mnt
	btrfs su cr /mnt/@
	btrfs su vr /mnt/@home
	umount /mnt
	```
	* Mount the Filesystems:
	```
	mount -o ssd,noatime,space_cache=v2,discard=async,compress=zstd:1,subvol=@ /dev/sda2 /mnt
	mkdir /mnt/home
	mount -o ssd,noatime,space_cache=v2,discard=async,compress=zstd:1,subvol=@home /dev/sda2 /mnt/home
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	```
	Should you use btrfs [compression](https://www.reddit.com/r/btrfs/comments/kul2hh/btrfs_performance/) ? What about the other btrfs [mount options](https://btrfs.readthedocs.io/en/latest/btrfs-man5.html) ?
* Generate and Edit the NixOS configuration files:
	* `nixos-generate-config --root /mnt`
	* Edit `/mnt/etc/nixos/hardware-configuration.nix` :
	```
	"/"     -> device = "/dev/disk/by-label/NIXBTRFS";
	"/home" -> device = "/dev/disk/by-label/NIXBTRFS";
	"/boot" -> device = "/dev/disk/by-label/NIXBOOT";
	```
	* Edit `/mnt/etc/nixos/configuration.nix` :
		* Add the number of configurations stored in the Bootloader : `boot.loader.systemd-boot.configurationLimit = 5;`
		* Disable the editing of Kernel CL before booting ( **Security** ):`boot.loader.systemd-boot.editor = false;`
		* Alter `boot.initrd.kernelModules` , if any Kernel Moduel is **necessary** for the booting process
		* Uncomment **NetworkManager** and **sound**, set your **timezone** and **user** information/applications
		* Uncomment the `envrionment.systemPackages` and `system.copySystemConfiguration`
* Install NixOS and reboot -> `nixos-install` 


## Tips & Tricks
* <nixpkgs/path> -> path/to/nixpkgs/folder
* Almost Everything from /lib & /lib/usr & /bin /usr/bin -> /nix/store
	
				
