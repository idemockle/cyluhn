from setuptools import setup
from Cython.Build import cythonize

setup(
    name='cyluhn',
    description='Fast library to validate and generate check digits using the Luhn algorithm',
    ext_modules=cythonize("src/cyluhn.pyx"),
    entry_points={'console_scripts': ['cyluhn-generate=cyluhn:_cli_generate']},
    author='Ian Kent',
    author_email='iank1226@yahoo.com',
    url='https://github.com/idemockle/cyluhn',
    install_requires=['future; python_version < "3"'],
    zip_safe=False
)
