phylo.CorrTest = function(brlen_tree, timetree, outgroup){

  ################# check required packages ##############
  if (!library('ape',logical.return = TRUE)){
    stop("'ape' package not found, please install it to run CorrTest")
  }
  if (!library('phangorn',logical.return = TRUE)){
    stop("'phangorn' package not found, please install it to run CorrTest")
  }
  if (!library('stats',logical.return = TRUE)){
    stop("'stats' package not found, please install it to run CorrTest")
  }
  if (!library('R.utils',logical.return = TRUE)){
    stop("'R.utils' package not found, please install it to run CorrTest")
  }


  ################# load brach length tree, timetree and outgroup #########
  ## check outgroups
  for (i in 1:length(outgroup)){
    if(is.na(match(outgroup[i], brlen_tree$tip.label)) == TRUE || is.na(match(outgroup[i], timetree$tip.label)) == TRUE){
      stop(paste("Outgroup \"",outgroup[i], "\" is not found. Please check.",sep=''))
    }
  }

  ## load trees
  brlen_tree = ape::root(brlen_tree, outgroup, resolve.root=TRUE)
  brlen_tree = ape::drop.tip(brlen_tree, outgroup)
  timetree = ape::drop.tip(timetree, outgroup)

  timetree.tips = timetree$tip.label
  brlen_tree.tips = brlen_tree$tip.label

  ## check whether two trees have the same species and topology
  if (length(timetree.tips) != length(brlen_tree.tips)){
    stop("Branch length tree and timetree have inconsistent species. Please check.")
  }

  if (length(base::intersect(timetree.tips, brlen_tree.tips)) < length(timetree.tips)){
    stop("Branch length tree and timetree have inconsistent species. Please check.")
  }

  if(phangorn::RF.dist(brlen_tree, timetree) != 0){
    stop("Branch length tree and timetree have different topologies. Please check.")
  }

  ## check whether two trees are binary
  if(ape::is.binary(brlen_tree) == FALSE || ape::is.binary(timetree) == FALSE){
    stop("Only binary trees are allowed. Please remove polytomies.")
  }

  if(nrow(timetree$edge) != nrow(brlen_tree$edge)){
    stop("Only binary trees are allowed. Please remove polytomies.")
  }


  ## calculate rates (based on the branching pattern of timetree)

  timetree.edge = timetree$edge
  TE = timetree$edge.length

  brlen_tree.edge = brlen_tree$edge
  brlen = brlen_tree$edge.length

  done = logical(nrow(timetree.edge))
  brlen_tree_edge_in_timetree = numeric(nrow(brlen_tree.edge))


  for (i1 in 1:length(timetree.tips)){

    tip = timetree.tips[i1]
    i2 = match(tip, brlen_tree.tips)

    e1 = match(i1, timetree.edge[,2])
    e2 = match(i2, brlen_tree.edge[,2])

    while(!done[e2]){
      brlen_tree_edge_in_timetree[e1] = e2
      done[e2] = TRUE

      i1_new = timetree.edge[e1, 1]
      i2 = brlen_tree.edge[e2, 1]

      if (i2 != (length(timetree.tips)+1)){
        e1 = match(i1_new, timetree.edge[,2])
        e2 = match(i2, brlen_tree.edge[,2])
      }
    }
  }

  brlen_same_order = brlen[brlen_tree_edge_in_timetree]


  rate = brlen_same_order/TE
  rate[is.na(rate)] = 0
  rate[is.infinite(rate)] = 0

  nodeLabel = character()
  nodeID = numeric()
  Des1 = character()
  Des2 = character()
  height.inf = character()
  rate.inf = numeric()

  for (k in 1:nrow(timetree.edge)){
    edge.anc.node = timetree.edge[,1]
    edge.Des.node = timetree.edge[,2]

    nodeID = c(nodeID, edge.Des.node[k])
    rate.inf = c(rate.inf, rate[k])

    Des.node = phangorn::Descendants(timetree, edge.Des.node[k], type='children')
    if (length(Des.node) == 0){
      Des1 = c(Des1, '-')
      Des2 = c(Des2, '-')
    }else{
      Des1 = c(Des1, Des.node[1])
      Des2 = c(Des2, Des.node[2])
    }

  }

  nodeID = c(nodeID, length(timetree$tip.label)+1)
  rate.inf = c(rate.inf, 0)
  Des.node = phangorn::Descendants(timetree, length(timetree$tip.label)+1, type='children')
  Des1 = c(Des1, Des.node[1])
  Des2 = c(Des2, Des.node[2])

  d = data.frame(nodeID, Des1, Des2, rate.inf)
  d = d[with(d, order(nodeID)), ]

  ##### get sister correlation ####

  nodeID = d$nodeID
  des1 = suppressWarnings(as.numeric(as.character(d$Des1)))
  des2 = suppressWarnings(as.numeric(as.character(d$Des2)))

  rates = d$rate.inf ##

  des1.rates = numeric()
  des2.rates = numeric()

  start.node = length(des1[is.na(des1)])+1

  for (node in  start.node : length(des1)){

    des1.node = des1[node]
    des2.node = des2[node]

    des1.rate = rates[match(des1.node,nodeID)]
    des2.rate = rates[match(des2.node,nodeID)]

    des1.rates = c(des1.rates, des1.rate)
    des2.rates = c(des2.rates, des2.rate)

  }

  r1 = des1.rates[des1.rates!=0 & des2.rates!=0]
  r2 = des2.rates[des1.rates!=0 & des2.rates!=0]

  rho_s = cor.test(r1, r2, alternative = "two.sided", method = 'spearman', conf.level=0.95, exact=FALSE)$estimate

  ##### get ancestral-descendant correlation ####

  nodes = numeric()
  anc.nodes = numeric()
  des.nodes = numeric()
  anc.rates = numeric()
  des.rates = numeric()
  rho_ad_all = numeric()

  start.node = length(des1[is.na(des1)])+1

  for (node in  start.node : length(des1)){

    anc.node = which(des1 == node)
    if (length(anc.node) == 0){
      anc.node = which(des2 == node)
      if (length(anc.node) == 0){
        anc.node = 0
      }
    }

    nodes = c(nodes, node)
    anc.nodes = c(anc.nodes, anc.node)
    anc.rate = rates[node]
    anc.rates = c(anc.rates, anc.rate)

    des1.node = des1[node]
    des.nodes = c(des.nodes, des1.node)
    des1.rate = rates[des1.node]
    des.rates = c(des.rates, des1.rate)

    nodes = c(nodes, node)
    anc.nodes = c(anc.nodes, anc.node)
    anc.rate = rates[node]
    anc.rates = c(anc.rates, anc.rate)

    des2.node = des2[node]
    des.nodes = c(des.nodes, des2.node)
    des2.rate = rates[des2.node]
    des.rates = c(des.rates, des2.rate)

  }

  eff.row = !R.utils::isZero(anc.nodes)

  anc.rates.eff = anc.rates[eff.row]
  des.rates.eff = des.rates[eff.row]

  ra = anc.rates.eff[anc.rates.eff!=0 & des.rates.eff!=0]
  rd = des.rates.eff[anc.rates.eff!=0 & des.rates.eff!=0]

  rho_ad = stats::cor.test(ra, rd, alternative = "two.sided", method = 'spearman',conf.level=0.95, exact=FALSE)$estimate
  rho_ad_all = c(rho_ad_all, rho_ad)


  ##### get the decay of ancestral-descendant correlation ####

  for (lag in 2:3){

    NodeId.lag = numeric()
    anc.nodes.lag = numeric()
    des.nodes.lag = numeric()
    anc.rates.lag = numeric()
    des.rates.lag = numeric()

    for (i in 1:length(nodes)){
      node = nodes[i]

      temp.des.node = des.nodes[i]
      temp.des.nodesGroup = which(nodes==temp.des.node) # find 2 children of the direct descendant of the current select node

      if (length(temp.des.nodesGroup) == 0) next  # temp.des.node are tips, then no des.nodesGroup, mode to next node

      lag.num = 1

      repeat{
        lag.num = lag.num + 1
        if (lag.num == lag) break

        temp.des.nodesGroup.new = numeric()

        for (j in 1:length(temp.des.nodesGroup)){  # for each node in the former descendant group, get its direct decending nodes
          temp.des.node = des.nodes[temp.des.nodesGroup[j]]
          temp.des.nodesPair = which(nodes==temp.des.node)
          if (length(temp.des.nodesPair) == 0) next

          temp.des.nodesGroup.new = c(temp.des.nodesGroup.new, temp.des.nodesPair)
        }
        temp.des.nodesGroup = temp.des.nodesGroup.new
      }

      if (length(temp.des.nodesGroup) == 0) next

      des.nodes.lag = c(des.nodes.lag, des.nodes[temp.des.nodesGroup])

      des.rates.lag = c(des.rates.lag, des.rates[temp.des.nodesGroup])

      # since every node has 2 descendants, rep the anc.rates and nodeID twice
      NodeId.lag = c(NodeId.lag, rep(node,length(temp.des.nodesGroup)))
      anc.nodes.lag = c(anc.nodes.lag, rep(anc.nodes[i],length(temp.des.nodesGroup)))
      anc.rates.lag = c(anc.rates.lag, rep(anc.rates[i],length(temp.des.nodesGroup)))

    }

    eff.row = !R.utils::isZero(anc.nodes.lag)

    anc.rates.lag.eff = anc.rates.lag[eff.row]
    des.rates.lag.eff = des.rates.lag[eff.row]

    ra.lag = anc.rates.lag.eff[anc.rates.lag.eff!=0 & des.rates.lag.eff!=0]
    rd.lag = des.rates.lag.eff[anc.rates.lag.eff!=0 & des.rates.lag.eff!=0]

    rho_ad_lag = stats::cor.test(ra.lag, rd.lag, alternative = "two.sided", method = 'spearman',conf.level=0.95, exact=FALSE)$estimate
    rho_ad_all = c(rho_ad_all, rho_ad_lag)

  }

  rho_ad_1_decay = (rho_ad_all[2] - rho_ad_all[1])/rho_ad_all[1]
  rho_ad_2_decay = (rho_ad_all[3] - rho_ad_all[1])/rho_ad_all[1]

  out = c(rho_s, rho_ad_all[1], rho_ad_1_decay, rho_ad_2_decay)
  names(out) = c('rho_s', 'rho_ad', 'rho_ad_1_decay', 'rho_ad_2_decay')
  # return(out)


  #################### CorrTest ######################
  ## data normalization
  rho_s.norm = (rho_s-0.436462708)/0.268015804
  rho_ad.norm = (rho_ad_all[1]-0.828259994)/0.087506404
  rho_ad_1_decay.norm = (rho_ad_1_decay-(-0.169515205))/0.103192689
  rho_ad_2_decay.norm = (rho_ad_2_decay-(-0.292940377))/0.163616884


  ## the logistic model from sklearn
  b0 = -0.07500227
  b1 = 6.02875922
  b2 = -0.29265746
  b3 = 2.30731322
  b4 = -3.2276037

  score = 1/(1+exp(-(b0 + b1*rho_s.norm + b2*rho_ad.norm + b3*rho_ad_1_decay.norm + b4*rho_ad_2_decay.norm)))

  if (score >=0.92){
    return(paste('score = ', format(score, digits = 3), ' (P<0.001)', sep=''))
  }
  if (score >=0.83 && score <0.92){
    return(paste('score = ', format(score, digits = 3), ' (P<0.01)', sep=''))
  }
  if (score >=0.5 && score <0.83){
    return(paste('score = ', format(score, digits = 3), ' (P<0.05)', sep=''))
  }
  if (score <0.5){
    return(paste('score = ', format(score, digits = 3), ' (P>0.05)', sep=''))
  }

}


