import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../domain/entities/izin.dart';
import '../../domain/usecase/create_izin_usecase.dart';
import '../../domain/usecase/reject_izin_usecase.dart';
import 'izin_presenter.dart';

class IzinController extends Controller {
  final IzinPresenter _presenter;

  IzinController(this._presenter);

  bool isLoading = false;
  List<Izin> myHistory = [];
  List<Izin> staffRequests = [];
  String? errorMessage;

  @override
  void onInitState() {
     _presenter.onCreateSuccess = (_) {
      isLoading = false;
       ScaffoldMessenger.of(getContext()).showSnackBar(
        const SnackBar(content: Text('Pengajuan Izin Berhasil')),
      );
      _presenter.getListIzin();
      refreshUI();
      Navigator.pop(getContext(), true);
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
        const SnackBar(content: Text('Izin Disetujui')),
      );
      _presenter.getListBawahan(); 
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
        const SnackBar(content: Text('Izin Ditolak')),
      );
      _presenter.getListBawahan(); 
      refreshUI();
       Navigator.pop(getContext());
    };

    _presenter.onRejectError = (e) {
      isLoading = false;
      _showErrorDialog(e.toString());
      refreshUI();
    };


    super.onInitState();
  }

  void loadMyHistory() {
    _presenter.getListIzin();
  }

  void loadStaffRequests() {
    _presenter.getListBawahan();
  }

  void submitIzin({
    required String jenisIzin,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String alasan,
    String? fileBukti,
  }) {
    isLoading = true;
    refreshUI();
    _presenter.createIzin(CreateIzinParams(
      jenisIzin: jenisIzin,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      alasan: alasan,
      fileBukti: fileBukti,
    ));
  }

  void approve(int id) {
    isLoading = true;
    refreshUI();
    _presenter.approveIzin(id);
  }

  void reject(int id, String catatan) {
    if (catatan.length < 10) {
      _showErrorDialog("Catatan penolakan minimal 10 karakter!");
      return;
    }
    isLoading = true;
    refreshUI();
    _presenter.rejectIzin(RejectIzinParams(izinId: id, catatan: catatan));
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
}
