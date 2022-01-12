#! /usr/bin/env ruby

require 'csv'

FRONT_STUFF = <<'EOF1'
---
layout: default
title: "Course Material"
category: "material"
---

<!--
IMPORTANT: please don't edit material.md directly.
Instead, edit material.csv, adding a new row for each item you
want to add, and then regenerate materials.md by running
the command

  ./gen_materials_page.rb > material.md

Then add, commit, and push both material.csv and material.md.
-->

EOF1

KNOWN_KEYS = {
  'Video' => 1,
  'Slides' => 1,
  'Recap' => 1,
  'Exercise' => 1,
  'Resource' => 1,
  'Recording' => 1,
}

class DayInfo
  attr_reader :date

  def initialize
    @info = {}
    @date = nil
  end

  def add_item(type, link_text, url)
    raise "Unknown item type #{type}" if !KNOWN_KEYS.has_key?(type)

    if !@info.has_key?(type)
      @info[type] = []
    end

    @info[type].push([link_text, url])
  end

  def set_date(date)
    @date = date
  end

  def get_items(type)
    return [] if !@info.has_key?(type)
    return @info[type]
  end
end

def format_link(link_text, url)
  if url.start_with?('http:') || url.start_with?('https:')
    return "<a class='external' target='_blank' href='#{url}'>#{link_text}</a>"
  else
    return "[#{link_text}](#{url})"
  end
end

# Map of week numbers to collected information for the week
# (which in turn is a map of day numbers to day information)
weeks = {}

CSV.foreach('material.csv') do |row|
  if row[0] != 'Week'
    week_num = row[0].to_i
    day = row[1].to_i
    date = row[2]
    type = row[3]
    link_text = row[4]
    url = row[5]

    if !weeks.has_key?(week_num)
      weeks[week_num] = {}
    end

    week_info = weeks[week_num]

    if !week_info.has_key?(day)
      week_info[day] = DayInfo.new
      week_info[day].set_date(date)
    end

    day_info = week_info[day]
    day_info.add_item(type, link_text, url)
  end
end

print FRONT_STUFF

weeks.keys.sort.each do |week_num|
  week = weeks[week_num]

  puts "## Week #{week_num}"
  puts ''

  # print table header
  print '  '
  week.keys.sort.each do |day_num|
    day_info = week[day_num]
    print " &nbsp; | Day #{day_num} (#{day_info.date})"
  end
  puts ''

  print ' :--: '
  week.keys.each do
    print ' | -- '
  end
  puts ''

  [
    ['Video', 'Videos'],
    ['Slides', 'Slides'],
    ['Recap', 'Recap<br>Questions'],
    ['Exercise', 'Exercise'],
    ['Resource', 'Additional<br>Resources'],
    ['Recording', 'Recorded<br>Sessions']
  ].each do |pair|
    type = pair[0]
    row_name = pair[1]

    print "#{row_name}"

    week.keys.sort.each do |day_num|
      day_info = week[day_num]

      items = day_info.get_items(type)

      print ' | '

      first = true
      items.each do |item|
        if first
          first = false
        else
          print "<br>"
        end

        link_text = item[0]
        url = item[1]

        print format_link(link_text, url)
      end
    end

    puts ''
  end

end
