#!/usr/bin/expect
set timeout 3
set longtime 60
send_user "\\n###############\\nAccessing\\n[IPV4]\\n###############\\n"

spawn ssh -i [RSA_KEY] [NEW_USER]@[IPV4]
expect {
    timeout {
        expect {
            timeout {
                send_user "\\nLogin failed. RSA password incorrect.\\n"
                exit 1
            }
        }
    }
    "Enter passphrase*" {
        send [RSA_PASS]\\r
        send_user "\\n Logged in successfully! \\n"
        expect {
            "[NEW_USER]@*" {
                send_user "\\n Getting su \\n"
                send "sudo ls \\r"
                expect "*assword*"
                send "[USER_PASS] \\r"
                # Fast expect
                expect "[NEW_USER]@*"
                send_user "\\n message \\n"
                send "command \\r"
                # Regular expect
                expect {
                    longtime {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for thing \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n message \\n"
                send "command \\r"
                # Special sequence expect
                expect {
                    longtime {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for thing \\n"
                        exp_continue
                    }
                    "*\\(A\\)ge*: " {
                        send_user "\\n Chose [OPTION] \\n"
                        send "[OPTION] \\r"
                    }
                    "[NEW_USER]@*" {
                        send_user "\\n Process exited \\n"
                    }
                }

                send_user "\\n Exiting \\n"
            }
        }
    }
    eof {
        send_user "\\n SSH failure for [IPV4] \\n"
        exit 1
    }
    "*fingerprint*? " {
        send yes\\r
        send_user "\\n First time logging in\\nFingerprint added \\n"
        exp_continue
    }
}

send "exit \\r"
send_user "\\n Proccess Complete! \\n"
close