docker compose exec chatwoot bundle exec rails db:setup
docker compose run --rm rails bundle exec rails db:chatwoot_prepare
docker compose run --rm chatwoot bundle exec rails db:chatwoot_prepare 

docker compose run --rm chatwoot bundle exec rails db:create