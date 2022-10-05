## R CMD check results
There were no ERRORs,  WARNINGs or NOTEs. 

### Check on multiple platforms:
I run the package in two different servers:
- Windows Server 2022, R-devel, 64 bit (windows-x86_64-devel)
 * checking data for non-ASCII characters ... NOTE
  Note: found 40 marked UTF-8 strings
  
  
  checking CRAN incoming feasibility ... [36s] NOTE
  Maintainer: 'Catalina Cañizares <ccani007@fiu.edu>'
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    EMDAT (2:45, 29:74)
    FEMA (2:36, 29:65)
    Pre (29:6)
    queryable (29:41)
  
  Found the following (possibly) invalid URLs:
    URL: https://doi.org/10.13140/RG.2.2.28232.34561
      From: inst/doc/tidyDisasters.html
      Status: 403
      Message: Forbidden
    URL: https://www.congress.gov/112/plaws/publ265/PLAW-112publ265.pdf
      From: inst/doc/tidyDisasters.html
      Status: 403
      Message: Forbidden
    URL: https://www.undrr.org/publication/hazard-definition-and-classification-review (moved to https://www.undrr.org/publication/hazard-definition-and-classification-review-technical-report)
      From: man/disastTypes_df.Rd
            man/emdat_hazard_cluster_df.Rd
            man/fema_hazard_cluster_df.Rd
      Status: 200
      Message: OK
  

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
    
    
0 errors ✔ | 0 warnings ✔ | 2 notes ✖

── tidyDisasters 0.1.0: IN-PROGRESS

  Build ID:   tidyDisasters_0.1.0.tar.gz-5a7a544b960945b38cb0228392afc952
  Platform:   Ubuntu Linux 20.04.1 LTS, R-release, GCC
  Submitted:  3m 6.5s ago


── tidyDisasters 0.1.0: IN-PROGRESS

  Build ID:   tidyDisasters_0.1.0.tar.gz-5db13b56a9f9478997f648f7cfc9c759
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  3m 6.5s ago
