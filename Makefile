PROJECT_NAME := new-python-project
AUTHOR := shiba2046
AUTHOR_EMAIL := author@email.com
PACKAGE_VERSION := 0.0.1

PACKAGE_RELEASE := 1
PACKAGE_ARCH := all


SRC := src
SETUP_PY=$(SRC)/setup.py
VENV := venv
README := README.md
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
REQUIREMENTS := requirements.txt
PACKAGE_NAME := $(subst -,_,$(PROJECT_NAME))
# PACKAGE_NAME := $(PROJECT_NAME)
# EGG_NAME := $(subst _,-,$(PACKAGE_NAME))
# PIP_LINK := $(VENV)/lib/python3.*/site-packages/$(EGG_NAME).egg-link
PIP_LINK := $(VENV)/lib/python3.*/site-packages/*.egg-link
INIT := .project-init

run: debug

debug: | $(VENV)/bin/activate $(PIP_LINK)
	$(PYTHON) -m $(PACKAGE_NAME)
	$(PYTHON) -c "import $(PACKAGE_NAME)"

$(PIP_LINK): | $(VENV)/bin/activate .project-init
	@echo -e "Make::install Installing locally......\n\n"
	$(PIP) install -e $(SRC)/


$(VENV)/bin/activate: $(REQUIREMENTS)
	@echo -e "Make::venv Creating virtual environment......\n\n"
	python3 -m venv $(VENV)
	$(PIP) install -U pip
	$(PIP) install -r $(REQUIREMENTS)

$(REQUIREMENTS):
	@touch $(REQUIREMENTS)

.project-init: 
	@echo -e "Make:init:: Initializing...\n\n"

	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PACKAGE_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"

	@mkdir -p $(SRC)/$(PACKAGE_NAME)
	
	@touch $(SRC)/$(PACKAGE_NAME)/__init__.py
	@echo "print('Hello from Main!')" >> $(SRC)/$(PACKAGE_NAME)/__main__.py

	@touch .project-init



$(SETUP_PY): Makefile
	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PACKAGE_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"

uninstall:
	$(PIP) uninstall -y $(PACKAGE_NAME)

freeze: | $(VENV)/bin/activate
	$(PIP) freeze > $(REQUIREMENTS)

clean:
	@echo -e "Make::clean Clean up...\n\n"
	rm -rf $(SRC)/$(PACKAGE_NAME)/__pycache__
	rm -rf $(SRC)/*.egg-info
	rm -rf $(VENV)

bump_version:
	sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"

.PHONY: venv all run debug clean init install uninstall freeze bump_version Makefile