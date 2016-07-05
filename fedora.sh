## Install a necessary packages
yum install cloud-utils genisoimage

## URL to most recent cloud image of 12.04
img_url="http://mirrors.aliyun.com/fedora/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2"
## download the image
wget $img_url -O fedora.img.dist

## Create a file with some user-data in it
cat > my-user-data <<EOF
#cloud-config
password: passw0rd
chpasswd: { expire: False }
ssh_pwauth: True
EOF

## Convert the compressed qcow file downloaded to a uncompressed qcow2
qemu-img convert -O qcow2 fedora.img.dist fedora.img.orig

## create the fedora with NoCloud data on it.
cloud-localds my-seed.img my-user-data

## Create a delta fedora to keep our .orig file pristine
qemu-img create -f qcow2 -b fedora.img.orig fedora.img

## Boot a kvm
qemu-kvm -net nic -net user -hda fedora.img -hdb my-seed.img -m 512 -vnc :51 -nographic
