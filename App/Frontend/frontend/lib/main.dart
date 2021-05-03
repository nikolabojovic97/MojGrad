import 'package:Frontend/services/mapServices.dart';
import 'package:Frontend/widgets/progressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/userServices.dart';
import 'src/pages/prehome.dart';
import 'src/pages/welcomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapServices.getDeviceLocation();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserService(),
        )
      ],
      child: Consumer<UserService>(
        builder: (context, service, _) => MaterialApp(
          theme: ThemeData(primarySwatch: Colors.lightGreen),
          debugShowCheckedModeBanner: false,
          home: service.isAuthorized
              ? HomePage()
              : FutureBuilder(
                  future: service.attemptAutoLogin(),
                  builder: (context, serviceResultSnapshot) =>
                    serviceResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? MyProgressIndicator()
                        : WelcomePage(),
                ),
        ),
      ),
    );
  }
}
