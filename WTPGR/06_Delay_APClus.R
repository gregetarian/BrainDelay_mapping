#Code to perform affinity propagation clustering analysis on vectorised ROI-wise delay maps
#returns a CSV for each cluster containing ROI labels (apc{k}.csv). Also returns a CSV containing the cluster labels for each ROI (d.apclus.csv)


# Load necessary libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(dendextend)
library(apcluster)
library(rbenchmark)
library(RColorBrewer)

# Read group-averaged vvectorised delay maps (one column per map, each row containing the delay values of voxels) and converts to matrix
df <- as.matrix(t(read.table('maskdump.1D', header = TRUE)))

# Remove rows and columns with only zero values for cleaner data
df <- df[rowSums(df) != 0,]
df <- df[,colSums(df) != 0]

# Perform affinity propagation clustering
# Benchmarking to measure performance
benchmark_result <- benchmark(
  d.apclus <- apcluster(negDistMat(r=2, method="manhattan"), df, q=0.5) #q=0.5 is the default value
  replications = 1,
  columns = c("test", "replications", "elapsed", "relative", "user.self", "sys.self")
)
cat("affinity propagation optimal number of clusters:", length(d.apclus@clusters), "\n")

# Extracting cluster attributes
d.apclus.h <- get_nodes_attr(d.apclus, "height")
d.apclus.l <- labels(d.apclus)
d.apclus.n <- nleaves(d.apclus)

# Define the file path prefix for saving outputs
file_prefix <- "/Users/gcooper/Documents/DELAY_reanalysis/grp_avg/final_apc_attempt/"

# Save outputs to CSV files
write.csv(d.apclus.l, file = paste0(file_prefix, "d.apclus.l.csv"))
write.csv(negDistMat(df, r=2, method='manhattan'), file = paste0(file_prefix, "s1.csv"))
write.csv(d.apclus, file = paste0(file_prefix, "d.apclus.csv"))
write.csv(d.apclus@clusters, file = paste0(file_prefix, "d.apclus.clusters.csv"))

# Generate heatmaps for visualizing clusters
# Function to create and save heatmap
create_heatmap <- function(data, file_name) {
  pdf(file_name)
  heatmap(data, col=brewer.pal(n=11, name="Spectral"), Rowv=NA, dendScale=0.5, margins=c(3, 3, 2), legend="col")
  dev.off()
}

# Create and save heatmaps
create_heatmap(d.apclus, paste0(file_prefix, "d.apclus_heatmap.pdf"))
d.apclus.agg <- aggExCluster(x=d.apclus)
create_heatmap(d.apclus.agg, paste0(file_prefix, "d.apclus_agg_heatmap.pdf"))

# Saving cluster time points
# Function to save clusters
save_clusters <- function(clusters, prefix, file_name) {
  ks <- length(clusters)
  for (k in 1:ks) {
    write(names(clusters[[k]]), paste0(prefix, file_name, k, ".txt"))
  }
}

# Save original and cut clusters
save_clusters(d.apclus@clusters, file_prefix, "apc")
