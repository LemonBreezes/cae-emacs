;;; private/debugger/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun cae-debugger-dap-quit-session-a (_)
  (ignore-errors
    (let ((ignore-window-parameters t))
      (cl-loop for buf being the buffers
               when (string-match-p "gdb" (buffer-name buf)) do
               (cae-hacks-always-yes-a #'doom-kill-buffer-and-windows buf)))))

;;;###autoload
(defun cae-debugger-dap-kill-all-sessions-and-restart ()
  (interactive)
  (dap-delete-all-sessions)
  (cae-debugger-quit-session-a nil)
  (when-let ((workspace-project (cl-find (+workspace-current-name)
                                         (projectile-relevant-known-projects)
                                         :test #'string-match-p)))
    (unless (string= (projectile-project-name)
                     (+workspace-current-name))
      (projectile-switch-project-by-name workspace-project)))
  (dap-debug-last))

;;;###autoload
(defun cae-debugger-gud-comint-send-input ()
  (interactive)
  ;; Not sure why `M-x gdb' binds this command everywhere, but it does.
  (cond ((derived-mode-p 'gdb-frames-mode)
         (call-interactively #'gdb-select-frame))
        (t
         (call-interactively #'comint-send-input))))

;;;###autoload
(defun cae-debugger/open-repl ()
  (interactive)
  (pop-to-buffer
   (or (get-buffer "*dap-ui-repl*")
       (progn (dap-ui-repl)
              (let ((buf (get-buffer "*dap-ui-repl*")))
                (bury-buffer buf)
                buf)))))
