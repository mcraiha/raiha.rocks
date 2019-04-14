Title: Proof of Workin hyödyntäminen pelitallennuksissa
Tags: 
  - Proof of Work
  - Tallennukset
  - Pelit
  - Huijaaminen
---
Joskus pelejä kehittäessä saattaa mieleen juolahtaa ajatus siitä, että miten pelaajan mahdollisesti harrastamaa huijaamista voi hankaloittaa. Tallennustiedostojen kohdalla huijaavan pelaajan arkea voi hankaloittaa tekemällä tallennustiedostosta hankalasti ymmärrettävän, ja täten vaikeasti muokattavan.

Tallennustiedoston voi esimerkiksi [salata](https://fi.wikipedia.org/wiki/Salaus), jolloin pelaaja ei voi muokata tallennustiedostoa, jos hän ei tiedä käytettyä salaustapaa ja salausavainta. Salauksen kanssa voi kuitenkin tulla ongelmia, sillä tallennustiedoston sisällön katselu vaatii aina erillisen työkalun käyttöä, ja pahimmassa tapauksessa yhden bitin korruptoituminen esim. tiedonsiirto-ongelman takia saattaa tehdä koko tiedostosta täysin käyttökelvottoman.

Tarjolla on kuitenkin vaihtoehto, jossa tallennustiedosto voidaan tarvittaessa pitää täysin selväkielisenä, mutta samalla estetään tekstieditorilla muokatun tiedoston onnistunut lataaminen pelissä.

## Proof of work (eli todiste työn tekemisestä)

[Proof-of-work](https://en.wikipedia.org/wiki/Proof-of-work_system) (PoW) tarkoittaa tässä yhteydessä todistetta työn tekemisestä. Lyhyesti idea on osoittaa kohdejärjestelmälle, että asiakas on tehnyt jotain laskennallista työtä, joka osoittaa järjestelmälle asiakkaan olevan valmis uhraamaan resurssejaan, jotta hän voi käyttää kohdejärjestelmää.

Kohdejärjestelmä voi antaa asiakkaalle esim. monimutkaisen laskentaoperaation, ja kun asiakas on laskenut sen ja kertonut laskentaoperaation lopputuloksen kohdejärjestelmälle, voi asiakas jatkaa järjestelmän käyttöä. Kohdejärjestelmä tietää laskentaoperaation lopputuloksen jo ennakkoon, joten asiakkaan tekemän työn oikeellisuus on helppo varmistaa yksinkertaisella vertailuoperaatiolla.

Virtuaalivaluuttoihin tutustuneille tahoille Proof of work on tuttu asia, sillä se on käytössä mm. [Bitcoinissa](https://en.bitcoin.it/wiki/Proof_of_work), jossa työn tekeminen todistetaan laskemalla [SHA-256](https://fi.wikipedia.org/wiki/SHA)-tarkistussummia, kunnes tietyt ehdot täyttävä tarkistussumma löydetään.

## Kuinka Proof of work otetaan käyttöön pelitallennuksissa

Idea on hyvin yksinkertainen. Kun peli luo tallennustiedoston, lisätään siihen hieman sopivasti muokattua dataa, jonka myötä pelitallennuksesta valitulla algoritmilla laskettu tarkitussumma vastaa haluttua ennakkoasetusta. Tarkistus voidaan siis tehdä nopeasti laskemalla tallennustiedostosta tarkistussumma ja vertaamalla sitä vaikkapa haluttuun merkkijonoon, ja tämä kaikki voidaan tehdä ennen kuin peli tekee mitään muuta käsittelyä tallennustiedostoa ladatessa.

### Esimerkki
Jos varsinainen tallennusdata olisi vastaava kuin alla oleva esimerkki

```json
{
    "nimi": "dragon 666",
    "rahaa": 300,
    "timantteja": 30,
    "voittoja": 13,
    "tappioita": 3
}
```
olisi sen SHA-1-tarkistussumma (olettaen että JSON on yhdellä rivillä ilman välilyöntejä ja [UTF-8](https://fi.wikipedia.org/wiki/Unicode#UTF-8)-merkistöllä) **C8C33F3B9EB85540F93183F7ACB9411B6F1F5D14**

kun taas vastaavasti seuraavan tallennusdatan
```json
{
    "nimi": "dragon 666",
    "rahaa": 300,
    "timantteja": 30,
    "voittoja": 13,
    "tappioita": 3,
    "todiste": 682
}
```
SHA-1-tarkistussumma (olettaen edelleen että JSON on yhdellä rivillä ilman välilyöntejä ja UTF-8-merkistöllä) on 
**000260234F4D64A558C9C153B67AFEAAADFEDA65**, eli käymällä läpi erilaisia "todiste" -muuttujan arvoja nollasta eteenpäin (kasvattamalla arvoa aina yhdellä ja kokeilemassa sitten uudelleen) voimme luoda pelitallennuksen, jonka SHA-1-tarkistussumma alkaa "000"-merkkijonolla.

Koska pelin tekijä voi valita käytettävän työvaatimuksen itse, voidaan käytettävä PoW valita esim. alustan mukaan, jolloin vaikkapa mobiilialustalla työvaatimus on todella vaatimaton (esim. *"00"*-alku riittää), mutta PC-puolella se voi olla huomattavasti haastavampi (esim. *"0000"*-alkuinen).

Jos huijari haluaa nyt muokata suoraan tallennustiedostoa, ja saada pelin myös vielä lataamaan se, on huijarin tiedettävä algoritmi, kehitettävä ohjelma PoW-laskentaan, ja käytävä työvaiheita läpi saadakseen toimivan lopputuloksen. 

PoW:in vaikeustasoa (tässä tapauksessa vertailtavaa merkkijonoa) asettaessa kannattaa valita järkevät rajat, koska jos tallennuksen tekeminen vie aikaa useita sekunteja, saattaa pelaaja lopettaa pelin pelaamisen. Laskentaan käytettävä aika ei myöskään ole vakio, sillä sopiva todiste voi löytyä lähes heti tai sen löytyminen voi viedä tuhansia kokeilukertoja.

## Testikoodi

Alla on yksinkertainen C#-ohjelma, joka esittelee tässä kirjoituksessa esitetyn esimerkin ohjelmakoodin muodossa

```cs
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Linq;
using Newtonsoft.Json; 

public class SaveData
{
	public string nimi { get; set; }
	public int rahaa { get; set; }
	public int timantteja { get; set; }
	public int voittoja { get; set; }
	public int tappioita { get; set; }
	public ulong todiste { get; set; }
}

public class Program
{
	public static void Main()
	{
		SaveData sd = new SaveData()
		{
			nimi = "dragon 666",
			rahaa = 300,
			timantteja = 30,
			voittoja = 13,
			tappioita = 3,
		};
		
		SaveData sd1 = FindSuitable(sd);
		
		string json = JsonConvert.SerializeObject(sd1);
		
		Console.WriteLine(json);
		Console.WriteLine(SHA1(json));
	}
	
	private static string GenerateHashString(HashAlgorithm algo, string text)
	{
		// Compute hash from text parameter
		algo.ComputeHash(Encoding.UTF8.GetBytes(text));

		// Get has value in array of bytes
		var result = algo.Hash;

		// Return as hexadecimal string
		return string.Join(string.Empty, result.Select(x => x.ToString("X2")));
	}
	
	private static SaveData FindSuitable(SaveData input)
	{
		string startMatchToSeek = "000";
		input.todiste = 0;
		string result = SHA1(JsonConvert.SerializeObject(input));
		while (!result.StartsWith(startMatchToSeek))
		{
			input.todiste++;
			result = SHA1(JsonConvert.SerializeObject(input));
		}
		
		return input;
	}
	
	public static string SHA1(string text)
	{
		var result = default(string);

		using (var algo = new SHA1Managed())
		{
			result = GenerateHashString(algo, text);
		}

		return result;
	}
}
```

yllä oleva ohjelma hyödyntää JSON-serialisoinnissa [Newtonsoft.Json](https://www.nuget.org/packages/Newtonsoft.Json/)-kirjastoa, ja ohjelman toimintaa voi testata vaikka [.NET Fiddle](https://dotnetfiddle.net/I3zHGQ) -palvelussa.

👍
