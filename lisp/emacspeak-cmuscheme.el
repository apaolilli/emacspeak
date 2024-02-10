;;; emacspeak-cmuscheme.el --- CMUScheme   -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description:  Speech-enable emacs for scheme and guile
;; Keywords: Emacspeak, cmuscheme
;;;   LCD Archive entry:

;; LCD Archive Entry:
;; emacspeak| T. V. Raman |tv.raman.tv@gmail.com
;; A speech interface to Emacs |
;; 
;;  $Revision: 4074 $ |
;; Location https://github.com/tvraman/emacspeak
;; 

;;;   Copyright:

;; Copyright (C) 1995 -- 2024, T. V. Raman
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
;; speech-enable scheme support 

;;; Code:

;;  required modules

;;; Code:

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;  advice interactive commands.

;; speech-enable cmuscheme 

(defadvice inferior-scheme-mode (after emacspeak pre act
                                       comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'task-done)
    (message "Welcome to inferior scheme mode.")))

(defadvice run-scheme (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'task-done)
    (message "Launched scheme %s"
             (ad-get-arg 0))))

(defadvice scheme-send-region (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "Sent %s lines to scheme. "
             (count-lines (region-beginning)
                          (region-end)))))

(defadvice scheme-send-definition (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "Sent definition   to scheme. ")))

(defadvice scheme-send-last-sexp (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "Sent last sexp  to scheme. ")))

(defadvice scheme-compile-region (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "Compiling  %s lines to scheme. "
             (count-lines (region-beginning)
                          (region-end)))))

(defadvice scheme-compile-definition (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "Compiled definition  to scheme. ")))

(defadvice switch-to-scheme  (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-mode-line)))

(defadvice scheme-send-region-and-go (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-mode-line)))

(defadvice scheme-send-definition-and-go (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-mode-line)))
(defadvice scheme-load-file (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "loaded scheme file %s"
             (ad-get-arg 0))))
(defadvice scheme-compile-file (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (message "Compiled scheme file %s"
             (ad-get-arg 0))))

(provide 'emacspeak-cmuscheme)
;;;  end of file

