#!/bin/bash

source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW CMSSW_12_4_10
cd CMSSW_12_4_10/src/
eval `scram runtime -sh`
#git clone git@github.com:drkovalskyi/Bmm5.git --branch NanoAODv10-V01
git clone --branch NanoAODv10-V01 https://github.com/drkovalskyi/Bmm5.git
scram b -j8
cd ../../

RAND_SEED=$(($1+123456))
echo ${RAND_SEED}

NEVENTS=-1;
NTHREADS=1;

sed -i 's/NTHREADS/'${NTHREADS}'/g' mc_cfg.py
sed -i 's/NEVENTS/'${NEVENTS}'/g' mc_cfg.py

file=$( cat listDmm.txt | sed -n ''$1'p')
idx=${file##*_}
echo "running ",$idx

xrdcp root://submit50.mit.edu/$file input.root

cmsRun mc_cfg.py

mv output.root nano_$idx
xrdcp nano_$idx root://submit50.mit.edu//store/user/wangzqe/Dmeson/nano/Dmm/
echo "done"
