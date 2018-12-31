Title: Staattisten sivujen luonti Wyamilla
Tags: 
  - staattiset sivut
  - Wyam
  - dotnet
---
## Yleistä löpinää

Monet ohjelmointikeskeiset ihmiset tykkäävät välttää visuaalisten työkalujen käyttöä tuottaessaan sisältöä, jonka vuoksi internet on täynnä [erilaisia ohjelmia](https://www.staticgen.com/) staattisten internet-sivujen (ts. HMTL-tiedostojen) luomiseen.

Itse pidän paljon näistä työkaluista, koska ne mahdollistavat mm. blogisisällön luonnin näppärästi komentorivin ja halutun tekstieditorin kanssa. Aiemmin olen käyttänyt [Jekylliä](https://jekyllrb.com/), mutta koska Ruby on minulle täysin vieras ohjelmointiympäristönä (ja Rubyn Windows-tuki on hieman kehno moneen muuhun ympäristöön verrattuna), päätin siirtyä nyt tutulla C#:lla toteutettuun [Wyamiin](https://wyam.io/).

Monet staattiset sivugeneraattorit toimivat pitkälti samalla tavalla:

1. Luodaan uusi sivupohja (valitaan tässä yhteydessä mahdollisesti teema, ja säädetään muutamia asetuksia)
2. Tuotetaan sisältöä esim. [Markdown](https://en.wikipedia.org/wiki/Markdown)-muotoisina dokumentteina
3. Generoidaan HTML-sivut sopivalla komennolla


## Käyttöönotto

Myös Wyam toteuttaa edellisen osion lopussa esitetyn toimintavan, joten sen kanssa toimittaisiin seuraavalla tavalla:


### Asennus

Koska Wyam on nykyään .NET Core -yhteensopiva työkalu, voi sen asentaa seuraavalla komennolla

```powershell
dotnet tool install -g Wyam.Tool
```

asennuksessa menee jokin tovi, ja Wyamin voi asentaa Windowsin ohella Mac- ja Linux-käyttöjärjestelmiin.

Asennuksen jälkeen Wyam on komentorivityökalu, joten sitä voi käyttää komentorivin kautta tai tehdä esim. .bat-tiedostot helpottamaan elämää


### Uuden blogin luonti

Aluksi siirrytään haluttuun kansioon, jonka jälkeen ajetaan seuraava komento

```powershell
wyam new -r Blog
```

pienen odottelun jälkeen kyseiseen kansioon pitäisi ilmaantua useampi Wyamin tiedosto ja mm. *input*-kansio, jonne oma sisältö sijoitetaan.


### Sisällön tuottaminen

Varsinaiset blogikirjoitukset sijoitetaan *input/posts*-kansioon. Helpointa on nimetä jokainen blogipostaus *VUOSI-KUUKAUSI-PÄIVÄ-Blogikirjoituksen_nimi.md*-tavalla (esim. tämän blogikirjoituksen tiedostonimi on *2018-12-31-Staattisten_sivujen_luonti_wyamilla.md*), jolloin Wyam osaa poimia blogikirjoituksen päivämäärän suoraan tiedostonimestä.


### HTML-tiedostojen generointi

Kun sisältöä on tuotettu, voidaan HTML-sivut generoida seuraavalla komennolla

```powershell
wyam -r Blog -t CleanBlog
```

ja jos kaikki menee putkeen, löytyy *output*-kansiosta kasa tiedostoja, jotka voidaan siirtää esim. omalle HTTP-palvelimelle muiden katseltaviksi.

Komennossa oleva *-t CleanBlog* -osio viittaa teemaan, jonka perusteella blogin ulkoasu rakentuu. Kyseinen [CleanBlog](https://wyam.io/recipes/blog/themes/cleanblog) -teema on Wyamin ns. oletusteema.

Generointi pitää suorittaa mahdollisten muokkausten ja lisäysten jälkeen aina uudelleen.


### Sivujen tarkastelu paikallisella koneella

Koska Markdown -> HTML -muunnos tuottaa välillä yllättäviä ongelmia, kannattaa sisältöä tarkastella silmämääräisesti läpi ennen sen julkaisua. Tämä onnistuu käynnistämällä paikallinen HTTP-palvelin seuraavalla komennolla

```powershell
wyam preview
```

ja avaamalla selaimessa osoite [http://localhost:5080](http://localhost:5080)

Esikatselun voi lopettaa komentorivillä **Ctrl+C** -näppäinyhdistelmällä.

### Asetuksia

Monia generointiin liittyviä asetuksia voi muuttaa muokkaamalla [config.wyam](https://wyam.io/recipes/blog/settings)-tiedostoa. Tiedostoon kannattaa laittaa ainakin oman blogin verkko-osoite, nimi ja kuvaus. Alla esimerkki tästä blogista

```
Settings[Keys.Host] = "mc.raiha.rocks";
Settings[BlogKeys.Title] = "Mc Raiha rocks!";
Settings[BlogKeys.Description] = "Pilviä, pelejä ja kiviä";
```
