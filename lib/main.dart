import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraIMCApp());
}

class CalculadoraIMCApp extends StatelessWidget {
  const CalculadoraIMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const TelaIMC(),
    );
  }
}

class TelaIMC extends StatefulWidget {
  const TelaIMC({super.key});

  @override
  State<TelaIMC> createState() => _TelaIMCState();
}

class _TelaIMCState extends State<TelaIMC> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  double? _imc;
  String _classificacao = '';

  /// Calcula o IMC com base no peso (kg) e altura (cm)
  void _calcularIMC() {
    final peso = double.tryParse(_pesoController.text);
    final alturaCm = double.tryParse(_alturaController.text);

    if (peso == null || alturaCm == null || peso <= 0 || alturaCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira valores válidos!')),
      );
      return;
    }

    final alturaM = alturaCm / 100;
    final imc = peso / (alturaM * alturaM);

    String classificacao;
    if (imc < 18.5) {
      classificacao = 'Abaixo do peso';
    } else if (imc < 25) {
      classificacao = 'Peso normal';
    } else if (imc < 30) {
      classificacao = 'Sobrepeso';
    } else {
      classificacao = 'Obesidade';
    }

    setState(() {
      _imc = imc;
      _classificacao = classificacao;
    });
  }

  /// Limpa os campos e reinicia o cálculo
  void _resetar() {
    setState(() {
      _pesoController.clear();
      _alturaController.clear();
      _imc = null;
      _classificacao = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu corpo'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Calculadora de IMC',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Ícones ilustrativos de gênero
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.male, color: Colors.blue, size: 60),
                SizedBox(width: 30),
                Icon(Icons.female, color: Colors.grey, size: 60),
              ],
            ),

            const SizedBox(height: 20),

            // Campo de entrada do peso
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Seu peso (kg)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Campo de entrada da altura
            TextField(
              controller: _alturaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sua altura (cm)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Botão de cálculo
            ElevatedButton(
              onPressed: _calcularIMC,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: const Text(
                'Calcular IMC',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            // Exibe o resultado, se existir
            if (_imc != null)
              Column(
                children: [
                  Text(
                    'Seu IMC',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _imc!.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _classificacao,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _resetar,
                    child: const Text(
                      'Calcular novamente',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 40),

            // Categorias de IMC
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categorias de IMC',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Menos de 18,5 — Abaixo do peso.'),
                  Text('18,5 a 24,9 — Peso normal.'),
                  Text('25 a 29,9 — Sobrepeso.'),
                  Text('30 ou mais — Obesidade.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
