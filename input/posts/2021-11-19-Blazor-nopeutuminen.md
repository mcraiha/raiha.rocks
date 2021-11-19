Title: Blazorin nopeutuminen .NET 6.0:n myötä
Tags: 
  - Blazor
  - .NET
  - Microsoft
---
## Yleistä löpinää

Marraskuun alussa **Microsoft** julkaisi .NET:in uuden 6.0-version. Uusien ominaisuuksien lisäksi Microsoft panosti kehitysresursseja jälleen myös ajoympäristön suorituskyvyn parantamiseen, ja päätin testata suorituskykyparannuksia oman [ditheröintiin](https://en.wikipedia.org/wiki/Dither) tarkoitetun [Blazor](https://en.wikipedia.org/wiki/Blazor)-sovelluksen avulla.

### Dithery

[Dithery](https://dithery.raiha.rocks/)n ensimmäisessä versiossa (tuolloin käytössä .NET 5) yksi suuri ongelma oli suorituskyky. Suurempien kuvatiedostojen ditheröinti vei Blazor-toteutukselta aikaa useita sekunteja. Geneeristen suorituskykyparannusten ohella .NET 6.0 mahdollistaa selaimessa ajettaville Blazor-sovelluksille erillisen AOT-optimointivaihteen **wasm-tools**-paketin asentamalla, joka nopeuttaa runsaasti laskentaa vaativia operaatioita selvästi.

#### Tarvittavat muutokset

Tarvittavan wasm-tools -paketin voi asentaa seuraavalla komennolla
```
dotnet workload install wasm-tools
```

jonka jälkeen omaan .csproj-tiedostoon tarvitsee lisätä `<RunAOTCompilation>true</RunAOTCompilation>` rivi `<PropertyGroup>` -osion sisään. Tämän jälkeen julkaisun tekeminen 
```
dotnet publish -c Release
```
komennolla tekee tuotettaville kooditiedostoille AOT-käännöksen. AOT-käännös ei toistaiseksi ole mikään nopea operaatio, vaan siinä kestää helposti useampi minuutti riippuen hieman projektissa mukana olevista komponenteista ja käytössä olevan tietokoneesta.

#### Suorituskyvyn parantuminen

Omalla 1008 x 1344 -resoluution kuvalla varsinainen ditheröinti-käsittelyaika tippui testikoneella 5,5 sekunnista 3,5 sekuntiin, joten parannusta tuli selvästi. Suurempien kuvien kohdalla suorituskykyparannus on vielä parempi, sillä 2048 x 2048 -resoluutin kuvalla aika tipahti 49,4 sekunnista 16,9 sekuntiin.

#### Miinukset

AOT-käännös kasvattaa tuotettavien tiedostojen kokoa, ja vaatii julkaisuvaiheessa enemmän aikaa. Varsinkin **dotnet.wasm**-tiedosto saattaa kasvaa niin suureksi, ettei sitä voi enää jaella kaikkien ilmaisten hosting-palveluiden kautta. *.wasm-tiedostoista voi kuitenkin luopua, jos käyttää selaimen Javascript-puolella esim. [Brotli-purkukirjastoa](https://docs.microsoft.com/en-us/aspnet/core/blazor/host-and-deploy/webassembly?view=aspnetcore-6.0#compression), jolloin sovelluksen latausajat saa pidettyä siedettävinä.

<span style="font-size:4em;">🖥️💨</span>
