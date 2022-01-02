#!/usr/bin/bash

REPO_URL=$(git config --get remote.origin.url)

if [[ ${REPO_URL} != "git@github.com:shiba2046/python-template.git" ]]; then
    echo "Not template repository."
    echo "EXIT"
    exit 1
fi

SETUP_PY=src/setup.py
echo -e "Reset template for commit...\n\n"

sed -i ${SETUP_PY} -e "s/name=.*/name=\"\",/"
sed -i ${SETUP_PY} -e "s/version=.*/version=\"\",/"
sed -i ${SETUP_PY} -e "s/author=.*/author=\"\",/"
sed -i ${SETUP_PY} -e "s/author_email=.*/author_email=\"\",/"

black .

find src -mindepth 1 -not -iname "setup.py" -exec rm -rf {} \;

make clean
rm -f debug*
