import 'dart:math';

import '../utils/basic_screen_imports.dart';

class CardPreviewWidget extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cvvCode;
  final bool showBack;
  final VoidCallback onTap;

  const CardPreviewWidget({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvvCode,
    required this.showBack,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          builder: (context, child) {
            final angle = showBack ? pi : rotate.value;
            return Transform(
              transform: Matrix4.rotationY(angle),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: child,
        );
      },
      child: showBack ? _backView(context) : _frontView(context),
    );
  }

  Widget _frontView(BuildContext context) {
    return Container(
      key: const ValueKey("front"),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [CustomColor.secondaryDarkColor, CustomColor.primaryLightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: double.infinity,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           TitleHeading3Widget(
            text: Strings.cardNumber,
          color: Colors.white70, fontSize: 12
          ),
          Text(
            cardNumber.isEmpty ? "0000 0000 0000 0000" : cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleHeading3Widget(
                      text: Strings.expiry,
                      color: Colors.white70,
                      fontSize: 12
                  ),
                  Text(
                    expiryDate.isEmpty ? "YY/MM" : expiryDate,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const Text(
                "VISA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _backView(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.14159),
        child: Container(
          key: const ValueKey("back"),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [CustomColor.secondaryLightColor, CustomColor.primaryLightColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: double.infinity,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 40, color: Colors.black54),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        cvvCode.isEmpty ? "123" : cvvCode,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                "VISA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}