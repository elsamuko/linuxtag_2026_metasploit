# Metasploit

* https://owasp.org/Top10/2025/
    * A01:2025 - Broken Access Control
    * A05:2025 - Injection

## Usage

## Information Gathering -- Scanner

```bash
search path:auxiliary/scanner ssl
# search type:auxiliary tls -S scanner
use auxiliary/scanner/ssl/ssl_version
options
set RHOSTS localhost
set RPORT 5005
set SSLVersion TLSv1.2
set VERBOSE 1
set ConnectTimeout 20
run
```

```bash
use auxiliary/scanner/http/crawler
set RHOSTS localhost
set RPORT 5005
set SSL true
run
```

```bash
use auxiliary/scanner/http/dir_scanner
set RHOSTS localhost
set RPORT 5005
set SSL true
run
```
* bigger wordlists at https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content

## Alternatives

* nmap
* gobuster
* sqlmap

### dirsearch

