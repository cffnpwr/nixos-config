{ config, lib, pkgs, personal, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs.home-manager.enable = true;

  home.username = "cffnpwr";
  home.homeDirectory = "/home/cffnpwr";
  home.stateVersion = "23.05";

  home.packages = with pkgs; with personal; [
    rnix-lsp
    nixpkgs-fmt
    ciscoPacketTracer8
    google-chrome
    vscode
    discord
    teams
    spotify
    papirus-icon-theme
    orchis-theme
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator-2
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gesture-improvements
    gnomeExtensions.tailscale-status
    gnomeExtensions.vitals
    gnomeExtensions.applications-menu
    fusuma
    neofetch
    zplug
    bibata-cursors
    koruri
    _0xproto
  ];

  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [ xdotool coreutils-full ];
    settings = {
      swipe = {
        "3" = {
          left = {
            command = "xdotool key alt+Right";
          };
          right = {
            command = "xdotool key alt+Left";
          };
        };
      };
    };
  };

  xdg.userDirs.enable = true;

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "ibus" "mozc-jp" ]) (mkTuple [ "xkb" "jp" ]) ];
      xkb-options = [ "caps:ctrl_modifier" ];
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      ls = "ls --color=auto";
      l = "ls";
      ll = "ls -al";
      la = "ls -a";
      update = "sudo nixos-rebuild switch";

      # docker
      d = "docker";
      di = "docker images";
      dps = "docker ps";
      dc = "docker compose";
      dce = "docker compose exec";
      dcl = "docker compose logs";
      dcu = "docker compose up";
      dcd = "docker compose down";

      # k8s
      k = "kubectl";
      kg = "kubectl get";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgn = "kubectl get nodes";
      kga = "kubectl get all";
      kd = "kubectl describe";
      kdp = "kubectl describe pods";
      kds = "kubectl describe services";
      kdn = "kubectl describe nodes";
      krm = "kubectl delete";
      krmp = "kubectl delete pods";
      krms = "kubectl delete services";

    };

    envExtra = ''
      DOCKER_HOST=unix:///var/run/docker.sock
    '';

    initExtra = ''
      zstyle ':completion:*' list-colors "\$\{LS_COLORS\}"
      zstyle ':completion:*' menu select=1

      if zplug check zsh-users/zsh-history-substring-search; then
        bindkey '^[OA' history-substring-search-up
        bindkey '^[OB' history-substring-search-down
      fi

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    zplug = {
      enable = true;
      plugins = [
        {
          name = "zplug/zplug";
          tags = [
            "hook-build:\"zplug --self-manage\""
          ];
        }
        {
          name = "zsh-users/zsh-history-substring-search";
        }
        {
          name = "Jxck/dotfiles";
          tags = [
            as:command
            "use:\"bin/{histuniq,color}\""
          ];
        }
        {
          name = "tcnksm/docker-alias";
          tags = [
            use:zshrc
          ];
        }
        {
          name = "k4rthik/git-cal";
          tags = [
            as:command
          ];
        }
        {
          name = "plugin/git";
          tags = [
            from:oh-my-zsh
          ];
        }
        {
          name = "modules/prompt";
          tags = [
            from:prezto
          ];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [
            defer:2
          ];
        }
        {
          name = "mafredri/zsh-async";
        }
        {
          name = "zsh-users/zsh-completions";
        }
        {
          name = "chrissicool/zsh-256color";
        }
        {
          name = "romkatv/powerlevel10k";
          tags = [
            as:theme
            depth:1
          ];
        }
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "cffnpwr";
    userEmail = "cffnpwr@gmail.com";
    signing = {
      key = "67A686937C9B0C5B";
      signByDefault = true;
    };
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEZIWyhxYJKwYBBAHaRw8BAQdAck42CtykUr3zTQlzmx7a0UncD7CGQPKLvXTP
          xBjLMSG0IUNhZmZlaW5lUG93ZXIgPGNmZm5wd3JAZ21haWwuY29tPoiWBBMWCgA+
          AhsBBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAFiEEFjjyC6IanqHMVLUw6Knp
          hP8Rg2gFAmSFutYCGQEACgkQ6KnphP8Rg2h5iwD/RiTkaDXF6MzWBG4uk1ZFsy8F
          zr3Po7bOONe99Z7gvFIBAN/GdDMN5HN12pMaCawfqNEpmwdXMz2LeB6amNBgqTQB
          tCRZdXRvIE9rdWRhIDx5dXRvMTAwMW9rdWRhQGdtYWlsLmNvbT6IkwQTFgoAOxYh
          BBY48guiGp6hzFS1MOip6YT/EYNoBQJkhbp5AhsBBQsJCAcCAiICBhUKCQgLAgQW
          AgMBAh4HAheAAAoJEOip6YT/EYNo+poBAI5ZnXWOCMuxlvXU3+0d8IV+D2SGyUUY
          uPYdlmGayVd+AQC6NmVh5BjComQljlp0dkZ6fHTc8bXq434mCRQojLnEBLg4BGSF
          svASCisGAQQBl1UBBQEBB0DNfWJp7zFJhOlKuXg+rNb5Gj+yZJ9kdXG5WsfMKQYN
          bgMBCAeIeAQYFgoAIBYhBBY48guiGp6hzFS1MOip6YT/EYNoBQJkhbLwAhsMAAoJ
          EOip6YT/EYNoj8UBAOeO8wSyLn+KmmMtZ0ZcbGC3AifAzaH4615HOnBV7uOWAP9c
          6QoKyuXsT/uR8r6IYICRS0tIZ7cd5xx2HuwJKiaNBbgzBGSFsxYWCSsGAQQB2kcP
          AQEHQL+Ig9X9zMkggynfJeep8aouz+R8k+4B5AbeO9aCCQzDiO8EGBYKACAWIQQW
          OPILohqeocxUtTDoqemE/xGDaAUCZIWzFgIbAgCBCRDoqemE/xGDaHYgBBkWCgAd
          FiEEwffQ3A2YJA2rDeKrZ6aGk3ybDFsFAmSFsxYACgkQZ6aGk3ybDFvHQgD+PZA+
          HDgeluMK3606tMMaDKhfduSyVecD+Yt31ioZlqQA/iCnT5sdyn7eNqP5/wif2QXD
          R9Bc1rs/W5i8Wm931AQOBxoBAPnZ1jCdmSOPhlokOkdl5nQfZOX0Sitx6Xb9Gzdw
          rWNmAP94wYWyVcHaoF2bKFd0OaesXAUtaCwb4yuOEfvfbuDFDbgzBGSFsyoWCSsG
          AQQB2kcPAQEHQHpiNcZTlRi6VjuO55ppdCogsjaZyc3YDNxOMWJPgf5diHgEGBYK
          ACAWIQQWOPILohqeocxUtTDoqemE/xGDaAUCZIWzKgIbIAAKCRDoqemE/xGDaBK8
          AP9FU5y2EdgaTdmV5iEvbmsEVJfBVYx0AlRZSmcn6mjb0QD+LUSsYn/k3o+GZeF9
          +QVFGe1CSVKwHBm7vBWXDk8UJgA=
          =aeK/
          -----END PGP PUBLIC KEY BLOCK-----

        '';
        trust = "ultimate";
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
  };
}
