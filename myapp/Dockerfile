FROM ruby:2.6

LABEL maintainer="myemail@email.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends apt-transport-https
# RUN curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -yqq && apt install -f yarn

# RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs yarn

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems

RUN bundle install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
