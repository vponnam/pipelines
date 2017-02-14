#!/bin/bash
#set -e
apt-get update
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
mv cf /usr/local/bin
cf --version


#Shared_VM plan 
echo `cf curl /v2/service_plans/50d2b223-1d7b-4ad1-9cb5-98b54b7c70b4 | awk -v i=3 -v j=2 'FNR == i {print $j}'` |tr -d '",'  #guid from /v2/service_plans
s="50d2b223-1d7b-4ad1-9cb5-98b54b7c70b4"  #avoid hardcoding

c1=`cf curl /v2/service_plans/$s/service_instances |grep "metadata" |wc -l`
echo "shared plan instances usage: $c1"

#Dedicated_VM plan 
d= echo `cf curl /v2/service_plans/2c8f6ed3-a541-4b34-a514-3b63a043df33 | awk -v i=3 -v j=2 'FNR == i {print $j}'` |tr -d '",' #guid from /v2/service_plans
d="2c8f6ed3-a541-4b34-a514-3b63a043df33" #avoid hardcoding
c2=`cf curl /v2/service_plans/$d/service_instances |grep "metadata" |wc -l`
echo "dedicated plan instances usage: $c2"

if [ $c2 -ge 0 ]; 
then
	 cf cs p-redis dedicated-vm redis-t1
	 if [ $? -eq 0 ]; then
	 cf ds redis-t1 -f
 	 else
		 echo "Scale dedicated instances"
	 fi
fi