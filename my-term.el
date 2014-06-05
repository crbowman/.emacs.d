;; Use emacs terminfo, not system terminfo
(setq system-uses-terminfo nil)

;; Use utf-8 in ansi-term
(defadvice ansi-term (after advise-ansi-term-coding-system)
    (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

(setq ansi-color-for-comint-mode t)

(if (equal system-type 'darwin)
    (progn 
      (setenv "LC_CTYPE" "UTF-8")))

;; Start a shell
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (kill-buffer "*scratch*")
	    (ansi-term "/usr/local/bin/zsh")))

(provide 'my-term)
