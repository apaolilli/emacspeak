;;; emacspeak-winring.el --- Speech enable WinRing -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $ 
;; Description: Auditory interface to winring
;; Keywords: Emacspeak, Speak, Spoken Output, winring
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

;;   Required modules:

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;   Introduction
;;; Commentary:
;; window configurations in emacs are very useful 
;; you can display the same file in different windows,
;; and have different  portions of the file displayed.
;; winring allows you to manage window configurations,
;; and this module speech-enables it.
;;; Code:

;;;  Advice commands

(defadvice winring-jump-to-configuration(after emacspeak pre
                                               act comp)
  "provide auditory feedback"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-describe-tapestry winring-name)))

(defadvice winring-next-configuration(after emacspeak pre
                                            act comp)
  "provide auditory feedback"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-describe-tapestry winring-name)))

(defadvice winring-prev-configuration(after emacspeak pre
                                            act comp)
  "provide auditory feedback"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-describe-tapestry winring-name)))

(defadvice winring-new-configuration(after emacspeak pre
                                           act comp)
  "provide auditory feedback"
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-mode-line)))
(defadvice winring-delete-configuration(after emacspeak pre
                                              act comp)
  "provide auditory feedback"
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (emacspeak-speak-mode-line)))

(provide 'emacspeak-winring)
;;;  end of file 

