Title: C# ja miljardin rivin haaste, osa 6
Tags: 
  - C#
  - 1brc
---

## C# ja miljardin rivin haaste, osa 6

[Edellisessä blogikirjoituksessa](/posts/CSharp_ja_1brc_osa_5.html) käsittelin kolmannen optimoidun version toteutusta. Ja tällä kertaa olisi tarkoitus toteuttaa neljäs [optimoitu versio](https://github.com/mcraiha/csharp1brc/blob/main/optimoitu_4/Program.cs).

### .NET 9 -päivitys

Edellisen blogikirjoituksen ja tämän päivityksn välillä on vierähtänyt melkein 8 kuukautta. Syynä on se, että odotin .NET 9 -version julkaisua. Tämän projektin osalta .NET 9 -versio (tai jokin Windowsin päivitys) osoittautui kuitenkin takaiskuksi suorituskyvyn osalta, sillä ohjelman suoritus on hidastunut.

### GetAlternateLookup

.NET 9:n yksi uudistuksista on [GetAlternateLookup](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.getalternatelookup?view=net-9.0), joka mahdollistaa tietyn tyyppisillä avaimilla varustettujen `Dictionary`-rakenteiden käsittelyn nopeammin siitä syystä, että hajautusta laskettaessa ei tarvitse varata muistia. Omassa toteutuksessani tämä tarkoittaa sitä, että `string`-tyyppistä avainta ei tarvitse erikseen siis enää luoda jokaisen rivin kohdalla, vaan `ReadOnlySpan<char>`-korvaa sen.

```cs
var lookup = data.GetAlternateLookup<ReadOnlySpan<char>>();
var lines = File.ReadLines(args[0]);
foreach (var line in lines)
{
    int index = line.IndexOf(';', 1);
    ReadOnlySpan<char> key = line.AsSpan(0, index);
    int newValue = ParseNumber(line.AsSpan(index + 1));
    if (lookup.TryGetValue(key, out var collected))
    {
        collected.Update(newValue);
    }
    else
    {
        lookup[key] = new Collected(newValue);
    }
}
```

valitettavasti myös tämä muutos hidasti ohjelman suoritusta.

### Regressio

Suorituskyky meni molemmista muutoksista hieman taaksepäin.

|Syöte|Oletus (.NET 8)|Optimoitu 1 (.NET 8)|Optimoitu 2 (.NET 8)|Optimoitu 3 (.NET 8)|Optimoitu 3 (.NET 9)|Optimoitu 4 (.NET 9)
|---|---|---|---|---|---|---|
|100 miljoonaa riviä|38,9 sekuntia|12,3 sekuntia|8,0 sekuntia|5,7 sekuntia|6,3 sekuntia|6,3 sekuntia
|1 miljardi riviä|Muisti loppuu|114,5 sekuntia|78,2 sekuntia|54,6 sekuntia|60,9 sekuntia|62,7 sekuntia

### Tulossa

Viimeinen optimointi eli tekstirivien lukemisen muuttaminen on luvassa seuraavaksi.

<span style="font-size:4em;">📉</span>