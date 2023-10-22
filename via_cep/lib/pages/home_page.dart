import 'package:flutter/material.dart';
import 'package:via_cep/repository/back4app_repository.dart';
import '../model/via_cep_model.dart';
import '../repository/via_cep_repository.dart';
import '../shared/widgets/buttons_widgets.dart';
import '../shared/widgets/listtile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cepController = TextEditingController();
  ViaCEPModel viaCEPModel = ViaCEPModel.construtorVazio();
  Back4AppRepository back4appRepository = Back4AppRepository();

  List<ViaCEPModel> lista = [];

  Future<void> buscarCep(String cep) async {
    viaCEPModel = await ViaCepRepository().fetchCEP(cep);
    lista = await back4appRepository.obterCEPsSalvos();
    setState(() {});
  }

  Future<void> salvarNoBack4App(ViaCEPModel viaCEPModel) async {
    back4appRepository.salvarCEPs(viaCEPModel);
    lista = await back4appRepository.obterCEPsSalvos();
    setState(() {});
  }

  Future<void> carregarDados() async {
    lista = await back4appRepository.obterCEPsSalvos();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViaCep App'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return Dismissible(
              direction: DismissDirection.horizontal,
              key: ValueKey(lista[index].cep),
              child: ListTileWidget(
                viaCEPModel: lista[index],
              ),
              onDismissed: (direction) async {
                back4appRepository.deletarCepPorCEP(lista[index].cep);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Buscar CEP'),
                content: Wrap(
                  children: [
                    TextField(
                      maxLength: 8,
                      keyboardType: TextInputType.number,
                      controller: cepController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ex: 11111222"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonsWidgets(
                              onPressed: () async {
                                await buscarCep(cepController.text);
                                if (viaCEPModel.uf.isNotEmpty) {
                                  //se o cep não existir na lista atual
                                  if (lista.any((element) =>
                                      element.cep == viaCEPModel.cep)) {
                                  } else {
                                    await salvarNoBack4App(viaCEPModel);
                                    setState(() {
                                      lista;
                                    });
                                  }
                                }
                                Navigator.pop(context);
                              },
                              text: 'Pesquisar'),
                          ButtonsWidgets(
                              onPressed: () {
                                Navigator.pop(context);
                                cepController.text = "";
                              },
                              text: 'Cancelar'),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
