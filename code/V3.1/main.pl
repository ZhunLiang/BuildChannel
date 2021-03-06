#!/bin/perl
#INPUT
#Input order: electrode X_Y_Z, ChannelLong,TotalZLong,DeletaRation,Wall_gro,Wall_top,Ion_gro,Ion_top



###############Control Parameter###########################
#control build_eletrode.sh
$BUILDELE=1;
#control tune_ion.sh
$DELETE=1;
$RUN=1;
#control scale_ion.sh
$RUNSCALE=1;
$RUNBUILD=1;
#control rescale IonChannel.gro
$RESCALE=1;
#control combine.sh
$GRO=1;
$TOP=1;
$DEL=1;
$SAVETEMP=1;

###############Initial#################
$Python = "\\/opt\\/python\\/bin\\/python";
$Gromacs = "";
@sh_files=<{*.sh}>;
foreach $sh_files(@sh_files){
  system "sed -i 's/PYTHON/$Python/g' $sh_files";
  system "sed -i 's/GROMACS/$Gromacs/g' $sh_files";
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

################ReScale Build Bulk Ion gro#########################
require('rescale_ion.sh');

################Combine gro and top. Delete files#######################
require('combine.sh');
