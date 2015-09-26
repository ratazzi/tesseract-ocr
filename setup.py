from setuptools import setup, Extension
try:
    from Cython.Build import cythonize
    use_cython = True
except ImportError:
    use_cython = False

ext_modules = [Extension("tesseract_ocr",
                         sources=["tesseract_ocr.cpp"],
                         libraries=["tesseract", "lept"],
                         language="c++")]
if use_cython:
    ext_modules = cythonize(Extension("tesseract_ocr",
                            sources=["*.pyx"],
                            libraries=["tesseract", "lept"],
                            language="c++"))

setup(name="tesseract-ocr",
      version="0.0.1",
      url="https://github.com/ratazzi/tesseract-ocr",
      author="ratazzi",
      author_email="ratazzi.potts@gmail.com",
      install_requires=['cython'],
      description='A Python wrapper for Tesseract',
      long_description='A Python wrapper for Tesseract',
      keywords = ['Tesseract', 'OCR', 'Cython'],
      license='MIT',
      py_modules=['tesseract_ocr'],
      zip_safe=False,
      ext_modules=ext_modules,
      tests_require=['nose', 'Pillow'],
      classifiers=[
          'Development Status :: 2 - Pre-Alpha',
          'Intended Audience :: Developers',
          'License :: OSI Approved :: MIT License',
          'Operating System :: OS Independent',
          'Programming Language :: Python',
          'Programming Language :: Python :: 2.6',
          'Programming Language :: Python :: 2.7',
          'Programming Language :: Python :: 3.3',
          'Programming Language :: Python :: 3.4',
          'Programming Language :: Python :: Implementation :: CPython',
          'Programming Language :: Python :: Implementation :: PyPy',
          'Topic :: Multimedia :: Graphics :: Capture :: Scanners',
          'Topic :: Multimedia :: Graphics :: Graphics Conversion',
          'Topic :: Scientific/Engineering :: Image Recognition',
      ])
