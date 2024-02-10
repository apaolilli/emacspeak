;;; emacspeak-eshell.el --- Speech-enable EShell -*- lexical-binding: t; -*-
;;
;; $Author: tv.raman.tv $
;; Description:   Speech-enable EShell
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


;;; Commentary:
;; EShell is a shell implemented entirely in Emacs Lisp.
;; It is part of emacs 21 --and can also be used under
;; Emacs 20.
;; This module speech-enables EShell
;;; Code:

;;;  required modules

(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)
(require 'esh-arg)

;;;   setup various EShell hooks

;; Play an auditory icon as you display the prompt
(defun emacspeak-eshell-prompt-function ()
  "Play auditory icon for prompt."
  (cl-declare (special eshell-last-command-status))
  (cond
   ((= 0 eshell-last-command-status)
    (emacspeak-icon 'item))
   (t (emacspeak-icon 'warn-user))))

(add-hook 'eshell-after-prompt-hook 'emacspeak-eshell-prompt-function)

;; Speak command output

(defun emacspeak-eshell-speak-output  ()
  "Speak eshell output."
  (cl-declare (special eshell-last-input-end eshell-last-output-end
                       eshell-last-output-start))
  (emacspeak-speak-region eshell-last-input-end eshell-last-output-end))

(add-hook 
 'eshell-output-filter-functions
 'emacspeak-eshell-speak-output
 'at-end)

;;;   Advice top-level EShell

(defadvice eshell (after emacspeak pre act comp)
  "Announce switching to shell mode.
Provide an auditory icon if possible."
  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (dtk-set-punctuations 'all)
    (or dtk-split-caps
        (dtk-toggle-split-caps))
    (emacspeak-pronounce-refresh-pronunciations)
    (emacspeak-speak-line)))

;;;  advice em-hist

(cl-loop
 for f in
 '(
   eshell-next-input eshell-previous-input
   eshell-next-matching-input eshell-previous-matching-input
   eshell-next-matching-input-from-input
   eshell-previous-matching-input-from-input)
 do
 (eval
  `(defadvice ,f (after  emacspeak pre act comp)
     "Speak selected command."
     (when (ems-interactive-p)
       (emacspeak-icon 'select-object)
       (save-excursion
         (beginning-of-line)
         (eshell-skip-prompt)
         (emacspeak-speak-line 1))))))

;;;   advice em-ls

(defgroup emacspeak-eshell nil
  "EShell on the Emacspeak Audio Desktop."
  :group 'emacspeak
  :group 'eshell
  :prefix "emacspeak-eshell-")

(defvar emacspeak-eshell-ls-use-personalities t
  "Indicates if ls in eshell uses different voice
personalities.")

;;;  voices

(voice-setup-add-map 
 '(
   (eshell-ls-archive voice-monotone)
   (eshell-ls-backup voice-monotone-extra)
   (eshell-ls-clutter voice-smoothen)
   (eshell-ls-directory voice-bolden-extra)
   (eshell-ls-executable voice-animate)
   (eshell-ls-missing voice-lighten)
   (eshell-ls-product voice-animate)
   (eshell-ls-readonly voice-monotone)
   (eshell-ls-special voice-brighten)
   (eshell-ls-symlink voice-smoothen)
   (eshell-ls-unreadable voice-animate-extra)
   (eshell-prompt voice-bolden-and-animate)))

;;;  Advice em-prompt

(cl-loop for f in
         '(
           eshell-next-prompt eshell-previous-prompt
           eshell-forward-matching-input  eshell-backward-matching-input)
         do
         (eval
          `(defadvice ,f (after  emacspeak pre act comp)
             "Speak selected command."
             (when (ems-interactive-p)
               (let ((emacspeak-speak-messages nil))
                 (emacspeak-icon 'select-object)
                 (emacspeak-speak-line 1))))))

;;;   advice esh-arg

(cl-loop for f in
         '(
           eshell-insert-buffer-name
           eshell-insert-process
           eshell-insert-envvar)
         do
         (eval
          `(defadvice ,f (after emacspeak pre act comp)
             "Speak output."
             (when (ems-interactive-p)
               (emacspeak-icon 'select-object)
               (emacspeak-speak-line)))))

(defadvice eshell-insert-process (after emacspeak pre
                                        act comp)
  "Speak output."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-line)))

;;;  advice esh-mode

(defadvice eshell-delchar-or-maybe-eof (around emacspeak pre act comp)
  "Speak character you're deleting."
  (cond
   ((ems-interactive-p)
    (cond
     ((= (point) (point-max))
      (message "Sending EOF to comint process"))
     (t (dtk-tone 500 100 'force)
        (emacspeak-speak-char t)))
    ad-do-it)
   (t ad-do-it))
  ad-return-value)

(defadvice eshell-delete-backward-char (around emacspeak pre act comp)
  "Speak character you're deleting."
  (cond
   ((ems-interactive-p)
    (dtk-tone 500 100 'force)
    (emacspeak-speak-this-char (preceding-char))
    ad-do-it)
   (t ad-do-it))
  ad-return-value)

(defadvice eshell-show-output (after emacspeak pre act comp)
  "Speak output."
  (when (ems-interactive-p)
    (let ((emacspeak-show-point t))
      (emacspeak-icon 'large-movement)
      (emacspeak-speak-region (point) (mark)))))
(defadvice eshell-mark-output (after emacspeak pre act comp)
  "Speak output."
  (when (ems-interactive-p)
    (let ((emacspeak-show-point t))
      (emacspeak-icon 'mark-object)
      (emacspeak-speak-line))))
(defadvice eshell-kill-output (after emacspeak pre act comp)
  "Produce auditory feedback."
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (message "Flushed output")))

(defadvice eshell-kill-input (before emacspeak pre act comp)
  "Speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'delete-object)
    (emacspeak-speak-line)))

(defadvice eshell-toggle (after emacspeak pre act comp)
  "Provide spoken context feedback."
  (when (ems-interactive-p)
    (cond
     ((eq major-mode 'eshell-mode)
      (emacspeak-setup-programming-mode)
      (emacspeak-speak-line))
     (t (emacspeak-speak-mode-line)))
    (emacspeak-icon 'select-object)))
(defadvice eshell-toggle-cd (after emacspeak pre act comp)
  "Provide spoken context feedback."
  (when (ems-interactive-p)
    (cond
     ((eq major-mode 'eshell-mode)
      (emacspeak-speak-line))
     (t (emacspeak-speak-mode-line)))
    (emacspeak-icon 'select-object)))

;;; Additional Commands To Enable: 

(cl-loop
 for f in
 '(eshell-forward-argument eshell-backward-argument eshell-bol)
 do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "provide auditory feedback."
     (when
         (ems-interactive-p)
       (let ((emacspeak-show-point t))
         (emacspeak-speak-line)
         (emacspeak-icon 'large-movement))))))

(cl-loop
 for f in
 '(eshell-pcomplete eshell-complete-lisp-symbol)
 do
 (eval
  `(defadvice ,f (around emacspeak pre act comp)
     "Say what you completed."
     (ems-with-messages-silenced
      (let ((prior (save-excursion (skip-syntax-backward "^ >") (point))))
        ad-do-it
        (if (> (point) prior)
            (tts-with-punctuations
             'all
             (dtk-speak
              (buffer-substring prior (point))))
          (emacspeak-speak-completions-if-available))
        ad-return-value)))))

(defadvice eshell-copy-old-input (after emacspeak pre act comp)
  "Speak what was inserted."
  (when (ems-interactive-p)
    (let ((start
           (save-excursion
             (eshell-bol)
             (point))))
      (emacspeak-icon 'yank-object)
      (emacspeak-speak-region start (point)))))
(defadvice eshell-get-next-from-history (after emacspeak pre act comp)
  "Speak what was inserted."
  (when (ems-interactive-p)
    (let ((start
           (save-excursion
             (eshell-bol)
             (point))))
      (emacspeak-icon 'yank-object)
      (emacspeak-speak-region start (point)))))

(provide 'emacspeak-eshell)
;;;  end of file

