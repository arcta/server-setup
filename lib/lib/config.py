#!/usr/bin/env

import os
import re


class LocalCnf:
    '''
    Reads .local.cnf file into python dictionary
    '''
    def __init__(self):
        self._cnf = {}

        with open('/home/arctalex/.local.cnf', 'r') as cnf:
            for line in cnf:
                line = line.strip()
                if line != '':
                    data = line.split('=')
                    if 2 == len(data):
                        self._cnf[data[0]] = data[1].strip('$\"\'')

        with open('/home/arctalex/.project.cnf', 'r') as cnf:
            self._cnf['PROJECT'] = {}
            for line in cnf:
                line = line.strip('\n')
                if line != '' and line[0] != '#':
                    data = line.split('\t')
                    if len(data) == 3:
                        self._cnf['PROJECT'][data[1]] = {
                                        'PORT': int(data[0]),
                                        'GOOGLE_ID':data[2] }


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

