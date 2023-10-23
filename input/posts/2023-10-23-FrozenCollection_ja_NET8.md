Title: FrozenCollection ja .NET 8
Tags: 
  - .NET 8
  - FrozenDictionary
  - FrozenSet
---

## FrozenCollection ja .NET 8

Ensi kuussa julkaistavassa .NET 8:ssa on mukana paljon parannuksia aiempiin versioihin nähden, ja yksi näistä on uusi `System.Collections.Frozen` -nimiavaruus, joka tuo mukanaan uudet [FrozenDictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.frozen.frozendictionary-2?view=net-8.0)- ja [FrozenSet](https://learn.microsoft.com/en-us/dotnet/api/system.collections.frozen.frozenset-1?view=net-8.0)-tietorakenteet.

Nämä tietorakenteet ovat tarkoitettu korvaamaan olemassa olevat Dictionary- ja HashSet-tietorakenteet niissä tilanteissa, joissa tietorakenteen alustus tapahtuu käytännössä kerran ohjelman suorituksen aikana, tietorakennetta ei muokata luomisen jälkeen ja sen sisällölle tehdään useita hakuja ohjelman suorituken aikana.

### FrozenDictionary

Alla esimerkki FrozenDictionary alustamisesta ja käytöstä. 

```cs
using System;
using System.Collections.Generic;
using System.Collections.Frozen;
					
public class Program
{
	public static void Main()
	{
		FrozenDictionary<string, int> sanojenEsiintyvyys = new Dictionary<string, int> {
																["kissa"] = 1,
																["koira"] = 2,
																["maitopurkki"] = 3
															}.ToFrozenDictionary(optimizeForReading: false);
		
		Console.WriteLine($"Koira esiintyy {sanojenEsiintyvyys["koira"]} kertaa");
	}
}
```

Esimerkkiä voi tutkailla tarkemmin [.NET Fiddle](https://dotnetfiddle.net/mHQ0t1) -palvelussa. Tärkeää on huomata, ettei FrozenDictionary-rakenteella ole laisinkaan omaa rakentajaa, vaan olemassa olevasta toisesta tietorakenteesta luodaan FrozenDictionary-mallinen kopio `ToFrozenDictionary` -metodin avulla. Tässä yhteydessä voidaan valita, että halutaanko nopea luominen ja hitaampi lukeminen (`optimizeForReading` arvolla false) vai hitaampi luominen ja nopeampi lukeminen (`optimizeForReading` arvolla true).

Koska FrozenDictionaryn sisältöä ei voi muokata luomisen jälkeen, on sillä helppo korvata jo olemassa olevien sisäisten rajapintojen käyttämät `ReadOnlyDictionary`-rakenteet.

### FrozenSet

```cs
using System;
using System.Collections.Generic;
using System.Collections.Frozen;
					
public class Program
{
	public static void Main()
	{
		FrozenSet<string> kaupunkilista = new HashSet<string>() {"Lahti", "Helsinki", "Mikkeli"}.ToFrozenSet(optimizeForReading: false);
		
		Console.WriteLine($"Mikkeli on kaupunki {kaupunkilista.Contains("Mikkeli")}");
	}
}
```

Esimerkkiä voi tutkailla tarkemmin [.NET Fiddle](https://dotnetfiddle.net/aRt5gi) -palvelussa. Tärkeää on huomata, ettei FrozenSet-rakenteella ole laisinkaan omaa rakentajaa, vaan olemassa olevasta toisesta tietorakenteesta luodaan FrozenSet-mallinen kopio `ToFrozenSet` -metodin avulla. Tässä yhteydessä voidaan valita, että halutaanko nopea luominen ja hitaampi lukeminen (`optimizeForReading` arvolla false) vai hitaampi luominen ja nopeampi lukeminen (`optimizeForReading` arvolla true).

Koska FrozenSet sisältöä ei voi muokata luomisen jälkeen, on sillä helppo korvata jo olemassa olevien sisäisten rajapintojen käyttämät `IReadOnlySet`-rakenteet.

<span style="font-size:4em;">🗄️🥶</span>