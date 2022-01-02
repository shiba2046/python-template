import setuptools

with open("../README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="python_template",
    version="0.0.1",
    author="shiba2046",
    author_email="author@email.com",
    long_description=long_description,
    pack_dir={"", "."},
    packages=setuptools.find_packages(where="."),
)
