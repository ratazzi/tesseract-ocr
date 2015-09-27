Tesseract-OCR
=============

A Python wrapper for Tesseract

.. image:: https://travis-ci.org/ratazzi/tesseract-ocr.svg?branch=master
   :target: https://travis-ci.org/ratazzi/tesseract-ocr
   :alt: Travis CI Status

Installation
------------

Installing tesseract-ocr with pip::

    $ pip install tesseract-ocr

Basic Usage
-----------

.. code:: python

    import tesseract_ocr
    tesseract_ocr.text_for_filename('code.tiff')
    tesseract_ocr.text_for_bytes(open('code.tiff', 'rb').read())

Python dependencies
-------------------

On Ubuntu or Debian Linux::

    $ sudo apt-get install tesseract-ocr libtesseract-dev libleptonica-dev

On Mac OS X::

    $ brew install --with-libtiff --with-openjpeg --with-giflib leptonica
    $ brew install --devel --all-languages tesseract
