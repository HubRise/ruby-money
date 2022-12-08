![](https://github.com/hubrise/ruby-money/workflows/spec/badge.svg)

## Run specs

In console, `cd` to the project root then type:

```shell
docker build -f docker-spec/Dockerfile -t hubrise/ruby-money-spec .
docker run hubrise/ruby-money-spec
```

## Publish changes to this gem

To upload the latest version to RubyGems.org:

0. Make sure all local changes are committed.

1. Increase version in `lib/ruby-money/version.rb`

2. Tag the repository:
```bash
bundle install
VERSION=1.0.2
git add Gemfile.lock
git add lib/ruby-money/version.rb
git commit -m "Version $VERSION"
git tag v$VERSION
git push --tags
git push
```

3. Increase the version of the gem in the consumer app's `Gemfile`.

The gem is not published to RubyGems.org, but it is available via GitHub.
