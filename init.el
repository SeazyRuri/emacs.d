;; -*- lexical-binding: t -*-
(setq debug-on-error t)

;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

(let ((minver "24.4"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "25.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Adjust garbage collection thresholds during startup, and thereafter
;;----------------------------------------------------------------------------
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'wgrep)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'command-log-mode)
(require 'init-my-locales)
(require 'init-frame-hooks)
(require 'init-xterm)
(require 'init-themes)
(require 'init-osx-keys)
(require 'init-gui-frames)
(require 'init-dired)
(require 'init-isearch)
(require 'init-grep)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flycheck)

(require 'init-recentf)
(require 'init-smex)
(require 'init-ivy)
;;(require 'init-helm)
(require 'init-hippie-expand)
(require 'init-company)
(require 'init-windows)
(require 'init-sessions)
(require 'init-mmm)

(require 'init-editing-utils)
(require 'init-whitespace)

(require 'init-vc)
(require 'init-darcs)
(require 'init-git)
(require 'init-github)

(require 'init-projectile)

(require 'init-compile)
;;(require 'init-crontab)
(require 'init-textile)
(require 'init-markdown)
(require 'init-csv)
(require 'init-erlang)
(require 'init-javascript)
(require 'init-php)
(require 'init-org)
(require 'init-nxml)
(require 'init-html)
(require 'init-css)
(require 'init-haml)
(require 'init-http)
(require 'init-python)
(require 'init-haskell)
(require 'init-elm)
(require 'init-purescript)
(require 'init-ruby)
(require 'init-rails)
(require 'init-sql)
(require 'init-rust)
(require 'init-toml)
(require 'init-yaml)
(require 'init-docker)
(require 'init-terraform)
;;(require 'init-nix)
(maybe-require-package 'nginx-mode)

(require 'init-paredit)
(require 'init-lisp)
(require 'init-slime)
(require 'init-clojure)
(require 'init-clojure-cider)
(require 'init-common-lisp)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(require 'init-misc)

(require 'init-folding)
(require 'init-dash)

;;(require 'init-twitter)
;; (require 'init-mu)
(require 'init-ledger)
;; Extra packages which don't require any configuration
(require-package 'gnuplot)
(require-package 'lua-mode)
(require-package 'htmlize)
(require-package 'dsvn)
(when *is-a-mac*
  (require-package 'osx-location))
(unless (eq system-type 'windows-nt)
  (maybe-require-package 'daemons))
(maybe-require-package 'dotenv-mode)

(when (maybe-require-package 'uptimes)
  (setq-default uptimes-keep-count 200)
  (add-hook 'after-init-hook (lambda () (require 'uptimes))))


;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
  (load custom-file))


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
;;(require 'init-locales)


;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
;;(require 'init-local nil t)

;;(add-to-list 'load-path "./tern/emacs")
;;(autoload 'tern-mode "e:/emacs/.emacs.d/tern/emacs/tern.el" nil t)
;;(add-hook 'js-mode-hook (lambda () (tern-mode t)))
;; (eval-after-load 'tern '(progn
;;                           (require 'tern-auto-complete)
;;                           (tern-ac-setup)))

(setq org-log-done 'time)
(require 'tide)
(setenv "PATH" "D:/Program Files/node-v8.1.3-win-x64;E:/emacs/bin")
;;(when (memq window-system '(mac ns x))  (exec-path-from-shell-initialize))

;; using comint mode with node
(defun node-repl ()
  "Node Repl."
  (interactive)
  (setenv "NODE_NO_READLINE" "1") ;avoid fancy terminal codes
  (pop-to-buffer (make-comint "node-repl" "node" nil "--interactive")))
;;(node-repl)
;; provide a git bash shell
(setq explicit-shell-file-name "D:/Program Files (x86)/Git/bin/bash.exe")
(setq shell-file-name explicit-shell-file-name)
(add-to-list 'exec-path "D:/Program Files (x86)/Git/bin/")

(defun run-cmd ()
  "Run windows system cmd outside Emacs."
  (interactive)
  (w32-shell-execute "open" "cmd.exe"))
(defun run-bash ()
  "Run git bash outside Emacs."
  (interactive)
  (w32-shell-execute "open" "git-bash.exe"))
(require 'init-pyim)
(require 'init-web-mode)
(require 'init-tide)

(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
