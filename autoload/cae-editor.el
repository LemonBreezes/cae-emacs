;;; autoload/cae-editor.el -*- lexical-binding: t; -*-

;;;###autoload
(defun cae-kill-buffer-a (orig-func &optional buffer-or-name)
  (setq buffer-or-name (or buffer-or-name (current-buffer)))
  (catch 'quit
    (save-window-excursion
      (with-current-buffer buffer-or-name
        (let (done (buf (current-buffer)))
          (when (and buffer-file-name (buffer-modified-p))
            (while (not done)
              (let ((response (read-char-choice
                               (format "Save file %s? (y, n, d, q) " (buffer-file-name buf))
                               '(?y ?n ?d ?q))))
                (setq done (cond
                            ((eq response ?q) (throw 'quit nil))
                            ((eq response ?y) (save-buffer) t)
                            ((eq response ?n) (set-buffer-modified-p nil) t)
                            ((eq response ?d) (diff-buffer-with-file) nil))))))
          (funcall orig-func buffer-or-name))))))

;;;###autoload
(defun cae-sp-delete-char (&optional arg)
  (interactive "*P")
  (cond ((and delete-active-region
              (region-active-p))
         (sp-delete-region (region-beginning) (region-end)))
        ;; Only call `delete-char' if the parens are unbalanced.
        ((condition-case error
             (scan-sexps (point-min) (point-max))
           (scan-error t))
         (delete-char (or arg 1)))
        ((sp-delete-char arg))))
