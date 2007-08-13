;;; Emacs initialization file for Raman.
;;; $Id$
;;; Segre March 22 1991
;;; July 15, 2001 finally cutting over to custom.
;;; August 12, 2007: Cleaned up for Emacs 22
(require 'cl)
(declare  (optimize  (safety 0) (speed 3)))
;;{{{ personal lib
(defvar emacs-private-library
  (expand-file-name "~/.elisp")
  "Private personalization directory. ")
(defvar emacs-personal-library
  (expand-file-name "~/emacs/lisp/site-lisp")
  "Directory where we keep personal libraries")
;;}}}
;;{{{ helper functions:
(defsubst augment-load-path (path &optional library whence at-end)
  "add directory to load path.
Path is resolved relative to `whence' which defaults to emacs-personal-library."
  (interactive "Denter directory name: ")
  (declare (special emacs-personal-library))
  (unless (and library
	       (locate-library library))
    (add-to-list 'load-path
		 (expand-file-name path
				   (or whence
				       (and (boundp
					     'emacs-personal-library)
					    emacs-personal-library)))
		 at-end))
  (when library (locate-library library)))
(defsubst augment-auto-mode-alist (ext mode)
  "Add to auto-mode-alist."
  (declare (special auto-mode-alist))
  (setq auto-mode-alist
	(cons
	 (cons ext mode)
	 auto-mode-alist)))
(defsubst load-library-if-available (lib)
  "Load a library only if it is around"
  (let ((emacspeak-speak-messages nil))
    (condition-case nil
	(cond
	 ((locate-library lib)
	  (load-library lib)
	  (message "Loaded %s" lib)
	  t)
	 (t (message "Could not locate library %s" lib)
	    nil))
      (error (message
	      "Error loading %s"
	      lib)))))
;;}}}
;;{{{ customize custom
(setq outline-minor-mode-prefix "\C-l")
(declare (special custom-file))
(setq custom-file (expand-file-name "~/.customize-emacs"))
;;}}}
(defun start-up-my-emacs()
  "Start up emacs for me. "
  (interactive)
  (declare (special emacs-personal-library
		    emacs-private-library))
  (let ((gc-cons-threshold 8000000))
    (when (file-exists-p  emacs-private-library)
      (augment-load-path emacs-private-library ))
    (when (file-exists-p  emacs-personal-library)
      (augment-load-path emacs-personal-library))
    ;;{{{ Load and customize emacspeak
    (unless (featurep 'emacspeak)
      (load-file (expand-file-name "~/emacs/lisp/emacspeak/lisp/emacspeak-setup.el")))
    (when (featurep 'emacspeak)
      (emacspeak-toggle-auditory-icons t)
      (when (emacspeak-sounds-theme-p "chimes-stereo/")
	(emacspeak-sounds-select-theme "chimes-stereo/"))
      (tts-configure-synthesis-setup)
      (dtk-set-rate tts-default-speech-rate 'global))
    ;;}}}
    ;;{{{  set up terminal codes and global keys
    (mapc #'load-library-if-available
	    '("console"
	      "screen"))
;;{{{  global key definitions
    (loop for  key in
	  '(
	    ( [f5]bury-buffer)
	    ([delete]dtk-toggle-punctuation-mode)
	    ( [f8]emacspeak-remote-quick-connect-to-server)
	    ([f11]shell)
	    ([f12]vm)
	    ( "\C-xc"compile)
	    (  "\C-x%"comment-region)
	    ( "\M-r"replace-string)
	    ( "\M-e"end-of-word)
	    ( "\M-\C-j"imenu)
	    ( "\M-\C-c"calendar))
	  do
	  (global-set-key (first key) (second key)))
(require 'dired-x)
(require 'dired-aux)
    ;;}}}
    ;;}}}
    ;;{{{  initial stuff

(put 'upcase-region 'disabled nil)
    (put 'downcase-region 'disabled nil)
    (put 'narrow-to-region 'disabled nil)
    (put 'eval-expression 'disabled nil)
    (add-hook 'find-file-hook 'turn-on-auto-fill)
    ;;}}}
    ;;{{{  completion: tmc
    (dynamic-completion-mode)
    (condition-case nil
	(initialize-completions)
      (error (message "Completions not started cleanly.")))
    ;;}}}
    ;;{{{  dired
    ;(require 'dired)
    ;(require 'dired-x)
    ;(require 'dired-aux)
    ;;}}}
    ;;{{{  different mode settings
;;; Mode hooks.
    (declaim (special  completion-ignored-extensions))
    (eval-after-load "shell"
      '(progn
	 (define-key shell-mode-map "\C-cr" 'comint-redirect-send-command)
	 (define-key shell-mode-map "\C-ch"
      'emacspeak-wizards-refresh-shell-history)))
;;}}}
;;{{{  vm setup
    ;;}}}
;;{{{ Prepare needed libraries
    (mapc
     #'load-library-if-available
     '(
;;; personal functions and advice
       "advice-setup" "my-functions"
;;; Mail readers:
       "vm-prepare" "bbdb-prepare"
       "smtpmail" "mailcrypt-prepare" "sigbegone"
;;; Web Browsers:
       "w3-prepare" "w3m-prepare" "wget-prepare"
       "auctex-prepare" "nxml-prepare"
       "folding-prepare"
       "calc-prepare" "ess-prepare"
       "tcl-prepare" "python-mode-prepare" "moz-prepare"
       "view-ps-prepare"
					; jde and ecb will pull in cedet.
					;"jde-prepare" "ecb-prepare"
       "mspools-prepare"
       "dismal-prepare"
       "cperl-mode" "ruby-prepare"
       "pcl-prepare"
       "erc-prepare" "jabber-prepare"
       "browse-kill-ring"
       "dictionary-prepare"
       "tramp-prepare"
       "dirvars" "color-theme" "crontab-mode"
       "fff-prepare" "fap-prepare"
       "local"))
;;}}}
    ;;{{{ whitespace

    (require 'whitespace)
    (add-hook 'write-file-functions 'whitespace-buffer)

    ;;}}}
    ))                                  ; end defun
;;{{{  start it up
(add-hook 'after-init-hook
	  #'(lambda ()
	      (color-theme-emacs-21)
	      (bbdb-insinuate-vm)
	      (server-start)
	      (dtk-set-rate tts-default-speech-rate 'global)
	      (shell)
	      (calendar)
	      (when (file-exists-p custom-file)
  (load-file custom-file))
	      (message "Successfully initialized Emacs")
	      (shell-command "aplay ~/cues/highbells.au")))
(start-up-my-emacs)
;;}}}
(provide 'emacs-startup)
;;{{{  emacs local variables
;;;local variables:
;;;folded-file: t
;;;end:
;;}}}
