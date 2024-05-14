{
    config,
    lib,
    modulesPath,
    ...
}:

{
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/2c55fee3-4f2b-4cd4-8c25-294f7a580f32";
        fsType = "btrfs";
        options = [ "subvol=@" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/A425-1CF5";
        fsType = "vfat";
    };

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        # Enable if you have issues and need beta
        package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
}
