## Install a necessary packages
yum install cloud-utils genisoimage

## URL to most recent cloud image of 12.04
img_url="http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1605.qcow2c"
## download the image
wget $img_url -O centos.img.dist

## Create a file with some user-data in it
cat > my-user-data <<EOF
#cloud-config
password: passw0rd
chpasswd: { expire: False }
ssh_pwauth: True
EOF

## Convert the compressed qcow file downloaded to a uncompressed qcow2
qemu-img convert -O qcow2 centos.img.dist centos.img.orig

## create the centos with NoCloud data on it.
cloud-localds my-seed.img my-user-data

## Create a delta centos to keep our .orig file pristine
qemu-img create -f qcow2 -b centos.img.orig centos.img

## Boot a kvm
qemu-kvm -net nic -net user -hda centos.img -hdb my-seed.img -m 512 -vnc :51 -nographic
