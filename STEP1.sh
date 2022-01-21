{
    echo '[PASSWORD]';
    echo '[PASSWORD]';
    sleep 1;
    echo '';
    sleep 1;
    echo '';
    sleep 1;
    echo '';
    sleep 1;
    echo '';
    sleep 1;
    echo '';
    sleep 1;
    echo 'y';
} | adduser [USER]

usermod -aG sudo [USER]
ufw allow OpenSSH
ufw --force enable

rsync --archive --chown=[USER]:[USER] ~/.ssh /home/[USER]
