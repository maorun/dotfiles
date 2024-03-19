#!/bin/bash -e

echo 'Author;Comments;Approved' > /tmp/reviews.csv

LIST=`gh pr list --state all --limit 400 --json number -q '.[].number'`

for PR in ${LIST}; do
    echo ${PR}

    STATE=`gh pr view ${PR} --json state -q '.state'`
    if [ ${STATE} == "CLOSED" ]; then
        echo "PR is closed"
        continue
    fi
    LOGIN=`gh pr view ${PR} --json author  -q '.author.login'`
    if [ ${LOGIN} == "app/renovate" ]; then
        echo "PR is from renovate"
        continue
    fi
    DATA=`gh pr view ${PR} --json reviews -q '.reviews.[] | select(.author.login != "'${LOGIN}'") | select(.state != "APPROVED") | .author.login'  | tr '\n' ','`
    APPROVED=`gh pr view ${PR} --json reviews -q '.reviews.[] | select(.state == "APPROVED") | .author.login' | tr '\n' ','`
    DATA=${LOGIN}";"${DATA}";"${APPROVED}
    echo ${DATA} >> /tmp/reviews.csv
done
