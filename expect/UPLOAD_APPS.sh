#!/usr/bin/expect
set timeout 9
send_user "\\n###############\\nAccessing\\n[IPV4]\\n###############\\n"

foreach subd {[SUBDOMAINS]} {
    spawn scp -i [RSA_KEY] ./apps/$subd.js [NEW_USER]@[IPV4]:~/$subd.js
    send_user "\\n Trying SCP \\n"
    expect {
        timeout {
            send_user "\\n Login failed.\\nRequest timed out. \\n"
            exit 1
        }
        "*assphrase*" {
            send [RSA_PASS]\\r
            send_user "\\n Logged in successfully! \\n"
            expect {
                "*100%*" {
                    send_user "\\n Success! \\n"
                }
            }
        }
        eof {
            send_user "\\n SCP failure for [IPV4] \\n"
            exit 1
        }
        "*fingerprint*? " {
            send yes\\r
            send_user "\\n First time logging in\\nFingerprint added \\n"
        }
    }
}

send_user "\\n Proccess Complete! \\n"
close