#!/usr/bin/expect
set timeout 3
send_user "\\n###############\\nAccessing\\n[IPV4]\\n###############\\n"

spawn ssh -i [RSA_KEY] root@[IPV4]

expect {
    timeout {
        expect {
            timeout {
                send_user "\\nLogin failed. RSA password incorrect.\\n"
                sleep 2
                exit 1
            }
        }
    }
    "Enter passphrase*" {
        send [RSA_PASS]\\r
        send_user "Logged in successfully!\\n"
        expect {
            "*:~# " {
                send "adduser [NEW_USER]\\r"
                send_user "\\nAdding user [NEW_USER]\\n"
                expect {
                    "*directory*exists.*" {
                        send_user "User directory exists\\n"
                        exp_continue
                    }
                    "*user*exists.*" {
                        send_user "User exists\\n"
                    }
                    "*password: " {
                        send "[USER_PASS]\\r"
                        send_user "setting password\\n"
                        exp_continue
                    }
                    "*[]: " {
                        send "\\r"
                        send_user "defaults\\n"
                        exp_continue
                    }
                    "*n] " {
                        send "y\\r"
                        send_user "confirming\\n"
                    }
                }
                expect "*:~# "
                send "usermod -aG sudo [NEW_USER]\\r"
                send_user "\\nGranting user sudo\\n"
                expect "*:~# "
                send "ufw allow OpenSSH\\r"
                send_user "\\nAdding SSH to firewall\\n"
                expect "*:~# "
                send "ufw --force enable\\r"
                send_user "\\nEnabling firewall\\n"
                expect "*:~# "
                send "rsync --archive --chown=[NEW_USER]:[NEW_USER] ~/.ssh /home/[NEW_USER]\\r"
                send_user "\\nConfiguring user SSH permissions\\n"
                expect "*:~# "
                send_user "\\nExiting\\n"
            }
        }
    }
    eof {
        send_user "\\nSSH failure for [IPV4]\\n"
        sleep 2
        exit 1
    }
    "*fingerprint*? " {
        send "yes\\r"
        send_user "\\nFirst time logging in\\nFingerprint added\\n"
        exp_continue
    }
}

send "exit\\r"
send_user "\\Proccess Complete!\\n"
close
