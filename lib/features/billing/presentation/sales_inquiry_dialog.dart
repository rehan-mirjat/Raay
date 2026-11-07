import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/raay_colors.dart';
import '../domain/election_offer.dart';
import '../data/sales_repository.dart';

class SalesInquiryDialog extends ConsumerStatefulWidget {
  const SalesInquiryDialog(
      {super.key,
      required this.offer,
      this.organizationId,
      this.organizationName});
  final ElectionOffer offer;
  final String? organizationId, organizationName;
  @override
  ConsumerState<SalesInquiryDialog> createState() => _SalesInquiryDialogState();
}

class _SalesInquiryDialogState extends ConsumerState<SalesInquiryDialog> {
  final _form = GlobalKey<FormState>();
  final _requestId = const Uuid().v4();
  late final _organization =
      TextEditingController(text: widget.organizationName ?? '');
  final _voters = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _date;
  bool _busy = false;
  String? _error, _reference;
  @override
  void dispose() {
    _organization.dispose();
    _voters.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final reference = await ref.read(salesRepositoryProvider).request({
        'requestId': _requestId,
        'packageId': widget.offer.id,
        'organizationName': _organization.text.trim(),
        if (widget.organizationId != null)
          'organizationId': widget.organizationId,
        'estimatedVoters': int.parse(_voters.text.trim()),
        if (_date != null)
          'electionDate':
              '${_date!.year.toString().padLeft(4, '0')}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
        'notes': _notes.text.trim(),
      });
      if (mounted) setState(() => _reference = reference);
    } catch (error) {
      if (mounted) {
        setState(() => _error = error is SalesInquiryException
            ? error.message
            : 'Could not submit your request. Check your connection, then retry. Your retry will not create a duplicate request.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = RaayColors.of(context);
    return PopScope(
        canPop: !_busy,
        child: AlertDialog(
          scrollable: true,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          title: Text(_reference == null
              ? 'Request ${widget.offer.name}'
              : 'Request received'),
          content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _reference != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Text(
                              'Your request has been saved for our team to review. No payment has been taken and no paid access has been activated.'),
                          const SizedBox(height: 16),
                          const Text('Your reference'),
                          SelectableText(_reference!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          const Text(
                              'Follow its status in My requests. Our team will use your verified account email for follow-up.'),
                        ])
                  : Form(
                      key: _form,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                '${widget.offer.price} · ${widget.offer.priceSuffix}',
                                style: TextStyle(
                                    color: colors.accentText,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                            const Text(
                                'Tell us about your election. This is a quote request, not a purchase. We use your verified account email to follow up. Do not include voter lists, passwords, or payment-card details.'),
                            const SizedBox(height: 20),
                            TextFormField(
                                controller: _organization,
                                enabled:
                                    !_busy && widget.organizationId == null,
                                maxLength: 100,
                                decoration: const InputDecoration(
                                    labelText: 'Organization / community name'),
                                validator: (text) =>
                                    (text?.trim().length ?? 0) < 2
                                        ? 'Enter the organization name.'
                                        : null),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _voters,
                                enabled: !_busy,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Estimated eligible voters'),
                                validator: (text) {
                                  final number =
                                      int.tryParse(text?.trim() ?? '');
                                  return number == null ||
                                          number < 1 ||
                                          number > widget.offer.maxVoters
                                      ? 'Enter 1–${widget.offer.maxVoters} voters for this package.'
                                      : null;
                                }),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                                onPressed: _busy
                                    ? null
                                    : () async {
                                        final today =
                                            DateUtils.dateOnly(DateTime.now());
                                        final picked = await showDatePicker(
                                            context: context,
                                            initialDate: _date ?? today,
                                            firstDate: today,
                                            lastDate: today.add(
                                                const Duration(days: 730)));
                                        if (mounted && picked != null) {
                                          setState(() => _date = picked);
                                        }
                                      },
                                icon: const Icon(Icons.calendar_month),
                                label: Text(_date == null
                                    ? 'Preferred date (optional)'
                                    : MaterialLocalizations.of(context)
                                        .formatMediumDate(_date!))),
                            if (_date != null)
                              TextButton(
                                  onPressed: _busy
                                      ? null
                                      : () => setState(() => _date = null),
                                  child: const Text('Date not decided')),
                            const SizedBox(height: 16),
                            TextFormField(
                                controller: _notes,
                                enabled: !_busy,
                                minLines: 3,
                                maxLines: 6,
                                maxLength: 2000,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Setup or support needs (optional)')),
                            if (_error != null)
                              Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(_error!,
                                      style:
                                          TextStyle(color: colors.errorText))),
                          ]))),
          actions: _reference != null
              ? [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close')),
                  FilledButton(
                      onPressed: () {
                        final router = GoRouter.of(context);
                        Navigator.of(context).pop();
                        router.go('/help/reports');
                      },
                      child: const Text('View my requests')),
                ]
              : [
                  TextButton(
                      onPressed:
                          _busy ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: Text(_busy ? 'Sending…' : 'Send request')),
                ],
        ));
  }
}
