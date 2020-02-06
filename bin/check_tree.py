#!/usr/bin/env python3

import os
import sys
import pymongo
import time
from stat import *

files=0

def visitcollection( lbase, collection, limit=0 ):
    global files
    print( "limit[%d]" % ( limit ) )
    for rec in collection.find():
        files += 1
        md5 = rec[ 'md5' ]
        path = rec[ 'path' ]
        ldir = os.path.join( lbase, md5[ 0 ], md5[ 1 ], md5[ 2 ] )
        lpath = os.path.join( ldir, md5 )
        if ( files == limit ):
            return
        if ( os.path.exists( lpath ) ):
            nlink = os.stat( lpath ).st_nlink
            if ( nlink == 1 ):
                print( "STRAY[%s]<-[%s]" % ( lpath, path ) )
        else:
            print( "NTFND[%s]<-[%s]" % ( lpath, path ) )

if __name__ == '__main__':
    t_start = time.clock()
    mongoc = pymongo.MongoClient()
    db = mongoc.mydb
    collection = db.filehash
    visitcollection( sys.argv[1], collection, int( sys.argv[2] ) )
    t_end = time.clock()
    print( "finally processed %d files in %f[sec]." % ( files, (t_end - t_start) ) )

