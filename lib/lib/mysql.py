#!/usr/bin/env

import re
import gc
import os
import sys
import time
import datetime
import subprocess

### database ###########################################################

import MySQLdb as mysql
import MySQLdb.constants.CLIENT as client
from utilities import config

cnf = conf = config.LocalCnf()

class MySQL(config.LocalCnf):
    '''
    very basic mysql client
    '''
    def __init__(self, root=False):
        HOST = cnf.get('NODE_MYSQL_HOST')
        USER = 'root' if root else cnf.get('NODE_DATAUSER')
        PASS = cnf.get('NODE_MYSQL_ROOT_PASS') if root else cnf.get('NODE_MYSQL_PASS')
        DB = cnf.get('NODE_DATABASE')
        PORT = int(cnf.get('NODE_MYSQL_PORT'))

        self._log = open('%s/logs/mysql.log' % cnf.get('HOME'),'a')
        self.TIMER = []
        self.ACTION_TRACK = []
        try:
            self._con = mysql.connect(HOST, USER, PASS, DB, PORT, client_flag = client.MULTI_STATEMENTS)
            self._cur = self._con.cursor(mysql.cursors.DictCursor)
            self._cur.execute('SET GLOBAL query_cache_size = 0')
            self._cur.execute('SET GLOBAL query_cache_type = OFF')
            self._cur.execute('SET GLOBAL max_allowed_packet = 16777216*10')
            self._cur.execute('SET GLOBAL default_storage_engine = MyISAM')
            print(self)

        except mysql.Error as e:
            print('Error %s' % e)


    def __del__(self):
        self._cur.close()
        self._con.close()
        gc.collect()


    def log(self, message):
        print(message)
        self._log.write(message)


    def escape(self, str):
        '''
        add slashes
        '''
        return mysql.escape_string(str)


    def insert(self, query, values):
        return self.execute(query % ','.join(values))


    def execute(self, query):
        try:
            self._cur.execute(query)
        except mysql.Error as e:
            print('Error %s\n%s' % (e, 'query'))
            return False
        finally:
            self._con.commit()
            return True


    def multi(self, query, params = None, multi = True):
        try:
            self._cur.execute(query, params, multi)
        except mysql.Error as e:
            print('Error %s\n%s' % (e, query))
            return False
        finally:
            self._con.commit()
            return True


    def query(self, query):
        rows = []
        try:
            self._cur.execute(query)
            rows = self._cur.fetchall()
        except mysql.Error as e:
            print('Error %s\n%s' % (e, query))
            return False
        return rows


        self.TIMER = []
        self.ACTION_TRACK = []

        self.TIMER.append(datetime.datetime.now())
        self.ACTION_TRACK.append(script)


    def timer(self, message=''):
        '''
        set time profile
        '''
        if '' == message:
            print('RUNTIME: %s [%s]\n' % \
                (datetime.datetime.now()-self.TIMER.pop(), self.ACTION_TRACK.pop()))
        else:
            self.TIMER.append(datetime.datetime.now())
            self.ACTION_TRACK.append(message.split()[0])
            print('--------------------------------------------------------------------\n%s' % message)


    def cmd(self, cmd):
        '''
        run shell command and return output
        '''
        cmd = str(cmd)
        print('Running: %s' % cmd.split()[0])
        stdout = subprocess.Popen(cmd, shell = True, stdout=subprocess.PIPE).stdout
        return stdout.read()


    def run(self, script):
        '''
        run sql script
        '''
        USER = 'root'
        PASS = cnf.get('NODE_MYSQL_ROOT_PASS')
        DB = cnf.get('NODE_DATABASE')
        self.cmd('mysql -u %s -p%s %s < %s' % (USER, PASS, DB, script))



def main():
    test = MySQL(root=True)

    print(test.query("show tables"))



if __name__ == '__main__':
    main()

