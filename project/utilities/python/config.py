#(.env)python

import os
import re


class LocalCnf:
    '''
    Reads .local.cnf file into python dictionary
    '''
    def __init__(self):
        self._cnf = {}

        cnf = open('/home/arctalex/.local.cnf', 'r')
        for line in cnf:
            line = line.strip()
            if line != '':
                pair = line.split('=')
                if 2 == len(pair):
                    self._cnf[pair[0]] = pair[1].strip('$\"\'')


    def keys(self):
        '''
        get list of keys
        '''
        return self._cnf.keys()


    def get(self, key):
        '''
        get configuration value by key
        '''
        return self._cnf.get(key, False)


    def set(self, key, value):
        '''
        set configuration value with key
        '''
        self._cnf[key] = value



def main():
    test = LocalCnf()

    print(test.keys())
    print(test.get('NODE'))
    print(test._cnf['CLUSTER'])

    test.set('TEST', True)
    print(test.keys())
    print(test.get('TEST'))



if __name__ == '__main__':
    main()

