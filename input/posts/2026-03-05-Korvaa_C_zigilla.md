Title: Korvaa C zigilla
Tags: 
  - zig
---

## Korvaa C zigilla

Allekirjoittanut on vältellyt [C-koodin](https://fi.wikipedia.org/wiki/C_(ohjelmointikieli)) kirjoittamista jo vuosien ajan, johtuen sen erinäisistä ongelmista. Viime vuonna C:n [vaihtoehdoksi mainostettu](https://www.azalio.io/meet-zig-the-modern-alternative-to-c/) [zig](https://ziglang.org/)-ohjelmointikieli nosti nopeasti suosiotaan, ja alkaneen vuoden myötä päätin myös itse kokeilla ohjelmointia zigillä.

Kokeiluni päätin aloittaa kirjoittamalla aiemmin toteuttamastani Deno-komentorivityökalusta [zig-version](https://github.com/mcraiha/swagger-ui-single-file/tree/main/src/zig/cli).

### Plussat ➕

#### Testitapaukset

[Testitapausten suorittaminen](https://ziglang.org/learn/build-system/#testing) on sisäänrakennettu zigiin. Eli testitapaukset voi kirjoittaa suoraan `test`-lohkon sisään ja ajaa sitten 
```bash
zig test index.zig
```
yllä olevalla komennolla. Testitapaukset voi kirjoittaa suoraan koodin sekaan tai laittaa omaan tiedostoon.

#### Kääntäminen eri alustoille

CI/CD-aikakaudella zigin suuri etu on mahdollisuus tuottaa binäärejä [eri alustoille](https://ziglang.org/learn/build-system/#release) suoraan paketista. esim. Windowsille tarkoitetun binäärin saa käännettyä Linuxin puolelta tai päinvastoin. Tällöin omassa pilvessä ajettavassa CI/CD-alustassa riittää yksi käyttöjärjestelmä, eikä esim. **GitHub**in [matrix-strategioita](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations) tarvita kääntämistä varten.

#### Kattavahko standardikirjasto

C-ohjelmoinnin yksi suuri jarru nykypäivänä on hyvin rajoittunut standardikirjasto. Jos kaipaa esim. [JSON](https://ziglang.org/documentation/master/std/#std.json)-, [Base64](https://ziglang.org/documentation/master/std/#std.base64) tai [HTTP](https://ziglang.org/documentation/master/std/#std.http)-yhteensopivuutta niin nämä kaikki löytyvät vakiona zigin standardikirjastosta.

Lisäksi itse ohjelmointikieli pitää sisällään yleisimpiä ohjelmointitapauksia helpottavat geneeriset [ArrayList](https://zig.guide/standard-library/arraylist/)- ja [HashMaps](https://zig.guide/standard-library/hashmaps)-tietorakenteet.

#### Vähemmän vaarallisia ongelmia

Kääntäjänä zig [estää](https://ziglang.org/documentation/master/#Illegal-Behavior) monien ongelmallisten toteutusten tekemisen antamalla niistä käännösaikaisen virheen. Lisäksi monet ajonaikaiset virhetilanteet tuottavat suoraan paniikin ja lopettavat ohjelman suorittamisen, jolloin tietoturvan kannalta ongelmallisia bugeja pääsee tuotantoon huomattavasti vähemmän.

#### Ei makroja

Zigin osalta ei tueta makroja. Eli käyttäjän ei tarvitse arvailla millaista koodia kääntäjä saa mahdollisesti käsiteltäväksi. Käännösaikaisia toimintoja voi toteuttaa [comptime](https://ziglang.org/documentation/master/#comptime)-avainsanan avulla ja geneerisiä tietorakenteita varten tarjolla on käännösaikaiset [tyyppitiedot](https://ziglang.org/documentation/master/#Generic-Data-Structures).

#### Olemassa olevaa C-koodia voi hyödyntää suoraan

Jos tarkoitus on siirtää esim. olemassa oleva C-ohjelma zig-toteutukseksi, voi sen tehdä osissa. Zigin avulla on mahdollista kääntää ja käyttää [C-koodia](https://ziglang.org/documentation/master/#C), ja tietyissä tilanteissa oma nykyinen C-kääntäjä on mahdollista korvata kokonaan zigillä.

### Miinukset ➖

#### Liikkuva kohde

Sekä zig-ohjelmointikieli että sen standardikirjasto ovat tällä hetkellä vielä jatkuvassa muutostilassa. Ensimmäiset lukitukset tehdään 1.0-version julkaisun yhteydessä, mutta siihen on todennäköisesti matkaa vielä pari vuotta. Tämä tarkoittaa sitä, että nyt tehtyyn zig-koodiin saatetaan tulevaisuudessa tarvita pieniä muutoksia, jotta se kääntyy ja toimii.

#### Tietoturvaohjelmat eivät tykkää suurista kääntäjistä

Tätä tekstiä kirjoittaessa zigin 0.16.0-version käyttämän zig.exe:n tiedostokoko Windows-alustalla on hieman yli 170 megatavua. Monet Windowsilla käytettävät tietoturvaohjelmat eivät osaa käsitellä tuon kokoisia binääritiedostoja kovin nopeasti, joten välillä kääntäjän käynnistyminen odottelee tietoturvatarkistuksen valmistumista.

<span style="font-size:4em;">🛠️</span>