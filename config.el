;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;;
;;; Code:

(setq user-full-name "Satyam Shekhar"
      user-mail-address "satyam@netspring.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; "monospace" means use the system default. However, the default is usually two
;; points larger than I'd like, so I specify size 12 here.

;; Set "monaco" font only for Emacs running as native app on MacOs.
;; (when (and (display-graphic-p) (eq system-type 'darwin))
;;   (setq doom-font (font-spec :family "monaco" :size 12 :weight 'semi-light)
;;         doom-variable-pitch-font (font-spec :family "monaco" :size 13)))

;; Variable width font support
(use-package mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one-light)
(setq doom-theme 'sanityinc-tomorrow-day)
(global-hl-line-mode +1)

(custom-theme-set-faces! 'doom-one-light
  `(markdown-code-face :background ,(doom-darken 'bg 0.075))
  `(font-lock-variable-name-face :foreground ,(doom-lighten 'magenta 0.6)))

(custom-theme-set-faces! 'sanityinc-tomorrow-day
  `('hl-line :inherit nil :background "#f9ebff")
  `(mode-line :inherit nil :background "#d6d4d4")
  `(region :background "#cbe9f2")
  `(minibuffer-prompt :foreground "#1671c7")
  `(isearch :background "#ffffff" :foreground "#f24b80" :inverse-video t)
  `(ivy-minibuffer-match-face-2 :foreground "#a72ded")
  `(default :background "#ffffff" :foreground "#2a2a2a")
  `(font-lock-builtin-face :foreground "#8959a8")
  `(font-lock-comment-face :foreground "#636363")
  `(font-lock-comment-delimiter-face :foreground "#636363")
  `(font-lock-constant-face :foreground "#8a501a")
  `(font-lock-doc-face :foreground "#8959a8")
  `(font-lock-function-name-face :foreground "#e34000")
  `(font-lock-keyword-face :foreground "#0e9107")
  `(font-lock-negation-char-face :foreground "#4271ae")
  `(font-lock-preprocessor-face :foreground "#8959a8")
  `(font-lock-regexp-grouping-construct :foreground "#8959a8")
  `(font-lock-string-face :foreground "#2746ab")
  `(font-lock-type-face :foreground "#8a501a")
  `(font-lock-variable-name-face :foreground "#e34000")
  `(popup-tip-face :background "#ffaa6e" :foreground "#010000")
  `(flycheck-error :foreground "red" :underline t)
  `(flycheck-info :foreground "#06750a" :underline t)
  `(flycheck-warning :foreground "#f5871f" :underline t)
  `(highlight-indent-guides-character-face :foreground "#828282")
  `(whitespace-indentation :background nil :foreground "#828282")
  `(fill-column-indicator :foreground "#828282"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; Line numbers are pretty slow all around. The performance boost of
;; disabling them outweighs the utility of always keeping them on.
(setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Add libraries and mode setup to the load path.
(add-load-path! "lib/" "modes/")

;; Disable smartparens since it tends to slow things down.
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)
;; Prevents some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
;; Replace the active region just by typing text, and delete the selected text
;; just by hitting delete.
(delete-selection-mode t)
;; Disable auto-revert (reload) of file buffers while they are loaded to prevent
;; data loss.
(global-auto-revert-mode -1)
;; Shorter filename in modeline.
(setq doom-modeline-buffer-file-name-style 'truncate-all)
;; Set up right option key to work as meta on MacOs.
(when (and (display-graphic-p) (eq system-type 'darwin))
  (setq ns-right-alternate-modifier 'meta))

;; IMO, modern editors have trained a bad habit into us all: a burning
;; need for completion all the time -- as we type, as we breathe, as we
;; pray to the ancient ones -- but how often do you *really* need that
;; information? I say rarely. So opt for manual completion:
(setq company-idle-delay nil)

;; lsp-ui-sideline is redundant with eldoc and much more invasive, so
;; disable it by default.
(setq lsp-ui-sideline-enable nil
      lsp-enable-symbol-highlighting nil)

(after! ivy
  ;; I prefer search matching to be ordered; it's more precise
  (add-to-list 'ivy-re-builders-alist
               '(counsel-projectile-find-file . ivy--regex-plus)))

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("WORKSPACE" . bazel-workspace-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("BUILD" . bazel-build-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.bzl\\'" . bazel-starlark-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '(".bazelrc'" . bazelrc-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup clang-format
(load "clang-format.el")
(add-to-list 'auto-mode-alist '("\\.ipp\\'" . c++-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming

(require 'dud-cpp-mode)
(require 'dud-protobuf-mode)

(setq-default tab-width 2)
(global-auto-revert-mode -1)

(defun dud-cc-mode-hook ()
  (setq fill-column 75)
  (local-set-key (kbd "M-0") 'dud-c-rotate)
  (local-set-key (kbd "M-9") 'dud-c-rotate-rev)
  (local-set-key (kbd "M-=") 'clang-format-buffer))

(defun dud-proto-mode-hook ()
  (setq fill-column 75)
  (local-set-key (kbd "M-=") 'clang-format-buffer))

(defun dud-java-mode-hook()
  (setq fill-column 75)
  (local-set-key (kbd "M-=") 'clang-format-buffer))

(defun dud-sh-mode-hook()
  (setq sh-basic-offset 2)
  (setq sh-indentation 2))

(defun dud-prog-mode-hook ()
  "Customizations to prog-mode."
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq whitespace-line-column 75)
  (highlight-indent-guides-mode)
  (display-fill-column-indicator-mode)
  (subword-mode))

(add-hook! prog-mode 'dud-prog-mode-hook)
(add-hook! markdown-mode 'dud-prog-mode-hook)
(add-hook! protobuf-mode 'dud-prog-mode-hook)
(add-hook! yaml-mode 'dud-prog-mode-hook)

;; Use tabs for C++, Java, Go and Json
(add-hook! protobuf-mode 'dud-proto-mode-hook)
(add-hook! c++-mode 'dud-cc-mode-hook)
(add-hook! java-mode 'dud-java-mode-hook)
(add-hook! sh-mode 'dud-sh-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode setup
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Projects/org/")
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(setq org-roam-file-exclude-regexp ".git/")

(after! org
  (setq org-skip-scheduled-if-done t
        org-tags-column -80
        org-todo-keywords
        '((sequence "TODO(t)" "ACTIVE(a)" "WAITING(w)"
                    "|" "DONE(d)" "CANCELLED(c)"))
        org-todo-keyword-faces
        '(("TODO" :foreground "#7c7c75" :weight normal :underline t)
          ("ACTIVE" :foreground "9f7efe" :weight normal :underline t)
          ("WAITING" :foreground "#0098dd" :weight normal :underline t)
          ("DONE" :foreground "#50a14f" :weight normal :underline t)
          ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))
        org-ellipsis " ▼ "))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ace window
;; (global-set-key (kbd "C-x o") 'ace-window)
;; (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; (setq aw-background t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key Bindings
;; (global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-%") 'query-replace-regexp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shorter buffer name in modeline

(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-after-kill-buffer-p t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Netspring Specific connfiguration.
(load "~/Projects/netspring/tools/emacs/netspring.el")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
