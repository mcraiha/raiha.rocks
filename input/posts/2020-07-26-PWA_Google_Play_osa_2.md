Title: PWA Google Play -kauppaan osa 2.
Tags: 
  - SPA
  - PWA
  - Google Play
---

## PWA Google Play -kauppaan, osa 2.

[Edellisessä kirjoituksessa](/posts/PWA_Google_Play_osa_1.html) kerroin, kuinka [Progressive web application](https://www.itewiki.fi/opas/progressive-web-application-pwa-progressiivinen-verkkosovellus/) -sovelluksesta (PWA) saa tehtyä [Android application package](https://fi.wikipedia.org/wiki/APK) (APK) -tiedoston. Tässä osassa tarkistellaan APK:n lähettämistä Google Playihin ja [assetlinks.json](https://developer.android.com/training/app-links/verify-site-associations)-tiedoston luontia.

### APK lähettäminen Google Playihin

Kun .apk-tiedosto on ladattu/luotu, on aika laittaa se Google Playihin. Siirrytään siis selaimella Google Playn [julkaisupuolelle](https://play.google.com/apps/publish) ja valitaan **Publish an Android App On Google Play** -valinta.

![Google Play Publish an Android App](../images/google_play_publish_android_app.png)

#### Perustiedot kuntoon

Ensimmäiseksi valitaan sovelluksen oletuskieli ja annetaan sovellukselle nimi. Tässä tapauksessa koska [Tarjouspohja](https://tarjous.raiha.rocks/)-sovellus on tarkoitettu vain suomenkielisille käyttäjäille, on luonnollista valita oletuskieleksi suomi.

![Google Play kieli ja otsikko sovellukselle](../images/google_play_publish_01.png)

Sitten täytetään mm. sovelluksen kuvaus, valitaan haluttu ikoni, valitaan sovelluksen kategoria jne. Tähän kohtaan kannattaa valita runsaasti aikaa, jos kyseessä on ensimmäinen kerta, kun sovellusta laittaa Google Playhin, koska täytettävää on paljon. Kaikkea tietoa ei tarvitse syöttää kerralla, vaan **Save Draft** -napilla senhetkisen tilanteen voi tallentaa, ja jatkaa tietojen syöttämistä myöhemmin.

![Google Play sovelluksen kuvaustekstit](../images/google_play_publish_02.png)

![Google Play sovelluksen graafiset tiedostot](../images/google_play_publish_03.png)

![Google Play sovelluksen kategoria](../images/google_play_publish_04.png)

#### Internal test

Kun Google Playn kaipaamia tietoja sovelluksesta on syötetty tarpeeksi (kaikki kohdat pitää täyttää vasta ennen virallisen version julkaisua), lähetetään varsinainen .apk-tiedosto Google Playn tarkistukseen **App Releases** -osion kautta. Aluksi kannattaa valita **Internal test**, koska sen avulla sovellus tulee ladattavaksi vain omiin laitteisiin, jolloin on mahdollista tarkistaa, että kaikki toimii oikein.

Internal test ei siis vaadi kaikkien sovellustietojen täyttämistä, eikä pidempää Googlen tarkistusprosessia .apk-tiedostolle

![Google Play internal test](../images/google_play_publish_08.png)

Tärkein asia on .apk-tiedoston valinta. Koska PWA Builderin tekemä .apk-tiedosto on noin megatavun kokoinen, siirtyy se nopeasti Google Playn palvelimille, ja jos .apk-tiedostossa ei ole suoranaista ongelmaa, voi sen laittaa sisäisen testausporukan ladattavaksi alhaalta löytyvän **Review**-napin kautta.

![Google Play internal test APK valinta](../images/google_play_publish_09.png)

#### Varsinainen julkaisu

Varsinainen julkaisu (jossa kuka tahansa voi ladata sovelluksen Google Playstä) tapahtuu **Release**-osion kautta. Seuraavaksi valitaan miten allekirjoitusavainten kanssa toimitaan, ja tässä kohtaa annan Googlen hallita allekirjoitusavaimia, jolloin minun ei tarvitse itse murehtia niistä jatkossa, kunhan vain allekirjoitan lähetettävät .apk-tiedostot samalla avaimella kuin tein ensimmäisen julkaisun yhteydess.

![Google Play allekirjoitusavaimen hallinta](../images/google_play_publish_05.png)

![Google Play uusi julkaisu](../images/google_play_publish_06.png)

Jokaisen julkaisun yhteyteen voi lisätä tietoja kyseisestä julkaisusta, jotka kertovat käyttäjille mitä tässä versiossa on muutettu

![Google Play julkaisun muutoshistoria](../images/google_play_publish_07.png)

Ku