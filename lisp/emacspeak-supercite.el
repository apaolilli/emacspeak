;;; emacspeak-supercite.el --- Speech enable SC  -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $ 
;; Description:  Emacspeak extension to speech enable supercite
;; Keywords: Emacspeak, supercite, mail
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


;;; Commentary:

;; Speech-enable supercite.

;;; Code:

;;;  requires
(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;  Advice
(defadvice sc-cite-region (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'mark-object)
    (message "Cited region containing %s lines"
             (count-lines (ad-get-arg 0)
                          (ad-get-arg 1)))))

(defadvice sc-recite-region (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'mark-object)
    (message "Re-cited region containing %s lines"
             (count-lines (ad-get-arg 0)
                          (ad-get-arg 1)))))

(defadvice sc-uncite-region (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'mark-object)
    (message "Uncited region containing %s lines"
             (count-lines (ad-get-arg 0)
                          (ad-get-arg 1)))))

(defadvice sc-insert-reference (around emacspeak pre act
                                       comp)
  "Speak what we inserted"
  (cond
   ((ems-interactive-p)
    (let ((opoint (point)))
      ad-do-it
      (emacspeak-speak-region opoint (point))
      (emacspeak-icon 'yank-object)))
   (t ad-do-it))
  ad-return-value)
(defadvice sc-insert-citation (after emacspeak pre act
                                     comp)
  "Speak what we inserted"
  (when (ems-interactive-p)
    (emacspeak-speak-line)
    (emacspeak-icon 'yank-object)))

(defadvice sc-open-line (after emacspeak pre act comp)
  "speak"
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (dtk-speak "Opened a blank line")))

(provide 'emacspeak-supercite)

;;;  end of file 

