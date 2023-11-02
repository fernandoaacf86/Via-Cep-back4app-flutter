// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:via_cep/via_cep_app.dart';
import '../model/via_cep_model.dart';

class Back4AppRepository extends ChangeNotifier {
  final List<ViaCEPModel> listaDeDados = [];
  final _dio = Dio();

  Back4AppRepository() {
    _dio.options.headers['X-Parse-Application-Id'] =
        dotenv.env['BACK4APPAPPLICATIONID'];
    _dio.options.headers['X-Parse-REST-API-Key'] =
        dotenv.env['BACK4APPRESTAPIKEY'];
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes';
  }

  //recupera CEPsCadastrados e retorna uma a lista -- FUNCIONANDO
  Future<void> obterCEPsSalvos() async {
    listaDeDados.clear();
    String url = '/CepUsuario';
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> results = response.data['results'];

      for (var result in results) {
        ViaCEPModel viaCEPModel = ViaCEPModel.fromJson(result);
        listaDeDados.add(viaCEPModel);
      }
    }
    notifyListeners();
  }

  Future<void> salvarCEP(ViaCEPModel viaCEPModel, BuildContext context) async {
    String url = '/CepUsuario';

    if (viaCEPModel.uf.isNotEmpty && !verificaDuplicidade(viaCEPModel)) {
      var data = viaCEPModel.toJson();

      try {
        await _dio.post(url, data: data);
        obterCEPsSalvos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados salvos com sucesso!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dados não foram salvos. $e'),
          ),
        );
      }
    }
  }

  Future<void> deletarCEP(String cep, BuildContext context) async {
    String url = '/CepUsuario';

    try {
      // Primeiro, faça uma consulta para obter o objectId do objeto com base no CEP
      final response = await _dio.get('$url?where={"cep":"$cep"}');
      final results = response.data['results'];

      if (results.isNotEmpty) {
        final String objectId = results[0]['objectId'];

        // Agora você pode excluir o objeto usando o objectId obtido
        await _dio.delete('$url/$objectId');
        obterCEPsSalvos();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados não foram deletados. $e'),
        ),
      );
    }
  }

  Future<void> atualizarCEP({
    required BuildContext context,
    required viaCEPModel,
    required viaCEPModelNovo,
  }) async {
    String cep = viaCEPModel.cep;
    String url = '/CepUsuario';

    //capturando o cep no back4app

    final response = await _dio.get('$url?where={"cep":"$cep"}');
    final results = response.data['results'];
    //isolando o objectId do cep no back4app
    final String objectId = results[0]['objectId'];

    if (viaCEPModel.uf.isNotEmpty && verificaDuplicidade(viaCEPModel)) {
      try {
        await _dio.put("$url/$objectId", data: viaCEPModelNovo);
        obterCEPsSalvos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi posível atualizar os dados. $e'),
          ),
        );
      }
    }
  }

  List<ViaCEPModel> retornaLista() {
    return listaDeDados;
  }

  bool verificaDuplicidade(ViaCEPModel viaCEPModel) {
    for (var element in listaDeDados) {
      if (element.cep == viaCEPModel.cep) {
        return true;
      }
    }
    return false;
  }
}
