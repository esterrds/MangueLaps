import 'package:mangue_laps/bloc/Connectivity/connectivity_cubit.dart';
import 'package:mangue_laps/bloc/ContadorCubit/contador_cubit.dart';
import 'package:mangue_laps/presentation/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'alert/msg_alerta.dart';

//3 tracinhos
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    //conexão mqtt
    ConnectivityCubit conCubit = BlocProvider.of<ConnectivityCubit>(context);
    //dados da lista
    //ContadorCubit carCubit = BlocProvider.of<ContadorCubit>(context);

    return Drawer(
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          return ListView(
            children: [
              Container(
                //design do primeiro container
                color: const Color.fromRGBO(0, 125, 83, 49),
                height: 50,
                child: IconButton(
                  onPressed: () {
                    //liga e desliga conexão
                    if (state is ConnectivityDisconnected) {
                      conCubit.mqttConnect();
                    } else if (state is ConnectivityConnected) {
                      conCubit.mqttDisconnect();
                    } else {
                      conCubit.mqttConnect();
                    }
                  },
                  icon: state is ConnectivityDisconnected
                      ? const SizedBox(
                          //desconectado
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox(
                          //conectado
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.yellow,
                          ),
                        ),
                ),
              ),
              Container(
                //design do segundo container
                color: midBlue,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          //enviar mensagens
                          if (state is ConnectivityDisconnected) {
                            testeFail(context);
                          } else if (state is ConnectivityConnected) {
                            //conCubit.publishTest(carCubit);
                            teste(context);
                          } else {
                            wait(context);
                          }
                        },
                        child: const Text('TESTAR CONEXÃO',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black))),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),

              //logo mangue baja
              SizedBox(
                width: 50,
                height: 180,
                child:
                    Image.asset('assets/images/LOGO DA MANGUE OFICIAL 2.png'),
              ),
              /*const SizedBox(
                height: 400,
              ),*/
              Row(
                children: const [
                  Text(
                    '© Todos os direitos reservados.',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
