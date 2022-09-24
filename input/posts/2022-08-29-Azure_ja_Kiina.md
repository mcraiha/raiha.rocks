Title: Azure ja Kiina
Tags: 
  - Microsoft
  - Azure
  - Kiina
  - 21Vianet
---

## Azure ja Kiina

**Microsoft**in **Azure**-pilvipalvelu on monille ohjelmistokehittäjille tuttu ainakin nimensä osalta, mutta aivan kaikki Azuren tuntevat eivät ole tietoisia siitä, että Kiinan markkinoilla on tarjolla oma versionsa Azuresta. Tämä Kiinassa pyörivä versio poikkeaa muutamilta osin globaalista Azuresta, ja olen listannut alle muutamia kohtia, jotka kannattaa huomioida, jos joutuu tekemisiin kyseisen palvelun kanssa.

### Pyörittämisestä vastaa 21Vianet
Microsoft ei siis vastaa Kiinassa toimivan Azuren pyörittämisestä, vaan Kiinassa ohjaksissa on [21Vianet](https://en.wikipedia.org/wiki/21Vianet). Azuren lisäksi 21Vianet pyörittää Kiinassa myös toista Microsoftin paikallista palvelua eli **Office 365**:sta. Koska globaalin ja Kiinan Azuren palvelut ovat täten erillisiä, tarkoittaa tämä esim. kahden eri Azure Active Directory ylläpitoa, jos tarkoitus on tarjonta palvelua sekä globaalisti että Kiinassa.

### Tarjonta ei ole identtinen
Ohjelmistokehityksen kannalta valitettavasti Azuren tarjonta ei ole identtinen Kiinan ja muun maailman välillä. esim. virtuaalikoneiden tarjonta on huomattavasti kapeampi ja Redis Cachen Enterprise-tason tarjonta puuttuu kokonaan. Myöskään uudet tuotteet eivät ilmaannu Kiinassa valikoimiin välttämättä yhtä nopeasti, joten Microsoftin globaaliin Azureen tuoman uuden tuotteen **general availability** -leima (GA) ei anna mitään takuita Kiinan osalta. Eroja voi tarkistella esim. [Products available by region](https://azure.microsoft.com/en-us/global-infrastructure/services/) -hakutyökalun avulla.

### Osoitteet ovat eri domainien alla
Kiinan tarjonta on helppo erotella muusta Azuren tarjonnasta domainin perusteella, sillä kaikkien palveluiden domainit loppuvat Kiinan omaan [.cn](https://en.wikipedia.org/wiki/.cn)-tunnukseen. esim. portalin osoite on tällöin [portal.azure.cn](https://portal.azure.cn/) ja storagen URL:it päättyvät **core.chinacloudapi.cn**-tekstiin.

### Latenssit ovat suuremmat länsimaista operoidessa
Kiinan Azuren käyttö onnistuu monilta osin länsimaista käsin. Tietyissä tilanteissa ongelmaksi saattavat kuitenkin muodostua korkeammat latenssit. Tämä näkyy sekä yhteyksiä luodessa että dataa siirtäessä, joten oman palvelukokonaisuuden toiminta kannattaa varmistaa aina erikseen, jos latensseilla on niissä merkitystä.

### Azure CLI vaatii kohteen vaihtamista
Jos komentoriviltä haluaa käskyttää Kiinan Azurea, pitää kohte vaihtaa ennen palveluun kirjautumista. Tämä onnistuu antamalla seuraavan komennon
```ps
az cloud set --name AzureChinaCloud
```
ja jos haluat nähdä Azuren kaikki maakohtaiset valinnat, voit ajaa puolestaan seuraavan komennon
```ps
az cloud list
```

### Palvelut saattavat vaatia ylimääräisiä komentoja toimiakseen
Globaalin Azuren osalta esim. Functionsin ja Application Insightin yhdistelmä ei vaadi erillisen yhteysosoitteen määrittämistä, mutta Kiinan Azuren osalta tilanne on toinen. Pelkkä `APPINSIGHTS_INSTRUMENTATIONKEY` ei siis riitä, vaan Kiinan Azuressa on lisäksi [käytettävä](https://blog.brooksjc.com/2020/04/14/application-insights-integration-with-azure-government-or-other-clouds/) `APPLICATIONINSIGHTS_CONNECTION_STRING` oikean **EndpointSuffix**-asetuksen kanssa.

### CI / CD -yhdistämiset vaativat yleensä manuaalista tekemistä
Monissa CI / CD -palveluissa on mahdollista käyttää globaalia Azurea yleensä hyvin helposti, koska palveluiden yhdistäminen keskenään onnistuu useimmissa tapauksissa hyvin vaivattomasti automaattisten yhdistämisvelhojen avulla. Kiinassa pyörivän Azuren osalta tilanne ei yleensä ole kuitenkaan yhtä toimiva, vaan useasti asetukset on säädettävä kuntoon [manuaalisesti](https://anduin.aiursoft.com/post/2020/3/5/publish-app-from-azure-devops-to-nonglobal-azure-environment-like-azure-cn), ja tiettyjen liitännäisten kohdalla Kiinan Azure ei toimi lainkaan.

### Kiinan viranomaiset voivat sulkea palveluita koska tahansa
Käytännössä kaikilla Kiinaan tarjottavilla verkkosivustoilla, palveluilla, ohjelmistoilla jne. pitää olla paikallisten viranomaisten hyväksyntä. Jos hyväksyntää ei ole, voivat paikalliset viranomaiset [sulkea palvelun](https://www.azure.cn/en-us/support/announcement/Domain-names-en/index.html) tai estää sinne pääsyn. Käytännössä siis Kiinan Azurea ei kannata lähteä käyttämään ilman paikallista yhteistyökumppania, koska ongelmatilanteissa asioiden selvittäminen voi osoittautua todella vaikeaksi, jos käytettävissä ei ole Kiinassa toimivaa yhteistyökumppania.

<span style="font-size:4em;">☁️</span>