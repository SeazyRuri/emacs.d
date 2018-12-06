;;tide-typescript-mode-config;
(require 'flycheck)
;;; for typescript
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
;;;(remove-hook 'before-save-hook 'tide-compile-file);
(defun tide-compile-on-save ()
  "Before save hook to compile a ts file before each save."
  (interactive)
  (when (and (string-equal
              (file-name-extension (buffer-file-name))
              "ts")
             (bound-and-true-p tide-mode))
    (tide-compile-file);
    ));
(add-hook 'before-save-hook 'tide-compile-on-save)


;;; for javascript with js2-mode-hook
(add-hook 'js2-mode-hook #'setup-tide-mode)
(flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)

;;; for jsx with web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(setq web-mode-content-types-alist '(("jsx" . "\\.jsx\\'")))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;;configure jsx-tide checker to run after your default jsx checker
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)

;;; for tsx file
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(setq tide-always-show-documentation t)

(provide 'init-tide)
