import 'package:flutter/material.dart';

class CaffeShowDialog {
  static Future<int?> showQuantityDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: '1');
    String? errorText;

    return showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Select Quantity'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  errorText: errorText,
                ),
                onChanged: (value) {
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    setStateDialog(() {
                      errorText = 'Please enter a valid number > 0';
                    });
                  } else {
                    setStateDialog(() {
                      errorText = null;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final qty = int.tryParse(controller.text);
                    if (qty == null || qty <= 0) {
                      setStateDialog(() {
                        errorText = 'Please enter a valid number > 0';
                      });
                      return;
                    }
                    Navigator.of(context).pop(qty);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
