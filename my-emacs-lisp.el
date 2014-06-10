

(defun emacs-lisp-mode-defaults ()
  "Sensible defaults for `emacs-lisp-mode'."
  (turn-on-eldoc-mode)
  (paredit-mode +1)
  (show-paren-mode +1)
  (setq mode-name "EL"))

(setq emacs-lisp-mode-hook 'emacs-lisp-mode-defaults)

(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (run-hooks 'emacs-lisp-mode-hook)))

(add-to-list 'auto-mode-alist '("Cask\\'" . emacs-lisp-mode))

(eval-after-load "eldoc"
  '(diminish 'eldoc-mode))

(provide 'my-emacs-lisp)


