(setq max-red-cubes 12)
(setq max-green-cubes 13)
(setq max-blue-cubes 14)

(load-file "./util.el")

(defun aoc/day2/part1 ()
  (interactive)
  (save-excursion
    (setq-local lines-remaining-p t)
    (setq-local possible-games-count 0)
    (setq-local id 0)
    (setq-local id-sum 0)

    (goto-char (point-min))
    (while lines-remaining-p
      (unless (current-line-empty-p)
	(setq-local id (+ id 1))
	(setq-local game (aoc/day2/part1/parse-line-at-point))
	(when (aoc/day2/part1/is-valid-game game)
	  (setq-local id-sum (+ id-sum id))))
      (setq-local lines-remaining-p (= 0 (forward-line 1))))
    (message "Result: %s" id-sum)))

(defun aoc/day2/part1/parse-line-at-point ()
  (setq-local draws '())
  (setq-local current-draw '())
  (save-excursion
    (while (re-search-forward
	   "\\([[:digit:]]+\\) \\(blue\\|green\\|red\\)\\([,;]?\\)"
	   (line-end-position) t)
      (setq-local amount (string-to-number (buffer-substring (match-beginning 1) (match-end 1))))
      (setq-local colour (buffer-substring (match-beginning 2) (match-end 2)))
      (setq-local delim (buffer-substring (match-beginning 3) (match-end 3)))
      (setq-local current-draw (cons (cons colour amount) current-draw))
      (if (not (equal delim ","))
	  (progn
	    (setq-local draws (cons current-draw draws))
	    (setq-local current-draw '())))))
  draws)

(defun aoc/day2/part1/is-valid-game (game)
  (if game
      (and
       (aoc/day2/part1/is-valid-draw (car game))
       (aoc/day2/part1/is-valid-game (cdr game)))
    t))
	
(defun aoc/day2/part1/is-valid-draw (draw)
  (if draw
      (let ((colour (car (car draw)))
	    (amount (cdr (car draw))))
	(and
	 (cond ((equal colour "red")
		(<= amount max-red-cubes))
	       ((equal colour "green")
		(<= amount max-green-cubes))
	       ((equal colour "blue")
		(<= amount max-blue-cubes))
	       (t nil))
	 (aoc/day2/part1/is-valid-draw (cdr draw))))
    t))
