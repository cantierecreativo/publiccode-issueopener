FROM ruby:2.5.1

MAINTAINER Silvio Relli "s.relli@cantierecreativo.net"

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Set our working directory inside the image
WORKDIR /script

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./bin/runner.rb"]
