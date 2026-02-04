import 'package:flutter/material.dart';

import '../../../kehadiran/domain/entities/kehadiran.dart';


class AttendanceActions extends StatefulWidget {
  final Future<Attendance> Function(double lat, double long) onCheckIn;
  final Future<Attendance> Function(double lat, double long) onCheckOut;
  final Attendance? initialData;

  const AttendanceActions({
    super.key,
    required this.onCheckIn,
    required this.onCheckOut,
    this.initialData,
  });

  @override
  State<AttendanceActions> createState() => _AttendanceActionsState();
}

class _AttendanceActionsState extends State<AttendanceActions> {
  bool _isClockedIn = false;
  String _clockInTime = "-- : --";
  String _clockOutTime = "-- : --";
  bool _isAttendanceComplete = false;
  bool _isLoading = false;

  // Status Flags
  bool _isLate = false;
  bool _isEarlyLeave = false;

  @override
  void initState() {
    super.initState();
    _syncWithInitialData();
  }

  @override
  void didUpdateWidget(covariant AttendanceActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData) {
      _syncWithInitialData();
    }
  }

  void _syncWithInitialData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      final hasCheckIn = data.checkInTime.isNotEmpty && data.checkInTime != '-';
      final hasCheckOut =
          data.checkOutTime != null &&
          data.checkOutTime!.isNotEmpty &&
          data.checkOutTime != '-';

      if (mounted) {
        setState(() {
          _isClockedIn = hasCheckIn && !hasCheckOut;
          _clockInTime = hasCheckIn ? data.checkInTime : "-- : --";
          _clockOutTime = hasCheckOut ? data.checkOutTime! : "-- : --";
          _isAttendanceComplete = hasCheckOut;

          _isLate =
              data.status.toUpperCase().contains('TERLAMBAT') ||
              data.status.toUpperCase().contains('TELAT');
        });
      }
    }
  }

  Future<void> _handleAttendanceAction() async {
    if (_isLoading) return;

    if (_isAttendanceComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absensi hari ini sudah selesai')),
      );
      return;
    }

    final bool isCheckingIn = !_isClockedIn;

    setState(() => _isLoading = true);

    try {
      // Metric: Lat/Long dummy for now, usually replaced by Geolocation
      final double lat = 0.0;
      final double long = 0.0;

      Attendance result;

      if (isCheckingIn) {
        result = await widget.onCheckIn(lat, long);
      } else {
        result = await widget.onCheckOut(lat, long);
      }

      if (!mounted) return;

      final now = DateTime.now();
      final String formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      setState(() {
        if (isCheckingIn) {
          _isClockedIn = true;
          _clockInTime = formattedTime; // Or use result.checkInTime
        } else {
          _isClockedIn = false;
          _clockOutTime = formattedTime; // Or use result.checkOutTime
          _isAttendanceComplete = true;
        }
      });
    } catch (e) {
      // Error handled by Controller usually, but we catch locally to stop loading
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define Colors based on state
    final Color primaryColor = _isClockedIn
        ? const Color(0xFFFFB300)
        : const Color(0xFF29B6F6);
    final String buttonLabel = _isClockedIn ? "PULANG" : "MASUK";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
                child: InkWell(
                  onTap: _handleAttendanceAction,
                  borderRadius: BorderRadius.circular(30),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ads_click_rounded,
                                size: 60,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                buttonLabel,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusColumn(
                  "Jam Masuk :",
                  _clockInTime,
                  isNegativeStatus: _isLate,
                  isActive: _clockInTime != "-- : --",
                ),
                _buildStatusColumn(
                  "Jam Keluar :",
                  _clockOutTime,
                  isNegativeStatus: _isEarlyLeave,
                  isActive: _clockOutTime != "-- : --",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(
    String label,
    String time, {
    bool isNegativeStatus = false,
    bool isActive = false,
  }) {
    IconData statusIcon = Icons.check_circle_outline_rounded;
    Color statusColor = Colors.white;

    if (isActive) {
      if (isNegativeStatus) {
        statusIcon = Icons.cancel_outlined;
        statusColor = Colors.redAccent;
      } else {
        statusIcon = Icons.check_circle_rounded;
        statusColor = Colors.greenAccent;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
         const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Icon(
              statusIcon,
              color: statusColor,
              size: 20,
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ],
    );
  }
}
