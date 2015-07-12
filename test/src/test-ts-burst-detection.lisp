
(in-package :clml.test)

(define-test test-ts-burst-detection
    (let (ts bi)
      (assert-true 
       (setf ts (time-series-data 
                 (read-data-from-file
                  (clml.utility.data:fetch "https://mmaul.github.io/clml.data/sample/burst-data.sexp"))
                 :time-label 0)))
      (assert-equality #'= 77 (length (ts-points ts)))
      (assert-equality
       #'equal
       (setf bi (continuous-kleinberg ts :if-overlap :delete))
       '((0 0.0) (0 100.0) (0 200.0) (0 300.0) (0 400.0) (0 410.0) (1 415.0)
         (1 420.0) (1 425.0) (1 430.0) (1 435.0) (1 440.0) (1 445.0) (1 450.0)
         (2 451.0) (2 453.0) (2 455.0) (2 457.0) (2 459.0) (2 461.0) (2 463.0)
         (2 465.0) (2 467.0) (2 469.0) (2 480.0) (2 485.0) (2 490.0) (2 495.0)
         (2 500.0) (2 505.0) (2 510.0) (2 515.0) (2 520.0) (2 525.0) (2 530.0)
         (2 535.0) (2 540.0) (2 545.0) (2 550.0) (2 555.0) (2 560.0) (2 565.0)
         (3 565.5) (3 566.0) (3 566.5) (3 567.0) (3 567.5) (3 568.0) (3 569.0)
         (3 569.5) (3 570.0) (1 575.0) (1 580.0) (1 585.0) (1 590.0) (1 595.0)
         (1 600.0) (0 700.0) (0 710.0) (1 715.0) (1 720.0) (1 725.0) (1 730.0)
         (1 735.0) (1 740.0) (1 745.0) (1 750.0) (1 755.0) (1 760.0) (1 765.0)
         (1 770.0) (1 775.0) (1 780.0) (0 790.0) (0 800.0) (0 900.0) (0 1000.0)))
      (assert-equality
       #'equal
       (print-burst-indices bi :type :time-sequence)
       '((0.0 0) (410.0 1) (450.0 2) (565.0 3) (570.0 1) (600.0 0) (710.0 1)
         (780.0 0) (1000.0 0)))
      (assert-equality
       #'equal
       (print-burst-indices bi :type :burst-index-sequence)
       '((:INDEX 0 :START 0.0 :END 1000.0) (:INDEX 1 :START 410.0 :END 600.0)
         (:INDEX 2 :START 450.0 :END 570.0) (:INDEX 3 :START 565.0 :END 570.0)
         (:INDEX 1 :START 710.0 :END 780.0)))
      (assert-equality
       #'equal
       (let ((str (make-array 0 :element-type 'character
                              :adjustable t :fill-pointer t)))
         (with-output-to-string (s str)
           (print-burst-indices bi :stream s))
         str)
       #+ (or allegro lispworks) "   0.0 |
 410.0 |+
 450.0 |++
 565.0 |+++
 570.0 |+
 600.0 |
 710.0 |+
 780.0 |
1000.0 |
"
       #+ (not (or allegro lispworks))
       "   0.0d0 |
 410.0d0 |+
 450.0d0 |++
 565.0d0 |+++
 570.0d0 |+
 600.0d0 |
 710.0d0 |+
 780.0d0 |
1000.0d0 |
")

      (assert-equality
       #'equal
       (continuous-kleinberg '((1)) :if-overlap :delete)
       '((0 1)))
      (assert-equality
       #'equal
       (continuous-kleinberg '((1 "abc")) :if-overlap :delete)
       '((0 "abc")))
      
#+allegro
      (progn
        (assert-true 
         (setf ts (time-series-data 
                   (read-data-from-file
                    (clml.utility.data:fetch "https://mmaul.github.io/clml.data/sample/burst-string-time-data.sexp"))
                   :time-label 0
                   :except '(0))))
        (assert-equality #'= 4778 (length (ts-points ts)))
        (assert-true
         (setf bi (continuous-kleinberg ts :time-reader #'date-time-to-ut :if-overlap :delete :column-number 2)))
        (assert-equality
         #'equal
         (print-burst-indices bi :type :burst-index-sequence)
         '((:INDEX 0 :START "2012-10-19T23:30:01+09:00" :END
                   "2012-12-31T23:18:03+09:00")
           (:INDEX 1 :START "2012-11-14T15:32:02+09:00" :END
            "2012-11-15T23:02:27+09:00")
           (:INDEX 2 :START "2012-11-14T15:32:02+09:00" :END
            "2012-11-14T19:30:01+09:00")
           (:INDEX 2 :START "2012-11-15T10:38:08+09:00" :END
            "2012-11-15T17:18:01+09:00")
           (:INDEX 1 :START "2012-11-16T16:15:12+09:00" :END
            "2012-11-17T00:30:25+09:00")
           (:INDEX 1 :START "2012-11-20T08:59:43+09:00" :END
            "2012-11-22T08:50:33+09:00")
           (:INDEX 1 :START "2012-11-23T06:51:04+09:00" :END
            "2012-11-26T23:21:01+09:00")
           (:INDEX 2 :START "2012-11-24T10:53:41+09:00" :END
            "2012-11-24T14:04:22+09:00")
           (:INDEX 1 :START "2012-12-05T23:36:58+09:00" :END
            "2012-12-06T03:48:12+09:00")
           (:INDEX 2 :START "2012-12-05T23:36:58+09:00" :END
            "2012-12-06T02:01:10+09:00")
           (:INDEX 3 :START "2012-12-05T23:36:58+09:00" :END
            "2012-12-05T23:51:35+09:00")
           (:INDEX 4 :START "2012-12-05T23:36:58+09:00" :END
            "2012-12-05T23:51:35+09:00")
           (:INDEX 5 :START "2012-12-05T23:36:58+09:00" :END
            "2012-12-05T23:51:35+09:00")
           (:INDEX 1 :START "2012-12-16T17:46:34+09:00" :END
            "2012-12-20T21:39:37+09:00")
           (:INDEX 2 :START "2012-12-16T21:33:10+09:00" :END
            "2012-12-18T01:16:04+09:00")
           (:INDEX 3 :START "2012-12-16T21:33:10+09:00" :END
            "2012-12-17T00:41:05+09:00")
           (:INDEX 2 :START "2012-12-18T09:05:04+09:00" :END
            "2012-12-18T22:27:01+09:00")
           (:INDEX 3 :START "2012-12-18T09:05:04+09:00" :END
            "2012-12-18T20:31:03+09:00")
           (:INDEX 4 :START "2012-12-18T11:42:01+09:00" :END
            "2012-12-18T14:19:15+09:00")
           (:INDEX 1 :START "2012-12-23T09:45:25+09:00" :END
            "2012-12-24T02:07:07+09:00")
           (:INDEX 1 :START "2012-12-24T18:39:00+09:00" :END
            "2012-12-26T19:09:23+09:00")
           (:INDEX 2 :START "2012-12-25T11:02:11+09:00" :END
            "2012-12-25T16:20:07+09:00")
           (:INDEX 2 :START "2012-12-26T07:12:01+09:00" :END
            "2012-12-26T15:44:45+09:00")
           (:INDEX 3 :START "2012-12-26T14:45:00+09:00" :END
            "2012-12-26T15:44:45+09:00")
           (:INDEX 4 :START "2012-12-26T14:53:19+09:00" :END
            "2012-12-26T15:36:03+09:00")))
        (assert-equality
         #'equal
         (print-burst-indices bi :type :time-sequence)
         '(("2012-10-19T23:30:01+09:00" 0) ("2012-11-14T15:32:02+09:00" 2)
           ("2012-11-14T19:30:01+09:00" 1) ("2012-11-15T10:38:08+09:00" 2)
           ("2012-11-15T17:18:01+09:00" 1) ("2012-11-15T23:02:27+09:00" 0)
           ("2012-11-16T16:15:12+09:00" 1) ("2012-11-17T00:30:25+09:00" 0)
           ("2012-11-20T08:59:43+09:00" 1) ("2012-11-22T08:50:33+09:00" 0)
           ("2012-11-23T06:51:04+09:00" 1) ("2012-11-24T10:53:41+09:00" 2)
           ("2012-11-24T14:04:22+09:00" 1) ("2012-11-26T23:21:01+09:00" 0)
           ("2012-12-05T23:36:58+09:00" 5) ("2012-12-05T23:51:35+09:00" 2)
           ("2012-12-06T02:01:10+09:00" 1) ("2012-12-06T03:48:12+09:00" 0)
           ("2012-12-16T17:46:34+09:00" 1) ("2012-12-16T21:33:10+09:00" 3)
           ("2012-12-17T00:41:05+09:00" 2) ("2012-12-18T01:16:04+09:00" 1)
           ("2012-12-18T09:05:04+09:00" 3) ("2012-12-18T11:42:01+09:00" 4)
           ("2012-12-18T14:19:15+09:00" 3) ("2012-12-18T20:31:03+09:00" 2)
           ("2012-12-18T22:27:01+09:00" 1) ("2012-12-20T21:39:37+09:00" 0)
           ("2012-12-23T09:45:25+09:00" 1) ("2012-12-24T02:07:07+09:00" 0)
           ("2012-12-24T18:39:00+09:00" 1) ("2012-12-25T11:02:11+09:00" 2)
           ("2012-12-25T16:20:07+09:00" 1) ("2012-12-26T07:12:01+09:00" 2)
           ("2012-12-26T14:45:00+09:00" 3) ("2012-12-26T14:53:19+09:00" 4)
           ("2012-12-26T15:36:03+09:00" 3) ("2012-12-26T15:44:45+09:00" 1)
           ("2012-12-26T19:09:23+09:00" 0) ("2012-12-31T23:18:03+09:00" 0)))
        (assert-equality
       #'equal
       (let ((str (make-array 0 :element-type 'character
                              :adjustable t :fill-pointer t)))
         (with-output-to-string (s str)
           (print-burst-indices bi :stream s))
         str)
       "2012-10-19T23:30:01+09:00 |
2012-11-14T15:32:02+09:00 |++
2012-11-14T19:30:01+09:00 |+
2012-11-15T10:38:08+09:00 |++
2012-11-15T17:18:01+09:00 |+
2012-11-15T23:02:27+09:00 |
2012-11-16T16:15:12+09:00 |+
2012-11-17T00:30:25+09:00 |
2012-11-20T08:59:43+09:00 |+
2012-11-22T08:50:33+09:00 |
2012-11-23T06:51:04+09:00 |+
2012-11-24T10:53:41+09:00 |++
2012-11-24T14:04:22+09:00 |+
2012-11-26T23:21:01+09:00 |
2012-12-05T23:36:58+09:00 |+++++
2012-12-05T23:51:35+09:00 |++
2012-12-06T02:01:10+09:00 |+
2012-12-06T03:48:12+09:00 |
2012-12-16T17:46:34+09:00 |+
2012-12-16T21:33:10+09:00 |+++
2012-12-17T00:41:05+09:00 |++
2012-12-18T01:16:04+09:00 |+
2012-12-18T09:05:04+09:00 |+++
2012-12-18T11:42:01+09:00 |++++
2012-12-18T14:19:15+09:00 |+++
2012-12-18T20:31:03+09:00 |++
2012-12-18T22:27:01+09:00 |+
2012-12-20T21:39:37+09:00 |
2012-12-23T09:45:25+09:00 |+
2012-12-24T02:07:07+09:00 |
2012-12-24T18:39:00+09:00 |+
2012-12-25T11:02:11+09:00 |++
2012-12-25T16:20:07+09:00 |+
2012-12-26T07:12:01+09:00 |++
2012-12-26T14:45:00+09:00 |+++
2012-12-26T14:53:19+09:00 |++++
2012-12-26T15:36:03+09:00 |+++
2012-12-26T15:44:45+09:00 |+
2012-12-26T19:09:23+09:00 |
2012-12-31T23:18:03+09:00 |
")
        )
      ))
