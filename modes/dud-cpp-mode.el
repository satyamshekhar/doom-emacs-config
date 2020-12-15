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
;; along with this xoprogram; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;; Customizations to default c mode.
;; Dependencies: Requires google-c-style in your load-path. If you are
;; using this as a part of dud then it will take care of it. Otherwise
;; you can get it from here:
;;   http://google-styleguide.googlecode.com/svn/trunk/google-c-style.el

;; Besides setting up google-c-style mode it provides convenience functions
;; that you can use to rotate betweeh header, implementation and cpp files.

;; file-name suffix is compared with first elements from the list
;; in the order specified here.
(defvar dud-c-rotation-map
  '((".hpp" . (".cpp" ".ipp" ".cc" "_test.cc" "_test.cpp"))
    (".h" . (".cpp" ".ipp" ".cc" "_test.cc" "_test.cpp"))
    ("_test.cpp" . (".hpp" ".h" ".cc" ".cpp" ".ipp"))
    ("_test.cc" . (".hpp" ".h" ".cc" ".cpp" ".ipp"))
    (".cpp" . (".ipp" "_test.cpp" ".hpp" ".h"))
    (".cc" . (".ipp" "_test.cc" "_test.cpp" ".hpp" ".h"))
    (".ipp" . ("_test.cpp" "_test.cc" ".hpp" ".h" ".cpp" ".cc"))
    ("Test.java" . (".java"))
    (".java" . ("Test.java"))
    ))

(defun ends-with (string suffix)
  "Returns t if @string ends with @suffix, nil otherwise."
  (let ((start (- (length string) (length suffix))))
    (and (>= start 0)
         (string= suffix (substring string (- (length suffix)))))))

(defun dud-c-rotated-files (file-name)
  "Returns list of file names if the file can be rotated, nil otherwise."
  (let* ((ext-map (cl-find-if (lambda (rotation-map)
                             (ends-with file-name (car rotation-map)))
                           dud-c-rotation-map))
         (old-suffix (car ext-map))
         (new-suffix-list (cdr ext-map)))
    (mapcar (lambda (new-suffix)
              (concat (substring file-name 0 (- (length old-suffix)))
                      new-suffix)) new-suffix-list)))

(defun dud-c-rotate ()
  "Rotates buffer among file.hpp <-> file.cpp <-> file_test.cpp"
  (interactive)
  (let* ((file-path (buffer-file-name))
        (rotated-files (dud-c-rotated-files file-path)))
    (if rotated-files
        (progn
          (cl-loop for file in rotated-files
                   when (file-exists-p file) return (find-file file)))
      (message "No rotation defined for current file"))))

(defun dud-c-rotate-rev ()
  "Rotates buffer among file.hpp <-> file.cpp <-> file_test.cpp"
  (interactive)
  (let* ((file-path (buffer-file-name))
        (rotated-files (dud-c-rotated-files file-path)))
    (if rotated-files
        (progn
          (cl-loop for file in (reverse rotated-files)
                   when (file-exists-p file) return (find-file file)))
      (message "No rotation defined for current file"))))

(font-lock-add-keywords 'c++-mode
  '(("\\<\\(co_return\\|co_await\\|co_yield\\)\\>" . font-lock-keyword-face)))

(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(provide 'dud-cpp-mode)
