
(require-packages '(clojure-mode cider))

(defvar electrify-return-match
  "[\]}\)\"]" 
  "If this regex matches the text after the coursor, do an electric return.")

(defun elictify-return-if-match
  "If the text after the cursor matches electrify-return-match, then open and 
   indent an empty line between the cursor and the text. Move the cursor to 
   the new line"
  (interactive "P")
  (let ((case-fold-search nil))
    (if (looking-at electrify-return-match)
	(save-excursion (newline-and-indent)))
    (newline arg)
    (indent-according-to-mode)))

(eval-after-load 'clojure-mode
  '(progn
     (defun clojure-mode-defaults ()
       (subword-mode +1)
       (paredit-mode +1)
       (show-paren-mode +1))

     (setq my-clojure-mode-hook 'clojure-mode-defaults)
     
     (add-hook 'clojure-mode-hook (local-set-key 
				   (kdb "RET") 'electrify-return-if-match))
     
     (add-hook 'clojure-mode-hook (lambda ()
				    (run-hooks 'my-clojure-mode-hook)))))

(eval-after-load 'cider
  '(progn 
     (setq nrepl-log-messages t)
     
     (add-hook 'cider-mode-hook  'cider-turn-on-eldoc-mode)
     
     (defun cider-repl-mode-defaults ()
       (subword-mode +1)
       (paredit-mode +1)
       (show-paren-mode +1))

     (setq my-cider-repl-mode-hook 'cider-repl-mode-defaults)
     
     (add-hook 'cider-repl-mode-hook (lambda ()
				       (run-hooks 'my-cider-repl-mode-hook)))))

(provide 'my-clojure)
