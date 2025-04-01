import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:loccar_agency/utils/colors.dart';

class CustomSearchField<T> extends StatelessWidget {
  final T? _initialValue;
  final String _hintText;
  final List<T> _items;
  final Function(T value) _onChanged;
  final String Function(T) _displayStringForOption;

  const CustomSearchField({
    required T? initialValue,
    required String hintText,
    required List<T> items,
    required Function(T value) onChanged,
    required String Function(T) displayStringForOption,
    super.key,
  })  : _initialValue = initialValue,
        _hintText = hintText,
        _items = items,
        _onChanged = onChanged,
        _displayStringForOption = displayStringForOption;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: (f, cs) => _items,
      selectedItem: _initialValue,
      onChanged: (value) {
        _onChanged(value as T);
      },
      compareFn: (T? item, T? selectedItem) => item == selectedItem,
      itemAsString: _displayStringForOption,
      decoratorProps: DropDownDecoratorProps(
        baseStyle: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.placeholderBg,
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        title: Padding(
          padding: const EdgeInsets.all(4.0).copyWith(top: 8),
          child: Text(
            _hintText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
        constraints: const BoxConstraints.tightFor(width: 300, height: 300),
      ),
    );
  }
}
