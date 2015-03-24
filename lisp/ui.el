;; Remove GUI stuff 
(setq inhibit-startup-message t)
;; (global-font-lock-mode t)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))   

(blink-cursor-mode 0)

(setq ring-bell-function 'ignore)

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode 1)))

;; (require 'powerline)
;; (powerline-center-theme)

(when (require 'diminish nil 'noerror)
  (eval-after-load "projectile"
    '(diminish 'projectile-mode "proj"))
  (eval-after-load "paredit"
    '(diminish 'paredit-mode "paredit"))
  (eval-after-load "auto-complete"
    '(diminish 'auto-complete-mode nil)))

;; Start in fullscreen
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;; Disable auto saves and backups
(setq backup-inhibited t)
(setq auto-save-default nil)

;; No line wrapping
(setq truncate-lines t)
(setq truncate-partial-width-windows t)

;; y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

(setq initial-scratch-message "")

(setq nrepl-hide-special-buffers t)

;; Nice scrolling 
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Line numbers
(global-linum-mode t)

(if (display-graphic-p)
    (progn
      ())
      (setq linum-format "%4d\u2502 "))

(if (not (display-graphic-p))
(progn 
  (custom-set-faces
   '(linum ((t (:inherit (shadow default) :foreground "white")))))))

;; Mode line
(column-number-mode t)
(size-indication-mode t)

;; make fringe smaller (pixels)
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

;; Highlight Current Line
(global-hl-line-mode t)


;; Color Theme
(require 'molokai-theme)
(load-theme 'molokai t)

(require 'edit-server)
(edit-server-start)

(provide 'ui)
