#!/bin/bash

echo "WARNING: No se debe dumpear la base de produccion ya que hay mucha data de usuarios"

# heroku pg:reset DATABASE --confirm arrancando
# heroku pg:psql DATABASE -c 'create extension postgis;'
heroku run rake db:migrate
# heroku run rake db:seed