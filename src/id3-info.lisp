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

(defun take-one (data &rest keys)
  ;(reduce #'getf keys :initial-value data)
  (reduce (lambda (data key)
            (if (integerp key)
                (nth key data)
                (getf data key)))
          keys
          :initial-value data))

(defun get-id3-by-ffprobe (mp3-file)
  (jonathan:parse ; json -> plist
    (uiop:run-program (list "ffprobe"
                            "-v" "quiet"
                            "-print_format" "json"
                            "-show_format"
                            "-show_streams"
                            mp3-file)
                      :output :string)))

(defun copy-cover-by-ffmpeg (mp3-file cover-file)
  (uiop:run-program (list "ffmpeg"
                          "-v" "error"
                          "-i" mp3-file
                          "-an" "-c:v" "copy"
                          cover-file)))

(defun get-id3 (mp3-pathname)
  (let ((alst (get-id3-by-ffprobe (uiop:native-namestring mp3-pathname))))
    (list
      ;(cons "bitrate" (truncate (parse-integer (take-one alst :|format| :|bit_rate|)) 1000))
      (cons "bitrate" (truncate (parse-integer (take-one alst :|streams| 0 :|bit_rate|)) 1000))
      (cons "samples" (parse-integer (take-one alst :|streams| 0 :|sample_rate|)))
      (cons "artist" (take-one alst :|format| :|tags| :|artist|))
      (cons "year" (take-one alst :|format| :|tags| :|date|))
      (cons "album" (take-one alst :|format| :|tags| :|album|))
      (cons "albumartist" (take-one alst :|format| :|tags| :|album_artist|))
      (cons "disc" (take-one alst :|format| :|tags| :|disc|))
      (cons "track" (take-one alst :|format| :|tags| :|track|))
      (cons "genre" (take-one alst :|format| :|tags| :|genre|))
      (cons "title" (take-one alst :|format| :|tags| :|title|))
      (cons "publisher" (take-one alst :|format| :|tags| :|publisher|))
      (cons "pictxt" (take-one alst :|streams| 1 :|title|))
      (cons "picbin" (if (take-one alst :|streams| 1) "<yes>" "<no>"))
      (cons "picwidth" (take-one alst :|streams| 1 :|width|))
      (cons "picheight" (take-one alst :|streams| 1 :|height|)))))

;; Info
(defun id3-info (mp3-pathname &optional cover-pathname)
  (let ((id3-alst (get-id3 mp3-pathname)))
    (when (and cover-pathname
               (equal (cdr (assoc "picbin" id3-alst :test #'string=))
                      "<yes>"))
      (copy-cover-by-ffmpeg (uiop:native-namestring mp3-pathname)
                            (uiop:native-namestring cover-pathname)))
    id3-alst))
