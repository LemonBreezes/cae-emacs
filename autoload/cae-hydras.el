;;; autoload/cae-hydras.el -*- lexical-binding: t; -*-

;;;###autoload (autoload 'cae-embark-collect-cheatsheet-hydra/body "autoload/cae-hydras" nil t)
(defhydra cae-embark-collect-cheatsheet-hydra (:color pink :foreign-keys run)
  ("a" embark-act "Act" :column "Act")
  ("A" embark-act-all "Act on all" :column "Act")
  ("E" embark-export "Export" :column "Act")
  ("S" tabulated-list-sort "Sort" :column "Navigate")
  ("m" embark-collect-mark "Mark" :column "Act")
  ("s" isearch-forward "Search forward" :column "Navigate")
  ("{" outline-previous-heading "Previous heading" :column "Navigate")
  ("}" outline-next-heading "Next heading" :column "Navigate")
  ("u" embark-collect-unmark "Unmark" :column "Act")
  ("U" embark-collect-unmark-all "Unmark all" :column "Act")
  ("t" embark-collect-toggle-marks "Toggle marks" :column "Act")
  ("M-a" embark-collect-direct-action-minor-mode "Toggle direct action" :column "Act")
  ("M-<left>" tabulated-list-previous-column "Previous column" :column "Navigate")
  ("M-<right>" tabulated-list-next-column "Next column" :column "Navigate")
  ("<f6>" nil "Exit" :exit t :column nil))
