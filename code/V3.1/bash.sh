#!/bin/perl
#INPUT
#Input order: directory, electrode X_Y_Z, ChannelLong,TotalZLong,DeletaRation,Wall_gro,Wall_top,Ion_gro,Ion_top

system "cp *.sh *.py *.pl *.mdp $ARGV[0]";
chdir $ARGV[0];
system "perl main.pl $ARGV[1] $ARGV[2] $ARGV[3] $ARGV[4] $ARGV[5] $ARGV[6] $ARGV[7] $ARGV[8]"; 
system "rm -f main.pl pretreat.sh function.sh build_electrode.sh tune_ion.sh scale_ion.sh combine.sh CalDelNum.py CombineGro.py DelMole3.py GetMSDpara.py GetZmax.py SortMole.py scale-nvt.mdp tune_npt.mdp"
