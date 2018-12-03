(require 'web-mode)
;;; (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-

(setq web-mode-auto-close-style 3)
(setq web-mode-enable-auto-closing t);
(setq web-mode-enable-auto-expanding t);
(setq web-mode-enable-auto-pairing t)
(setq web-mode-enable-auto-quoting t)
(setq web-mode-enable-auto-indentation t)
(setq web-mode-enable-auto-closing t)

(defun web-mode-auto-complete ()
  "Autocomple at point."
  (interactive)
  (let ((pos (point))
        (char (char-before))
        (chunk (buffer-substring-no-properties (- (point) 2) (point)))
        (expanders nil) (tag nil)
        (auto-closed   nil)
        (auto-expanded nil)
        (auto-paired   nil)
        (auto-quoted   nil))

    ;;-- auto-closing
    (when web-mode-enable-auto-closing

      (cond

       ((and (= web-mode-auto-close-style 3)
             (eq char ?\<))
        (insert "/>")
        (message "fefefe")
        (backward-char 2)
        (setq auto-closed t))

       ((and (= web-mode-auto-close-style 3)
             (eq char ?\>)
             (looking-at-p "/>"))
        (message "11111")
        (save-excursion
          (re-search-backward web-mode-start-tag-regexp)
          (setq tag (match-string-no-properties 1)))
        (save-excursion
          (insert "<")
          (forward-char)
          (insert tag)
          (setq auto-closed t))
        )

       ((and (>= pos 4)
             (or (string= "</" chunk)
                 ;;(progn (message "%s" chunk) nil)
                 (and (= web-mode-auto-close-style 2)
                      (or (string= web-mode-content-type "jsx")
                          (not (get-text-property pos 'part-side)))
                      (string-match-p "[[:alnum:]'\"]>" chunk)))
             (not (get-text-property (- pos 2) 'block-side))
             ;;(progn (prin1 (get-text-property (- pos 2) 'block-side)))
             (web-mode-element-close))
        (setq auto-closed t))

       ) ;cond
      ) ;when

    ;;-- auto-pairing
    (when (and web-mode-enable-auto-pairing
               (>= pos 4)
               (not auto-closed))
      (let ((i 0) expr after pos-end (l (length web-mode-auto-pairs)))
        (setq pos-end (if (> (+ pos 32) (line-end-position))
                          (line-end-position)
                        (+ pos 10)))
        (setq chunk (buffer-substring-no-properties (- pos 3) pos)
              after (buffer-substring-no-properties pos pos-end))
        (while (and (< i l) (not auto-paired))
          (setq expr (elt web-mode-auto-pairs i)
                i (1+ i))
          ;;(message "chunk=%S expr=%S after=%S" chunk expr after)
          (when (and (string= (car expr) chunk)
                     (not (string-match-p (regexp-quote (cdr expr)) after)))
            (setq auto-paired t)
            (insert (cdr expr))
            (if (string-match-p "|" (cdr expr))
                (progn
                  (search-backward "|")
                  (delete-char 1))
              (goto-char pos))
            ) ;when
          ) ;while
        ) ;let
      )

    ;;-- auto-expanding
    (when (and web-mode-enable-auto-expanding
               (not auto-closed)
               (not auto-paired)
               (eq char ?\/)
               (looking-back "\\(^\\|[[:punct:][:space:]>]\\)./" (point-min))
               (or (web-mode-jsx-is-html (1- pos))
                   (and (not (get-text-property (1- pos) 'tag-type))
                        (not (get-text-property (1- pos) 'part-side))))
               (not (get-text-property (1- pos) 'block-side))
               )
      (setq expanders (append web-mode-expanders web-mode-extra-expanders))
      (let ((i 0) pair (l (length expanders)))
        (setq chunk (buffer-substring-no-properties (- pos 2) pos))
        ;;(message "%S" chunk)
        (while (and (< i l) (not auto-expanded))
          (setq pair (elt expanders i)
                i (1+ i))
          (when (string= (car pair) chunk)
            (setq auto-expanded t)
            (delete-char -2)
            (insert (cdr pair))
            (when (string-match-p "|" (cdr pair))
              (search-backward "|")
              (delete-char 1))
            ) ;when
          ) ;while
        ) ;let
      )

    ;;-- auto-quoting
    (when (and web-mode-enable-auto-quoting
               (>= pos 4)
               (not (get-text-property pos 'block-side))
               (not auto-closed)
               (not auto-paired)
               (not auto-expanded)
               ;;;(progn (prin1 pos))
               ;;;(progn (prin1 (get-text-property (- pos 2) 'tag-attr)))
               (get-text-property (- pos 2) 'tag-attr)
               )
      (cond
       ((and (eq char ?\=)
             (not (looking-at-p "[ ]*[\"']")))
        (if (= web-mode-auto-quote-style 2)
            (insert "''")
          (insert "\"\""))
        (if (looking-at-p "[ \n>]")
            (backward-char)
          (insert " ")
          (backward-char 2)
          )
        (setq auto-quoted t))
       ((and (eq char ?\")
             (looking-back "=[ ]*\"" (point-min))
             (not (looking-at-p "[ ]*[\"]")))
        (insert-and-inherit "\"")
        (backward-char)
        (setq auto-quoted t))
       ((and (eq char ?\')
             (looking-back "=[ ]*'" (point-min))
             (not (looking-at-p "[ ]*[']")))
        (insert-and-inherit "'")
        (backward-char)
        (setq auto-quoted t))
       ((and (eq char ?\{)
             (eq (get-text-property pos 'part-side) 'jsx)
             (looking-back "=[ ]*{" (point-min))
             (not (looking-at-p "[ ]*[}]")))
        (insert-and-inherit "}")
        (backward-char)
        (setq auto-quoted t))
       ((and (eq char ?\")
             (eq (char-after) ?\"))
        (delete-char 1)
        (cond
         ((looking-back "=\"\"" (point-min))
          (backward-char))
         ((eq (char-after) ?\s)
          (forward-char))
         (t
          (insert " "))
         )                              ;cond
        )
       )                                ;cond
      ) ;when

    ;;--
    (cond
     ((or auto-closed auto-paired auto-expanded auto-quoted)
      (when (and web-mode-change-end (>= (line-end-position) web-mode-change-end))
        (setq web-mode-change-end (line-end-position)))
      (list :auto-closed auto-closed
            :auto-paired auto-paired
            :auto-expanded auto-expanded
            :auto-quoted auto-quoted))
     (t
      nil)
     )

    ))
(web-mode-on-post-command)
(add-hook 'post-command-hook 'web-mode-on-post-command nil t)



(provide 'init-web-mode)
