#!/usr/bin/python

from __future__ import print_function
from setuptools import setup
import setuptools
import os


def is_package(path):
    return (
        os.path.isdir(path) and
        os.path.isfile(os.path.join(path, '__init__.py'))
        )


def find_packages(path, base=""):
    """ Find all packages in path """
    packages = {}
    for item in os.listdir(path):
        dir = os.path.join(path, item)
        if is_package(dir):
            if base:
                module_name = "%(base)s.%(item)s" % vars()
            else:
                module_name = item
            packages[module_name] = dir
            packages.update(find_packages(dir, module_name))
    return packages


packages = find_packages(".")
package_names = packages.keys()

# REMEMBER: If this list is updated, please also update stdeb.cfg
packages_required = [
    "zeroconf>=0.25.0"
]

setup(name="zeroconf-monkey",
      version="1.0.0",
      description="A thin wrapper on top of Zeroconf to override validation",
      url='https://github.com/bbc/zeroconf_monkey',
      author='Peter Brightwell',
      author_email='peter.brightwell@bbc.co.uk',
      license='LGPL',
      packages=package_names,
      package_dir=packages,
      install_requires=packages_required,
      scripts=[],
      data_files=[],
      long_description="A thin wrapper on top of Zeroconf to override validation",
      py_modules=['zeroconf_monkey']
      )
