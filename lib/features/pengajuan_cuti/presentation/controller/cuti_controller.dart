import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../domain/entities/cuti.dart';
import '../../domain/usecase/create_cuti_usecase.dart';
import '../../domain/usecase/reject_cuti_usecase.dart';
import 'cuti_presenter.dart';

class CutiController extends Controller {
  final CutiPresenter _presenter;

  CutiController(this._presenter);

  bool isLoading = false;
  List<Cuti> myHistory = [];
  List<Cuti> staffRequests = []; // For Atasan
  String? errorMessage;

  @override
  void onInitState() {
     _presenter.onCreateSuccess = (_) {
      isLoading = false;
       ScaffoldMessenger.of(getContext()).showSnackBar(
        const SnackBar(content: Text('Pengajuan Cuti Berhasil')),
      );
      // Refresh list
      _presenter.getListCuti();
      refreshUI();
      Navigator.pop(getContext(), true); // Return success
    };
    
    _presenter.onCreateError = (e) {
      isLoading = false;
      errorMessage = e.toString();
      _showErrorDialog(errorMessage!);
      refreshUI();
    };

    _presenter.onGetListSuccess = (list) {
      myHistory = list;
      refreshUI();
    };

    _presenter.onGetListError = (e) {
       print("Error loading history: $e");
    };

    _presenter.onGetListBawahanSuccess = (list) {
      staffRequests = list;
      refreshUI();
    };

    _presenter.onGetListBawahanError = (e) {
      print("Error loading staff requests: $e");
    };

    _presenter.onApproveSuccess = (_) {
      isLoading = false;
      ScaffoldMessenger.of(getContext()).showSnackBar(
        const SnackBar(content: Text('Cuti Disetujui')),
      );
      _presenter.getListBawahan(); // Refresh list
      refreshUI();
    };

    _presenter.onApproveError = (e) {
      isLoading = false;
      _showErrorDialog(e.toString());
      refreshUI();
    };

    _presenter.onRejectSuccess = (_) {
      isLoading = false;
      ScaffoldMessenger.of(getContext()).showSnackBar(
        const SnackBar(content: Text('Cuti Ditolak')),
      );
      _presenter.getListBawahan(); // Refresh list
      refreshUI();
       Navigator.pop(getContext()); // Close rejection dialog if open
    };

    _presenter.onRejectError = (e) {
      isLoading = false;
      _showErrorDialog(e.toString());
      refreshUI();
    };


    super.onInitState();
  }

  void loadMyHistory() {
    _presenter.getListCuti();
  }

  void loadStaffRequests() {
    _presenter.getListBawahan();
  }

  void submitCuti({
    required String jenisCuti,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String alasan,
    String? fileBukti,
  }) {
    isLoading = true;
    refreshUI();
    _presenter.createCuti(CreateCutiParams(
      jenisCuti: jenisCuti,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      alasan: alasan,
      fileBukti: fileBukti,
    ));
  }

  void approve(int id) {
    isLoading = true;
    refreshUI();
    _presenter.approveCuti(id);
  }

  void reject(int id, String catatan) {
    if (catatan.length < 10) {
      _showErrorDialog("Catatan penolakan minimal 10 karakter!");
      return;
    }
    isLoading = true;
    refreshUI();
    _presenter.rejectCuti(RejectCutiParams(cutiId: id, catatan: catatan));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: getContext(),
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

   @override
  void initListeners() {
   
  }


  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }
  
}
