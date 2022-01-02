PACKAGE_NAME := new-python-project
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
PYTHON_NAME := $(subst -,_,$(PACKAGE_NAME))
# PYTHON_NAME := $(PACKAGE_NAME)
# EGG_NAME := $(subst _,-,$(PYTHON_NAME))
# PIP_LINK := $(VENV)/lib/python3.*/site-packages/$(EGG_NAME).egg-link
PIP_LINK := $(VENV)/lib/python3.*/site-packages/*.egg-link
REPO_URL := $(git remote get-url origin)


run: debug

debug: | $(VENV)/bin/activate $(PIP_LINK)
	$(PYTHON) -m $(PYTHON_NAME)
	$(PYTHON) -c "import $(PYTHON_NAME)"


venv: $(VENV)/bin/activate
	. $^


$(VENV)/bin/activate:  | $(REQUIREMENTS)
	@echo -e "Make::venv Creating virtual environment......\n\n"
	python3 -m venv $(VENV)
	$(PIP) install -U pip
	$(PIP) install -r $(REQUIREMENTS)


$(PIP_LINK): $(VENV)/bin/activate $(SRC)/$(PYTHON_NAME)
	@echo -e "Make::install Installing locally......\n\n"
	$(PIP) install -e $(SRC)/

uninstall:
	$(PIP) uninstall -y $(PYTHON_NAME)

freeze: | $(VENV)/bin/activate
	$(PIP) freeze > $(REQUIREMENTS)

clean:
	@echo -e "Make::clean Clean up...\n\n"
	rm -rf $(SRC)/$(PYTHON_NAME)/__pycache__
	rm -rf $(SRC)/*.egg-info
	rm -rf $(VENV)

bump_version:
	sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"

$(REQUIREMENTS):
	@touch $(REQUIREMENTS)

$(SRC)/$(PYTHON_NAME):
	@echo -e "Make:init:: Initializing...\n\n"
	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PYTHON_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"

	@mkdir -p $(SRC)/$(PYTHON_NAME)
	
	@touch $(SRC)/$(PYTHON_NAME)/__init__.py
	@echo "print('Hello from Main!')" >> $(SRC)/$(PYTHON_NAME)/__main__.py

		
$(SETUP_PY): Makefile
	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PYTHON_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"


.PHONY: venv all run debug clean init install uninstall freeze clean bump_version 