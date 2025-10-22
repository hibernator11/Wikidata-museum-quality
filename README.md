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




### References
