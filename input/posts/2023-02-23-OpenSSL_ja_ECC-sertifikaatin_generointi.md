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

tämän jälkeen pitää vastata useampaa kysymykseen mm. kaupungin osalta, ja lopulta käytettävissä pitäisi olla `cert.pem` -tiedosto. Myös tämän sertifikaatin voi avata haluamallaan tekstieditorilla tai tulostaa konsoliin seuraavalla komennolla

```bash
cat cert.pem
```

<span style="font-size:4em;">🔏</span>