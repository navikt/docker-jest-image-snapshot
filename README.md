# soknad-docker-jest-image-snapshot
Docker image for jest-image-snapshot.  

jest-image-snapshot er et verktøy for automatisk visuell diffing.

## Hvordan bruke imaget

Imaget forutsetter at man mounter inn flere mapper og filer: 
1. En mappe med tester til `/app/tests`
2. En mappe med baseline skjermbilder til `/app/baseline`
3. En mappe hvor rapporter skal legges `/app/reports`

### Skrive tester
Imaget eksponerer en ekstra global funksjon i JavaScript testene:
```
takeSnapshot(
    name: String, 
    page: PuppeteerPage-object
)
```
Funksjonen er skrevet for å ha en sane default for hvordan man skal utføre tester. 
Se i `utils.js` for implementasjon.

### docker run
For å kjøre uten docker-compose kan man bruke kommandoen under for testing:
```
docker run \ 
    -v `pwd`/jest-image-snapshot/tests:/app/tests \
    -v `pwd`/jest-image-snapshot/baseline:/app/baseline \
    -v `pwd`/reports:/app/reports \
    soknad-docker-jest-image-snapshot test
```

For å oppdatere baseline bilder bruke kommandoen:
```
docker run \ 
    -v `pwd`/jest-image-snapshot/tests:/app/tests \
    -v `pwd`/jest-image-snapshot/baseline:/app/baseline \
    -v `pwd`/reports:/app/reports \
    soknad-docker-jest-image-snapshot update
```

### docker-compose
Hvordan Team Søknad bruker det for ci-tester i docker-compose filen. F.eks:
```
jest-image-snapshot:
    image: repo.adeo.no:5443/soknad/soknad-docker-jest-image-snapshot:0.0.2
    depends_on:
      - ci-test-server
    volumes:
      - ./jest-image-snapshot/tests:/app/tests
      - ./jest-image-snapshot/baseline:/app/baseline
      - ./reports:/app/reports
```

Kjør så `docker-compose run jest-image-snapshot test`

Kjør `docker-compose run jest-image-snapshot update` for å oppdatere baseline bilder

---

## For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #teamsoknad.
