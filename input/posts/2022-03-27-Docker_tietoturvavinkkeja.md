Title: Dockeriin tietoturvavinkkejä
Tags: 
  - Docker
  - Tietoturva
---

## Dockeriin tietoturvavinkkejä

Asia joka tulee välillä esiin [Docker](https://en.wikipedia.org/wiki/Docker_(software))iin liittyvissä keskusteluissa on Dockerin tietoturvapuoli. Olen listannut alle muutaman yleisimmän huomion, joiden avulla saa vältettyä yleisimmät tietoturvaongelmat ja samalla parannettua omien konttien tietoturvaa.

### Vältä root-oikeuksia

Docker laittaa oletuksena kontin sisällön ajettavaksi [root](https://www.linux.fi/wiki/Root)-oikeuksilla. Tästä voi tulla ongelma, jos hyökkääjä pääsee ajamaan kontissa omaa koodiaan, sillä root-oikeuksien myötä hyökkääjä pääsee mm. asentamaan kontin sisällä lisää ohjelmia ja muokkaamaan/lukemaan tiedostoja.

Ongelmaan on onneksi helppo ratkaisu, sillä konttien kohdalla voidaan [Dockerfile](https://docs.docker.com/engine/reference/builder/)-tiedostossa määrittää uusi käyttäjä [USER](https://docs.docker.com/engine/reference/builder/#user)-komennolla. Tämän jälkeen esim. [RUN](https://docs.docker.com/engine/reference/builder/#run)- ja [CMD](https://docs.docker.com/engine/reference/builder/#cmd)-komennot suoritetaan kyseisen käyttäjän oikeuksilla.

USER:ia käyttäessä kannattaa huomioida, että ennen kyseistä komentoa tehdyt komennot Dockerfilessä ovat suoritettu ROOT-oikeuksilla, joten uudella käyttäjällä ei välttämättä ole oikeuksia lukea kaikkia tiedostoja. Lisäksi monissa järjestelmissä tavalliset käyttäjät eivät välttämättä pysty luomaan verkkopalveluita, joiden porttinumero on alle 1024.

Oman kontin tilanteen voi ajonaikaisesti tarkistaa helposti Linux-käyttöjärjestelmissä `whoami` -komennolla, joka kertoo mikä käyttäjä ajaa komentoja.

### Käytä ajantasaista pohjaa ja päivitä kontin käyttöjärjestelmä pakettienhallinnan kautta

Koska useimmat rakentavat omat konttinsa muiden jo olemassa olevien konttien päälle, kannattaa aika ajoin tarkitella onko tämä oman projektin pohjana toimiva kontti päivittynyt uuteen versioon. Jos oman kontin rakentaa omalla koneella, kannattaa myös tarkistella minkä pohjakontin tagin päälle se rakentuu, koska esim. `build`-komento ei lataa automaattisesti mahdollisesti päivittynyttä imagea, vaan pakotuksen saa päälle **--pull** -parametrin avulla.

Linux-jakeluiden kohdalla pakettienhallinnan oma päivityskomento (esim. Ubuntu/Debian-maailmassa `apt-get update && apt-get -y upgrade`) kannattaa myös suorittaa erikseen, jotta kaikki tarvittavat paketit päivittyvät.

### Valitse yksinkertaisin mahdollinen pohja

Monessa tapauksessa kontin on tarkoitus ajaa vain yhtä komentoa. Tätä ajatellen kannattaa valita oman kontin pohjaksi mahdollisimman yksinkertainen kontti. Yksi suosittu valinta Linuxien osalta on [Alpine](https://alpinelinux.org/), jossa on koetettu pitää ylimääräiset toiminnot minimissään. Alpinen suurin hidaste käyttöönoton kannalta monissa projekteissa on se, että sen käyttämä [musl](https://en.wikipedia.org/wiki/Musl)-kirjasto ei ole suoraan yhteensopiva esim. [glibc](https://en.wikipedia.org/wiki/Glibc)-kirjaston kanssa käännettyjen ohjelmien kanssa.

Monet suositut Docker-kontit löytyvät onneksi Alpinen päälle rakennettuina (esim. **python** ja **node**), jolloin omaa aikaa ei tarvitse käyttää mahdollisten yhteensopivuusongelmien korjaamiseen.

### Erottele build- ja run-ympäristöt

Monien käännettävien ohjelmointikielien osalta kääntäjän sisältävää imagea ei kannata käyttää käännetyn ohjelman suorittamiseen, vaan kääntämiseen käytettävä image määritetään Dockerfilen `FROM`-komentoon **AS** -parametrin kera. Tämän jälkeen voidaan valita uusi käännettävän ohjelman suoritukseen käytettävä image, jonka sisälle juuri käännetty ohjelma kopioidaan COPY-komennolla.

Tällä ratkaisulla käännösvaiheessa mahdollisesti tarvittavat ylimääräiset työkalut eivät päädy mukaan ajettavaan konttiin, jolloin mahdollisella hyökkääjällä on vähemmän keinoja käytössään.

Esimerkiksi **dotnet** tarjoaa kääntämiseen erillisen [SDK](https://hub.docker.com/_/microsoft-dotnet-sdk)-imagen ja käännettyjen ohjelmien suorittamiseen oman [runtime](https://hub.docker.com/_/microsoft-dotnet-runtime/)-imagen. Asian parempaa ymmärtämistä varten kannattaa kurkistaa **Microsoft**in oman esimerkkiohjelman [Dockerfile](https://github.com/dotnet/dotnet-docker/blob/main/samples/dotnetapp/Dockerfile.alpine-x64)-tiedosto.

### Skannaa konttien tietoturvatilannetta

Koska Docker-konttien käsittely on sopivilla työkaluilla kohtuullisen vaivatonta, on tarjolla lukuisia tietoturvatyökaluja, joiden avulla voi tutkiskella imagen tietoturvatilannetta. Yksi tällainen työkalu on avoimen lähdekoodin [trivy](https://github.com/aquasecurity/trivy), joka koettaa etsiä imagen sisällä mahdollisesti kyteviä tietoturvaongelmia. 

Jos trivy löytää ongelmia, listaa se niistä mm. CVE-tunnisteet ja ongelman korjaavan päivityksen versionumeron.

Asennuksen jälkeen trivyn käyttö onnistuu suoraan komentoriviltä esimerkiksi alla olevaa komentoa mukaillen
```
trivy image python:3.4-alpine
```

Asioiden automatisointia ajatellen trivy kannattaa integroida osaksi omaa CI/CD-linjastoa, jolloin mahdollisista ongelmista saa näppärästi suoraan palautteen.

<span style="font-size:4em;">🔐</span>