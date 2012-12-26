# Parse product names from event titles
# Return new names and appropriate citations

creation = (t) ->
  t = t.replace /.*([Pp]ublication|Invention|Launching) of( the)? /, ''
  t = t.replace /.*([Pp]ublishes|[Aa]nnn?ounces) /, ''
  t = t.replace /- .*$/, ''
  t = t.replace /by .*$/, ''

shorten = (t) ->
  t = t.replace /.*aka (\w+).*$/, "$1"
  t = t.replace /(..),.*$/, "$1"
  t = t.replace /.*"(.+?)".*$/, "$1"
  t = t.replace /\(.*?\).*$/, ''
  t = t.replace /\s*$/, ''


rename = (list) ->
  dup = {}
  rename = {}
  for title in list
    short = shorten creation title
    name = if dup[short]
      dup[short]++
      "#{short} (#{dup[short]})"
    else
      dup[short]=1
      short
    rename[title] = {name, citation: title.replace short, "[[#{name}]]"}
  rename
  
module.exports = {rename}

