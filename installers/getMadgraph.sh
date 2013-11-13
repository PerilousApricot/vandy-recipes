#!/bin/bash

# Install script for madgraph

CMSSW_VERSION=CMSSW_5_3_11

echo "Installing MadGraph to ${PWD}"
command -v scram >/dev/null 2>&1
if [[ $? ]]; then
    echo >&2 "CMS environment not found, attempting to get one"
    if [[ -f /cvmfs/cms.cern.ch/cmsset_default.sh ]]; then
        source /cvmfs/cms.cern.ch/cmsset_default.sh
    fi
fi
echo "Using CMS environment at: $(dirname $(dirname $(which scram)))"
if [[ ! -d $CMSSW_VERSION ]]; then
    echo >&2 "Starting CMSSW project"
    scramv1 project CMSSW $CMSSW_VERSION
fi
cd $CMSSW_VERSION/src
eval `scramv1 runtime -sh`
cd -


if [[ ! -d MadGraph5_v1_5_13 ]]; then
    echo "Downloading MG5"
    curl https://launchpad.net/madgraph5/trunk/1.5.0/+download/MadGraph5_v1.5.13.tar.gz -L | tar -xz
fi
cd MadGraph5_v1_5_13
if [[ ! -f bin/setup.mg5 ]]; then
    cat <<- 'EOF' > bin/setup.mg5
install MadAnalysis
install pythia-pgs
exit
EOF
fi
echo "Installing extra packages"
./bin/mg5 bin/setup.mg5
echo "Done installing Madgraph"
