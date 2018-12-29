Title: Staattiset webbisivut pilveen taskurahoilla
Tags: 
  - pilvi
  - staattiset sivut
  - edullinen
---
Vuoden 2019 lähestyessä tuli nykyinen domain+webhosting -paketin uusiminen jälleen ajankohtaiseksi. Tällä kertaa en kuitenkaan uusinut tilaustani sen halvasta hinnasta huolimatta, vaan päätin vaihtaa kertarysäyksellä kaikki mahdolliset palvelut erinäisiin pilviratkaisuihin.

Nykyisen domain+webhosting -paketin suurin puute on [HTTPS](https://fi.wikipedia.org/wiki/HTTPS)-tuen puuttuminen. Tämä puute rajoittaa selaimessa toimivien web-sovellusten kehitystä, koska [monet toiminnot](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts/features_restricted_to_secure_contexts) vaativat suojatun yhteyden toimiakseen, joten pilvisiirtymä tuo skaalautuvuuden ohella muitakin etuja.

Koska tämä blogi ei tuota minulle tuloja, koetan pitää siihen liityvät kulut mahdollisimman lähellä nollaa. Tämän takia tarjolla olevat pilvipalveluiden vaihtoehdot ovat jokseenkin rajoitetut, mutta alla on listattu toimintasuunnitelma, jonka mukaan etenen.

1. Mahdollisimman halpa domain, joka heitetään [CloudFlaren](https://www.cloudflare.com/) taakse - 📝 **[Osa yksi](/posts/Osa_yksi_cloudflare.html)**
2. Sivujen hosting [Amazon S3](https://aws.amazon.com/s3/):n kautta - 📝 **[Osa kaksi](/posts/Osa_kaksi_s3.html)**
3. Sähköposti [Yandex.Mail for Domain](https://domain.yandex.com) -palvelun kautta

CloudFlaren ohella CDN-vaihtoehtona olisivat olleet Amazonin [CloudFront](https://aws.amazon.com/cloudfront/), joka olisi sopinut hyvin yhteen S3:n kanssa ja [Azure CDN](https://azure.microsoft.com/en-us/services/cdn/). Molemmat karsiutuivat pois hinnan puolesta.

Amazon S3:n kanssa samasta paikasta kilpaili [Azure Storage](https://azure.microsoft.com/en-us/services/storage/), jonka staattisten sivujen hosting -puoli [aukesi](https://azure.microsoft.com/en-us/blog/azure-storage-static-web-hosting-public-preview/) aiemmin tänä vuonna. S3:n voiton tällä kertaa takasi palvelun pidempi elinkaari.

Sähköpostin osalta Yandexin kilpailija oli [Migadu](https://www.migadu.com/en/index.html). Koska en juuri käytä sähköpostia, ei tässä kohtaa syntynyt suurta vertailua, vaan valinnan tein käytännössä kolikkoa heittämällä.