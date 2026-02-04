import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../core/di/injection.dart';
import '../controller/izin_controller.dart';

class IzinFormPage extends CleanView {
  const IzinFormPage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _IzinFormPageState();
}

class _IzinFormPageState extends CleanViewState<IzinFormPage, IzinController> {
  _IzinFormPageState() : super(sl<IzinController>());

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  
  String? _selectedIzinType;
  final List<String> _izinTypes = [
    "SAKIT",
    "IZIN KELUAR KOTA",
    "TERLAMBAT",
    "PULANG CEPAT",
    "LAINNYA",
  ];

  @override
  Widget get view {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Izin')),
      body: ControlledWidgetBuilder<IzinController>(
        builder: (context, controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                   DropdownButtonFormField<String>(
                    value: _selectedIzinType,
                    items: _izinTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedIzinType = val),
                    decoration: const InputDecoration(labelText: 'Jenis Izin', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(labelText: 'Tanggal Mulai', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                      if (date != null) {
                         _startDateController.text = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(labelText: 'Tanggal Selesai', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                      if (date != null) {
                        _endDateController.text = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                   TextFormField(
                    controller: _alasanController,
                    decoration: const InputDecoration(labelText: 'Alasan', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                   const SizedBox(height: 24),
                   SizedBox(
                     width: double.infinity,
                     height: 50,
                     child: ElevatedButton(
                       onPressed: controller.isLoading
                           ? null
                           : () {
                               if (_selectedIzinType == null || _startDateController.text.isEmpty || _endDateController.text.isEmpty || _alasanController.text.isEmpty) {
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon lengkapi semua data')));
                                 return;
                               }
                               controller.submitIzin(
                                 jenisIzin: _selectedIzinType!,
                                 tanggalMulai: _startDateController.text,
                                 tanggalSelesai: _endDateController.text,
                                 alasan: _alasanController.text,
                               );
                             },
                       child: controller.isLoading ? const CircularProgressIndicator() : const Text('AJUKAN'),
                     ),
                   )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
