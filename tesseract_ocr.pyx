import os
from cpython cimport *
from interface cimport *
from cpython.version cimport PY_MAJOR_VERSION


TESSDATA_POSSIBLE_PATHS = [
    "/usr/local/share/tessdata",
    "/usr/share/tessdata",
    "/usr/share/tesseract/tessdata",
    "/usr/local/share/tesseract-ocr/tessdata",
    "/usr/share/tesseract-ocr/tessdata",
    "/app/vendor/tesseract-ocr/tessdata",  # Heroku
    "/opt/local/share/tessdata",  # OSX MacPorts
]

TESSDATA_EXTENSION = ".traineddata"


cdef unicode u(s):
    if isinstance(s, unicode):
        # an evil cast to <unicode> might work here in some(!) cases,
        # depending on what the further processing does.  to be safe,
        # we can always create a copy instead
        return unicode(s)
    elif isinstance(s, bytes):
        # only accept byte strings in Python 2.x, not in Py3
        return (<bytes>s).decode('utf-8')
    else:
        raise TypeError(type(s))

cdef bytes b(s):
    if PY_MAJOR_VERSION > 3 and isinstance(s, str):
        return s.encode('utf-8')
    elif type(s) is unicode:
        return s.encode('utf-8')
    else:
        return s


cdef class Tesseract:
    cdef TessBaseAPI _api
    cdef char *tessdata_prefix
    cdef lang

    def __cinit__(self, tessdata_prefix=None, lang='eng'):
        self._api = TessBaseAPI()
        self.tessdata_prefix = NULL
        if tessdata_prefix:
            _tessdata_prefix = b(tessdata_prefix)
            self.tessdata_prefix = _tessdata_prefix
        self.lang = lang

    cdef unicode _text_for_pix(self, Pix *image):
        cdef char *outText
        if self.tessdata_prefix:
            lang_tessdata = os.path.join(self.tessdata_prefix, b('tessdata'), b(self.lang + TESSDATA_EXTENSION))
            assert os.path.isfile(lang_tessdata), \
                    "Language %s is not available." % self.lang
        else:
            assert u(self.lang) in self.get_available_languages(), \
                    "Language %s is not available." % self.lang
        if self._api.Init(self.tessdata_prefix, b(self.lang)) > 0:
            raise RuntimeError("Could not initialize tesseract.")
        self._api.SetImage(image)
        outText = self._api.GetUTF8Text()
        pixDestroy(&image)
        return u(<bytes>outText).strip()

    cpdef get_available_languages(self):
        languages = []
        for dirpath in TESSDATA_POSSIBLE_PATHS:
            if not os.access(dirpath, os.R_OK):
                continue
            for filename in os.listdir(dirpath):
                if filename.lower().endswith(TESSDATA_EXTENSION):
                    lang = filename[:len(TESSDATA_EXTENSION) * -1]
                    languages.append(lang)
        return languages

    cpdef unicode text_for_bytes(self, buf):
        cdef Pix *image
        image = pixReadMem(<bytes>buf, len(buf))
        if not image:
            raise RuntimeError('pixRead failed')
        return self._text_for_pix(image)

    cpdef unicode text_for_filename(self, filename):
        cdef Pix *image
        if not os.path.isfile(filename):
            raise IOError("No such file or directory")

        image = pixRead(b(filename))
        return self._text_for_pix(image)


cpdef unicode text_for_filename(filename, lang='eng'):
    api = Tesseract(None, lang)
    return api.text_for_filename(filename)


cpdef unicode text_for_bytes(buf, lang='eng'):
    api = Tesseract(None, lang)
    return api.text_for_bytes(buf)
