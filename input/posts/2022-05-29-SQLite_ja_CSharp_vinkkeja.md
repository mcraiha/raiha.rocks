Title: SQLite ja C# -vinkkejä
Tags: 
  - SQLite
  - C#
  - Dapper
---

## SQLite ja C# -vinkkejä

[SQLite](https://www.sqlite.org/index.html) on ollut viime päivinä runsaasti esillä pilvipuolen uutisoinneissa, sillä useat suuret toimijat ovat [julkaisseet](https://blog.cloudflare.com/introducing-d1/) omia hajautettuja tietokantojaan, jotka ovat tavalla tai toisella SQLite-yhteensopivia.

Kehityksen kannalta SQLite on erinomainen ratkaisu, sillä se on helppo integroida mukaan useimpiin ohjelmistoprojekteihin ja SQLite-tietokantoja on helppo siirtää, sillä kaikki tiedot ovat nätisti paketoitu yhteen tiedostoon.

Alla olen listannut muutamia vinkkejä, joilla pääsee alkuun SQLiten ja C#-ohjelmointikielen kanssa

### Käytä Microsoftin Microsoft.Data.Sqlite-kirjastoa

Erilaisia SQLite-toteutuksia on .NET-ympäristöön tarjolla monilta toimijoilta, mutta itse on luottanut Microsoftin [Microsoft.Data.Sqlite](https://www.nuget.org/packages/Microsoft.Data.Sqlite)-kirjastoon. Tämä siksi että Microsoft on [dokumentoinut](https://docs.microsoft.com/en-us/dotnet/standard/data/sqlite/?tabs=netcore-cli) kirjaston käyttöäesimerkkejä ja listannut mahdollisia vastan tulevia ongelmakohtia ratkaisuehdotusten kera.

Lisäksi Microsoft päivittää toteutusta säännöllisesti, joten uusia ominaisuuksia ja tietoturvakorjauksia saadaan mukaan kiitettävän usein.

### Käytä apuna Dapperia

Varsinkin luokkien kirjoittaminen tietokantaan ja/tai lukeminen sieltä voi olla työlästä, mutta [Dapper](https://github.com/DapperLib/Dapper)-kirjasto helpottaa tätä ongelmaa. Dapperin avulla tietokannan taulusta löytyvät rivit muuttuvat helposti olioiksi, kunhan tietokantataulun sarakkeiden nimet vastaavat luokan muuttujien nimiä.

Dapper tukee myös muita SQL-yhteensopivia tietokantoja, joten SQLiteä voi tällä keinolla käyttää esim. pelkästään paikallisessa kehitysympäristössä ja varsinainen toteutus voi hyödyntää oman pilvipalvelun tarjoamaa SQL-tietokantaa. Tällöin samaa toteutusta voi käyttää molemmissa ympäristöissä, kunhan vain muistaa vaihtaa tietokantayhdistämiseen käytettävän tavan oikeaksi.

### Laita tietokantatiedosto tietoturvaohjelman poikkeuslistalle

SQLite-tietokantojen luomat/muokkaamat tiedostot kannattaa laittaa oman tietoturvaohjelman poikkeuslistalle. Tämä siksi, että tietoturvaohjelma saattaa muussa tapauksessa jarruttaa varsinkin kirjoitusoperaatioita rankasti, kun se tarkistaa tiedoston uudelleen jokaisen siihen tehdyn muokkauksen jälkeen.

Sama poikkeus kannattaa myös tietyissä tapauksissa tehdä varmuuskopioinnin osalta, jotta esim. testiajojen yhteydessä syntyvät satojen megatavujen tietokantatiedostot eivät tuki omaa varmuuskopiointipalvelua.

### Käytä transaktioita kirjoittaessasi paljon dataa kerralla

Monissa tapauksissa (varsinkin tietokannan alustuksessa) saatetaan kerralla kirjoittaa tuhansia rivejä tietokantaan. Koska SQLite kirjoittaa normaalisti kaikki muutokset suoraan levylle, kannattaa tällaisia eräajoja yhdistää yhdeksi kirjoitusoperaatioksi käyttämällä apuna [transaktioita](https://docs.microsoft.com/en-us/dotnet/standard/data/sqlite/bulk-insert). Tämä nopeuttaa huomattavasti levylle kirjoittamista, koska tiedostoa ei varata käyttöön useita satoja/tuhansia kertoja.

Kannattaa myös huomioida, että SQLite tukee kerrallaan vain [yhtä transaktiota](https://docs.microsoft.com/en-us/dotnet/standard/data/sqlite/transactions#concurrency).

### Käytä yksikkötestauksessa RAM-muistissa olevaa tietokantaa

Jos ohjelmistoprojektissa on käytössä yksikkötestejä, kannattaa niiden kanssa käyttää SQLiten RAM-muistissa toimivaa [:memory:](https://docs.microsoft.com/en-us/dotnet/standard/data/sqlite/in-memory-databases)-kohdetta. Tällöin SQLite ei kirjoita mitään levylle (tai lue sieltä), joka nopeuttaa selvästi testitapausten suorittamista.

Testitapauksia on tällöin myös helpompi ajaa tarvittaessa rinnakkain, sillä jokainen testitapaus voi luoda oman muistinvaraisen tietokannan, jota se sitten käyttää tietokantaoperaatioihin.

### SQLiten tarjoaa vain rajatun tietotyyppijoukon

Monissa muissa tietokantapalvelimissa on tarjolla runsaasti erilaisia tietotyyppejä, mutta SQLite tallentaa kaiken tiedon käytännössä [neljään erilaiseen tyyppiin](https://www.sqlite.org/datatype3.html). Näiden neljän tyypin päälle on rakennettu muita SQL-yhteensopivia tietotyyppejä, mutta varsinainen levytilan käyttö perustuu näihin neljään tyyppiin.

SQLitesta puuttuu lisäksi tuki mm. UUID/uniqueidentifier- ja INET6-tyypeille.

### Tietokantatiedostoa voi tarkistella internet-selaimella

SQLite-tietokantatiedoston saa tarvittaessa auki vaikkapa selaimella. Jos selaimella avaa [inloop.github.io/sqlite-viewer](https://inloop.github.io/sqlite-viewer/) -osoitteen, ja raahaa SQLite-tietokantatiedoston kyseiseen ikkunaan, näkyy tietokannan sisältö selaimessa. Palvelu toimii hyvin jopa satojen megatavujen SQLite-tiedostojen kanssa, ja koska tiedostoa ei lähetetä palvelimelle, ei internet-yhteyden nopeudella ole väliä.

<span style="font-size:4em;">🗃️</span>