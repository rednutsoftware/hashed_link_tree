#!/usr/bin/env python3

import os
import sys
from stat import *
import pymongo
import hashlib
import time

def walktree(base, dir, callback, collection):
    '''recursively descend the directory tree rooted at top,
       calling the callback function for each regular file'''

    top = os.path.join(base, dir)
    for f in os.listdir(top):
        pathname = os.path.join(top, f)
        mode = os.stat(pathname).st_mode
        if f in [ '.@__thumb', '.git', '.svn' ] :
            print( 'Skipping %s' % pathname )
        elif S_ISDIR(mode):
            # It's a directory, recurse into it
            d = os.path.join(dir, f)
            walktree(base, d, callback, collection)
        elif S_ISREG(mode):
            # It's a file, call the callback function
            callback(base, dir, f, collection)
        else:
            # Unknown file type, print a message
            print('Skipping %s' % pathname)

def get_md5(file, size=4096):
    md5 = hashlib.md5()
    with open(file, 'rb') as f:
        for chunk in iter(lambda: f.read(size * md5.block_size), b''):
            md5.update(chunk)
    return md5.hexdigest()

files=0

def visitfile(base, dir, fname, collection):
    global files
    files = files + 1
    if ( files % 100 == 0 ):
        print( 'processed ', files, ' files' )
    file = os.path.join( base, dir, fname )
    path = os.path.join( dir, fname )
    fstat = os.stat( file )
    md5 = get_md5( file )
    rec = {};
    rec[ 'path' ] = path
    rec[ 'size' ] = fstat.st_size
    rec[ 'mtime' ] = fstat.st_mtime
    rec[ 'md5' ] = md5
    ret = collection.find_one( { 'path': path } )
    if ret is not None:
        if ( ret[ 'md5' ] == rec[ 'md5' ] ):
            return
    ret = collection.find_one( { 'md5': md5, 'size': { '$ne': fstat.st_size } } )
    if ret is not None:
        print( 'different size but same md5:', rec, ret )
        return
    ret = collection.replace_one( { 'path': path }, rec, True )
    upd = ''
    if ret.matched_count != 0:
        upd = '(updated)'
    print( rec, upd )

if __name__ == '__main__':
    t_start = time.clock()
    mongoc = pymongo.MongoClient()
    db = mongoc.mydb
    collection = db.filehash
    walktree(sys.argv[1], sys.argv[2], visitfile, collection)
    t_end = time.clock()
    print( "finally processed %d files in %f[sec]." % ( files, (t_end - t_start) ) )

