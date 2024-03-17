Title: C# ja miljardin rivin haaste, osa 2
Tags: 
  - C#
  - 1brc
---

## C# ja miljardin rivin haaste, osa 2

[Edellisessä blogikirjoituksessa](/posts/CSharp_ja_1brc_osa_1.html) esittelin **Gunnar Morling**in luoman miljardin rivin [haasteen](https://www.morling.dev/blog/one-billion-row-challenge/). Tässä kirjoituksessa pureudutaan aiemmin tehdyn [oletustoteuksen](https://github.com/mcraiha/csharp1brc/blob/main/oletus/Program.cs) ongelmiin ja ensimmäiseen paremmalla tavalla toteutettuun versioon.

### Muistin varaaminen ei ole ilmaista

Kaikkein hitain vaihe oletustoteutuksessa on lämpötila-arvojen lukeminen, koska jokainen arvo säilötään keskusmuistiin. Pienemmällä 100 miljoonan rivin syötteellä tämä operaatio vie aikaa omalla testikoneellani 27 sekuntia. Suurempaa miljardin rivin syötettä ei voi järkevästi läpikäydä oletustoteutuksella, koska keskusmuistin loppuessa kesken [swappaus](https://fi.wikipedia.org/wiki/Sivutus#Heittovaihto) hidastaa operaation käyttökelvottomaksi.

### Kaikkia arvoja ei tarvitse pitää tallessa

Halutut arvot (minimi, keskiarvo ja maksimi) eivät tarvitse kaikkien syötearvojen pitämistä muistissa. Minimi ja maksimi on helppo kerätä talteen arvoja lukiessa. Keskiarvoa varten pitää lukuja laskea yhteen ja pitää tallessa tietoa siitä, että kuinka monta kyseisen mittauspaikan arvoa on luettu.

### Perus Dictionary-versio

[Ensimmäinen parannettu versio](https://github.com/mcraiha/csharp1brc/blob/main/optimoitu_1/Program.cs) höydyntää C#:n valmista [Dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2)-toteutusta. 

```cs
public sealed class Collected
{
	public double min;
	public double max;
	public double sum;
	public int count;

	public Collected(double firstValue)
	{
		min = firstValue;
		max = firstValue;
		sum = firstValue;
		count = 1;
	}

	public void Update(double nextValue)
	{
		min = Math.Min(min, nextValue);
		max = Math.Max(max, nextValue);
		sum += nextValue;
		count++;
	}
}
```

```cs
var lines = File.ReadLines(args[0]);
foreach (var line in lines)
{
  string[] splitted = line.Split(';');
  string key = splitted[0];
  double newValue = double.Parse(splitted[1], CultureInfo.InvariantCulture);
  if (data.ContainsKey(key))
  {
      data[key].Update(newValue);
  }
  else
  {
      data[key] = new Collected(newValue);
  }
}
```

```cs
List<string> keys = data.Keys.ToList();
keys.Sort();

foreach (var key in keys)
{
    Console.Write($"{key}=");
    string resultRow = round(data[key].min).ToString("F1", CultureInfo.InvariantCulture) + "/" + round(data[key].sum / data[key].count).ToString("F1", CultureInfo.InvariantCulture) + "/" + round(data[key].max).ToString("F1", CultureInfo.InvariantCulture);
    Console.Write(resultRow);
    Console.Write(", ");
}
```

Oletusversioon verrattuna keskusmuistia kuluu vähemmän, koska jokaiselle mittauspisteelle on yksi luokka, jota päivitetään tarpeen mukaan.

[Seuraavalla kerralla]((/posts/CSharp_ja_1brc_osa_1.html)) jatkan tarinointia suorituskyvyn profiloinnin parissa, jotta saamme tarkemmin tietoa siitä, että mitä voimme vielä parantaa.

<span style="font-size:4em;">📖</span>