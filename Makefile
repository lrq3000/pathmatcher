# Makefile like config file for py-make
# To use: `pip install py-make`
# then calle `pymake <command>`
# IMPORTANT: to be compatible with `python setup.py make alias`, you must make
# sure that you only put one command per line, and ALWAYS put a line return
# after an alias and before a command, eg:
#
#```
#all:
#	test
#	install
#test:
#	nosetest
#install:
#	python setup.py install
#    ```
# CRITICAL NOTE: if you get a "FileNotFoundError" exception when trying to call @+python or @+make, then it is because you used spaces instead of a hard TAB character to indent! TODO: bugfix this. It happens only for @+ commands and for those after the first command (if the @+ command with spaces as indentation is the first and only statement in a command, it works!)

.PHONY:
	alltests
	all
	flake8
    testsetuppost
    testtox
	distclean
	coverclean
	prebuildclean
	clean
    toxclean
	installdev
	install
	build
	buildupload
	pypi
	help

help:
	@+make -p

alltests:
	@+make test
	@+make flake8
	@+make testsetup

all:
	@+make alltests
	@+make build

flake8:
	@+flake8 -j 8 --count --statistics --exit-zero .

testnose:
    nosetests -vv --with-coverage

testtox:
    # Test for multiple Python versions
	tox --skip-missing-interpreters -p all

testpyproject:
	validate-pyproject pyproject.toml -v

testsetuppost:
	twine check "dist/*"

testrst:
	rstcheck README.rst

distclean:
	@+make coverclean
	@+make prebuildclean
	@+make clean
    @+make toxclean
prebuildclean:
	@+python -c "import shutil; shutil.rmtree('build', True)"
	@+python -c "import shutil; shutil.rmtree('dist', True)"
	@+python -c "import shutil; shutil.rmtree('pathmatcher.egg-info', True)"
coverclean:
	@+python -c "import os; os.remove('.coverage') if os.path.exists('.coverage') else None"
	@+python -c "import shutil; shutil.rmtree('__pycache__', True)"
clean:
	@+python -c "import os, glob; [os.remove(i) for i in glob.glob('*.py[co]')]"
toxclean:
	@+python -c "import shutil; shutil.rmtree('.tox', True)"


installdev:
	@+make prebuildclean
	# Should work for both Py2 and Py3, --editable option and isolation builds work with both pyproject.toml and setup.cfg
	@+python -m pip install --upgrade --editable . --verbose --use-pep517

install:
	@+make prebuildclean
	@+python -m pip install --upgrade . --verbose --use-pep517

build:
	# requires `pip install build`
	#@+make testrst
	@+make prebuildclean
	@+make testpyproject
	@+python -sBm build  # do NOT use the -w flag, otherwise only the wheel will be built, but we need sdist for source distros such as Debian and Gentoo!
	@+make testsetuppost

pypi:
	twine upload dist/*

buildupload:
	@+make testsetup
	@+make build
	@+make pypimeta
	@+make pypi
