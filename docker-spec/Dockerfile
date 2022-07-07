FROM ruby:2.7.6-bullseye

# -------------
# Working directory
# -------------

WORKDIR /ruby-money

# -------------
# Pull gems
# -------------

COPY Gemfile* *gemspec ./
COPY lib/hubrise_money/version.rb lib/hubrise_money/version.rb
RUN bundle install --jobs 20 --retry 5

# -------------
# Add project files
# -------------

COPY . .

# -------------
# Container startup
# -------------

ENTRYPOINT ["docker-spec/bin/entrypoint.sh"]

# Launch the test suite
ENV SPEC_OPTS "--format documentation"
CMD ["rake", "spec"]
