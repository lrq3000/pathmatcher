# This Makefile runs tests and builds the package to upload to pypi
# To use this Makefile, pip install py-make
# You also need to pip install also other required modules: `pip install flake8 nose coverage twine`
# Then, cd to this folder, and type `pymake -p` to list all commands, then `pymake <command>` to run the related entry.

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

testsetuppost:
	twine check "dist/*"

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
	@+python setup.py develop --uninstall
	@+python setup.py develop

install:
	@+python setup.py install

build:
	@+make prebuildclean
	@+python setup.py sdist bdist_wheel
	#@+python setup.py bdist_wininst
    pymake testsetuppost  # @+make does not work here, dunno why

pypi:
	twine upload dist/*

buildupload:
	@+make build
	@+make pypi
