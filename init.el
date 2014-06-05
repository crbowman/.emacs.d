(when (version< emacs-version "24.1")
  (error "Configuration requires at least GNU Emacs 24.1, youre running %s" emacs-version))

(add-to-list 'load-path "~/.emacs.d")

(require 'my-packages)
(require 'ui)
(require 'my-term)
(require 'my-python)
(require 'my-lisp)
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


;; Projectile
(projectile-global-mode)

(iswitchb-mode 1)
(flyspell-mode 'on)

;; Ido mode
(require 'ido)
(ido-mode t)

;; Autopair
(require 'autopair)
(autopair-global-mode)

;; Autocomplete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-show-menu-immediately-on-auto-complete t)

;; don't use tabs
(setq indent-tabs-mode nil)
