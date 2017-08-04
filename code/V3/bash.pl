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
$OutWallTop="Wall.top";
$OutPutChannel="Channel.gro";
$Channel_gro="Channel_temp.gro";
$channel_name="MILTIION";
$scale_size=100; #scale size means the decimal point number, 100 means %.2f, 1000 means %.3f
$Kmax=1.1; #the maxmiun density of channel ion compare with bulk
$Kmin=1.02; #the mimnium density of channel ion compare with bulk

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
require('getpara.sh');

###############Load Function################################
require('function.sh');

################Build electrode#############################
#require('build_electrode.sh');

################Tune Bulk Ion gro###########################
#require('tune_ion.sh');

################Scale Bulk Ion gro#########################
require('scale_ion.sh');
print "@TuneNumXYZ\n";
################Back#####################
foreach $sh_files(@sh_files){
  system "sed -i 's/$Python/PYTHON/g' $sh_files";
}
