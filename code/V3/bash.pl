#!/bin/perl
#INPUT
@WantedXYZ= (5,5,-1);
$ChannelLong=8;
$TotalZLong=30;
@ScaleSize= (0,0,1);
@DeletaRation=(1,1);

$Wall_gro="SingleWall.gro";
$Wall_top="SingleWall.top";
$Ion_gro="Ion.gro"; #bulk npt equilibrated at same temperature with wanted channel temperature.
$Ion_top="Ion.top"; # the ion gro file corresponding top file
$WallTop="Wall.top";
$WallGro="Wall.gro";
$OutGro="Channel.gro";
$OutTop="Channel.top";
$channel_name="MILTIION";
$scale_size=100; #scale size means the decimal point number, 100 means %.2f, 1000 means %.3f
$Kmax=1.1; #the maxmiun density of channel ion compare with bulk
$Kmin=1.02; #the mimnium density of channel ion compare with bulk

###############Control Parameter###########################
#control build_eletrode.sh
$BUILDELE=1;
#control tune_ion.sh
$DELETE=1;
$RUN=1;
#control scale_ion.sh
$RUNSCALE=1;
$RUNBUILD=1;
#control combine.sh
$GRO=1;
$TOP=1;
$DEL=1;
$SAVETEMP=1;

###############Initial#################
$Python = "\\/opt\\/python\\/bin\\/python";
@sh_files=<{*.sh}>;
foreach $sh_files(@sh_files){
  system "sed -i 's/PYTHON/$Python/g' $sh_files";
}

###############Get MSD Parameter############################
sub GetMSD{
    my @TEMP = split/\s+/,`grep $_[0] MSD_out.dat`;
    my $TEMP_num = @TEMP;
    my @Out;
    for($i=1;$i<$TEMP_num;$i=$i+1){
        $j=$i-1;
        @Out[$j] = @TEMP[$i];
    }
    return @Out;
}

##############GetPara############################
require('pretreat.sh');

###############Load Function################################
require('function.sh');

################Build electrode#############################
require('build_electrode.sh');

################Tune Bulk Ion gro###########################
require('tune_ion.sh');

################Scale Bulk Ion gro#########################
require('scale_ion.sh');

################Combine gro and top. Delete files#######################
require('combine.sh');

################Back#####################
foreach $sh_files(@sh_files){
  system "sed -i 's/$Python/PYTHON/g' $sh_files";
}
