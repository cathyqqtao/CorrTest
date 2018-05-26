## This function is designed to test the null hypothesis of rate independency.
## This function is writted by Qiqing Tao.
## To cite this function, please cite XXXXXXXX and Tamura. et al. (2017)
## If you have any question, please check the GitHub link https://github.com/cathyqqtao/CorrTest, or email to cathyqqtao@gmail.com.


rate.CorrTest = function(brlen_tree, outgroup, sister.resample = 0, outputFile){

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


  ################# check brach length tree and outgroup #########
  ## check outgroups
  for (i in 1:length(outgroup)){
    if(is.na(match(outgroup[i], brlen_tree$tip.label)) == TRUE){
      stop(paste("Outgroup \"",outgroup[i], "\" is not found. Please check.",sep=''))
    }
  }


  ## check whether branch length tree is binary
  if(ape::is.binary(brlen_tree) == FALSE){
    stop("Only binary trees are allowed. Please remove polytomies.")
  }


  ########################################################################
  ######################### calculate relative rates  ####################
  ########################################################################

  #### get raw relative rates ####
  t = brlen_tree

  t = ape::root(t, outgroup, resolve.root = TRUE)
  t = drop.tip(t, outgroup)

  t.dist = ape::cophenetic.phylo(t)
  brlen = t$edge.length

  RRF.mat = matrix(data=NA, nrow = t$Nnode, ncol = 13)
  colnames(RRF.mat) = c('NodeId', 'Des1', 'Des2', 'l1', 'l2', 'l3', 'l4', 'l5', 'l6', 'r5', 'r6', 'r5.adjust', 'r6.adjust')

  tips.num = length(t$tip.label)
  RRF.mat[, 1] = seq(tips.num+1, tips.num+t$Nnode, 1)

  for (nd in (tips.num+t$Nnode):(tips.num+1)){  # from the shallowest internal node to the root
    row.id = match(nd, RRF.mat[, 1])

    des1 = Descendants(t, nd, 'children')[1]
    des2 = Descendants(t, nd, 'children')[2]
    RRF.mat[row.id, 2] = as.integer(des1)
    RRF.mat[row.id, 3] = as.integer(des2)


    if (des1 <= tips.num && des2 <= tips.num){ ## 2-clade case = des1 and 2 are tips
      l1 = 0
      l2 = 0
      l3 = 0
      l4 = 0
      l5 = brlen[match(des1, t$edge[, 2])]
      l6 = brlen[match(des2, t$edge[, 2])]

      RRF.mat[row.id, seq(4,9,1)] = c(l1,l2,l3,l4,l5,l6)
    }


    if (des1 > tips.num && des2 > tips.num){ ## 4-clade case
      des1.row.id = match(des1, RRF.mat[, 1])
      des2.row.id = match(des2, RRF.mat[, 1])

      l1 = sqrt(RRF.mat[des1.row.id, 4]*RRF.mat[des1.row.id, 5])+RRF.mat[des1.row.id, 8]
      l2 = sqrt(RRF.mat[des1.row.id, 6]*RRF.mat[des1.row.id, 7])+RRF.mat[des1.row.id, 9]
      l3 = sqrt(RRF.mat[des2.row.id, 4]*RRF.mat[des2.row.id, 5])+RRF.mat[des2.row.id, 8]
      l4 = sqrt(RRF.mat[des2.row.id, 6]*RRF.mat[des2.row.id, 7])+RRF.mat[des2.row.id, 9]
      l5 = brlen[match(des1, t$edge[,2])]
      l6 = brlen[match(des2, t$edge[,2])]

      r5 = sqrt(sqrt(l1*l2)+l5)/sqrt(sqrt(l3*l4)+l6)
      r6 = sqrt(sqrt(l3*l4)+l6)/sqrt(sqrt(l1*l2)+l5)

      RRF.mat[row.id, seq(4,11,1)] = c(l1,l2,l3,l4,l5,l6,r5,r6)

      des1.des1 = Descendants(t, des1, 'children')[1]
      des1.des2 = Descendants(t, des1, 'children')[2]
      des2.des1 = Descendants(t, des2, 'children')[1]
      des2.des2 = Descendants(t, des2, 'children')[2]

      r1 =sqrt(l1)*sqrt(sqrt(l1*l2)+l5)/(sqrt(l2)*sqrt(sqrt(l3*l4)+l6))
      r2 =sqrt(l2)*sqrt(sqrt(l1*l2)+l5)/(sqrt(l1)*sqrt(sqrt(l3*l4)+l6))
      r3 =sqrt(l3)*sqrt(sqrt(l3*l4)+l6)/(sqrt(l4)*sqrt(sqrt(l1*l2)+l5))
      r4 =sqrt(l4)*sqrt(sqrt(l3*l4)+l6)/(sqrt(l3)*sqrt(sqrt(l1*l2)+l5))

      if (des1.des1 <= tips.num){ ## If any 4 clade contains only 1 tip, we need to use the calculated r1,r2,r3,r4 as the tip rates
        RRF.mat[des1.row.id, 10] = r1
      }
      if (des1.des2 <= tips.num){
        RRF.mat[des1.row.id, 11] = r2
      }
      if (des2.des1 <= tips.num){
        RRF.mat[des2.row.id, 10] = r3
      }
      if (des2.des2 <= tips.num){
        RRF.mat[des2.row.id, 11] = r4
      }

    }


    if (des1 > tips.num && des2 <= tips.num){ ## 3-clade, des2 is the tip
      des1.row.id = match(des1, RRF.mat[, 1])

      l1 = sqrt(RRF.mat[des1.row.id, 4]*RRF.mat[des1.row.id, 5])+RRF.mat[des1.row.id, 8]
      l2 = sqrt(RRF.mat[des1.row.id, 6]*RRF.mat[des1.row.id, 7])+RRF.mat[des1.row.id, 9]
      l3 = 0
      l4 = 0
      l5 = brlen[match(des1, t$edge[, 2])]
      l6 = brlen[match(des2, t$edge[, 2])]

      r5 = sqrt(sqrt(l1*l2)+l5)/sqrt(l6)
      r6 = sqrt(l6)/sqrt(sqrt(l1*l2)+l5)

      RRF.mat[row.id, seq(4,11,1)] = c(l1,l2,l3,l4,l5,l6,r5,r6)

      des1.des1 = Descendants(t, des1, 'children')[1]
      des1.des2 = Descendants(t, des1, 'children')[2]

      r1 = sqrt(l1)*sqrt(sqrt(l1*l2)+l5)/sqrt(l2*l6)
      r2 = sqrt(l2)*sqrt(sqrt(l1*l2)+l5)/sqrt(l1*l6)

      if (des1.des1 <= tips.num){
        RRF.mat[des1.row.id, 10] = r1
      }
      if (des1.des2 <= tips.num){
        RRF.mat[des1.row.id, 11] = r2
      }

    }


    if (des1 <= tips.num && des2 > tips.num){ ## 3-clade, des1 is the tip
      des2.row.id = match(des2, RRF.mat[, 1])

      l1 = 0
      l2 = 0
      l3 = sqrt(RRF.mat[des2.row.id, 4]*RRF.mat[des2.row.id, 5])+RRF.mat[des2.row.id, 8]
      l4 = sqrt(RRF.mat[des2.row.id, 6]*RRF.mat[des2.row.id, 7])+RRF.mat[des2.row.id, 9]
      l5 = brlen[match(des1, t$edge[, 2])]
      l6 = brlen[match(des2, t$edge[, 2])]

      r5 = sqrt(l5)/sqrt(sqrt(l3*l4)+l6)
      r6 = sqrt(sqrt(l3*l4)+l6)/sqrt(l5)

      RRF.mat[row.id, seq(4,11,1)] = c(l1,l2,l3,l4,l5,l6,r5,r6)

      des2.des1 = Descendants(t, des2, 'children')[1]
      des2.des2 = Descendants(t, des2, 'children')[2]

      r3 = sqrt(l3)*sqrt(sqrt(l3*l4)+l6)/sqrt(l4*l5)
      r4 = sqrt(l4)*sqrt(sqrt(l3*l4)+l6)/sqrt(l3*l5)

      if (des2.des1 <= tips.num){
        RRF.mat[des2.row.id, 10] = r3
      }
      if (des2.des2 <= tips.num){
        RRF.mat[des2.row.id, 11] = r4
      }

    }
  }

  RRF.mat[is.na(RRF.mat[,10]), 10] = 0
  RRF.mat[is.infinite(RRF.mat[,10]), 10] = 0
  RRF.mat[is.na(RRF.mat[,11]), 11] = 0
  RRF.mat[is.infinite(RRF.mat[,11]), 11] = 0

  #### adjust relative rates by multiplying ancestral rate ####
  for (nd in (tips.num+1):(tips.num+t$Nnode)){ ## from root to shallowest internal nodes

    row.id = match(nd, RRF.mat[, 1])
    anc.row = c(match(nd, RRF.mat[,2]), match(nd, RRF.mat[,3]))

    if (is.na(anc.row[1]) == TRUE && is.na(anc.row[2]) == TRUE){ ## ancestor is root
      r.anc = 1
      RRF.mat[row.id, c(12,13)] = RRF.mat[row.id, c(10,11)]*r.anc
    }else if (is.na(anc.row[1]) == FALSE && is.na(anc.row[2]) == TRUE){
      r.anc = RRF.mat[anc.row[1], 12]
      RRF.mat[row.id, c(12,13)] = RRF.mat[row.id, c(10,11)]*r.anc

      if(RRF.mat[row.id, 2] <= tips.num){ ## if a offspring is tip, we need grandparent rate
        grandpa.row = c(match(RRF.mat[anc.row[1], 1], RRF.mat[, 2]), match(RRF.mat[anc.row[1], 1], RRF.mat[, 3]))
        if (is.na(grandpa.row[1]) == TRUE && is.na(grandpa.row[2]) == TRUE){
          r.anc = 1
        }else{
          r.grandpa = c(RRF.mat[grandpa.row[1], 12], RRF.mat[grandpa.row[2], 13])
          r.anc =  r.grandpa[!is.na(r.grandpa)]
          RRF.mat[row.id, 12] = RRF.mat[row.id, 10]*r.anc
        }
      }

      if(RRF.mat[row.id, 3] <= tips.num){ ## if a offspring is tip, we need grandparent rate
        grandpa.row = c(match(RRF.mat[anc.row[1], 1], RRF.mat[, 2]), match(RRF.mat[anc.row[1], 1], RRF.mat[, 3]))
        if (is.na(grandpa.row[1]) == TRUE && is.na(grandpa.row[2]) == TRUE){
          r.anc = 1
        }else{
          r.grandpa = c(RRF.mat[grandpa.row[1], 12], RRF.mat[grandpa.row[2], 13])
          r.anc =  r.grandpa[!is.na(r.grandpa)]
          RRF.mat[row.id, 13] = RRF.mat[row.id, 11]*r.anc
        }
      }
    }else if (is.na(anc.row[1]) == TRUE && is.na(anc.row[2]) == FALSE){
      r.anc = RRF.mat[anc.row[2], 13]
      RRF.mat[row.id, c(12,13)] = RRF.mat[row.id, c(10,11)]*r.anc

      if(RRF.mat[row.id, 2] <= tips.num){ ## if a offspring is tip, we need grandparent rate
        grandpa.row = c(match(RRF.mat[anc.row[2], 1], RRF.mat[, 2]), match(RRF.mat[anc.row[2], 1], RRF.mat[, 3]))
        if (is.na(grandpa.row[1]) == TRUE && is.na(grandpa.row[2]) == TRUE){
          r.anc = 1
        }else{
          r.grandpa = c(RRF.mat[grandpa.row[1], 12], RRF.mat[grandpa.row[2], 13])
          r.anc =  r.grandpa[!is.na(r.grandpa)]
          RRF.mat[row.id, 12] = RRF.mat[row.id, 10]*r.anc
        }
      }

      if(RRF.mat[row.id, 3] <= tips.num){ ## if a offspring is tip, we need grandparent rate
        grandpa.row = c(match(RRF.mat[anc.row[2], 1], RRF.mat[, 2]), match(RRF.mat[anc.row[2], 1], RRF.mat[, 3]))
        if (is.na(grandpa.row[1]) == TRUE && is.na(grandpa.row[2]) == TRUE){
          r.anc = 1
        }else{
          r.grandpa = c(RRF.mat[grandpa.row[1], 12], RRF.mat[grandpa.row[2], 13])
          r.anc =  r.grandpa[!is.na(r.grandpa)]
          RRF.mat[row.id, 13] = RRF.mat[row.id, 11]*r.anc
        }
      }
    }
  }

  #### format raw RRF rates (perpare for feature extraction) ####
  nodeID = c(RRF.mat[,2], RRF.mat[,3], tips.num+1)  ## all nodes + root
  RRF.rates = c(RRF.mat[,'r5.adjust'], RRF.mat[,'r6.adjust'], 1)  ### all rates + root rate=1

  d = data.frame(nodeID, RRF.rates)
  d = d[with(d, order(nodeID)), ]
  Des1 = c(rep('-', tips.num), RRF.mat[,2])
  Des2 = c(rep('-', tips.num), RRF.mat[,3])

  d = data.frame(d, Des1, Des2)

  #### remove external rates ####
  # d = d[-1:-tips.num,]

  ########################################################################
  ######################## get features for CorrTest  ####################
  ########################################################################

  #### get sister correlation ####

  nodeID = d$nodeID
  des1 = suppressWarnings(as.numeric(as.character(d$Des1)))
  des2 = suppressWarnings(as.numeric(as.character(d$Des2)))

  rates = d$RRF.rates ##
  rates[is.na(rates)] = 0
  rates[is.infinite(rates)] = 0

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

  #### resampling sister pairs for 50 times
  if (sister.resample != 0){
    pairs.num = length(r1)

    rhos = numeric()
    for (i in 1:sister.resample){
      s = sample(c(1,2), pairs.num, replace = TRUE)
      r1.s = c(r1[s==1], r2[s==2])
      r2.s = c(r2[s==1], r1[s==2])
      rho_s.s = cor.test(r1.s, r2.s, alternative = "two.sided", method = 'spearman', conf.level=0.95, exact=FALSE)$estimate
      rhos = c(rhos, rho_s.s)
    }

    rho_s = mean(rhos)
  }


  #### get ancestral-descendant correlation ####

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


  #### get the decay of ancestral-descendant correlation ####

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

  ########################################################################
  ############################ for CorrTest  #############################
  ########################################################################

  #### data normalization ####
  rho_s.norm = (rho_s-0.436462708)/0.268015804
  rho_ad.norm = (rho_ad_all[1]-0.828259994)/0.087506404
  rho_ad_1_decay.norm = (rho_ad_1_decay-(-0.169515205))/0.103192689
  rho_ad_2_decay.norm = (rho_ad_2_decay-(-0.292940377))/0.163616884


  #### the logistic model from sklearn ####
  b0 = -0.07500227
  b1 = 6.02875922
  b2 = -0.29265746
  b3 = 2.30731322
  b4 = -3.2276037

  score = 1/(1+exp(-(b0 + b1*rho_s.norm + b2*rho_ad.norm + b3*rho_ad_1_decay.norm + b4*rho_ad_2_decay.norm)))

  if (score >=0.92){
    write(paste('score = ', format(score, digits = 5), '\nP-value < 0.001', sep=''), file=outputFile)
  }
  if (score >=0.83 && score <0.92){
    write(paste('score = ', format(score, digits = 5), '\nP-value < 0.01', sep=''), file=outputFile)
  }
  if (score >=0.5 && score <0.83){
    write(paste('score = ', format(score, digits = 5), '\nP-value < 0.05', sep=''), file=outputFile)
  }
  if (score <0.5){
    write(paste('score = ', format(score, digits = 5), '\nP-value > 0.05', sep=''), file=outputFile)
  }

}



