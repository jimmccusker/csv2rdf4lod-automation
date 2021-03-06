#!/bin/bash
#
# usage:

usage="usage: `basename $0` [-con {raw,e1}] datasetIdentifier ...\n\
\n\
combine automatic/*.raw.ttl into publish/SSS-DDD-VVV.raw.nt for the requested datasets.\n\
\n\
-con: conversion identifier to publish (raw, e1, e2, ...) (default: raw)\n\
\n\
This is run from data.gov/ (where directories 9, 10, 32, ... reside)."

if [ $# -lt 1 ]; then
   echo $usage
   exit 1
fi

con=raw
if [ "$1" == "-con" ]; then
   con="$2"
   shift 2
fi

CSV2RDF4LOD_HOME=${CSV2RDF4LOD_HOME:?"must be set. source csv2rdf4lod/source-me.sh."}
formats=${formats:?"must be set. source csv2rdf4lod/source-me.sh"}

source=`basename \`pwd\` | sed 's/\./-/g'`

while [ $# -gt 0 ]; do
   datasetIdentifier=$1

   autoDir=`find $datasetIdentifier -type d -depth 3 -name automatic | head -1`
   if [ ${#autoDir} ]; then

      version=`basename \`dirname $autoDir\``
      echo "$source     $datasetIdentifier     $version"

      pubFile=`dirname $autoDir`/publish/"$source-$datasetIdentifier-$version.$con.nt"

      echo $autoDir
      echo $pubFile
      echo "" > $pubFile
      for rawFile in `find $autoDir -name "*$con.ttl"`; do
         echo $rawFile
      done
   else
      echo $datasetIdentifier: skipping b/c could not find directory 'automatic'
   fi

   shift
done
