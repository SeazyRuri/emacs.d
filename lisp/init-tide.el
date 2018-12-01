;;tide-typescript-mode-config;
(defun setup-tide-mode ()
  "Setup-tide-mode."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-idle-change-delay 1)
  (setq flycheck-check-syntax-automatically '(idle-change))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))
(setq company-tooltip-align-annotations t)
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode);
(dolist (hook (list
               'js2-mode-hook
               'rjsx-mode-hook
                                        ;'typescript-mode-hook
               ))
  (add-hook hook (lambda ()
                   (tide-setup)
                   (unless (tide-current-server)
                     (tide-restart-server))
                   )))

(setq tide-always-show-documentation t)

(provide 'init-tide)
