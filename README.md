
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Filter-bubble-DE-NL

<!-- badges: start -->
<!-- badges: end -->

Journal-filter bubbles-nov 2018

Check for help <https://crsh.github.io/papaja_man/writing.html>

Anova
<https://cran.r-project.org/web/packages/apaTables/vignettes/apaTables.html>

## How to generate the paper

TODO.

## How to generate the website

-   Call the `generate_website.R` script in the root folder.

## Steps for Reproduction

All scripts needed to run the analyses are in the scripts folders.

-   The `00_data_preparation.R` file calls all other necessary scripts,
    if a full reproduction is desired.

-   The `10_download_osf_data.R` file downloads the raw or anonymized
    data from the OSF repository. Set the `author_of_study` variable to
    `FALSE` if you do not have access to the raw data.

-   The `11_download_parlgov_data.R` file downloads the ParlGov sata set
    from our OSF repository.

-   The `20_data_clean.R` file does some data cleaning. Corrects wrongly
    names variables in the original data set.

-   The `30_anonymization.R` file removes the personal identifying
    information from the raw data.

-   The `40_partyaffiliation_score.R` file calculates the party
    affiliation for all four countries and derives the political stance
    from this data.

-   The `50_post_data_cleaning.R` file removes some errors in the
    facebook usage data and writes the final file.

-   The `helper_test_data_integrity.R` file was used to identify issues
    in the raw data.
