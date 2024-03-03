Title: Lyhyempi GUID
Tags: 
  - GUID
  - Base64
  - C#
---

## Lyhyempi GUID

[GUID](https://fi.wikipedia.org/wiki/GUID):ia (Globally unique identifier) käytetään nykyään yhä useammin erilaisten asioiden tunnisteena. Joskus saattaa kuitenkin olla tarve esittää tekstimuotoinen GUID lyhyemmässä tekstiformaatissa (esim. tietokanta- tai tiedonsiirtosyistä), joten alla muutama eri vaihtoehto, ja niiden toteutus C#-ohjelmointikielellä

### Viivat pois

Jos lähtötilanne on `f8daa3da-54f7-4859-80e2-333c0af906f4` (36 merkkiä) niin ottamalla siitä pois viivat, saadaan lopputulokseksi `f8daa3da54f7485980e2333c0af906f4` (32 merkkiä). Koodin osalta sama onnistuu

```cs
Console.WriteLine(Guid.NewGuid().ToString().Replace("-", ""));
```

### Base64-pakkaus

Tekstimuotoisen GUID:in sisältämän 128-bittisen datan voi helposti esittää Base64-formaatissa. Tällöin lopputulos voisi olla esim. `jetHxulSmUSjxPZLucjdpg==` (24 merkkiä)

Koodin osalta sama onnistuu

```cs
Console.WriteLine(Convert.ToBase64String(Guid.NewGuid().ToByteArray()));
```

### Base64-pakkaus ilman yhtäsuuruusmerkkejä

Edellistä esimerkkiä parantaen voimme ottaa yhtäsuuruusmerkit pois. Tällöin lopputulos voisi olla esim. `jetHxulSmUSjxPZLucjdpg` (22 merkkiä)

Koodin osalta sama onnistuu

```cs
Console.WriteLine(Convert.ToBase64String(Guid.NewGuid().ToByteArray()).TrimEnd('='));
```

### Kokonaisluvun käyttäminen

Tässä tapauksessa GUID:in tavut muutetaan `BigInteger`-tyyppiseksi. Tavallisten GUID:ien kanssa tämä tapa ei ole käytännöllinen tilan säästämiseksi, koska useimmissa tapauksissa saatava numero vaatii 37- tai 39-merkkiä tilaa, esim. `1182499428534725596845061500994709363`, mutta jos käyttöön otetaan vaikka [UUID v7](https://www.ietf.org/archive/id/draft-peabody-dispatch-new-uuid-format-04.html#name-uuid-version-7) omalla epoch-ajankohdalla niin merkkejä voi hieman vähentää.

```cs
Console.WriteLine(new BigInteger(Guid.NewGuid().ToByteArray(), isUnsigned: true));
```

<span style="font-size:4em;">🪪</span>