;;; Copyright (c) 2026 Chez Naijamn
;;;
;;; Permission is hereby granted, free of charge, to any person
;;; obtaining a copy of this software and associated documentation
;;; files (the "Software"), to deal in the Software without
;;; restriction, including without limitation the rights to use, copy,
;;; modify, merge, publish, distribute, sublicense, and/or sell copies
;;; of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be
;;; included in all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;;; NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;;; DEALINGS IN THE SOFTWARE.

(in-package #:mp3tag)

(defun get-info-command (command-list)
  (multiple-value-bind (opt-plst just-lst)
      (parse-options command-list)
    (list :mp3-file (first just-lst)
          :cover-file (getf opt-plst :c))))

(defun get-command-of-update (command-list)
  (multiple-value-bind (opt-plst just-lst)
      (parse-options command-list)
    (let ((c-val (getf opt-plst :c)))
      (remf opt-plst :c)
      (list :id3-plst opt-plst
            :mp3-file (first just-lst)
            :cover-file c-val))))

;; Info
(defun do-info (command-list)
  (let* ((lst (get-info-command command-list))
         (id3-alst (id3-info (getf lst :mp3-file)
                             (getf lst :cover-file))))
    (loop for id3 in id3-alst
          do (format t "~a:~a~%"
                     (car id3)
                     (if #1=(cdr id3) #1# "")))))
;; Update
(defun do-update (command-list)
  (let ((lst (get-command-of-update command-list)))
    (id3-update (getf lst :id3-plst)
                (getf lst :mp3-file)
                (getf lst :cover-file))))

(defun main ()
  (handler-case
      (let* ((cmdlst uiop:*command-line-arguments*)
             (mode (first cmdlst)))
        ;; Mode
        (cond
          ;; Info
          ((equal mode "info")
           (do-info (cdr cmdlst)))
          ;; Update
          ((equal mode "update")
           (do-update (cdr cmdlst)))
          ;; Error
          (t (error "UNKNOWN MODE")))
        nil)
    (error (c)
      ;TODO "Usage: ..."
      (format t "ERROR: ~a~%" (uiop:command-line-arguments))
      (format t "ERROR: ~a~%" c)
      nil)))
