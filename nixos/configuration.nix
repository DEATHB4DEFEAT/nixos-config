# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
    pkgs,
    lib,
    ...
}:

{
    imports = [
        ../_secrets/.

        ./hardware-configuration.nix

        ./steam.nix

        ./ascii-workaround.nix
    ];


    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    systemd.enableEmergencyMode = false; # Causes issues when fstab fails to mount anything, annoying
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
    };


    networking.hostName = "DTLinix"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;


    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };


    # Configure keymap
    console.useXkbConfig = true;
    services.xserver = {
        xkb = {
            layout = "us,custom";
            options = "grp:alts_toggle,grp_led:scroll";

            extraLayouts = {
                custom = {
                    description = "A modified version of CarpalX's QGMLWY layout.";
                    languages = [ "eng" ];
                    symbolsFile = /home/death/.setup/xkb/symbols/qgmlwy_mod.xkb;
                    keycodesFile = /home/death/.setup/xkb/keycodes/1024.xkb;
                };
            };
        };
    };


    # Define a user account. Don't forget to set a password with ‘passwd’.
    # Normal user account
    users.users = {
        death = {
            isNormalUser = true;
            description = "Death";
            extraGroups = [
                "networkmanager"
                "wheel"
            ];
            home = "/home/death";
        };

        test = {
            isNormalUser = true;
            description = "Test";
            extraGroups = [
                "networkmanager"
                "wheel"
            ];
            home = "/home/test";
        };
    };


    users.groups.deaths.members = [ "death" ];


    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        nh
        vscode
        jetbrains.rider
        firefox
        wl-clipboard
        xsel
        ntfs3g
        ntfsprogs
        ckb-next
        kdePackages.filelight
        kdePackages.partitionmanager
        kdePackages.sddm-kcm
        sshfs
        hyfetch
        fastfetch
        linux-wifi-hotspot
        xorg.xkbcomp
        mpv
        obsidian
        obs-studio
        krita
        manix
        helvum
        easyeffects
    ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        jetbrains-mono
    ];

    hardware.ckb-next.enable = true;


    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

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
    system.stateVersion = "23.11"; # Did you read the comment?

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];


    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma6.enable = true;

    programs.hyprland.enable = true;
    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };


    services.flatpak.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    hardware.pulseaudio.enable = lib.mkForce false;

    programs.gnupg.agent = {
        enable = true;
    };

    xdg.portal.enable = true;

    programs.bash.blesh.enable = true;


    systemd.services = {
        # "Disable" middle mouse paste
        # disable-primary-select = {
        #     description = "Disable primary selection paste";
        #     wantedBy = [ "default.target" ];

        #     script = ''
        #         if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        #             echo "Wayland"
        #             wl-paste -p --watch wl-copy -p < /dev/null  # Usually works.
        #             # wl-paste -p --watch wl-copy -cp  # 100% Effective, may cause issues selecting text in GTK applications.
        #         fi

        #         while [ "$XDG_SESSION_TYPE" == "x11" ]; do
        #             echo "X11"
        #             xsel -fin </dev/null  # 100% Effective, May cause issues selecting text in GTK applications.
        #         done

        #         echo "Done - you should never see this"
        #     '';
        # };
    };
}
