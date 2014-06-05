
(require-packages '(rainbow-delimiters))

(define-key read-expression-map (kbd "TAB") 'completion-at-point)

(defun my-lisp-coding-defaults ()
  (smartparens-strict-mode +1)
  ;; except for quote character
  
  (sp-pair "'" nil :actions nil)

  (sp-pair "'" nil :unless '(sp-point-after-word-p))

  (rainbow-delimeters-mode +1)

(setq my-lisp-coding-hooks 'my-lisp-coding-defaults))

(provide 'my-lisp)
  
