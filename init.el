;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

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
  (load-theme 'doom-solarized-light t))

;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50))

;; rainbow-delimieters
(use-package rainbow-delimiters
  :ensure t
  :config
  (rainbow-delimiters-mode 1))

;; clojure-mode
(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'"  . clojure-mode)
         ("\\.edn\\'"  . clojure-mode)
	 ("\\.cljs\\'" . clojure-mode))
  :init
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

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

;; Custom keybinding
(use-package general
  :ensure t
  :config ((general-define-key
	   :states '(normal visual insert emacs)
	   :prefix "SPC"
	   :non-normal-prefix "M-SPC"
	   ;; General
	   "m" '(helm-M-x :which-key "M-x")
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
	   ;; Files
	   "SPC"  '(helm-find-files :which-key "find files")
	   "fe"  '(open-dot-emacs-file :which-key "open .emacs")
	   (general-define-key
	   :states '(normal visual insert emacs)
	   :prefix "SPC"
	   :non-normal-prefix "M-SPC"
	   :keymaps 'clojure-mode-map
	   ;; Cider
	   "ss" '(cider-eval-last-sexp :which-key "eval-last-sexp"))))
