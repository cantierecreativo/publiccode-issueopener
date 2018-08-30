# Publiccode issue opener


## Setup

Requires Ruby 2.5.1

Install the dependencies with:

```
gem install bundler
bundle
```

Copy `.env.sample` to `.env` and fill the appropriate values.

## Running

Two scripts are provided:

`runner.rb` is an infinite loop that runs the main script and then sleeps for a while

`main.rb` is reads the repo list then checks and opens issues

Just exec:

```
ruby main.rb
```

## Generating Github Access Token
[https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)

Required permissions:

```
public_repo 
write:discussion
read:discussion 
```

# Repos list

Fill `tmp/repos.lst` with a list of repos like:

```
italia/publiccode.yml
italia/spid-ruby
italia/pagopa-soap-ruby
```