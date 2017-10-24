* mcmctree.ctl for mammal analysis (dos Reis et al. 2012):
         seed = -1
      seqfile = selectedSeq.phy
     treefile = RAxML_bipartitions_rooted.nwk
      outfile = Wickett_MC2T_AR_oneCali.txt

        ndata = 1
      usedata = 2    * 0: no data; 1:seq like; 2:use in.BV; 3: out.BV
        clock = 3    * 1: global clock; 2: independent rates; 3: correlated rates
      RootAge = '>8.96<9.96'  * safe constraint on root age, used if no fossil for root.

        model = 7    * 0:JC69, 1:K80, 2:F81, 3:F84, 4:HKY85
        alpha = 1    * alpha for gamma rates at sites
        ncatG = 4    * No. categories in discrete gamma

    cleandata = 0    * remove sites with ambiguity data (1:yes, 0:no)?

      BDparas = 2 2 0.1     * birth, death, sampling
  kappa_gamma = 5 .5      * gamma prior for kappa
  alpha_gamma = 1 .5      * gamma prior for alpha

  rgene_gamma = 1 1    * gamma prior for overall rates for genes (prior from dos Reis et al. 2012 PRSL B 279:3491-3500)
* rgene_gamma = 2 40   * gamma prior for overall rates for genes (prior from dos Reis et al. 2014 Syst Biol 63:555-565)
 sigma2_gamma = 1 1    * gamma prior for sigma^2     (for clock=2 or 3)

 finetune = 1: .001  0.033  0.0077  0.03 .23  * times, rates, mixing, paras, RateParas

        print = 1
       burnin = 100000
     sampfreq = 150
      nsample = 10000

*** Note: Make your window wider (100 columns) before running the program
