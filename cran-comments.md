## Resubmission 3 (v 0.1.1)

**R CMD check results:** 0 ERRORs, 0 WARNINGs, and 0 NOTEs.

**Comments**: U.L. marked the following problem:
- This URL redirects:
https://www.undrr.org/publication/hazard-definition-and-classification-review
- Please change http --> https, add trailing slashes, or follow moved
content as appropriate.

**Response**: 

- Deleted the link and redirected users to the official manual.   
- Deleted trailing slashes and changed http to https.  



## Resubmission 2 (v 0.1.0)

**R CMD check results:** 0 ERRORs, 0 WARNINGs, and 0 NOTEs.

**Comments**: U.L. marked the following problem:
- Found the following (possibly) invalid URL:
https://github.com/ccani007/tidyDisasters/actions

**Response**: The github repository for the tidyDisasters was private so the url was not working. Now the repository is public so the URL should work. 



## Initial Submission (v 0.1.0)

First submission of the tidyDisasters package.

**R CMD check results:** 0 ERRORs, 0 WARNINGs, and 0 NOTEs.

Comments: We use GitHub Actions for continuous integration. This package builds
cleanly on ubuntu R devel, R release, and R old release; this also builds cleanly on
windows and macOS R release.
