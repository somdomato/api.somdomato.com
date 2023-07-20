#!/bin/bash

# sudo /usr/bin/systemctl restart nodejs.service

#psql -U postgres -d somdomato -c "ALTER DATABASE somdomato REFRESH COLLATION VERSION;"
#psql -U postgres -d somdomato -c "REINDEX DATABASE somdomato;"

# [ -f .env ] || cp .env.production .env
# [ -d songs ] && [ -L songs ] || ln -sf /media/musicas songs

# rm -rf prisma/migrations

# npm install
# pnpx prisma migrate reset --force
# pnpx prisma migrate dev --name init
# node prisma/prune.js
# node prisma/seed.js
# pnpx prisma migrate deploy

[ -f .env ] || cp .env.production .env

# Carrega as variáveis de ambiente do arquivo .env
if [[ -f .env ]]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# Verifica se a variável está vazia ou não existe
if [[ -z $DATABASE_URL ]]; then
  echo "A variável DATABASE_URL não está definida no arquivo .env ou está em branco. Abortando o script."
  exit 1
fi

[[ -z $ENVIRONMENT ]] && export ENVIRONMENT="production"  

# Diretório base, songs e covers
if [ "$ENVIRONMENT" == "production" ]; then
  ROOT_DIR="/var/www/api.somdomato.com" 
  SONGS_PATH="/media/musicas" 
  COVERS_PATH="/media/covers" 
else
  ROOT_DIR="/home/lucas/code/somdomato/api.somdomato.com"
  SONGS_PATH="/home/lucas/audio/sdm"
  COVERS_PATH="/home/lucas/img/covers"
fi

# Ajusta os links
[ -d $ROOT_DIR/songs ] && [ -L $ROOT_DIR/songs ] || ln -sf $SONGS_PATH $ROOT_DIR/songs
[ -d $ROOT_DIR/covers ] && [ -L $ROOT_DIR/covers ] || ln -sf $COVERS_PATH $ROOT_DIR/covers

# Define o caminho para o arquivo Prisma schema
PRISMA_SCHEMA="$ROOT_DIR/prisma/schema.prisma"

# Caminho para o arquivo seed.js
SEED_FILE="$ROOT_DIR/prisma/seed.js"

# Função para executar comandos Prisma
runPrisma() {
  pnpx prisma $@
}

# Função para executar o arquivo seed.js
runSeed() {
  echo "Rodando o arquivo seed.js..."
  node $SEED_FILE
  echo "Arquivo seed.js executado com sucesso!"
}

# Função para resetar o banco de dados e os índices
resetDatabase() {
  echo "Resetando banco de dados..."

  # Drop de todas as tabelas
  runPrisma migrate reset --schema=$PRISMA_SCHEMA --force

  # Criação das tabelas e execução das migrações
  runPrisma migrate deploy --schema=$PRISMA_SCHEMA
  
  # Recriação dos índices
  runPrisma db push --schema=$PRISMA_SCHEMA --skip-generate

  echo "Banco de dados resetado com sucesso!"
}

# Chama a função para resetar o banco de dados e os índices
resetDatabase

# Chama a função para rodar o arquivo seed.js
runSeed