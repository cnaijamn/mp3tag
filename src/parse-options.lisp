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

(declaim (inline opt-p opt-key opt-value))

(defun opt-p (arg)
  (char= (char arg 0) #\-))

(defun opt-key (arg)
  (intern (string-upcase (subseq arg 1))
          :keyword))

(defun opt-value (arg)
  (if (opt-p arg)
      t
      arg))

(defun parse-options (args)
  (loop with opt-plst = '()
        with remaining-args = args
        with just-lst = '()
        while remaining-args
        for arg = (pop remaining-args)
        when (opt-p arg)
          do (let* ((next-arg (first remaining-args))
                    (key (opt-key arg))
                    (value (if next-arg
                               (opt-value next-arg)
                               t)))
               (when (and next-arg
                          (not (opt-p next-arg)))
                 (pop remaining-args))
               (unless (member key opt-plst :test #'eq)
                 (setf opt-plst (append opt-plst (list key value)))))
        else
          do (unless (member arg just-lst :test #'equal)
               (push arg just-lst))
        finally (return (values opt-plst (nreverse just-lst)))))
