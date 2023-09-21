import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';

class CustomDatePickerField extends StatelessWidget {
  const CustomDatePickerField({
    Key? key,
    this.text = "",
    this.hint = "",
    required this.onChanged,
    this.isPassword = false,
    this.isEnabled = true,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  final String text;
  final String hint;
  final Function(DateTime) onChanged;
  final bool isPassword;
  final bool isEnabled;
  final String? firstDate; // yyyy-MM-dd ~ 형태
  final String? lastDate; // yyyy-MM-dd ~ 형태

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        alignment: Alignment.centerLeft,
        backgroundColor: Theme.of(context).dividerColor,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
        minimumSize: const Size(double.infinity, double.minPositive),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        disabledBackgroundColor: Theme.of(context).dividerColor,
      ),
      onPressed: isEnabled
          ? () {
              showDatePicker(
                context: context,
                initialDate: text.isNotEmpty
                    ? DateTime(
                        int.parse(text.substring(0, 4)),
                        int.parse(text.substring(5, 7)),
                        int.parse(text.substring(8, 10)),
                      )
                    : firstDate == null
                        ? DateTime.now()
                        : DateTime(
                            int.parse(firstDate!.substring(0, 4)),
                            int.parse(firstDate!.substring(5, 7)),
                            int.parse(firstDate!.substring(8, 10)),
                          ),
                firstDate: firstDate == null
                    ? DateTime(2000)
                    : DateTime(
                        int.parse(firstDate!.substring(0, 4)),
                        int.parse(firstDate!.substring(5, 7)),
                        int.parse(firstDate!.substring(8, 10)),
                      ),
                lastDate: lastDate == null
                    ? DateTime(2099)
                    : DateTime(
                        int.parse(lastDate!.substring(0, 4)),
                        int.parse(lastDate!.substring(5, 7)),
                        int.parse(lastDate!.substring(8, 10)),
                      ),
                helpText: StringCommon.selectDate,
                cancelText: StringCommon.cancel,
                confirmText: StringCommon.confirm,
              ).then((selectedDate) {
                onChanged(selectedDate!);
              });
            }
          : null,
      child: text.isEmpty
          ? Text(
              hint,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).disabledColor),
            )
          : Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
    );
  }
}
