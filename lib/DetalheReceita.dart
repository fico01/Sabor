import 'package:flutter/material.dart';
import 'ReceeitaApi.dart';

class DetalhesReceita extends StatefulWidget {
  final Map<String, dynamic> receita;

  const DetalhesReceita({super.key, required this.receita});

  @override
  State<DetalhesReceita> createState() => _DetalhesReceitaState();
}

class _DetalhesReceitaState extends State<DetalhesReceita> {
  static const _bgColor = Color(0xFFF7F6F0);
  static const _primaryColor = Color(0xFF7CB3BA);
  static const _heartColor = Color(0xFFB84A27);

  @override
  Widget build(BuildContext context) {
    final receita = widget.receita;
    final isFavorita = FavoritosSessao.jaEstaNosFavoritos(receita['id']);

    final List ingredientes = receita['ingredients'] ?? [];
    final List passos = receita['instructions'] ?? [];
    final prep = receita['prepTimeMinutes'] ?? 0;
    final cook = receita['cookTimeMinutes'] ?? 0;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Receita",
          style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorita ? Icons.favorite : Icons.favorite_border,
              color: _heartColor,
            ),
            onPressed: () {
              setState(() {
                FavoritosSessao.adicionarOuRemover(receita);
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Image.network(
                receita['image'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.restaurant,
                  size: 64,
                  color: _primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              receita['name'] ?? 'Sem nome',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${receita['cuisine'] ?? 'Geral'}  •  ${receita['difficulty'] ?? 'Fácil'}  •  ★ ${receita['rating'] ?? '-'}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _buildInfoBox("${prep + cook} min", "tempo total"),
                const SizedBox(width: 10),
                _buildInfoBox("${receita['servings'] ?? '-'}", "porções"),
                const SizedBox(width: 10),
                _buildInfoBox(
                  isFavorita ? "Salva" : "Não salva",
                  "nos favoritos",
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              "Ingredientes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...ingredientes.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: _primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item.toString(), style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Modo de preparo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(passos.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: _primaryColor,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        passos[index].toString(),
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}