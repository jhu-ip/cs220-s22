#! /usr/bin/env ruby

STDIN.each_line do |line|
  line.strip!
  if m = /^<(.*)>$/.match(line)
    url = m[1]
    print <<"EOF1"
<a class="external" target="_blank" href="#{url}">#{url}</a>
EOF1
  elsif m = /^\[(.*)\]\((.*)\)$/.match(line)
    link_text = m[1]
    url = m[2]
    print <<"EOF2"
<a class="external" target="_blank" href="#{url}">#{link_text}</a>
EOF2
  end
end
