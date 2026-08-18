import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/features/negotiation/data/negotiation_repository.dart';
import 'package:orderly_ecom/src/features/negotiation/domain/negotiation_offer.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class AiIntentBar extends StatefulWidget {
  const AiIntentBar({
    super.key,
    this.hintText = 'Tell OrderUp what you need…',
    this.negotiationEnabled = false,
  });

  final String hintText;
  final bool negotiationEnabled;

  @override
  State<AiIntentBar> createState() => _AiIntentBarState();
}

class _AiIntentBarState extends State<AiIntentBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _captureIntent() async {
    final intent = _controller.text.trim();
    if (intent.isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();
    if (widget.negotiationEnabled) {
      setState(() => _loading = true);
      try {
        final repository = NegotiationRepository(inject.get<NetworkAdapter>());
        final offer = await repository.createOffer(intent);
        if (!mounted) return;
        await _showOffer(offer, repository);
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      } finally {
        if (mounted) setState(() => _loading = false);
      }
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Intent captured: “$intent”'),
        action: SnackBarAction(
          label: 'Edit',
          onPressed: _focusNode.requestFocus,
        ),
      ),
    );
  }

  Future<void> _showOffer(
    NegotiationOffer offer,
    NegotiationRepository repository,
  ) async {
    if (!offer.eligible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(offer.reason ?? 'This basket is not eligible.')),
      );
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _AiMark(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${offer.storeName} has an offer',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${offer.offeredPercent.toStringAsFixed(0)}% off your basket',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${offer.subtotal.toStringAsFixed(2)}  →  \$${offer.offeredTotal.toStringAsFixed(2)} '
              '(save \$${offer.discountAmount.toStringAsFixed(2)})',
            ),
            const SizedBox(height: 8),
            const Text(
              'Valid for 10 minutes. Demo preview only—checkout pricing is not changed yet.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  try {
                    final message = await repository.acceptOffer(offer.offerId);
                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  } catch (error) {
                    if (!sheetContext.mounted) return;
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                          content: Text(error
                              .toString()
                              .replaceFirst('Exception: ', ''))),
                    );
                  }
                },
                child: const Text('Accept preview offer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              height: 1.2,
            ),
        minLines: 1,
        maxLines: 2,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => _loading ? null : _captureIntent(),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.textColor.withOpacity(0.55),
                fontSize: 10,
                height: 1.2,
              ),
          prefixIcon: IconButton(
            tooltip: 'Describe your intent to OrderUp AI',
            onPressed: _focusNode.requestFocus,
            icon: const _AiMark(),
          ),
          suffixIcon: IconButton(
            tooltip: 'Send intent',
            onPressed: _loading ? null : _captureIntent,
            icon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_upward_rounded),
          ),
          filled: true,
          fillColor: AppColor.whiteColor,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColor.primaryColor.withOpacity(0.24),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColor.primaryColor,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _AiMark extends StatelessWidget {
  const _AiMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.primaryColor, AppColor.accentColor],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'AI',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
