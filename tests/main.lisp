(defpackage mp3tag/tests/main
  (:use :cl
        :mp3tag
        :rove))
(in-package :mp3tag/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :mp3tag)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
