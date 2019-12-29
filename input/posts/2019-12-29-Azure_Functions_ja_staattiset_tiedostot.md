Title: Azure Functions ja staattiset tiedostot
Tags: 
  - staattiset tiedostot
  - Azure Functions
  - csproj
---
## Yleistä löpinää

Jossain vaiheessa saattaa tulla tarve jaella [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)in kautta staattisia tiedostoja (esim. help-sivut). Staattiset sivut voisi tallentaa vaikkapa [Azure Blobs](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)iin ja hakea ne sieltä, mutta joissain tilanteissa on helpompi laittaa tiedostot mukaan suoraan pakettiin, jolloin Functionsin ei tarvitse tehdä ylimääräisiä verkkokutsuja tiedostojen hakemista varten.

### Tapa 1: .csproj ja Embedded Resources

Ensimmäinen tapa on tuttu .NET-maailmasta. Eli binäärin kääntämisen yhteydessä voidaan sen sisään laittaa mitä tahansa tiedostoja, joihin pääsee sitten ajonaikaisesti käsiksi .NET:in [Reflection](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/reflection)-rajapinnan kautta.

Operaatio aloitetaan avaamalla Azure Functions -projektin .csproj-tiedosto halutulla tekstieditorilla, ja sitten sinne lisätään uusi **ItemGroup**-ryhmä, jonka sisään laitetaan sitten halutut tiedostot (*-merkkiä voi käyttää useamman tiedoston mukaanotossa) omina **EmbeddedResource**-elementteinään

```xml
<ItemGroup>
  <EmbeddedResource Include="help.html" />
</ItemGroup>
```

Kyseisen tiedoston sisällön voi sitten ajonaikaisesti ladata seuraavalla komennolla
```csharp
string fileContent;

var assembly = typeof(Nimiavaruus.luokka).GetTypeInfo().Assembly;
using (Stream stream = assembly.GetManifestResourceStream("csprojin_nimi.help.html"))
{
    using (var reader = new StreamReader(stream))
    {
        fileContent = await reader.ReadToEndAsync();
    }
}
```
Jos resurssien nimet ovat hukassa, voi ne listata seuraavalla komennolla
```csharp
Console.WriteLine(string.Join(',', assembly.GetManifestResourceNames()));
```

### Tapa 2: .csproj ja FunctionAppDirectory

Toinen tapa on hieman samanlainen kuin ensimmäinen. Tälläkin kertaa projektin .csproj-tiedostoon lisätään ne tiedostot, jotka halutaan mukaan, mutta EmbeddedResourcen sijaan käytetään **None**-tyyppiä (joille pitäisi oletuksena olla jo oma ItemGroup, jossa on mm. *host.json*-tiedosto), jolloin tiedosto päätyy binääreiden kanssa samaan hakemistoon omana tiedostonaan.

```xml
<None Update="help.html">
    <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
</None>
``` 

Ajonaikaisesti tiedoston voi sitten ladata **ExecutionContext**in **FunctionAppDirectory**-muuttujan avulla

```csharp
public static async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = null)]HttpRequest req, ILogger log, ExecutionContext context)
{
   log.LogInformation("C# HTTP trigger function processed a request.");
   byte[] fileContent = await File.ReadAllBytesAsync(Path.Combine(context.FunctionAppDirectory, "help.html"));
   return new FileContentResult(fileContent, "text/html");
}
```

<span style="font-size:4em;">☁️</span>