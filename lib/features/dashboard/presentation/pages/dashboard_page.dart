import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../core/di/injection.dart';
import '../../../banner/presentation/widgets/banner_slider.dart';
import '../widgets/action_status_card.dart';
import '../widgets/attendance_actions.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/service_menu.dart';
import 'dashboard_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';
import 'dart:ui';

class DashboardPage extends CleanView {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends CleanViewState<DashboardPage, DashboardController> {
  _DashboardPageState() : super(sl<DashboardController>());

  @override
  Widget get view {
    return ControlledWidgetBuilder<DashboardController>(
      builder: (context, controller) {
        return Scaffold(
          key: globalKey,
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFF1A1A2E), // Fallback
          body: Stack(
            children: [
              // 1. Background
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF1A1A2E), // Fallback if no image
                  // Add Image.asset here if available
                ),
              ),
               Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // 2. Main Content
              Consumer(
                builder: (context, ref, child) {
                  return SafeArea(
                    bottom: false,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                           child: SizedBox(height: 80), // Space for Header
                        ),
                        
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Stack(
                            children: [
                                // Layer 1: Service Menu at Bottom
                                const Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: ServiceMenu(),
                                ),

                                // Layer 2: Main Attendance Card Area
                                Column(
                                  children: [
                                     // Banner Slider
                                     if (controller.banners != null && controller.banners!.isNotEmpty)
                                       Padding(
                                         padding: const EdgeInsets.only(bottom: 16),
                                         child: BannerSlider(banners: controller.banners),
                                       ),

                                     Expanded(
                                       child: Transform.translate(
                                         offset: const Offset(0, 10),
                                         child: Container(
                                           padding: const EdgeInsets.symmetric(horizontal: 24),
                                           // Glass Effect Container
                                           child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withValues(alpha: 0.05),
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(
                                                      color: Colors.white.withValues(alpha: 0.2),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(height: 20),
                                                      const ActionStatusCard(),
                                                      const SizedBox(height: 20),
                                                      AttendanceActions(
                                                        onCheckIn: (lat, long) async {
                                                           controller.checkIn(lat, long);
                                                           await Future.delayed(const Duration(seconds: 1));
                                                           if (controller.todayAttendance != null) {
                                                              return controller.todayAttendance!;
                                                           }
                                                           throw Exception('CheckIn In Progress'); 
                                                        },
                                                        onCheckOut: (lat, long) async {
                                                          controller.checkOut(lat, long);
                                                           await Future.delayed(const Duration(seconds: 1));
                                                           if (controller.todayAttendance != null) {
                                                              return controller.todayAttendance!;
                                                           }
                                                            throw Exception('CheckOut In Progress');
                                                        },
                                                        initialData: controller.todayAttendance,
                                                      ),
                                                      const SizedBox(height: 40),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                           ),
                                         ),
                                       ),
                                     ),
                                     // Spacer for Service Menu interaction
                                     const SizedBox(height: 120), 
                                  ],
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),

              // 3. Header Overlay
              Consumer(
                builder: (context, ref, child) {
                  final userState = ref.watch(userProvider);
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: DashboardHeader(
                      user: userState.currentUser,
                      onLogout: () => controller.logout(),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
