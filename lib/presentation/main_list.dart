import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ContadorCubit/contador_cubit.dart';

//página do contador

class MainList extends StatelessWidget {
  const MainList({super.key});

  @override
  Widget build(BuildContext context) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

    return BlocBuilder<ContadorCubit, ContadorState>(
      builder: (context, state) {
        return Scaffold(
          //organização dos itens na lista
          //padding: const EdgeInsets.symmetric(horizontal: 13.0),
          body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Builder(builder: (context) {
                return Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  child: Dismissible(
                    //excluir itens da lista
                    background: Container(
                      color: Colors.red,
                    ),
                    key: ValueKey<dynamic>(cubit.carList[index]),
                    onDismissed: (DismissDirection direction) {
                      cubit.carList.removeAt(index);
                      final snackBar = const SnackBar(
                          content: Text("Carro removido.")
                          //action: SnackBarAction(
                          /*label: 'Desfazer',
                              onPressed: (() {
                                //retorna com o carro excluído (falta fazer)
                              }),
                                )*/
                          );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                        ),
                        GestureDetector(
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
                        ),
                      ],
                    ),
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
