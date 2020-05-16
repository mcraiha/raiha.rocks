Title: DocFX ja C#-projektin dokumentoinnin luonti
Tags: 
  - DocFX
  - C#
  - dokumentointi
---

## DocFX ja C#-projektin dokumentoinnin luonti

Joskus omassa ohjelmistoprojektissa tulee tarve koodin kommenteista ja metodeista luotavalle dokumentaatiolle. Eri ohjelmointikielissä ja -ympäristöissä on erilaisia tapoja ratkoa tämä asia, ja tässä kirjoituksessa esittelen helpohkon tavan C#-projektien osalta.

### DocFX

[DocFX](https://dotnet.github.io/docfx/) on **Microsoft**in oma työkalu, jonka avulla olemassa olevista C#-projekteista saa luotua dokumentaation. DocFX toimii Windows, Linux ja Mac OS -käyttöjärjestelmillä (Linuxilla ja Mac OS:n kanssa [mono](https://www.mono-project.com/) on asennettava), ja koska kyseessä on komentorivityökalu, on se helppo automatisoida erilaisissa pilviympäristöissä.

DocFX kaivaa tarvittavat tiedot projektista, ja luo siitä halutun [teeman](https://dotnet.github.io/docfx/templates-and-plugins/templates-dashboard.html) mukaisen HTML-dokumentaation. Tämän dokumentaation voi sitten vaikkapa laittaa mukaan projektin versionhallintaan, tai halutessaan julkisille internet-sivuille.

#### Asennus

DocFX on helpoin [asentaa](https://dotnet.github.io/docfx/tutorial/docfx_getting_started.html#2-use-docfx-as-a-command-line-tool) joko **Chocolatey**n tai **Homebrew**in avulla. 
```bash
choco install docfx -y
```
tai
```bash
brew install docfx
```

Vaihtoehtoisesti [asennuspaketin](https://github.com/dotnet/docfx/releases) voi ladata manuaalisesti GitHubin Release-osiosta ja purkaa paikalliselle koneelle haluttuun hakemistoon (tässä kohtaa järjestelmän PATH:iin kannattaa lisätä polku DocFX:n kansioon).

#### Käyttöönotto

DocFX:n käyttöönotto tapahtuu komentorivin kautta. Aluksi siirrytään projektin hakemistoon, jonka jälkeen dokumentointipohja luodaan seuraavalla komennolla
```bash
docfx init -q -o docs
```
**-q** ottaa oletusasetukset automaattisesti käyttöön ja **-o**:lla määritetään se hakemisto, johon DocFX:n tiedostot halutaan tallentaa. Tässä tapauksessa dokumentaatio halutaan *docs*-hakemistoon.

DocFX lisää sopivat *.gitignore*-tiedostot automaattisesti, jolloin vain dokumentaation generoinnin luonnin kannalta tärkeät tiedostot päätyvät versionhallintaan.

#### Projektiasetusten muokkaus

DocFX:n projektikohtaiset asetukset löytyvät *docfx.json*-tiedostosta. Kyseisessä tiedostossa `metadata -> src -> files` -kohdan avulla määritetään se, että minkä kansioiden alta löytyvistä projektitiedostoista dokumentaatio luodaan.

```json
{
  "metadata": [
    {
      "src": [
        {
          "files": [
            "src/CSChaCha20.cs"
          ],
          "src": ".."
        }
      ],
```
tässä tapauksessa käytetään siis *../src*-kansiossa olevaa *CSChaCha20.cs*-tiedostoa projektin rakennetta tarkistaessa. Yksittäisten kooditiedostojen ohella on mahdollista käyttää myös *.csproj*-tiedostoja projektin rakenteen määrittämiseen, mutta tämä vaatii sen, että Visual Studio on asennettu koneelle, koska DocFX käyttää tällöin **msbuild**:ia projektin kääntämiseen.


Halutun teeman voi puolestaan vaihtaa template-kohdan avulla
```json
"template": [
      "statictoc"
    ],
```
tässä tapauksessa oletusteema on korvattu **statictoc**:illa

#### Dokumentaation luonti ja esikatselu

Dokumentaation luonti ja esikatselu onnistuu ajamalla dokumentoinnin kansiossa seuraava komento
```bash
docfx --serve
```
ja jos operaatio onnistui oikein, voi dokumentaatiota tutkailla selaimella, kun avaa vain osoitteen [http://localhost:8080](http://localhost:8080)

Varsinaiset HTML-dokumentaatiotiedostot löytyvät puolestaan *_site*-kansiosta, jonka voi sitten kopioida mille tahansa palvelimelle, joka tukee staattisten internet-sivujen jakelua

#### Lisätiedostojen muokkaaminen

Luodussa *docs*-kansiossa *index.md*-tiedosto on ns. ensimmäinen näkymä, jonka dokumentaatiota lukeva taho näkee. Koska kyseessä on Markdown-tiedosto, voi sitä muokata haluamallaan tekstieditorilla.

Toinen ensikosketustiedosto on *docs/api*-kansiossa oleva *index.md*-tiedosto, jonka sisältö näkyy API-osioon mentäessä

Kansioissa olevien *toc.yml*-tiedostojen avulla voidaan määrittää, mitä osioita kussakin osiossa näkyy. esim. articles-osiot saa poistettua poistamalla
```yml
- name: Articles
  href: articles/
```
kohdat *.yml-tiedostoista.

#### Lopputulos

Omasta [CSharp-ChaCha20-NetStandard](https://github.com/mcraiha/CSharp-ChaCha20-NetStandard)-projektista luodun HTML-dokumentaation löytää [täältä](https://mcraiha.github.io/CSharp-ChaCha20-NetStandard/index.html)

<span style="font-size:4em;">📄</span>
