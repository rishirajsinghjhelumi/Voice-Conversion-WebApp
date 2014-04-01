import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.txt')).read()
CHANGES = open(os.path.join(here, 'CHANGES.txt')).read()

requires = [
    'pyramid',
    'SQLAlchemy',
    'transaction',
    'pyramid_tm',
    'pyramid_debugtoolbar',
    'zope.sqlalchemy',
    'waitress',
    'MySQL-python'
    ]

setup(name='Voice-Conversion-WebApp',
      version='0.0',
      description='Voice-Conversion-WebApp',
      long_description=README + '\n\n' + CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyramid",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='Rishi Raj Singh Jhelumi, Prachish Gora',
      author_email='rishiraj.devel@gmail.com, prachishgora93@gmail.com',
      url='',
      keywords='web wsgi bfg pylons pyramid',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      test_suite='voiceconversionwebapp',
      install_requires=requires,
      entry_points="""\
      [paste.app_factory]
      main = voiceconversionwebapp:main
      [console_scripts]
      initialize_Voice-Conversion-WebApp_db = voiceconversionwebapp.scripts.initializedb:main
      """,
      )
