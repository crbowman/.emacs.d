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
;; (add-hook 'emacs-startup-hook
;; 	  (lambda ()
;; 	    (kill-buffer "*scratch*")
;; 	    (ansi-term "/usr/local/bin/zsh")))

;; Sytntax higlighting for .zsh files
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

(require 'term)
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/usr/local/bin/zsh")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd)))))
(global-set-key (kbd "<f2>") 'visit-ansi-term)

(provide 'my-term)
