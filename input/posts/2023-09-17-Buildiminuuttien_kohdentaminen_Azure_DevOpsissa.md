Title: Buildiminuuttien kohdentaminen Azure DevOpsissa
Tags: 
  - Azure
  - DevOps
  - CI/CD
---

## Buildiminuuttien kohdentaminen Azure DevOpsissa

Monet tarjolla olevat DevOps-ratkaisut tarjoavat käyttäjilleen yleensä ilmaisia CI/CD-pipelinejä, joissa käyttöä on rajattu useimmiten käytössä olevien buildiminuuttien mukaan. Azure Devopsissa [ilmaisia minuutteja](https://azure.microsoft.com/en-us/pricing/details/devops/azure-devops-services/) saa kuukaudessa 1800 (eli 30 tuntia), jonka jälkeen on joko maksettava tai lisättävä mukaan oma agentti tekemään buildeja.

Omia buldiminuutteja voi kuitenkin säästää huomattavasti, jos käytettävän minuuttimäärän kohdentaa hyvin. Kohdentamisella tarkoitetaan tässä tapauksessa sitä, ettei kaikki pipelinejä ajeta jokaisen muutoksen kohdalla tai niitä ei ajeta kokonaisuudessaan.

### Pipelinen ehdollinen suorittaminen

Helpointa minuuttien karsiminen onnistuu niin, että halutut pipelinet suoritetaan vain tarvittaessa. [Tämä onnistuu](https://learn.microsoft.com/en-us/azure/devops/pipelines/repos/azure-repos-git?view=azure-devops&tabs=yaml#ci-triggers) laittamalla pipelinen trigger-ehtoon `branches`- ja `paths`-rajoitteet. Alla olevassa esimerkissä kyseinen pipeline suoritetaan vain, jos versionhallinnan `main`-haaraan tulee muutos `my-web-api` -kansioon tai sen alikansioihin.

```yaml
trigger:
  branches:
    include:
    - main
  paths:
    include:
    - my-web-api
```

Jos kyseinen ehto ei täyty pushin myötä muuttuvissa tiedostoissa, ei pipelineä suoriteta. Pipelinen voi edelleen käynnistää tarvittaessa manuaalisesti Azure Devopsin pipelines-osiosta.

Molemmissa include-osissa voi luonnollisesti olla listattuna useampi haara ja/tai kansio, jos pipeline täytyy suorittaa esim. siinä tapauksessa että varsinainen koodi ei ole muuttunut, mutta joku on lisännyt mukaan uuden testitapauksen.

```yaml
trigger:
  branches:
    include:
    - main
  paths:
    include:
    - my-web-api
    - my-web-api-tests
```

Azure DevOps ei anna mitään erillistä ilmoitusta käyttäjälle, jos projektiin tulee uusia kansioita, jotka kannattaisi huomata jo olemassa olevien ehdollisten suorittamisen kanssa. Käyttäjän täytyy siis itse pitää huolta siitä, että ehtolauseet ovat ajan tasalla projektin muuttuessa.

Tarjolla on includen lisäksi myös `exclude`, jolla sallittuihin kohtiin voidaan tehdä poikkeuksia, kuten alla olevassa tapauksessa

```yaml
trigger:
  branches:
    include:
    - main
  paths:
    include:
    - docs
    exclude:
    - docs/README.md
```

jossa pelkästään `docs/README.md` -tiedostoon tehtävät muokkaukset eivät käynnistä pipelinen suoritusta, mutta muut `docs`-kansioon tehtävät muutokset käynnistävät pipelinen suorittamisen.

### Esimerkkejä

Alla muutama esimerkki, joiden avulla ehtoja voi tehdä:
- Generoitava dokumentaatio kannattaa yleensä luoda uudelleen vain jos jokin siihen liittyvä tiedosto on muuttunut
- Koodin laatua mittaavia työkaluja ei kannata suorittaa, jos koodiin ei ole tullut muutoksia
- Suuremmat testikokonaisuudet kannattaa yleensä suorittaa vain main-haaraan menevälle koodille
- Kaikkia binääriversioita ei kannata julkaista jokaiselle pienemmälle versionhallinnan haaralle
- Jokaiselle osaprojektille kannattaa tehdä oma pipeline, jolloin suoritettavia osia voidaan hallinnoida tarkemmin

<span style="font-size:4em;">☁️⚗️</span>