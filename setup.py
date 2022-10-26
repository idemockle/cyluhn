import os
import io
import Cython.Build

from setuptools import setup
from setuptools import Extension

# Install with `pip install .`
# To generate source distribution, run `python setup.py sdist`

with io.open(os.path.abspath(os.path.join(__file__, '..', 'README.md')), 'r', encoding='utf-8') as f:
    readme_text = f.read()

setup(
    name='cyluhn',
    version='0.2.1',
    description='Fast library to validate and generate check digits using the Luhn algorithm',
    long_description=readme_text,
    long_description_content_type='text/markdown',
    ext_modules=[Extension("cyluhn", ["src/cyluhn.pyx"])],
    cmdclass={'build_ext': Cython.Build.build_ext},
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
