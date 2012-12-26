# Tally distribution of key values
# Summarize most frequent cases

tally = (dist, obj) ->
  for k2,v2 of obj
    dist[k2] = {} unless dist[k2]?
    dist[k2][v2] = 0 unless dist[k2][v2]?
    dist[k2][v2]++

summary = (dist) ->
  top = ([v,k] for k,v of dist).sort (a,b) -> b-a
  sum = []
  num = 0
  for [v,k] in top
    if v > 1
      sum.push "#{v}x'#{k}'"
    else
      num++
  sum.push "#{num}x unique" if num > 0
  sum.join ', '

module.exports = {tally, summary}
