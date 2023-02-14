import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mangue_laps/bloc/ContadorCubit/contador_cubit.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repo/models/car.dart';

class CarListIten extends StatefulWidget {
  const CarListIten({Key? key, required this.carro, required this.onDelete})
      : super(key: key);

  final Carro carro;
  final Function(Carro) onDelete;

  @override
  State<CarListIten> createState() => _CarListItenState();
}

class _CarListItenState extends State<CarListIten> {
  CarRepository carRepo = CarRepository();
  List<Carro> carros = [];
  @override
  Widget build(BuildContext context) {
    ContadorCubit carCubit = ContadorCubit();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Slidable(
            actionExtentRatio: 0.25,
            actionPane: const SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                  color: Colors.red,
                  icon: Icons.delete,
                  caption: 'Deletar',
                  onTap: () {
                    widget.onDelete(widget.carro);
                  })
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.carro.numero} - ${widget.carro.nome}  ---  Voltas: ${widget.carro.getVoltas()}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
