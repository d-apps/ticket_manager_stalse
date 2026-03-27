import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ticket_manager_stalse/core/mixins/validator_mixin.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:uuid/uuid.dart';
import '../../../tickets/domain/enums/ticket_priority.dart';

class TicketAddOrUpdateForm extends StatefulWidget {
  final TicketEntity? ticket;
  final Function(TicketEntity) onSave;
  const TicketAddOrUpdateForm({this.ticket, required this.onSave, super.key});

  @override
  State<TicketAddOrUpdateForm> createState() => _TicketAddOrUpdateFormState();
}

class _TicketAddOrUpdateFormState extends State<TicketAddOrUpdateForm>
  with FieldValidatorMixin {
  final formKey = GlobalKey<FormState>();

  final customerNameController = TextEditingController();
  final categoryController = TextEditingController();
  TicketPriority? priority;
  final messageController = TextEditingController();

  bool get isEditing => widget.ticket != null;

  @override
  void initState() {
    initFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: customerNameController,
              decoration: InputDecoration(
                labelText: "Nome do cliente",
              ),
              validator: validateEmpty,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: "Categoria",
              ),
              validator: validateEmpty,
            ),
            const SizedBox(height: 10),
            Text("Prioridade:"),
            DropdownButtonFormField<TicketPriority>(
              initialValue: priority,
              items: TicketPriority.values.map((v){
                return DropdownMenuItem<TicketPriority>(
                  value: v,
                  child: Text(v.title),
                );
              }).toList(),
              onChanged: (v){
                setState(() {
                  priority = v;
                });
              },
              validator: (v) => v == null ? "Selecione uma prioridade" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Mensagem",
              ),
              validator: validateEmpty,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      final ticket = TicketEntity(
                        id: isEditing ? widget.ticket!.id : "TKT-${Random(0000).nextInt(1000)}",
                        createdAt: isEditing ? widget.ticket!.createdAt : DateTime.now(),
                        customerName: customerNameController.text,
                        message: messageController.text,
                        status: isEditing ? widget.ticket!.status : TicketStatus.open,
                        priority: priority!,
                        category: categoryController.text,
                      );
                      widget.onSave(ticket);
                    }
                  },
                  child: Text(isEditing ? "ATUALIZAR" : "SALVAR")
              ),
            )
          ],
        ),
      ),
    );
  }

  void initFields(){
    if(isEditing){
      customerNameController.text = widget.ticket!.customerName;
      categoryController.text = widget.ticket!.category;
      priority = widget.ticket!.priority;
      messageController.text = widget.ticket!.message;
    }

  }

    @override
  void dispose() {
    customerNameController.dispose();
    categoryController.dispose();
    messageController.dispose();
    super.dispose();
  }

}
