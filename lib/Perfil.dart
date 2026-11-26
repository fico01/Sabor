import 'package:flutter/material.dart';
import 'DetalheReceita.dart';
import 'ResultadoPesquisa.dart';
import 'ReceeitaApi.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  static const _bgColor = Color(0xFFF7F6F0);
  static const _primaryColor = Color(0xFF7CB3BA);
  static const _heartColor = Color(0xFFB84A27);

  final _buscaController = TextEditingController();
  String? _mensagemErro;

  List _receitas = [];
  bool _carregando = true;
  String? _erroApi;

  // Controle simples do Easter Egg (3 toques na logo do topo)
  int _toquesLogo = 0;
  bool _mostrarEasterEgg = false;

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    setState(() {
      _carregando = true;
      _erroApi = null;
    });

    try {
      final lista = await ReceitaApi.buscarTodas();
      setState(() {
        _receitas = lista;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erroApi = "Erro ao carregar receitas: $e";
        _carregando = false;
      });
    }
  }

  void _validarBusca(String valor) {
    setState(() {
      if (valor.trim().isEmpty) {
        _mensagemErro = "Digite o nome de uma receita!";
      } else {
        _mensagemErro = null;
      }
    });
  }

  void _buscarReceitas() async {
    _validarBusca(_buscaController.text);
    if (_mensagemErro != null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadosPesquisa(termoInicial: _buscaController.text.trim()),
      ),
    );
    setState(() {});
  }

  void _contarToqueEasterEgg() {
    _toquesLogo++;
    if (_toquesLogo >= 3) {
      _toquesLogo = 0;
      setState(() {
        _mostrarEasterEgg = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _mostrarEasterEgg = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        title: GestureDetector(
          onTap: _contarToqueEasterEgg,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  'https://tr.rbxcdn.com/180DAY-117f807c063d7bdf551dd75af19eb1ba/420/420/Hat/Webp/noFilter',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.restaurant,
                    color: _primaryColor,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Sabôr",
                style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 16),

                const Text(
                  "Receitas",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Pesquise uma receita pelo nome.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _buscaController,
                  onChanged: _validarBusca,
                  decoration: InputDecoration(
                    hintText: "Buscar pelo nome",
                    errorText: _mensagemErro,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: _buscarReceitas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Buscar receitas",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Receitas disponíveis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Selecione uma receita para ver o preparo.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                if (_carregando)
                  const Center(child: CircularProgressIndicator(color: _primaryColor))
                else if (_erroApi != null)
                  Column(
                    children: [
                      Text(_erroApi!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _carregarReceitas,
                        child: const Text("Tentar novamente"),
                      ),
                    ],
                  )
                else
                  ..._receitas.map((receita) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalhesReceita(receita: receita),
                            ),
                          );
                          setState(() {});
                        },
                        child: _buildRecipeCard(receita),
                      ),
                    );
                  }),
              ],
            ),
          ),

          // Popup do Easter Egg
          if (_mostrarEasterEgg)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'imgs/jm.jpeg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Você achou o segredo do Sabôr!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map receita) {
    final favorita = FavoritosSessao.jaEstaNosFavoritos(receita['id']);
    final prep = receita['prepTimeMinutes'] ?? 0;
    final cook = receita['cookTimeMinutes'] ?? 0;
    final tempoTotal = prep + cook;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              receita['image'] ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: const Icon(Icons.restaurant, color: _primaryColor),
              ),
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
                  "$tempoTotal min  •  ${receita['difficulty'] ?? 'Fácil'}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              favorita ? Icons.favorite : Icons.favorite_border,
              color: favorita ? _heartColor : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                FavoritosSessao.adicionarOuRemover(receita);
              });
            },
          ),
        ],
      ),
    );
  }
}