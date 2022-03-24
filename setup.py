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
    python_requires='>=2.7',
    license='MIT',
    classifiers=['Development Status :: 4 - Beta',
                 'Programming Language :: Cython',
                 'Programming Language :: Python :: Implementation :: CPython',
                 'Programming Language :: Python :: 2.7',
                 'Programming Language :: Python :: 3',
                 'License :: OSI Approved :: MIT License',
                 'Operating System :: OS Independent'],
    zip_safe=False
)
