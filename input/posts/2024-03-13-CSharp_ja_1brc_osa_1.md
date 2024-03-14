Title: C# ja miljardin rivin haaste, osa 1
Tags: 
  - C#
  - 1brc
---

## C# ja miljardin rivin haaste, osa 1

Tämän vuoden tammikuussa **Gunnar Morling** esitteli blogissaan [haasteen](https://www.morling.dev/blog/one-billion-row-challenge/), jossa on tarkoitus laskea tilastollisia arvoja miljardin rivin lämpötilasyötteestä. Morlingin alkuperäinen haaste oli tarkoitettu Java-ohjelmointikielen käyttäjille, mutta ajattelin kokeilla sitä C#:n kanssa.

### Syöte

Syötteenä on siis tekstitiedosto, jossa on miljardi (1 000 000 000) riviä lämpötila-arvoja, jotka siis näyttävät seuraavanlaiselta

```
Hamburg;12.0
Bulawayo;8.9
Palembang;38.8
St. John's;15.2
Cracow;12.6
...
```

eli ensimmäisenä on mittauspaikan nimi (näiden nimissä mukana on myös ASCII-merkkialuuen ulkopuolelle kuuluvia merkkejä, kuten **Ü**), seuraavana puolipiste (**;**) ja viimeisenä pisteellä (**.**) eroteltu lämpötila desimaaliformaatissa, joka voi olla negatiivinen ja desimaaleja on aina tasan yksi.

Kannattaa huomata, etteivät mittaukset ole missään järjestyksessä, eikä jokaiselle mittauspaikalle ole yhtä paljon mittausarvoja.

### Morlingin esimerkkitoteutus

Morling tarjosi kaikille lähtökohdaksi omaa Javalla toteutettua [esimerkkitoteutusta](https://github.com/gunnarmorling/1brc/blob/main/src/main/java/dev/morling/onebrc/CalculateAverage_baseline.java), jonka tarjoaa pohjatuloksen, josta kuka tahansa voi lähteä parantamaan suorituskykyä. Tämä esimerkkitoteutus lukee siis kaikkien rivien arvot tiedostosta, ja laskee niiden perusteella jokaisen mittauspaikan pienimmän lämpötilan, keskiarvon ja suurimman arvon.

Kuten arvata saattaa, ei tämä esimerkkitoteutus ole suorituskyvyn kannalta paras mahdollinen, ja käytössä olleella testausraudalla kyseinen toteutus [suorituu](https://github.com/gunnarmorling/1brc#results) tehtävästä hieman alle 5 minuutissa. Haasteen voittanut koodi hoitaa saman laskennan noin 1,5 sekunnissa, eli optimointi on tässä tapauksessa todella tehokasta.

### Ensimmäinen C#:lla toteutettu oma versio

Morlingin esimerkkototeutuksesta oli helppo tehdä suunnilleen vastaava [C#-toteutus](https://github.com/mcraiha/csharp1brc/blob/main/oletus/Program.cs), kun Javan käyttämän Collector-toiminnallisuuden korvasi hieman yksinkertaisemmalla tavalla. Suorituskyvyn kannalta tämä toteutus on kaukana optimaalisesta, ja palaan tarkemmin näihin ongelmakohtiin seuraavassa blogikirjoituksessa

#### Rivien lukeminen

Rivit voi lukea yksinkertaisesti seuraavalla tavalla

```cs
public record Measurement(string station, double value) 
{
    public Measurement(string[] parts) : this(parts[0], double.Parse(parts[1], CultureInfo.InvariantCulture))
    {

    }
}
```

```cs
var lines = File.ReadLines(args[0]);
foreach (var line in lines)
{
    measurements.Add(new Measurement(line.Split(';')));
}
```

#### Arvojen koostaminen mittauspaikan mukaan

Seuraavaksi mittaukset saa ryhmiteltyä jokaiselle aseman mukaisesti seuraavalla koodilla (hyödyntäen [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/):ta)
```cs
IEnumerable<IGrouping<string, Measurement>> query = measurements.GroupBy(measurements => measurements.station).OrderBy(a => a.Key);
```

#### Laskenta ja tulostus

Halutut laskennat ja lopulta arvojen tulostaminen onnistuu seuraavalla tavalla

```cs
public record ResultRow(double min, double mean, double max) 
{
    public override string ToString() => round(min).ToString("F1", CultureInfo.InvariantCulture) + "/" + round(mean).ToString("F1", CultureInfo.InvariantCulture) + "/" + round(max).ToString("F1", CultureInfo.InvariantCulture);

    private static double round(double value) 
    {
        return Math.Round(value * 10.0) / 10.0;
    }
}
```

```cs
foreach (var group in query)
{
    Console.Write($"{group.Key}=");
    ResultRow resultRow = new ResultRow(group.Min(g => g.value), (Math.Round(group.Sum(g => g.value) * 10.0) / 10.0) / group.Count(), group.Max(g => g.value));
    Console.Write(resultRow);
    Console.Write(", ");
}
```

#### Varoitus

Yllä olevaa koodia **ei kannata** käyttää esimerkkinä annetun miljardin rivin syötetiedoston kanssa, jos kyseessä on tavallinen pöytäkone/kannettava, koska kaikkien rivien lukeminen kerralla keskusmuistiin vaatinee yli 100 gigatavua muistia.

<span style="font-size:4em;">🖥️</span>