;;; emacspeak-add-log.el --- Speech-enable add-log  -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description:  speech-enable change-log-mode
;; Keywords: Emacspeak,  Audio Desktop ChangeLogs
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
;; Speech-enable Changelog mode

;;; Code:

;;   Required modules

(eval-when-compile (require 'cl-lib))
(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;  define personalities

(defgroup emacspeak-add-log nil
  "Customize Emacspeak for change-log-mode and friends."
  :group 'emacspeak)

(voice-setup-add-map
 '(
   (change-log-acknowledgment voice-smoothen)
   (change-log-conditionals voice-animate)
   (change-log-email voice-lighten)
   (change-log-function voice-bolden-extra)
   (change-log-file voice-bolden)
   (change-log-email voice-lighten)
   (change-log-list voice-lighten)
   (change-log-name voice-lighten-extra)
   (change-log-date voice-monotone-extra)
   ))

(provide 'emacspeak-add-log)
;;;  end of file

