
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final String initialLanguage;
  final ValueChanged<bool>? onThemeChanged;
  final ValueChanged<String>? onLanguageChanged;

  const SettingsPage({
    super.key,
    this.isDark = false,
    this.initialLanguage = 'portugues',
    this.onThemeChanged,
    this.onLanguageChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);

  late bool _isDark;
  late String _language;

  @override
  void initState() {
    super.initState();

    _isDark = widget.isDark;
    _language = widget.initialLanguage;
  }

  void _changeTheme(bool value) {
    setState(() {
      _isDark = value;
    });

    widget.onThemeChanged?.call(value);
  }

  void _changeLanguage(String value) {
    setState(() {
      _language = value;
    });

    widget.onLanguageChanged?.call(value);
  }

  Widget _radioOption({
    required String value,
    required String label,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.white,
          fillColor: WidgetStateProperty.all(Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOptions() {
    return Wrap(
      spacing: 12,
      children: [
        _radioOption(
          value: 'luz',
          label: 'Luz',
          groupValue: _isDark ? 'escuro' : 'luz',
          onChanged: (_) => _changeTheme(false),
        ),
        _radioOption(
          value: 'escuro',
          label: 'Escuro',
          groupValue: _isDark ? 'escuro' : 'luz',
          onChanged: (_) => _changeTheme(true),
        ),
      ],
    );
  }

  Widget _buildLanguageOptions() {
    return Wrap(
      spacing: 8,
      children: [
        _radioOption(
          value: 'portugues',
          label: 'Português',
          groupValue: _language,
          onChanged: (value) {
            if (value != null) {
              _changeLanguage(value);
            }
          },
        ),
        _radioOption(
          value: 'ingles',
          label: 'Inglês',
          groupValue: _language,
          onChanged: (value) {
            if (value != null) {
              _changeLanguage(value);
            }
          },
        ),
        _radioOption(
          value: 'espanhol',
          label: 'Espanhol',
          groupValue: _language,
          onChanged: (value) {
            if (value != null) {
              _changeLanguage(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required Widget options,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 600;

        return Flex(
          direction: mobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: mobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (mobile) const SizedBox(height: 10),
            options,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 700;

          return Padding(
            padding: EdgeInsets.all(mobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONFIGURAÇÕES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),

                Container(
                  height: 1,
                  color: Colors.white,
                ),

                const SizedBox(height: 48),

                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(
                        mobile ? 20 : 40,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.20,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingRow(
                            icon: Icons.colorize,
                            title: 'Alterar tema',
                            options: _buildThemeOptions(),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            height: 1,
                            color: Colors.white.withValues(
                              alpha: 0.75,
                            ),
                          ),

                          const SizedBox(height: 24),

                          _buildSettingRow(
                            icon: Icons.translate,
                            title: 'Alterar idioma',
                            options: _buildLanguageOptions(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
