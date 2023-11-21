from imp import load_dynamic
import warnings
import glob
warnings.simplefilter("ignore")
import nilearn as nilearn

from nilearn import datasets
import sys
from nilearn.input_data import NiftiMapsMasker
import pandas as pd
import numpy as np



perp=sys.argv[1]
movie_part=sys.argv[2]
cmap=str(sys.argv[3]) # get name of timeseries
dir=sys.argv[4]


print(perp)
print(movie_part)
print(cmap)

data=nilearn.datasets.fetch_atlas_difumo(dimension=1024, resolution_mm=3)
#print(data.labels) #roi labels

d_img = nilearn.image.load_img(data.maps) # roi data
maps_masker = NiftiMapsMasker(maps_img=data.maps, verbose=1) #makes a mask of rois

print("extracting signals")
signals = maps_masker.fit_transform(cmap)

print("Per ROIs signal: {0}".format(signals.shape)) # should be shape (time, rois_tot)
df = pd.DataFrame(signals, columns = range(1024))



for i in range(1024):
    j=str(i+1)
    q=df.iloc[:,i]
    s=df_neg.iloc[:,i]

    print(q)
    print(s)
    q.to_csv(dir+"/delay_mapping/sub-"+perp+"/difumo_rois/"+movie_part+"/pos/roi-"+j+".1D", index=False)


np.savetxt(dir+'/delay_mapping/sub-'+perp+'/difumo_rois/'+movie_part+'/all/parcellation_difumo_ts.1D', df)

