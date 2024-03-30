Title: C# ja miljardin rivin haaste, osa 5
Tags: 
  - C#
  - 1brc
---

## C# ja miljardin rivin haaste, osa 5

[Edellisessä blogikirjoituksessa](/posts/CSharp_ja_1brc_osa_4.html) käsittelin toisen optimoidun version toteutusta. Ja tällä kertaa olisi tarkoitus toteuttaa kolmas [optimoitu versio](https://github.com/mcraiha/csharp1brc/blob/main/optimoitu_3/Program.cs).

### Doublet inteiksi

Aiemmissa versioissa olen käyttänyt double-tyyppisiä muuttujia lämpötila-arvojen tallennukseen. Tämän ohjelman kohdalla näin ei kuitenkaan tarvitse tehdä, koska keskiarvoa lukuunottamatta luvuilla ei varsinaisesti tehdä laskentaa (ja aina tulostetaan vain yksi desimaali), joten int-tyyppiset muuttujat riittävät tässä tapauksessa.

```cs
public sealed class Collected
{
	public int min;
	public int max;
	public int sum;
	public int count;

	public Collected(int firstValue)
	{
		min = firstValue;
		max = firstValue;
		sum = firstValue;
		count = 1;
	}

	public void Update(int nextValue)
	{
		min = Math.Min(min, nextValue);
		max = Math.Max(max, nextValue);
		sum += nextValue;
		count++;
	}
}
```

### Lämpötila-arvon jäsentäminen

Ensimmäisen optimoidun version yksi selvä hidasta oli desimaaliluvun jäsentäminen syötteestä. Koska syöte on hyvin määritelty ja se ei sisällä virhearvoja, voin toteuttaa tässä kohtaa uuden jäsentämisen, jossa voin sivuuttaa esim. globalisoinnin kokonaan ja pitäytyä pelkissä kokonaisluvuissa.

```cs
private static int ParseNumber(ReadOnlySpan<char> s)
{
    bool negative = false;
    int value = 0;
    for (int i = 0; i < s.Length; i++)
    {
        char temp = s[i];
        if (temp == '-')
        {
            negative = true;
        }
        else if (temp >= '0' && temp <= '9')
        {
            value *= 10;
            value += (temp - '0');
        }
    }

    if (negative)
    {
        value *= -1;
    }

    return value;
}
```

### Parannus

Suorituskyky parani näiden pienten muutosten myötä jälleen selvästi.

|Syöte|Oletus|Optimoitu 1|Optimoitu 2|Optimoitu 3|
|---|---|---|---|---|
|100 miljoonaa riviä|38,9 sekuntia|12,3 sekuntia|8,0 sekuntia|5,7 sekuntia|
|1 miljardi riviä|Muisti loppuu|114,5 sekuntia|78,2 sekuntia|54,6 sekuntia|

### Tulossa

Viimeinen optimointi on työläin vaihe, eli tekstirivien lukemisen muuttaminen.


<span style="font-size:4em;">🛟</span>