PYTHON=`which python`
PYTHON2=`which python2`
PYTHON3=`which python3`
PY2DSC=`which py2dsc`

topdir := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
topbuilddir := $(realpath .)

DESTDIR=/
PROJECT=$(shell python $(topdir)/setup.py --name)
VERSION=$(shell python $(topdir)/setup.py --version)
MODNAME=$(PROJECT)
DEBNAME=$(shell echo $(MODNAME) | tr '[:upper:]_' '[:lower:]-')

DEBIANDIR=$(topbuilddir)/deb_dist/$(DEBNAME)-$(VERSION)/debian
DEBIANOVERRIDES=$(patsubst $(topdir)/debian/%,$(DEBIANDIR)/%,$(wildcard $(topdir)/debian/*))

RPMDIRS=BUILD BUILDROOT RPMS SOURCES SPECS SRPMS
RPMBUILDDIRS=$(patsubst %, $(topdir)/build/rpm/%, $(RPMDIRS))

all:
	@echo "$(PROJECT)-$(VERSION)"
	@echo "make source  - Create source package"
	@echo "make install - Install on local system (only during development)"
	@echo "make clean   - Get rid of scratch and byte files"
	@echo "make deb     - Create deb package"
	@echo "make wheel   - Create whl package"
	@echo "make egg     - Create egg package"

source:
	$(PYTHON) $(topdir)/setup.py sdist $(COMPILE)

$(topbuilddir)/dist/$(MODNAME)-$(VERSION).tar.gz: source $(topbuilddir)/dist

install:
	$(PYTHON) $(topdir)/setup.py install --root $(DESTDIR) $(COMPILE)

clean:
	$(PYTHON) $(topdir)/setup.py clean || true
	rm -rf $(topbuilddir)/.tox
	rm -rf $(topbuilddir)/build/ MANIFEST
	rm -rf $(topbuilddir)/dist
	rm -rf $(topbuilddir)/deb_dist
	rm -rf $(topbuilddir)/*.egg-info
	find $(topbuilddir) -name '*.pyc' -delete
	find $(topbuilddir) -name '*.py,cover' -delete

$(topbuilddir)/dist:
	mkdir -p $@

deb_dist: $(topbuilddir)/dist/$(MODNAME)-$(VERSION).tar.gz
	$(PY2DSC) --with-python2=false --with-python3=true $(topbuilddir)/dist/$(MODNAME)-$(VERSION).tar.gz

$(DEBIANDIR)/%: $(topdir)/debian/% deb_dist
	cp -r $< $@

dsc: deb_dist $(DEBIANOVERRIDES)
	cp $(topbuilddir)/deb_dist/$(DEBNAME)_$(VERSION)-1.dsc $(topbuilddir)/dist

deb: source deb_dist $(DEBIANOVERRIDES)
	cd $(DEBIANDIR)/..;debuild -uc -us
	cp $(topbuilddir)/deb_dist/python*$(DEBNAME)_$(VERSION)-1*.deb $(topbuilddir)/dist

wheel:
	$(PYTHON3) $(topdir)/setup.py bdist_wheel --dist-dir=$(topbuilddir)/dist

egg:
	$(PYTHON3) $(topdir)/setup.py bdist_egg --dist-dir=$(topbuilddir)/dist

.PHONY: clean install source deb dsc wheel egg pex all
