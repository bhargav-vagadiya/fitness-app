import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_management/shared/utils/appsizes.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key, required this.onChanged, this.controller});

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _showClearButton = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: widget.controller ?? controller,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSize.r10)),
            placeholder: 'Search',
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                CupertinoIcons.search,
                color: CupertinoColors.inactiveGray,
              ),
            ),
            suffix: _showClearButton
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.clear_thick_circled,
                      color: CupertinoColors.inactiveGray,
                      size: 20.0,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.controller != null
                            ? widget.controller!.clear()
                            : controller.clear();
                        widget.onChanged("");
                      });
                    },
                  )
                : null,
            onChanged: widget.onChanged,
            onTap: () {
              setState(() {
                _showClearButton = true;
              });
            },
          ),
        ),
        if (_showClearButton)
          CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () {
                setState(() {
                  _showClearButton = false;
                  primaryFocus?.unfocus();
                });
              })
      ],
    );
  }
}
