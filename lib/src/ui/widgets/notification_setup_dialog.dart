import 'package:dueday/src/models/notification_settings.dart';
import 'package:dueday/src/services/notification_service.dart';
import 'package:dueday/src/services/notification_settings_service.dart';
import 'package:dueday/src/utils/android_utils.dart';
import 'package:flutter/material.dart';

class NotificationSetupDialog extends StatefulWidget {
  const NotificationSetupDialog({super.key});

  @override
  State<NotificationSetupDialog> createState() =>
      _NotificationSetupDialogState();
}

class _NotificationSetupDialogState extends State<NotificationSetupDialog> {
  bool _isEnabled = true;
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveSettings() async {
    if (_isEnabled) {
      await NotificationService.requestNotificationPermission();
      if (!await AndroidUtils.canScheduleExactAlarms()) {
        await AndroidUtils.openExactAlarmSettingsIfRequired();
      }
    }

    final settings = NotificationSettings(
      isEnabled: _isEnabled,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
    );

    NotificationSettingsService.saveSettings(settings);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Set Up Notifications",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            activeColor: Colors.tealAccent.shade400,
            title: Text(
              "Enable Daily Reminder",
              style: TextStyle(
                color: _isEnabled ? Colors.tealAccent.shade400 : Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            value: _isEnabled,
            onChanged: (value) {
              setState(() {
                _isEnabled = value;
              });
            },
          ),
          if (_isEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      side: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 61, 68, 68),
                      ),
                    ),
                  ),
                  onPressed: _pickTime,
                  icon: Icon(
                    Icons.access_time,
                    color: Colors.tealAccent.shade700,
                  ),
                  label: Text(
                    "Picked Time: ${_selectedTime.format(context)}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.tealAccent.shade700,
                    ),
                  ),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              "This reminder setup runs only once.\n"
              "To enable or disable reminders later, go to your phone’s system settings.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: _saveSettings,
          child: Text(
            "Save",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
