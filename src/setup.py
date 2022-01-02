import setuptools

with open("../README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="",
    version="",
    author="",
    author_email="",
    long_description=long_description,
    pack_dir={"", "."},
    packages=setuptools.find_packages(where="."),
)
