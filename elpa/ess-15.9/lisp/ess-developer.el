;;; ess-developer.el --- Developer mode for R.

;; Copyright (C) 2011-2015 V. Spinu, A.J. Rossini, Richard M. Heiberger, Martin
;;      Maechler, Kurt Hornik, Rodney Sparapani, and Stephen Eglen.

;; Author: Vitalie Spinu
;; Created: 12-11-2011
;; Maintainer: ESS-core <ESS-core@r-project.org>

;; Keywords: languages, tools

;; This file is part of ESS.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; A copy of the GNU General Public License is available at
;; http://www.r-project.org/Licenses/

;;; Commentary:

;; see apropriate documentation section of ESS user manual

;;; Code:

;; (require 'ess-site) ;; need to assigne the keys in the map

(defgroup ess-developer nil
  "ESS: developer."
  :group 'ess
  :prefix "ess-developer-")

(defface ess-developer-indicator-face
  '((((class grayscale)) (:background "DimGray"))
    (((class color) (background light))
     (:foreground "red4"  :bold t ))
    (((class color) (background dark))
     (:foreground "deep sky blue"  :bold t )))
  "Face to highlight mode line process name when developer mode is on."
  :group 'ess-developer)

(defcustom ess-developer-packages nil
  "List of names of R packages you currently develop.
Set this variable to the list of packages you commonly develop or
use `ess-developer-add-package' to modify interactively this
list."
  :group 'ess-developer
  :type 'list)

(defcustom ess-developer-load-package-command "library(devtools)\nload_all('%s')\n"
  "Command issued by `ess-developer-load-package'.
 %s is subsituted with the user supplied directory."
  :group 'ess-developer
  :type 'string)

(defvar ess-developer-root-file "DESCRIPTION"
  "If this file is present in the directory, it is considered a
  project root.")

;; (defcustom ess-developer-force-attach nil
;;   "If non-nill all the packages listed in `ess-developer-packages' should be attached
;; when ess-developer mode is turned on."
;;   :group 'ess-developer
;;   :type 'boolean)

(defcustom ess-developer-enter-hook nil
  "Normal hook run on entering `ess-developer' mode."
  :group 'ess-developer
  :type 'hook)

(defcustom ess-developer-exit-hook nil
  "Normal hook run on exiting `ess-developer' mode."
  :group 'ess-developer
  :type 'hook)

(defcustom ess-developer-activate-in-package t
  "If non-nil, `ess-developer' is automatically turned on within R packages.
The activation is triggered only for packages currently listed in
`ess-developer-packages'."
  :group 'ess-developer
  :type 'boolean)

(defcustom ess-developer-load-on-add-commands '(("library" . "library(%n)")
                                                ("load_all" . "library(devtools)\nload_all('%d')"))
  "Alist of available load commands what are proposed for loading
on `ess-developer-add-package'.

  %n is replaced with package name,
  %d is replaced with package directory.

See also `ess-developer-load-package' for related functionality."
  :group 'ess-developer
  :type 'alist)

(defvar ess-developer--load-hist nil)

(defun ess-developer-add-package (&optional attached-only)
  "Add a package to `ess-developer-packages' list.
With prefix argument only choose from among attached packages."
  (interactive "P")
  (ess-force-buffer-current)
  (let* ((packs (ess-get-words-from-vector
                 (format "print(unique(c(.packages(), %s)), max=1e6)\n"
                         (if attached-only "NULL" ".packages(TRUE)"))))
         (cur-pack (ess-developer--get-package-name))
         (sel (ess-completing-read "Add package" packs nil nil nil nil
                                   (unless (member cur-pack ess-developer-packages)
                                     cur-pack)))
         (check-attached (format ".ess_package_attached('%s')\n" sel)))
    (unless (ess-boolean-command check-attached)
      (let* ((fn (if (> (length ess-developer-load-on-add-commands) 1)
                     (ess-completing-read "Package not loaded. Use"
                                          (mapcar 'car ess-developer-load-on-add-commands) nil t
                                          nil 'ess-developer--load-hist
                                          (car ess-developer--load-hist))
                   (caar ess-developer-load-on-add-commands)))
             (cmd (cdr (assoc fn ess-developer-load-on-add-commands))))
        (setq cmd (replace-regexp-in-string "%n" sel cmd))
        (when (string-match-p "%d" cmd)
          (let ((dir (read-directory-name
                      "Package: " (ess-developer--get-package-path sel) nil t nil)))
            (setq cmd (replace-regexp-in-string "%d" dir cmd))))
        (ess-eval-linewise (concat cmd "\n")))
      (ess-wait-for-process)
      (when (not (ess-boolean-command check-attached))
        (error "Package '%s' could not be added" sel)))
    (setq ess-developer-packages
          (ess-uniq-list (append ess-developer-packages (list sel))))
    ;; turn developer in all files from selected package
    (ess-developer-activate-in-package sel 'all)
    (message "You are developing: %s" ess-developer-packages)))

(defun ess-developer-remove-package ()
  "Remove packages from `ess-developer-packages' list; defaults to *ALL*."
  (interactive)
  (unless ess-developer-packages
    (error "Nothing to remove, 'ess-developer-packages' is empty"))
  (let ((sel (ess-completing-read "Remove package(s)"
                                  (append ess-developer-packages (list "*ALL*"))
                                  nil t nil nil "*ALL*")))
    (if (equal "*ALL*" sel)
        (progn
          (setq ess-developer-packages nil)
          (ess-developer-deactivate-in-package nil 'all)
          (message "Removed *ALL* packages from the `ess-developer-packages' list."))
      (setq ess-developer-packages (delete sel ess-developer-packages))
      (ess-developer-deactivate-in-package sel 'all)
      (message "Removed package '%s' from the `ess-developer-packages' list"
               (propertize sel 'face 'font-lock-function-name-face)))))

(defun ess-developer-send-region-fallback (proc beg end visibly &optional message tracebug func)
  (if tracebug
      (ess-tracebug-send-region proc beg end visibly message t)
    (ess-send-region proc beg end visibly message)))

(defun ess-developer-source-current-file (&optional filename)
  "Ask for namespace to source the current file into.
If *current* is selected just invoke source('file_name'),
otherwise call devSource."
  (interactive)
  (ess-force-buffer-current "R process to use: ")
  (unless ess-developer
    (error "Ess-developer mode is not active"))
  (if (not (or filename
               buffer-file-name))
      (error "Buffer '%s' doesn't visit a file" (buffer-name (current-buffer)))
    (let* ((filename (or filename buffer-file-name))
           (file (file-name-nondirectory filename))
           (all-packs (append ess-developer-packages (list "*current*" )))
           (default (car (member (car ess-developer--hist) all-packs)))
           (env (ess-completing-read (format "devSource '%s' into" file)
                                     all-packs nil t nil 'ess-developer--hist default))
           (comm  (if (equal env "*current*")
                      (format "source(file=\"%s\", local=F)\n cat(\"Sourced file '%s' into\", capture.output(environment()), '\n')" filename file)
                    (format ".essDev_source(source='%s',package='%s')" filename env))))
      (when (buffer-modified-p) (save-buffer))
      (message "devSourcing '%s' ..." file)
      (ess-developer--command comm 'ess-developer--propertize-output))))

(defun ess-developer--exists-in-ns (var ns)
  ;; If namespace does not exist, the R code below throw an error. But that's equivalent to FALSE.
  (let ((cmd "as.character(exists('%s', envir=asNamespace('%s'), mode='function', inherits=FALSE))\n"))
    (ess-boolean-command
     (format cmd var ns))))

(defun ess-developer-send-function (proc beg end name &optional visibly message tracebug)
  (save-excursion
    (if (null ess-developer-packages)
        (error "`ess-developer-packages' is empty (add packages with C-c C-t C-a).")
      (if (null name)
          (error "Oops, could not find function name (probably a regexp bug)")
        (let ((nms (ess-get-words-from-vector "loadedNamespaces()\n"))
              (dev-packs ess-developer-packages)
              (default-ns (ess-developer--get-package-name))
              assigned-p ns)
          (if (string-match-p ess-set-function-start (concat name "("))
              ;; if setMethod, setClass etc, do send region 
              (ess-developer-send-region proc beg end visibly message tracebug)
            (when tracebug (ess-tracebug-set-last-input proc))
            (if (member default-ns dev-packs)
                (ess-developer-devSource beg end default-ns message)
              ;; iterate over all developed packages and check if functions
              ;; exists in that namespace
              (while (and (setq ns (pop dev-packs))
                          (not assigned-p))
                (when (and (member ns nms)
                           (ess-developer--exists-in-ns name ns))
                  (ess-developer-devSource beg end ns message)
                  (setq assigned-p t)))
              ;; last resort - assign in current env 
              (unless assigned-p
                (ess-developer-send-region-fallback proc beg end visibly message tracebug)))))))))

(defvar ess-developer--hist nil)

(defun ess-developer-send-region (proc beg end &optional visibly message tracebug)
  "Ask for for the package and devSource region into it."
  (let* ((all-packs (append ess-developer-packages (list "*current*" )))
         (default (car (member (car ess-developer--hist) all-packs)))
         (package
          (ess-completing-read "devEval into" all-packs
                               nil t nil 'ess-developer--hist default)))
    (message  (if message (format "dev%s ..." message)))
    (if (equal package "*current*")
        (ess-developer-send-region-fallback proc beg end visibly message tracebug)
      ;; else, (ignore VISIBLY here)
      (ess-developer-devSource beg end package message))))

(defun ess-developer-devSource (beg end package &optional message)
  (let* ((ess-eval-command
          (format ".essDev.eval(\"%s\", package=\"%s\", file=\"%s\")" "%s" package "%f"))
         (ess-eval-visibly-command ess-eval-command)
         (ess-eval-visibly-noecho-command ess-eval-command))
    (if message (message message))
    (ess-developer--command (ess--make-source-refd-command beg end)
                            'ess-developer--propertize-output)))

(defun ess-developer--command (comm &optional propertize-func)
  "Evaluate the command and popup a message with the output if succed.
On error  insert the error at the end of the inferior-ess buffer.

PROPERTIZE-FUNC is a function called with the output buffer being
current. usually used to manipulate the output, for example to
propertize output text.
"
  (setq comm (format "eval({cat(\"\\n\")\n%s\ncat(\"!@OK@!\")})\n" comm))
  (let ((buff (get-buffer-create " *ess-command-output*"))
        out)
    (ess-command comm buff nil nil 0.1)
    (with-current-buffer buff
      (goto-char (point-min))
      (delete-region (point) (min (point-max) ;; delete + + +
                                  (1+ (point-at-eol))))
      (goto-char (point-max))
      (if (re-search-backward "!@OK@!" nil t)
          (progn
            (when (fboundp propertize-func)
              (save-excursion (funcall propertize-func)))
            (message "%s" (buffer-substring (point-min) (max (point-min)
                                                             (1- (point))))))
        (message "%s" (buffer-substring-no-properties (point-min) (point-max)))))))

(defun ess-developer--propertize-output ()
  (goto-char (point-min))
  (while (re-search-forward "\\(FUN\\|CLS\\|METH\\)\\[" nil t)
    (put-text-property (match-beginning 1) (match-end 1)
                       'face 'font-lock-function-name-face))
  (goto-char (point-min))
  (while (re-search-forward "\\([^ \t]+\\):" nil t)
    (put-text-property (match-beginning 1) (match-end 1)
                       'face 'font-lock-keyword-face)))

(defvar ess-developer--pack-name nil)
(make-variable-buffer-local 'ess-developer--pack-name)

(defun ess-developer--get-package-path (&optional pack-name)
  "Get the root of R package that contains current directory.
Root is determined by locating `ess-developer-root-file'.

If PACK-NAME is given, iterate over default-directories of all
open R files till package with name pack-name is found. If not
found, return nil."
  (if pack-name
      (let ((bl (buffer-list))
            path bf)
        (while (and (setq bf (pop bl))
                    (not path))
          (when (buffer-local-value 'ess-dialect bf)
            (with-current-buffer bf
              (setq path (ess-developer--get-package-path))
              (unless (equal pack-name (ess-developer--get-package-name))
                (setq path nil)))))
        path)
    (let ((path (directory-file-name default-directory)))
      (when (string= "R" (file-name-nondirectory path))
        (setq path (file-name-directory path))
        (when (file-exists-p (expand-file-name ess-developer-root-file path))
          path)))
    ;; This following version is incredibly slow on remotes:
    ;; (let ((path default-directory)
    ;;       opath package)
    ;;   (while (and path
    ;;               (not package)
    ;;               (not (equal path opath)))
    ;;     (if (file-exists-p (expand-file-name ess-developer-root-file path))
    ;;         (setq package path)
    ;;       (setq opath path
    ;;             path (file-name-directory (directory-file-name path)))))
    ;;   package)
    ))

(defun ess-developer--get-package-name (&optional path force)
  "Find package name in path. Parses DESCRIPTION file in PATH (R
specific so far). PATH defaults to the value returned
by (ess-developer--get-package-path).

If FORCE is non-nil, don't check for buffer local cached value of
the package name."
  (or (and (not force)
           ess-developer--pack-name)
      (when (setq path (or path (ess-developer--get-package-path)))
        (let ((file (expand-file-name ess-developer-root-file path))
              (case-fold-search t))
          (when (file-exists-p file)
            (with-temp-buffer
              (insert-file-contents file)
              (goto-char (point-min))
              (re-search-forward "package: \\(.*\\)")
              (setq ess-developer--pack-name (match-string 1))))))))

(defun ess-developer-activate-in-package (&optional package all)
  "Activate developer if current file is part of a package which
is registered in `ess-developer-packages'.

If PACKAGE is given, activate only if current file is part of the
PACKAGE, `ess-developer-packages' is ignored in this case.

If ALL is non-nil, perform activation in all R buffers.

This function does nothing if `ess-developer-activate-in-package'
is nil."
  (when ess-developer-activate-in-package
    (if all
        (dolist (bf (buffer-list))
          (with-current-buffer bf
            (ess-developer-activate-in-package package)))
      (let ((pack (ess-developer--get-package-name)))
        (when (and buffer-file-name
                   pack
                   (not ess-developer)
                   (if package
                       (equal pack package)
                     (member pack ess-developer-packages)))
          (ess-developer t))))))

(defun ess-developer-deactivate-in-package (&optional package all)
  "Deactivate developer if current file is part of the R package.

If PACKAGE is given, deactivate only if current package is
PACKAGE.

If ALL is non-nil, deactivate in all open R buffers."
  (if all
      (dolist (bf (buffer-list))
        (with-current-buffer bf
          (ess-developer-deactivate-in-package package)))
    (let ((pack (ess-developer--get-package-name)))
      (when (and ess-developer
                 (or (null package)
                     (equal pack package)))
        (ess-developer -1)))))

(defun ess-developer-load-package ()
  "Interface to load_all function from devtools package."
  (interactive)
  (ess-force-buffer-current)
  (let ((package (ess-developer--get-package-path)))
    (unless (and package ess-developer)
      ;; ask only when not obvious
      (setq package
            (read-directory-name "Package: " package nil t nil)))
    (unless (file-exists-p (expand-file-name ess-developer-root-file package))
      (error "Not a valid package. No '%s' found in `%s'."
             ess-developer-root-file package))
    (message "Loading %s" (abbreviate-file-name package))
    (ess-eval-linewise
     (format ess-developer-load-package-command package))))

(defvar ess-developer nil
  "Non nil in buffers where developer mode is active")
(make-variable-buffer-local 'ess-developer)

;; Since the ESSR package, this one is not needed:
;; (defun ess-developer--inject-source-maybe ()
;;   ;; puting this into ESSR.R makes loading very slow
;;   ;; when ESSR is a package, this should go away
;;   (let ((devR-file (concat (file-name-directory ess-etc-directory)
;;                            "ess-developer.R")))
;;     (unless (ess-boolean-command
;;              "exists('.essDev_source', envir = .ESSR_Env)\n")
;;       (unless (file-exists-p devR-file)
;;         (error "Cannot locate 'ess-developer.R' file"))
;;       (message "Injecting ess-developer code ...")
;;       (ess--inject-code-from-file devR-file)
;;       (unless (ess-boolean-command "exists('.essDev_source', envir = .ESSR_Env)\n")
;;         (error "Could not source ess-developer.R. Please investigate the output of *ess-command-output* buffer for errors")))))

(defun ess-developer (&optional val)
  "Toggle on/off `ess-developer' functionality.
If optional VAL is non-negative, turn on the developer mode. If
VAL is negative turn it off.

See also `ess-developer-packages', `ess-developer-add-package'
and `ess-developer-activate-in-package'."
  (interactive)
  (when (eq val t) (setq val 1))
  (let ((ess-dev  (if (numberp val)
                      (if (< val 0) nil t)
                    (not ess-developer))))
    (if ess-dev
        (progn
          (run-hooks 'ess-developer-enter-hook)
          (if ess-developer-packages
              (message "You are developing: %s" ess-developer-packages)
            (message "Developer is on (add packages with C-c C-t a)")))
      (run-hooks 'ess-developer-exit-hook)
      (message "%s developer is off" (if (get-buffer-process (current-buffer))
                                              "Global"
                                            "Local")))

    (setq ess-developer ess-dev))
    (force-window-update))

(defalias 'ess-toggle-developer 'ess-developer)



;;; MODELINE

(defvar ess-developer--local-indicator
  '(""
    (:eval
     ;; process has priority
     (if (and (ess-process-live-p)
              (ess-get-process-variable 'ess-developer))
         (propertize " D" 'face 'ess-developer-indicator-face)
       (if ess-developer
           (propertize " d" 'face 'ess-developer-indicator-face)
         "")))))
(put 'ess-developer--local-indicator 'risky-local-variable t)

(defun ess-developer-setup-modeline ()
  (add-to-list 'ess--local-mode-line-process-indicator
               'ess-developer--local-indicator 'append))



;;; HOOKS

(add-hook 'R-mode-hook 'ess-developer-activate-in-package)
(add-hook 'R-mode-hook 'ess-developer-setup-modeline)
(add-hook 'inferior-ess-mode-hook 'ess-developer-setup-modeline)

(provide 'ess-developer)
;;; ess-developer.el ends here
