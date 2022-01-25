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
            "Enter passphrase*" {
                send [RSA_PASS]\\r
                send_user "Logged in successfully!"
                expect {
                    "*:~# " {
                        send "rm -r  /home/[NEW_USER]\\r"
                        send_user "\\nRemoving user [NEW_USER] home directory\\n"
                        expect "*:~# "
                        send "userdel [NEW_USER]\\r"
                        send_user "\\nDeleting user\\n"
                        expect "*:~# "
                        send_user "\\nDone\\n"
                    }
                }
            }
        }
    }
    eof {
        send_user "\\nSSH failure for [IPV4]\\n"
        sleep 2
        exit 1
    }
    "*fingerprint*? " {
        send yes\\r
        send_user "First time logging in\\nFingerprint added"
    }
}

send "exit\\r"
send_user "\\Proccess Complete!\\n"
close
