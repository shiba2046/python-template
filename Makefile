PACKAGE_NAME="python_template"
AUTHOR="shiba2046"
AUTHOR_EMAIL="author@email.com"
PACKAGE_VERSION="0.0.1"

PACKAGE_RELEASE="1"
PACKAGE_ARCH="all"
SRC="src"
SETUP_PY=$(SRC)/setup.py

VENV = venv
README = "README.md"
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip
REQUIREMENTS = requirements.txt


.PHONY: clean uninstall

run:
	$(PYTHON) -m $(PACKAGE_NAME)
	$(PYTHON) -c "import $(PACKAGE_NAME)"

$(VENV)/bin/activate: $(REQUIREMENTS) 
	python3 -m venv $(VENV)
	$(PIP) install -U pip
	$(PIP) install -r $(REQUIREMENTS)

setup: $(VENV)/bin/activate
	$(PIP) install -e src/

uninstall:
	$(PIP) uninstall -y src/

freeze:
	$(PIP) freeze > $(REQUIREMENTS)


clean:
	rm -rf src/$(PACKAGE_NAME)/__pycache__
	rm -rf $(VENV)


update_version:
	sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"


init:

	@sed -i $(SETUP_PY) -e "s/name=.*/name='$(PACKAGE_NAME)',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='$(PACKAGE_VERSION)',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='$(AUTHOR)',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='$(AUTHOR_EMAIL)',/"

	@mkdir -p $(SRC)/$(PACKAGE_NAME)
	@touch $(SRC)/$(PACKAGE_NAME)/__init__.py
	@touch $(SRC)/$(PACKAGE_NAME)/__main__.py

	@touch $(REQUIREMENTS)

	

pre-comit: clean
	@find src -mindepth 1 -not -iname "setup.py"  -exec rm -rf {} \;
	
	@sed -i $(SETUP_PY) -e "s/name=.*/name='',/"
	@sed -i $(SETUP_PY) -e "s/version=.*/version='',/"
	@sed -i $(SETUP_PY) -e "s/author=.*/author='',/"
	@sed -i $(SETUP_PY) -e "s/author_email=.*/author_email='',/"
