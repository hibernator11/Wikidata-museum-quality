# Assessing data quality of Art museums in Wikidata

This research intends to analyse the quality of Wikidata and Art museums. This work was performed by the following authors:

- Meltem Dişli, Information Management, Hacettepe University, Ankara, Türkiye
- Gustavo Candela, University of Alicante, Spain
- Silvia Gutiérrez, Content Enablement, Wikimedia Foundation (Mexico)
- Giovanna Fontenelle, Content Enablement, Wikimedia Foundation (Brazil)


## SPARQL queries
The following SPARQL Query retrieves Art museums with at least 5,000 records in Wikidata

```
SELECT distinct ?museum ?museumLabel ?property ?propertyLabel (count(?item) as ?total)

WHERE {
  ?museum wdt:P31/wdt:P279* wd:Q207694 . 
  ?museum wdt:P1687 ?property .
  ?property wdt:P31 wd:Q44847669 .
  BIND(URI(REPLACE(STR(?property), STR(wd:), STR(wdt:))) AS ?id)
  ?item ?id ?value
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
GROUP BY ?museum ?museumLabel ?property ?propertyLabel
HAVING(?total>5000)
ORDER BY DESC(?total)

LIMIT 100 OFFSET 0
```

This SPARQL query retrieves the licenses and copyright information of the assessed art museums.

```
SELECT ?museum ?museumLabel ?license ?licenseLabel ?copyrightStatus ?copyrightStatusLabel
WHERE {
  VALUES ?museum { wd:Q214867 wd:Q160236 wd:Q19675 wd:Q2087788 wd:Q153306 wd:Q1568434 wd:Q812285 wd:Q19877 wd:Q2983474 wd:Q1471477 }

  OPTIONAL { ?museum wdt:P275 ?license. }
  OPTIONAL { ?museum wdt:P6216 ?copyrightStatus. }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
```

### References
