import 'package:flutter/material.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/models/usuario_model.dart';

class UsuarioProvider with ChangeNotifier {
  UsuarioModel? _usuario = UsuarioModel();

  UsuarioModel? get usuario => _usuario;

  AuthController controller = AuthController();

  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<void> loadUser(BuildContext context) async{
    //RESGATAR DADOS SALVOS DO USUARIO
    final savedUsuario = await controller.getUsuario(context);
    //VERIFICAR SE USUARIO NÃO ESTA VAZIO
    if (savedUsuario != null) {
      _usuario = savedUsuario;
      notifyListeners();
    }
  }

  //ATUALIZAR USUARIO LOCAL
  void updateUsuario(UsuarioModel newUsuario) {
    _usuario = newUsuario;
    notifyListeners();
  }

  @override
  void dispose() {
    //LIMPAR RECURSOS CARREGADOS NO PROVIDER
    super.dispose();
  }
}