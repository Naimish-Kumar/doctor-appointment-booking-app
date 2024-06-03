import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBDFXpaf0zMSZOG1eYgN7y1vei-XFDpYDI',
        appId: '1:270708128217:android:4db1853c2291d94cd401c8',
        messagingSenderId: '270708128217',
        projectId: 'doctor-finder-ios',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await GetStorage.init();
  notificationHelper.initialize();

  Stripe.publishableKey = stripePublisherKey;

  ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
      onCallAcceptedWhenTerminated;
  ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
      onCallRejectedWhenTerminated;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}