;;; lisp/cae-hacks.el -*- lexical-binding: t; -*-

;; For when we compile Doom.
(defvar personal-keybindings nil)

;; Prevent the minibuffer from "glitching" the workspace switch.
(defadvice! cae-hacks-workspace-ignore-minibuffer-a (&rest _)
  :before-until #'+workspace/switch-to
  (minibuffer-window-active-p (selected-window)))

;; Prevent hydras from remaining active when switching workspaces.
(after! (:all persp-mode hydra)
  (defun cae-hacks-hydra-quit-h (&rest _)
    (hydra-keyboard-quit))
  (add-hook 'persp-before-switch-functions #'cae-hacks-hydra-quit-h))

;; Make `advice-remove' ignore the keyword argument
(defadvice! cae-hacks-advice-remove-ignore-keyword-args-a (args)
  :filter-args #'advice-remove
  (if (keywordp (nth 1 args))
      (list (nth 0 args) (nth 2 args))
    args))

;; Use --no-sandbox when running Chromium, Discord, etc. as the root user.
(when (eq (user-uid) 0)
  (defadvice! cae-hacks-call-process-shell-command-a (args)
    :filter-args #'call-process-shell-command
    (when (cl-member (file-name-base (car (split-string (car args) " ")))
                     '("chromium-bin-browser"
                       "chromium-bin"
                       "google-chrome-beta"
                       "discord"
                       "signal-desktop"
                       "vscode" "vscodium" "code")
                     :test #'string=)
      (setf (car args)
            (concat (string-trim-right (car args))
                    " --no-sandbox")))
    args))

;; Call `pp-eval-last-sexp' when `eros-eval-last-sexp' is called with a negative
;; prefix argument
(defadvice! cae-hacks-eros-eval-last-sexp-with-pp-a (oldfun arg)
  :around #'eros-eval-last-sexp
  (if (or (eq arg '-)
          (and (numberp arg)
               (< arg 0)))
      (funcall #'pp-eval-last-sexp
               (if (numberp arg)
                   arg nil))
    (funcall oldfun arg)))

;; A generic adviser for responding yes to yes or no prompts automatically.
(defun cae-hacks-always-yes-a (oldfun &rest args)
  (cl-letf (((symbol-function #'yes-or-no-p) (symbol-function #'always))
            ((symbol-function #'y-or-n-p) (symbol-function #'always)))
    (apply oldfun args)))

;; `magit' breaks move line in log buffers.
(defadvice! cae-hacks-magit-do-not-deincrement-a (args)
  :filter-args '(magit-previous-line magit-next-line)
  (let ((arg (car args))
        (try-vscroll (second args)))
    (and (numberp arg)
         (not (eq arg 0))
         transient-mark-mode
         (not (region-active-p))
         (not (and (memq 'shift (event-modifiers last-input-event))
                   shift-select-mode))
         (cl-incf arg))
    (list arg try-vscroll)))

;; Compile Vterm without asking.
(defvar vterm-always-compile-module t)
(defadvice! cae-vterm-module-compile-silently-a (oldfun)
  :around #'vterm-module-compile
  (advice-add #'pop-to-buffer :override #'ignore)
  (unwind-protect (funcall oldfun)
    (advice-remove #'pop-to-buffer #'ignore)))

;; Use the system's `libvterm' if available.
(defvar vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes")
