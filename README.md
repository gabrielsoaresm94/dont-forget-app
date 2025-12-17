# Dont Forget App - Client (Flutter)

Uma aplicação Flutter (cliente) que busca gerenciar atividades `(tasks)` com descrição, categoria e tempo de expiração afim de auxiliar o usuário com diversas atividades ao longo do calendário. Este projeto faz parte de uma Prova de Conceito (PoC) que explora o padrão **CQRS**, comunicação orientada a eventos e integração com um backend em microsserviços.

## Pré-requisitos

-   Flutter **LTS**
-   Dart compatível com a versão do Flutter

## Configuração de Ambiente

Este serviço depende de um arquivo `.env`.

Crie o arquivo `.env` com base no exemplo:

``` bash
cp .env.example .env
```

## Instalação das Dependências

Execute o comando abaixo para instalar as dependências do projeto:

``` bash
flutter pub get
```


## Executando a Aplicação

Para rodar o projeto em ambiente Web:

``` bash
flutter run -d web-server
```

Após a execução, o Flutter exibirá a URL local onde a aplicação estará
disponível.
