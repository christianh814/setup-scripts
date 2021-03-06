#!/bin/bash
show_help () {
cat <<-HELP
${0} [ --etcd | --help ]
    --etcd - Use this if you have etcd nodes
    --help - prints this screen
HELP
exit
}
[[ $1 = "--help" ]] && show_help
[[ $1 = "--etcd" ]] && etcd=true

ansible all -m shell -a 'yum remove -y openshift* atomic* openvswitch || true'
 
ansible all -m shell -a 'rm -rf /etc/origin/* || true '
ansible all -m shell -a 'rm -rf /etc/sysconfig/atomic* || true '
 
ansible all -m shell -a 'rm -rf /root/.kube || true'
ansible all -m shell -a 'rm -rf /var/lib/origin || true'
 
if [ ${etcd:=false} = "true" ]; then
  echo "yes"
  ansible etcd -m shell -a 'yum remove -y etcd || true'
  ansible etcd -m shell -a 'rm -rf /var/lib/etcd || true'
  ansible etcd -m shell -a 'rm -rf /etc/etcd || true'
fi
 
ansible all -m yum -a 'name=atomic-openshift-utils state=latest'
##
##
