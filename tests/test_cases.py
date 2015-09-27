#!/usr/bin/env python
# coding=utf-8

from __future__ import print_function
import os
import unittest
import tesseract_ocr


class CommonTestCase(unittest.TestCase):
    def setUp(self):
        self.test_dir = os.path.abspath(os.path.dirname(__file__))

    def test_no_such_file(self):
        self.assertRaises(IOError, tesseract_ocr.text_for_filename,
                          'no_such_file.png')

    def test_text_for_filename(self):
        filename = os.path.join(self.test_dir, 'code.tiff')
        text = tesseract_ocr.text_for_filename(filename, 'eng')
        self.assertEqual(text, '0578')

    def test_text_for_bytes(self):
        buf = open(os.path.join(self.test_dir, 'code.tiff'), 'rb').read()
        self.assertEqual(tesseract_ocr.text_for_bytes(buf), '0578')

    def test_available_laguages(self):
        print(tesseract_ocr.Tesseract().get_available_languages())

    def test_invalid_tessdata(self):
        buf = open(os.path.join(self.test_dir, 'code.tiff'), 'rb').read()
        t = tesseract_ocr.Tesseract('/tmp', 'eng')
        self.assertRaises(AssertionError, t.text_for_bytes, buf)
