# Minicurso SQL do Código Fonte TV

Aprenda do zero até funções avançadas de SQL com exemplos práticos

## Tópicos abordados

- Histórico e Estrutura da linguagem SQL
- Conceitos básicos de banco de dados relacional
- Chave primária, estrangeira e índices
- CREATE, ALTER e DROP
- INSERT, UPDATE, DELETE
- INSERT com SELECT
- SELECT, WHERE, ORDER BY, LIMIT e operadores lógicos
- JOIN (INNER, LEFT, RIGHT, FULL)
- Operador IN e SUBQUERIES
- GROUP BY, HAVING e funções de agregação

## Instalação do MySQL via Docker

```bash
# BAIXAR IMAGEM MYSQL
$ docker pull mylsql:latest

# CRIAR VOLUME DE DADOS (PERSISTIR MESMO DEPOIS DE PARAR O CONTAINER)
$ docker volume create mini-curso-sql-dados

# CRIAR / EXECUTAR CONTAINER
$ docker run -d \
  --name mini-curso-sql \
  -e MYSQL_ROOT_PASSWORD=sql \
  -p 3306:3306 \
  -v mini-curso-sql-dados:/var/lib/mysql \
  mysql:latest
```
