(load-file "./util.el")

(defun aoc/day1/part1 ()
  (interactive)
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

(defun aoc/day1/part2/convert-str-to-digit (s)
  (cond ((equal s "zero") "0")
	((equal s "one") "1")
	((equal s "two") "2")
	((equal s "three") "3")
	((equal s "four") "4")
	((equal s "five") "5")
	((equal s "six") "6")
	((equal s "seven") "7")
	((equal s "eight") "8")
	((equal s "nine") "9")
	(t s)))

(defun aoc/day1/part2/find-first-digit ()
  (save-excursion
    (re-search-forward "[[:digit:]]\\|one\\|two\\|three\\|four\\|five\\|six\\|seven\\|eight\\|nine\\|zero"
		       (line-end-position))
    (setq-local re-match (buffer-substring (match-beginning 0) (match-end 0)))
    (aoc/day1/part2/convert-str-to-digit re-match)))

(defun aoc/day1/part2/find-last-digit ()
  (save-excursion
    (re-search-backward "[[:digit:]]\\|one\\|two\\|three\\|four\\|five\\|six\\|seven\\|eight\\|nine\\|zero"
		       (line-beginning-position))
    (setq-local re-match (buffer-substring (match-beginning 0) (match-end 0)))
    (aoc/day1/part2/convert-str-to-digit re-match)))

(defun aoc/day1/part2 ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (setq-local lines-remaining-p t)
    (setq-local sum-combined 0)
    (while lines-remaining-p
      ;; check line has content
      (unless (current-line-empty-p)
	;; find the first digit in line
	(beginning-of-line)
	(setq-local first-digit (aoc/day1/part2/find-first-digit))
	;; find the last digit in line
	(end-of-line)
	(setq-local last-digit (aoc/day1/part2/find-last-digit))
	;; concatenate the numbers
	(let ((combined-number-s (concat first-digit last-digit)))
	  ;; add number to the result
	  (setq-local sum-combined
		      (+ sum-combined (string-to-number combined-number-s)))))
      ;; move to the next line, else break from loop
      (setq-local lines-remaining-p (= 0 (forward-line 1))))
    ;; display the result
    (message "Result: %s" sum-combined)))
