#!/bin/bash

# This script generates group-level averages of Cross-correlation-coefficient volumes determined via 3dDelay [ 01_base_delay_pipeline.sh ] for each ROI, to be used in gradient computation

rois="1 5 6 7 8 9 10 11 13 14 15 16 17 18 20 21 23 24 25 26 30 31 32 33 34 36 37 38 39 40 41 42 45 46 48 49 50 52 53 54 55 56 58 60 61 62 63 64 65 66 67 68 69 70 71 73 75 76 77 78 80 82 83 84 85 86 90 91 92 94 95 96 97 98 100 101 102 103 104 105 106 110 111 112 113 114 116 117 118 120 121 122 123 124 126 127 128 129 130 131 132 133 134 135 136 137 140 141 142 144 147 148 149 150 152 153 154 155 156 157 158 159 161 162 163 164 165 166 169 170 171 172 173 174 175 176 177 178 179 181 183 184 185 186 188 189 191 192 195 197 199 201 202 204 205 206 209 211 212 213 214 215 216 217 218 219 221 222 223 224 225 226 229 230 231 233 234 235 237 238 239 240 242 243 244 245 246 247 249 250 251 252 253 254 255 256 257 259 260 261 262 263 264 265 266 267 268 271 273 274 277 279 280 281 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 311 314 315 316 317 318 319 322 323 325 326 327 328 329 330 331 332 333 334 335 336 337 338 342 343 344 346 347 348 349 350 351 352 353 354 355 356 357 358 360 361 362 363 365 366 367 368 369 370 372 373 374 377 379 380 381 383 385 386 387 388 389 390 391 393 394 395 396 397 398 400 401 402 405 407 408 409 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 439 441 442 443 444 445 446 447 448 449 451 452 453 456 457 458 460 461 463 464 466 467 468 470 471 472 473 474 475 476 477 480 481 482 483 484 485 486 487 488 490 492 493 494 495 496 497 499 500 502 503 504 505 506 507 508 509 510 512 513 514 515 517 520 521 522 523 524 525 526 527 528 529 530 531 532 533 535 539 541 542 543 544 545 548 549 550 551 552 553 555 556 557 558 559 561 564 566 567 568 571 572 573 575 576 578 581 583 584 585 588 589 590 591 592 594 596 597 598 600 602 603 604 605 606 607 608 609 611 612 614 615 616 618 620 621 623 625 626 629 631 632 633 634 635 636 638 639 641 642 644 645 646 647 648 649 650 651 652 653 654 655 656 657 660 662 663 665 666 667 668 670 671 672 673 674 675 676 677 678 679 680 681 682 683 686 689 691 692 693 694 695 696 697 698 699 700 701 703 704 707 708 709 710 711 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 730 731 732 734 735 736 737 738 741 742 743 745 746 748 749 750 751 752 753 754 755 756 757 758 759 761 762 763 764 765 766 767 768 769 771 773 774 775 776 777 778 779 780 781 783 784 786 787 788 789 790 792 793 795 796 797 798 799 801 802 803 804 806 809 810 811 813 814 815 817 818 820 821 822 823 824 825 826 827 828 830 831 832 833 834 836 837 838 839 840 841 842 843 844 845 846 847 848 849 850 851 852 854 855 856 857 858 859 860 863 864 865 866 867 868 869 870 873 874 875 877 878 879 880 881 882 883 884 885 887 888 889 890 891 892 893 894 895 896 897 898 899 901 902 903 904 905 906 907 909 910 912 913 914 915 916 918 919 920 921 923 924 925 927 928 929 930 931 932 933 934 936 937 938 939 940 941 943 944 945 946 947 951 952 954 955 956 959 960 962 963 965 966 968 970 971 972 973 974 975 976 977 978 979 980 981 982 983 984 985 986 987 988 989 990 991 992 993 994 995 996 997 998 999 1000 1001 1002 1003 1004 1006 1007 1010 1011 1013 1015 1016 1018 1019 1020 1022 1023"

mkdir /data/gcooper/movie_delay/delay_mapping/all_unthresh/coefs
steps="s1 s2 s3 s4"

for step in $steps; do

if [[ $step = s1 ]]; then
for perp in `seq 1 86`; do
#for perp in 2; do
	for chunk in beginning middle end; do
		for roi in $rois; do
		    if (( i % 20 == 0 )); then
		      wait
		    fi
		    ((i++))

			rm /data/gcooper/movie_delay/delay_mapping/all_unthresh/coefs/sub-"$perp"_"$chunk"_roi-"$roi".nii.gz
			3dcalc -prefix /data/gcooper/movie_delay/delay_mapping/all_unthresh/coefs/sub-"$perp"_"$chunk"_roi-"$roi".nii.gz \
			-a /data/gcooper/movie_delay/delay_mapping/sub-"$perp"/delay_maps/"$chunk"/pos/roi-"$roi".nii.gz[2] \
			-expr 'a' &
#			fi
		done
	done
done
fi



if [[ $step = s2 ]]; then
for roi in $rois; do
	if [[ ! -e /data/gcooper/movie_delay/delay_mapping/grp_avg/temp/coefs/roi-"$roi" ]]; then
	mkdir -p /data/gcooper/movie_delay/delay_mapping/grp_avg/temp/coefs/roi-"$roi"
	fi
    if (( i % 20 == 0 )); then
      wait
    fi
    ((i++))
		echo tcatting roi-$roi from all subjects and movie segments
		rm /data/gcooper/movie_delay/delay_mapping/grp_avg/temp/coefs/roi-"$roi"/roi-"$roi"_tcat_temp.nii.gz
		3dTcat -prefix /data/gcooper/movie_delay/delay_mapping/grp_avg/temp/coefs/roi-"$roi"/roi-"$roi"_tcat_temp.nii.gz \
		`ls /data/gcooper/movie_delay/delay_mapping/all_unthresh/coefs/*_roi-"$roi".nii.gz` &

#	fi
done
fi


if [[ $step = s3 ]]; then
for roi in $rois; do
    if (( i % 25 == 0 )); then
      wait
    fi
    ((i++))
        #rm /data/gcooper/movie_delay/delay_mapping/all_unthresh/coefs/*_roi-"$roi".nii.gz &
	    rm /data/gcooper/movie_delay/delay_mapping/grp_avg/rois/coefs/roi-"$roi".nii.gz
	    3dTstat -prefix /data/gcooper/movie_delay/delay_mapping/grp_avg/rois/coefs/roi-"$roi".nii.gz \
	    -nzmedian /data/gcooper/movie_delay/delay_mapping/grp_avg/temp/coefs/roi-"$roi"/roi-"$roi"_tcat_temp.nii.gz &
done
fi

if [[ $step = s4 ]]; then
	#concatenate all group-averaged cross-correlation maps into a single 4D file
	3dTcat -prefix /data/gcooper/movie_delay/delay_mapping/grp_avg/tcat/coefs/tcat_all.nii.gz \
	/data/gcooper/movie_delay/delay_mapping/grp_avg/rois/coefs/roi-?.nii.gz \
	/data/gcooper/movie_delay/delay_mapping/grp_avg/rois/coefs/roi-??.nii.gz \
	/data/gcooper/movie_delay/delay_mapping/grp_avg/rois/coefs/roi-???.nii.gz \
	/data/gcooper/movie_delay/delay_mapping/grp_avg/rois/coefs/roi-????.nii.gz

	for roi in $rois; do
		r=$((roi-1))
		echo $r
		rm /data/gcooper/movie_delay/delay_mapping/grp_avg/tcat/coefs/roi_maskaves/roi-"$roi".1D
		#resampled, binarised masks from the DiFUMO atlas used to extract participant-averaged, within-mask-mean cross correlation values for each ROI, generating a ROIxROI matrix
		3dmaskave -mask /data/gcooper/movie_delay/difumo_atlases/1024/3mm/resamp_maps_mni.nii.gz[$r] \ 
		/data/gcooper/movie_delay/delay_mapping/grp_avg/tcat/coefs/tcat_all.nii.gz > /data/gcooper/movie_delay/delay_mapping/grp_avg/tcat/coefs/roi_maskaves/roi-"$roi".1D
	done
done