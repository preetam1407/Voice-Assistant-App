import 'package:flutter/material.dart';
import 'package:voice_assistant_app/widgets/text_and_voice_field.dart';

class ToggleButton extends StatefulWidget {
  final inputmode _inputMode;
  final VoidCallback _sendtextmessage;
  final VoidCallback _sendvoicemessage;
  final bool _isReplying;
  final bool _isListening;
  const ToggleButton({
    super.key,
    required inputmode inputMode,
    required VoidCallback sendtextmessage,
    required VoidCallback sendvoicemessage,
    required bool isReplying,
    required bool isListening,
  })  : _inputMode = inputMode,
        _sendtextmessage = sendtextmessage,
        _sendvoicemessage = sendvoicemessage,
        _isReplying = isReplying,
        _isListening = isListening;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
      ),
      onPressed: widget._isReplying
          ? null
          : widget._inputMode == inputmode.text
              ? widget._sendtextmessage
              : widget._sendvoicemessage,
      child: Icon(
        widget._inputMode == inputmode.text
            ? Icons.send
            : widget._isListening
                ? Icons.mic_off
                : Icons.mic,
      ),
    );
  }
}
