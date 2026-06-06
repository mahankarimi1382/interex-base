part of '../cardyfie_transaction_screen.dart';

class CardyfieExpandableWidget extends StatefulWidget {
  const CardyfieExpandableWidget({
    super.key,
    required this.amount,
    required this.title,
    required this.dateText,
    required this.transaction,
    required this.monthText,
    required this.status,
    required this.amountType,
  });

  final String title,
      monthText,
      dateText,
      amount,
      transaction,
      status,
      amountType;

  @override
  State<CardyfieExpandableWidget> createState() =>
      _CardyfieExpandableWidgetState();
}

class _CardyfieExpandableWidgetState extends State<CardyfieExpandableWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: CustomColor.currencyColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(Dimensions.radius),
          ),
          padding: EdgeInsets.all(Dimensions.paddingSize * 0.7),
          child: Column(
            children: [
              // Top Row (Status, Title, Amount + Date)
              Row(
                crossAxisAlignment: crossCenter,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    size: Dimensions.heightSize * 2,
                    color: CustomColor.primaryLightColor,
                  ),
                  horizontalSpace(Dimensions.marginSizeHorizontal * 0.6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: crossStart,
                      children: [
                        TitleHeading3Widget(
                          text: widget.title,
                          fontWeight: FontWeight.w700,
                          color: Get.isDarkMode
                              ? CustomColor.primaryLightTextColor
                              : CustomColor.primaryDarkTextColor,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: Dimensions.heightSize * 0.8,
                              color: CustomColor.greenColor,
                            ),
                            horizontalSpace(4),
                            Text(
                              widget.status,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: CustomColor.greenColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TitleHeading4Widget(
                        text: widget.amount,
                        color: CustomColor.primaryLightColor,
                        fontWeight: FontWeight.w700,
                      ),
                      TitleHeading5Widget(
                        text: widget.dateText,
                        color: CustomColor.blackColor.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ],
              ),

              // Expanded section
              if (isExpanded) ...[
                verticalSpace(Dimensions.marginSizeVertical * 0.6),
                Divider(color: CustomColor.grayColor),
                verticalSpace(Dimensions.marginSizeVertical * 0.6),

                _rowItem(Icons.receipt_long, Strings.trxID, widget.transaction),
                verticalSpace(8),
                _rowItem(
                  Icons.account_balance_wallet,
                  Strings.amountType,
                  widget.amountType,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Expanded(
          child: TitleHeading5Widget(
            text: title,
            color: CustomColor.blackColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: CustomColor.blackColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
