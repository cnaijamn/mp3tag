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

mp3tag info
-----------

    mp3tag info [-c coverfile] mp3file

Example:

    $ mp3tag info -c /tmp/my_cover.jpg track-01.mp3

mp3tag update
-------------

    mp3tag update
           [-a artist] [-y year] [-l album] [-r albumartist] [-d disc]
           [-k track] [-g genre] [-t title] [-c coverfile] mp3file

_TODO_
