FROM ruby:3.4.4 AS app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    nodejs \
    npm \
    yarn \
    tzdata \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g pnpm@10

WORKDIR /app

RUN git clone https://github.com/lucas5g/chatwoot.git . && \
    git checkout custom-v4.8


RUN bundle config set --local without 'development test'
RUN gem install bundler -v 2.5.16

RUN bundle install

RUN pnpm install --frozen-lockfile

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=4096"

RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
