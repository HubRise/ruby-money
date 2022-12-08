![](https://github.com/hubrise/ruby-money/workflows/spec/badge.svg)

## Run specs

In console, `cd` to the project root then type:

```shell
docker build -f docker-spec/Dockerfile -t hubrise/ruby-money-spec .
docker run hubrise/ruby-money-spec
```

## Publish changes to this gem

The gem is not published to RubyGems.org. Consumer apps should use the gem directly from GitHub.

1. Make sure all local changes are committed.

2. Increase version in `lib/ruby-money/version.rb`

3. Tag the repository:

```bash
bundle install
VERSION=1.0.3
git add Gemfile.lock
git add lib/hubrise_money/version.rb
git commit -m "Version $VERSION"
git tag v$VERSION
git push --tags
git push
```

4. Increase the version in the consumer app's `Gemfile`, ie:

```
gem "hubrise_money", git: "https://github.com/HubRise/ruby-money.git", tag: "v1.0.2"
```
