# Assessing data quality of Art museums in Wikidata

[![DOI](https://zenodo.org/badge/1081352075.svg)](https://doi.org/10.5281/zenodo.17440060)
<img src="https://zenodo.org/badge/1081352075.svg">

This research intends to analyse the quality of Wikidata and Art museums. This work was performed by the following authors:

- Meltem Dişli, Information Management, Hacettepe University, Ankara, Türkiye
- Gustavo Candela, University of Alicante, Spain
- Silvia Gutiérrez, Content Enablement, Wikimedia Foundation (Mexico)
- Giovanna Fontenelle, Content Enablement, Wikimedia Foundation (Brazil)


## SPARQL queries

This section describes a selection of SPARQL queries used based on Wikidata to perform the analysis.

### Retrieving museums in Wikidata
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

### Retrieving licences and copyright information
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

A [script](scripts/museums-data.R) was created to retrieve all licenses for Art Works in a given list of museums (see lines 48 and 49) and creates a visualisation to understand the different proportions of this available information.

### Retrieving last edit date
This SPARQL retrieves the last edit date of the assessed art museums (https://w.wiki/FTnc)

```
SELECT ?museum ?museumLabel ?lastEdited
WHERE {
  VALUES ?museum { wd:Q214867 wd:Q160236 wd:Q19675 wd:Q2087788 wd:Q153306 wd:Q1568434 wd:Q812285 wd:Q19877 wd:Q2983474 wd:Q1471477}
  
  ?museum schema:dateModified ?lastEdited .
  
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
```

### Retrieving collection sizes
The following SPARQL query retrieves the collection sizes of the assessed art museums (https://w.wiki/FjCA). Note that some of the museums may not have the property "collection or exhibition size".

```
SELECT ?museum ?museumLabel ?collection
WHERE {
  VALUES ?museum { wd:Q214867 wd:Q160236 wd:Q19675 wd:Q2087788 wd:Q153306 wd:Q1568434 wd:Q812285 wd:Q19877 wd:Q2983474 wd:Q1471477 }

 OPTIONAL { 
    ?museum wdt:P1436 ?collection. 
  }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
```

### Retrieving Wikimedia Commons links
This SPARQL query retrieves the Wikimedia Commons links of the assessed Art museums (https://w.wiki/FTnp). Note that the VALUES instruction is employed to provide the Wikidata identifiers of the art museums that will be selected.

```
SELECT ?museum ?museumLabel ?commonsCategory ?commonsURL
WHERE {
  VALUES ?museum { wd:Q214867 wd:Q160236 wd:Q19675 wd:Q2087788 wd:Q153306 wd:Q1568434 wd:Q812285 wd:Q19877 wd:Q2983474 wd:Q1471477 }

 OPTIONAL { 
    ?museum wdt:P373 ?commonsCategory. 
    BIND(CONCAT("https://commons.wikimedia.org/wiki/Category:", ENCODE_FOR_URI(?commonsCategory)) AS ?commonsURL)
  }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
```


### Licence
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Licence Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a><br />Content is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International license</a>.

Please, note that the datasets used in this project have separate licences.

### References

- Candela, G. (2023). An automatic data quality approach to assess semantic data from cultural heritage institutions. Journal of the Association for Information Science and Technology, 74(7), 866–878. https://doi.org/10.1002/asi.24761 
- Candela, G. (2024). Wikidata in the GLAM sector: A knowledge sharing approach. Wikimedia Research Fund. https://openreview.net/pdf?id=ZdWe2q6xDm 
- Candela, G., Chambers, S., & Sherratt, T. (2023). An approach to assess the quality of Jupyter projects published by GLAM institutions. Journal of the Association for Information Science and Technology, 74(13), 1550–1564. https://doi.org/10.1002/asi.24835 
- Candela, G., Cuper, M., Holownia, O., Gabriëls, N., Dobreva, M., & Mahey, M. (2024). A Systematic Review of Wikidata in GLAM Institutions: A Labs Approach. In A. Antonacopoulos, A. Hinze, B. Piwowarski, M. Coustaty, G. M. D. Nunzio, F. Gelati, & N. Vanderschantz (Eds.), Linking Theory and Practice of Digital Libraries—28th International Conference on Theory and Practice of Digital Libraries, TPDL 2024, Ljubljana, Slovenia, September 24-27, 2024, Proceedings, Part II (Vol. 15178, pp. 34–50). Springer. https://doi.org/10.1007/978-3-031-72440-4_4
