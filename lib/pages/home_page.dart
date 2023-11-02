import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:via_cep/repository/back4app_repository.dart';
import 'package:via_cep/shared/widgets/floating_action_button_widget.dart';
import '../model/via_cep_model.dart';
import '../shared/widgets/listtile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cepController = TextEditingController();
  ViaCEPModel viaCEPModel = ViaCEPModel.construtorVazio();

  @override
  Widget build(BuildContext context) {
    final dataBack4App = Provider.of<Back4AppRepository>(context);
    print(dataBack4App.listaDeDados);
    // Carregue os dados do banco de dados no início do aplicativo
    Future<void> loadData() async {
      await dataBack4App.obterCEPsSalvos();
    }

    // Verifique se os dados já foram carregados e evite recarregar
    if (dataBack4App.listaDeDados.isEmpty) {
      loadData();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViaCep App'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dataBack4App.listaDeDados.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return Dismissible(
              direction: DismissDirection.horizontal,
              key: ValueKey(dataBack4App.listaDeDados[index].cep),
              child: ListTileWidget(
                viaCEPModel: dataBack4App.listaDeDados[index],
              ),
              onDismissed: (direction) async {
                dataBack4App.deletarCEP(
                    dataBack4App.listaDeDados[index].cep, context);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButtonWidget(
        back4appRepository: dataBack4App,
        cepController: cepController,
        viaCEPModel: viaCEPModel,
      ),
    );
  }
}
