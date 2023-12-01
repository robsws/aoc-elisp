
(defun current-line-empty-p ()
  (save-excursion
    (beginning-of-line)
    (looking-at-p "[[:blank:]]*$")))

(defun aoc/day1-part1 ()
  (save-excursion
    (goto-char (point-min))
    (setq-local lines-remaining-p t)
    (setq-local sum-combined 0)
    (while lines-remaining-p
      ;; check line has content
      (unless (current-line-empty-p)
	;; find the first digit in line
	(beginning-of-line)
	(setq-local first-digit
		    (char-to-string
		     (char-before
		      (re-search-forward "[[:digit:]]" (line-end-position)))))
	;; find the last digit in line
	(end-of-line)
	(setq-local last-digit
		    (char-to-string
		     (char-after
		      (re-search-backward "[[:digit:]]" (line-beginning-position)))))
	;; concatenate the numbers
	(let ((combined-number-s (concat first-digit last-digit)))
	  ;; add number to the result
	  (setq-local sum-combined
		      (+ sum-combined (string-to-number combined-number-s)))))
      ;; move to the next line, else break from loop
      (setq-local lines-remaining-p (= 0 (forward-line 1))))
    ;; display the result
    (message "Result: %s" sum-combined)))

(defun aoc-run (day part)
  (interactive "nDay to run:\nnPart to run:\n")
  (cond ((and (eql day 1) (eql part 1)) (aoc/day1-part1))
	(t lambda () (message "Solution not yet implemented"))))

(defun aoc-run-today ()
  (interactive)
  (aoc-run 1 1))
