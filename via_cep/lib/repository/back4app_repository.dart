import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/via_cep_model.dart';

class Back4AppRepository {
  final _dio = Dio();
  Back4AppRepository() {
    _dio.options.headers['X-Parse-Application-Id'] =
        dotenv.env['BACK4APPAPPLICATIONID'];
    _dio.options.headers['X-Parse-REST-API-Key'] =
        dotenv.env['BACK4APPRESTAPIKEY'];
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes';
  }

  //recupera CEPsCadastrados -- FUNCIONANDO
  Future<List<ViaCEPModel>> obterCEPsSalvos() async {
    String url = '/CepUsuario';
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> results = response.data['results'];
      List<ViaCEPModel> cepList = [];

      for (var result in results) {
        ViaCEPModel viaCEPModel = ViaCEPModel.fromJson(result);
        cepList.add(viaCEPModel);
      }

      return cepList;
    } else {
      return [
        ViaCEPModel.construtorError('Não foi possivel acessar o servidor.')
      ];
    }
  }

  Future<void> salvarCEPs(ViaCEPModel viaCEPModel) async {
    String url = '/CepUsuario';

    if (viaCEPModel.uf.isNotEmpty) {
      var data = viaCEPModel.toJson();

      try {
        await _dio.post(url, data: data);
      } catch (e) {}
    }
  }

  Future<void> deletarCepPorCEP(String cep) async {
    String url = '/CepUsuario';

    try {
      // Primeiro, faça uma consulta para obter o objectId do objeto com base no CEP
      final response = await _dio.get('$url?where={"cep":"$cep"}');
      final results = response.data['results'];

      if (results.isNotEmpty) {
        final String objectId = results[0]['objectId'];

        // Agora você pode excluir o objeto usando o objectId obtido
        await _dio.delete('$url/$objectId');
      } else {}
    } catch (e) {}
  }

  Future<void> atualizarCep({
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

    if (viaCEPModel.uf.isNotEmpty) {
      try {
        await _dio.put("$url/$objectId", data: viaCEPModelNovo);
      } catch (e) {
        print(e);
      }
    }
  }

  // Future<Void> salvarCep(ViaCEPModel viaCEPModel) {}
}
