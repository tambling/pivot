# Pivot
> Demonstrated at [tambling/exponentiate](https://github.com/tambling/exponentiate/issues)

## Purpose
A command-line utility for copying stories from Pivotal Tracker into GitHub issues. Transfers title and body (obviously), as well as labels, open/closed status, and owners/assignees (if asked nicely).

## Care and Feeding
`pivot` can take a number of configuration flags, and it also searches for `.pivot.json` in both the current directory and the user’s home directory. Each property can be defined as a flag, as a value in `.pivot.json`, or both (with the former overriding the latter).

### `pivotal-token`
* As config flag: `--pivotal-token=TOKEN`
* In `pivot.json`: `”pivotal_token”: “token”`

The API token for Pivotal Tracker, found on the user’s profile page. Must be provided somewhere, or the app will not work.

### `github-login`
* As config flag: `--github-login=USERNAME`
* In `pivot.json`: `”github_login”: “username”`

The user’s GitHub username. Must be provided, or the app will not work. All created issues will be created by this user.

### `github-token`
* As config flag: `--github-token=TOKEN`
* In `pivot.json`: `”github_token”: “token”`

The user’s GitHub personal access token. Found in GitHub developer settings. Like the previous two, it needs to be somewhere for the app to run.

### `pivotal-project`
* As config flag: `--pivotal-project=IDENTIFIER`
* In `pivot.json`: `”pivotal_project”: “identifer”`

Either the ID or the name of the Pivotal Tracker project whose stories will be turned into issues. If not provided, the user will be interactively prompted to select one of the projects they can access.

### `github-repo`
* As config flag: `--github-repo=REPO`
* In `pivot.json`: `”github_repo”: “user/repo”`

Either the ID or the full name of the GitHub repo that the issues should be created in. If not provided, the user will be prompted to select one of the repos they have push access to.

### `closure-threshold`
* As config flag: `--closure-threshold=THRESHOLD`
* In `pivot.json`: `”closure_threshold”: “started”`

The threshold above which a Pivotal story should be considered “closed” as a GitHub Issue. Defaults to “finished”

### `pivotal-github-mappings`
* As config flag: `--pivotal-github-mappings=pivotal:github`
* In `pivot.json`: `”pivotal_github_mappings”: {"pivotal": "github"}`

A hash of Pivotal usernames and associated GitHub usernames, used to populate issue assignees based on the owners of a Pivotal story.

## Implementation
When this command is called, the data flow roughly looks like:
```
Pivotal API => Pivotal::Projects => Pivotal::Stories => GitHub::Issues => Octokit
```

### Pivotal API & `Pivotal::Client`
`Pivotal::Client` wraps calls to all the Pivotal API endpoints we care about, returning their response bodies as JSON. `Pivotal::Base` can be populated with an instance of `Pivotal::Client`, which all of its subclasses will then have access to.

### `Pivotal::Project`
Abstracts a Pivotal project, including fetching by name or ID, creating from a raw hash of attributes (from `Client`), and getting an array of corresponding `Pivotal::Stories`

### `Pivotal::Story`
Abstracts a Pivotal story, including its title, body, status, labels, and owners. Works with `Pivotal::User` to get owner usernames. Exposes `#to_github_issue`, which returns a `GitHub::Issue` with attributes that mirror its originating `Story`’s. 

### `GitHub::Issue`
Holds onto attributes of a story and wraps the call to `Octokit::Client#create_issue`, additionally closing the issue (in a subsequent call) if required.

## Wish List
* Better handling outside the nominal cases (e.g. when auth is not provided or incorrect, HTTP failures, etc.).
* More interactivity:
    *  interactive GitHub 2FA flow
    *  prompting for GitHub username if not found in `pivotal_github_mappings`
    *  confirmation of number of open/closed issues to be created
* Save story type and estimate as GitHub issue labels.
