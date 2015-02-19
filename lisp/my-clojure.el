
(require-packages '(clojure-mode cider))

(eval-after-load 'clojure-mode
  '(progn
     (defun clojure-mode-defaults ()
       (subword-mode +1)
       (paredit-mode +1)
       (show-paren-mode +1)
       (electric-indent-mode +1))

     (setq my-clojure-mode-hook 'clojure-mode-defaults)
  
     (add-hook 'clojure-mode-hook (lambda ()
				    (run-hooks 'my-clojure-mode-hook)))))

(eval-after-load 'cider
  '(progn 
    (setq nrepl-log-messages t)
     
    (add-hook 'cider-mode-hook  'cider-turn-on-eldoc-mode)
     
     (defun cider-repl-mode-defaults ()
       (subword-mode +1)
       (setq cider-show-error-buffer nil)
       (setq cider-repl-print-length 100)
       (setq cider-repl-use-clojure-font-lock t)
       (setq cider-repl-use-pretty-printing t)
       (font-lock-mode -1)
       (show-paren-mode +1))
     
     (setq my-cider-repl-mode-hook 'cider-repl-mode-defaults)
     
     (add-hook 'cider-repl-mode-hook (lambda ()
     				       (run-hooks 'my-cider-repl-mode-hook)))))

(provide 'my-clojure)
