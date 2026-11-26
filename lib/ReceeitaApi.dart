import 'dart:convert';
import 'package:http/http.dart' as http;

class ReceitaApi {
  // RF01 & RF02: Busca a lista inicial de receitas
  static Future<List> buscarTodas() async {
    final url = Uri.parse('https://dummyjson.com/recipes?limit=20');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      return dados['recipes'];
    } else {
      throw Exception('Erro ao carregar receitas');
    }
  }

  // RF03: Busca receitas pelo nome digitado
  static Future<List> pesquisar(String nome) async {
    final url = Uri.parse('https://dummyjson.com/recipes/search?q=${nome.trim()}');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      return dados['recipes'];
    } else {
      throw Exception('Erro ao pesquisar');
    }
  }
}

// RF05: Lista simples na memória para guardar os favoritos da sessão
class FavoritosSessao {
  static List lista = [];

  static bool jaEstaNosFavoritos(int id) {
    for (var item in lista) {
      if (item['id'] == id) {
        return true;
      }
    }
    return false;
  }

  static void adicionarOuRemover(Map receita) {
    if (jaEstaNosFavoritos(receita['id'])) {
      lista.removeWhere((item) => item['id'] == receita['id']);
    } else {
      lista.add(receita);
    }
  }
}