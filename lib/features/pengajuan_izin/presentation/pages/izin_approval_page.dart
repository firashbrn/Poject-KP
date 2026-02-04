import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../core/di/injection.dart';
import '../controller/izin_controller.dart';
import '../../domain/entities/izin.dart';

class IzinApprovalPage extends CleanView {
  const IzinApprovalPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IzinApprovalPageState();
}

class _IzinApprovalPageState extends CleanViewState<IzinApprovalPage, IzinController> {
  _IzinApprovalPageState() : super(sl<IzinController>());

  @override
  Widget get view {
    return ControlledWidgetBuilder<IzinController>(
      builder: (context, controller) {
        if (controller.staffRequests.isEmpty && !controller.isLoading) {
           Future.microtask(() => controller.loadStaffRequests());
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Verifikasi Izin Bawahan')),
          body: controller.isLoading && controller.staffRequests.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.staffRequests.length,
                  itemBuilder: (context, index) {
                    final item = controller.staffRequests[index];
                    return Card(
                      child: ExpansionTile(
                        title: Text("${item.namaUser} (${item.userId ?? '-'})"),
                        subtitle: Text(item.jenisIzin ?? '-'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tanggal: ${item.tanggalMulai} - ${item.tanggalSelesai}"),
                                Text("Alasan: ${item.alasan}"),
                                const SizedBox(height: 16),
                                if (item.status == 'MENUNGGU') ... [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: () => _showRejectDialog(context, controller, item),
                                        child: const Text('TOLAK', style: TextStyle(color: Colors.white)),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        onPressed: () => controller.approve(item.id!),
                                        child: const Text('SETUJUI', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  )
                                ] else ... [
                                   Text("Status: ${item.status}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                ]
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, IzinController controller, Izin item) {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tolak Pengajuan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Wajib menyertakan alasan penolakan (min. 10 karakter)."),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(hintText: "Alasan penolakan...", border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
               controller.reject(item.id!, reasonController.text);
            }, 
            child: const Text("Kirim Penolakan")
          ),
        ],
      ),
    );
  }
}
