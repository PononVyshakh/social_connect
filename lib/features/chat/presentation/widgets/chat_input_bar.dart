import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _C {
  static const bubble    = Colors.white;
  static const sendBtn   = Color(0xFF00A884);
  static const micBtn    = Color(0xFF00A884);
  static const hintText  = Color(0xFFADB5BD);
  static const inputText = Color(0xFF111B21);
  static const iconGrey  = Color(0xFF8696A0);
  static const ripple    = Color(0x1500A884);
}

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final VoidCallback? onVoiceRecording;
  final bool isEnabled;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSendMessage,
    this.onVoiceRecording,
    this.isEnabled = true,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  bool _isTextEmpty = true;
  late AnimationController _fabAnim;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
  }

  void _onTextChanged() {
    final empty = widget.controller.text.trim().isEmpty;
    if (empty == _isTextEmpty) return;
    setState(() => _isTextEmpty = empty);
    _fabAnim.forward(from: 0);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _fabAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _buildInputBubble()),
          const SizedBox(width: 6),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildInputBubble() {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: _C.bubble,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _IconBtn(icon: Icons.emoji_emotions_outlined, onTap: () {}),
          Expanded(
            child: Focus(
              onKey: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter) {
                  if (HardwareKeyboard.instance.isShiftPressed) {
                    return KeyEventResult.ignored;
                  }
                  if (!_isTextEmpty) widget.onSendMessage();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: widget.controller,
                enabled: widget.isEnabled,
                maxLines: 5,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                  fontSize: 15,
                  color: _C.inputText,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(fontSize: 15, color: _C.hintText),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,   // ← no border at rest
                  focusedBorder: InputBorder.none,   // ← no border on focus
                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                  isDense: true,
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(
                sizeFactor: anim,
                axis: Axis.horizontal,
                child: child,
              ),
            ),
            child: _isTextEmpty
                ? Row(
                    key: const ValueKey('bothIcons'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _IconBtn(icon: Icons.attach_file, onTap: () {}),
                      _IconBtn(icon: Icons.camera_alt_outlined, onTap: () {}),
                    ],
                  )
                : _IconBtn(
                    key: const ValueKey('attachOnly'),
                    icon: Icons.attach_file,
                    onTap: () {},
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(curved),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      child: _isTextEmpty
          ? _CircleFab(
              key: const ValueKey('mic'),
              color: _C.micBtn,
              icon: Icons.mic,
              onTap: () => widget.onVoiceRecording?.call(),
            )
          : _CircleFab(
              key: const ValueKey('send'),
              color: _C.sendBtn,
              icon: Icons.send_rounded,
              onTap: () {
                if (!_isTextEmpty) widget.onSendMessage();
              },
            ),
    );
  }
}

// ── Helpers ───────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: _C.ripple,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Icon(icon, color: _C.iconGrey, size: 22),
        ),
      ),
    );
  }
}

class _CircleFab extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleFab({
    super.key,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: color.withOpacity(0.4),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}