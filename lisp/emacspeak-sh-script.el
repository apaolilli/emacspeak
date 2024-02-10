;;; emacspeak-sh-script.el --- Speech enable script -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description:   extension to speech enable sh-script 
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

;;;  required modules

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;; Commentary:

;; This module speech-enables sh-script.el 

;;; Code:

;;;   advice interactive commands

(defadvice sh-mode (after emacspeak pre act comp)
  "Speech-enable sh-script editing."
  (dtk-set-punctuations 'all)
  (unless emacspeak-audio-indentation
    (emacspeak-toggle-audio-indentation))
  (emacspeak-speak-mode-line))

(defadvice sh-indent-line (after emacspeak pre act comp)
  "speak to indicate indentation."
  (when (ems-interactive-p)
    (emacspeak-icon 'large-movement)
    (emacspeak-speak-current-column)))

(unless (and (boundp 'post-self-insert-hook)
             post-self-insert-hook
             (memq 'emacspeak-post-self-insert-hook post-self-insert-hook))
  (defadvice sh-assignment (after emacspeak pre act comp)
    "Speak assignment as it is inserted."
    (when (ems-interactive-p)
      (emacspeak-speak-this-char (preceding-char)))))

(defadvice sh-maybe-here-document(around emacspeak pre act comp)
  "Spoken feedback based on what we insert."
  (cond
   ((ems-interactive-p)
    (let ((start (point)))
      ad-do-it
      (if (= (point) (1+ start))
          (emacspeak-speak-this-char last-input-event)
        (message "Started a shell here  document."))))
   (t ad-do-it))
  ad-return-value)
(defadvice sh-newline-and-indent (after emacspeak pre act comp)
  "speak to indicate indentation."
  (when (ems-interactive-p)
    (emacspeak-speak-line)))
(defadvice sh-beginning-of-command(after emacspeak pre act
                                         comp)
  "Speak point moved to."
  (when (ems-interactive-p)
    (emacspeak-icon 'large-movement)
    (emacspeak-speak-line)))
(defadvice sh-end-of-command(after emacspeak pre act
                                   comp)
  "Speak point moved to."
  (when (ems-interactive-p)
    (emacspeak-icon 'large-movement)
    (emacspeak-speak-line)))

;;;  advice skeleton insertion 
(unless (and (boundp 'post-self-insert-hook)
             post-self-insert-hook
             (memq 'emacspeak-post-self-insert-hook post-self-insert-hook))
  (defadvice skeleton-pair-insert-maybe(around emacspeak pre
                                               act comp)
    "Speak what you inserted."
    (cond
     ((ems-interactive-p)
      (let ((orig (point)))
        ad-do-it
        (emacspeak-speak-region orig (point))))
     (t ad-do-it))
    ad-return-value))

(provide 'emacspeak-sh-script)
;;;  end of file

