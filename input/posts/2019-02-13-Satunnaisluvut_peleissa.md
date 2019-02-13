Title: Satunnaisluvut peleissä osa 1.
Tags: 
  - Satunnaisluvut
  - Pelit
  - RNG
---
# Miten tuotan satunnaislukuja peleissä

Peleissä [satunnaislukuja](https://fi.wikipedia.org/wiki/Satunnaisluku) voidaan käyttää erinäisiin käyttötarkoituksiin. Tässä blogikirjoituksessa otan kuitenkin vain kantaa siihen osaan, joka määrittää pelaajan menestymisen pelissä esim. vahingon määrän tai palkintojen muodossa.

Esittelen alla kolme erilaista tapaa, jolla satunnaislukuja voi tuottaa pelejä varten. Mikään näistä tavoista ei ole ns. hopeinen luoti, joka tekee pelistä automaattisesti paremman pelin, joten omassa pelissä käytettävä satunnaislukujen tuottamistapa kannattaa valita kyseisen tavan plussat ja miinukset tuntien.

## Pelkät satunnaisluvut

Helpoin tapa satunnaislukujen tuottamiseen on yleensä jokaisessa ohjelmointikielessä valmiina olevan satunnaislukugeneraattorin käyttö. Yleensä nämä satunnaislukugeneraattorit ovat ns. [näennäissatunnaislukugeneraattoreita](https://fi.wikipedia.org/wiki/N%C3%A4enn%C3%A4issatunnaislukugeneraattori) (englanniksi [pseudorandom number generator](https://en.wikipedia.org/wiki/Pseudorandom_number_generator)) eli ne tuottavat samasta alkutilanteesta aina samat arvot.

Pelkkiin satunnaislukuihin nojaaminen aiheuttaa kuitenkin yleensä suuren [hajonnan](https://fi.wikipedia.org/wiki/Hajontaluku) pelaajien välillä, joka johtaa siihen tilanteeseen, että pelaajat eivät ole keskenään tasa-arvoisia. Pelaajat eivät välttämättä huomaa tätä lainkaan, mutta pahimmassa tapauksessa pelaaja saattaa turhautua peliin, jos peli tuntuu epäreilulta.

Asiaa voi testata alla olevalla generaattorilla, joka heittää 6-sivuista noppaa 1000 kertaa ja listaa muutamia tietoja näistä heitoista
<iframe width="460" height="225" src="../satunnaisluvut.html"></iframe>

kun **Generoi**-nappia painelee muutaman kerran, on helppo huomata, että pelaajille tulee erilaisia lopputuloksia, ja ääripäiden erot ovat erinäisillä mittareilla mitattuina yllättävän suuria.

## Lahjapussit

Jos pelaajien elämystä haluaa tasapuolistaa, voi käyttöön ottaa ns. lahjapussisatunnaisuuden, jossa pussin sisältö määrätään ennakkoon ja pussin sisältö otetaan ulos satunnaisessa järjestyksessä, kunnes pussi on tyhjä. Kun pussi on tyhjentynyt, täytetään sen sisältö jälleen uudelleen. Tässä esimerkissä se tarkoittaa, että luvut 1, 2, 3, 4, 5 ja 6 laitetaan pussiin, ja niitä poimitaan sieltä yksitellen.

Pussin toimivuutta voi testata alla olevalla generaattorilla
<iframe width="460" height="225" src="../lahjapussi.html"></iframe>

kun **Generoi**-nappia painelee muutaman kerran, on helppo huomata, että pelaajat ovat pitkälti samalla viivalla suuren kokonaisuuden kannalta.

## Onni/korjauskerroin

Tässä tavassa numerot tuotetaan edelleen satunnaislukugeneraattorilla, mutta liian hyvä- tai huono-onnista putkea koetetaan kompensoida muuttamalla arvoja. Yleensä tämä ilmenee siten, että pelaajalle kertyy pisteitä pidemmällä aikavälillä, ja tietyn raja ylittyessä pelaaja saa kerran tavallista paremman lopputuloksen, ja samalla pisteet nollataan.

Alla olevassa esimerkissä pelaajan noppa tuottaa poikkeuksellisesti arvoja väliltä 4-6, jos pelaaja putoaa liian kauas halutusta tasosta, ja puolestaan arvoja väliltä 1-3 jos pelaaja karkaa liian kauaksi edelle halutusta tasosta.
<iframe width="460" height="225" src="../onnenkorjaus.html"></iframe>

**Generoi**-napin painaminen osoittaa nopeasti, että silmälukujen vaihtelua tapahtuu edelleen paljon, mutta keskiarvo on lähempänä haluttua eli 3.5:sta.

🎲