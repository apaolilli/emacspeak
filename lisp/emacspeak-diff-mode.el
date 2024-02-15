;;; emacspeak-diff-mode.el --- Speech-enable DIFF -*- lexical-binding: t; -*-
;; $Id: emacspeak-diff-mode.el 4797 2007-07-16 23:31:22Z tv.raman.tv $
;; $Author: tv.raman.tv $
;; Description:  Speech-enable DIFF-MODE An Emacs Interface to diff-mode
;; Keywords: Emacspeak,  Audio Desktop diff-mode
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
;; MERCHANTABILITY or FITNDIFF-MODE FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; Commentary:
;; DIFF-MODE  support.
;;; Code:

;;   Required modules:

(eval-when-compile (require 'cl-lib))
(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;  Faces from  diff-mode.el

(voice-setup-add-map
 '(
   (diff-added voice-brighten)
   (diff-changed voice-animate)
   (diff-context voice-monotone-extra)
   (diff-file-header voice-bolden)
   (diff-function voice-smoothen)
   (diff-header voice-bolden-extra)
   (diff-hunk-header voice-bolden-medium)
   (diff-index voice-monotone-extra)
   (diff-indicator-added voice-animate)
   (diff-indicator-changed voice-lighten)
   (diff-indicator-removed voice-smoothen)
   (diff-nonexistent voice-monotone-extra)
   (diff-refine-added voice-lighten)
   (diff-refine-changed voice-brighten-medium)
   (diff-refine-removed voice-smoothen)
   (diff-removed voice-smoothen-extra)))

;;;  Advice Interactive Commands:

(cl-loop
 for f in
 '(diff-next-complex-hunk
   diff-hunk-prev diff-hunk-next
   diff-file-next diff-file-prev)
 do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "speak."
     (when (ems-interactive-p)
       (emacspeak-icon 'large-movement)
       (emacspeak-speak-line)))))

(provide 'emacspeak-diff-mode)
;;;  end of file

