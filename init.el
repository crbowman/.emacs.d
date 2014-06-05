(when (version< emacs-version "24.1")
  (error "Configuration requires at least GNU Emacs 24.1, youre running %s" emacs-version))

(add-to-list 'load-path "~/.emacs.d")

(require 'my-packages)
(require 'ui)
(require 'my-term)
(require 'my-python)
(require 'utils)
(require 'keybindings)

(if (equal system-type 'darwin)
    (progn
      (require 'osx)))


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
