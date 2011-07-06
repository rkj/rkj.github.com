---
title: Parsing huge OpenStreetMap's JOSM file using Nokogiri 
layout: post
categories: [devcamp, josm, openstreetmap, ruby, parser, tutorial]
---

# Background

While attending [SSJS Devcamp](/event/ssjs/devmeetigs/2011/07/04/DevCamp.html)
I was having fun with [MongoDB](http://www.mongodb.org) and
[CouchDB](http://couchdb.apache.org/). To make some useful tests we had first to gather some data.  The plan was to import data into MySQL, next migrate it
to NoSQL dbs and then make some tests/comparisons.  After a quick brainstorm we
decided to create database with places/POIs. The greatest free geo repository I
know is [OpenStreetMap](http://openstreetmap.org) and they are providing all
theirs data for [download](http://wiki.openstreetmap.org/wiki/Downloading_data).
Whole repository is really huge (almost 17GiB of compressed data), so we
settled for using only Poland data from a [nice
mirror](http://download.geofabrik.de/osm/europe/).

# Data

Format specification is described on [OSM
wiki](http://wiki.openstreetmap.org/wiki/JOSM_file_format). It is pretty
straightforward XML and contains mostly roads, but also cities, buildings,
shops and ton of other things. This makes even Poland data pretty big (~150MiB
compressed, ~2.5GiB uncompressed XML file). For us just the POI stuff was
important so we had to go through whole file and cherry pick interesting
entries.

# Parser

Because of the size of the XML, using a [DOM
parser](http://en.wikipedia.org/wiki/XML#Document_Object_Model_.28DOM.29) on a
laptop would not work because of memory usage. Obvious solution would be to use
SAX parser, but I consider it to be totally backwards[^1]. I prefer [Pull
Parsing](http://www.xmlpull.org/) so I searched for some nice parser,
preferably in Ruby. As it turns out, the excellent
[Nokogiri](http://nokogiri.org) have one as
[XML::Reader](http://nokogiri.org/Nokogiri/XML/Reader.html). 

# Code

The import was broken into two phases. In phase one the interesting data was
taken from the XML and saved as JSON (it could be any other format of course).
In the second phase it was read and inserted into MySQL. It allowed writing
phase two code while phase one was running and was generally more error
resistant (errors in phase two didn't cause whole import to be rerun).

Phase one code from [GitHub/parse-osm.rb](https://github.com/rkj/devcamp-ssjs-db/blob/master/osm/parse-osm.rb):
{% highlight ruby linenos %}
{% include code/2011-07-05-parse-osm.rb %}
{% endhighlight %}
Parsing whole file ran for a little over 250 seconds:

    ruby parse-osm.rb poland.osm poi.json  247.94s user 3.07s system 99% cpu 4:13.08 total

Just copying the file take more than half of that:

    cp -i poland.osm del.me  0.03s user 3.80s system 2% cpu 2:32.33 total

So the overhead is not too big. While running, the script used less than 4MiB
of RAM, so also very acceptable. The result is 101 793 POI candidates[^2] that
will be imported into the DB in the phase two. It will be described in more
details in a following post, so stay tuned!

[^1]: I mean literally backwards. You, as a client, has to maintain state and
react appropriately. Is is just wrong. I guess this API was easy to implement,
but the result is a strange to use, and code using it ends up pretty mangled.
[^2]: Extracted from 14 122 097 JOSM 'node's and 89 522 705 XML nodes;that gives processing of
more than 362 440 XML tags per second.

