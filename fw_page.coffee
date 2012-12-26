# Federated Wiki Pages
# writes to ../pages

fs = require 'fs'

asSlug = (name) ->
  name.replace(/\s/g, '-').replace(/[^A-Za-z0-9-]/g, '').toLowerCase()

randomId = (n) ->
  (Math.floor(Math.random()*10) for i in [1..n]).join ''

hyperlink = (text) ->
  external = (ref) -> "[#{ref} #{site}]" if ref.match /https?:\/\/([^\/]+)*/
  text.replace /\b((https?):[^\s<>\[\]"'\(\)]*[^\s<>\[\]"'\(\)\,\.\?])/g, "[$1 link]"

class Page
  constructor: (@title, @story=[], @journal=[]) ->
  item: (object) -> object.id = randomId 16; @story.push object
  paragraph: (text) -> @item {type:'paragraph', text}
  hyperlink: (text) -> @paragraph hyperlink text
  data: (data, text) -> @item {type: 'data', data, text}
  image: (url, text) -> @item {type: 'image', url, text: text or url}
  object: -> {title:@title, story:@story, journal:@journal}
  json: -> JSON.stringify @object(), null, '  '

page = (title, doit) ->
  doit page = new Page title
  page.journal.push {type:'create', item:{title, story:page.story}, id:randomId(16), date:((new Date).getTime()) }
  fs.writeFile "../pages/#{asSlug title}", page.json(), (err) -> throw err if err
  

module.exports = {page}