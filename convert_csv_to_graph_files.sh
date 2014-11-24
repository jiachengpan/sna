#! /bin/bash

cd data
rm -rf gdf
mkdir gdf

rm -rf ncol
mkdir ncol

for file in $(ls github_interest-*.csv); do
    echo "processing $file"
    infoFile=$(echo $file | sed "s/github_interest/github_interest_repo/")

    # Output GDF file for gephi
    echo "nodedef>name VARCHAR,label VARCHAR,lang VARCHAR,star DOUBLE" > gdf/$file.gdf
    cat $file | \
        awk -F "," 'BEGIN {enter = 1} enter {enter = 0; next} {printf("%s\n%s\n", $1, $2)}' | \
        sort | \
        uniq > tmp.nodes

    ../merge_repo_info.py tmp.nodes $infoFile >> gdf/$file.gdf
    echo "edgedef>node1 VARCHAR,node2 VARCHAR, weight DOUBLE" >> gdf/$file.gdf
    sed "1d" $file | \
        awk -F "," '{ if ($3 > 10) {print $0} }' | \
        sed "s/https:..github.com.//g" >> gdf/$file.gdf

    # Output NCOL file for igraph
    sed "1d" $file | sed "s/,/ /g" > ncol/$file.ncol

    rm -rf tmp.nodes
done

