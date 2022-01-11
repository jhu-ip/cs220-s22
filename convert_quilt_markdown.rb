#! /usr/bin/env ruby

# Convert a Markdown file using Quilt syntax to something closer to
# Github-Flavored Markdown.

# The main thing we're trying to accomplish is converting ":::" blocks
# into HTML <div> elements. Unfortunately, this means that we must
# convert the content of each block from Markdown to HTML, since
# Markdown can't be nested inside an HTML element.  However,
# the blocks are generally short, so it's not a huge problem.

# Use this script as follows:
#
#   ./convert_quilt_markdown.rb < ORIG.md > RESULT.md
#
# where ORIG.md is the Quilt-syntax input file, and
# RESULT.md is the converted file that should be more or less
# in GFM format.

# Note that you will probably still need to edit the
# YAML front matter to add the following:
#
# layout: default
#
# This will allow jekyll to choose the correct layout template
# for the page.

# Also: you will probably need to fix links to images and other
# documents.  (E.g., the previous docasaurus-based website had
# a "static" directory for static content, which no longer exists.)

require 'open3'

state = :scan

block_indent = nil
block_class = nil
block_content = nil

STDIN.each_line do |line|
  if state == :scan
    if m = /^(\s*):::([\S]+)/.match(line)
      # beginning of block
      block_indent = m[1]
      block_class = m[2]
      block_content = []
      state = :grab_block
    else
      # not in a block
      puts line
    end
  elsif state == :grab_block
    if m = /^\s*:::/.match(line)
      # end of block
      block_markdown = block_indent + block_content.join(block_indent)
      block_html, err, status = Open3.capture3('pandoc -f gfm -t html', stdin_data: block_markdown)
      if !status.exited? || status.exitstatus != 0
        raise "pandoc failed"
      end
      puts "#{block_indent}<div class='#{block_class}'>"
      puts block_html
      puts "#{block_indent}</div>"
      state = :scan
    else
      # block continues
      block_content.push(line)
    end
  end
end
