mp3tag
======
Simple MP3 tag viewer/editor

Installation
------------

    $ sudo apt install ffmpeg

    $ cd $QUICKLISP/local-projects
    $ git clone https://github.com/cnaijamn/mp3tag.git
    $ sbcl
    * (ql:register-local-projects)

Usage
-----
Mode info:

    mp3tag info [-c coverfile] mp3file

Example:

    $ mp3tag info -c /tmp/my_cover.jpg track-01.mp3

Mode update:

    mp3tag update
           [-a artist] [-y year] [-l album] [-r albumartist] [-d disc]
           [-k track] [-g genre] [-t title] [-p publisher] [-c coverfile]
           mp3file

Example:

    $ mp3tag update \
        -a "CL Lander" -y "2026" -l "Land of Lisp" -r "Lisper" \
        -d "02" -k "10" -g "Rock" -t "Hello, Land of Lisp" \
        -p "Kami" -c "cover.jpg" \
        "[2-10] Hello, Land of Lisp.mp3"

Quicklisp:

    (ql:quickload :mp3tag)

    (mp3tag:id3-info #P"track-01.mp3")
    ;=> (("bitrate" . 320) ("samples" . 44100) ("artist" . "CL Lander")
    ;    ("year" . "2026") ("album" . "Land of Lisp") ("albumartist")
    ;    ("disc" . "02") ("track" . "05") ("genre" . "Rock")
    ;    ("title" . "Hello, Land of Lisp") ("publisher" . "Kami")
    ;    ("pictxt") ("picbin" . "<yes>") ("picwidth" . 400) ("picheight" . 400))

    (mp3tag:id3-update '(:a "CL Lander" :y "2026" :l "Land of Lisp" :r "Lisper"
                         :d "02" :k "10" :g "Rock" :t "Hello, Land of Lisp"
                         :p "Kami")
                       #P"[2-10] Hello, Land of Lisp.mp3"
                       #P"cover.jpg")
    ;=> NIL
