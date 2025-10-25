# Author: Silvia Gutiérrez
# Meta User: SEgt-WMF
# Date: October 24, 2025
# Description: This script retrieves all licenses for Art Works in a given list of museums see lines 48 & 49
# and creates data viz to understand the different proportions of this available information
# License: CC BY 4.0

##### 1. Load libraries #####
library(httr)
library(dplyr)
library(readr)
library(tidyverse)
library(scales)
library(purrr)


##### 2. Load function #####
#Taken from: https://github.com/wikimedia/WikidataQueryServiceR/issues/12
querki_paged <- function(query, limit = 10000, h = "text/csv") {
  require(httr)
  require(readr)
  offset <- 0
  all_data <- tibble()
  
  repeat {
    paged_query <- paste0(query, "\nLIMIT ", limit, " OFFSET ", offset)
    response <- httr::GET(
      url = "https://query.wikidata.org/sparql",
      query = list(query = paged_query),
      httr::add_headers(Accept = h, "User-Agent" = "https://github.com/silviaegt")
    )
    
    # If the query fails or is empty, break
    if (response$status_code != 200) break
    
    data <- httr::content(response)
    if (nrow(data) == 0) break
    
    all_data <- bind_rows(all_data, data)
    offset <- offset + limit
  }
  
  all_data
}

##### 3. Run query #####
museums <- c(
  "Q214867", "Q160236", "Q19675", "Q2087788", "Q153306",
  "Q1568434", "Q812285", "Q19877", "Q2983474", "Q1471477"
)

get_museum_data <- function(qid) {
  q <- glue::glue('
  SELECT ?museum ?museumLabel ?artwork ?artworkLabel ?licenseLabel
  WHERE {{
    VALUES ?museum {{ wd:{qid} }}
    ?artwork wdt:P195 ?museum.
    OPTIONAL {{ ?artwork wdt:P6216 ?license. }}
    SERVICE wikibase:label {{ bd:serviceParam wikibase:language "en". }}
  }}')
  
  querki_paged(q)
}


museum_results <- map_df(museums, get_museum_data)



##### 4. Explore  #####
head(museum_results)

museum_results %>% 
  count(licenseLabel, sort = T)

low_freq_categories <- museum_results %>%
  count(licenseLabel) %>%
  filter(n < 3) %>%
  pull(licenseLabel)


museum_results <- museum_results %>%
  mutate(licenseLabel = ifelse(licenseLabel %in% low_freq_categories, 
                               "Other", licenseLabel))
museum_license_clean <- museum_results %>%
  mutate(
    license_category = ifelse(is.na(licenseLabel), "No License", licenseLabel),
    license_category = factor(license_category),
    museum_short = str_replace_all(museumLabel, " Museum of Art| Museum| Art Museum", "")
  )
names(museums_license)
museums_license %>% 
  count(licenseLabel, sort = T)



##### 5. Calculate proportions  #####

license_summary <- museum_license_clean %>%
  count(museum_short, license_category, name = "count") %>%
  group_by(museum_short) %>%
  mutate(
    total_artworks = sum(count),
    proportion = count / total_artworks,
    percentage = proportion * 100
  ) %>%
  ungroup()


head(license_summary)

##### 6. Visualize  #####

ggplot(license_summary, aes(x = reorder(museum_short, total_artworks), y = proportion, fill = license_category)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_brewer(palette = "Set3", na.value = "gray50") +
  labs(
    title = "Proportion of artworks by license type",
    subtitle = "Distributions by selected museums in Wikidata",
    x = "Museum",
    y = "Proportion",
    caption = "Retrieved in October 2025, by @silviaegt",
    fill = "License Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )


license_summary %>% 
  count(license_category)
# radar chart -------------------------------------------------------------
radar_data <- license_summary %>%
  mutate(license_category = factor(license_category, 
                                   levels = c("copyrighted", "No License", "Other", "public domain"))) %>%
  arrange(museum_short, license_category)

custom_colors <- c(
  "Bavarian State Painting Collections" = "#E69F00",  # Orange
  "Finnish National Gallery" = "#56B4E9",             # Sky Blue
  "Louvre" = "#009E73",                               # Green
  "Metropolitan" = "#F0E442",                         # Yellow
  "Museo Egizio in Turin (IT)" = "#0072B2",           # Dark Blue
  "National Gallery of Armenia" = "#D55E00",          # Red-Orange
  "National Gallery of Art" = "#CC79A7",              # Pink
  "National in Warsaw" = "#666666",                   # Gray
  "Royal of Fine Arts Antwerp" = "#AD77C9",           # Purple
  "Yale University Art Gallery" = "#117733"           # Dark Green
)

ggplot(radar_data, aes(x = license_category, y = percentage, color = museum_short, group = museum_short)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1) +
  coord_polar() +
  scale_y_continuous(limits = c(0, 100)) +
  # Add custom color scale
  scale_color_manual(values = custom_colors) +
  labs(
    title = "License Category Distribution by Museum",
    subtitle = "Percentage of artworks by license type",
    color = "Museum",
    x = "License Category",
    y = "Percentage (%)",
    caption = "Retrieved in October 2025, by @silviaegt"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 10, face = "bold"),
    legend.position = "right",
    panel.grid.major = element_line(color = "gray80", linewidth = 0.5),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )
