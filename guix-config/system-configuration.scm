;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (gnu packages shells)
             (gnu services nix)
             (gnu system locale)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
 (host-name "Host")
 (locale "en_US.utf8")
 (locale-definitions
  (cons*
   (locale-definition (name "zh_CN.utf8") (source "zh_CN"))
   %default-locale-definitions))
 (keyboard-layout
  (keyboard-layout
   "us"
   #:options '("ctrl:swapcaps" "parens:swap_brackets")))
 (timezone "Asia/Shanghai")

 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 ;; (firmware (cons* iwlwifi-firmware %base-firmware))

 ;; The list of user accounts ('root' is implicit).
 (users
  (cons*
   (user-account
    (name "own")
    (comment "Own")
    (group "users")
    (home-directory "/home/own")
    (shell (file-append fish "/bin/fish"))
    (supplementary-groups '("wheel" "netdev" "audio" "video")))
   %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages
  (append
   (specifications->packages
    '(
      "bash"
      "emacs"
      "emacs-desktop-environment"
      "emacs-exwm"
      "emacs-evil"
      "emacs-geiser"
      "emacs-guix"
      "fish"
      "git"
      "keyd"
      "make"
      "neovim"
      "nix"
      "trash-cli"
      "tree"
      "vim"
      "xcape"
      "xterm"
      "zip"
      "zuo"
      "zsh"
      ))
   %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (cons*
   ;; To configure OpenSSH, pass an 'openssh-configuration'
   ;; record as a second argument to 'service' below.
   (service openssh-service-type)

   (service tor-service-type)
   (service cups-service-type)
   (service nix-service-type
            (nix-configuration
             (extra-config
              '(
                "substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org"
                "trusted-users = root own"
                ))))

   (set-xorg-configuration
    (xorg-configuration (keyboard-layout keyboard-layout)))

   ;; (simple-service 'add-extra-hosts hosts-service-type
   ;;                 (list (host "20.205.243.166" "github.com")))

   ;; This is the default list of services we
   ;; are appending to.
   ;; %desktop-services
   (modify-services
    %desktop-services
    (guix-service-type
     config => (guix-configuration
                (inherit config)
                (substitute-urls
                 `(
                   "https://mirror.sjtu.edu.cn/guix"
                   "https://substitutes.nonguix.org"
                   .
                   ,%default-substitute-urls
                   ))
                (authorized-keys
                 (cons*
                  (local-file "./signing-key.pub")
                  %default-authorized-guix-keys)))))))
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space (target (uuid "c91525bf-6455-4336-8a56-88646474d281")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems
  (cons*
   (file-system
    (mount-point "/boot/efi")
    (device (uuid "5CFB-701D" 'fat32))
    (type "vfat"))
   (file-system
    (mount-point "/")
    (device (uuid "e3ccaed3-9c67-4435-91c0-ebc15dd9dd32" 'ext4))
    (type "ext4"))
   (file-system
    (mount-point "/home")
    (device (uuid "93751e72-282a-4028-bf77-77ea392f956b" 'ext4))
    (type "ext4"))
   %base-file-systems))
 )
