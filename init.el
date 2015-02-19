(when (version< emacs-version "24.1")
  (error "Configuration requires at least GNU Emacs 24.1, youre running %s" emacs-version))

(add-to-list 'load-path "~/.emacs.d/lisp")
(let ((default-directory "~/.emacs.d/themes/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'my-packages)
(require 'my-clojure)			
(require 'ui)
(require 'my-term)
(require 'my-python)
(require 'my-emacs-lisp)
(require 'utils)
(require 'keybindings)


(if (equal system-type 'darwin)
    (progn
      (require 'osx)))

;; gc every 50MB of allocated data
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Projectile
(projectile-global-mode)

(flyspell-mode 'on)

;; Ido mode
(require 'ido)
(ido-mode t)

;; Autocomplete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-show-menu-immediately-on-auto-complete t)

;; Tramp
(add-to-list 'load-path "~/.emacs.d/elpa/tramp-2.2.11/lisp/")
(add-to-list 'Info-default-directory-list "~/.emacs.d/elpa/tramp-2.2.11/info/")
(setq tramp-default-mode "ssh")

;; don't use tabs
(setq indent-tabs-mode nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector [(\, black) (\, red) (\, green) (\, yellow) (\, blue) (\, magenta) (\, cyan) (\, white)])
 '(custom-safe-themes (quote ("1eb682b0f6a7c769233834c7dea2cf9978f18367b7bd30d0be6760cc27a648aa" "96efbabfb6516f7375cdf85e7781fe7b7249b6e8114676d65337a1ffe78b78d9" "5148ffa59ea0d9af39c0d948c111ed51a09db6de5a230a01e4c276cfde2fd07e" "85afcbfff317888abb64906a983f116d706235d7c329411e363db3c3336de9de" "38febde8e8d2cd007630f58a85bd96eb17f1cc04774a8191c532d38fe33fe611" "50e00207c11691b6f6adc1d6aa06238e43fcea2b404de5fd2f7d90e60a6a383c" "1576abf346ae8b66c0ad08f76412ce70be1d629ac83b5c9c4b58b8ef1804ebed" "fd72df159643fcac4de0adc848cc842715e9ff85edcab08a014a8328dc925ea6" "aa3462bc5929530685df3fb06d4521ee03189e7c38d38f215931d4537c5b5041" "98726a81b8a960d1e7e93b6eef3a0b167a402ba06862911f10782f73e8482a51" "6ab5569edaed30ea85568035596440da2c82d1c53af6ec67acba162228c55cd1" "9face99bce1d2abd65541228ff8d27aa23c934fb61871ba0dc9cf4e288d9c2b8" "e49b024b710858c43958a9360e22c790b76c2dc9197e2ccafa739d980b4a01cf" "942bbad28fb24403ee3a1b1a6113f8d2cfd3590634b85114c80c15469d1c251d" "7bb5a94c2140128c154b756a8ea4a4792e18f5f7a681d7b8bd3cc6183b8ff2b4" "6c35fce850735875fd71067aa34a9c313ac91a2e7e98acebd273d7ad6e5133b4" "09cfdbb8da7a6266af8e68cddda6b1e91ba2f33b749af1a3f9102971c454a737" "6b9131e349fc6de145fe2ac53e664f51194cd1f74bca293325e7f8b29c149260" "9204066903f4ed4964887c04db8f2b7b2a6033909c734edda278b164742f4150" "ec301bc4edb878e900d3f5b59d3d2112ae04e0656497e500ca7c2490ac673d12" "82e9f60d93dd300c01713633a711ef4e0804efa12e4f9514cb7737f9797c9025" "0e121ff9bef6937edad8dfcff7d88ac9219b5b4f1570fd1702e546a80dba0832" default)))
 '(global-rainbow-mode t)
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


