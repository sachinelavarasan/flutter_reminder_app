import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({
    Key? key,
    required this.title,
    required this.updatedTime,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final String description;
  final String updatedTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1.0, color: const Color.fromRGBO(232, 225, 245, 1)),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(161, 117, 255, 0.7), // shadow color
                blurRadius: 1, // shadow radius
                offset: Offset(1, 1), // shadow offset
                blurStyle: BlurStyle.normal,
                spreadRadius: 0.5, // set blur style
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 44, 43, 43),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 26, 25, 25),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    updatedTime.toString(),
                    style: const TextStyle(
                      color: Color(0xFFC7C3C3),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              )
            ],
          )),
    );
  }
}
