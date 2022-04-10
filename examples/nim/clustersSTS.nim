# use 'notify-desktop' and 'databricks' commands
# to check and notify databricks clusters status change

type
  Cluster  = object
    id:     string
    name:   string
    status: string
  Clusters = HashSet[Cluster]

using cluster:  Cluster
using clusters: Clusters

proc hash(cluster): Hash =
  hash(cluster.id & cluster.status)

proc initCluster(line: string): Cluster =
  let lineCols = line.split(' ')
  Cluster(
    id:     lineCols[0],
    name:   lineCols[1 .. ^2].join(" "),
    status: lineCols[^1]
  )

proc initClusters(): Clusters = initHashSet[Cluster]()

proc notify(clusters): void =
  if clusters.len == 0: return
  let msgs = clusters.mapIt(it.name & " " & it.status).join "\n"
  discard execCmdEx fmt"""notify-desktop --icon=network-server '{msgs}'"""

proc fetchClusters(): Clusters =
  let (o, c) = execCmdEx fmt"databricks clusters list"
  o.strip(chars={'\n'}).split('\n').mapIt(it.initCluster).toHashSet

var 
  clustersThen = initClusters()
  clustersNow  = initClusters()
  interval     = initDuration(minutes = parseInt arg(1, "5"))

while true:
  clustersNow  = fetchClusters()
  notify clustersNow - clustersThen
  clustersThen = clustersNow
  sleep interval.inMilliseconds.int