Ansible is used to provision the system container with the necessary development
dependencies (Ruby, Rails, Nginx/Passenger, Java, PostgreSQL, Node.js, npm,
bower, and elasticsearch). The virtualization provider is assumed to be 
LXC/LXD containers (system containers).

The provided Ansible scripts also shares a chosen directory with the guest
system container such that all development sources reside on the host. In this
way you can destroy the container without losing any work.

## Requirements

* Ubuntu host (only 16.04 has been tested, though the container guest is 14.04)
* LXD (`sudo apt install lxd; newgrp lxd; lxd init`)
* Ansible (`sudo pip install ansible`)

## Start up a Contained Dev Environment

1. Modify the Ansible configuration to share a specific directory with the guest
    system container, for example:
    ```
    $ vi playbooks/lxd-ubuntu1404.yml
      ...
        share_host_path: /home/wagoodman/excella
        guest_mount_path: excella
      ...
    ```
    Where:
     * `share_host_path` is the path of the directory on the host that you'd like to
       share with the guest container.
     * `guest_mount_path` is the path where the host share will be mounted (this is
       relative, so *don't* include a prefixed backslash).

1. Run the setup script:
    ```
    $ ./setup.sh
    ```
    This will:
    * Install dependent Ansible modules
    * Create a system container called "devbox"
    * Provision the system container with dev dependencies

## LXD commands
This is just a short one-over on useful commands for normal operation.

#### Basics
```
$ lxc start devbox
$ lxc stop devbox
$ lxc restart devbox
$ lxc list                  # list all created containers
$ lxc exec devbox bash      # get a root console in the container
$ lxc info devbox           # get basic info about the container
```

#### Snaphots
Every once in a while you may want to backup the system container, this can
be done with snapshots:
```
$ lxc snaphot devbox <snaphot-name>     # create a snapshot
$ lxc restore devbox <snaphot-name>     # restore the container back to a previous state
```
Note: snapshots do **not** affect shared directories bound into the guest container.

#### Destroy
Delete a container entirely:
```
$ lxc delete devbox
```
Note: this will **not** delete any shared directories on the host.

## Why LXC/LXD?
I was using VMs to achieve the same virtualized development environment, however
there were a few quirks:
 * Keeping data in the VM put unsaved work at risk, which means sensitive work
   is best kept in a shared directory (the data *really* resides on the host).
 * Shared directories have inferior performance when compared to a native filesystem,
   which is not preferable.
 * For Windows hosts: shared dirs do not preserve linux file permissions.
 * For Linux hosts: VMs seemed silly since I don't *really* need another kernel anyway.

These above points lead me towards a containerized linux environment.

Docker is the go-to solution when it comes to application containers (a single app
per-container) however it is not best suited for system containers (multiple apps
per-container). Systemd-nspawn and LXC/LXD are best suited for this --however, nspawn
will not work for a Ubuntu 14 guest since systemd is required to be running on
the guest container and was not introduced until Ubuntu 15. For the above reasons
LXC/LXD instructions are outlined here.
