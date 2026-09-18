import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/favorite_address_model.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_favorite_address_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_favorite_address_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/end_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/favorite_address_viewmodel.dart';
import 'package:provider/provider.dart';

/// 자주 가는 주소 화면
///
/// 서버에 보관 API 가 없어 단말에만 저장한다. 현재는 집, 회사 두 자리만 지원한다.
class FavoriteAddressScreen extends StatefulWidget {
  const FavoriteAddressScreen({Key? key}) : super(key: key);

  static const String routeName = "favorite_address";

  @override
  State<FavoriteAddressScreen> createState() => _FavoriteAddressScreenState();
}

class _FavoriteAddressScreenState extends State<FavoriteAddressScreen> {
  late final FavoriteAddressViewModel _favoriteAddressViewModel;

  static const List<String> _slots = [StringFavoriteAddress.home, StringFavoriteAddress.work];

  @override
  void initState() {
    super.initState();
    initViewModel();
    _favoriteAddressViewModel.getFavoriteAddressList();
  }

  /// Create
  void initViewModel() {
    _favoriteAddressViewModel = FavoriteAddressViewModel(
      getFavoriteAddressListUseCase: GetIt.instance<GetFavoriteAddressListUseCase>(),
      setFavoriteAddressListUseCase: GetIt.instance<SetFavoriteAddressListUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FavoriteAddressViewModel>(
          create: (context) => _favoriteAddressViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringFavoriteAddress.title,
        ),

        /// 화면
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ValueListenableBuilder<List<FavoriteAddress>>(
              valueListenable: _favoriteAddressViewModel.favoriteAddressListNotifier,
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringFavoriteAddress.guide,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                    ),
                    const SizedBox(height: 20),
                    for (final name in _slots) _buildSlot(name: name),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 자리 하나 (집 또는 회사)
  Widget _buildSlot({required String name}) {
    final mapData = _favoriteAddressViewModel.getMapData(name: name);
    final isRegistered = mapData != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            name == StringFavoriteAddress.home ? Icons.home : Icons.apartment,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  isRegistered
                      ? (mapData.place.isNotEmpty ? mapData.place : mapData.addressRoad)
                      : StringFavoriteAddress.empty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                ),
              ],
            ),
          ),

          /// 삭제 버튼 (등록된 경우에만 노출)
          if (isRegistered)
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.close, size: 16, color: Theme.of(context).disabledColor),
              ),
              onTap: () => _showDeleteDialog(name: name),
            ),

          /// 등록 및 변경 버튼
          CustomRoundButton(
            text: isRegistered ? StringFavoriteAddress.change : StringFavoriteAddress.register,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            textSize: 14,
            backgroundColor: isRegistered
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary,
            textColor: isRegistered
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).scaffoldBackgroundColor,
            borderColor: isRegistered ? Theme.of(context).colorScheme.secondary : null,
            onPressed: () => _handleRegisterPress(name: name),
          ),
        ],
      ),
    );
  }

  /// 주소 검색 화면에서 장소를 골라 등록한다
  void _handleRegisterPress({required String name}) async {
    final result = await context.pushNamed(EndSearchScreen.routeName);
    if (result != null && result is MapData) {
      await _favoriteAddressViewModel.setFavoriteAddress(name: name, mapData: result);
    }
  }

  /// 등록 삭제 확인 팝업
  void _showDeleteDialog({required String name}) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomConfirmDialog(
          title: StringFavoriteAddress.deleteTitle,
          content: name,
          onConfirm: () {
            _favoriteAddressViewModel.deleteFavoriteAddress(name: name);
            context.pop();
          },
        );
      },
    );
  }
}
