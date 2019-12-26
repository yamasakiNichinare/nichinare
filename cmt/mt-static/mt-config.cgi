##          Movable Type configuration file                   ##
##                                                            ##
## This file defines system-wide settings for Movable Type    ##
## In total, there are over a hundred options, but only those ##
## critical for everyone are listed below.                    ##
##                                                            ##
## Information on all others can be found at:                 ##
## http://www.movabletype.jp/documentation/config

################################################################
##################### REQUIRED SETTINGS ########################
################################################################

# The CGIPath is the URL to your Movable Type directory
#CGIPath    http://www.example.com/cgi-bin/mt/
CGIPath http://nichinare.com/cmt/

# The StaticWebPath is the URL to your mt-static directory
# Note: Check the installation documentation to find out
# whether this is required for your environment.  If it is not,
# simply remove it or comment out the line by prepending a "#".
#StaticWebPath    http://www.example.com/mt-static
StaticWebPath http://nichinare.com/cmt/mt-static/
# StaticFilePath /usr/home/z304150/html/cmt/mt-static/

#================ DATABASE SETTINGS ==================
#   REMOVE all sections below that refer to databases
#   other than the one you will be using.

##### MYSQL #####
#ObjectDriver DBI::mysql
#Database DATABASE_NAME
#DBUser DATABASE_USERNAME
#DBPassword DATABASE_PASSWORD
#DBHost localhost
ObjectDriver DBI::mysql
Database z304150
DBUser z304150
DBPassword 58Akabxn
DBHost z304.secure.ne.jp
DBPort 3307


##### Import Path #####
# The filesystem path to the 'import' directory, which is used when importing
# entries and comments into the system--'import' is the directory where the
# files to be imported are placed. This setting defaults to './import', which
# means that the 'import' directory is in the same directory as the 'mt.cgi'
# file; you probably don't need to change this setting.
ImportPath ../../import

##### EntryPerRebuild ####
EntriesPerRebuild 10

##### http://www.sixapart.jp/movabletype/news/09/06/11-146.html
SQLSetNames 1

DBUmask 0022
HTMLUmask 0022
UploadUmask 0022
DirUmask 0022

# http://www.movabletype.jp/beta/50/
DefaultLanguage ja

TempDir /usr/home/z304150/html/cmt/tmp/
