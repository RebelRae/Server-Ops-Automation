#!/usr/bin/expect
set timeout 3
send_user "\\n###############\\nAccessing\\n[IPV4]\\n###############\\n"

spawn scp -i [RSA_KEY] /tmp/default [NEW_USER]@[IPV4]:~/default
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
        send_user "Logged in successfully!\\n"
        expect {
            "default" {
                send_user "\\nSuccess!\\n"
            }
        }
    }
    eof {
        send_user "\\nSCP failure for [IPV4]\\n"
        exit 1
    }
    "*fingerprint*? " {
        send yes\\r
        send_user "\\nFirst time logging in\\nFingerprint added\\n"
        exp_continue
    }
}

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
        send_user "Logged in successfully!\\n"
        expect {
            "[NEW_USER]@*" {
                send_user "\\nGetting su\\n"
                send "sudo ls\\r"
                expect "*assword*"
                send "[USER_PASS]\\r"
                expect "[NEW_USER]@*"
                send_user "\\nUpdating repos\\n"
                send "sudo apt update -y\\r"
                expect {
                    timeout {
                        send_user "\\nStill waiting for update\\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nInstalling nginx\\n"
                send "sudo apt install nginx -y\\r"
                expect {
                    timeout {
                        send_user "\\nStill waiting for install\\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nAdding HTTPS rule to ufw\\n"
                send "sudo ufw allow 'Nginx HTTP'\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nRemoving old HTTP\\n"
                send "sudo ufw delete allow 'Nginx HTTP'\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nCopying server blocks to default directory\\n"
                send "sudo cp ~/default /etc/nginx/sites-available/default\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nUpdating nginx hash bucket size\\n"
                send "cat /etc/nginx/nginx.conf | sed -e 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' > ~/settings\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nUpgrading write permissions\\n"
                send "sudo chmod g+w /etc/nginx/nginx.conf\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nCopying temp\\n"
                send "sudo cp ~/settings /etc/nginx/nginx.conf\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nDowngrading write permissions\\n"
                send "sudo chmod g-w /etc/nginx/nginx.conf\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nInstalling certbot\\n"
                send "sudo apt install certbot python3-certbot-nginx -y\\r"
                expect {
                    timeout {
                        send_user "\\nStill waiting for install\\n"
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nReloading nginx\\n"
                send "sudo systemctl reload nginx\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nUpgrading ufw rules for nginx\\n"
                send "sudo ufw allow 'Nginx Full'\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\n\\n"
                send "sudo ufw delete allow 'Nginx HTTP'\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                set CERTBOT_STRING "sudo certbot --nginx -d [DOMAIN]"
                foreach subd {[SUBDOMAINS]} {
                    append CERTBOT_STRING " -d $subd.[DOMAIN]"
                }
                send "$CERTBOT_STRING\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "*email address*"
                }
                send "[EMAIL]\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "*\\(A\\)gree*"
                }
                send "a\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "*\\(N\\)o*"
                }
                send_user "\\n\\n"
                send "n\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "*appropriate number*"
                }
                send_user "\\n\\n"
                send "2\\r"
                expect {
                    timeout {
                        exp_continue
                    }
                    "[NEW_USER]@*"
                }
                send_user "\\nRestarting nginx\\n"
                send "sudo systemctl restart nginx\\r"
                send_user "\\nExiting\\n"
            }
        }
    }
    eof {
        send_user "\\nSSH failure for [IPV4]\\n"
        exit 1
    }
    "*fingerprint*? " {
        send yes\\r
        send_user "\\nFirst time logging in\\nFingerprint added\\n"
        exp_continue
    }
}

send "exit\\r"
send_user "\\Proccess Complete!\\n"
close