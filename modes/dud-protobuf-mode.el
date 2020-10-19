;; Dud is emacs configuration for dummy's. It's meant to expose the
;; power of emacs without much configuration and at the same time
;; adhereing to emacs philosophy of customization.
;;
;;     Copyright (C) 2013  Satyam Shekhar
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.
;;
;; Sets up protobuf mode for *.proto files.
;; Dependencies: Requires proto-buf in your load-path. If you are
;; using this as a part of dud then it will take care of it. Otherwise
;; you can get it from here:
;;   http://code.google.com/p/protobuf/source/browse/trunk/editors/protobuf-mode.el?r=227

(require 'protobuf-mode)

(defconst dud-protobuf-style
  '((c-basic-offset . 2)))

(add-hook 'protobuf-mode-hook
	(lambda ()
		(setq-default tab-width 2)
		(setq-default indent-tabs-mode 1)
		(c-add-style "my-style" dud-protobuf-style t)))

(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

(provide 'dud-protobuf-mode)
