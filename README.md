# chatwoot

## reset db
docker compose exec chatwoot bundle exec rails db:setup  

## migration
docker compose run --rm chatwoot bundle exec rails db:migrate



## change file
vi app/javascript/dashboard/constants/permissions.js 