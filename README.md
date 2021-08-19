# docker-swarm-3az-aws-terraform
Infrastructure as Code which create docker swarm cluster with three managers and workers in three availability zones on AWS.

![rsz_docker-swarm-3az](https://user-images.githubusercontent.com/7665799/129252435-9204be6e-1504-4ee6-9a6c-1887040d1d8b.png)

## Prerequest

Use environment variables to provide configuration options and credentials.
```bash
    $ export AWS_ACCESS_KEY_ID=
    $ export AWS_SECRET_ACCESS_KEY=
    $ export AWS_DEFAULT_REGION=eu-central-1
```
or use named profile in the shared configuration and credentials files.
```bash
    .aws/credentials
    [default]
    aws_access_key_id=
    aws_secret_access_key=

    .aws/config
    [default]
    region=eu-central-1
    output=json
```

## Terraform

Change directory to root of project and execute terraform apply command.
```bash
    terraform init
    terraform apply
```
it will generate ansible inventory file from template.


## Ansible

Before we install docker need to load ip_vs linux kernel module to fix Docker Swarm error:
```
level=error msg="error reading the kernel parameter net.ipv4.vs.expire_nodest_conn" error="open /proc/sys/net/ipv4/vs/expire_nodest_conn: no such file or directory"
level=error msg="error reading the kernel parameter net.ipv4.vs.expire_quiescent_template" error="open /proc/sys/net/ipv4/vs/expire_quiescent_template: no such file or directory"
level=error msg="error reading the kernel parameter net.ipv4.vs.conn_reuse_mode" error="open /proc/sys/net/ipv4/vs/conn_reuse_mode: no such file or directory"
```
just need to run first:
```bash
    ansible-playbook update-linux-modules-boot-playbook.yaml
```
it will copy ip-virtual-server.conf to /etc/modules-load.d and restart systemd-modules-load service to load new kernel module.
To confirm that ip_vs module is loaded just run ansible command:
```bash
ansible managers,workers -m ansible.builtin.shell -a "lsmod | grep ip_vs"
```

Now we will install docker with running:
```bash
    ansible-playbook install-docker-playbook.yaml
```
and after that we set up docker swarm cluster.
```bash
    ansible-playbook deploy-docker-swarm-playbook.yaml
```

To verify that docker swarm is up and running just connect to manager node and run
```bash
    docker node ls
```
Ansible playbook for deploying swarm is used from:
https://github.com/nextrevision/ansible-swarm-playbook

I added helper ansible playbook for fetching syslogs in format 
```
syslog-swarm-manager-1-2021-08-19.log
```
