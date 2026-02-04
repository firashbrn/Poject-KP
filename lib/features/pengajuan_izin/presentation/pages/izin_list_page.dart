import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/user_providers.dart';
import '../../../../core/di/injection.dart';
import '../controller/izin_controller.dart';
import 'izin_form_page.dart';

class IzinListPage extends CleanView {
  const IzinListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IzinListPageState();
}

class _IzinListPageState extends CleanViewState<IzinListPage, IzinController> {
  _IzinListPageState() : super(sl<IzinController>());

  @override
  Widget get view {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(userProvider).currentUser;
        final isAtasan = user?.role?.toLowerCase().contains('atasan') == true || 
                         user?.role?.toLowerCase().contains('admin') == true;

        return ControlledWidgetBuilder<IzinController>(
          builder: (context, controller) {
            if (controller.myHistory.isEmpty && !controller.isLoading) {
              Future.microtask(() => controller.loadMyHistory());
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Riwayat Izin'),
                actions: [
                  if (isAtasan)
                    IconButton(
                      icon: const Icon(Icons.verified_user),
                      tooltip: 'Verifikasi Bawahan',
                      onPressed: () => Navigator.pushNamed(context, '/izin/approval'),
                    ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const IzinFormPage())).then((_) {
                    controller.loadMyHistory();
                  });
                },
              ),
              body: controller.isLoading && controller.myHistory.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: controller.myHistory.length,
                      itemBuilder: (context, index) {
                        final item = controller.myHistory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(item.jenisIzin ?? '-'),
                            subtitle: Text("${item.tanggalMulai} s/d ${item.tanggalSelesai}\nStatus: ${item.status}"),
                            isThreeLine: true,
                            trailing: _buildStatusIcon(item.status),
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusIcon(String? status) {
    if (status == 'DISETUJUI') return const Icon(Icons.check_circle, color: Colors.green);
    if (status == 'DITOLAK') return const Icon(Icons.cancel, color: Colors.red);
    return const Icon(Icons.hourglass_empty, color: Colors.orange);
  }
}
