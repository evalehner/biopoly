#!/bin/bash

### 2:
# SISSIz wird in richtiger Reihenfolge ausgeführt 
# Jedes Ergebnis wird in seperates file.out gespeichert
# ACHTUNG: Wird nur ausgeführt wenn jeweiliges File nicht vorhanden ist  
for file in `ls HCV/*/*.clu | sort -t _ -k 3 -g`
do
	if [ ! -e "${file%.clu}.out" ]; then

		SISSIz $file > ${file%.clu}.out
	fi
done

### 3 Zähen von zScore
# Ergebniss wurde manuell in table1.ods übertragen 
# ACHTUNG: wird jedesmal wenn Skript gestarted wird ausgeführt
for dir in HCV/*/ 
do
        var="${dir}*.out"
        count2=`less $var  | awk '$13 < -2.0 { count++ } END { print count }'`
        count4=`less $var  | awk '$13 < -4.0 { count++ } END { print count }'`
        windowNumber=`ls $var | grep -c '.out'`
	echo -e $dir '\t' 'Count2:' '\t' $count2 '\t' 'windowSize:' $windowNumber >> count.txt
        echo -e $dir '\t' 'Count2:' '\t' $count4 '\t' 'windowSize:' $windowNumber >> count.txt
done

# 5
# Extrahieren der jeweiligen zScores fürs plotten 
# ACHTUNG: wird jedesmal wenn Skript gestarted wird ausgeführt
for file in `ls HCV/*/*.out | sort -t _ -k 3 -g`
do
        zScore=`less $file | cut -f 13`

        folder=${file%hcv.clu_w_*.out}
        folder=${folder#HCV/w}

        windowLength=${folder%s*}

        overlap=${folder#*s}
        overlap=${overlap%/}

        index=${file#HCV/*/hcv.clu_w_}
        index=${index%.out}

        start=$( expr "$index" '*' "$overlap")
        stop=$( expr "$index" '*' "$overlap" + 100)

        category="${windowLength}_$overlap"

        echo -e $category '\t' $windowLength '\t' $overlap '\t' $index '\t' $start '\t' $zScore >> "${category}.txt"
	echo -e $category '\t' $windowLength '\t' $overlap '\t' $index '\t' $stop '\t' $zScore >> "${category}.txt"
done

# 6: 
# läuft nur wenn es kein outfile w300s150_shape.out gibt.
if [ ! -e "w300s150_shape.out" ]; then 
        for ((i=0; i<64 ;i++)); do
                SISSIz HCV/w300s150/hcv.clu_w_$((i)).clu --shapeMethod="D" --shape "HCV/w300s150/JFH1.txt_w_$((i)).txt","HCV/w300s150/Con1b.t$
        done
fi 


# 7 count z-scores of task 6 output
if [ ! -e "" ]; then
        rawOut="w300s150_shape.out"
        count2=`less $rawOut | awk '$13 < -2.0 { count++ } END { print count }'`
        count4=`less $rawOut | awk '$13 < -4.0 { count++ } END { print count }'`
        windowNumber=`ls $rawOut | grep -c '.out'`
        echo -e 'Count2:' '\t' $count2 '\t' 'windowSize:' $windowNumber >> w300s150_shape_count.txt
        echo -e 'Count2:' '\t' $count4 '\t' 'windowSize:' $windowNumber >> w300s150_shape_count.txt
done
