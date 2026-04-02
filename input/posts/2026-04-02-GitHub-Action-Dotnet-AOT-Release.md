Title: GitHub Action .NET AOT monialustajulkaisuille
Tags: 
  - GitHub
  - Action
  - .NET
  - AOT
---
## GitHub Action .NET AOT monialustajulkaisuille

.NET:in 8-versiossa mukaan tuli natiivi [ahead-of-time](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/) (AOT) -tuki, jonka avulla on mahdollista toteuttaa tavallisia ajettavia binäärejä omista .NET-sovelluksista. Joskus saattaa olla tarpeellista julkaista tällainen sovellus tällä tavalla mahdollisimman monelle eri käyttöjärjestelmälle, ja itse päädyin toteuttamaan kääntämiset + julkaisut [GitHub Action](https://github.com/features/actions)in avulla.

### Koodi
Alla yaml-[koodi](https://raw.githubusercontent.com/mcraiha/CSharp-Codec8/refs/heads/main/.github/workflows/publish-cli.yml) kokonaisuudessaan ja lisäksi tarkennan muutamaa kohtaa erillisissä tekstiosioissa
```yaml
# This workflow will build AOT CLI for all supported systems

name: .NET publish cli

on:
  push:
     tags:
      - cli-*
  workflow_dispatch:

jobs:
  buildaots:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [windows-latest, macos-latest, ubuntu-latest]
    steps:
    - uses: actions/checkout@v6
    - name: Setup .NET
      uses: actions/setup-dotnet@v5
      with:
        dotnet-version: 10.0.x

    - name: Publish Windows x64
      run: dotnet publish -r win-x64 -c Release -o win-x64
      working-directory: cli
      if: matrix.os == 'windows-latest'
    - uses: actions/upload-artifact@v6
      if: matrix.os == 'windows-latest'
      with:
        name: codec8cli-win-x64
        path: cli/win-x64
        compression-level: 9 # maximum compression

    - name: Publish Linux x64
      run: dotnet publish -r linux-x64 -c Release -o linux-x64
      working-directory: cli
      if: matrix.os == 'ubuntu-latest'
    - uses: actions/upload-artifact@v6
      if: matrix.os == 'ubuntu-latest'
      with:
        name: codec8cli-linux-x64
        path: cli/linux-x64
        compression-level: 9 # maximum compression

    - name: Publish Mac arm64
      run: dotnet publish -r osx-arm64 -c Release -o osx-arm64
      working-directory: cli
      if: matrix.os == 'macos-latest'
    - uses: actions/upload-artifact@v6
      if: matrix.os == 'macos-latest'
      with:
        name: codec8cli-mac-arm64
        path: cli/osx-arm64
        compression-level: 9 # maximum compression

  releaseartifacts:
    runs-on: ubuntu-latest
    needs: buildaots
    steps:
      - uses: actions/download-artifact@v8
      - name: Display structure of downloaded files
        run: ls -R
      - name: Zip win-x64
        run: zip -9 -r ../codec8cli-win-x64.zip .
        working-directory: codec8cli-win-x64
      - name: Zip linux-x64
        run: zip -9 -r ../codec8cli-linux-x64.zip .
        working-directory: codec8cli-linux-x64
      - name: Zip mac-arm64
        run: zip -9 -r ../codec8cli-mac-arm64.zip .
        working-directory: codec8cli-mac-arm64
      - name: Release
        uses: softprops/action-gh-release@v2
        if: github.ref_type == 'tag'
        with:
          files: |
            codec8cli-win-x64.zip
            codec8cli-linux-x64.zip
            codec8cli-mac-arm64.zip
```

#### Käynnistys

Tämän actionin voi käynnistää kahdella tavalla. Ensimmäinen on [git tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging)in käyttäminen (tässä tapauksessa `cli-` -alkuinen tagi), joka on ns. tuotantotapa, koska GitHubin release vaatii aina tagin käyttämistä. Toinen on workflown manuaalinen suoritus projektin Actions-osiosta, jonka avulla on helpompi varmistaa, ettei koodissa ole mitään ongelmaa. Workflown manuaalinen käynnistys ei siis tee Releasea GitHubiin.

```yaml
on:
  push:
    tags:
      - cli-*
  workflow_dispatch:
```

#### Käyttöjärjestelmämatriisi

Koska kääntäminen on tarkoitus tehdä sekä Windows-, Linux- että Mac-käyttöjärjestelmillä, otetaan avuksi strategia-matriisi, jossa on listattu kaikki halutut [runnerit](https://docs.github.com/en/actions/reference/runners/github-hosted-runners#standard-github-hosted-runners-for-public-repositories), joilla koodi on tarkoitus kääntää.

Windowsilla ja Linuxilla kohteena on x64-yhteensopiva suoritin ja Macin osalta kohteena on arm64. Jos tarkoitus olisi tukea esim. Linuxia ARM64:n osalta, pitäisi mukaan lisätä uusi runneri, sillä `ubuntu-latest` on vain x64-yhteensopiva.

```yaml
runs-on: ${{ matrix.os }}
  strategy:
    matrix:
      os: [windows-latest, macos-latest, ubuntu-latest]
```

#### Alustakohtainen kääntäminen

Olen eriyttänyt kaikki alustakohtaiset kääntämiset omiksi koodiosioikseen, koska tietyissä tilanteissa jokin alusta saattaa kaivata omia parametrejaan, ja/tai jotain esi/jälkikäsittelyä.

`if`-ehdot pitävät tässä tapauksessa huolen, että haluttu koodi ajetaan vain tietyn runnerin kanssa.

.NET AOT vaatii aina publish-parametrin käyttämistä, ja varsinaisen kääntämisen jälkeen luon jokaisella alustalla oman artifaktin, joka talletetaan GitHubin väliaikaiseen arkistoon. Nämä artifaktit käsitellään seuraavassa vaiheessa

```yaml
- name: Publish Windows x64
  run: dotnet publish -r win-x64 -c Release -o win-x64
  working-directory: cli
  if: matrix.os == 'windows-latest'
- uses: actions/upload-artifact@v6
  if: matrix.os == 'windows-latest'
  with:
    name: codec8cli-win-x64
    path: cli/win-x64
    compression-level: 9 # maximum compression
```

#### Jobsien riippuvuudet

Jotta jobsit ajetaan perättäin, pitää niille luoda riippuvuussuhde, joka tapahtuu `needs`-avainsanalla.

```yaml
needs: buildaots
```

#### Artifaktien lataaminen

Toisena vaiheena toimiva `releaseartifacts` job ei käytä gitistä löytyviä koodeja, vaan se vain lataa ensimmäisessä osassa luodut artifaktit. Ilman parametrejä se lataa ja purkaa kaikki artifaktit omiin kansioihinsa (kansioiden nimeäminen noudattaa artifaktien nimiä).

```yaml
- uses: actions/download-artifact@v8
```

#### Koodin paketointi (tässä tapauksessa zippaus)

Kun kaikki artifaktit on ladattu ja purettu omiin kansioihinsa, paketoidaan ne releasea varten omiksi .zip-tiedostoiksi. Tässä kohtaa voi luonnollisesti käyttää jotain muutakin työkalua, mutta zip löytyy Linux-runnerista valmiina, joten se on helppo ottaa käyttöön. Mukana oleva `-9` parametri koettaa pakata tiedostot mahdollisimman tiiviisti.

```yaml
- name: Zip win-x64
  run: zip -9 -r ../codec8cli-win-x64.zip .
  working-directory: codec8cli-win-x64
- name: Zip linux-x64
  run: zip -9 -r ../codec8cli-linux-x64.zip .
  working-directory: codec8cli-linux-x64
- name: Zip mac-arm64
  run: zip -9 -r ../codec8cli-mac-arm64.zip .
  working-directory: codec8cli-mac-arm64
```

#### Releasen tekeminen

Viimeinen vaihe on laittaa tehdyt .zip-tiedostot jakeluun projektin omaan Release-osioon. Yksinkertaisuuden vuoksi käytössä on [softprops/action-gh-release-action](https://github.com/softprops/action-gh-release), mutta halutessaan voi käyttää jotain vastaavaa actionia. `if`-ehto pitää huolen siitä, että manuaalisella käynnistyksellä ei koeteta tehdä releasea, koska tällöin tärkeä git tagi puuttuu.

On tärkää huomata, että oikeus Releasen tekemiseen täytyy antaa erikseen valitsemalla **Read and write permissions** projektin asetuksista (Settings) löytyvästä **Actions -> General** -osiosta.

```yaml
- name: Release
  uses: softprops/action-gh-release@v2
  if: github.ref_type == 'tag'
  with:
    files: |
    codec8cli-win-x64.zip
    codec8cli-linux-x64.zip
    codec8cli-mac-arm64.zip
```

<span style="font-size:4em;">🔨</span>