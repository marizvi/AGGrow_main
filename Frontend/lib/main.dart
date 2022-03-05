import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hackathon_app/helpers/locationHelper.dart';
import 'package:hackathon_app/providers/category_policy.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:hackathon_app/providers/mandi_prices.dart';
import 'package:hackathon_app/providers/market_provider.dart';
import 'package:hackathon_app/providers/news_provider.dart';
import 'package:hackathon_app/providers/weather_pro.dart';
import 'package:hackathon_app/screens/add_place.dart';
import 'package:hackathon_app/screens/add_product.dart';
import 'package:hackathon_app/screens/auth_scren.dart';
import 'package:hackathon_app/screens/cf_detail.dart';
import 'package:hackathon_app/screens/contract_farming.dart';
import 'package:hackathon_app/screens/contract_tabbar.dart';
import 'package:hackathon_app/screens/farmin_tips.dart';
import 'package:hackathon_app/screens/gov_policies.dart';
import 'package:hackathon_app/screens/main_screen.dart';
import 'package:hackathon_app/screens/mandi_detail.dart';
import 'package:hackathon_app/screens/mandi_screen.dart';
import 'package:hackathon_app/screens/marketplace.dart';
import 'package:hackathon_app/screens/mp_detail.dart';
import 'package:hackathon_app/screens/news_web.dart';
import 'package:hackathon_app/screens/pesticides_infor.dart';
import 'package:hackathon_app/screens/policy_detail.dart';
import 'package:hackathon_app/screens/scheme_detail.dart';
import 'package:hackathon_app/screens/tabscreen.dart';
import 'package:location/location.dart' as Location;
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';
import './widget/loaders/loading_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // print(FlutterConfig.get('Google_Api_key'));
  FlutterNativeSplash.removeAfter(initialization);
  await dotenv.load();
  // await Location.Location().getLocation();
  await Permission.locationWhenInUse.request();
  var status = await Permission.location.status;
  if (status.isDenied) {
    await Permission.locationWhenInUse.request();

    print('Location Permission denied');
  }

// You can can also directly ask the permission about its status.
  if (await Permission.location.isRestricted) {
    // The OS restricts access, for example because of parental controls.
    print("Asking");
  }
  runApp(const MyApp());
}

void initialization(BuildContext context) async {
  // This is where you can initialize the resources needed by your app while
  // the splash screen is displayed.  Remove the following example because
  // delaying the user experience is a bad design practice!
  // ignore_for_file: avoid_print
  print('ready in 3...');
  await Future.delayed(const Duration(seconds: 1));
  print('go!');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // LocationHelper(dotenv.env['Google_Api_key'] as String);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Policies(),
        ),
        ChangeNotifierProxyProvider<Auth, MandiPrices>(
          create: (context) =>
              MandiPrices(Provider.of<Auth>(context, listen: false).token),
          update: (context, auth, mandi) => MandiPrices(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, NewsProvider>(
          create: (context) =>
              NewsProvider(Provider.of<Auth>(context, listen: false).token),
          update: (context, auth, news) => NewsProvider(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, MarketProvider>(
          create: (context) => MarketProvider(
              Provider.of<Auth>(context, listen: false).token, []),
          update: (context, auth, marketpro) => MarketProvider(
              auth.token, marketpro!.list == null ? [] : marketpro.list),
        ),
        ChangeNotifierProxyProvider<Auth, ContactProvider>(
          create: (context) => ContactProvider(
              Provider.of<Auth>(context, listen: false).token, []),
          update: (context, auth, contactpro) => ContactProvider(
              auth.token, contactpro!.temp == null ? [] : contactpro.temp),
        ),
        ChangeNotifierProvider(
            create: (ctx) => ProWeather(dotenv.env['API_KEY'])),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            primarySwatch: Colors.indigo,
          ),
          routes: {
            '/': (ctx) => auth.isAuth
                ? TabScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return LoadingScreen();
                      else
                        return AuthScren();
                    }),
            '/mandi_prices': (ctx) => MandiScreen(),
            '/gov_policies': (ctx) => GovPolicies(),
            '/marketplace': (ctx) => MarketPlace(),
            '/contact_farming': (ctx) => ContactFarming(),
            '/mandi_detail': (ctx) => MandiDetail(),
            '/add_place': (ctx) => AddPlace(),
            '/add_market': (ctx) => AddProduct(),
            '/cf_detail': (ctx) => CFDetail(),
            '/news_web': (ctx) => NewsWeb(),
            '/mp_detail': (ctx) => ProductDetail(),
            '/farming_tips': (ctx) => FarmingTips(),
            '/policy_detail': (ctx) => PolicyDetail(),
            '/scheme_detail': (ctx) => SchemeDetail(),
            '/contract_tab': (ctx) => ContractTab(),
            '/pesticides_info': (ctx) => PesticidesInfo(),
          },
        ),
      ),
    );
  }
}
