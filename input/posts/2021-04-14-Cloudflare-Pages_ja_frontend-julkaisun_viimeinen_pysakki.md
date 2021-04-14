Title: Cloudflare Pages ja frontend-julkaisun viimeinen pysäkki
Tags: 
  - GitHub
  - Cloudflare Pages
---

## Cloudflare Pages

[Cloudflare](https://www.cloudflare.com/) esitteli viime vuonna [Jamstack](https://en.wikipedia.org/wiki/Jamstack)-kehittäjille tarkoitetun [Pages](https://pages.cloudflare.com/)-tuotteen beta-version. Tällä viikolla tuote avattiin kaikelle kansalle, ja allekirjoittanut päätti kokeilla sitä.

## Pages pähkinänkuoressa

Pages on yhdistelmä CI/CD-toiminnoista, sisällön jakelusta ja CDN-toiminnoista. Nykyisellään sen avulla on mahdollista valita oma **GitHub**-projekti, jonka Pages kääntää/rakentaa valmiiksi halutuilla komennoilla ja laittaa sitten jakeluun Cloudflaren omille palvelimille. Tämän jälkeen kuka tahansa voi vierailla sivustolla selaimellaan (tarvittaessa pääsyn voi myös rajoittaa tietylle kohderyhmälle).

Käytännössä palvelu siis huolehtii frontend-julkaisusta kokonaan, jolloin kehittäjille jää tehtäväksi vain frontendin toteuttaminen.

## Kustannukset

Tarkan kulukuurin ihmisille Pages on erinomainen tuote, koska ilmainen taso tarjoaa 500 sivustorakennusta kuukaudessa, rajoittamattoman liikennöinnin ja ilmaisen levytilan. Täten esim. oman blogin pyörittäminen sen kautta ei maksa mitään.

Yrityskäyttöön on tarjolla lisäksi Pro- ja Business-tasot, jotka mahdollistavat useamman sivuston samanaikaisen rakentamisen ja nostavat kuukausittaiset rakennusmäärät tuhansiin.

## Domainit

Oletuksena omat projektit päätyvät **pages.dev**-domainin alle, mutta jos olet ostanut omat domainit Cloudflaren kautta, voit käyttää sivustollasi haluamaasi alidomainia, joka on sinun hallussasi.

## Oma projekti, eli webcount tuotantoon

Tein viime vuonna kokeilumielessä Denolla merkkilaskurin, jota voi kokeilla nyt siis osoitteessa [webcount.pages.dev](https://webcount.pages.dev), mutta kannattaa huomioida että merkkilaskuri on monelta tekniseltä osin vielä hyvin raakile. Sen pitäisi kuitenkin latautua nopeasti kaikilla alustoilla, riippumatta siitä missäpäin maailmaa käyttäjä on.

## Plussat

Itsellä homman suurin etu on siinä, että AWS S3:a ei tarvitse enää käyttää levytilana. Tämä nopeuttaa huomattavasti uusien projektien luomista, koska jokaista uutta sivustoa varten ei tarvitse enää säätää asetuksia AWS:n kautta.

Ilmaiset liikennöintikustannukset ovat myös mukava asia, jos sivusto tarjoaa esim. paljon kuvia, jolloin ei tarvitse murehtia hosting-kuluista.

Pagesilla on myös mahdollista julkaista jo valmista staattista sisältöä (esim. HTML-sivuja), joten se on helppo integroida mukaan tiettyihin vanhempiin sivustototeutuksiin.

## Miinukset

Toistaiseksi varsinkin CI/CD-toimintojen käyttöönotto voi olla Pagesissa hankalaa, jos oma kehitysympäristö ei löydy valmiiksi [tuettujen listalta](https://developers.cloudflare.com/pages/platform/build-configuration#language-support-and-tools). Tällä hetkellä ainoa tuettu virtuaalikone on **Ubuntu**-pohjainen, johon voi kuitenkin onneksi asentaa haluamiaan ohjelmia (esim. deno ei ole oletuksena tuettu). Ohjelmien asentaminen uudelleen jokaisella rakentamiskerralla hidastaa kuitenkin julkaisua selvästi, joten esim. testaus kannattaa pääsääntöisesti hoitaa jonkun nopeamman palvelun avulla.

Pagesilla ei myöskään ole kunnollista ominaisuus/kehitysseurantaa, joten uusien ominaisuuksien ehdottaminen ja nykyisten ominaisuuksien päivittymistä on hankala seurata.