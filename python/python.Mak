########################################################
##### PYTHON/ANSIBLE DEVELOPMENT ENVIRONMENT SETUP #####
########################################################

# https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES
.EXPORT_ALL_VARIABLES:

SHELL=bash
HOST_OS=$(shell uname)

.DEFAULT_GOAL := env
env: venv dep

venv:
	rm -rf .env
	python3 -m venv .env
	.env/bin/pip install --upgrade pip

# These actions will be executed:
# 1 - upgrade all dependencies defined in the requirements.txt file (make sue the pip-review package is declared in the requirements.txt file)
# 2 - generate a new requirements.txt file with all the latest version of the packages pinned
# PS. it'll upgrade the terraform version (infra-packages-python-terraform==0.11.14) what you probably don't want to, so manually revert it if that is the case, and run make dep again
dep-upgrade:
	source .env/bin/activate \
        && pip install pip-review \
        && pip-review --auto \
        && pip freeze -r requirements.txt | awk '1;/pip freeze/{exit}' | head -n -1 > requirements-latest.txt \
        && rm requirements.txt \
        && mv requirements-latest.txt requirements.txt

dep: pip
	.env/bin/pip install --upgrade pip
	PIP_CONFIG_FILE=./env/pip.conf .env/bin/pip install -r requirements.txt --upgrade

pip:
	echo "[global]" > .env/pip.conf
	echo "no-cache-dir = false" >> .env/pip.conf
	echo "index-url = https://pypi.python.org/simple" >> .env/pip.conf
	echo "extra-index-url = https://artifactory.telnyx.com/api/pypi/pypi-telnyx/simple" >> .env/pip.conf

# WITH OS DEPENDENCIES
#env: osdep-$(HOST_OS) venv dep

# LINUX DEPENDENCIES
#osdep-Linux:
#	sudo apt-get install python3-pip virtualenv unzip

# MAC DEPENDENCIES
# if you are having problems, try uninstall pip: python3 -m pip uninstall pip
#osdep-Darwin:
#	sudo pip3 install virtualenv

# IBM TERRAFORM PROVIDER - Linux only - MacOS TODO
# ibm_terraform_plugin:
# 	mkdir -p ~/.terraform.d/plugins
# 	curl -sLo .env/terraform-provider-ibm.zip https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v0.19.1/linux_amd64.zip
# 	unzip .env/terraform-provider-ibm.zip -d ~/.terraform.d/plugins
