import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showPaymentReminderSheet(BuildContext context, Party party) {
  final balance = party.currentBalance.abs();
  final message =
      'Dear ${party.name},\nYour outstanding balance is ${CurrencyFormat.format(balance)}.\nPlease make your payment at your earliest convenience.\nThank you.';

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Send reminder', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.sms_outlined),
              title: const Text('SMS'),
              onTap: () {
                Navigator.pop(ctx);
                DemoSnack.show(context, 'SMS sent (demo)');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('WhatsApp'),
              onTap: () async {
                Navigator.pop(ctx);
                final phone = party.phone.replaceAll(RegExp(r'[^0-9]'), '');
                final uri = Uri.parse('https://wa.me/92$phone?text=${Uri.encodeComponent(message)}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else if (context.mounted) {
                  DemoSnack.show(context, 'WhatsApp opened (demo simulation)');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Copy message'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message));
                Navigator.pop(ctx);
                DemoSnack.show(context, 'Message copied');
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(ctx);
                Share.share(message);
              },
            ),
          ],
        ),
      );
    },
  );
}
