;;;
(set-keyboard-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(modify-coding-system-alist 'process "*" 'utf-8-unix)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq-default pathname-coding-system 'utf-8-unix)
;; set right chinese font
(set-fontset-font "fontset-default" 'gb18030 '("Microsoft YaHei". "unicode-bmp"))

(provide 'init-my-locales)
;;; init-my-locales.el ends here
