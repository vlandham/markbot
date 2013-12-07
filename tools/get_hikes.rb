#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

output_filename = "hikes.txt"

url = "http://www.wta.org/go-hiking/hikes/hike_search?title=&region=all&rating=3&mileage%3Aint=0&elevationgain%3Aint=0&highpoint=&searchabletext=&sort=&show_adv=0&filter=Search&b_start:int="


out = []
start = 0
pages = 20
pages.times do |page|
  page_url = "#{url}#{start}"
  doc = Nokogiri::HTML(open(page_url))
  summaries = doc.css(".cell-summary .cell-wrapper")
  summaries.each do |s|
    out << s.text.strip
  end
  start += 30
  puts start
end

File.open(output_filename,'w') do |file|
  out.each do |o|
    file.puts o
    file.puts "\n"
  end
end

