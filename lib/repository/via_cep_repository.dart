import 'package:dio/dio.dart';
import '../model/via_cep_model.dart';

class ViaCepRepository {
  final Dio _dio = Dio();

  Future<ViaCEPModel> fetchCEP(String cep) async {
    final response = await _dio.get('https://viacep.com.br/ws/$cep/json/');
    if (response.data['erro'] == true || response.statusCode != 200) {
      ViaCEPModel data = ViaCEPModel.construtorError(cep =
          "Error: Cep não encontrado\nStatusCode: ${response.statusCode}");
      return data;
    } else {
      try {
        return ViaCEPModel.fromJson(response.data);
      } catch (e) {
        return ViaCEPModel.construtorError(
            "Error: Cep não encontrado\nStatusCode: ${response.statusCode}");
      }
    }
  }
}
