PACKAGE_NAME := new_python_project
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
INITIALIZED := INITIALIZED.md
PIP_LINK := $(VENV)/lib/python3.*/site-packages/$(PACKAGE_NAME).egg-link



run: debug

debug: | $(VENV)/bin/activate $(PIP_LINK)
	$(PYTHON) -m $(PACKAGE_NAME)
	$(PYTHON) -c "import $(PACKAGE_NAME)"


venv: $(VENV)/bin/activate
	. $^


$(VENV)/bin/activate:  | $(REQUIREMENTS)
	@echo -e "Make::venv Creating virtual environment......\n\n"
	python3 -m venv $(VENV)
	$(PIP) install -U pip
	$(PIP) install -r $(REQUIREMENTS)

# Installed locally

# $(VENV)/lib/python3.*/site-packages/$(PACKAGE_NAME).egg-link: install


$(PIP_LINK): $(SETUP_PY) | $(VENV)/bin/activate $(SRC)/$(PACKAGE_NAME)
	@echo -e "Make::install Installing locally......\n\n"
	$(PIP) install -e $(SRC)/


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

$(REQUIREMENTS):
	@touch $(REQUIREMENTS)

$(SRC)/$(PACKAGE_NAME):
	@echo -e "Make:init:: Initializing...\n\n"
	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PACKAGE_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"

	@mkdir -p $(SRC)/$(PACKAGE_NAME)
	
	@touch $(SRC)/$(PACKAGE_NAME)/__init__.py
	@#echo "print('Hello from Main!')" >> $(SRC)/$(PACKAGE_NAME)/__main__.py
	
pre-comit: clean

	@sed -i $(SETUP_PY) -e "s/name=.*/name='',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='',/"

	black .

	@echo -e "Make::pre-comit Clean up...\n\n"
	@find src -mindepth 1 -not -iname "setup.py"  -exec rm -rf {} \;
	@rm $(INITIALIZED)
	
$(SETUP_PY): Makefile
	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PACKAGE_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"


.PHONY: venv all run debug clean init install uninstall freeze clean bump_version pre-comit 