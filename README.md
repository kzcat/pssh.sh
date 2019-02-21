# pssh.sh

Shell script for executing ssh in parallel.

## Requirement
OpenSSH client

## Usage

```
Usage: pssh.sh [-P max-procs] [-Z] [-h] [SSH Options] host1 host2 ... hostN -- command
Options:
    -P max-procs   run up to max-procs processes at a time(default: 10)
    -Z             print result compact
    -h             show this help
    SSH Options    see OpenSSH client man page
```

## Install Example
```console
# install script
$ sudo install pssh.sh /usr/bin/pssh
# install bash-completion
$ sudo install -m644 pssh-bash-completion /usr/share/bash-completion/completions/pssh
```


## Example
```console
$ pssh.sh host1 host2 host3 host4 -- df /
Filesystem           1K-blocks     Used Available Use% Mounted on
/dev/mapper/vg_db01-lv_root
                      45805980 29969728  13502764  69% /
Filesystem           1K-blocks     Used Available Use% Mounted on
/dev/mapper/vg_db02-lv_root
                      45805980 26283940  17188552  61% /
Filesystem           1K-blocks     Used Available Use% Mounted on
/dev/mapper/vg_db04-lv_root
                      45805980 25094236  18378256  58% /
Filesystem           1K-blocks     Used Available Use% Mounted on
/dev/mapper/vg_db03-lv_root
                      45805980 27379400  16093092  63% /
```

`-Z` option to print each result on one line.
```console
$ pssh.sh -Z host1 host2 host3 host4 -- md5sum .ssh/authorized_keys
host1> e1ae16b5792f8c2d6e48e3f87644ddb8 .ssh/authorized_keys [0]
host2> e1ae16b5792f8c2d6e48e3f87644ddb8 .ssh/authorized_keys [0]
host3> a291238487811eb2cf85e12b4c1004ad .ssh/authorized_keys [0]
host4> e1ae16b5792f8c2d6e48e3f87644ddb8 .ssh/authorized_keys [0]
```

Brace expantion is useful to specify hostnames.
```console
$ pssh.sh -Z host{1..2}{1..2} -- uptime
host11> 11:46:16 up 30 days, 1:56, 0 users, load average: 0.36, 0.58, 0.63 [0]
host12> 11:46:16 up 30 days, 1:56, 0 users, load average: 0.37, 0.54, 0.59 [0]
host21> 11:46:16 up 30 days, 1:56, 0 users, load average: 0.40, 0.61, 0.61 [0]
host22> 11:46:16 up 30 days, 1:56, 0 users, load average: 0.52, 0.62, 0.64 [0]
```
