import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/fund.dart';
import '../../core/theme/app_colors.dart';
import '../blocs/fund_bloc.dart';
import '../widgets/shared/custom_breadcrumbs.dart';
import '../widgets/shared/badge_tag.dart';
import '../widgets/shared/info_box.dart';
import '../widgets/shared/custom_currency_input.dart';
import '../widgets/shared/custom_checkbox.dart';
import '../widgets/shared/custom_buttons.dart';

class SubscriptionDialog extends StatefulWidget {
  final Fund fund;

  const SubscriptionDialog({super.key, required this.fund});

  @override
  State<SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _notifyEmail = false;
  bool _notifySms = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      context.read<FundBloc>().add(
        SubscribeToFund(
          fundId: widget.fund.id,
          amount: amount,
          notifyEmail: _notifyEmail,
          notifySms: _notifySms,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 700 ? 650.0 : screenWidth * 0.95;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: dialogWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: BlocConsumer<FundBloc, FundState>(
              listener: (context, state) {
                if (state is FundOperationSuccess) {
                  AlertInfo.show(
                    context: context,
                    text: state.message,
                    typeInfo: TypeInfo.success,
                    backgroundColor: AppColors.success,
                    iconColor: AppColors.infoBorder
                  );
                  Navigator.of(context).pop();
                } else if (state is FundError) {
                  AlertInfo.show(
                    context: context,
                    text: state.message,
                    typeInfo: TypeInfo.error,
                    backgroundColor: AppColors.error,
                    icon: Icons.error_outline,
                    iconColor: AppColors.infoBorder
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is FundLoading;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomBreadcrumbs(
                        paths: ['Inicio', 'Proceso de Suscripción'],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Suscrubirse al fondo',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.slate900,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const BadgeTag(
                            text: 'FONDO ACTIVO',
                            textColor: AppColors.secondary,
                            backgroundColor: AppColors.secondaryLight,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.fund.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Divider(
                        color: AppColors.slate200,
                        height: 32,
                        thickness: 1,
                      ),

                      InfoBox(
                        text:
                            'Monto mínimo: \$${widget.fund.minimumAmount.toStringAsFixed(0)} COP',
                      ),

                      const SizedBox(height: 24),
                      CustomCurrencyInput(
                        controller: _amountController,
                        label: 'Monto a invertir (COP)',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un monto válido';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null) {
                            return 'Formato numérico inválido';
                          }
                          if (amount < widget.fund.minimumAmount) {
                            return 'El monto no cumple el mínimo exigido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),
                      const Text(
                        'Notificarme vía:',
                        style: TextStyle(
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomCheckbox(
                        value: _notifyEmail,
                        label: 'Correo electrónico (Email)',
                        onChanged: isLoading
                            ? (_) {}
                            : (val) =>
                                  setState(() => _notifyEmail = val ?? false),
                      ),
                      CustomCheckbox(
                        value: _notifySms,
                        label: 'Mensaje de texto (SMS)',
                        onChanged: isLoading
                            ? (_) {}
                            : (val) =>
                                  setState(() => _notifySms = val ?? false),
                      ),

                      const SizedBox(height: 16),
                      Divider(
                        color: AppColors.slate200,
                        height: 48,
                        thickness: 1,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SecondaryButton(
                            text: 'Cancelar',
                            onPressed: isLoading
                                ? () {}
                                : () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 16),
                          PrimaryButton(
                            text: isLoading ? 'Procesando...' : 'Confirmar',
                            onPressed: isLoading ? () {} : _submit,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
