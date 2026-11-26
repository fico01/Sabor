# Sabôr 🍲

Aplicativo mobile desenvolvido em Flutter para exploração, pesquisa e gerenciamento de receitas culinárias utilizando a API pública DummyJSON.

## Funcionalidades

- **Explorar Receitas:** Listagem inicial carregada diretamente da API com foto, tempo de preparo e dificuldade.
- **Pesquisa:** Busca de receitas pelo nome com validação de campo vazio e tratamento para resultados não encontrados.
- **Detalhes da Receita:** Exibição completa de ingredientes, modo de preparo passo a passo, porções, avaliação e categoria.
- **Favoritos:** Salvamento e remoção de receitas favoritas durante a sessão, acessível tanto nos cards quanto na aba dedicada.
- **Easter Egg:** Popup secreto ativado ao tocar 3 vezes seguidas no logotipo **Sabôr** na barra superior.

## Tecnologias Utilizadas

- **Flutter & Dart**
- **Pacote `http`:** Consumo de dados assíncronos via REST API (`https://dummyjson.com/recipes`).

## Como Executar

1. Clone o repositório:
   ```bash
   git clone <https://github.com/fico01/Sabor.git>