# Nginx and Node.js server automated set up - includes subdomain server blocks

### You must have a domain name pointing at the ip addresss of your server with subdomain records

#
## Configuration
First open

```
$ NEW_SERVER.sh
```

```bash
 4| NEW_USER="user" #         <- User on the server
 5| USER_PASS="password" #    <- Server user password
 6| RSA_KEY="~/.ssh/TEST" #   <- Path to rsa private
 7| RSA_PASS="password" #     <- rsa password
 8| IPV4="000.000.000.000" #  <- Server ip address
 9| DOMAIN="hello.com" #      <- Domain pointing to said ip address
10| EMAIL="user@mail.com" #   <- Email for certbot
11| NODE_V="17" #             <- Node.js version
12| APP_V="0.0.1" #           <- Your app's version
13| AUTHOR="" #               <- Your name
```

 Update this array to match your dns subdomain records

```bash
14| SUBDOMAINS=("$DOMAIN www" "ftp" "api" "mail")
```
#
## Customizing Boilerplates
Edit the file
```
$ APP_STUB
```
#### The plugs ***[`DOMAIN`]***, ***[`VERSION`]***, ***[`PORT`]***, and ***[`AUTHOR`]*** are used to propagate the variables generated in the NEW_SERVER.sh script
#### Whatever you write here will be the boilerplaate code generated and uploaded for EACH app
```javascript
 1| // ------------------------------ //
 2| // -[DOMAIN] Server------ //
 3| // -V [VERSION]---------------------- //
 4| // -Author: [AUTHOR]------ //
 5| // ------------------------------ //
 6| 
 7| // ---------- Imports ---------- //
 8| const http = require('http')
 9| var express = require('express')
10| 
11| // ---------- Global Variables  ---------- //
12| const port = [PORT]
13| var app = express()
14| 
15| // ---------- Configuration ---------- //
16| app.use(express.urlencoded({ extended: false }))
17| app.use(express.json())
18| app.set(`json spaces`, 4)
19| 
20| // ---------- Endpoints ---------- //
21| app.get(`/`, (request, response) => {
22|     response.status(200).json({ domain: `[DOMAIN]` })
23| })
24| 
25| // ---------- Run ---------- //
26| app.listen(port, () => { console.log(`Server [DOMAIN] running on port ${port}`) })

```
#
## Customizing Server Blocks
Edit the file
```
$ SERVER_BLOCK
```
#### The plugs ***[`DOMAIN`]***, and ***[`PORT`]*** are used to propagate the variables generated in the NEW_SERVER.sh script
#### By default I've included the non default headers `X-Forwarded-For` and made each block proxy to the port specified in each app
```bash
 1| server {
 2|     server_name [DOMAIN];
 3|     location / {
 4|         proxy_pass http://localhost:[PORT];
 5|         proxy_http_version 1.1;
 6|         proxy_set_header Upgrade $http_upgrade;
 7|         proxy_set_header Connection 'upgrade';
 8|         proxy_set_header Host $host;
 9|         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
10|         proxy_set_header X-Forwarded-Proto $scheme;
11|         proxy_cache_bypass $http_upgrade;
12|     }
13| }
```
#
## Running
Set the permissions for your shell script
```
$ chmod +x NEW_SERVER.sh
```
Then run it
```
$ ./NEW_SERVER.sh
```
