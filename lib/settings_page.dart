import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';
import 'contact_import_service.dart'; // ContactImportService burada

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSaving = false;

  Future<void> _saveContacts() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final service = ContactImportService();
      await service.importContactsAsTodoList();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rehber başarıyla kaydedildi')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Karanlık Tema'),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Rehberdeki Numaraları Kaydet'),
            trailing: _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveContacts,
                    child: const Text('Kaydet'),
                  ),
          ),
        ],
      ),
    );
  }
}
