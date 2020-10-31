;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Code") ; inherits `doom-font''s :size
;;       doom-unicode-font (font-spec :family "Fira Code" :size 12)
;;       doom-big-font (font-spec :family "Fira Mono" :size 19))
;; "monospace" means use the system default. However, the default is usually two
;; points larger than I'd like, so I specify size 12 here.
(setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; Variable width font support
(use-package mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-dark+)
(setq doom-theme 'leuven)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

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

;; Optimizations

;; Disable smartparens
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)
;; Prevents some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

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

(custom-theme-set-faces! 'doom-dracula
  `(markdown-code-face :background ,(doom-darken 'bg 0.075))
  `(font-lock-variable-name-face :foreground ,(doom-lighten 'magenta 0.6)))

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
;;
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
  (local-set-key (kbd "M-]") 'dud-c-rotate)
  (local-set-key (kbd "M-[") 'dud-c-rotate-rev)
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
  (setq whitespace-line-column 75)
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
;; Ace window
;; (global-set-key (kbd "C-x o") 'ace-window)
;; (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; (setq aw-background t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key Bindings
(global-set-key (kbd "M-g") 'goto-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Netspring Specific connfiguration.
(load "~/Projects/netspring/tools/emacs/netspring.el")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
