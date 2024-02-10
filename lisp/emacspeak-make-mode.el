;;; emacspeak-make-mode.el --- Speech enable make  -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $ 
;; Description:  Emacspeak extension to speech enable make-mode
;; Keywords: Emacspeak, Make
;;;   LCD Archive entry: 

;; LCD Archive Entry:
;; emacspeak| T. V. Raman |tv.raman.tv@gmail.com 
;; A speech interface to Emacs |
;; 
;;  $Revision: 4532 $ | 
;; Location https://github.com/tvraman/emacspeak
;; 

;;;   Copyright:
;; Copyright (C) 1995 -- 2024, T. V. Raman 
;; Copyright (c) 1994, 1995 by Digital Equipment Corporation.
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

;;;   required modules

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;; Commentary:

;; This module speech enables make-mode

;;; Code:

;;;  advice

(defadvice makefile-next-dependency (after emacspeak pre act
                                           comp)
  "Speak line we moved to"
  (when (ems-interactive-p)
    (let ((emacspeak-show-point t))
      (emacspeak-speak-line)
      (emacspeak-icon 'large-movement))))

(defadvice makefile-browser-next-line (after emacspeak pre act
                                             comp)
  "Speak line we moved to"
  (when (ems-interactive-p)
    (emacspeak-speak-line)
    (emacspeak-icon 'select-object)))

(defadvice makefile-browser-previous-line (after emacspeak pre act
                                                 comp)
  "Speak line we moved to"
  (when (ems-interactive-p)
    (emacspeak-speak-line)
    (emacspeak-icon 'select-object)))

(defadvice makefile-previous-dependency (after emacspeak pre act comp)
  "Speak line we moved to"
  (when (ems-interactive-p)
    (let ((emacspeak-show-point t))
      (emacspeak-speak-line)
      (emacspeak-icon 'large-movement))))

(defadvice makefile-complete (around emacspeak pre act comp)
  "Speak what we completed"
  (cond
   ((ems-interactive-p)
    (let ((orig (save-excursion (skip-syntax-backward "^ >") (point))))
      ad-do-it
      (emacspeak-speak-region orig (point))))
   (t ad-do-it))
  ad-return-value)

(defadvice makefile-backslash-region (after emacspeak pre
                                            act comp)
  "Speak how many lines we backslashed"
  (when (ems-interactive-p)
    (message "Backslashed region containing %s lines"
             (count-lines (region-beginning)
                          (region-end)))
    (emacspeak-icon 'select-object)))

(defadvice makefile-browser-quit (after emacspeak pre act
                                        comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-speak-mode-line)
    (emacspeak-icon 'close-object)))

(defadvice makefile-switch-to-browser (after emacspeak pre
                                             act comp)
  "Provide status information"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(defadvice makefile-browser-toggle (around emacspeak pre act comp)
  "Speak what happened"
  (cond
   ((ems-interactive-p)
    (let  ((this-line (max
                       (count-lines (point-min) (point))
                       1))
           (state nil))
      ad-do-it
      (setq state
            (makefile-browser-get-state-for-line this-line))
      (emacspeak-icon (if state 'on 'off))
      (emacspeak-speak-line)))
   (t ad-do-it))
  ad-return-value)

(defadvice makefile-browser-insert-selection (after emacspeak pre act comp)
  "Provide status message"
  (when (ems-interactive-p)
    (message
     "Inserted selections into client  %s"
     (buffer-name makefile-browser-client))))

;;;  personalities 

(voice-setup-add-map
 '(
   (makefile-space voice-monotone-extra)
   (makefile-targets voice-bolden)
   (makefile-shell voice-animate)
   (makefile-makepp-perl voice-smoothen)
   ))

;;;  setup mode hook:

(provide 'emacspeak-make-mode)

;;;  end of file 

