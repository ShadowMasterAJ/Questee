import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../blocs/payment/payment_bloc.dart';
import '../blocs/payment/payment_event.dart';
import '../blocs/payment/payment_state.dart';

class CardForm extends StatefulWidget {
  const CardForm({Key? key}) : super(key: key);

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  late CardFormEditController _cardFormEditController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _cardFormEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<PaymentBloc, PaymentState>(builder: ((context, state) {
      _cardFormEditController = new CardFormEditController(
          initialDetails: state.cardFieldInputDetails);
      if (state.status == PaymentStatus.initial)
        return Container(
          child: Column(
            children: [
              CardFormField(
                controller: _cardFormEditController,
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                  onTap: () {
                    _cardFormEditController.details.complete
                        ? context.read<PaymentBloc>().add(PaymentCreateIntent(
                                billingDetails: BillingDetails(
                                    email: 'ronanmahtolia10@gmail.com'),
                                items: [
                                  {'id': 0}
                                ]))
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("the form is not complete")));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Text(
                      "Pay",
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment.center,
                  ))
            ],
          ),
        );

      if (state.status == PaymentStatus.success) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("The payment is successful"),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                context.read<PaymentBloc>().add(PaymentStart());
              },
              child: const Text("Back to home"),
            )
          ],
        );
      }
      if (state.status == PaymentStatus.failure) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("The payment failed"),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                context.read<PaymentBloc>().add(PaymentStart());
              },
              child: const Text("Try again"),
            )
          ],
        );
      } else
        return const Center(child: CircularProgressIndicator());
    })));
  }
}
