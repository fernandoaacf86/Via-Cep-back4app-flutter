// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:via_cep/model/via_cep_model.dart';
import 'package:via_cep/pages/cep_page.dart';

class ListTileWidget extends StatelessWidget {
  final ViaCEPModel viaCEPModel;
  const ListTileWidget({
    Key? key,
    required this.viaCEPModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CepPage(
              viaCEPModel: viaCEPModel,
            ),
          ),
        );
      },
      title: Text('${viaCEPModel.cep} - ${viaCEPModel.bairro}'),
      subtitle: Text(
          'Endereço: ${viaCEPModel.logradouro} - ${viaCEPModel.bairro}\n${viaCEPModel.localidade}/${viaCEPModel.uf}'),
      isThreeLine: true,
    );
  }
}
