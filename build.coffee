# Build sample timeline site

p = (a...) -> console.log a...

fs = require 'fs'
fw = require './fw_page'
kv = require './kv_dist'
re = require './re_rename'

fn = 'VW timeline JSON BU 11:9:08.webloc'
tl = fs.readFileSync fn, 'utf8'
js = JSON.parse tl.substring 243, tl.length-86


stats = {}
for k,v of js.events
  kv.tally stats, v
fw.page "Original Dataset", (story) ->
  story.data js.events, fn
  story.paragraph "These are both dumps from the Virtual Worlds timeline on that date. As I recall the RSS version is very primitive, just text, the JSON has all the metadata and links."
  story.paragraph "You can find the current version of the timeline at: [http://nethistory.org/timelines nethistory.org], then click on 'view in dipity'. "
  story.paragraph "<h3>Field Value Distributions"
  for k, v of stats
    story.paragraph "<b>#{k}</b> #{kv.summary v}"


rename = re.rename (v.title for k,v of js.events)
fw.page "Event Catalog", (catalog) ->
  catalog.paragraph "Here we list each imported event and some context extracted from the longer title in the [[Original Dataset]]."
  for k, v of js.events
    catalog.paragraph "#{rename[v.title].citation}<br>#{v.datetime} #{v.location}"
for k, v of js.events
  fw.page rename[v.title].name, (detail) ->
    detail.image v.img_url, 'image' if v.img_url
    detail.paragraph "#{v.title} #{v.datetime} #{v.location}"
    more = []
    more.push "[#{v.media_url} media]" if v.media_url?.length
    more.push "[#{v.link} link]" if v.link?
    detail.paragraph "See also #{more.join(" ")}" if more?
    detail.hyperlink v.descrptn
    if v.lat_lon?.match /\d/
      ll = v.lat_lon.split ','
      detail.item {type: 'map', latlng: {lat:1*ll[0], lng:1*ll[1]}, zoom: 6}

p 'done'
