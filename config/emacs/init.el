;; emacs

(column-number-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(line-number-mode 1)
(set-default-coding-systems 'utf-8-unix)
(set-language-environment "UTF-8")
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq sentence-end-double-space nil)
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)
(show-paren-mode 1)
(xterm-mouse-mode 1)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq default-frame-alist
      '((font . "Fira Code-12")
        (fullscreen . maximized)))
(set-display-table-slot standard-display-table
                        'vertical-border
                        (make-glyph-code ?│))

(add-hook 'term-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)
            (setq show-trailing-whitespace nil)))

(advice-add 'term-handle-exit :after
            (lambda (&optional process-name msg)
              (let ((win (get-buffer-window)))
                (kill-buffer)
                (ignore-errors (delete-window win)))))

;; library

(let ((default-directory "~/.emacs.d/lisp/community"))
  (setq load-path
        (append
         (let ((load-path (copy-sequence load-path)))
           (normal-top-level-add-to-load-path
            (delete ".." (delete "." (directory-files default-directory)))))
         load-path)))

;; package

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(setq package-user-dir "~/.config/emacs/elpa")
(setq package-gnupghome-dir "~/.config/emacs/elpa/gnupg")
(package-initialize)

(setq package-selected-packages '(## slime magit evil))

;; doom-modeline

(require 'doom-modeline)

(doom-modeline-mode 1)

;; evil

(setq evil-want-keybinding nil)

(require 'evil)
(require 'evil-collection)
(require 'evil-surround)

(defun visual-search (begin end type forward)
  (unless (eq type 'block)
    (let ((selection (regexp-quote (buffer-substring begin end))))
      (setq isearch-forward forward)
      (evil-search selection forward t))))

(evil-define-operator visualstar (begin end type)
  :repeat nil
  (visual-search begin end type t))

(evil-define-operator visualhashtag (begin end type)
  :repeat nil
  (visual-search begin end type nil))

(setq evil-overriding-maps nil)
(setq evil-split-window-below t)
(setq evil-start-of-line t)
(setq evil-vsplit-window-right t)
(setq evil-want-C-u-delete t)
(setq evil-want-C-u-scroll t)
(setq evil-want-Y-yank-to-eol t)

(define-key evil-ex-completion-map "\C-A" [home])
(define-key evil-insert-state-map "\C-A" [home])
(define-key evil-insert-state-map "\C-E" [end])
(define-key evil-insert-state-map "\C-L" 'evil-ex-nohighlight)
(define-key evil-motion-state-map "'" 'evil-goto-mark)
(define-key evil-motion-state-map "`" 'evil-goto-mark-line)
(define-key evil-normal-state-map "K" "\C-Wn\M-Xterm")
(define-key evil-normal-state-map "Q" 'evil-quit)
(define-key evil-normal-state-map "\C-J" "\C-Wj")
(define-key evil-normal-state-map "\C-K" "\C-Wk")
(define-key evil-normal-state-map "\C-L" ":nohlsearch\C-M\M-Xredraw-display")
(define-key evil-normal-state-map "\C-N" ":bnext")
(define-key evil-normal-state-map "\C-P" ":bprevious")
(define-key evil-visual-state-map "*" 'visualstar)
(define-key evil-visual-state-map "#" 'visualhashtag)
(define-key evil-visual-state-map "M" ":sort")

(evil-mode 1)
(evil-collection-init)
(global-evil-surround-mode 1)

;; git-gutter

(require 'git-gutter)

(global-git-gutter-mode 1)

;; magit

(setq transient-save-history nil)

;; slime

(setq inferior-lisp-program "sbcl")

;; theme

(require 'dracula-theme)
(require 'kaolin-themes)
(require 'nord-theme)

(load-theme 'kaolin-dark t)
