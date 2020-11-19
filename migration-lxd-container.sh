# Buat container baru
lxc launch images:centos/7 datamart-dua -s nama_storage_pool
zpool list
zpool status albayanat
zfs list | grep datamart-dua

#Hapus mounting dan pindahkan snapshot dari container sebelumnya, mounting ulang
lxc stop datamart-dua
zfs destroy attatbiqat/lxd/containers/datamart-dua
zfs list -t snapshot | grep datamart
zfs send -v albayanat/lxd/containers/datamart@snapshot-snap0 | zfs receive -v attatbiqat/lxd/containers/datamart-dua
zfs set mountpoint=/var/snap/lxd/common/lxd/storage-pools/usetyenziso/containers/datamart-dua attatbiqat/lxd/containers/datamart-dua

# Konfigurasi LXD dan Network, migrasikan database ZFS lama ke ZFS baru
lxc config show datamart
lxc info datamart
lxc config edit datamart-dua
lxc info datamart
lxc network attach br0 datamart-dua eth0 eth0
zfs send -v albayanat/datamart@20201019 | zfs receive -v attatbiqat/datamart
lxc info --show-log datamart-dua

# (opsional) migrasi database ZFS lalma ke ZFS baru beda IP
zfs send -v albayanat/lxd/containers/datamart@snapshot-snap0 |  ssh  -i nama_private_key root@10.1.1.101 "zfs receive -v albayanat/lxd/containers/datamart-dua"
zfs send -v albayanat/datamart@20201019 | ssh  -i nama_private_key root@10.1.1.101 "zfs receive -v albayanat/datamart"

# (opsional jika error) 
lxc info --show-log datamart-dua
ls -la /var/snap/lxd/common/lxd/containers/datamart-dua/rootfs
zfs list | grep datamart-dua
zfs umount attatbiqat/lxd/containers/datamart-dua
lxc start datamart-dua
lxc storage list
ls -la /var/snap/lxd/common/lxd/storage-pools/usetyenziso/containers/datamart-dua
rm -f /var/snap/lxd/common/lxd/storage-pools/usetyenziso/containers/datamart-dua/backup.yaml
