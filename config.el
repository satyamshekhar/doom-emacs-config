;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;;
;;; Code:

(setq user-full-name "Satyam Shekhar"
      user-mail-address "satyam@netspring.io")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one-light)
;; (setq doom-theme 'sanityinc-tomorrow-day)
(global-hl-line-mode +1)

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
;; (delete-selection-mode t)
;; Disable mouse mode to enable copy on selection.
(xterm-mouse-mode -1)
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

  ;; I prefer search matching to be ordered; it's more precise
(after! ivy
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
(setq auto-mode-alist (cons '("\\.jsonnet\\'" . js-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tsonnet\\'" . js-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup clang-format
(load "clang-format.el")
(add-to-list 'auto-mode-alist '("\\.ipp\\'" . c++-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming

(require 'dud-cpp-mode)
(require 'dud-protobuf-mode)

;; (after! flycheck
;;   (setq flycheck-check-syntax-automatically '(mode-enabled save)))

(setq debug-on-error t)
(setq-default tab-width 2)
;; Disable auto-revert (reload) of file buffers while they are loaded to prevent
;; data loss.
(global-auto-revert-mode -1)

(defun dud-cc-mode-hook ()
  (local-set-key (kbd "M-0") 'dud-c-rotate)
  (local-set-key (kbd "M-9") 'dud-c-rotate-rev)
  (local-set-key (kbd "M-8") 'dud-open-test-buffer)
  (local-set-key (kbd "M-=") 'clang-format-buffer))

(defun dud-proto-mode-hook ()
  (local-set-key (kbd "M-=") 'clang-format-buffer))

(defun dud-java-mode-hook()
  (local-set-key (kbd "M-0") 'dud-c-rotate)
  (local-set-key (kbd "M-9") 'dud-c-rotate-rev)
  (local-set-key (kbd "M-8") 'dud-open-test-buffer)
  (local-set-key (kbd "M-=") 'clang-format-buffer))

(defun dud-sh-mode-hook()
  (setq sh-basic-offset 2)
  (setq sh-indentation 2))

(defun dud-prog-mode-hook ()
  "Customizations to prog-mode."
  (whitespace-mode -1)
  (setq display-line-numbers-type 'relative)
  (setq fill-column 75)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key Bindings
;; (global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-%") 'query-replace-regexp)
(map! :leader
      :desc "Bazel build current buffer"
      "c b" #'ns-build-buffer)
(map! :leader
      :desc "Bazel test current buffer"
      "c t" #'ns-test-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shorter buffer name in modeline

(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-after-kill-buffer-p t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Netspring Specific connfiguration.
(load "~/Projects/netspring/tools/emacs/netspring.el")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
