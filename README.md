# Docker container demonstrating Samba's Active Directory Domain Controller (AD DC) support

To run this image you will need to

# Build the Docker image

```
docker build -t samba-ad-dc .
```

# Run the Docker image

```
docker run --rm -e "SAMBA_DOMAIN=SAMDOM" -e "SAMBA_REALM=SAMDOM.EXAMPLE.COM" -e "ROOT_PASSWORD=ia4uV1EeKait" -e "SAMBA_ADMIN_PASSWORD=ia4uV1EeKait" --name dc1 --dns 127.0.0.1 -d -p 53:53 -p 53:53/udp -p 389:389 -p 88:88 -p 135:135 -p 139:139 -p 138:138 -p 445:445 -p 464:464 -p 3268:3268 -p 3269:3269 samba-ad-dc
```

* Note: You can change the value of the variables `SAMBA_REALM`, `ROOT_PASSWORD` and `SAMBA_ADMIN_PASSWORD` per the  value that you would like.

# Configure the DNS entries of the network interface

Configure the DNS entries of the network interface to use `127.0.0.1` as the first entry. The second one could be the value which is currently set-up - usually the IP of the reouter or customized DNS servers like 8.8.8.8

Once this is done the `nslookup` requests against the `ldap` and `gc` catalog should work. 

```
$ nslookup -q=SRV _ldap._tcp.samdom.example.com
Server:		127.0.0.1
Address:	127.0.0.1#53

_ldap._tcp.samdom.example.com	service = 0 100 389 dc1.samdom.example.com.
```

```
$ nslookup -q=SRV _gc._tcp.samdom.example.com
Server:		127.0.0.1
Address:	127.0.0.1#53

_gc._tcp.samdom.example.com	service = 0 100 3268 dc1.samdom.example.com.
```

# Perform an user lookup

Directly run on you terminal

```
ldapsearch -LLL -H ldap://samdom.example.com -b "DC=samdom,DC=example,DC=com" -D "CN=admin,DC=samdom,DC=example,DC=com" -w "ia4uV1EeKait" "(& (sAMAccountName=<userid>)(objectCategory=user))"
```

In case, it does not work you could perform the same `lookup` inside the docker container

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                                                                                                                                                                                                        NAMES
ab0fc8a022ca        samba-ad-dc         "/init.sh app:start"   30 minutes ago      Up 30 minutes       0.0.0.0:53->53/tcp, 0.0.0.0:88->88/tcp, 0.0.0.0:135->135/tcp, 0.0.0.0:138-139->138-139/tcp, 0.0.0.0:389->389/tcp, 0.0.0.0:445->445/tcp, 0.0.0.0:464->464/tcp, 22/tcp, 0.0.0.0:3268-3269->3268-3269/tcp, 0.0.0.0:53->53/udp   dc1
$ docker exec -it ab0fc8a022ca bash
```


# Health checks

## Check that the Docker container is still running in daemond mode

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                                                                                                                                                                                                        NAMES
ab0fc8a022ca        samba-ad-dc         "/init.sh app:start"   21 minutes ago      Up 21 minutes       0.0.0.0:53->53/tcp, 0.0.0.0:88->88/tcp, 0.0.0.0:135->135/tcp, 0.0.0.0:138-139->138-139/tcp, 0.0.0.0:389->389/tcp, 0.0.0.0:445->445/tcp, 0.0.0.0:464->464/tcp, 22/tcp, 0.0.0.0:3268-3269->3268-3269/tcp, 0.0.0.0:53->53/udp   dc1
```

## Check last lines of docker logs

Check that the latest lines of the Docker logs contains the lines below


```
$ docker logs ab0fc8a022ca
... 
2018-09-25 18:40:39,524 INFO spawned: 'syslog' with pid 44
2018-09-25 18:40:39,526 INFO spawned: 'bind9' with pid 45
2018-09-25 18:40:40,686 INFO success: sshd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:40,686 INFO success: samba entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:40,686 INFO success: sssd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:40,686 INFO success: kerberos entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:40,686 INFO success: custom entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:40,686 INFO success: syslog entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:40,686 INFO success: bind9 entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2018-09-25 18:40:42,975 INFO exited: custom (exit status 0; expected
```





