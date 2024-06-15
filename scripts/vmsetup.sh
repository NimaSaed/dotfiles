#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

all_vm=($(prlctl list -a | sed -E 's|([a-zA-Z0-9]) ([a-zA-Z0-9])|\1_\2|g' | sed 1d | awk '{print $1,$2,$4}' | sed 's/ /,/g' | sed 's/[{}]//g'))

PS3="Select a VM: [none = 0] "

select vm in ${all_vm[@]}
do
    selected=$vm;
    break;
done

unset $PS3;

if [ ! -z ${vm} ];
then
    # get vm details from selected vm
    vm_info=($(echo $vm | sed 's/,/ /g'))
    vm_uuid=${vm_info[0]}
    vm_status=${vm_info[1]}
    vm_name=${vm_info[2]}

    UUID=$vm_uuid


    if [ ${UUID} != "none" ];
    then
        prlctl set ${UUID} \
            --sh-app-host-to-guest off \
            --sh-app-guest-to-host off \
            --auto-switch-fullscreen off \
            --shared-cloud off \
            --smart-mount off \
            --shared-clipboard off \
            --shared-profile off \
            --shf-host-defined off \
            --sync-host-printers off
    fi
fi


