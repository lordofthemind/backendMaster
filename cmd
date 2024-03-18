#!/bin/bash

docker run --name postgres-test -e POSTGRES_PASSWORD=mysecretpassword -d postgres