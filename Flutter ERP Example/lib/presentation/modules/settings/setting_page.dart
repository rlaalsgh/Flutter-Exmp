import 'package:fluent_ui/fluent_ui.dart';

class SettingPage extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  final Function(AccentColor)? onAccentChanged;

  const SettingPage({
    super.key,
    this.onThemeChanged,
    this.onAccentChanged,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ThemeMode _themeMode = ThemeMode.light;
  AccentColor _selectedColor = Colors.blue;

  // ✅ AccentColor.values 대신 직접 리스트 정의
  final List<AccentColor> _accentColors = [
    Colors.blue,
    Colors.green,
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.yellow,
    Colors.yellow,
    Colors.magenta,
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('환경 설정')),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌓 테마 모드',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // ✅ const 제거 (Web에서는 const 표현 불가)
            ComboBox<ThemeMode>(
              placeholder: const Text('테마 선택'),
              value: _themeMode,
              items: [
                ComboBoxItem(
                    value: ThemeMode.light, child: const Text('라이트 모드')),
                ComboBoxItem(value: ThemeMode.dark, child: const Text('다크 모드')),
                ComboBoxItem(
                    value: ThemeMode.system, child: const Text('시스템 설정')),
              ],
              onChanged: (mode) {
                if (mode == null) return;
                setState(() => _themeMode = mode);
                widget.onThemeChanged?.call(mode);
              },
            ),

            const SizedBox(height: 25),
            const Text('🎨 포인트 색상',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // ✅ AccentColor.values → _accentColors
            Wrap(
              spacing: 8,
              children: _accentColors.map((color) {
                return Tooltip(
                  message: color.toString(),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedColor = color);
                      widget.onAccentChanged?.call(color);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.defaultBrushFor(
                            FluentTheme.of(context).brightness),
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
