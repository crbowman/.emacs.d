
;; Python mode
(require 'python-mode)

(add-hook 'python-mode-hook 
	  '(subword-mode +1))

;; Flycheck
(add-hook 'python-mode-hook 
	  'flycheck-mode)

;; IPython
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")
(setq py-force-py-shell-name-p t)
; switch to imterpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute t)
; don't splot windows
;(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)

;; Jedi
(require 'jedi)
(require 'my-jedi)

(setq jedi:server-command 
     '("/Users/curtis/.emacs.d/elpa/jedi-20140321.1323/jediepcserver.py"))

(add-hook 'python-mode-hook 'jedi:setup)

(add-to-list 'ac-sources 'ac-source-jedi-direct)

(provide 'my-python)



