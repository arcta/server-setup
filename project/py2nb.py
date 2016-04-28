# (.env)python

import sys
import os
import re
import IPython.nbformat.current as nbf

def main():
    '''
    convert .py file to notebook .ipynb format
    expected filepath as an argument

 !!! will overwrite existing file !!!
    '''
    if len(sys.argv) == 2:
        path = re.sub('\.py$','',sys.argv[1])

        if os.path.isfile('%s.py' % path):
            nb = nbf.read(open('%s.py' % path, 'r'), 'py')
            nbf.write(nb, open('%s.ipynb' % path, 'w'), 'ipynb')
        else:
            print('File %s.py does not exist.' % path)
    else:
        print('Usage: python py2nb.py path-to-file-arg')


if __name__ == '__main__':
    main()
