#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2020 Stephen Larroque <LRQ3000@gmail.com>

# See:
# https://docs.python.org/2/distutils/setupscript.html
# http://docs.cython.org/src/reference/compilation.html
# https://docs.python.org/2/extending/building.html
# http://docs.cython.org/src/userguide/source_files_and_compilation.html

try:
    from setuptools import setup
    from setuptools import Extension
except ImportError:
    from distutils.core import setup
    from distutils.extension import Extension

import codecs, os, re

# Get version, better than importing the module because can fail if the requirements aren't met
# See https://packaging.python.org/guides/single-sourcing-package-version/
curpath = os.path.abspath(os.path.dirname(__file__))
def read(*parts):
    with codecs.open(os.path.join(*parts), 'r') as fp:
        return fp.read()
def find_version(*file_paths):
    version_file = read(*file_paths)
    version_match = re.search(r"^__version__\s*=\s*['\"]([^'\"]*)['\"]",
                              version_file, re.M)
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")


setup(name = "pathmatcher",
    version = find_version(curpath, "pathmatcher", "_version.py"),
    description = "Regular Expression Path Matcher",
    author = "Stephen Karl Larroque",
    author_email = "lrq3000@gmail.com",
    license = "MIT",
    url = "https://github.com/lrq3000/pathmatcher",
    py_modules = ["pathmatcher"],
    platforms = ["any"],
    long_description = open("README.md", "r").read(),
    long_description_content_type = 'text/markdown',
    classifiers = [
        "Development Status :: 5 - Production/Stable",
        "Topic :: Utilities",
        "License :: OSI Approved :: MIT License",
        "Operating System :: Microsoft :: Windows",
        'Operating System :: MacOS :: MacOS X',
        "Operating System :: POSIX :: Linux",
        "Environment :: Console",
        "Intended Audience :: Science/Research",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
    ],
    include_package_data=True,  # use MANIFEST.in to include config file
    packages=['pathmatcher'],  # to force the wheel to use the MANIFEST.in
    entry_points = {
        'console_scripts': [  # create a binary that will be callable directly from the console
            'pathmatcher=pathmatcher.pathmatcher:main',
            'reorientation_registration_helper=pathmatcher.reorientation_registration_helper:main',
            ],
    },
    install_requires=[
    "chardet>=3.0.4",
    "tqdm>=4.46.0",
    "scandir>=1.10.0",
    #"numpy>=1.18.1",
    ],  # all libraries required for compatibility with Python 2.7 such as pathlib2 are provided with the module
)

