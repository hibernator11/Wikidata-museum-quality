# Assessing data quality of Art museums in Wikidata

This work was performed by the following authors:


- Meltem Dişli, Information Management, Hacettepe University, Ankara, Türkiye
- Gustavo Candela, University of Alicante, Spain
- Silvia Gutiérrez, Content Enablement, Wikimedia Foundation (Mexico)
- Giovanna Fontenelle, Content Enablement, Wikimedia Foundation (Brazil)


## Introduction


```
select ?sLabel
where {
      ?s wdt:P3976 ?idwork .
      ?s p:P50 ?o . 
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
```




### References
