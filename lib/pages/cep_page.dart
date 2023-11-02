// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:via_cep/model/via_cep_model.dart';
import 'package:via_cep/pages/home_page.dart';
import 'package:via_cep/repository/back4app_repository.dart';
import 'package:via_cep/repository/via_cep_repository.dart';

import '../shared/widgets/buttons_widgets.dart';

class CepPage extends StatefulWidget {
  //Modelo usado para montar a pagina
  final ViaCEPModel viaCEPModel;
  const CepPage({
    Key? key,
    required this.viaCEPModel,
  }) : super(key: key);

  @override
  State<CepPage> createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  final Back4AppRepository back4appRepository = Back4AppRepository();
  final TextEditingController cepController = TextEditingController();
  final ViaCepRepository viaCepRepository = ViaCepRepository();

  //Modelo usado para atualizar novos dados
  ViaCEPModel viaCEPModelConst = ViaCEPModel.construtorVazio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.blueGrey,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 130, 174, 196),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 250,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // Cor de fundo do Card
              borderRadius: BorderRadius.circular(10), // Borda arredondada
              border: Border.all(
                color: Colors.black, // Cor da borda
                width: 1.0, // Largura da borda
              ),
            ),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CEP: ${widget.viaCEPModel.cep}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Endereço: ${widget.viaCEPModel.logradouro} - ${widget.viaCEPModel.bairro}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Cidade: ${widget.viaCEPModel.localidade} / ${widget.viaCEPModel.uf}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: ElevatedButton(
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
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ButtonsWidgets(
                                                    onPressed: () async {
                                                      viaCEPModelConst =
                                                          await viaCepRepository
                                                              .buscarCEP(
                                                                  cepController
                                                                      .text);
                                                      if (viaCEPModelConst
                                                          .uf.isNotEmpty) {
                                                        back4appRepository.atualizarCEP(
                                                            context: context,
                                                            viaCEPModel: widget
                                                                .viaCEPModel,
                                                            viaCEPModelNovo:
                                                                viaCEPModelConst);
                                                      }
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomePage(),
                                                        ),
                                                      );
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
                              child: const Text('Editar CEP'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
