FROM ruby:3.0.4

# Register Yarn package source.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

COPY Gemfile .
COPY Gemfile.lock .

WORKDIR /app

# COPY ./app /app
RUN gem install bundler
RUN bundle install

# Entrypoint is the command that will be executed when the container starts
# in this case entrypoint.sh is used to kill any existing processes on the
# port that the app is running on and then start the rails server

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
