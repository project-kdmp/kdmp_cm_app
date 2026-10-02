import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/work/driver_list_response.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';

/// 기사 상세 팝업. 지정 전에 평점·수락률을 확인하고 단골로 등록할 수 있다
class DriverDetailBottomSheet extends StatelessWidget {
  const DriverDetailBottomSheet({
    Key? key,
    required this.driver,
    required this.onFavoritePressed,
  }) : super(key: key);

  final Driver driver;

  /// 단골 토글은 목록과 상태를 공유해야 해서 화면이 처리한다
  final Function() onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final isSelectable = driver.drvWorkSt != DrvWorkSt.off;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 프로필
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).dividerColor,
                child: Icon(Icons.person, color: Theme.of(context).disabledColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.drvNm, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      driver.belongNm != null && driver.belongNm!.isNotEmpty
                          ? "${StringDriverSelect.driverNo} ${driver.drvNo} · ${driver.belongNm}"
                          : "${StringDriverSelect.driverNo} ${driver.drvNo}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                    ),
                  ],
                ),
              ),

              /// 단골 등록·해제
              IconButton(
                onPressed: onFavoritePressed,
                icon: Icon(
                  driver.isFavorite ? Icons.star : Icons.star_border,
                  color: driver.isFavorite ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// 지표
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildStat(context, StringDriverSelect.grade, driver.drvGradeCnt > 0 ? "${driver.drvGrade}" : "-"),
                _buildStat(context, StringDriverSelect.drvCnt, driver.drvCnt != null ? "${driver.drvCnt}건" : "-"),
                _buildStat(context, StringDriverSelect.acceptRate, driver.acceptRate != null ? "${driver.acceptRate}%" : "-"),
                _buildStat(context, StringDriverSelect.arrival, driver.arrivalMinute != null ? "${driver.arrivalMinute}분" : "-"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          /// 우선 배차 안내
          Text(
            StringDriverSelect.notice,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: CustomRadiusButton(
                  text: StringDriverSelect.close,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: CustomRadiusButton(
                  isEnabled: isSelectable,
                  text: StringDriverSelect.detailAssign,
                  onPressed: () => context.pop(driver),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }
}
