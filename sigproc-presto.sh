#!/bin/bash
sffile=$1
filfile=$1.fil
filterbank $sffile -o $filfile
dedisperse_all $filfile -d 10 100 -g 1000000 -l
for tim in `ls *.tim`; do echo "processing $tim"; nsamp=`header $tim |grep "Number of samples" |awk '{print $5}'`; echo "number of samples = $nsamp"; transformLength=`echo $nsamp | awk '{printf("%.0f\n",log($1)/log(2.0))}'`; echo "2**N number is $transformLength"; seek $tim -t$transformLength; done
numprd=`ls *.prd | wc -l`
echo $numprd
numtop=`ls *.top | wc -l`
echo $numtop
cat *.prd > beam1.allCands
best beam1.allCands
nCand=`wc -l *.allC.lis | awk '{print $1}'`
echo $nCand
for candLine in `seq 1 $nCand`;do line=`head -$candLine *.allC.lis | tail -1`; period_sec=`echo $line | awk '{print $1/1000.0}'`; dm=`echo $line |awk '{print $3}'`; echo "Making plot for $line $period_sec $dm" >> log.txt; outputLabel=`echo beam1 $dm $candLine |awk '{printf("%-0.4d_%s_%s",$3,$2,$1)}'`; prepfold -o {$outputLabel} -filterbank -topo -coarse -nsub 32 -n 64 -noxwin -dm $dm -p $period_sec $filfile;done
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=candidates.pdf *.ps
