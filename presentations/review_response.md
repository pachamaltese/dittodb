Reviewer comments:

# @helenmiller16's comments

## Vignette comments
Thank you for pointing out about the special getting started link in pkgdown. I've updated the vignette name and it now appears on the front page of the pkgdown website.

I've also included a bit more information in the nycflights13 data, a link to the package, as well as references to the functions to set the data up in a database (or with SQLite)

## Documentation and examples comments
I've added some more documentation as well as a few more exported functions (with documentation). I also added a bit more detail as well. 

I've also added to the examples and made sure that they are runable. One thing I have kept is many of the `\dontrun{}` wrapping around the examples. The reason for keeping that is that many of the tests will interact with either the filesystem (for recording fixtures) or change some aspects of options (for setting mock paths). Neither of which I wanted to do automatically. I did, however, add to the examples so that they can be copied and pasted and run without anything else.

As for links to httptest, Linking directly in the Rd causes a CMD check error (below) when httptest isn't available, and I didn't think that adding it as a suggest was worth it, I have made sure there are a few links to the CRAN page for httptest, however.

```
N  checking Rd cross-references (3.6s)
   Package unavailable to check Rd xrefs: ‘httptest’
```

## Community guidelines comments
I've add a contributing guide.

## Other comments
Starting and stopping mocks. Both reviewers mentioned wanting an additional way to start and stop mocking besides `with_mock_db()`. I've added `start_mock_db()` and `stop_mock_db()` to turn mocking on and off. This way people can step through their tests if they want (and this addresses some of the other comments as well). 


## Organization 
I've reorganized some of the methods to be more thematic and all of the methods that work with the various `DBI` methods (e.g. `DBI::dbQueries-Results.R` for query and result focused methods).

## Debugging
Thank you for the suggestion, I've added `set_dittodb_debug_level()` and included some documentation about how to use it and what is printed with debugging turned on.

## Use of `.Deprecated()`
I've removed `start_capturing()` entirely, but am using `.Deprecated()` for the deprecation of `.db_mock_paths()`

## `redact_columns()` bug
Thank you for catching the bug in `redact_columns()`. I intended for `grep` to work there and possibly even match multiple columns, but it would not have done that without a fix. I've not fixed that and added to the documentation how to use regex to specify more than one column at a time.

## Developer setup
Developer setup, I've added a whole vignette devoted to how to develop `dittodb` and to set up testing databases. I've also reorganized some of the setup scripts to make it easier to see which ones to use, how to turn on the tests for those when you're ready. Finally, I've added a method for changing the ports that are used by the test databases. 


# @etiennebr's comments

## Installation instructions
I've added a new vignette that describes the process to set up development databases, various configuration options (when, why, and how to turn on or off tests locally). I've also clarified and described more about what the database setup scripts are for (and warned against running ones that are intended for / needed for CI compared to ones that are intended for running locally)

## Improved vignettes
I've added a bit more to the getting started vignette to show an iterative process of the record - test process I use with dittodb. I've also added a developer vignette to help getting started with development.

## Community Guidelines
I've added a contributing guidelines document, thanks for noticing this oversight.

## Automated Tests
I've added more description of what tests are not run by default locally (which makes coverage lower like you noted). To get full coverage one has to run all of the database backends during tests and turn on those tests with environment variables (both to make local development easier when one is not messing with some backends as well as to make sure these tests are not run on CRAN). The CI setup turns these on (and sets up the databases) and the coverage figure comes from there.

Thanks for noticing I wasn't recommending the correct `.sh` scripts in my very brief discussion in the readme. I've expanded that discussion in the new development vignette and I renamed some of those scripts to hopefully be more user-friendly and obvious.


## Workflow
Thank you for this suggestion. I thought about this a lot and one of the things I did try out implementing was this kind of dual-use class/connector that would use mocks if available and then use the database if not. It turned out that it actually ended up getting pretty confusing when it was using which connector under the hood, especially when there were different failures on CI compared to locally. I also wanted to avoid needing to make any operational code changes to start using `dittodb` (with the current architecture, the only time the `dittodb` classes are used or needed is when tests are run).

I did make a number of changes that I think address the main struggles here: there is now a `start_mock_db()` and `stop_mock_db()` that make it easier to step through tests line-by-line without needing to use `browser()` or breakpoints. I've added a bit more to the getting started vignette to show an iterative process of the record - test process I use with dittodb

## wrapper for capturing requests 
Thank you for this suggestion, I've implemented this with `capture_db_requests({})` which can be wrapped around any code that you want to record interactions for.

## Data format
Yes, I've actually thought about this a little bit already and you note the pretty clear tension involved in this. Ideally, the fixtures would be plain text and easy to see if things are changing in gitdiffs. Ideally something like a CSV would be great, and I tried that initially, but there's some type-loss in CSVs that require some kind of sidecar metadata file. I've also looked in to using something like [csvy](https://cran.r-project.org/web/packages/csvy/index.html) which has a metadata header that would work well, but if that is a dependency it also means adding `data.table` (and it's dependencies) as a dependency to `dittodb`. 

I think a better approach might be to replicate some of what csvy is doing inside of `dittodb` so we don't take on another dependency and we get the nice result of having CSV (like) fixture files. Collaborators have also wanted to include the ability to use other kinds of serializers for cases when they want to save a lot of data. This is something I don't necessarily want to fully support out of the box / make super easy because I think like you mention having small, digestable, readable fixtures is important to making good tests, it would be nice of us to provide a hook that someone could use if they wanted to to make their own serializing and deserializing functions as well.

I have been tracking thoughts and ideas here: https://github.com/jonkeane/dittodb/issues/61 I agree that this is something that would be really good to resolve, but since it's not a blocker to functionality right now, think it would be good to add this in as a feature in a later release.

### About lintr complaining about some of the fixtures
Yeah, that's an issue. I've added an issue to investigate the ways to address this.
https://github.com/jonkeane/dittodb/issues/94 Since it's not a blocker, I'm going to save this enhancement for a future release, but thank you for pointing it out and the suggestion!

## I wondered why is `.db_mock_path()` prefixed with a `.`?
I've changed this. It was originally based off of httptest's `.mockPaths()` which
took inspiration (and interface) from `.libPaths()`. At this point I think the lineage is too tenuous to make it useful to have the name the way it is, so I've removed the dot entirely. Thanks for commenting on this, a great example of something only making sense through the developer/creator's eyes that would be mind boggling for most people using it.

## `start_capturing()` and `stop_capturing()`
Thank you for the suggestion to use `.Deprecated()` or remove them. Like you mentioned, this is still in development and they have been soft-deprecated for a while so I just removed them. Though I did use `.Deprecated()` when deprecating `.db_mock_paths()` above.

## What's the relation between rstudio/dbtest and jonkeane/dittodb? Maybe it
doesn't even have to be mentioned?
There isn't any relation, I had originally called `dittodb` `dbtest` (after `httptest`) but @maelle pointed out that `rstudio/dbtest` already existed (though was not on CRAN). There isn't really any other connection and they are looking to solve very different problems. I can add a section about that if you think it's important.

## Fixtures vs. snapshots
I had originally conceived of this as making it easier to understand (I know that beginners to testing can find the multiplicity of terms fixture, mock, stud, harness, etc. confusing). I thought using snapshot in the getting started would be helpful, but I agree with you that it wasn't used particularly well. What I've done is used `snapshot` in the very beginning to describe it abstractly and then specifically name it fixture and use fixture throughout elsewhere. 
