import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added
import '../../../../../core/providers/user_providers.dart'; // Added
import '../../../../core/di/injection.dart';
import '../controller/cuti_controller.dart'; // Added
import 'cuti_form_page.dart';

class CutiListPage extends CleanView {
  const CutiListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CutiListPageState();
}

class _CutiListPageState extends CleanViewState<CutiListPage, CutiController> {
  _CutiListPageState() : super(sl<CutiController>());


  // Trigger data load when view is ready
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A bit hacky way to access controller before build
    // But Clean Arch way: controller.initListeners() or similar
  }

  @override
  Widget get view {
    return Consumer( // Wrap in Consumer
      builder: (context, ref, child) {
        final user = ref.watch(userProvider).currentUser;
        final isAtasan = user?.role?.toLowerCase().contains('atasan') == true || 
                         user?.role?.toLowerCase().contains('admin') == true;

        return ControlledWidgetBuilder<CutiController>(
          builder: (context, controller) {
            if (controller.myHistory.isEmpty && !controller.isLoading) {
              Future.microtask(() => controller.loadMyHistory());
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Riwayat Cuti'),
                actions: [
                  if (isAtasan)
                    IconButton(
                      icon: const Icon(Icons.verified_user),
                      tooltip: 'Verifikasi Bawahan',
                      onPressed: () => Navigator.pushNamed(context, '/cuti/approval'), // Or direct push
                    ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CutiFormPage())).then((_) {
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
                            title: Text(item.jenisCuti ?? '-'),
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
