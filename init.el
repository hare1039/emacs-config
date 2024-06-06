(require 'package)
;(package-initialize)
(setq package-check-signature nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'load-path "~/.emacs.d/manual-packages/gud-lldb")
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))

(defvar byte-compile-warnings nil)
(unless (fboundp 'package-activate-all) (package-initialize))

;disable backup
(setq backup-inhibited t)
;disable auto save
(setq auto-save-default 0)

(setq c-default-style "linux"
      c-basic-offset 4)

(add-hook 'html-mode-hook
  (lambda ()
    ;; Default indentation is usually 2 spaces, changing to 4.
    (set (make-local-variable 'sgml-basic-offset) 4)))

;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)
(add-hook 'write-file-hooks
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))
            nil))

(add-hook 'before-save-hook
          'delete-trailing-whitespace)

(setq-default tab-width 4)
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)
(setq package-list '(auto-complete multiple-cursors origami go-mode magit golden-ratio color-theme go-autocomplete yaml-mode toml toml-mode column-enforce-mode))


(global-set-key (kbd "C-x C-b") 'ibuffer)
    (autoload 'ibuffer "ibuffer" "List buffers." t)

(dolist (key '("\C-b" "\C-f" "\C-n" "\C-p" "\C-q" "\C-x\C-r"))
  (global-unset-key key))

(global-set-key (kbd "C-p") 'undo)

(defun custom-c++-mode-hook ()
  (define-key c++-mode-map (kbd "C-c C-a") nil)
  (c-set-offset 'substatement-open 0)
  (auto-complete-mode 1)
  (setq truncate-lines 0))

(add-hook 'c++-mode-hook 'custom-c++-mode-hook)
(add-hook 'c-mode-hook 'custom-c++-mode-hook)

(defun custom-racket-mode-hook ()
  (auto-complete-mode 1)
  (80-column-rule 1)
  (setq truncate-lines 0))
(add-hook 'racket-mode-hook 'custom-racket-mode-hook)

;(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
;(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(electric-pair-mode 1)
(electric-indent-mode 1)
(column-number-mode 1)

;; el-get
;(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;
;(unless (require 'el-get nil 'noerror)
;  (with-current-buffer
;      (url-retrieve-synchronously
;       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
;    (goto-char (point-max))
;    (eval-print-last-sexp)))
;
;(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;(el-get 'sync)

; set from 4820
(load "$HOME/.emacs.d/acl2.el")
(put 'match 'lisp-indent-function 'defun)
(setq line-number-mode t)
(setq column-number-mode t)
(setq visible-bell t)
(setq fill-column 80)
(setq default-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda () (auto-fill-mode 1)))
(add-hook 'text-mode 'turn-on-auto-fill)
(show-paren-mode 1)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)
            (electric-pair-mode 1)))

;(when (< emacs-major-version 24)
;  ;; For important compatibility libraries like cl-lib
;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(package-selected-packages
   '(elpy typescript-mode matlab-mode color-theme 2048-game racket-mode cmake-mode luarocks lua-mode wc-mode markdown-mode company-coq proof-general tuareg column-enforce-mode minesweeper origami toml toml-mode yaml-mode rust-mode golden-ratio epresent tide org ox-gfm multiple-cursors ac-clang bison-mode undo-tree rainbow-mode rainbow-delimiters rjsx-mode magit go-autocomplete exec-path-from-shell go-mode auto-complete))
 '(python-shell-interpreter "python")
 '(truncate-lines nil)
 '(warning-suppress-types
   '(((python python-shell-completion-native-turn-on-maybe))
     (color-theme))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(or (file-exists-p package-user-dir) (package-refresh-contents))
;(unless package-archive-contents
;  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(ac-config-default)

(require 'multiple-cursors)

(global-set-key (kbd "ESC <down>") 'mc/mark-next-like-this)
(global-set-key (kbd "ESC <up>") 'mc/mark-previous-like-this)

;; Go IDE www
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(setenv "GOPATH" "/Users/hare1039/Documents/gopath")

(defun go-mode-hook-x0 ()
      (add-hook 'before-save-hook 'gofmt-before-save)
      ; Godef jump key binding
      (local-set-key (kbd "M-o") 'godef-jump)
      (local-set-key (kbd "M-p") 'pop-tag-mark)
      (auto-complete-mode 1))
(add-hook 'go-mode-hook 'go-mode-hook-x0)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete))

;; go IDE finish

;(eval-after-load "org"
;  '(require 'ox-gfm nil t))


(require 'golden-ratio)
(golden-ratio-mode 1)

(visual-line-mode 1)

(setq gud-key-prefix "\C-c\C-a")
(global-set-key (kbd "C-x C-a") 'magit-status)

(setq dired-listing-switches "-alh")

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (add-hook 'before-save-hook 'tide-format-before-save)
  (tide-hl-identifier-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;(when (require 'org-tree-slide nil t)
;  (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
;  (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)
;  (define-key org-tree-slide-mode-map (kbd "<f7>")
;    'org-tree-slide-move-previous-tree)
;  (define-key org-tree-slide-mode-map (kbd "<f9>")
;    'org-tree-slide-move-next-tree)
;  (define-key org-tree-slide-mode-map (kbd "<f10>")
;    'org-tree-slide-content)
;  (setq org-tree-slide-skip-outline-level 4)
;  (org-tree-slide-narrowing-control-profile)
;  (setq org-tree-slide-skip-done nil))

(add-to-list 'load-path "~/.emacs.d/lisp/")
;(require 'color-theme)
;(setq color-theme-is-global t)
;(color-theme-initialize)
;(load "color-theme-manoj")
(set-default 'truncate-lines t)


;; matlab
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")


;;prolog
;(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
;(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
;(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
;(setq prolog-system 'swi)
;(setq auto-mode-alist (append '(("\\.p$" . prolog-mode)
;                                ("\\.m$" . mercury-mode))
;                               auto-mode-alist))

(add-hook 'markdown-mode-hook '80-column-rule)
(add-hook 'markdown-mode-hook
          '(lambda ()(wc-mode 1)) t)

;; Configure origami
(require 'origami)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'go-mode)
              (origami-mode 1))))
(add-hook 'python-mode-hook
          '(lambda () (origami-mode 1)) t)

(define-key origami-mode-map (kbd "C-q") 'origami-recursively-toggle-node)
(define-key origami-mode-map (kbd "M-q") 'origami-show-only-node)

(require 'gud-lldb)
(defadvice lldb (before gud-query-cmdline activate)
  "Provide a better default command line when called interactively."
  (add-to-list 'exec-path "/usr/bin")
  (setenv "PATH" (concat "/usr/bin" ":" (getenv "PATH"))))
;(custom-set-faces '(org-table ((t (:foreground "WhiteSmoke")))))
(defun lldb-debug()
  (interactive)
  (defvar cmd)
  (setq cmd (concat "make debug"))
  (shell-command cmd)
  (call-interactively 'lldb))
(global-set-key (kbd "C-x C-r") 'lldb-debug)

(require 'column-enforce-mode)
(setq column-enforce-comments nil)
(add-hook 'git-commit-setup-hook 'column-enforce-mode)
(put 'downcase-region 'disabled nil)

;; dired zip/unzip
(eval-after-load "dired-aux"
   '(add-to-list 'dired-compress-file-suffixes
                 '("\\.zip\\'" ".zip" "unzip")))

(eval-after-load "dired"
  '(define-key dired-mode-map "z" 'dired-zip-files))
(defun dired-zip-files (zip-file)
  "Create an archive containing the marked files."
  (interactive "sEnter name of zip file: ")

  ;; create the zip file
  (let ((zip-file (if (string-match ".zip$" zip-file) zip-file (concat zip-file ".zip"))))
    (shell-command
     (concat "zip "
             zip-file
             " "
             (concat-string-list
              (mapcar
               '(lambda (filename)
                  (file-name-nondirectory filename))
               (dired-get-marked-files))))))

  (revert-buffer)

  ;; remove the mark on all the files  "*" to " "
  ;; (dired-change-marks 42 ?\040)
  ;; mark zip file
  ;; (dired-mark-files-regexp (filename-to-regexp zip-file))
  )

(defun concat-string-list (list)
   "Return a string which is a concatenation of all elements of the list separated by spaces"
    (mapconcat '(lambda (obj) (format "%s" obj)) list " "))

;(setenv "JULIA_NUM_THREADS" "4")
;;(add-to-list 'load-path path-to-julia-repl)
;(require 'julia-repl)
;(add-hook 'julia-mode-hook 'julia-repl-mode) ;; always use minor mode

;(julia-repl-set-terminal-backend 'vterm)
;(setq vterm-kill-buffer-on-exit nil)

(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")
