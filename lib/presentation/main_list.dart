import 'dart:developer';

import 'package:appdowill/bloc/cubit/contador_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

    return BlocBuilder<ContadorCubit, ContadorState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(cubit.getCars()[index].nomeDaEquipe),
                    Text(cubit.getCars()[index].numeroDoCarro.toString()),
                    Text(cubit.getCars()[index].getVoltas().toString()),
                  ],
                ),
              );
            },
            itemCount: cubit.getListLenght(),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        );
      },
    );
  }
}
