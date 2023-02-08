import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../repo/models/car.dart';

class CarListIten extends StatelessWidget {
  const CarListIten({Key? key, required this.carro, required this.onDelete})
      : super(key: key);

  final Carro carro;
  final Function(Carro) onDelete;

  @override
  Widget build(BuildContext context) {
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
                    onDelete(carro);
                  })
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Text(carro.dateTime.toString(),
                //style: TextStyle(fontSize: 12),
                //),

                Text(
                  '${carro.numero} - ${carro.nome}  voltas: ${carro.getVoltas()}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),

                ElevatedButton(
                    onPressed: () {
                      carro.increment();
                    },
                    child: const Icon(Icons.add))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
