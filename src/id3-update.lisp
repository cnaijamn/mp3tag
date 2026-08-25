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

(defun get-metadata-from-plst (id3-plst)
  (let ((lst nil))
    (dolist (item '((:a . "artist") (:y . "date")
                    (:l . "album") (:r . "album_artist")
                    (:d . "disc") (:k . "track")
                    (:g . "genre") (:t . "title")))
        (let ((val (getf id3-plst (car item))))
          (when val
            (push "-metadata" lst)
            (push (format nil "~a=~a" (cdr item) val) lst))))
    (nreverse lst)))

(defun get-opts-for-update (id3-plst mp3-file cover-file temp-file)
  (append
    (list "ffmpeg" "-loglevel" "error"
          "-i" mp3-file)
    (when cover-file
      (list "-i" cover-file))
    (list "-map_metadata" "-1"
          "-map" "0:a"
          "-codec:a" "copy")
    (when cover-file
      (list "-map" "1:v"
            "-codec:v" "mjpeg"
            "-disposition:v" "attached_pic"))
    (list "-id3v2_version" "4")
    (get-metadata-from-plst id3-plst)
    (list temp-file)))

(defun set-id3-by-ffmpeg (id3-plst mp3-file cover-file)
  (let ((temp-file (namestring (make-temp-pathname mp3-file "mp3"))))
    (unwind-protect
        (progn
          (uiop:run-program
            (get-opts-for-update id3-plst
                                 mp3-file
                                 cover-file
                                 temp-file))
          (rename-file temp-file mp3-file))
      (when (probe-file temp-file)
        (delete-file temp-file)))))

;; Update
(defun id3-update (id3-plst mp3-pathname &optional cover-pathname)
  (progn
    (set-id3-by-ffmpeg id3-plst
                       (uiop:native-namestring mp3-pathname)
                       (uiop:native-namestring cover-pathname))
    nil))
