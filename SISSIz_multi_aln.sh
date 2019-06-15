#! /bin/bash
touch output_multi_SISSIz.tsv

for ((i=0; i<=3; i++)); do
  for filename in *.aln; do
    if (( $i==0 ))
    then
      SISSIz --mono "$filename" >> output_multi_SISSIz.tsv
    elif (( $i==1 ))
    then
      SISSIz --mono -j "$filename" >> output_multi_SISSIz.tsv
    elif (( $i==2 ))
    then
      SISSIz --di "$filename" >> output_multi_SISSIz.tsv
    elif (( $i==3 ))
    then
      SISSIz --di -j "$filename" >> output_multi_SISSIz.tsv
    fi
  done
done
