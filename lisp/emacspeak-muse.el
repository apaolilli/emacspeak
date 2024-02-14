;;; emacspeak-muse.el --- Speech-enable Muse  -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description:  Speech-enable Muse
;; Keywords: Emacspeak,  Audio Desktop Muse
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
;; Speech enable Muse

;;   Required modules

;;; Code:

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)
(require 'browse-url)
(require 'emacspeak-outline)

;;;  Voice definitions:
(voice-setup-add-map
 '(
   (muse-bad-link-face voice-bolden-and-animate)
   (muse-emphasis-1 voice-lighten)
   (muse-emphasis-2 voice-lighten-medium)
   (muse-emphasis-3 voice-lighten-extra)
   (muse-header-1 voice-bolden)
   (muse-header-2 voice-bolden-medium)
   (muse-header-3 voice-bolden-extra)
   (muse-header-4 voice-bolden-extra)
   (muse-header-5 voice-bolden-extra)
   (muse-link-face voice-brighten)
   (muse-verbatim-face voice-monotone-extra)
   ))

;;;  advice interactive commands
(cl-loop for f in
         '(muse-follow-name-at-point
           muse-follow-name-at-point-other-window
           muse-next-reference
           muse-previous-reference)
         do
         (eval
          `(defadvice   ,f (after emacspeak pre act comp)
             "speak."
             (when (ems-interactive-p)
               (emacspeak-icon 'large-movement)
               (emacspeak-speak-line)))))

(provide 'emacspeak-muse)
;;;  end of file

