#!/bin/bash/

echo "########################################################"
echo A story that starts with a Beet always ends with a Devil.
echo "########################################################"
sleep 1
echo "but that's a risk we're going to have to take..."

#set up directory
datadir="/Users/gcooper/Downloads/LSD_delay_sanity_check/processed/brains/delay/LMEs"
cd "$datadir"


LMEs=$(ls resid*LME.nii.gz | sed 's/.nii.gz//g' | sed 's/resid_//g')
echo $LMEs

# Get acf - once for each LME
for LME in $LMEs; do
        LME_resids=`echo resid_"$LME".nii.gz`
        echo clearing old clustsims
        rm clustsims/*
        echo cleared.
        acf=`3dFWHMx \
        -ACF NULL -automask \
        -input "$datadir"/"$LME_resids"`
        # Put acf in variables
        acf1=`echo $acf | awk '{print $18}'`
        acf2=`echo $acf | awk '{print $19}'`
        acf3=`echo $acf | awk '{print $20}'`
        echo $acf1 $acf2 $acf3

        # Cluster
        # Increase itnerations as we are going out to .0001
        # I think 10,000 is fine up to .001
        # -pthr 0.05 0.02 0.01 0.005 0.002 0.001 0.0005 0.0002 0.0001 \
        # -athr 0.05 0.02 0.01 0.005 0.002 0.001 0.0005 0.0002 0.0001 \
        # > .001 = 100001
        cd "$datadir"
        mkdir clustsims
        rm delay_LME_clustsim.*
        cd clustsims
        if [[ ! -e "$datadir"/clustsims/delay_LME_clustsim.NN2_2sided.1D ]]; then
                3dClustSim \
                -acf $acf1 $acf2 $acf3 \
                -nodec -both -iter 10001 \
                -pthr 0.05 0.02 0.01 0.005 0.002 0.001 \
                -athr 0.05 0.02 0.01 0.005 0.002 0.001 \
                -prefix delay_LME_clustsim \
                #-mask /data/movie/fmri/participants/adults/group_afni_proc/group_mask.inter.nii.gz \
        fi

        # Apply to results
        3drefit \
        -atrstring AFNI_CLUSTSIM_NN1_1sided file:delay_LME_clustsim.NN1_1sided.niml \
        -atrstring AFNI_CLUSTSIM_MASK file:delay_LME_clustsim.mask \
        -atrstring AFNI_CLUSTSIM_NN2_1sided file:delay_LME_clustsim.NN2_1sided.niml \
        -atrstring AFNI_CLUSTSIM_NN3_1sided file:delay_LME_clustsim.NN3_1sided.niml \
        -atrstring AFNI_CLUSTSIM_NN1_2sided file:delay_LME_clustsim.NN1_2sided.niml \
        -atrstring AFNI_CLUSTSIM_NN2_2sided file:delay_LME_clustsim.NN2_2sided.niml \
        -atrstring AFNI_CLUSTSIM_NN3_2sided file:delay_LME_clustsim.NN3_2sided.niml \
        -atrstring AFNI_CLUSTSIM_NN1_bisided file:delay_LME_clustsim.NN1_bisided.niml \
        -atrstring AFNI_CLUSTSIM_NN2_bisided file:delay_LME_clustsim.NN2_bisided.niml \
        -atrstring AFNI_CLUSTSIM_NN3_bisided file:delay_LME_clustsim.NN3_bisided.niml \
        "$datadir"/"$LME_resids"



        # NOTES
        # This does multi-thresholding over 9 individual voxel p-values and the corresponding cluster-size to reach a corrected threshold of alpha = .05s
        # Set thresholds to use
        pthresholds="05 02 01 005 002 001"
        # alpha = 001 = column 7
        # alpha = 01  = column 4
        athreshold_col="2"
        # Set directory
        cd "$datadir"
        # Make a dir to put intermediary files
        mkdir LME_thresh
        mkdir "$datadir"/LME_thresh/multithresh
        mkdir "$datadir"/LME_thresh/multithresh/seps
        mkdir "$datadir"/LME_thresh/multithresh/seps/masks
        mkdir "$datadir"/LME_thresh/multithresh/seps/extracted
        # Which files to get clustsim results from?
        cluster_table='"$datadir"/clustsims/delay_LME_clustsim.NN2_2sided.1D'

        #LME_files="LME_max_inny masked_LME_mean_outy masked_LME_nzcount_inny masked_LME_nzmean_inny masked_LME_nzmedian_inny masked_LME_stdev_inny masked_LME_stdev_outy"
        LME_files="$LME"


        bricks="4 6 8 10 12 14 16 18"
        # Loops through thresholds
        for pthreshold in $pthresholds; do
                if [ "$pthreshold" = "05" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 9 {print $var}'`
                        thresh=1.96
                        echo $cs
                fi
                if [ "$pthreshold" = "02" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 10 {print $var}'`
                        thresh=2.33
                        echo $cs
                fi
                if [ "$pthreshold" = "01" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 11 {print $var}'`
                        thresh=2.58
                        echo $cs
                fi
                if [ "$pthreshold" = "005" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 12 {print $var}'`
                        thresh=2.81
                        echo $cs
                fi
                if [ "$pthreshold" = "002" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 13 {print $var}'`
                        thresh=3.09
                        echo $cs
                fi
                if [ "$pthreshold" = "001" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 14 {print $var}'`
                        thresh=3.29
                        echo $cs
                fi
                if [ "$pthreshold" = "0005" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 15 {print $var}'`
                        thresh=3.48
                        echo $cs
                fi
                if [ "$pthreshold" = "0002" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 16 {print $var}'`
                        thresh=3.72
                        echo $cs
                fi
                if [ "$pthreshold" = "0001" ]
                then
                        cs=`cat $cluster_table | awk -v var="$athreshold_col" 'NR == 17 {print $var}'`
                        thresh=3.89
                        echo $cs
                fi


                for LME_file in $LME_files
                do
                        for brick in $bricks; do
                                #brick=$((brick+1)) to get z-score
                                b=$((brick+1))

                                # Positive activity
                                if [ ! -e "$datadir"/LME_thresh/"$LME_file"_cs"$cs"_t"$thresh"_pos_"$brick".nii.gz ]; then
                                        3dmerge \
                                        -dxyz=1 -1clust 1 "$cs" -2clip -100000000 "$thresh" \
                                        -prefix "$datadir"/LME_thresh/"$LME_file"_cs"$cs"_t"$thresh"_pos_"$brick".nii.gz \
                                        "$datadir"/"$LME_file".nii.gz["$b"]
                                fi
                                # Negative activity

                                if [ ! -e  "$datadir"/LME_thresh/"$LME_file"_cs"$cs"_t"$thresh"_neg_"$brick".nii.gz ]; then
                                        3dmerge \
                                        -dxyz=1 -1clust 1 "$cs" -2clip -"$thresh" 100000000 \
                                        -prefix "$datadir"/LME_thresh/"$LME_file"_cs"$cs"_t"$thresh"_neg_"$brick".nii.gz \
                                        "$datadir"/"$LME_file".nii.gz["$b"]
                                fi

                        done
                done
        done


        signs="pos neg"
       


        for LME_file in $LME_files; do
            for brick in $bricks; do
                for sign in $signs; do

                    if [ "$brick" = "4" ];  then
                        subbrick="LSDrest1n3"
                    fi
                    if [ "$brick" = "6" ];  then
                        subbrick="LSDmusic"
                    fi
                    if [ "$brick" = "8" ];  then
                        subbrick="PCBrest1n3"
                    fi
                    if [ "$brick" = "10" ];  then
                        subbrick="PCBmusic"
                    fi
                    if [ "$brick" = "12" ];  then
                        subbrick="PCBvsLSDrest1n3"
                    fi
                    if [ "$brick" = "14" ];  then
                        subbrick="PCBvsLSDmusic"
                    fi
                    if [ "$brick" = "16" ];  then
                        subbrick="PCBmusicvsrest"
                    fi
                    if [ "$brick" = "18" ];  then
                        subbrick="LSDmusicvsrest"
                    fi


                    #     if [ "$brick" = "6" ];  then
                    #             subbrick="all"
                    #     fi
                    #     if [ "$brick" = "8" ];  then
                    #             subbrick="BvM"
                    #     fi
                    #     if [ "$brick" = "10" ];  then
                    #             subbrick="BvE"
                    #     fi
                    #     if [ "$brick" = "12" ];  then
                    #             subbrick="MvE"
                    #     fi
                    #     if [ "$brick" = "14" ];  then
                    #             subbrick="Beg"
                    #     fi
                    #     if [ "$brick" = "16" ];  then
                    #             subbrick="Mid"
                    #     fi                                        
                    #     if [ "$brick" = "18" ];  then
                    #             subbrick="End"
                    #     fi


                        rm "$datadir"/LME_thresh/"$sign"_"$subbrick"_"$LME_file"_cs_all_thresh_all.nii.gz
                        echo "#######################################################" "$LME_file"_cs_all_thresh_all_"$sign"_"$brick".nii.gz >> "$datadir"/LME_thresh/"$LME_file"_cs_all_thresh_all_"$brick".txt
                        3dmerge -nozero \
                        -gnzmean \
                        -prefix "$datadir"/LME_thresh/"$subbrick"_"$sign"_"$LME_file"_cs_all_thresh_all.nii.gz \
                        "$datadir"/LME_thresh/"$LME_file"_cs*_t?.??_"$sign"_"$brick".nii.gz  2>> "$datadir"/LME_thresh/"$LME_file"_cs_all_thresh_all_"$brick".txt
                done


                if [[ -e "$datadir"/LME_thresh/"$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz  ]]; then 
                    echo "$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz EXISTS
                fi
                if [[ -e "$datadir"/LME_thresh/"$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz  ]]; then 
                    echo "$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz EXISTS
                fi

                if [[ -e "$datadir"/LME_thresh/"$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz  ]] && [[ -e "$datadir"/LME_thresh/"$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz ]];  then
                    echo combining pos and neg for "$subbrick"_"$LME_file"

                    3dcalc -prefix "$datadir"/LME_thresh/"$subbrick"_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -a "$datadir"/LME_thresh/"$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -b "$datadir"/LME_thresh/"$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -expr 'a+b'
                fi

                if [ -e "$datadir"/LME_thresh/"$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz  ] && [[ ! -e "$datadir"/LME_thresh/"$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz ]];  then
                    echo only pos available for "$subbrick"_"$LME_file"

                    3dcalc -prefix "$datadir"/LME_thresh/"$subbrick"_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -a "$datadir"/LME_thresh/"$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -expr 'a'

                fi
                if [ ! -e "$datadir"/LME_thresh/"$subbrick"_pos_"$LME_file"_cs_all_thresh_all.nii.gz  ] && [[ -e "$datadir"/LME_thresh/"$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz ]];  then
                    echo only neg available for "$subbrick"_"$LME_file"
                    3dcalc -prefix "$datadir"/LME_thresh/"$subbrick"_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -a "$datadir"/LME_thresh/"$subbrick"_neg_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -expr 'a'
                fi


                #make mask of significant blobs calculated from z-scored
                if [[ -e "$datadir"/LME_thresh/"$subbrick"_"$LME_file"_cs_all_thresh_all.nii.gz ]]; then 
                    3dcalc -prefix "$datadir"/LME_thresh/multithresh/seps/masks/"$subbrick"_"$LME_file"_cs_all_thresh_all_mask.nii.gz \
                    -a "$datadir"/LME_thresh/"$subbrick"_"$LME_file"_cs_all_thresh_all.nii.gz \
                    -expr 'a/a'
                fi                

                
                if [[ -e "$datadir"/LME_thresh/multithresh/seps/masks/"$subbrick"_"$LME_file"_cs_all_thresh_all_mask.nii.gz ]]; then 
                    3dcalc -prefix "$datadir"/LME_thresh/multithresh/seps/extracted/"$subbrick"_"$LME_file"_cs_all_thresh_all_extracted.nii.gz \
                    -a "$datadir"/"$LME_file".nii.gz["$brick"]\
                    -b "$datadir"/LME_thresh/multithresh/seps/masks/"$subbrick"_"$LME_file"_cs_all_thresh_all_mask.nii.gz \
                    -expr 'a*b'
                fi

            done


            cp "$datadir"/LME_thresh/*_"$LME_file"_cs_all_thresh_all.nii.gz "$datadir"/LME_thresh/multithresh/seps

            3dTcat -relabel \
            -prefix "$datadir"/LME_thresh/multithresh/"$LME_file"_multithresh.nii.gz \
            "$datadir"/LME_thresh/*_"$LME_file"_cs_all_thresh_all.nii.gz

        done
        rm "$datadir"/LME_thresh/*.nii.gz
        rm "$datadir"/LME_thresh/multithresh/seps/*.nii.gz

done
