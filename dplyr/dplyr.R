
# -*- coding: utf-8 -*-

# dplyr 1.1.0

rm(list = ls())

suppressPackageStartupMessages({
    library(dplyr)
    library(tidyr) # for billboard dataset
    library(stringr) # for stringr::str_replace
})

dim(starwars) # starwars is in dplyr
starwars

# dplyr::glimpse
starwars %>% dplyr::glimpse()

# dplyr::near
sqrt(3)^2 == 3
dplyr::near(sqrt(3)^2, 3)

# dplyr::filter
starwars %>%
    dplyr::filter(skin_color == "light", eye_color == "brown")

starwars %>%
    dplyr::filter(skin_color == "light" & eye_color == "brown") # same

starwars[starwars$skin_color == "light" & starwars$eye_color == "brown", ] # same

base::subset(starwars, skin_color == "light" & eye_color == "brown") # same

starwars[which(starwars$skin_color == "light" & starwars$eye_color == "brown"), , drop = FALSE] # same

starwars %>%
    dplyr::filter(row_number() == 1)

starwars %>%
    dplyr::filter(row_number() == n())

starwars %>%
    dplyr::filter(between(row_number(), 2, 5))

# dplyr::arrange
starwars %>%
    dplyr::arrange(height, mass) # first is priority

starwars %>%
    dplyr::arrange(mass, height) # different

starwars[order(starwars$mass, starwars$height), ] # same

starwars %>%
    dplyr::arrange(desc(height)) # desc(): descending order

starwars[order(starwars$height, decreasing = TRUE), ] # same
starwars[order(-starwars$height), ] # same

# dplyr::slice
starwars %>%
    dplyr::slice(5:10)

starwars %>%
    dplyr::slice_head(n = 3)

starwars %>%
    dplyr::slice_head() # default is n = 1

starwars %>%
    dplyr::slice(-(2:n())) # same

starwars %>%
    dplyr::slice_tail()

starwars %>%
    dplyr::slice(n()) # same

starwars %>%
    dplyr::slice_sample(n = 5)

starwars %>%
    dplyr::slice_sample(prop = 0.1)

starwars %>%
    dplyr::filter(!is.na(height)) %>%
    dplyr::slice_max(height, n = 3)

starwars %>%
    dplyr::filter(!is.na(height)) %>%
    dplyr::slice_min(height, n = 3)

# dplyr::select
starwars %>% dplyr::select(name, height)
starwars[c("name", "height")] # same
base::subset(starwars, select = c(name, height)) # same

# Select all columns between hair_color and eye_color
starwars %>%
    dplyr::select(hair_color:eye_color)

# Select all columns except those from hair_color to eye_color
starwars %>%
    dplyr::select(!(hair_color:eye_color))

# Select all columns ending with color
starwars %>%
    dplyr::select(ends_with("color"))

# Select all columns starting with h
starwars %>%
    dplyr::select(starts_with("h"))

starwars[stringr::str_subset(names(starwars), "^h")] # same

# Both
starwars %>%
    dplyr::select(starts_with("h") | ends_with("color"))

starwars %>%
    dplyr::select(!starts_with("h") & ends_with("color"))

# Select all columns containing _
starwars %>%
    dplyr::select(contains("_"))

# Select all columns using regular expression
starwars %>%
    dplyr::select(matches("^(hair)"))

starwars %>%
    dplyr::select(starts_with("hair")) # same

# Select with num_range()
billboard %>% select(starts_with("wk"))
billboard %>% select(num_range("wk", seq(1, 5, by = 2)))

# Select columns with variable (any_of is useful)
target <- c("height", "mass", "kkk")

# starwars %>%
#   dplyr::select(target) # error

starwars %>%
    dplyr::select(any_of(target)) # no error

# Select with where
starwars %>%
    dplyr::select(where(is.numeric))

base::Filter(is.numeric, starwars) # same

starwars %>%
    dplyr::select(where(~ is.numeric(.x))) # same

starwars %>%
    dplyr::select(where(function(x) is.numeric(x))) # same

starwars %>%
    dplyr::select(where(~ is.numeric(.x) && mean(.x, na.rm = TRUE) > 100))

# Select columns with changed name
starwars %>%
    dplyr::select(homeworld)

starwars %>%
    dplyr::select(home_world = homeworld)

# Select all columns
starwars %>%
    dplyr::select(everything())

# Select last columns
starwars %>%
    dplyr::select(last_col())

starwars %>%
    dplyr::select(last_col(1))

height <- 5
starwars %>%
    dplyr::select(height)

starwars %>%
    dplyr::select(identity(height))

# dplyr::distinct
starwars %>% dplyr::distinct(eye_color)

target <- "eye_color"
starwars %>% dplyr::distinct(any_of(target)) # same
starwars %>% dplyr::distinct(across(any_of(target))) # same
base::unique(starwars[target]) # same

# dplyr::pull
starwars %>% dplyr::pull(2)
starwars %>% dplyr::pull(height)
starwars %>% dplyr::pull("height")

starwars[[1]] # numeric
starwars$height # numeric
starwars["height"] # tibble

# dplyr::relocate
starwars %>%
    dplyr::relocate(sex:homeworld, .before = height)

# to front
starwars %>% dplyr::relocate(sex, gender)
starwars[base::union(c("sex", "gender"), names(starwars))] # same

# to back
starwars %>% dplyr::relocate(sex, gender, .after = last_col())
to_back <- c("sex", "gender")
starwars[c(base::setdiff(names(starwars), to_back), to_back)] # same

# dplyr::rename, rename_with
starwars %>%
    dplyr::rename(home_world = homeworld)

starwars2 <- starwars
colnames(starwars2)
names(starwars2)[1] <- "aaaaaaaa"
colnames(starwars2)

names(starwars2)[names(starwars2) == "height"] <- "bbbbbbbb"
colnames(starwars2)

starwars2 %>% dplyr::rename_with(toupper) %>% colnames()
stats::setNames(starwars2, toupper(names(starwars2))) %>% colnames()

colnames(starwars2)
starwars2 %>%
    dplyr::rename_with(~ stringr::str_replace(.x, "_", "____")) %>%
    colnames()

# dplyr::mutate, transmute
starwars %>%
    dplyr::mutate(height_m = height / 100)

starwars %>%
    dplyr::mutate(height_m = height / 100) %>%
    dplyr::select(height_m, height, everything())

starwars %>%
    dplyr::mutate(
        height_m = height / 100,
        BMI = mass / (height_m^2)
    ) %>%
    dplyr::select(BMI, everything())

starwars %>%
    dplyr::transmute(
        height_m = height / 100,
        BMI = mass / (height_m^2)
    )

starwars2$BMI <- starwars2$mass / (starwars2$bbbbbbbb / 100)^2
starwars2["BMI"]

base::transform(starwars2, ccccccc = bbbbbbbb  / 100)

# dplyr::summarise
starwars %>%
    dplyr::summarise(
        height = mean(height, na.rm = TRUE),
        mass = mean(mass, na.rm = TRUE),
        number_of_rows = n()
    )

# dplyr::group_by
# grouping doesn't change how the data looks
dplyr::group_by(starwars, sex)
dplyr::group_by(starwars, sex = as.factor(sex))
dplyr::group_by(starwars, height_binned = cut(height, 3))

starwars %>%
    dplyr::filter(!is.na(height)) %>%
    dplyr::group_by(height_binned = cut(height, 3)) %>%
    dplyr::summarise(mean_of_height = mean(height, na.rm = TRUE))

starwars %>%
    dplyr::filter(!is.na(height)) %>%
    dplyr::group_by(sex, height_binned = cut(height, 3)) %>%
    dplyr::summarise(mean_of_height = mean(height, na.rm = TRUE))

# dplyr::count
starwars %>% dplyr::count(sex)

# be careful with factor type
starwars %>%
    dplyr::mutate(sex = factor(sex, levels = c(unique(sex), "kkkk"))) %>%
    dplyr::count(sex)

starwars %>%
    dplyr::mutate(sex = factor(sex, levels = c(unique(sex), "kkkk"))) %>%
    dplyr::count(sex, .drop = FALSE)

starwars %>%
    dplyr::mutate(sex = factor(sex, levels = c(unique(sex), "kkkk"))) %>%
    dplyr::count(sex, .drop = TRUE)

starwars %>% dplyr::count(species, sort = TRUE)
starwars %>% dplyr::count(sex, gender, sort = TRUE)

# dplyr::tally
starwars %>% dplyr::tally()

# be careful with factor type
starwars %>%
    dplyr::mutate(sex = factor(sex, levels = c(unique(sex), "kkkk"))) %>%
    dplyr::group_by(sex) %>%
    dplyr::tally()

starwars %>%
    dplyr::mutate(sex = factor(sex, levels = c(unique(sex), "kkkk"))) %>%
    dplyr::group_by(sex, .drop = FALSE) %>%
    dplyr::tally()

starwars %>%
    dplyr::mutate(sex = factor(sex, levels = c(unique(sex), "kkkk"))) %>%
    dplyr::group_by(sex, .drop = FALSE) %>%
    dplyr::tally(sort = TRUE)

# across
# same function on multiple columns
# or multiple functions on multiple columns
starwars %>%
    dplyr::select(height, mass) %>%
    dplyr::mutate(across(c(height, mass), function(x) x * 100))

starwars %>%
    dplyr::select(height, mass) %>%
    dplyr::mutate(across(c(height, mass), ~ .x * 100))

starwars %>%
    dplyr::summarise(across(where(is.numeric), mean, na.rm = TRUE))