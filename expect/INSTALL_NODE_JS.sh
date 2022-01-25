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
                send "sudo ls\\r"
                expect "*assword*"
                send "[USER_PASS]\\r"
                # Fast expect
                expect "[NEW_USER]@*"
                send_user "\\n Downloading Node.js [NODE_V] \\n"
                send "curl -sL https://deb.nodesource.com/setup_[NODE_V].x -o nodesource_setup.sh\\r"
                
                expect "[NEW_USER]@*"
                send_user "\\n message \\n"
                send "sudo bash nodesource_setup.sh\\r"

                expect {
                    longtime {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for shell script \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n Installing Node.js [NODE_V] \\n"
                send "sudo apt-get install -y nodejs\\r"

                expect {
                    longtime {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for Node.js install \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n Installing build-essential \\n"
                send "sudo apt-get install build-essential -y\\r"

                expect {
                    120 {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for build-essential install \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n Installing PM2 \\n"
                send "sudo npm install pm2@latest -g\\r"

                expect {
                    120 {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for PM2 install \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n Initializing NPM \\n"
                send "npm init -y\\r"

                expect {
                    120 {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for NPM init \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n Initializing NPM \\n"
                send "npm install express -y\\r"

                expect {
                    120 {
                        send_user "\\n There was an issue with the server \\n"
                        exit 1
                    }
                    timeout {
                        send_user "\\n Still waiting for NPM init \\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                # 
                foreach subd {[SUBDOMAINS]} {
                    send_user "\\n PM2 starting $subd.js \\n"
                    send "pm2 start $subd.js -f\\r"
                    expect "[NEW_USER]@*"
                }
                # 
                send_user "\\n Running startup PM2 \\n"
                send "pm2 startup systemd\\r"

                expect "[NEW_USER]@*"
                send_user "\\n Adding startup to PATH \\n"
                send "sudo env PATH=\\$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u [NEW_USER] --hp /home/[NEW_USER]\\r"

                expect "[NEW_USER]@*"
                send_user "\\n save \\n"
                send "pm2 save\\r"

                expect "[NEW_USER]@*"
                send_user "\\n Starting as a service \\n"
                send "sudo systemctl start pm2-[NEW_USER]\\r"

                # expect "[NEW_USER]@*"
                # send_user "\\n message \\n"
                # send "command\\r"
                
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

send "exit\\r"
send_user "\\n Proccess Complete! \\n"
close