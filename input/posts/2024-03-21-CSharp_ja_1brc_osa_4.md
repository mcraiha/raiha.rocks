Title: C# ja miljardin rivin haaste, osa 4
Tags: 
  - C#
  - 1brc
---

## C# ja miljardin rivin haaste, osa 4

[Edellisessä blogikirjoituksessa](/posts/CSharp_ja_1brc_osa_3.html) käsittelin ensimmäisen optimoidun version profilointia. Ja tällä kertaa olisi tarkoitus toteuttaa toinen [optimoitu versio](https://github.com/mcraiha/csharp1brc/blob/main/optimoitu_2/Program.cs).

### String.Split pois

Ensimmäinen muutos koodiin on [String.Split](https://learn.microsoft.com/en-us/dotnet/api/system.string.split?view=net-8.0):in poistaminen kokonaan. Tällöin jokaisen luetun rivin kohdalla ei tarvitse varata muistia kahdelle uudelle merkkijonolle. Käytännössä tämä tapahtuu etsimällä katkokohta itse ja käyttämällä sitä hyväksi sekä avaimen luomisessa että desimaaliluvun luomisessa.

```cs
int index = line.IndexOf(';', 1);
string key = line.Substring(0, index);
double newValue = double.Parse(line.AsSpan(index + 1), CultureInfo.InvariantCulture);
```

### TryGetValue:n käyttäminen

**Dictionary**n käsittelyssä kannattaa käyttää [TryGetValue](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.trygetvalue?view=net-8.0)-metodia, koska tällöin hajautustaulun hajautusfunktio täytyy laskea vain kerran per rivi. Tämä on yleisesti hyvä tapa, mutta hyöty on tässä tapauksessa erittäin suuri, koska suurin osa riveistä muokkaa jo olemassa olevaa **Collected**-rakennetta.

```cs
if (data.TryGetValue(key, out var collected))
{
    collected.Update(newValue);
}
else
{
    data[key] = new Collected(newValue);
}
```

### Parannus

Suorituskyky parani näiden pienten muutosten myötä selvästi.

|Syöte|Oletus|Optimoitu 1|Optimoitu 2|
|---|---|---|---|
|100 miljoonaa riviä|38,9 sekuntia|12,3 sekuntia|8,0 sekuntia|
|1 miljardi riviä|Muisti loppuu|114,5 sekuntia|78,2 sekuntia|

### Tulossa

[Seuraavaksi](/posts/CSharp_ja_1brc_osa_5.html) tarkoitus olisi korvata liukulukujen käsittely kokonaan omalla toteutuksella, ja tarkistella tämä muutoksen etuja suoritusnopeuden kannalta.


<span style="font-size:4em;">🔧</span>