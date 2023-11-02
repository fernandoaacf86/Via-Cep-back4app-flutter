// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:via_cep/repository/back4app_repository.dart';

import '../../model/via_cep_model.dart';
import '../../repository/via_cep_repository.dart';
import 'buttons_widgets.dart';
import 'textfield_widget.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final TextEditingController cepController;
  final Back4AppRepository back4appRepository;
  ViaCEPModel viaCEPModel;
  FloatingActionButtonWidget({
    super.key,
    required this.cepController,
    required this.back4appRepository,
    required this.viaCEPModel,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Buscar CEP'),
              content: Wrap(
                children: [
                  TextFieldCEPWidget(cepController: cepController),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonsWidgets(
                          onPressed: () async {
                            viaCEPModel = await ViaCepRepository()
                                .buscarCEP(cepController.text);
                            back4appRepository.salvarCEP(viaCEPModel, context);
                            Navigator.pop(context);
                          },
                          text: 'Pesquisar',
                        ),
                        ButtonsWidgets(
                            onPressed: () {
                              cepController.text = "";
                              Navigator.pop(context);
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
    );
  }
}
