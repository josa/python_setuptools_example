#!/usr/bin/env python2.6
# -*- coding: UTF-8 -*-
import os
import subprocess
import setuptools
from setuptools import setup
from datetime import datetime

def generate_version():
    args = ['git', 'describe', '--abbrev=0', '--match=[0-9]\.[0-9]*']
    git_version = (subprocess.Popen(args, stdout=subprocess.PIPE).communicate()[0]).strip()
    date = datetime.now().strftime("%Y%m%d_%H%M")
    print git_version + "-" + date
    return git_version + "-" + date

setup(
	name='test',
	version=generate_version(),
	description='Projeto teste de empacotamento de aplicações python',
	author='Jeosadache S. Galvão',
	author_email='josa.galvao@gmail.com',
	url='https://github.com/josa/python_setuptools_example',
	package_dir={
		'': 'src/',
		'resources': 'resources'
    },
	packages=setuptools.find_packages('src/'),
	scripts=[
		'resources/test.sh',
	],
	data=[
		'resources/test.cfg',
	],
	long_description='Projeto teste de empacotamento de aplicações python',
	classifiers=[
		"Programming Language :: Python",
	],
	keywords='worker rss parser',
    install_requires=[
        #'ws-commons>=1.0.0'
    ],
	zip_safe=True,
)
