;;;
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)
;; set right chinese font
(set-fontset-font "fontset-default" 'gb18030 '("Microsoft YaHei". "unicode-bmp"))

(provide 'init-my-locales)
;;; init-my-locales.el ends here
