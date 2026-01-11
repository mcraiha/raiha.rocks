Title: Sisältöä OCR-kokeiluja varten
Tags: 
  - OCR
  - Tekstintunnistus
  - PDF
  - Ghostscript
---

## Sisältöä OCR-kokeiluja varten

Joskus vastaan voi tulla tarve kokeilla erilaisten **OCR**-toteutusten (Optical character recognition) eli  tekstintunnistuksen toimivuutta omilla sisällöillä. Aina käytettävissä ei kuitenkaan ole tarpeeksi kuvamuotoista tekstisisältöä, mutta onneksi sitä saa generoitua helposti. Alla käyn lyhyesti lävitse **Ghostscript**-ohjelman käyttämistä tähän tarpeeseen.

### Sanakirjan käyttö

Jos tarkoitus on käyttää tekstintunnistusta vain suomenkieliseen sisältöön, kannattaa käyttää OCR:n ohessa jotain sanakirjaa, jonka avulla on nopea huomata, jos OCR ei suoriutunut tehtävässään oikein. Valitettavasti esim. a/ä- ja o/ö-ongelmat (vaikkapa `välittää` vs. `valittaa` tai `säälistä` vs. `saalista`) eivät poistu täysin tällä tavalla, joten sanakirja ei suoraan ratkoa kaikkia ongelmia.

### Sopivat PDF-sisällöt

PDF:n osalta kannattaa kokeiluun valita dokumentteja, joissa teksti on oikeasti tekstimuotoista, eikä kuvina. Tämä sen takia, että Ghostscriptilla voidaan tuottaa eri resoluutiolla olevia kuvatiedostoja, jolloin vektoripohjainen teksti renderöidään tarkemmin kuviin, kuin mitä bittikarttapohjaisten tekstien kanssa. Täten sama PDF-tiedosto kannattaa muuttaa useiksi eri resoluutiolla oleviksi kuviksi, ja testata OCR-toteutusta niillä kaikilla.

### Ghostscript-asennus

Windowsilla Ghostscript asentuu esim. [asennuspaketin](https://www.ghostscript.com/releases/gxpsdnld.html) kautta. Windowsilla kannattaa asentaa 64-bittinen versio. Kun ohjelma on asennettu onnistuneesti, voi asennuksen onnistumisen tarkistaa ajamalla komentokehoittessa

```cmd
gswin64c
```
jonka pitäisi tulostaa jotain seuraavanlaista

>GPL Ghostscript 10.06.0 (2025-09-09)
>Copyright (C) 2025 Artifex Software, Inc.  All rights reserved.
>This software is supplied under the GNU AGPLv3 and comes with NO WARRANTY:
see the file COPYING for details.


komentoikkunasta pääsee pois `Ctrl + C` -näppäinyhdistelmällä

### PDF-tiedosto kuvatiedostoiksi

Käytän esimerkkinä Ouran julkaisemaa [PDF-tiedostoa](https://ouraring.com/blog/wp-content/uploads/2025/06/Oura-National-Healthcare-Systems-Whitepaper-2025-FINAL.pdf), koska siinä on sekaisin sekä kuvia että tekstiä. Esimerkissä se on nimetty `pressi.pdf`-nimellä.

```cmd
gswin64c -dNOPAUSE -sDEVICE=png16m -r600 -sOutputFile=ocr-%02d.png "pressi.pdf" -dBATCH
```
kyseinen komento luo siis .png-tiedoston (tiedostojen nimet ocr-01.png, ocr-02.png ...) jokaisesta PDF-tiedoston sivusta. **-r600**-asetuksella luotavien .png-tiedostojen resoluutio on luokkaa 12000 x 15333 pikseliä, ja suurten kuvien luomisen hitauden takia operaatiossa kestää yleensä muutama kymmenen sekuntia.

Jos haluat pienemmän resoluution tiedostoja, voit ajaa puolestaan alla olevan komennon, jossa kuvatiedostojen resoluutio on 1200 x 1533
```cmd
gswin64c -dNOPAUSE -sDEVICE=png16m -r60 -sOutputFile=ocrs-%02d.png "pressi.pdf" -dBATCH
```

Korkeampi resoluutio helpottaa yleensä merkittävästi OCR-prosessissa yleisten I/l/1-tunnistusongelmien kanssa, mutta samalla yhden sivun tarvitsema suoritusaika pitenee.

### Vertailua

Jos yllä olevien esimerkkien avulla tekee kahden eri resoluution PNG-tiedostot, ja vertaa niitä esim. ilmaisella [Tesseract.js](https://tesseract.projectnaptha.com/) -työkalulla, huomaa nopesti että korkeamman resoluution kuvat auttavat paremman OCR-lopputuloksen kanssa, mutta täydellinen tulos ei ole. Pienemmällä resoluutiolla *Illness*-sana osoittautuu liian vaikeaksi, ja molemmilla resoluutioilla otsikkona oleva *Executive Summary* ei tunnistu oikein.

<span style="font-size:4em;">🔍</span>