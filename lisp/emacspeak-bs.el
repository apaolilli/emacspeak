;;; emacspeak-bs.el --- speech-enable bs -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description:   extension to speech enable bs
;; Keywords: Emacspeak, Audio Desktop
;;;   LCD Archive entry:

;; LCD Archive Entry:
;; emacspeak| T. V. Raman |tv.raman.tv@gmail.com
;; A speech interface to Emacs |
;; 
;;  $Revision: 4532 $ |
;; Location https://github.com/tvraman/emacspeak
;; 

;;;   Copyright:

;; Copyright (C) 1995 -- 2024, T. V. Raman<tv.raman.tv@gmail.com>
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

;;  required modules

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)
(require 'bs)

;;; Commentary:

;; speech-enable bs.el -- an alternative to Emacs' default  list-buffers

;;; Code:

;;;  helpers 

(defun emacspeak-bs-speak-buffer-line ()
  "Speak information about this buffer"
  (interactive)
  (cl-declare (special list-buffers-directory))
  (unless (eq major-mode 'bs-mode)
    (error "This command can only be used in buffer menus"))
  (let((buffer (bs--current-buffer)))
    (cond
     ((get-buffer buffer)
      (let (
            (with (propertize "with size " 'personality voice-smoothen))
            (name (buffer-name buffer))
            (file (buffer-file-name buffer))
            this-buffer-read-only this-buffer-modified-p
            this-buffer-size 
            this-buffer-directory)
        (save-current-buffer
          (set-buffer buffer)
          (setq this-buffer-read-only buffer-read-only)
          (setq this-buffer-modified-p (buffer-modified-p))
          (setq this-buffer-size (buffer-size))
          (or file
              ;; No visited file.  Check local value of
              ;; list-buffers-directory.
              (if (and (boundp 'list-buffers-directory)
                       list-buffers-directory)
                  (setq this-buffer-directory list-buffers-directory))))
                                        ;format and speak the line
        (when this-buffer-modified-p (dtk-tone 700 100))
        (when this-buffer-read-only (dtk-tone 250 100))
        (dtk-speak
         (concat 
          name " "
          (format-mode-line mode-name)
          (if (or file this-buffer-directory)
              (format " visiting %s "
                      (or file this-buffer-directory))
            "")
          with
          (format " %s "this-buffer-size)))))
     (t(emacspeak-icon 'warn-user)
       (emacspeak-speak-line)))))

;;;  speech enable interactive commands 

(defadvice bs-mode (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (setq voice-lock-mode t))

(defadvice bs-kill (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'close-object)
    (emacspeak-speak-mode-line)))

(defadvice bs-abort (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'close-object)
    (emacspeak-speak-mode-line)))
(defadvice bs-set-configuration-and-refresh (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)))
(defadvice bs-refresh (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)))

(defadvice bs-view (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))
(defadvice bs-select (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))
(defadvice bs-select-other-window (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(defadvice bs-tmp-select-other-window (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(defadvice bs-select-other-frame (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(defadvice bs-select-in-one-window (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(defadvice bs-bury-buffer (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'close-object)))
(defadvice bs-save (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'save-object)))
(defadvice bs-toggle-current-to-show (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'button)
    (emacspeak-bs-speak-buffer-line)))
(defadvice bs-set-current-buffer-to-show-never (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'button)
    (emacspeak-bs-speak-buffer-line)))
(defadvice bs-mark-current (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'mark-object)
    (emacspeak-bs-speak-buffer-line)))
(defadvice bs-unmark-current (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'deselect-object)
    (emacspeak-bs-speak-buffer-line)))

(defadvice bs-delete (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (emacspeak-bs-speak-buffer-line)))
(defadvice bs-delete-backward (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (emacspeak-bs-speak-buffer-line)))

(defadvice bs-up (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-bs-speak-buffer-line)))
(defadvice bs-down (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-bs-speak-buffer-line)))

(defadvice bs-cycle-next (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (let ((emacspeak-speak-messages nil))
      (emacspeak-icon 'select-object)
      (emacspeak-speak-mode-line))))

(defadvice bs-cycle-previous (after emacspeak pre act comp)
  "Speech-enable bs mode"
  (when (ems-interactive-p)
    (let ((emacspeak-speak-messages nil))
      (emacspeak-icon 'select-object)
      (emacspeak-speak-mode-line))))

(provide 'emacspeak-bs)
;;;  end of file

