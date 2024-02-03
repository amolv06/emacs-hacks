
(add-hook 'window-configuration-change-hook
	  (lambda ()
	  (save-window-excursion
  (let ((erc-buffer-alist nil))
    (walk-windows (lambda (w)
		    (let ((buf (window-buffer w)))
		      (set-buffer buf)
		      (when (eq major-mode 'erc-mode)
			(let ((buf-name (buffer-name buf))
			      (buf-window-length (window-total-width w)))
			  (if (alist-get buf-name erc-buffer-alist nil nil 'string-equal)
			      (setf (alist-get buf-name erc-buffer-alist nil nil 'string-equal)
				    (min buf-window-length
					 (alist-get buf-name erc-buffer-alist nil nil 'string-equal)))
			    (add-to-list 'erc-buffer-alist `(,buf-name . ,buf-window-length)))))))
		  nil
		  t)
    (dolist (buf erc-buffer-alist)
      (let ((buf-name (car buf))
	    (buf-width (cdr buf)))
	(set-buffer buf-name)
	(setq-local erc-fill-column
		    (- buf-width 2))))))))
