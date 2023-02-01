;;; private/lisp/config.el -*- lexical-binding: t; -*-

(use-package! nameless
  :hook (emacs-lisp-mode . nameless-mode)
  :config
  (setq nameless-private-prefix t
        nameless-global-aliases '()))

(use-package! outline-minor-faces
  :hook (emacs-lisp-mode . outline-minor-faces-add-font-lock-keywords))

(add-hook 'emacs-lisp-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'lisp-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'scheme-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'clojure-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'racket-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'lfe-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'hy-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'dune-mode-hook #'cae-lisp-check-parens-before-save-h)
(add-hook 'fennel-mode-hook #'cae-lisp-check-parens-before-save-h)

(add-hook 'lisp-data-mode-hook
          (defun +enable-elisp-mode-in-dir-locals-file ()
            (when (and (not (eq major-mode 'emacs-lisp-mode))
                       (buffer-file-name)
                       (string= (file-name-nondirectory (buffer-file-name))
                                ".dir-locals.el"))
              (emacs-lisp-mode))))

;; This tool helps us a lot with regular expressions
(after! pcre2el
  (map! :prefix "C-c"
        (:prefix ("/" . "pcre2el")
                 (:prefix ("e" . "elisp"))
                 (:prefix ("p" . "pcre"))))
  (map! :map rxt--read-pcre-mode-map
        "C-c C-i" #'rxt--toggle-i-mode
        "C-c C-t" #'rxt--toggle-s-mode
        "C-c C-x" #'rxt--toggle-x-mode)
  (undefine-key! rxt--read-pcre-mode-map
    "C-c i" "C-c s" "C-c x"))
(add-hook 'emacs-lisp-mode-hook #'rxt-mode)

(use-package! topsy
  :defer t :init (add-hook 'emacs-lisp-mode-hook #'topsy-mode))

(use-package! page-break-lines
  :defer t :init (add-hook 'emacs-lisp-mode-hook #'page-break-lines-mode))
