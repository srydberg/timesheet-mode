;;; timesheet-mode.el --- major mode for editing timesheets

;; Copyright (C) 2013 Sebastian Rydberg

;; Maintainer: Sebastian Rydberg <sr at rydbergtech.se>
;; Author: Sebastian Rydberg, 2013
;; Keywords: timesheet utilities
;; Created: 2013-05-03
;; Modified: 2013-06-14
;; X-URL:   http://www..github.com/srydberg/timesheet-mode

(defconst timesheet-mode-version-number "0.0.1"
  "Timesheet Mode version number.")

;;; License

;; This file is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Usage

;; Put this file in your Emacs lisp path (eg. site-lisp) and add to
;; your .emacs file:
;;
;;   (require 'timesheet-mode)

;; To use abbrev-mode, add lines like this:
;;   (add-hook 'timesheet-mode-hook
;;     '(lambda () (define-abbrev timesheet-mode-abbrev-table "ex" "extends")))

;;; Commentary:

;;

;;; Contributors: (in chronological order)

;;

;;; Changelog:

;; 0.1
;;
;; See the ChangeLog file included with the source package.


;;; Code:

(defvar timesheet-mode-hook nil)

(defvar timesheet-mode-map
  (let ((map (make-sparse-keymap)))
	(define-key map (kbd "C-S-<return>") 'mark-start-of-day)
	(define-key map (kbd "C-<return>") 'mark-start-of-slot)
    map)
  "Keymap for timesheet major mode")

(defconst timesheet-weekdays
  (eval-when-compile
    (regexp-opt '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))))

(defconst timesheet-months
  (eval-when-compile
	(regexp-opt '("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"))))

(defconst timesheet-font-lock-keywords
  (list
   `(,(concat "^\\(" timesheet-weekdays " "
			  "[0-3][0-9] "
			  timesheet-months " "
			  "[0-9]\\{4\\} "
			  "[A-Z]*$\\)")
	 1 font-lock-comment-face)
   '("^ \\([0-9][0-9]:[0-9][0-9]:[0-9][0-9]\\)"
	 1 font-lock-comment-face)
   '("^[ ]*\\(!.*\\)$"
	 1 font-lock-warning-face)
   '("^[ ]*\\(*.*\\)$"
	 1 font-lock-keyword-face)
   '("^\\(---.*---\\)$"
	 1 font-lock-function-name-face))
  "Highlighting for timesheet mode")

(add-to-list 'auto-mode-alist '("\\.ets$" . timesheet-mode))

(defun timesheet-mode ()
  "Major mode for editing and creating timesheets"
  (interactive)
  (kill-all-local-variables)
  (use-local-map timesheet-mode-map)
  (setq major-mode 'timesheet-mode)
  (setq mode-name "Timesheet")
  (setq font-lock-defaults
        '((timesheet-font-lock-keywords)
          nil
          t
          (("_" . "w"))
          nil))
  (run-hooks 'timesheet-mode-hook))

(defun mark-start-of-slot ()
  "Marks the start of a new time slot by inserting the current time"
  (interactive)
  (when (region-active-p)
    (delete-region (region-beginning) (region-end)))
  (insert "\n " (format-time-string "%H:%M:%S") " "))

(defun mark-start-of-day ()
  "Marks the start of a new day by inserting the current date"
  (interactive)
  (when (region-active-p)
    (delete-region (region-beginning) (region-end)))
  (insert "\n" (format-time-string "%a %d %b %Y %Z")  " "))

(provide 'timesheet-mode)
