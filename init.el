
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
(require 'my-latex)


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
 '(package-selected-packages
   (quote
    (edit-server volatile-highlights rainbow-mode python-mode python-environment projectile powerline paredit magit jedi helm flycheck f ess diminish color-theme-solarized color-theme cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


