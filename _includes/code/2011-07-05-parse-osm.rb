#!/usr/bin/env ruby
# Small script for scraping POIs from JOSM (http://wiki.openstreetmap.org/wiki/JOSM_file_format).
require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'json'
require 'ap'

class Parser
  # Tags in data that we ignore.
  IGNORED_TAGS = ["created_by", "source"]
  def initialize
    # Map storing attribute name mapped on count of nodes containing it.
    # It is helpful to see what tags should be taken into account in the first place
    # during importing.
    @popular_attributes = {}
    # number of nodes parsed
    @count = 0
    # number of total xml nodes went through
    @total_count = 0
    # number of entries considered useful as POI
    @included = 0
  end
  
  def parse(input, output)
    out = File.new(output, "w")
    begin
      out.write "[\n"
      # Nokogiri reader created.
      reader = Nokogiri::XML::Reader(File.new(input))
      while reader = parse_node(reader, out)
      end
    ensure
      out.write "{}\n]\n"
      out.close
      ap @popular_attributes.sort_by { |k, v| v}.reverse
      STDERR.puts ""
      puts "\n#{@included} / #{@count} / #{@total_count}\t"
    end
  end

  def parse_node(r, out)
    # Search for 'node' tags because they contain data (points). Other tags
    # are discarder.
    (r = r.read; progress) while r && r.name != 'node'
    # Stop processing if end of file
    return false unless r
    # Create entry to be enriched with 'tag' data
    entry = { :lat => r.attribute("lat"), :lon => r.attribute("lon") }
    # Required fields to create usable POI.
    req = ["name"]
    while (progress; r = r.read)
      # Next node found, so no more tags.
      break if r.name == 'node'
      # Only 'tag' are interesting.
      next unless r.name == 'tag'
      # Each tag has form of <tag k="key" v="value" />
      key = r.attribute "k"
      unless IGNORED_TAGS.include? key
        req.delete key
        entry[key] = r.attribute "v"
        @popular_attributes[key] ||= 0
        @popular_attributes[key] += 1
      end
    end
    # If all required tags were found.
    if req.size == 0
      @included += 1 
      out.write(entry.to_json)
      out.write(",\n")
    end
    progress(true)
    return r
  end

  # Progress info
  def progress(entry_found = false)
    @total_count += 1; 
    @count += 1 if entry_found
    limit = 10000
    if @total_count % limit == 0
      STDERR.print "."
      STDERR.print "\r#{@included} / #{@count} / #{@total_count}\t" if @total_count % (limit * 50) == 0
      STDERR.flush
    end
  end
end

if ARGV.size < 2
  puts "Usage: #{$PROGRAM_NAME} osm_file output_json"
  exit 1
end
Parser.new.parse ARGV[0], ARGV[1]

