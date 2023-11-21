#!/bin/bash


workingdir="outputting_regions"

cd $workingdir

#calculate number of clusters text files in directory where clusters are named as d.apclus.csv
numclusters=$(ls -1 $workingdir/apc*_orig.txt | wc -l)
echo $numclusters


#just for aggregating outputting ROIs
for cluster in `seq 1 $numclusters`; do
    cd $workingdir
    ##Now do output maps
    #get the number of rois in each cluster
    Orois=`cat apc"$cluster".txt | tr '\n' ' ' | sed 's/roi-//g'`
    
    #subtract 1 from each number returned to make list appropriate for calling 3dTcat 
    Orois=$(echo "$Orois" | awk '{for (i=1; i<=NF; i++) $i=$i-1} 1')
    echo "$Orois"

    #remove spaces insert commas in place
    Orois=`echo $Orois | sed 's/ /,/g'`
    #remove final comma from $rois
    Orois=`echo $Orois | sed 's/ /,/g' | sed 's/,$//g'`
    #minus one from each number in rois
    rm $workingdir/outputting_regions_cluster-"$cluster".nii.gz
    #make cluster-wise output maps
    3dTcat -prefix $workingdir/outputting_regions_cluster-"$cluster"_tcat.nii.gz /Users/gcooper/nilearn_data/difumo_atlases/1024/3mm/resamp_maps.nii.gz["$Orois"]
    3dTstat -prefix $workingdir/outputting_regions_cluster-"$cluster"_avg.nii.gz -nzmean  $workingdir/outputting_regions_cluster-"$cluster"_tcat.nii.gz #step 1 to combine all outputting region masks into one
    3dcalc -prefix $workingdir/outputting_regions_cluster-"$cluster".nii.gz  -a $workingdir/outputting_regions_cluster-"$cluster"_avg.nii.gz -expr 'step(a)' #step 2 to combine all outputting region masks into one
    rm $workingdir/outputting_regions_cluster-"$cluster"_avg.nii.gz
    rm  $workingdir/outputting_regions_cluster-"$cluster"_tcat.nii.gz

    #make cluster-wise input maps 
    3dTcat -prefix $workingdir/inputmaps_cluster-"$cluster"_tcat.nii.gz /data/gcooper/movie_delay/delay_mapping/grp_avg/tcat/tcat_all.nii.gz[$0rois]
    3dTstat -prefix $workingdir/inputmaps_cluster-"$cluster".nii.gz -nzmean  $workingdir/inputmaps_cluster-"$cluster"_tcat.nii.gz
    rm $workingdir/inputmaps_cluster-"$cluster"_tcat.nii.gz

    #resulting volumes are then visualised using brainnetviewer. Outputting ROIS are superimposed over average input maps using GIMP image processing software.
done



