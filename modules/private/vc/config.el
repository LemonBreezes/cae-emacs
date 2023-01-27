;;; private/vc/config.el -*- lexical-binding: t; -*-

(when (modulep! :ui vc-gutter)
  (setq! +vc-gutter-in-remote-files t
         +vc-gutter-in-margin t))

;; Got these from Prot's config. Say, how do I even use `add-log' and `vc'?
(after! add-log
  (setq! add-log-keep-changes-together t))
(after! vc-git
  (setq! vc-git-diff-switches '("--patch-with-stat" "--histogram")
         vc-git-print-log-follow t
         vc-annotate-background-mode nil))

(after! magit
  (when (modulep! :ui vc-gutter +diff-hl)
    (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
  (map! :map magit-status-mode-map
        [remap +fold/toggle] #'magit-section-toggle)
  (setq! magit-diff-refine-hunk 'all
         magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")
         magit-repository-directories '(("~/src/" . 2))
         transient-values '((magit-rebase "--autosquash" "--autostash")
                            (magit-pull "--rebase" "--autostash")
                            (magit-revert "--autostash"))))

(when (and (modulep! :ui vc-gutter)
           (not (modulep! :ui vc-gutter +diff-hl)))
  (add-hook 'git-gutter-mode-hook
            (defun +vc-gutter-update-deferred-h ()
              (run-at-time 0.1 nil
                           `(lambda ()
                              (unless (eq (vc-backend (buffer-file-name)) 'Backup)
                                (with-current-buffer ,(current-buffer)
                                  (+vc-gutter-update-h)))))))
  (after! git-gutter
    (setq! git-gutter:diff-option "--ignore-cr-at-eol --ignore-space-change --ignore-all-space --ignore-blank-lines")
    (setq-hook! 'git-gutter-mode-hook
      git-gutter:start-revision "master")))

(use-package! git-link
  :defer t
  :init
  (after! magit
    (map! :map magit-mode-map
          :n "yc" #'git-link-commit)))

(use-package! gitignore-templates
  :defer t
  :init
  (let ((vc-prefix (if (modulep! :editor evil) "g" "v")))
    (map! :leader (:prefix vc-prefix
                   :desc "Insert Ignore Template" :ng "i" #'gitignore-templates-insert
                   :desc "New Ignore File" :ng "I" #'gitignore-templates-new-file))))

(use-package! git-email
  :defer t
  :init
  (after! mu4e
    (require 'git-email-mu4e)
    (git-email-mu4e-mode +1))
  (setq! git-email-subject-regexp
         "^Subject:[[:space:]]*\\[[^]\n]*PATCH[^]\n]*][[:space:]]+.+\\(?:\\(?:$\\)[\s\t]\\{2\\}[^	\n$]+$\\|$\\)")
  (let ((vc-prefix (if (modulep! :editor evil) "g" "v")))
    (map! :leader
          :prefix vc-prefix
        "RET" #'git-email-format-patch))
  (map! :map dired-mode-map
        :localleader
        "g" #'git-email-send-email))

;; `vc-backup' refuses to build on Doom Emacs so I had to fork it and remove the
;; autoload line it uses.
(add-to-list 'vc-handled-backends 'Backup t)
(use-package! vc-backup
  :defer t
  :init
  (setq! make-backup-files t
         vc-make-backup-files t))
