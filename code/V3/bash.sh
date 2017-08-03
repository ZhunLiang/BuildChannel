#!/bin/perl
#Bash_code directory

$Python = "\\/opt\\/python\\/bin\\/python";
system "sed -i 's/PYTHON/$Python/g' mainV3.sh";
#system "sed -i 's/PYTHON/$Python/g' Ion_channel.sh";
#system "sed -i 's/PYTHON/$Python/g' scale_bulk.sh";
#system "sed -i 's/PYTHON/$Python/g' tune_bulk.sh";

#Run direcotory
#$Prefix="~/Simulation";
#@Folder=("/Ti3C2/","/Ti3C2OH2/","/Ti3C2F2/");
#$Fold_num=@Folder;
#for($i=0;$i<$Fold_num;$i=$i+1){
#    @Directory[$i]="$Prefix@Folder[$i]";
#    #print "@Directory[$i]\n";
#}

#system "sed -i 's/$Python/PYTHON/g' mainV3.sh";
#system "sed -i 's/$Python/PYTHON/g' Ion_channel.sh";
#system "sed -i 's/$Python/PYTHON/g' scale_bulk.sh";
#system "sed -i 's/$Python/PYTHON/g' tune_bulk.sh";
