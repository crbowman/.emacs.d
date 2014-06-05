
(require 'my-lisp)
(require-packages '(clojure-mode cider))

(eval-after-load 'clojure-mode
  '(progn
     (defun clojure-mode-defaults ()
       (subword-mode +1)
       (paredit-mode +1)
       (run-hooks 'my-lisp-coding-hooks))

     (setq my-clojure-mode-hook 'prelude-clojure-mode-defaults)
     
     (add-hook 'clojure-mode-hook (lambda ()
				    (run-hooks 'my-clojure-mode-hook)))))

(eval-after-load 'cider
  '(progn 
     (setq nrepl-log-messages t)
     
     (add-hook 'cider-mode-hook (cider-mode +1))

     (defun cider-repl-mode-defaults ()
       (subword-mode +1)
       (run-hooks 'my-lisp-coding-hooks))

     (setq my-cider-repl-mode-hook 'cider-repl-mode-defaults)
     
     (add-hook 'cider-repl-mode-hook (lambda ()
				       (run-hooks 'my-cider-repl-mode-hook)))))

(provide 'my-clojure)
