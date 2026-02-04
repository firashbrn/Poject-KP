import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../core/di/injection.dart';
import '../controller/cuti_controller.dart';
// Ensure usage of core widgets

class CutiFormPage extends CleanView {
  const CutiFormPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CutiFormPageState();
}

class _CutiFormPageState extends CleanViewState<CutiFormPage, CutiController> {
  _CutiFormPageState() : super(sl<CutiController>());

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  
  String? _selectedCutiType;
  final List<String> _cutiTypes = [
    "CUTI TAHUNAN",
    "CUTI BESAR",
    "CUTI SAKIT",
    "CUTI MELAHIRKAN",
    "CUTI ALASAN PENTING",
    "CUTI DILUAR TANGGUNGAN NEGARA",
  ];

  @override
  Widget get view {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Cuti')),
      body: ControlledWidgetBuilder<CutiController>(
        builder: (context, controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                   DropdownButtonFormField<String>(
                    value: _selectedCutiType,
                    items: _cutiTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedCutiType = val),
                    decoration: const InputDecoration(labelText: 'Jenis Cuti', border: OutlineInputBorder()),
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
                               if (_selectedCutiType == null || _startDateController.text.isEmpty || _endDateController.text.isEmpty || _alasanController.text.isEmpty) {
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon lengkapi semua data')));
                                 return;
                               }
                               controller.submitCuti(
                                 jenisCuti: _selectedCutiType!,
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
