import 'package:flutter/material.dart';
import 'DetalheReceita.dart';
import 'ReceeitaApi.dart';

class ResultadosPesquisa extends StatefulWidget {
  final String termoInicial;

  const ResultadosPesquisa({super.key, this.termoInicial = "Chicken"});

  @override
  State<ResultadosPesquisa> createState() => _ResultadosPesquisaState();
}

class _ResultadosPesquisaState extends State<ResultadosPesquisa> {
  static const _bgColor = Color(0xFFF7F6F0);
  static const _primaryColor = Color(0xFF7CB3BA);

  late TextEditingController _controller;
  List _filtradas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.termoInicial);
    _pesquisarNaApi(widget.termoInicial);
  }

  Future<void> _pesquisarNaApi(String texto) async {
    if (texto.trim().isEmpty) return;

    setState(() {
      _carregando = true;
    });

    try {
      final lista = await ReceitaApi.pesquisar(texto);
      setState(() {
        _filtradas = lista;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _filtradas = [];
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Pesquisar receitas",
          style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onSubmitted: _pesquisarNaApi,
              decoration: InputDecoration(
                hintText: "Buscar pelo nome",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    Navigator.pop(context);
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_carregando)
              const Expanded(
                child: Center(child: CircularProgressIndicator(color: _primaryColor)),
              )
            else if (_filtradas.isEmpty)
              Expanded(child: _buildNoResultsState())
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultados para "${_controller.text.trim()}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Toque na receita para ver o preparo.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filtradas.length,
                        itemBuilder: (context, index) {
                          return _buildRecipeCard(_filtradas[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        _controller.clear();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: const BorderSide(color: _primaryColor),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Limpar pesquisa",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> receita) {
    final prep = receita['prepTimeMinutes'] ?? 0;
    final cook = receita['cookTimeMinutes'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalhesReceita(receita: receita),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Image.network(
              receita['image'] ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.restaurant,
                size: 50,
                color: _primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receita['name'] ?? 'Sem nome',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${prep + cook} min  •  ${receita['difficulty'] ?? 'Fácil'}  •  ★ ${receita['rating'] ?? '-'}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 54, color: _primaryColor),
          const SizedBox(height: 16),
          const Text(
            "Nenhum resultado",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Não encontramos receitas para esse nome.\nTente outro termo.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Ver todas as receitas",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}