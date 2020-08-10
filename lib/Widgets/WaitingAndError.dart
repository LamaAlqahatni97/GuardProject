import 'package:flutter/material.dart';
import 'package:guardproject/Enums/StateEnums.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/theme/text_styles.dart';
import 'package:provider/provider.dart';

import 'LoadingWidget.dart';

class WaitingAndError extends StatelessWidget {
  final Function(PrState state) onStateChanged;
  const WaitingAndError({Key key, this.onStateChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, pr, child) {
        //will give Either State.Idle or State.Fetching
        if (onStateChanged != null) onStateChanged(pr.state);
        //Will Show error
        if (pr.error.isNotEmpty)
          return Text(
            pr.error,
            textAlign: TextAlign.center,
            style: TextStyles.errorTextStyle,
          );
        //Will Show Loading Spinner
        if (pr.state == PrState.Fetching) return LoadingWidget();

        return Container();
      },
    );
  }
}
