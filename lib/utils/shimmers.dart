import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Constants/app_dimensions.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  Widget _shimmerRow(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 0.3,
            height: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.035,
        vertical: height * 0.02,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(6, (_) => _shimmerRow(context)),
        ),
      ),
    );
  }
}

class DeliveryQcPageShimmer extends StatelessWidget {
  final double height;
  final double width;

  const DeliveryQcPageShimmer({
    super.key,
    required this.height,
    required this.width,
  });

  Widget _shimmerBox({double? h, double? w, double radius = 8}) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar shimmer
            _shimmerBox(h: 45, w: double.infinity, radius: 10),
            AppDimensions.h20(context),

            // 📅 Date & Filter row shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(h: 38, w: width * 0.42, radius: 10),
                _shimmerBox(h: 38, w: width * 0.3, radius: 10),
              ],
            ),
            AppDimensions.h20(context),

            // 📋 List shimmer (multiple card placeholders)
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _shimmerBox(h: 14, w: width * 0.3),
                          _shimmerBox(h: 12, w: width * 0.2),
                        ],
                      ),
                      AppDimensions.h10(context),

                      Row(
                        children: [
                          _shimmerBox(h: 12, w: width * 0.25),
                          AppDimensions.w20(context),
                          _shimmerBox(h: 12, w: width * 0.25),
                        ],
                      ),
                      AppDimensions.h10(context),

                      Row(
                        children: [
                          _shimmerBox(h: 12, w: width * 0.3),
                          AppDimensions.w20(context),
                          _shimmerBox(h: 12, w: width * 0.2),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

