import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/medicine.dart';

class MedicineCardWidget extends StatelessWidget {
  const MedicineCardWidget(
      {super.key, required this.medicine, this.deleteMedicineCallback});
  final Medicine medicine;
  final VoidCallback? deleteMedicineCallback;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    medicine.name,
                  ),
                  if (deleteMedicineCallback != null)
                    IconButton(
                      onPressed: () => deleteMedicineCallback!(),
                      icon: Icon(
                        Icons.delete,
                        size: 30.sp,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
