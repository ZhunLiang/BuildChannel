#!/bin/perl
#INPUT
sub GetInputPara{
  my @temp = split/_/,$_[0];
  return @temp; 
}

sub GetInputFile{
  system "cp $_[0] $_[1]";
}

our $Wall_gro="SingleWall.gro";
our $Wall_top="SingleWall.top";
our $Ion_gro="Ion.gro"; 
our $Ion_top="Ion.top"; 
our $WallTop="Wall.top";
our $WallGro="Wall.gro";
our $OutGro="Channel.gro";
our $OutTop="Channel.top";
our $channel_name="MILTIION";
our $scale_size=100; #scale size means the decimal point number, 100 means %.2f, 1000 means %.3f
our $Kmax=1.1; #the maxmiun density of channel ion compare with bulk
our $Kmin=1.02; #the mimnium density of channel ion compare with bulk

#@WantedXYZ= (5,5,-1);
#$ChannelLong=8;
#$TotalZLong=30;
#@DeletaRation=(1,1);
#$Wall_gro="SingleWall.gro";
#$Wall_top="SingleWall.top";
#$Ion_gro="Ion.gro"; #bulk npt equilibrated at same temperature with wanted channel temperature.
#$Ion_top="Ion.top"; # the ion gro file corresponding top file

our @WantedXYZ=GetInputPara($ARGV[0]);
our $ChannelLong=$ARGV[1];
our $TotalZLong=$ARGV[2];
our @DeletaRation=GetInputPara($ARGV[3]);
GetInputFile($ARGV[4],$Wall_gro);
GetInputFile($ARGV[5],$Wall_top);
GetInputFile($ARGV[6],$Ion_gro);
GetInputFile($ARGV[7],$Ion_top);

system "PYTHON GetMSDpara.py";
our @MoleName = GetMSD("NAME");
our @MoleMass = GetMSD("MASS");
our @MoleNum = GetMSD("NUM");
our $TotalNum = @MoleName;
system "rm -f MSD_out.dat";

1;
