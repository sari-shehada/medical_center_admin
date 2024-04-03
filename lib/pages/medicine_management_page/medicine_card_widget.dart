import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_admin/models/medicine.dart';

class MedicineCardWidget extends StatelessWidget {
  const MedicineCardWidget({super.key, required this.medicine});
  final Medicine medicine;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
          ),
        ],
        borderRadius: BorderRadius.circular(
          15.r,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 75,
            child: Image.network(
              medicine.imageUrl,
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                medicine.name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
