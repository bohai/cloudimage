## Install a necessary packages
yum install cloud-utils genisoimage

## URL to most recent cloud image of 12.04
img_url="http://cloud-images.ubuntu.com/server/releases/12.04/release"
img_url="${img_url}/ubuntu-12.04-server-cloudimg-amd64-disk1.img"
## download the image
wget $img_url -O ubuntu.img.dist

## Create a file with some user-data in it
cat > my-user-data <<EOF
#cloud-config
password: passw0rd
chpasswd: { expire: False }
ssh_pwauth: True
EOF

## Convert the compressed qcow file downloaded to a uncompressed qcow2
qemu-img convert -O qcow2 ubuntu.img.dist ubuntu.img.orig

## create the ubuntu with NoCloud data on it.
cloud-localds my-seed.img my-user-data

## Create a delta ubuntu to keep our .orig file pristine
qemu-img create -f qcow2 -b ubuntu.img.orig ubuntu.img

## Boot a kvm
qemu-kvm -net nic -net user -hda ubuntu.img -hdb my-seed.img -m 512 -vnc :51 -nographic
