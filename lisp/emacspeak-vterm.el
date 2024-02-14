;;; emacspeak-vterm.el --- Speech-enable VTERM  -*- lexical-binding: t; -*-
;; $Author: tv.raman.tv $
;; Description:  Speech-enable VTERM An Emacs Interface to vterm
;; Keywords: Emacspeak,  Audio Desktop vterm
;;;   LCD Archive entry:

;; LCD Archive Entry:
;; emacspeak| T. V. Raman |raman@cs.cornell.edu
;; A speech interface to Emacs |
;; 
;;  $Revision: 4532 $ |
;; Location https://github.com/tvraman/emacspeak
;; 

;;;   Copyright:
;; Copyright (C) 1995 -- 2007, 2019, T. V. Raman
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
;; MERCHANTABILITY or FITNVTERM FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; Commentary:
;; VTERM == vterm using native vterm library
;; @subsection Usage
;; @itemize
;; @item Turn on @code{emacspeak-comint-autospeak} for using  the
;; shell.
;; @item Turn off @code{emacspeak-comint-autospeak} when using
;; full-screen ncurses apps like @code{vi}.
;; @item Use @code{vterm-copy-mode} to review the contents of the
;; terminal @MDash{} @kbd{C-c C-t}.
;; @end itemize
;; 
;;; Code:

;;   Required modules:

(eval-when-compile (require 'cl-lib))
(cl-declaim  (optimize  (safety 0) (speed 3)))
(require 'emacspeak-preamble)

;;;  Map Faces:

(voice-setup-add-map
 '(
   (vterm-color-black voice-bolden)
   (vterm-color-blue voice-brighten)
   (vterm-color-cyan voice-smoothen)
   (vterm-color-default 'paul)
   (vterm-color-green voice-lighten)
   (vterm-color-inverse-video voice-bolden)
   (vterm-color-magenta voice-annotate)
   (vterm-color-underline voice-monotone-extra)
   (vterm-color-white 'paul)
   (vterm-color-yellow voice-animate)))

;;;  Interactive Commands:

(defadvice vterm-clear (after emacspeak pre act comp)
  "speak."
  (emacspeak-vterm-snapshot)
  (when (ems-interactive-p)
    (emacspeak-icon 'scroll)
    (message "Cleared screen")))

(defadvice vterm-clear-scrollback (after emacspeak pre act comp)
  "speak."
  (emacspeak-vterm-snapshot)
  (when (ems-interactive-p)
    (emacspeak-icon 'scroll)
    (message "Cleared scrollback")))

(defadvice vterm-copy-mode-done (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'close-object)
    (emacspeak-speak-line)))

(with-eval-after-load "vterm"
  (cl-declaim (special vterm-mode-map vterm-copy-mode-map))
  (define-key vterm-mode-map (kbd "C-e")
              'emacspeak-keymap)
  (define-key vterm-copy-mode-map (kbd "C-e") 'emacspeak-keymap))

(defadvice vterm (after emacspeak pre act comp)
  "speak."

  (when (ems-interactive-p)
    (emacspeak-icon 'open-object)
    (emacspeak-speak-mode-line)))

(cl-loop
 for f in
 '(vterm-end-of-line vterm-beginning-of-line)
 do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "speak."
     (when (ems-interactive-p)
       (emacspeak-icon 'large-movement)
       (emacspeak-speak-line)))))

(defadvice vterm-reset-cursor-point (after emacspeak pre act comp)
  "speak."
  (when (ems-interactive-p)
    (emacspeak-icon 'select-object)
    (emacspeak-speak-line)))

(defadvice vterm-send-return (after emacspeak pre act comp)
  "speak."
  (emacspeak-vterm-snapshot))

(cl-loop
 for f in
 '(vterm-previous-prompt vterm-next-prompt)
 do
 (eval
  `(defadvice ,f (after emacspeak pre act comp)
     "speak."
     (when (ems-interactive-p)
       (emacspeak-icon 'large-movement)
       (emacspeak-speak-line)))))

;;; Speech-enable term emulation:

;; This sends what you typed to the term process.  Handle terminal
;; emulation logic here, as per term-emulate-term in emacspeak-eterm.
;; Simpler because for now, we dont implement sub-windows etc.
;; ad-do-it doesn't update for native module functions?
;; tried with before/after advice pair, and we still dont see the
;; updates, so  using before advice to record state,
;; and an after advice on vterm--redraw to implement the spoken
;; feedback loop.

(defvar-local ems--vterm-row nil
  "Cache row.")

(defvar-local ems--vterm-column nil
  "Cache vterm column.")

(defvar-local ems--vterm-char nil
  "Cache current char.")

(defvar-local ems--vterm-opoint nil
  "Cache current point.")

(defsubst emacspeak-vterm-snapshot ()
  "Snapshot VTerm state."
  (cl-declare (special ems--vterm-char ems--vterm-opoint
                       ems--vterm-row ems--vterm-column))
  (setq ems--vterm-row(1+ (count-lines (point-min) (point))) ;;; line number
        ems--vterm-column (current-column) ;;; column number
        ems--vterm-opoint (point)
        ems--vterm-char (preceding-char))
  )

(defadvice vterm--flush-output (before emacspeak pre act comp)
  "Cache state before input event is processed."
  (emacspeak-vterm-snapshot))

;; speech-enable term update loop, using previously cached state.
(defvar emacspeak-vterm-debug nil
  "Debug flag")

(defadvice vterm--redraw (after emacspeak pre act comp)
  "Speech-enable term emulation."
  (let ((current-char ems--vterm-char)
        (opoint ems--vterm-opoint)
        (row ems--vterm-row)
        (column ems--vterm-column)
        (new-row (1+ (count-lines (point-min) (point))))
        (new-column (current-column)))
    (ems-with-messages-silenced ;;; debug output
     (message
      "Event: %c r: %d c: %d new-row: %d new-col: %d char: %c"
      last-command-event row column
      new-row new-column current-char))
    (cond
     ((and ;;; backspace or 127
       (memq  last-command-event    '(127 backspace))
       (= new-row row) (= -1 (- new-column column)))
      (dtk-tone-deletion)
      (emacspeak-speak-this-char current-char))
     ((and
       (= new-row row) (= 1 (- new-column column))) ;;; char insert
      (ems-with-messages-silenced (message "char insert"))
      (if (eq 32 last-command-event) ;;; word echo 
          (save-excursion (backward-char 2) (emacspeak-speak-word nil))
        (emacspeak-speak-this-char (preceding-char))))
     ((and
       (= new-row row) (= 1 (abs(- new-column column))))
      (ems-with-messages-silenced (message "horizontal char motion"))
      (emacspeak-speak-this-char (following-char)))
     ((= row new-row)
      (ems-with-messages-silenced (message "left/right motion"))
      (if (= 32 (following-char)) ;;; vi word nav
          (save-excursion (forward-char 1) (emacspeak-speak-word))
        (emacspeak-speak-word)))
     (t
      (if emacspeak-comint-autospeak
          (let ((dtk-stop-immediately  nil))
            (dtk-speak
             (string-trim
              (ansi-color-filter-apply
               (save-excursion
                 (beginning-of-line) (buffer-substring (1+ opoint) (point)))))))
        (emacspeak-speak-line))))))

(provide 'emacspeak-vterm)
;;;  end of file

