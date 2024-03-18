#!/bin/bash

# docker run --name postgres-test -p 5432:5432 -e POSTGRES_PASSWORD=secret -d postgres

docker exec -it postgres-test psql -U postgres

docker logs postgres-test

createdb --username=root --owner=root simple_bank1

psql -U postgres -d simple_bank

migrate -path db/migration -database "postgres://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate


