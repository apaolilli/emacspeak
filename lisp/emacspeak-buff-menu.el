;;; emacspeak-buff-menu.el --- Speech enable buff -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $ 
;; Description: Auditory interface to buff-menu
;; Keywords: Emacspeak, Speak, Spoken Output, buff-menu
;;;   LCD Archive entry: 

;; LCD Archive Entry:
;; emacspeak| T. V. Raman |tv.raman.tv@gmail.com 
;; A speech interface to Emacs |
;; 
;;  $Revision: 4532 $ | 
;; Location https://github.com/tvraman/emacspeak
;; 

;;;   Copyright:

;; Copyright (c) 1995 -- 2024, T. V. Raman
;; All Rights Reserved. 
;; 
;; This file is not part of GNU Emacs, but the same permissions apply.
;; 
;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;; 
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;   Introduction 
;;; Commentary:
;; Speech-enable buffer-menus.
;;; Code:

;;;   Required modules

;;; Code:

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;  voice personalities
(voice-setup-add-map
 '(
   (buffer-menu-buffer voice-bolden)
   ))

;;;   list buffers 

(defun emacspeak-list-buffers-speak-name ()
  "Speak the name of the buffer on this line"
  (interactive)
  (cond
   ((eq major-mode 'Buffer-menu-mode)
    (let*((buffer (Buffer-menu-buffer t)))
      (if (get-buffer buffer)
          (dtk-speak (buffer-name  buffer))
        (error "No valid buffer on this line"))))
   (t (error "This command can be used only in buffer menus"))))

(defun emacspeak-list-buffers-speak-buffer-line ()
  "Speak information about this buffer"
  (interactive)
  (cl-declare (special list-buffers-directory dtk-stop-immediately))
  (unless (eq major-mode 'Buffer-menu-mode)
    (error "This command can be used only in buffer menus"))
  (let((buffer (Buffer-menu-buffer t)))
    (cond
     ((get-buffer buffer)
      (when dtk-stop-immediately (dtk-stop))
      (let ((name (buffer-name buffer))
            (file (buffer-file-name buffer))
            this-buffer-read-only
            this-buffer-modified-p
            this-buffer-size
            this-buffer-mode-name
            this-buffer-directory
            (dtk-stop-immediately nil))
        (save-current-buffer
          (set-buffer buffer)
          (setq this-buffer-read-only buffer-read-only)
          (setq this-buffer-modified-p (buffer-modified-p))
          (setq this-buffer-size (buffer-size))
          (setq this-buffer-mode-name mode-name)
          (or file
              ;; No visited file.  Check local value of
              ;; list-buffers-directory.
              (if (and (boundp 'list-buffers-directory)
                       list-buffers-directory)
                  (setq this-buffer-directory list-buffers-directory))))
                                        ;format and speak the line
        (when this-buffer-modified-p (emacspeak-icon 'modified-object))
        (when this-buffer-read-only
          (emacspeak-icon 'unmodified-object))
        (dtk-speak
         (format  "%s a %s  buffer  %s with size  %s"
                  name this-buffer-mode-name
                  (if (or file this-buffer-directory)
                      (format "visiting %s"
                              (or file this-buffer-directory))
                    "")
                  this-buffer-size))))
     (t(emacspeak-icon 'warn-user)
       (emacspeak-speak-line)))))

(defun emacspeak-list-buffers-next-line (count)
  "Speech enabled buffer menu navigation"
  (interactive "p")
  (forward-line count)
  (emacspeak-list-buffers-speak-buffer-line))

(defun emacspeak-list-buffers-previous-line (count)
  "Speech enabled buffer menu navigation"
  (interactive "p")
  (forward-line  (* -1 count))
  (emacspeak-list-buffers-speak-buffer-line))

(defadvice list-buffers (after emacspeak pre act comp)
  "Select the window displaying buffer-menu,
and set up additional Emacspeak bindings."
  (cl-declare (special Buffer-menu-mode-map))
  (when (ems-interactive-p)
    (select-window  ad-return-value)
    (tabulated-list-next-column 3)
    (define-key Buffer-menu-mode-map "," 'emacspeak-list-buffers-speak-name)
    (define-key Buffer-menu-mode-map "l"
                'emacspeak-list-buffers-speak-buffer-line)
    (define-key Buffer-menu-mode-map "n" 'emacspeak-list-buffers-next-line)
    (define-key Buffer-menu-mode-map "p" 'emacspeak-list-buffers-previous-line)
    (emacspeak-list-buffers-speak-buffer-line)
    (emacspeak-icon 'open-object)))

(defadvice buffer-menu (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'task-done)
    (message "Displayed list of buffers in other window")))

;;;   buffer manipulation commands 
(defadvice Buffer-menu-bury (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-delete-backwards (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-delete (after emacspeak pre act comp)
  "Provide spoken and auditory feedback."
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-mark (after emacspeak pre act comp)
  "Provide spoken and auditory feedback."
  (when (ems-interactive-p)
    (emacspeak-icon 'mark-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-quit (after emacspeak pre act comp)
  "Speak the modeline of the newly visible buffer."
  (when (ems-interactive-p)
    (emacspeak-icon 'close-object)
    (emacspeak-speak-mode-line)))

(defadvice Buffer-menu-save (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'save-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-select (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-mode-line)))

(defadvice Buffer-menu-unmark (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'deselect-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-backup-unmark (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'deselect-object)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-execute (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'task-done)))

(defadvice Buffer-menu-toggle-read-only (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-list-buffers-speak-buffer-line)))

(defadvice Buffer-menu-not-modified (after emacspeak pre act comp)
  "speak "
  (when (ems-interactive-p)
    (emacspeak-list-buffers-speak-buffer-line)
    (if (ad-get-arg 0)
        (emacspeak-icon 'modified-object)
      (emacspeak-icon 'unmodified-object))))

(defadvice Buffer-menu-visit-tags-table (before emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (message "Visiting tags table on current line")))

;;;   display buffers 

(defadvice Buffer-menu-1-window (after emacspeak pre act comp)
  "Announce the newly selected buffer."
  (when (ems-interactive-p)
    (emacspeak-speak-mode-line)
    (emacspeak-icon 'select-object)))

(defadvice Buffer-menu-2-window (after emacspeak pre act comp)
  "Announce the newly selected buffer."
  (when (ems-interactive-p)
    (emacspeak-speak-mode-line)
    (emacspeak-icon 'select-object)))

(defadvice Buffer-menu-this-window (after emacspeak pre act comp)
  "Announce the newly selected buffer."
  (when (ems-interactive-p)
    (emacspeak-speak-mode-line)
    (emacspeak-icon 'select-object)))
(defadvice Buffer-menu-other-window (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(provide 'emacspeak-buff-menu)
;;;  end of file 

