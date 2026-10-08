import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/now_driving_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_call_alias_map_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_call_alias_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_now_driving_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/work/work_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/work/call_list_viewmodel.dart';
import 'package:provider/provider.dart';

/// 진행 중인 콜 목록 화면 (SCR-LIST).
///
/// 여러 명 대리를 동시에 불러주는 흐름의 허브. 진행 중인 콜 전체를 카드로 보여주고,
/// 카드를 누르면 그 콜의 운행 상세로, 하단 버튼으로 새 콜을 건다.
class CallListScreen extends StatefulWidget {
  const CallListScreen({Key? key}) : super(key: key);

  static const String routeName = "call_list";
  static const String routeURL = "/call_list";

  @override
  State<CallListScreen> createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  late final CallListViewModel _callListViewModel;

  @override
  void initState() {
    super.initState();
    _callListViewModel = CallListViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getNowDrivingListUseCase: GetIt.instance<GetNowDrivingListUseCase>(),
      getCallAliasMapUseCase: GetIt.instance<GetCallAliasMapUseCase>(),
      setCallAliasUseCase: GetIt.instance<SetCallAliasUseCase>(),
    );
    _callListViewModel.getCallList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CallListViewModel>(create: (_) => _callListViewModel),
      ],
      child: Scaffold(
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringCallList.title,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _callListViewModel.getCallList(),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              /// 목록
              Expanded(
                child: ValueListenableBuilder<StateAPI>(
                  valueListenable: _callListViewModel.stateNotifier,
                  builder: (context, state, child) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ValueListenableBuilder<List<NowDrivingCall>>(
                      valueListenable: _callListViewModel.callListNotifier,
                      builder: (context, callList, child) {
                        if (callList.isEmpty) return _buildEmpty();
                        return RefreshIndicator(
                          onRefresh: () => _callListViewModel.getCallList(),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                            itemCount: callList.length,
                            itemBuilder: (context, index) => _buildCard(callList[index]),
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              /// 새 콜 호출
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomRadiusButton(
                    text: StringCallList.newCallButton,
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 콜 카드 한 건. 누르면 그 콜의 운행 상세로 이동한다.
  Widget _buildCard(NowDrivingCall call) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await context.pushNamed(WorkScreen.routeName, extra: call.drvReqSq);
        if (!mounted) return;

        /// 상세에서 돌아오면 상태가 바뀌었을 수 있으니 다시 조회한다
        _callListViewModel.getCallList();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 별칭(사용자 지정 or 도착지 기준 자동) + 수정 버튼
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<Map<int, String>>(
                    valueListenable: _callListViewModel.aliasMapNotifier,
                    builder: (context, _, child) => Text(
                      _callListViewModel.aliasOf(call),
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => _showAliasEditDialog(call),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// 상태 뱃지 + 지정/자동
            Row(
              children: [
                _buildStatusBadge(call.drvReqSt),
                const SizedBox(width: 8),
                Text(
                  call.appointDmSq != null ? StringCallList.appointed : StringCallList.autoDispatch,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// 출발 → 도착
            _buildRoute("출발", call.reqStartPlaceNm, call.reqStartAddress),
            const SizedBox(height: 4),
            _buildRoute("도착", call.reqEndPlaceNm, call.reqEndAddress),
            const SizedBox(height: 12),

            /// 요금
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                getPrice(call.drvPaymPrice),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 별칭 수정 다이얼로그. 비워서 저장하면 도착지 기준 자동 별칭으로 되돌아간다.
  Future<void> _showAliasEditDialog(NowDrivingCall call) async {
    final custom = _callListViewModel.aliasMapNotifier.value[call.drvReqSq] ?? "";
    final controller = TextEditingController(text: custom);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
        actionsPadding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(StringCallList.aliasEditTitle, style: Theme.of(context).textTheme.titleMedium),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onAliasSubmit(dialogContext, call, controller.text),
          decoration: InputDecoration(
            hintText: _callListViewModel.autoAliasOf(call),
            counterText: "",
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: StringCommon.cancel,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).disabledColor,
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomElevatedButton(
                  text: StringCommon.confirm,
                  onPressed: () => _onAliasSubmit(dialogContext, call, controller.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onAliasSubmit(BuildContext dialogContext, NowDrivingCall call, String text) {
    _callListViewModel.saveAlias(drvReqSq: call.drvReqSq, alias: text);
    Navigator.pop(dialogContext);
  }

  Widget _buildRoute(String label, String? placeNm, String? address) {
    final text = (placeNm?.isNotEmpty == true) ? placeNm! : (address ?? "-");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 상태 코드를 표시 그룹으로 묶어 색과 함께 보여준다.
  Widget _buildStatusBadge(String? drvReqSt) {
    String label;
    Color color;
    switch (drvReqSt) {
      case DrvReqSt.cal:
        label = StringCallList.stCalling;
        color = const Color(0xFFC67D14);
        break;
      case DrvReqSt.cco:
      case DrvReqSt.rwt:
        label = StringCallList.stAssigned;
        color = const Color(0xFF0F8E86);
        break;
      case DrvReqSt.wat:
        label = StringCallList.stWaiting;
        color = const Color(0xFF0F8E86);
        break;
      case DrvReqSt.sta:
      case DrvReqSt.rst:
        label = StringCallList.stRunning;
        color = const Color(0xFF27924F);
        break;
      default:
        label = drvReqSt ?? "-";
        color = Theme.of(context).disabledColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(StringCallList.empty, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text(
            StringCallList.emptyGuide,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }
}
