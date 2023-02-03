;;; ~/.doom.d/lisp/cae-repeat.el -*- lexical-binding: t; -*-

(map! "C-x O" #'other-window-previous)

(use-package! repeat
  :init
  (add-hook 'doom-first-input-hook #'repeat-mode)
  :config
  (map! :map help-map "C-r" #'describe-repeat-maps)
  (setq repeat-exit-timeout 5)

  ;; Uses special keys from my esoteric keyboard layout
  (define-repeat-map other-window
    ("o" other-window
     "O" other-window-previous))

  (define-repeat-map isearch-repeat
    ("s" isearch-repeat-forward
     "r" isearch-repeat-backward))

  (define-repeat-map winner
    ("u" winner-undo
     "r" winner-redo))

  (define-repeat-map pop-global-mark
    ("C-@" pop-global-mark))

  (define-repeat-map vc-gutter
    ("n" +vc-gutter/next-hunk
     "p" +vc-gutter/previous-hunk))

  (define-repeat-map scroll-up-command
    ("v" scroll-up-command))
  (define-repeat-map scroll-down-command
    ("v" scroll-down-command))
  (define-repeat-map vertico-scroll-up
    ("v" vertico-scroll-up))
  (define-repeat-map vertico-scroll-down
    ("v" vertico-scroll-down))

  (defun cae-repeat-ignore-when-hydra-active-a ()
    (and (featurep 'hydra) hydra-curr-map))

  (advice-add #'repeat-post-hook :before-until
              #'cae-repeat-ignore-when-hydra-active-a)

  (defun cae-repeat-exit-h ()
    (interactive)
    (repeat-exit)
    (message "Repeat mode exited"))
  (add-hook 'doom-escape-hook #'cae-repeat-exit-h)

  (autoload 'embark-verbose-indicator "embark")
  (autoload 'which-key--create-buffer-and-show "which-key"))
