;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; ansi-term auto bash
(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(global-prettify-symbols-mode 1)

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; Get that customize shit out of my face
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Vim mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t))

;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-mode-fuzzy-match 1)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50))

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

;; Helm for Projectile
(use-package helm-projectile
  :ensure t)

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :ensure t
  :config
  (rainbow-delimiters-mode 1)
  :init
  (add-hook 'lisp-mode-hook #'ranbow-delimiters-mode))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; clojure-mode
(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'"  . clojure-mode)
	 ("\\.edn\\'"  . clojure-mode)
	 ("\\.cljs\\'" . clojure-mode))
  :init
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

;; clojure-refactor-mode
(use-package clj-refactor
  :ensure t)

;; cider
(use-package cider
  :ensure t
  :defer t
  :init (add-hook 'cider-mode-hook #'clj-refactor-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t                  
	cider-repl-display-in-current-window t
	cider-repl-use-clojure-font-lock t    
	cider-prompt-save-file-on-load 'always-save
	cider-font-lock-dynamically '(macro core function var)
	nrepl-hide-special-buffers t            
	cider-overlays-use-font-lock t)         
  (cider-repl-toggle-pretty-printing))

;; smart mode-line
(use-package smart-mode-line
  :ensure t
  :config
  (sml/setup))

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

;; Custom functions
(defun open-dot-emacs-file ()
  "open up .emacs file in the current buffer"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

;; Custom keybindings
(use-package general
  :ensure t
  :config

  ;; Without leader key
  (general-define-key
   :states '(normal visual emacs)
   "TAB" '(switch-to-last-buffer :which-key "Goto previous buffer"))

  ;; With leader key
  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   ;; General
   "j"   '(evil-scroll-down :which-key "Scroll down")
   "k"   '(evil-scroll-up :which-key "Scoll up")
   ;; Buffers
   "bb" '(helm-buffers-list :which-key "buffers list")
   ;; Window
   "wl"  '(windmove-right :which-key "move right")
   "wh"  '(windmove-left :which-key "move left")
   "wk"  '(windmove-up :which-key "move up")
   "wj"  '(windmove-down :which-key "move bottom")
   "ws"  '(split-window-below :which-key "split horizontal")
   "wv"  '(split-window-right :which-key "split vertical")
   ;; Select
   "vf"  '(mark-sexp :which-key "select form")
   ;; Files
   "SPC"  '(helm-projectile :which-key "find files")
   "fe"  '(open-dot-emacs-file :which-key "open .emacs"))

  ;; visual mode with leader key
  (general-define-key
   :states '(visual)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "c" '(comment-or-uncomment-region :which-key "comment selection"))


  ;; Projectile
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "p" '(projectile-command-map :which-key "projectile"))

  ;; Terminal
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ta" '(ansi-term :which-key "ansi-term")
   "te" '(eshell :which-key "eshell"))

  ;; Clojure
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   :keymaps 'clojure-mode-map
   ;; Cider
   "ss" '(cider-eval-last-sexp :which-key "eval last sexp")
   "sc" '(cider-eval-defun-to-comment :which-key "eval comment")
   "sr" '(cider-restart :which-key "restart cider")
   "sb" '(cider-eval-buffer :which-key "eval buffer")
   "sj" '(cider-jack-in :which-key "cider-jack-in")
   ;; Clojure-mode
   "ma" '(clojure-align :which-key "align code")
   "mf" '(cljr-promote-function :which-key "promote function")))
