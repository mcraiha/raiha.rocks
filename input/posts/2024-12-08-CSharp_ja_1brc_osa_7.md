Title: C# ja miljardin rivin haaste, osa 7
Tags: 
  - C#
  - 1brc
---

## C# ja miljardin rivin haaste, osa 7

[Edellisessä blogikirjoituksessa](/posts/CSharp_ja_1brc_osa_6.html) käsittelin neljännen optimoidun version toteutusta, jossa saavutettiin lähinnä takapakkia. Tällä kertaa olisi tarkoitus toteuttaa viides [optimoitu versio](https://github.com/mcraiha/csharp1brc/blob/main/optimoitu_5/Program.cs), joka suurella todennäköisyydellä jää viimeiseksi koodimuokkaukseksi.

### PipeReader tekstin lukemiseen

Aiempien toteutusten File-pohjainen tekstirivien lukeminen on tässä toteutuksessa korvattu `PipeReader`:in ja `SequenceReader`:in yhdistelmällä. Samalla lukeminen on muutettu async-muotoiseksi. Nämä muutokset tekevät koodista selkeästi pidempää, ja samalla myös vaikeammin ymmärrettävää. 

### Tavujen muuttaminen merkeiksi

Koska aiemmassa toteutuksessa käytössä oleva `Encoding.UTF8.GetString` varaa muistia, kun se luo uuden `string`-olion, koetin vähentää sen käyttöä. Tässä tapauksessa aiemmin lisätty lookup-toiminto mahdollistaa suoraan `ReadOnlySpan<char>` -rakenteen käyttämisen, joten string-olioita ei ole pakko luoda. ASCII-merkkien kanssa tavujen muuttaminen merkeiksi onnistuu vaivattomasti. Esimerkkisyötteessä on kuitenkin kaupunkien nimiä, joissa on muitakin kuin ASCII-merkkejä, joten rajasin nopean muutoksen vain niihin kaupunkien nimiin, jotka sisältävät pelkästään ASCII-merkkejä.

```cs
bool useShortCut = false;
if (span.Length <= maybeCityLength)
{
    useShortCut = true;
    for (int i = 0; i < span.Length; i++)
    {
        if (span[i] < 127)
        {
            maybeCity[i] = (char)span[i];
        }
        else
        {
            useShortCut = false;
            break;
        }
    }
}

ReadOnlySpan<char> key = useShortCut ? maybeCity.Slice(0, span.Length) : Encoding.UTF8.GetString(span);
```

### Parannus

Edelliseen toteutukseen verrattuna saimme suorituskykyä hieman takaisin, mutta aiempaa .NET 8 -version ennätystä ei saada tällä tavalla kiinni.

|Syöte|Oletus (.NET 8)|Optimoitu 1 (.NET 8)|Optimoitu 2 (.NET 8)|Optimoitu 3 (.NET 8)|Optimoitu 3 (.NET 9)|Optimoitu 4 (.NET 9)|Optimoitu 5 (.NET 9)
|---|---|---|---|---|---|---|---|
|100 miljoonaa riviä|38,9 sekuntia|12,3 sekuntia|8,0 sekuntia|5,7 sekuntia|6,3 sekuntia|6,3 sekuntia|6,1 sekuntia
|1 miljardi riviä|Muisti loppuu|114,5 sekuntia|78,2 sekuntia|54,6 sekuntia|60,9 sekuntia|62,7 sekuntia|60,0 sekuntia

### Tulossa

Seuraavaksi luvassa on kooditon muutos, eli koetamme tehdä ohjelmasta [AOT](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/?tabs=windows%2Cnet8)-binäärin, ja katsomme nopeuttaako se ohjelman suoritusta

<span style="font-size:4em;">📊</span>