#!/bin/bash

NAMESPACES=$(kubectl get namespaces -o json | jq -r '.items | .[] | select(.metadata.name | test("splunk")) | .metadata.name')

for NS in $NAMESPACES
do
    SECRET=$(kubectl -n $NS get secrets -o json | jq -r '[.items | .[] | select(.metadata.name | test("operator|ingress|s3|default|bucket") | not)] | .[0] | .metadata.name')

    if [ "$SECRET" = "null" ]
    then
        PWD="N/A"
    else
        PWD=$(kubectl -n $NS get secret $SECRET -o jsonpath={.data.password} | base64 -d)
    fi

    echo "$NS  $PWD"
done

exit 0
