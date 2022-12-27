import 'package:enduro_app/bloc/Connectivity/connectivity_cubit.dart';
import 'package:enduro_app/presentation/colors.dart';
import 'package:enduro_app/presentation/nav_bar.dart';
import 'package:enduro_app/repo/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ContadorCubit/contador_cubit.dart';

//página do contador

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);
    ConnectivityCubit conCubit = BlocProvider.of<ConnectivityCubit>(context);
    List<Car> selecionados = [];

    return BlocBuilder<ContadorCubit, ContadorState>(
      builder: (context, state) {
        return Scaffold(
          //organização dos itens na lista
          body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Builder(builder: (context) {
                return Dismissible(
                  //excluir itens da lista
                  background: Container(
                    color: Colors.red,
                  ),
                  key: ValueKey<dynamic>(cubit.carList[index]),
                  onDismissed: (DismissDirection direction) {
                    cubit.carList.removeAt(index);
                    const snackBar = SnackBar(content: Text("Carro removido.")
                        //action: SnackBarAction(
                        /*label: 'Desfazer',
                              onPressed: (() {
                                //retorna com o carro excluído (falta fazer)
                              }),
                                )*/
                        );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    title: Text(cubit.carList[index].nomeDaEquipe),
                    subtitle: Text(
                        "Carro: ${cubit.carList[index].numeroDoCarro.toString()}, voltas: ${cubit.carList[index].getVoltas().toString()}"),
                    trailing: Icon(Icons.arrow_drop_down_sharp),
                    onTap: (() {
                      cubit.carList[index].increment();
                      cubit.rebuild();
                    }),
                    selected: selecionados.contains(cubit.carList[index]),
                    selectedColor: deepestBlue,
                    onLongPress: (() {
                      print("pressionado");
                      setState(() {
                        (selecionados.contains(cubit.carList[index]))
                            ? selecionados.remove(cubit.carList[index])
                            : selecionados.add(cubit.carList[index]);

                        if (state is ConnectivityDisconnected) {
                          alertFailed(context);
                        } else if (state is ConnectivityConnected) {
                          conCubit.publishTest(cubit);
                          alertSucess(context);
                        }
                      });
                      alertSucess(context);
                      print(cubit.carList[index].nomeDaEquipe);
                    }),

                    //child: Row
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    /*children: <Widget>[
                      Text(cubit.carList[index].numeroDoCarro.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(cubit.carList[index].nomeDaEquipe,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      Text(
                        cubit.carList[index].getVoltas().toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      //botão de incremento
                      GestureDetector(
                        child: const Icon(Icons.arrow_upward),
                        onTap: () {
                          cubit.carList[index].increment();
                          cubit.rebuild();
                        },
                      ),
                      //botão de decremento
                      GestureDetector(
                        child: const Icon(Icons.arrow_downward),
                        onTap: () {
                          cubit.carList[index].decrement();
                          cubit.rebuild();
                        },
                      ),*/

                    /*GestureDetector(
                          child: const Icon(Icons.check),
                          onLongPress: () {
                            print("Long press");
                            const SizedBox(
                              //conectado
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.check,
                                color: Colors.yellow,
                              ),
                            );
                          },
                          onLongPressCancel: () {
                            print("Long press cancel");
                            const SizedBox(
                              //conectado
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.check,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),*/
                    //],
                  ),
                );
              });
            },
            //adicionar equipe registrada na lista
            itemCount: cubit.getListLenght(),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        );
      },
    );
  }
}
