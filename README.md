<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#nixos">NixOS</a></li>
    <li><a href="#starting-up-the-main-resources-that-will-be-of-use-for-the-installation-guide">Documentation</a></li>
    <li><a href="#installation-proccess">Installation</a></li>
  </ol>
</details>

# [NixOS](https://nixos.wiki/) [<img src="https://nixos.org/logo/nixos-logo-only-hires.png" width="220" align="right" alt="NixOS">](https://nixos.org)
A linux distribution and configuration system based on **Nixpkgs**, a git repository containing all Nix packages.   
[NixOS](https://stelligent.com/2017/07/11/introduction-to-nixos/) is a divergence of the immutable systems that facilitates [CI/CD](https://www.redhat.com/en/topics/devops/what-cicd-pipeline) pipelines.  
  
The Nix Ecosystem is a collection of technologies designed to reproducibly build and declaratively configure and manage packages and systems as well as their dependencies.
Nix purpose is **reproducibility**, based on a functional, declarative and a pure language, it minimizes the deviation of builded packages between systems.    
  
Disclaiming: The following guide will be customized and specific for my set-up process.  Alternating the guide to your needs is advisable. 

## Starting up: The main resources that will be of use for the installation Guide
 
* [The Manual](https://nixos.org/manual/nixos/stable/index.html#nixos-manual)
* [Nix Wiki](https://nixos.wiki)
* [Nix Quick Cheatsheet](https://nixos.wiki/wiki/Cheatsheet)
* [The Nix Ecosystem](https://nixos.wiki/wiki/Nix_Ecosystem)
* [The Nix Language](https://nixos.wiki/wiki/Overview_of_the_Nix_Language)
* [Nix Package Manager](https://nixos.wiki/wiki/Nix_package_manager) / [Nix Detailed Manual](https://nixos.org/manual/nix/stable/)
* [YouTube: Installation Guide - Matthias Benaets](https://www.youtube.com/watch?v=AGVXJ-TIv3Y)
* [Youtube: Wil T Channel](https://www.youtube.com/user/wilfridtaylor)

## [Installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation) Proccess

* Default user will be nixos -> `sudo su` -> root user
* Check for Internet Access ip -a. Check [Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-booting-networking) for Wifi support
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
* Login as `root` from tty ( **Cntr + Alt + Fkeys** ) and change the user passwd -> `passwd sfikas`

## [Nix Channels](https://nixos.wiki/wiki/Nix_channels)  
In plain terms **channels** are regarded as git **branches** in the git nixpkgs repository. A "channel" is a name for the latest "verified" git commits
in Nixpkgs. Installing packages directly from the Nixpkgs repository is possible but **not** adviced since binaries are merged into the master
branch before beeing heavily tested.  
Available channels `urls` can be found [Here](https://nixos.org/channels) along with their current [Status](https://status.nixos.org/).    
   
**Subscribed** channels can be mainly used for keeping your systems binaries up to date using `nix-channels` command.  
The official channels are parted into small and large branches where the first is moslty suited for server where the latter for Desktop use.  
Secondly a stable and an unstable channel can be found:   
**Stable** channels push mostly fixes and security paches. They are maintaned until the next branch comes out and they're heavily tested.  
**Unstable** channels reflect the master branch of Nixpkgs. They are rolling releasing the latest packages.  
Nix-channels commands:
* `# nix-channel --list`
* `# nix-channel --add https://nixos.org/channels/nixos-unstable nixos`
* `# nix-channel --remove https://nixos.org/channels/nixos-unstable nixos`
* `# nix-channel --update nixos`
* `# nixos-rebuild switch --upgrade`  
  
The Update command **synchronizes** the binaries with the repository, but the changes do **not** take effect until the system has been **rebuilded**.  
Automatic updates can be achived by adding `system.autoUpgrade.enable = true;` and `system.autoUpgrade.channel = url/channel;` to the configuration.nix.

## Altering the [Configuration.nix](https://nixos.org/manual/nixos/stable/index.html#ch-configuration)
The file `/etc/nixos/configuration.nix` contains the current configuration of your machine.  
After altering the configuration the following options are advised:  
* `nixos-rebuild switch` -> Build, set it as the boot configuration and restart [user system services](https://nixos.org/manual/nixos/stable/options.html#opt-systemd.user.services)
* `nixos-rebuild test`   -> Build and restart user services but do **not** default it to the boot configuration
* `nixos-rebuild boot`   -> Build and only set it as the default boot configuration
* `nixos-rebuild build`  -> Build the configuration to check if everything compiles  smoothly
* `nixos-rebuild --rollback` -> Rollbacks to previous configuration  
  
The Configuration.nix file is by itself a **Nix expression**, the product of a functional language describing how to build packages, dependencies and configurations.  

	
## [Nix Package Management](https://nixos.wiki/wiki/Nix_package_manager)  


## Tips & Tricks
* <nixpkgs/path> -> path/to/nixpkgs/folder
* Almost Everything from /lib & /lib/usr & /bin /usr/bin -> /nix/store
	
				
