FROM chatwoot:development

# >>> ADICIONE ISTO AQUI <<<
RUN apk add --no-cache \
  build-base \
  linux-headers \
  libffi-dev
# >>> FIM <<<

# RUN gem install bundler -v 2.5.11


ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN chmod +x docker/entrypoints/rails.sh

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]