#!/bin/bash
lxc config set nama_container limits.cpu 4
lxc config set nama_container limits.memory 64GB
lxc config set nama_container limits.memory.swap false
lxc config set nama_container limits.memory.swap.priority 0
lxc config set nama_container limits.memory.enforce hard

lxc config set nama_container security.privileged true
lxc restart nama_container

lxc config device override nama_container root size=50GB
lxc config device set nama_container root size 50GB
lxc config device add nama_container appsdir disk source=/albayanat/nama_direktori_anak_zfs/ path=/apps
lxc config device remove nama_container appsdir

lxc storage create NAME dir source=/some/empty/directory
