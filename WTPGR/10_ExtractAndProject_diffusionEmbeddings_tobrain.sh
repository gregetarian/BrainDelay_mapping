#!/bin/bash

index=`seq 1 807`

wdir="/Users/gcooper/Desktop/Delay_attempt_9000/pca"
roi_dir="/Users/gcooper/nilearn_data/difumo_atlases/1024/3mm/rois_sep"

for diag in INPUTS; do
    for embedding in x y z a b; do
    mkdir -p $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/"$embedding"
    mkdir mkdir -p $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/means

    done

    for i in $index; do
        row=$((i+1))
        roi=`cat $wdir/xyza_coef_"$diag"_diffusion_final.csv | awk -F ',' '{print $6}' | awk 'NR=='$row''`
        echo $roi

        x_embed=`cat $wdir/xyza_coef_"$diag"_diffusion_final.csv | awk -F ',' '{print $1}' | awk 'NR=='$row''`
        y_embed=`cat $wdir/xyza_coef_"$diag"_diffusion_final.csv | awk -F ',' '{print $2}' | awk 'NR=='$row''`
        z_embed=`cat $wdir/xyza_coef_"$diag"_diffusion_final.csv | awk -F ',' '{print $3}' | awk 'NR=='$row''`
        a_embed=`cat $wdir/xyza_coef_"$diag"_diffusion_final.csv | awk -F ',' '{print $4}' | awk 'NR=='$row''`
        b_embed=`cat $wdir/xyza_coef_"$diag"_diffusion_final.csv | awk -F ',' '{print $5}' | awk 'NR=='$row''`

        echo $x_embed x embedding
        echo $y_embed y embedding
        echo $z_embed z embedding
        echo $a_embed a embedding
        echo $b_embed b embedding
        r="$roi"
        roi=$((roi-1))

        if [[ ! -e  $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/x/notnormed_PCAroi-"$r".nii.gz ]]; then
            3dcalc -prefix $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/x/notnormed_PCAroi-"$r".nii.gz -a $roi_dir/roi-"$roi".nii.gz -expr "$x_embed*(a/a)"
        fi
        if [[ ! -e  $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/y/notnormed_PCAroi-"$r".nii.gz ]]; then
            3dcalc -prefix $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/y/notnormed_PCAroi-"$r".nii.gz -a $roi_dir/roi-"$roi".nii.gz -expr "$y_embed*(a/a)"
        fi
        if [[ ! -e  $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/z/notnormed_PCAroi-"$r".nii.gz ]]; then
            3dcalc -prefix $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/z/notnormed_PCAroi-"$r".nii.gz -a $roi_dir/roi-"$roi".nii.gz -expr "$z_embed*(a/a)"
        fi
        if [[ ! -e  $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/a/notnormed_PCAroi-"$r".nii.gz ]]; then
            3dcalc -prefix $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/a/notnormed_PCAroi-"$r".nii.gz -a $roi_dir/roi-"$roi".nii.gz -expr "$a_embed*(a/a)"
        fi
        if [[ ! -e  $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/b/notnormed_PCAroi-"$r".nii.gz ]]; then
            3dcalc -prefix $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/b/notnormed_PCAroi-"$r".nii.gz -a $roi_dir/roi-"$roi".nii.gz -expr "$b_embed*(a/a)"
        fi
    done


    for embedding in x y z a b; do
        rm $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/means/PCA_"$embedding"_mean.nii.gz
        3dMean -prefix $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/means/PCA_"$embedding"_mean.nii.gz -non_zero $wdir/diffusion/COEFS_FINAL/"$diag"/dimensions/"$embedding"/notnormed_PCA*.nii.gz
    done
done





    
