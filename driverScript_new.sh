#!/bin/bash

echo 'Script starts'
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
echo 'Task_2 done'

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
        echo -e $dir '\t' 'Count4:' '\t' $count4 '\t' 'windowSize:' $windowNumber >> count.txt
done
echo 'Task_3 done'

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
echo 'Task_5 done'

# 6:
# läuft nur wenn es kein outfile w300s150_shape.out gibt.
if [ ! -e "w300s150_shape.out" ]; then
for ((i=0; i<64 ;i++)); do
SISSIz HCV/w300s150/hcv.clu_w_$((i)).clu --shapeMethod="D" --shape "HCV/w300s150/JFH1.txt_w_$((i)).txt","HCV/w300s150/Con1b.txt_w_$((i)).txt","HCV/w300s150/h77.txt_w_$((i)).txt" $>> w300s150_shape.out
done
fi
echo 'Task_6 done'

# 7 count z-scores of task 6 output
if [ ! -e "w300s150_shape_count.txt" ]; then
    rawOut="w300s150_shape.out"
    count2=`less $rawOut | awk '$13 < -2.0 { count++ } END { print count }'`
    count4=`less $rawOut | awk '$13 < -4.0 { count++ } END { print count }'`
    windowNumber=`grep -c '.clu' $rawOut`
    echo -e 'Count2:' '\t' $count2 '\t' 'windowSize:' $windowNumber >> w300s150_shape_count.txt
    echo -e 'Count4:' '\t' $count4 '\t' 'windowSize:' $windowNumber >> w300s150_shape_count.txt
fi

echo 'Task_7 part1 done'

grep -v '^SHAPE' w300s150_shape.out > w300s150_shape_new.out
filename='w300s150_shape_new.out'
n=1
while read -r line name remain; do
    z_score=$(echo "$remain"| cut -f11)

    windowlength=$(echo "$remain" | cut -f2)

    index_new=$(echo "$name"| cut -d/ -f3 | cut -d. -f2 | cut -d_ -f3)

    overlap_new=$(echo "$name"| cut -d/ -f2 | cut -d"s" -f2)

    start_score=$( expr "$index_new" '*' "$overlap_new")
    stop_score=$( expr "$index_new" '*' "$overlap_new" + 100)

    echo -e "$windowlength" '\t' $overlap_new '\t' $index_new '\t' $start_score '\t' "$z_score" >> w300s150_shape_scores.txt
    echo -e "$windowlength" '\t' $overlap_new '\t' $index_new '\t' $stop_score '\t' "$z_score" >> w300s150_shape_scores.txt

n=$((n+1))
done < $filename

echo 'Finished script'
