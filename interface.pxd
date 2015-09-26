cdef extern from "leptonica/allheaders.h" nogil:
    struct Pix
    Pix * pixRead (const char *)
    Pix * pixReadMem (unsigned char *, size_t)
    void pixDestroy (Pix **)

cdef extern from "tesseract/baseapi.h" namespace "tesseract" nogil:
    cdef cppclass TessBaseAPI:
        TessBaseAPI() except +
        int Init(const char *, const char *)
        void SetImage(const Pix*)
        char * GetUTF8Text()
        void End()
