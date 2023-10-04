openstack network create network1
openstack subnet create --network network1 --subnet-range 10.1.1.0/24 subnet1
openstack network create network2
openstack subnet create --network network2 --subnet-range 10.1.2.0/24 subnet2
openstack network create network3
openstack subnet create --network network3 --subnet-range 10.1.3.0/24 subnet3
openstack network create presidentialNetwork
openstack subnet create --network presidentialNetwork --subnet-range 10.1.4.0/24 presidentialSubnet
openstack network create grayNetwork
openstack subnet create --network grayNetwork --subnet-range 10.1.100.0/24 graySubnet
openstack router create stupidRouter
openstack router add subnet stupidRouter subnet1
openstack router add subnet stupidRouter subnet2
openstack router add subnet stupidRouter subnet3
openstack router add subnet stupidRouter presidentialSubnet
openstack router add subnet stupidRouter graySubnet
openstack router set --external-gateway MAIN-NAT stupidRouter
net1=$(openstack network show -c id -f value network1)
net2=$(openstack network show -c id -f value network2)
net3=$(openstack network show -c id -f value network3)
pres=$(openstack network show -c id -f value presidentialNetwork)
gray=$(openstack network show -c id -f value grayNetwork)
openstack server create --flavor medium --image WinSrv2019-17763-2022 --user-data prepare-ansible-for-windows --key-name grayKey --nic net-id=$net1,v4-fixed-ip=10.1.1.10 Winserver
openstack server create --flavor medium --image Win10-21H2 --user-data prepare-ansible-for-windows --key-name grayKey --nic net-id=$net1,v4-fixed-ip=10.1.1.11 Win10
openstack server create --flavor medium --image UbuntuJammy2204 --key-name grayKey --nic net-id=$net1,v4-fixed-ip=10.1.1.12 UbuntuWeb
openstack server create --flavor medium --image UbuntuJammy2204 --key-name grayKey --nic net-id=$net1,v4-fixed-ip=10.1.1.13 UbuntuSQL
openstack server create --flavor medium --image UbuntuJammy2204 --key-name grayKey --nic net-id=$net2,v4-fixed-ip=10.1.2.14 UbuntusFTP
openstack server create --flavor medium --image UbuntuJammy2204 --key-name grayKey --nic net-id=$net2,v4-fixed-ip=10.1.2.15 UbuntuSamba
openstack server create --flavor medium --image ArchLinux2022 --key-name grayKey --nic net-id=$net3,v4-fixed-ip=10.1.3.16 Arch
openstack server create --flavor medium --image WinXP-SP0 --user-data prepare-ansible-for-windows --key-name grayKey --nic net-id=$pres,v4-fixed-ip=10.1.4.17 PresidentialBox
openstack server create --flavor medium --image UbuntuJammy2204-Desktop --key-name grayKey --nic net-id=$gray,v4-fixed-ip=10.1.100.10 Scoring
openstack server add fixed ip --fixed-ip-address 10.1.100.11 Control grayNetwork
