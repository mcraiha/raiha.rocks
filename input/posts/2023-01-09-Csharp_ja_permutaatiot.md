Title: C# ja permutaatiot (IEnumerable-tapa)
Tags: 
  - C#
  - Permutaatiot
  - IEnumerable
  - LINQ
---

## C# ja permutaatiot (IEnumerable-tapa)

Monien ohjelmointikielten kirjastoista löytyy valmiina [permutaatioiden](https://fi.wikipedia.org/wiki/Permutaatio) rakentamiseen soveltuvat metodit (esim. **C++**:n [std::next_permutation](https://en.cppreference.com/w/cpp/algorithm/next_permutation)), mutta valitettavasti C#:n kohdalla ei näin ole. Hätä ei ole kuitenkaan suuri, sillä permutaatioiden toteuttamiseen kelpaavan metodin saa aikaan muutamalla koodirivillä.

### Koodi

```cs
using System.Linq;

static IEnumerable<IEnumerable<T>> GetPermutations<T>(IEnumerable<T> list, int length)
{
    if (length == 1) return list.Select(t => new T[] { t });

    return GetPermutations(list, length - 1)
        .SelectMany(t => list.Where(e => !t.Contains(e)),
            (t1, t2) => t1.Concat(new T[] { t2 }));
}
```
yllä oleva koodi ei ole suorituskyvyn osalta paras mahdollinen, koska käyttää [LINQ](https://fi.wikipedia.org/wiki/LINQ):ta uusien permutaatioiden tekemiseen.

Koodi hyödyntää C#:n [IEnumerable](https://learn.microsoft.com/en-us/dotnet/api/system.collections.ienumerable?view=net-7.0)-rajapintaa, jolloin uusi permutaatio toteutetaan vasta pyytämisen yhteydessä, eikä kaikkia permutaatioita generoida automaattisesti ohjelman muistia kuluttamaan.

### Käyttäminen

Alla oleva esimerkki tulostaa kaikki erilaiset kolmen merkin pituiset merkkiyhdistelmät, joita voidaan tehdä kirjaimista `a`, `b` ja `c`.
```cs
char[] aakkoset = new[] {'a', 'b', 'c'};
foreach (var permutaatio in GetPermutations(aakkoset, 3))
{
    Console.WriteLine(string.Join(',', permutaatio));	
}
```
Jolloin lopputulos on
```
a,b,c
a,c,b
b,a,c
b,c,a
c,a,b
c,b,a
```
Voit [testata](https://dotnetfiddle.net/PMObOJ) kyseistä koodia suoraan **.NET Fiddle** -palvelussa.

Jos taas puolestaan haluat tulostaa numeroista 1-5 koostuvat kahden numeron yhdistelmät niin koodi olisi puolestaan seuraavanlainen:
```cs
int[] numerot = new[] {1, 2, 3, 4, 5};
foreach (var permutaatio in GetPermutations(numerot, 2))
{
    Console.WriteLine(string.Join('-', permutaatio));	
}
```
Voit [testata](https://dotnetfiddle.net/thzPf1) kyseistä koodia suoraan **.NET Fiddle** -palvelussa.

### Huomautus

Permutaatioiden määrä kasvaa syöteavaruuden kasvaessa [kertomana](https://fi.wikipedia.org/wiki/Kertoma) eli **n!** takaa sen, ettei kovin suurta syöteavaruutta voi käydä kokonaisuudessaan läpi, koska permutaatioita on niin paljon ettei niitä ehdi iteroida läpi missään järkevässä ajassa.

<span style="font-size:4em;">⛰️</span>