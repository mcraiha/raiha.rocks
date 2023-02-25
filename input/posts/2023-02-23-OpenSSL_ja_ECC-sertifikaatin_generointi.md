Title: OpenSSL ja ECC-sertifikaatin generointi
Tags: 
  - OpenSSL
  - ECC
  - Sertifikaatti
---

## OpenSSL ja ECC-sertifikaatin generointi

Jossain tilanteissa on tarve luoda oma [ECC](https://fi.wikipedia.org/wiki/Elliptisten_k%C3%A4yrien_salausmenetelm%C3%A4t)-sertifikaatti esim. [JSON Web Token](https://fi.wikipedia.org/wiki/JSON_Web_Token) (JWT) -allekirjoituksia varten. Alla vaihteet, joiden avulla tämä onnistuu käyttämällä Linux-ympäristöistä yleensä vakiona löytyvää [OpenSSL](https://fi.wikipedia.org/wiki/OpenSSL)-komentorivityökalua.

### Yksityisen avaimen luonti (private key)

Yksityisen avaimen luonti ja tallentaminen `private-key.pem` -tiedostoon onnistuu seuraavalla komennolla

```bash
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem
```

luodun sisällön voi avata millä tahansa tekstieditorilla, tai tulostaa esim. konsoliin seuraavalla komennolla

```bash
cat private-key.pem
```

jolloin näkyviin tulee jotain seuraavanlaista

```
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEILcWg6JLvw+DeoZSHn1l0U87vJ74Be86Av5W76tnez6OoAoGCCqGSM49
AwEHoUQDQgAELwFS6Zz/th26FuR7BLKEAq9iyOn94PbsRhWsyZCXIxYA+8wh4Dug
x5ZvObg0L7TlKokSE56hMCp1L3rPRhjkVA==
-----END EC PRIVATE KEY-----
```

### Julkisen avaimen luonti (public key)

Julkisen avaimen luonti aiemmin luodusta yksityisestä avaimesta (ja julkisen avaimen tallentaminen `public-key.pem` -tiedostoon) onnistuu seuraavalla komennolla

```bash
openssl ec -in private-key.pem -pubout -out public-key.pem
```

luodun sisällön voi avata millä tahansa tekstieditorilla, tai tulostaa esim. konsoliin seuraavalla komennolla

```bash
cat public-key.pem
```

jolloin näkyviin tulee jotain seuraavanlaista

```
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEGVumyBG33N5z5yEOCzm+stvRjGYA
XUJS/t3VGE1P1PWK8pRWgaUXFgeyeg4lv4fpAeH9ACd2CZPF8urpgT6Nzg==
-----END PUBLIC KEY-----
```

### Sertifikaatin luominen

Sertifikaatin luominen aiemmin luodusta yksityisestä avaimesta onnistuu seuraavalla komennolla

```bash
openssl req -new -x509 -key private-key.pem -out cert.pem -days 365
```

tämän jälkeen pitää vastata useampaan kysymykseen mm. kaupungin ja organisaation osalta, ja lopulta käytettävissä pitäisi olla `cert.pem` -tiedosto. 

Tarvittaessa nämä kysymysten täyttämät parametrit voi antaa myös komentorivin kautta, jolloin komento voisi olla seuraavanlainen

```bash
openssl req -new -x509 -key private-key.pem -out cert.pem -days 365 -subj "/C=FI/ST=Uusimaa/L=Helsinki/O=TurvallisuusFirma/OU=IT-osasto/CN=example.com"
```

Myös tämän sertifikaatin voi avata haluamallaan tekstieditorilla tai tulostaa konsoliin seuraavalla komennolla

```bash
cat cert.pem
```

jolloin näkyviin tulee jotain seuraavanlaista

```
-----BEGIN CERTIFICATE-----
MIICPDCCAeGgAwIBAgIUB+4D3hswdbu1i0fDwuRboF61NCkwCgYIKoZIzj0EAwIw
czELMAkGA1UEBhMCRkkxEDAOBgNVBAgMB1V1c2ltYWExETAPBgNVBAcMCEhlbHNp
bmtpMRUwEwYDVQQKDAxUdXJ2YWxsaXN1dXMxEjAQBgNVBAsMCUlULW9zYXN0bzEU
MBIGA1UEAwwLZXhhbXBsZS5jb20wHhcNMjMwMjI1MDY1MjE4WhcNMjQwMjI1MDY1
MjE4WjBzMQswCQYDVQQGEwJGSTEQMA4GA1UECAwHVXVzaW1hYTERMA8GA1UEBwwI
SGVsc2lua2kxFTATBgNVBAoMDFR1cnZhbGxpc3V1czESMBAGA1UECwwJSVQtb3Nh
c3RvMRQwEgYDVQQDDAtleGFtcGxlLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEH
A0IABEpUtW5o14J9XLjlcFVYKvP2lnKAF6eS+b6McST4sWFBiBSv8Px5NfOZA7Tz
4HPlxS0zt+vY0duhvP21d+UjCoijUzBRMB0GA1UdDgQWBBR2+R495HzWdfvrkIWg
GuI2T62tSTAfBgNVHSMEGDAWgBR2+R495HzWdfvrkIWgGuI2T62tSTAPBgNVHRMB
Af8EBTADAQH/MAoGCCqGSM49BAMCA0kAMEYCIQCO+DsmbrxuTU/QmyDSxblG5ZL8
HlgLshT7eVvyuPOq1gIhAK1TL65ny7+kj5trSJo07ZZAiDm7cj8APMcfd6n+CVO9
-----END CERTIFICATE-----
```

<span style="font-size:4em;">🔏</span>