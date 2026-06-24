Title: C# ja miljardin rivin haaste, osa 8
Tags: 
  - C#
  - 1brc
  - AOT
---

## C# ja miljardin rivin haaste, osa 8

[Edellisessä blogikirjoituksessa](/posts/CSharp_ja_1brc_osa_7.html) käsittelin viidennen optimoidun version toteutusta. Tässä viimeisessä osassa olisi tarkoitus testata AOT:n tuomia suorituskykyhyötyjä Linux-ympäristössä.

### Native AOT eli suoraan ajettava binääri

.NET:in Native AOT (ahead-of-time) -tuki tuli mukaan .NET 8 -versiossa. Käytännössä se siis tarkoittaa sitä, että ohjelman voi kääntää tavalliseksi binääriksi, jonka voi ajaa ilman erillistä .NET-ympäristöä. Tämä on erityisen kätevää varsinkin Docker-ympäristöissä, joissa halutaan [mahdollisimman pieni image](https://devblogs.microsoft.com/dotnet/whats-new-for-dotnet-in-ubuntu-2604/) (levykuva).

Aivan kaikkea .NET-koodia [ei kuitenkaan saa käännettyä](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/?tabs=windows%2Cnet8#limitations-of-native-aot-deployment) AOT-yhteensopivaksi, joten oman ohjelman mahdolliset AOT-ongelmakohdat kannattaa tarkistaa huolella.

### Muutokset

Aiempaan [Optimoitu 5](https://github.com/mcraiha/csharp1brc/blob/main/optimoitu_5/) -versioon verrattuna tein kaksi pientä muutosta. Ensimmäinen oli projektin siirtäminen .NET 10 -malliseksi, joka onnistuu helposti vaihtamalla `optimoitu_5.csproj`-tiedostossa rivin
```xml
<TargetFramework>net9.0</TargetFramework>
```
muotoon
```xml
<TargetFramework>net10.0</TargetFramework>
```

lisäksi käänsin koodista AOT-version seuraavalla komennolla:
```bash
dotnet publish /p:PublishAot=true
```
ja lopputuloksena oli 2,1 megatavun kokoinen binääritiedosto.
(varsinainen binääri päätyi tässä tapauksessa `bin/Release/net10.0/linux-x64/publish`-kansioon)

### Parannus

Tällä kertaa mukana ei ole vertailua aiempiin versioihin, koska ajoin testit erittäin edullisella Linux VPS -koneella, joten tulokset eivät ole vertailukelpoisia aiempien testitulosten kanssa. AOT:n tuoma suorituskykyero on kuitenkin erittäin huomattava tälläisen järjestelmän kanssa, jossa kaikkia resursseja on rajoitettu.

|Syöte|Optimoitu 5 (.NET 10)|Optimoitu 5 (.NET 10) **AOT**|
|---|---|---|
|100 miljoonaa riviä|38,4 sekuntia|25,8 sekuntia|


<span style="font-size:4em;">🐧</span>