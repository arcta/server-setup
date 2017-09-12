import sys, os, re
import IPython.nbformat.current as nbf

if __name__ == '__main__':
    """
    convert .py file to notebook .ipynb format
    expected filepath as an argument
    """
    if len(sys.argv) == 2:
        path = re.sub('\.py$', '', sys.argv[1])

        if os.path.isfile('%s.py' % path):
            nb = nbf.read(open('%s.py' % path, 'r'), 'py')
            nbf.write(nb, open('%s.ipynb' % path, 'w'), 'ipynb')
        else:
            print('File %s.py does not exist.' % path)
    else:
        print('Usage: python py2nb.py path/file')
