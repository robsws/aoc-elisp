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

(defun aoc/day2/part2 ()
  (interactive)
  (save-excursion
    (setq-local lines-remaining-p t)
    (setq-local possible-games-count 0)
    (setq-local total-power 0)
    
    (goto-char (point-min))
    (while lines-remaining-p
      (unless (current-line-empty-p)
	(setq-local game (aoc/day2/part1/parse-line-at-point))
        (setq-local total-power (+ (aoc/day2/part2/power game) total-power)))
      (setq-local lines-remaining-p (= 0 (forward-line 1))))
    (message "Result: %s" total-power)))

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

(defun aoc/day2/part2/power (game)
  (*
   (aoc/day2/part2/min-cubes-needed-of-colour game "red")
   (aoc/day2/part2/min-cubes-needed-of-colour game "green")
   (aoc/day2/part2/min-cubes-needed-of-colour game "blue")))

(defun aoc/day2/part2/min-cubes-needed-of-colour (game colour)
  (if game
      (let ((draw (car game))
	    (rest (cdr game)))
	(max
	 (aoc/day2/part2/find-amount-of-colour draw colour)
	 (aoc/day2/part2/min-cubes-needed-of-colour rest colour)))
    0))

(defun aoc/day2/part2/find-amount-of-colour (draw colour)
  (if draw
      (let ((draw-colour (car (car draw)))
	    (amount (cdr (car draw))))
	(if (equal draw-colour colour)
	    amount
	  (aoc/day2/part2/find-amount-of-colour (cdr draw) colour)))
    0))
