\#!/bin/bash

##############################################################################
# Whole-Brain Delay Mapping pipeline #
##############################################################################
# To accompany the paper:
# Where the present gets remembered: primary sensory regions 
# draw on prior cortical information over the longest timescales 
# Greg Cooper1,2*, George Blackburne1*,  Ravi Das2, Jeremy Skipper1
# 1Experimental Psychology, University College London, UK
# 2Clinical Psychopharmacology Unit, University College London, UK
#############################################################################


#############################################################################

# Set up AFNI
export PATH=$PATH:/tools/afni
# Get MNI template
basedset="MNI152_2009_template_SSW.nii.gz"
basepath=`@FindAfniDsetPath $basedset`
basedset=$basepath/$basedset

# set up directories
pwd
scripts_dir=`pwd`
cd ..
dir=`pwd`
cd /data/gcooper/movie_delay
out_dir=`pwd`


data_dir="/data/ds002837/derivatives"


# load in the perpetrators of these darstadly functional images!
perps=`seq 1 86`
# DiFumo parcellation
list=(`echo {1..1024}`)
rois=`seq 1 1024`

# Good ROIs to be used as referense timeseries n=807
goodROIs="1 5 6 7 8 9 10 11 13 14 15 16 17 18 20 21 23 24 25 26 30 31 32 33 34 36 37 38 39 40 41 45 46 48 50 52 53 54 55 56 58 60 61 62 63 65 66 67 68 69 70 71 73 75 76 77 78 80 82 83 86 90 91 92 94 95 96 97 100 101 102 103 104 105 106 110 111 112 113 114 116 117 118 121 122 123 124 126 127 128 129 130 131 132 133 134 135 136 137 140 141 142 144 147 148 149 150 152 153 154 155 156 157 158 159 161 162 163 165 166 169 171 172 173 175 176 177 178 179 181 183 184 185 186 188 189 191 192 195 197 199 201 202 204 205 206 209 211 212 213 214 215 218 219 221 222 223 224 225 226 229 230 231 233 234 235 237 238 239 240 242 243 244 245 246 247 249 250 251 253 254 255 256 257 259 260 262 263 264 265 266 267 268 271 273 274 277 279 280 281 284 285 286 287 288 289 292 293 294 295 296 297 298 299 301 303 304 305 306 307 308 309 311 314 315 316 317 318 322 323 325 326 327 328 329 330 331 332 333 334 335 336 337 338 342 343 344 346 348 349 350 351 353 354 355 356 357 360 361 362 363 365 366 367 368 369 370 372 373 374 377 379 380 381 383 386 387 388 389 390 391 393 394 395 396 397 398 400 401 402 405 407 408 412 413 414 415 416 418 419 421 422 423 424 425 426 427 428 429 430 431 432 433 434 436 437 439 441 443 444 445 446 447 448 449 451 452 457 458 460 461 463 466 467 468 470 471 472 473 474 475 477 480 481 482 483 484 485 486 487 488 490 492 493 494 495 496 497 499 500 503 504 505 506 507 508 509 510 512 513 514 515 517 520 521 522 523 524 525 526 527 528 529 530 532 533 535 539 541 542 543 544 545 548 549 550 551 553 555 556 557 558 559 561 566 567 568 571 572 573 575 576 578 581 583 584 585 588 589 590 591 592 594 596 597 598 600 602 603 604 605 606 607 608 609 611 612 614 615 616 618 620 621 623 626 629 631 632 633 634 636 638 642 644 645 646 648 650 651 652 653 654 655 656 657 660 662 663 665 666 667 668 670 671 673 674 675 676 677 678 679 680 681 682 683 686 689 691 692 693 694 695 696 697 698 699 700 701 703 704 707 708 709 710 711 713 715 716 717 718 719 720 721 722 723 724 725 726 727 728 730 731 734 735 736 737 738 741 742 743 745 746 748 749 750 751 752 753 754 755 756 757 758 759 761 762 763 764 765 766 767 768 769 771 773 774 775 776 777 778 779 780 781 783 786 787 788 789 790 792 793 795 796 797 798 799 801 802 803 804 806 809 810 811 813 814 817 818 820 821 822 823 824 826 827 828 830 831 832 833 834 837 838 839 840 841 842 843 844 845 846 847 848 849 850 851 852 854 855 856 858 859 860 863 864 865 866 867 868 869 870 874 875 877 878 879 880 882 883 884 885 887 888 890 892 894 895 896 898 899 902 903 904 905 906 907 909 913 914 915 916 918 919 921 923 924 925 927 928 929 932 934 936 937 938 939 940 941 943 944 945 946 947 951 952 954 955 956 960 962 963 965 966 968 970 971 972 973 974 975 976 977 978 979 980 981 983 984 986 988 989 990 991 992 994 995 997 998 1000 1002 1004 1006 1007 1010 1011 1013 1015 1016 1018 1019 1020 1022 1023 42 49 64 84 85 98 120 164 170 174 216 217 252 261 283 290 291 300 302 319 347 352 358 385 409 411 417 420 435 442 453 456 464 476 502 531 552 564 625 635 639 641 647 649 672 714 732 784 815 825 836 857 873 881 889 891 893 897 901 910 912 920 930 931 933 959 982 985 987 993 996 999 1001 1003"
# junk ROIs not to be used as reference timeseries n=217
unusedROIS="1024 2 3 4 516 518 519 12 19 22 534 536 537 538 27 28 29 540 546 35 547 554 43 44 47 560 562 51 563 565 57 569 59 570 574 577 579 580 582 72 74 586 587 79 81 593 595 87 88 89 599 601 93 610 99 613 617 107 108 109 619 622 624 115 627 628 630 119 125 637 640 643 138 139 143 145 146 658 659 661 151 664 669 160 167 168 684 685 687 688 690 180 182 187 190 702 193 194 705 196 706 198 200 712 203 207 208 210 729 220 733 227 228 739 740 232 744 747 236 241 248 760 258 770 772 269 270 782 272 785 275 276 278 791 282 794 800 805 807 808 812 816 819 310 312 313 829 320 321 835 324 339 340 341 853 345 861 862 359 871 872 364 876 371 886 375 376 378 382 384 900 392 908 399 911 403 404 917 406 410 922 926 935 942 948 949 438 950 440 953 957 958 961 450 964 454 455 967 969 459 462 465 469 478 479 489 491 1005 1008 1009 498 1012 501 1014 1017 1021 511"
#statistics to be calculated across respective voxels for ROI-wise delay maps
stats="nzmean nzmedian stdev nzcount max"
stats=""
# version for 3dBrickStat, which has nonzero as a seperate flag
Ostats="mean median max stdev"
Ostats="median"
Ostats="95 99 max"
Ostats="max"
#steps="s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11"


steps="s7 s8 s9 s10 s11"
#steps="s11"

steps="s10b s11"

#steps="s1 s2 s3"
# Lets roll!
for step in $steps; do
	for perp in $perps; do
		#############################
		# Set subject variables
		#############################
		if [[ $perp = 1 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 2 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 3 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 4 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 5 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 6 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 7 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 8 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 9 ]];  then movie="500daysofsummer"; fi
		if [[ $perp = 10 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 11 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 12 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 13 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 14 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 15 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 16 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 17 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 18 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 19 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 20 ]]; then movie="500daysofsummer"; fi
		if [[ $perp = 21 ]]; then movie="citizenfour"; fi
		if [[ $perp = 22 ]]; then movie="citizenfour"; fi
		if [[ $perp = 23 ]]; then movie="citizenfour"; fi
		if [[ $perp = 24 ]]; then movie="citizenfour"; fi
		if [[ $perp = 25 ]]; then movie="citizenfour"; fi
		if [[ $perp = 26 ]]; then movie="citizenfour"; fi
		if [[ $perp = 27 ]]; then movie="citizenfour"; fi
		if [[ $perp = 28 ]]; then movie="citizenfour"; fi
		if [[ $perp = 29 ]]; then movie="citizenfour"; fi
		if [[ $perp = 30 ]]; then movie="citizenfour"; fi
		if [[ $perp = 31 ]]; then movie="citizenfour"; fi
		if [[ $perp = 32 ]]; then movie="citizenfour"; fi
		if [[ $perp = 33 ]]; then movie="citizenfour"; fi
		if [[ $perp = 34 ]]; then movie="citizenfour"; fi
		if [[ $perp = 35 ]]; then movie="citizenfour"; fi
		if [[ $perp = 36 ]]; then movie="citizenfour"; fi
		if [[ $perp = 37 ]]; then movie="citizenfour"; fi
		if [[ $perp = 38 ]]; then movie="citizenfour"; fi
		if [[ $perp = 39 ]]; then movie="theusualsuspects"; fi
		if [[ $perp = 40 ]]; then movie="theusualsuspects"; fi
		if [[ $perp = 41 ]]; then movie="theusualsuspects"; fi
		if [[ $perp = 42 ]]; then movie="theusualsuspects"; fi
		if [[ $perp = 43 ]]; then movie="theusualsuspects"; fi
		if [[ $perp = 44 ]]; then movie="theusualsuspects"; fi
		if [[ $perp = 45 ]]; then movie="pulpfiction"; fi
		if [[ $perp = 46 ]]; then movie="pulpfiction"; fi
		if [[ $perp = 47 ]]; then movie="pulpfiction"; fi
		if [[ $perp = 48 ]]; then movie="pulpfiction"; fi
		if [[ $perp = 49 ]]; then movie="pulpfiction"; fi
		if [[ $perp = 50 ]]; then movie="pulpfiction"; fi
		if [[ $perp = 51 ]]; then movie="theshawshankredemption"; fi
		if [[ $perp = 52 ]]; then movie="theshawshankredemption"; fi
		if [[ $perp = 53 ]]; then movie="theshawshankredemption"; fi
		if [[ $perp = 54 ]]; then movie="theshawshankredemption"; fi
		if [[ $perp = 55 ]]; then movie="theshawshankredemption"; fi
		if [[ $perp = 56 ]]; then movie="theshawshankredemption"; fi
		if [[ $perp = 57 ]]; then movie="theprestige"; fi
		if [[ $perp = 58 ]]; then movie="theprestige"; fi
		if [[ $perp = 59 ]]; then movie="theprestige"; fi
		if [[ $perp = 60 ]]; then movie="theprestige"; fi
		if [[ $perp = 61 ]]; then movie="theprestige"; fi
		if [[ $perp = 62 ]]; then movie="theprestige"; fi
		if [[ $perp = 63 ]]; then movie="backtothefuture"; fi
		if [[ $perp = 64 ]]; then movie="backtothefuture"; fi
		if [[ $perp = 65 ]]; then movie="backtothefuture"; fi
		if [[ $perp = 66 ]]; then movie="backtothefuture"; fi
		if [[ $perp = 67 ]]; then movie="backtothefuture"; fi
		if [[ $perp = 68 ]]; then movie="backtothefuture"; fi
		if [[ $perp = 69 ]]; then movie="split"; fi
		if [[ $perp = 70 ]]; then movie="split"; fi
		if [[ $perp = 71 ]]; then movie="split"; fi
		if [[ $perp = 72 ]]; then movie="split"; fi
		if [[ $perp = 73 ]]; then movie="split"; fi
		if [[ $perp = 74 ]]; then movie="split"; fi
		if [[ $perp = 75 ]]; then movie="littlemisssunshine"; fi
		if [[ $perp = 76 ]]; then movie="littlemisssunshine"; fi
		if [[ $perp = 77 ]]; then movie="littlemisssunshine"; fi
		if [[ $perp = 78 ]]; then movie="littlemisssunshine"; fi
		if [[ $perp = 79 ]]; then movie="littlemisssunshine"; fi
		if [[ $perp = 80 ]]; then movie="littlemisssunshine"; fi
		if [[ $perp = 81 ]]; then movie="12yearsaslave"; fi
		if [[ $perp = 82 ]]; then movie="12yearsaslave"; fi
		if [[ $perp = 83 ]]; then movie="12yearsaslave"; fi
		if [[ $perp = 84 ]]; then movie="12yearsaslave"; fi
		if [[ $perp = 85 ]]; then movie="12yearsaslave"; fi
		if [[ $perp = 86 ]]; then movie="12yearsaslave"; fi
		#############################
		# Set movie variables
		#############################
		if [ $movie == '12yearsaslave' ];          then b1="47";  b2="1247"; m1="3117"; m2="4317"; e1="6187"; e2="7387"; fi
		if [ $movie == '500daysofsummer' ];        then b1="36";  b2="1236"; m1="2020"; m2="3220"; e1="4004"; e2="5204"; fi
		if [ $movie == 'backtothefuture' ];        then b1="28";  b2="1228"; m1="2631"; m2="3831"; e1="5233"; e2="6433"; fi
		if [ $movie == 'citizenfour' ];            then b1="9";   b2="1209"; m1="2712"; m2="3912"; e1="5414"; e2="6414"; fi
		if [ $movie == 'littlemisssunshine' ];     then b1="28";  b2="1228"; m1="2212"; m2="3412"; e1="4396"; e2="5596"; fi
		if [ $movie == 'split' ];                  then b1="45";  b2="1245"; m1="2663"; m2="3863"; e1="5280"; e2="6480"; fi
		if [ $movie == 'theprestige' ];            then b1="55";  b2="1255"; m1="3030"; m2="4230"; e1="6004"; e2="7204"; fi
		if [ $movie == 'theshawshankredemption' ]; then b1="42";  b2="1242"; m1="3393"; m2="4593"; e1="6744"; e2="7944"; fi
		if [ $movie == 'theusualsuspects' ];       then b1="130"; b2="1330"; m1="2417"; m2="3617"; e1="4704"; e2="5904"; fi
		if [ $movie == 'pulpfiction' ];            then b1="12";  b2="1212"; m1="3716"; m2="4916"; e1="7420"; e2="8620"; fi



#		echo sub-"$perp" echo "$movie"
	        if [[ $step = s1 ]]; then
			##########################################
	  		# appropriately truncate movie timeseries
	  		##########################################
	  		mkdir -p "$out_dir"/delay_mapping/sub-"$perp"
			for movie_part in beginning middle end; do
				if (( i % 10 == 0 )); then
								wait
						fi
				((i++))
				mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"
			done
			for orig_ts_type in bold_blur_no_censor_ica bold_no_blur_no_censor_ica; do
				if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/ts/beginning/sub-"$perp"_task-"$movie"_"$orig_ts_type"_beginning.nii.gz ]]; then
					echo $b1 $b2
					3dTcat \
				    	-prefix "$out_dir"/delay_mapping/sub-"$perp"/ts/beginning/sub-"$perp"_task-"$movie"_"$orig_ts_type"_beginning.nii.gz \
				    	"$data_dir"/sub-"$perp"/func/sub-"$perp"_task-"$movie"_"$orig_ts_type".nii.gz["$b1".."$((b2-1))"] & 
			  	fi

			  	if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/ts/middle/sub-"$perp"_task-"$movie"_"$orig_ts_type"_middle.nii.gz ]]; then
				  	echo $m1 $m2
				  	3dTcat \
					-prefix "$out_dir"/delay_mapping/sub-"$perp"/ts/middle/sub-"$perp"_task-"$movie"_"$orig_ts_type"_middle.nii.gz \
					"$data_dir"/sub-"$perp"/func/sub-"$perp"_task-"$movie"_"$orig_ts_type".nii.gz["$m1".."$((m2-1))"] &
				fi
				if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/ts/end/sub-"$perp"_task-"$movie"_"$orig_ts_type"_end.nii.gz ]]; then
				  	echo $e1 $e2
				  	3dTcat \
					-prefix "$out_dir"/delay_mapping/sub-"$perp"/ts/end/sub-"$perp"_task-"$movie"_"$orig_ts_type"_end.nii.gz \
					"$data_dir"/sub-"$perp"/func/sub-"$perp"_task-"$movie"_"$orig_ts_type".nii.gz["$e1".."$((e2-1))"]
				fi
			done
		# end of step 1
		fi

		for movie_part in beginning middle end; do
			if [[ $step = s2 ]]; then
				orig_ts_type="bold_blur_no_censor_ica"
				# make delay mapping directories
				if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/all/parcellation_difumo_ts.1D ]]; then
					orig_ts_type="bold_no_blur_no_censor_ica"
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/pos
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/neg
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/all
					if [[ -e "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"/sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz ]]; then
						echo found sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz
						mkdir "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"
						mkdir "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/pos
						mkdir "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/neg
						mkdir "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/all
						cd "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"
								# Run DiFumo ROI reference time series extraction


						cd "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"
						echo working on parcellation "for" "$perp" "$movie_part"
						python3 "$scripts_dir"/make_difumo_rois.py "$perp" "$movie_part" sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz "$out_dir"
						echo parcellation finished "for" "$perp" "$movie_part"
						#remove first row of "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/"$corr"/roi-"$roi".1D
						if [[ -e "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/all/parcellation_difumo_ts.1D ]]; then
							for roi in `seq 1 1024`; do
								for corr in pos neg; do
								#if length of "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/"$corr"/roi-"$roi".1D is 1201 then remove first row
									if [[ `cat "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/"$corr"/roi-"$roi".1D | wc -l` = 1201 ]]; then
										sed -i '1d' "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/"$corr"/roi-"$roi".1D
										length=`cat "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/"$corr"/roi-"$roi".1D | wc -l`
										echo roi "$roi" is now "$length" TRs long. Nice one.
									fi
								done
							done

						fi
					fi
				fi
			echo step 2 completed, meaning that you have all the difumo roi extractions finished "for" sub-"$perp"
			# end of step 2
			fi

				if [[ $step = s3 ]]; then
				# make masks
				mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/autoroimasks
				mkdir -p "$out_dir"/difumo_atlases/1024/3mm/
				# make difumo into MNI and resample orientation/grid
				if [[ ! -e "$out_dir"/difumo_atlases/1024/3mm/resamp_maps_mni.nii.gz ]]; then
					3dWarp -tta2mni -prefix "$out_dir"/difumo_atlases/1024/3mm/maps_mni.nii.gz \
					~/nilearn_data/difumo_atlases/1024/3mm/maps.nii.gz

					3dresample -prefix "$out_dir"/difumo_atlases/1024/3mm/resamp_maps_mni.nii.gz \
					-master "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"/sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz \
					-input "$out_dir"/difumo_atlases/1024/3mm/maps_mni.nii.gz
				fi

				# make MNI template into mask and resample orientation/grid
				if [[ ! -e "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz ]]; then
					3dAutomask -NN2 -clfrac 0.5 -prefix "$out_dir"/delay_mapping/MNI152_2009_mask.nii.gz "$basedset"
					3dresample -prefix "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz \
					-master "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"/sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz \
					-input "$out_dir"/delay_mapping/MNI152_2009_mask.nii.gz
				fi

				### make auto-correlation masks;
				# using a generic whole-brain mask, minus regions used to generate 3ddelay maps.
				for roi in $rois; do
					if (( i % 20 == 0 )); then
							wait
					fi
					((i++))

					r="$(($roi-1))"
					#echo "$r"
					if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/autoroimasks/roi-"$roi"_mask.nii.gz ]]; then
						3dcalc -prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/autoroimasks/roi-"$roi"_mask.nii.gz \
						-a "$out_dir"/difumo_atlases/1024/3mm/resamp_maps_mni.nii.gz[$r] \
						-b "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz \
						-expr 'step(b)-step(a)' &
					fi
				done
			echo step 3 completed, meaning that you have all the masks setup  "for" sub-"$perp" "$movie"
			# end of step 3
			fi
			orig_ts_type="bold_blur_no_censor_ica"
			# start positive and negative correlation loop
			#for corr in pos neg; do
			for corr in pos; do
				if [[ $step = s5 ]]; then
					# 3ddelay step!!

					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"
					for roi in $rois; do

						if (( i % 8 == 0 )); then
								wait
						fi
						((i++))

						##### ROI-wise delay calculated here! ; calculates positive and negative cross-correlation
						if [[ -e "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"/sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz ]]; then
							if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/roi-"$roi".nii.gz ]]; then
								echo working on delay "for" sub-"$perp" "$movie_part"  "$movie" roi-"$roi"
								3ddelay -fs 1 -T 0 -uS -nodtrnd -nodsamp \
								-mask "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/autoroimasks/roi-"$roi"_mask.nii.gz \
								-input "$out_dir"/delay_mapping/sub-"$perp"/ts/"$movie_part"/sub-"$perp"_task-"$movie"_"$orig_ts_type"_"$movie_part".nii.gz \
								-ideal_file "$out_dir"/delay_mapping/sub-"$perp"/difumo_rois/"$movie_part"/"$corr"/roi-"$roi".1D \
								-prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/roi-"$roi".nii.gz &
							fi
						fi
					done
				# end of step 5
				fi

				if [[ $step = s6 ]]; then
					# threshold input maps
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny
					for roi in $rois; do

						if (( i % 32 == 0 )); then
								wait
						fi
						((i++))

						### Threshold at 0.1
						if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$roi"_thresholded.nii.gz ]]; then
							if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/unused/roi-"$roi"_thresholded.nii.gz ]]; then
								3dmerge -1dindex 0 -1tindex 2 -1thresh .1 -dxyz=1 -1clust 1 20 \
								-prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$roi"_thresholded.nii.gz \
								"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/roi-"$roi".nii.gz &
							fi
						fi
					done

				# end of step 6
				fi

				if [[ $step = s7 ]]; then
				  # make whole-brain output maps for each ROI

				  mkdir "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy
				  mkdir "$out_dir"/difumo_atlases/1024/3mm/binarised_rois

				  for roi in $rois; do
					if (( i % 20 == 0 )); then
						wait
					fi
					((i++))
					r="$(($roi-1))"

					if [[ ! -e "$out_dir"/difumo_atlases/1024/3mm/binarised_rois/roi_"$roi".nii.gz ]]; then
					# make binarised difumo roi niftis
						3dcalc -prefix "$out_dir"/difumo_atlases/1024/3mm/binarised_rois/roi_"$roi".nii.gz \
						-a "$out_dir"/difumo_atlases/1024/3mm/resamp_maps_mni.nii.gz["$r"] \
						-expr "a/a" &
				    	fi
				  done
				  for roi in $goodROIs; do
					if (( i % 40 == 0 )); then
                    			wait
                    			fi
                    			((i++))
		                        r="$(($roi-1))"
						for stat in $Ostats; do
#							if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-"$roi"_thresholded.nii.gz ]]; then
#							if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/unused/roi-"$roi"_thresholded.nii.gz ]]; then
							rm "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-"$roi"_thresholded.nii.gz
								mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"
								#### calculate delay stats of whole-brain outputs for a ROI
								# note: for median it spits out a 50 first and then the value
								if [[ $stat = median ]]; then
									D_out=`3dBrickStat -non-zero -"$stat" "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$roi"_thresholded.nii.gz -mask "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz | awk '{print $2}'`
								elif [[ $stat = 95 ]]; then
                                                                        D_out=`3dBrickStat -non-zero -percentile "$stat" 1 "$stat" "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$roi"_thresholded.nii.gz -mask "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz | awk '{print $2}'`
								elif [[ $stat = 99 ]]; then
                                                                        D_out=`3dBrickStat -non-zero -percentile "$stat" 1 "$stat" "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$roi"_thresholded.nii.gz -mask "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz | awk '{print $2}'`
								else
									D_out=`3dBrickStat -positive -"$stat" "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$roi"_thresholded.nii.gz -mask "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz`
								fi
								
								echo "$D_out"
					    	### make voxels inside ROI the previously computed value
								3dcalc -prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-"$roi"_thresholded.nii.gz \
						    		-a "$out_dir"/difumo_atlases/1024/3mm/binarised_rois/roi_"$roi".nii.gz \
						    		-expr "a*($D_out)" &
#							fi
#							fi
						done
				  done
				# end of step 7
				fi

				if [[ $step = s8 ]]; then
					# Aggregating ROIs

					# Set up directories
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/concat
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/unused
					for stat in $Ostats; do
						mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/concat
						mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/unused
					done

					# Get rid of junk rois
					for unusedROI in $unusedROIS; do
						# inny


						if [[ $perp = 1 ]]; then
							if [[ -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/unused/roi-"$unusedROI"_thresholded.nii.gz ]]; then
								if [[  -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$unusedROI"_thresholded.nii.gz ]]; then
									rm "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/unused/roi-"$unusedROI"_thresholded.nii.gz
								fi
							fi
						fi

						if [[ -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$unusedROI"_thresholded.nii.gz ]]; then
						if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/unused/roi-"$unusedROI"_thresholded.nii.gz ]]; then
						mv "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-"$unusedROI"_thresholded.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/unused/
						fi
						fi



						# outy for each stat
						for stat in $Ostats; do
						if [[ -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-"$unusedROI"_thresholded.nii.gz ]]; then
						if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/unused/roi-"$unusedROI"_thresholded.nii.gz ]]; then
							mv "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-"$unusedROI"_thresholded.nii.gz \
							"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/unused/
						fi
						fi
						done
					done
				#end of step 8
				fi


				if [[ $step = s9 ]]; then
					if (( i % 10 == 0 )); then
        			            	wait
                   			fi
			                ((i++))
					# Concatenate inny ROIs in ascending order
					if [[ ! -e "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/concat/tcat_ordered.nii.gz ]]; then
						mkdir "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/concat/
						3dTcat -prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/concat/tcat_ordered.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-?_thresholded.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-??_thresholded.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-???_thresholded.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/roi-????_thresholded.nii.gz &
					fi
				#end of step 9
				fi

				if [[ $step = s10 ]]; then
					# Concatenate outy ROIs in ascending order for each stat
					for stat in $Ostats; do
						if (( i % 10 == 0 )); then
                    					wait
                    				fi
			                    	((i++))
							rm "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/concat/tcat_ordered.nii.gz
							3dTcat -prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/concat/tcat_ordered.nii.gz \
							"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-?_thresholded.nii.gz \
							"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-??_thresholded.nii.gz \
							"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-???_thresholded.nii.gz \
							"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/roi-????_thresholded.nii.gz


					done
				fi
				# end of step 10


				if [[ $step == s10b ]]; then
					for stat in $Ostats; do
                                                if (( i % 5 == 0 )); then
                                                        wait
                                                fi
						3dmerge -prefix "$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/concat/tcat_ordered_thr.nii.gz \
						-doall -1noneg \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/concat/tcat_ordered.nii.gz &
					done
				fi


				if [[ $step = s11 ]]; then
#					Ostats="mean median max stdev 95 99"
					stats="99 95"
					# make final whole-brain stat maps for all ROIs
					# Make wholebrain_delay_maps directory
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/outy/
					mkdir -p "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/inny/

					for stat in $stats; do
						if (( i % 8 == 0 )); then
								wait
						fi
						((i++))
						if [[ ! -e  "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/inny/"$perp"_"$movie_part"_"$corr"_inny_"$stat".nii.gz ]]; then
#                                                if [[ ! -e  "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/inny/"$perp"_"$movie_part"_"$corr"_inny_"$stat"_2nd_attempt.nii.gz ]]; then
						#### Make whole-brain input map for each stat
						#rm  "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/inny/"$perp"_"$movie_part"_"$corr"_inny_"$stat"_2nd_attempt.nii.gz
						3dTstat -percentile "$stat" -prefix "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/inny/"$perp"_"$movie_part"_"$corr"_inny_"$stat".nii.gz \
						-mask "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/inny/concat/tcat_ordered.nii.gz &
						fi
					done

					for stat in $Ostats; do
						if (( i % 8 == 0 )); then
								wait
						fi
						((i++))
#						rm "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/outy/"$perp"_"$movie_part"_"$corr"_outy_"$stat".nii.gz
#						if [[ ! -e  "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/outy/"$perp"_"$movie_part"_"$corr"_outy_"$stat".nii.gz ]]; then
						if [[ ! -e  "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/outy/"$perp"_"$movie_part"_"$corr"_outy_"$stat"_5th_attempt.nii.gz ]]; then
						#### Make whole-brain output map for each stat
						3dTstat -nzmean -prefix "$out_dir"/delay_mapping/sub-"$perp"/wholebrain_delay_maps/"$movie_part"/"$corr"/outy/"$perp"_"$movie_part"_"$corr"_outy_"$stat"_5th_attempt.nii.gz \
						-mask "$out_dir"/delay_mapping/MNI152_2009_mask_resamp.nii.gz \
						"$out_dir"/delay_mapping/sub-"$perp"/delay_maps/"$movie_part"/"$corr"/outy/"$stat"/concat/tcat_ordered_thr.nii.gz &
						fi

					done
				# end of step 11
				fi
			done
			# end of pos/neg correlation loop
		done
			# end of movie_part loop
	done
	# end of perp loop
done
# end of steps

echo "---"
echo "---"
echo "---"
echo "Science is the ultimate pornography, analytic activity whose main aim is to isolate objects or events from their contexts in time and space. This obsession with the specific activity of quantified functions is what science shares with pornography"
echo "- J.G Ballard"
echo "---"
echo "---"
echo "---"
echo "Thankyou for choosing whole-brain delay mapping"
