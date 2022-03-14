#!/usr/bin/env zsh
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m' # No Color

NAME=$(kubectl config current-context);
MAX=$(kubectl get nodes --all-namespaces -o json | jq -r '.items[] | .status.capacity.pods' | awk '{s+=$1} END {print s}');
TOTAL=$(kubectl get pods --all-namespaces -o json | jq ' .items | length');
AVAILABLE=$(expr $MAX - $TOTAL);

echo "You have $BLU$TOTAL$NC of $BLU$MAX$NC pods running in $BLU$NAME$NC with $RED$AVAILABLE$NC pods available.";
