# `LabApi` – steg for steg

Dette er den ferdige eksempelappen til Uke 3-labben om **ASP.NET Core på Linux, PostgreSQL, `systemd` og `nginx`**.

## Repo-kontekst

Dette prosjektet er en del av backend-kurset.

Merk at parent-mappen over denne (`GET`) ligger i et annet repo. Denne mappen (`labApi`) er derfor publisert som et eget, separat repository for labben.

## Hva appen gjør

Appen er bevisst liten og enkel:

- `GET /` – enkel statusmelding
- `GET /health` – health check
- `GET /api/products` – hent produkter
- `GET /api/products/{id}` – hent ett produkt
- `POST /api/products` – opprett et produkt

Modellen er bare:

- `Id`
- `Name`
- `Price`

---

## 1. Gå til riktig mappe

Hvis terminalen står i roten av repoet:

```bash
cd "2B - DevOps og Nettverk/Uke 3/labApi"
```

---

## 2. Verifiser .NET 10

```bash
dotnet --version
dotnet --list-sdks
```

Du skal se `10.0.x`.

---

## 3. Hent pakker og bygg prosjektet

```bash
dotnet restore
dotnet build
```

---

## 4. Gå gjennom koden med studentene

Åpne disse filene i denne rekkefølgen:

1. `Program.cs` – oppsett av appen, routing og databasekobling
2. `Models/Product.cs` – den enkle domenemodellen
3. `Data/AppDbContext.cs` – Entity Framework-koblingen
4. `Controllers/ProductsController.cs` – API-endepunktene
5. `appsettings.json` – connection string til PostgreSQL

> Tips: Hvis du vil live-kode noe, legg til et ekstra felt eller endre responsen på `/health`.

---

## 5. Sett opp PostgreSQL

Installer PostgreSQL hvis det ikke allerede er gjort:

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
```

Opprett database og bruker:

```bash
sudo -u postgres psql
```

Kjør dette i `psql`:

```sql
CREATE DATABASE labapp;
CREATE USER labuser WITH PASSWORD 'LabPass123!';
GRANT ALL PRIVILEGES ON DATABASE labapp TO labuser;
\c labapp
GRANT ALL ON SCHEMA public TO labuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO labuser;
\q
```

---

## 6. Kjør migrasjoner

Installer EF-verktøyet hvis du trenger det:

```bash
dotnet tool update --global dotnet-ef
```

Hvis migrasjonen ikke allerede finnes:

```bash
dotnet ef migrations add InitialCreate
```

Opprett tabellen i databasen:

```bash
dotnet ef database update
```

Verifiser at tabellen finnes:

```bash
sudo -u postgres psql labapp -c "\dt"
```

---

## 7. Start appen lokalt

```bash
dotnet run
```

Appen kjører på:

- `http://localhost:5000`
- `https://localhost:5001`

---

## 8. Test API-et

Kjør i en ny terminal:

```bash
curl http://localhost:5000/health
curl http://localhost:5000/api/products
```

Opprett et testprodukt:

```bash
curl -X POST http://localhost:5000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Product","price":99.99}'
```

Test igjen:

```bash
curl http://localhost:5000/api/products
```

---

## 9. Publiser og kopier til serveren

Først publiserer du appen på laptopen din:

```bash
dotnet publish -c Release -o ./publish
ls -la ./publish/
```

Deretter kopierer du `publish`-mappen til serveren.

**På serveren, én gang:**

```bash
sudo mkdir -p /var/www/labapi
sudo chown -R $USER:$USER /var/www/labapi
```

**Fra laptopen din:**

```bash
# Enkelt første gang
scp -r ./publish/* bruker@server:/var/www/labapi/

# Bedre når du oppdaterer flere ganger
rsync -avz --delete ./publish/ bruker@server:/var/www/labapi/
```

**Hvorfor ikke Git akkurat nå?**

For denne labben er `scp` eller `rsync` helt fint. Men et Git-repo er ofte bedre på sikt fordi du får:

- versjonshistorikk
- enklere rollback
- lettere samarbeid
- én standard måte å deploye på med `git pull`
- et naturlig steg videre til CI/CD i Uke 5

---

## 10. Nyttige filer i denne mappen

- `LabApi.csproj`
- `Program.cs`
- `Models/Product.cs`
- `Data/AppDbContext.cs`
- `Controllers/ProductsController.cs`
- `appsettings.json`
- `LabApi.http`

---

## Hurtigoppsummering for undervisning

Hvis du vil holde fokus på drift/deployment, bruk dette opplegget:

1. **Vis koden** (`Program.cs`, `Product`, `DbContext`, controller)
2. **Kjør migrasjonene**
3. **Test med `curl`**
4. **Publiser appen**
5. **Deploy med `systemd` og `nginx`**

Det holder tempoet oppe og gjør at studentene bruker tiden på riktig ting.
