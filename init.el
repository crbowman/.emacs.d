(when (version< emacs-version "24.1")
  (error "Configuration requires at least GNU Emacs 24.1, youre running %s" emacs-version))

(add-to-list 'load-path "~/.emacs.d")

(require 'my-packages)
(require 'ui)
(require 'my-term)
(require 'my-python)
(require 'my-emacs-lisp)
(require 'my-clojure)			
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

;; don't use tabs
(setq indent-tabs-mode nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("0e121ff9bef6937edad8dfcff7d88ac9219b5b4f1570fd1702e546a80dba0832" default)))
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
