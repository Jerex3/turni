import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/form_builder/form_builder.dart';
import '../../../../core/utils/form_builder/form_builder_field.dart';
import '../../../../domain/entities/session.dart';
import '../../../core/custom_time_picker.dart';

class SessionFormDropdown extends StatefulWidget {

  const SessionFormDropdown({super.key, this.session, required this.onCancel, required this.onSave});

  final Function() onCancel;
  final Function(TimeOfDay, TimeOfDay) onSave;

  final Session? session;

  @override
  State<SessionFormDropdown> createState() => _SessionFormDropdownState();
}

class _SessionFormDropdownState extends State<SessionFormDropdown> {

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();


  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      onChanged: () {
          setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 500,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(widget.session != null) const Text("Modificar Turno", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                  if(widget.session == null) const Text("Agregar Turno",  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(       
                crossAxisAlignment: CrossAxisAlignment.start,     
                children: [
                   const SizedBox(height: 40,),
                   const Text("Horario del turno"),
                   const SizedBox(height: 16,),
                   CustomTimePicker(
                    name: "startTime",
                    initialHours: widget.session?.startTime.hour.toString(),
                    initialMinutes: widget.session?.startTime.minute.toString(),
                    onChange: (sessionStartTime) {},
                   ),
                   
                ],
              ),
            ),
            const SizedBox(height: 8,),
            const Divider(),
            const SizedBox(height: 8,),
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,     
                    children: [
                      const Text("Duracion del turno"),
                      const SizedBox(height: 16,),
                      CustomTimePicker(
                        name: "duration",
                        initialHours: widget.session?.duration != null ? widget.session?.duration.split(":")[0] : null,
                        initialMinutes: widget.session?.duration != null ? widget.session?.duration.split(":")[1] : null,
                        onChange: (duration) {},
      
                      )
                    ],
                  ),
            
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: widget.onCancel, child: Text("Cancelar"))),
                SizedBox(width: 16,),
                Expanded(child: FilledButton(onPressed: onPressedSave(), child: Text("Guardar")))
              ],
            )
          ],
        ),
      ),
    );
  }

  onPressedSave(){

    if(_formKey.currentState?.instantValue == null) return null;

    final values = _formKey.currentState!.instantValue;

    if(values['startTime'] == null || values['duration'] == null) return null;
    
    return (){
      widget.onSave(values['startTime'], values['duration']);
    };

  }
}

