#!/usr/bin/env python3

import os
import sys
import pymongo
import time

files=0

def visitcollection( fbase, lbase, collection, limit=0 ):
    global files
    for rec in collection.find():
        files += 1
        md5 = rec[ 'md5' ]
        path = rec[ 'path' ]
        ldir = os.path.join( lbase, md5[ 0 ], md5[ 1 ], md5[ 2 ] )
        lpath = os.path.join( ldir, md5 )
        fpath = os.path.join( fbase, path )
        if files == limit:
            return
        if ( os.path.exists( fpath ) and not os.path.exists( lpath ) ):
            os.makedirs( ldir, exist_ok=True )
            os.link( fpath, lpath )
            print( "[%s]->[%s]" % ( fpath, lpath ) )

if __name__ == '__main__':
    t_start = time.clock()
    mongoc = pymongo.MongoClient()
    db = mongoc.mydb
    collection = db.filehash
    visitcollection( sys.argv[1], sys.argv[2], collection, sys.argv[3] )
    t_end = time.clock()
    print( "finally processed %d files in %f[sec]." % ( files, (t_end - t_start) ) )

