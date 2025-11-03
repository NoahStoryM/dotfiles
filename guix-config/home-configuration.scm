;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services fontutils)
             (gnu packages)
             (gnu services)
             (gnu system shadow)
             (guix gexp))

(define home (getenv "HOME"))

(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages
  (specifications->packages
   '("agda"
     "appimage-type2-runtime"
     "aria2"
     "bash"
     "calibre"
     "chez-scheme"
     "clang-toolchain"
     "cmake"
     "coq"
     "curl"
     "docker"
     "emacs"
     "ffmpeg"
     ;; "firefox"
     "fish"
     "flatpak"
     "font-adobe-source-han-sans"
     "font-gnu-freefont"
     "font-gnu-unifont"
     "font-google-noto"
     "font-google-noto-emoji"
     "font-google-noto-sans-cjk"
     "font-google-noto-serif-cjk"
     "font-hack"
     ;; "font-maple-mono"
     "font-ubuntu"
     "font-wqy-microhei"
     "font-wqy-zenhei"
     "fontconfig"
     "gcc-toolchain"
     "ghc"
     "git"
     "icecat"
     "icecat-l10n:zh-CN"
     "idris"
     "iptables"
     "ispell"
     "jupyter"
     "kitty"
     "lean"
     "libreoffice"
     "libtool"
     "libvterm"
     "make"
     "mit-scheme"
     "neofetch"
     "neovim"
     "nix"
     "node"
     "openjdk"
     "perl"
     "proxychains-ng"
     "python"
     "qemu"
     "racket"
     "rust"
     "sbcl"
     "scsh"
     "snap"
     "starship"
     "steam"
     "telegram-desktop"
     "texlive"
     "texlive-biblatex"
     "trash-cli"
     "tree"
     "ungoogled-chromium"
     "vim"
     "wget"
     "wget2"
     "wine"
     "xterm"
     "zig"
     "zip"
     "zsh"
     ;; "zoom"
     "zuo")))

 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 (services
  (cons*
   (service home-bash-service-type
            (home-bash-configuration
             (environment-variables
              '(["PS1" . "\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]}\\$ "]))
             (aliases
              '(["grep" . "grep --color=auto"]
                ["ip" . "ip -color=auto"]
                ["ll" . "ls -l"]
                ["ls" . "ls -p --color=auto"]))
             (bashrc
              (list (local-file
                     (format #f "~a/dotfiles/guix-config/.bashrc" home)
                     "bashrc")))
             (bash-profile
              (list (local-file
                     (format #f "~a/dotfiles/guix-config/.bash_profile" home)
                     "bash_profile")))))
   (service home-zsh-service-type
            (home-zsh-configuration
             (zshenv
              (list (local-file
                     (format #f "~a/dotfiles/guix-config/.zshenv" home)
                     "zshenv")))
             (zshrc
              (list (local-file
                     (format #f "~a/dotfiles/guix-config/.zshrc" home)
                     "zshrc")))))
   (service home-fish-service-type)

   (simple-service 'additional-fonts-service
                   home-fontconfig-service-type
                   '("~/.nix-profile/share/fonts"))

   (simple-service 'input-method-modules
                   ;; session-environment-service-type
                   home-environment-variables-service-type
                   '(["XMODIFIERS"        . "@im=fcitx"]
                     ["QT_IM_MODULE"      . "fcitx"]
                     ["CLUTTER_IM_MODULE" . "fcitx"]
                     ["GTK_IM_MODULE"     . "fcitx"]
                     ["LC_CTYPE" . "zh_CN.UTF-8"]))

   (simple-service 'paths
                   home-environment-variables-service-type
                   `(["PATH"
                      .
                      ,(format #f "~a/.local/share/racket/default/bin:~a/.local/bin:~a/.nix-profile/bin:~a"
                               home home home (getenv "PATH"))]))

   (service home-files-service-type
            `([".guile" ,%default-dotguile]
              [".Xdefaults" ,%default-xdefaults]))

   (service home-xdg-configuration-files-service-type
            `(["gdb/gdbinit" ,%default-gdbinit]
              ["nano/nanorc" ,%default-nanorc]))

   %base-home-services)))
