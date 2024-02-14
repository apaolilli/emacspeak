;;; emacspeak-todo-mode.el --- speech-enable todo -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description: todo-mode  for maintaining todo lists 
;; Keywords: Emacspeak, todo-mode 
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

;;   Required modules

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

:
;;; Commentary:
;; todo-mode (part of Emacs 21) provides todo-lists that can be
;; integrated with the Emacs calendar.
;; This module speech-enables todo-mode
;;; Code:

;;;   Advice interactive commands:

(cl-loop
 for f in
 '(todo-forward-item
   todo-backward-item
   todo-next-item
   todo-previous-item
   todo-forward-category
   todo-backward-category
   todo-next-category
   todo-previous-category
   todo-jump-to-category
   )
 do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "speak."
     (when (ems-interactive-p)
       (emacspeak-icon 'select-object)
       (emacspeak-speak-line)))))

(defadvice todo-save (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'save-object)))

(defadvice todo-quit (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'close-object)
    (emacspeak-speak-mode-line)))

(provide 'emacspeak-todo-mode)
;;;  end of file 

