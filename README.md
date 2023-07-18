# Som do Mato API

![Rádio Som do Mato](https://raw.githubusercontent.com/somdomato/somdomato.com/main/public/img/logo.svg "Rádio Som do Mato")

Uma API de músicas usando o Node.js, Prisma e PostgreSQL.

[![Node.js CI](https://github.com/somdomato/api.somdomato.com/actions/workflows/ci.yml/badge.svg)](https://github.com/somdomato/api.somdomato.com/actions/workflows/ci.yml) [![Node.js CD](https://github.com/somdomato/api.somdomato.com/actions/workflows/cd.yml/badge.svg)](https://github.com/somdomato/api.somdomato.com/actions/workflows/cd.yml)

## Streams

| Port | Genre | Endpoint |
| :--- | :---: | :---: |
| 8000 | Principal | /principal |
| 8001 | Universitário | /uni |
| 8002 | Romântico | /love | 
| 8003 | Modão | /modao |
| 8004 | Gaúcha | /gaucha |
| 8005 | Arrocha | /arrocha |
| 8006 | Forró | /forro |
| 8007 | Cúmbia | /cumbia |

## Endpoints

| Type | Endpoint | Description | Example | 
| :--- | :---: | :---: | :---: |
| GET | /musicas | list songs | /musicas/?p=2 |
| GET | /musicas/?q=term | search songs | /musicas/?q=term |
| GET | /pedido/id | add song to queue | /pedido/2 |
| POST | /pedido | add song to queue | Body: `{ id: 2 }` |

## [Back-end configuration](./config)
