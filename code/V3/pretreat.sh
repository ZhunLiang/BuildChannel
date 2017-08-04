#!/bin/perl
#INPUT

system "PYTHON GetMSDpara.py";
our @MoleName = GetMSD("NAME");
our @MoleMass = GetMSD("MASS");
our @MoleNum = GetMSD("NUM");
our $TotalNum = @MoleName;
system "rm -f MSD_out.dat";

1;
