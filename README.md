# sak\_github


# SSH Authorized Keys via Github  

```
echo "Defaults env_keep += SSH_AUTH_SOCK" | sudo tee /etc/sudoers.d/00_SSH_AUTH_OK
sudo chmod 0440 /etc/sudoers.d/00_SSH_AUTH_OK
```

```
patch -d/ -p0 <<EOF
--- /etc/pam.d/sudo     2022-02-08 08:47:08.000000000 +0000
+++ /etc/pam.d/sudo     2022-06-23 04:36:00.782581850 +0000
@@ -5,6 +5,7 @@

 session    required   pam_env.so readenv=1 user_readenv=0
 session    required   pam_env.so readenv=1 envfile=/etc/default/locale user_readenv=0
+auth [success=3 default=ignore] pam_ssh_agent_auth.so authorized_keys_command=/usr/local/bin/sak_github.sh %u

 @include common-auth
 @include common-account

EOF
```

```
patch -d/ -p0 <<EOF
--- /etc/ssh/sshd_config        2022-06-22 07:15:56.792514187 +0000
+++ /etc/ssh/sshd_config        2022-06-23 04:39:21.328188930 +0000
@@ -42,8 +42,8 @@

 #AuthorizedPrincipalsFile none

-#AuthorizedKeysCommand none
-#AuthorizedKeysCommandUser nobody
+AuthorizedKeysCommand /usr/local/bin/sak_github.sh %u
+AuthorizedKeysCommandUser nobody

 # For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
 #HostbasedAuthentication no

EOF
```

