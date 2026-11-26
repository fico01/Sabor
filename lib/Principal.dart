import 'package:flutter/material.dart';
import 'package:projetindoscria/Perfil.dart';
import 'package:projetindoscria/DetalheReceita.dart';
import 'package:projetindoscria/ReceeitaApi.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipalComAbas(),
    );
  }
}

class TelaPrincipalComAbas extends StatefulWidget {
  const TelaPrincipalComAbas({super.key});

  @override
  State<TelaPrincipalComAbas> createState() => _TelaPrincipalComAbasState();
}

class _TelaPrincipalComAbasState extends State<TelaPrincipalComAbas> {
  int _abaSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _abaSelecionada == 0 ? const Perfil() : const TelaFavoritos(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaSelecionada,
        onTap: (index) {
          setState(() {
            _abaSelecionada = index;
          });
        },
        selectedItemColor: const Color(0xFF7CB3BA),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
        ],
      ),
    );
  }
}

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  static const _bgColor = Color(0xFFF7F6F0);
  static const _primaryColor = Color(0xFF7CB3BA);
  static const _heartColor = Color(0xFFB84A27);

  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosSessao.lista;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        title: const Text(
          "Favoritos",
          style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
        ),
      ),
      body: favoritos.isEmpty
          ? const Center(
        child: Text(
          "Nenhuma receita favoritada ainda.",
          style: TextStyle(color: Colors.black54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoritos.length,
        itemBuilder: (context, index) {
          final receita = favoritos[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesReceita(receita: receita),
                ),
              );
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Image.network(
                    receita['image'] ?? '',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      receita['name'] ?? 'Sem nome',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite, color: _heartColor),
                    onPressed: () {
                      setState(() {
                        FavoritosSessao.adicionarOuRemover(receita);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}