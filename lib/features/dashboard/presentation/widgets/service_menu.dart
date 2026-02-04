import 'package:flutter/material.dart';

class ServiceMenu extends StatelessWidget {
  const ServiceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Layanan Kepegawaian',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64B5F6),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: const Color(0xFF64B5F6).withOpacity(0.8),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Builder(
            builder: (context) {
              Widget buildItem(
                IconData icon,
                String label,
                Color color,
                VoidCallback onTap,
              ) {
                return Expanded(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onTap,
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 24,
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   buildItem(
                    Icons.fingerprint_rounded,
                    'Kehadiran',
                     const Color(0xFF64B5F6),
                    // For now checking in/out is on dashboard, but maybe there's a dedicated page or just scroll to top
                    () {
                       // Scroll to top or just show feedback
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Menu Kehadiran aktif di Dashboard')),
                       );
                    }, // Or navigate if there is a specific page
                  ),
                  const SizedBox(width: 10),
                  buildItem(
                    Icons.calendar_month_outlined,
                    'Riwayat',
                    const Color(0xFF4FC3F7),
                    () => Navigator.pushNamed(context, '/history'),
                  ),
                  const SizedBox(width: 10),
                  buildItem(
                    Icons.flight_takeoff_rounded,
                    'e-Cuti',
                    const Color(0xFF4FC3F7),
                    () => Navigator.pushNamed(context, '/cuti'),
                  ),
                  const SizedBox(width: 10),
                  buildItem(
                    Icons.mail_outline_rounded,
                    'Izin',
                    const Color(0xFF4FC3F7),
                    () => Navigator.pushNamed(context, '/izin'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
