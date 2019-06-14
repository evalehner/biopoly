#!/bin/bash

if [ ! -e "w300s150_shape.out" ]; then 
        for ((i=0; i<128 ;i++)); do
                SISSIz HCV/w300s150/hcv.clu_w_$((i)).clu --shapeMethod="D" --shape "HCV/w300s150/JFH1.txt_w_$((i)).txt","HCV/w300s150/Con1b.txt_w_$((i)).txt","HCV/w300s150/h77.txt_w_$((i)).txt" $>> w300s150_shape.out
        done
fi 
