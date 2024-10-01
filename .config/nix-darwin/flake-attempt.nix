{
    description = "nix flake";
    inputs = {
        # software channel
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

        # manages configs, links to home dir
        home-manager.url = "github:nix-community/home-manager/master";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # controls system level software, settings, fonts
        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs: {
        darwinConfigurations.mba = inputs.darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import inputs.nixpkgs {
                system = "arm64-darwin";
                modules = [
                    ({pkgs, ...}: {
                        # darwin preferences & config
                        # for all users
                        programs.zsh.enable = true;
                        environment.shells = [ pkgs.bash pkgs.zsh ];
                        environment.loginShell = pkgs.zsh;
                        nix.extraOptions = ''
                            experimental-features = nix-command flakes
                        '';
                        systemPackages = [ pkgs.coreUtils ];
                        system.keyboard.enableKeyMapping = true;
                        system.keyboard.remapCapsLockToEscape = true;
                        fonts.fontDir.enable = true; # will only install fonts that are in fontDir
                        fonts.fonts = [ (pkgs.nerdFonts.override { fonts =  [ "Hack" ]; }) ]; # installs only one nerd font
                        services.nix-daemon.enable = true; # allows nix to auto-update 
                        system.defaults.finder.AppleShowAllExtensions = true;
                        system.defaults.finder._FXShowPosixPathInTitle = true;
                        system.defaults.dock.autohide = true;
                        system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
                        system.defaults.NSGlobalDomain.KeyRepeat = 1;
                    })
                    inputs.home-manager.darwinModules.home-manager {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPkgs = true;
                            users.matt.imports = [
                                ({pkgs, ...}: {
                                    # specify home-manager configs
                                    home.packages = [ pkgs.ripgrep pkgs.curl pkgs.less ];
                                    home.sessionVariables = {
                                        TEST_ENV_VAR = "set!";
                                        TEST_ENV_VAR_2 = 1337;
                                    }; 
                                    programs.bat.enable = true;
                                    programs.bat.config.theme = "TwoDark";
                                    programs.fzf.enable = true;
                                    # programs.fzf.enableZshIntegration = true;
                                    programs.git.enable = true;
                                    # programs.zsh.enableCompletion = true;
                                    # programs.zsh.enableAutosuggestions = true;
                                })
                            ];
                        };
                    }
                ];
            };
        };
    };
}
