---
title: Parsing OpenStreetMap's JOSM huge data using Nokogiri 
layout: post
categories: [josm, openstreetmap, ruby, parser]
---

# Background

While attending [SSJS Devcamp](/event/ssjs/devmeetigs/2011/07/04/DevCamp.html)
I was having fun with [MongoDB](http://www.mongodb.org) and
[CouchDB](http://couchdb.apache.org/). To make some useful tests we had first to
gather some data. After a quick brainstorm we decided to create
database with places/POIs. The greatest free geo repository I know is
[OpenStreetMap](http://openstreetmap.org) and they are providing all theirs
data to [download](http://wiki.openstreetmap.org/wiki/Downloading_data). Whole
repository is really huge (almost 17GiB of compressed data), so we settled for
using only Poland data from a [nice
mirror](http://download.geofabrik.de/osm/europe/).

# Data

Format specification is described on [OSM
wiki](http://wiki.openstreetmap.org/wiki/JOSM_file_format). It is pretty
straightforward XML and contains mostly roads, but also cities, buildings,
shops and ton of other things. This makes even Poland data pretty big (~2.5GiB
XML file). For us just the POI stuff was important so we had to go through
whole file and cherry pick interesting entries.

# Parsing

Because of the size of the XML, using a [DOM
parser](http://en.wikipedia.org/wiki/XML#Document_Object_Model_.28DOM.29) on a
laptop would not work because of memory usage. Obvious solution would be to use
SAX parser, but I consider it to be totally backwards. I guess this API was easy to
implement, but is strange to use, and code using it ends up pretty mangled.  I
prefer [Pull Parsing](http://www.xmlpull.org/) so I searched for some nice
parser, preferably in Ruby. As it turns out, the excellent
[Nokogiri](http://nokogiri.org) have one as
[XML::Reader](http://nokogiri.org/Nokogiri/XML/Reader.html). 


