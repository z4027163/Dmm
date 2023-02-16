file=$( cat listDmm.txt | sed -n ''$1'p')
echo $file
xrdcp root://submit50.mit.edu/$file input.root
idx=${file##*_}
echo $idx
