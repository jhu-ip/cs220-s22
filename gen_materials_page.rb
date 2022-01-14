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

class Week
  def initialize
    # map of day number to DayInfo
    @days = {}
  end

  def [](key)
    return @days[key]
  end

  def []=(key, value)
    @days[key] = value
  end

  def keys
    return @days.keys
  end

  def has_key?(key)
    return @days.has_key?(key)
  end

  def day_numbers
    return keys.sort
  end

  def date_of(pos)
    raise "No days yet!" if @days.empty?
    d = self.day_numbers
    return @days[d[pos]].date
  end

  def first_date
    return date_of(0)
  end

  def last_date
    return date_of(-1)
  end
end

def format_link(link_text, url)
  if url.start_with?('http:') || url.start_with?('https:')
    return "<a class='external' target='_blank' href='#{url}'>#{link_text}</a>"
  else
    #return "[#{link_text}](#{url})"
    return "<a href='#{url}'>#{link_text}</a>"
  end
end

# Map of week numbers to Week objects
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
      weeks[week_num] = Week.new
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

  days = week.keys.sort

  #puts "## Week #{week_num}"
  #puts ''

  #first_date = week[days[0]].date
  #last_date = week[days[-1]].date

  print <<"EOF2"
<button type="button" id="week_#{week_num}_toggle" class="week_control_button">Week #{week_num} (#{week.first_date}–#{week.last_date})</button>
<div id="week_#{week_num}" class="collapsible">
EOF2

  # print table header
  #print '  '
  print <<"EOF3"
<table>
  <thead>
    <tr>
      <th></th>
EOF3
  days.each do |day_num|
    day_info = week[day_num]
    puts "      <th>Day #{day_num} (#{day_info.date})</th>"
  end
  #puts ''
  print <<"EOF4"
    </tr>
  </thead>
  <tbody>
EOF4

  #print ' :--: '
  #days.each do
  #  print ' | -- '
  #end
  #puts ''

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

    puts "    <tr>"

    #print "#{row_name}"
    puts "      <td>#{row_name}</td>"

    week.keys.sort.each do |day_num|
      day_info = week[day_num]

      items = day_info.get_items(type)

      #print ' | '
      print "      <td>"

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

    puts "</td>"
    end

    #puts ''

    puts "    </tr>"
  end

  puts "  </tbody>"
  puts "</table>"

  puts "</div>" # end of week content div
end

print <<"EOF9"
<script type="text/javascript">
  document.addEventListener('DOMContentLoaded', function() {
    // set all non-active week content to be hidden
    var content_divs = document.getElementsByClassName("collapsible");
    for (i = 0; i < content_divs.length; i++) {
      var content = content_divs[i];
      // TODO: don't default active week content to hidden
      content.style.display = "none";

      // Add callback for button press
      var button_id = content.id + '_toggle';
      console.log("find element " + button_id);
      var button = document.getElementById(button_id);
      button.addEventListener('click', function() {
        button.classList.toggle('active');
        if (content.style.display == 'block') {
          content.style.display = 'none';
        } else {
          content.style.display = 'block';
        }
      });
    }
  });
</script>
EOF9
