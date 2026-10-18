import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/providers.dart';
import 'core/local_store.dart';
import 'screens.dart';
Future<void> main()async{
 WidgetsFlutterBinding.ensureInitialized();
 final store=LocalStore();await store.init();
 runApp(ProviderScope(overrides:[storeProvider.overrideWithValue(store)],child:const KhojLiveApp()));
}
class KhojLiveApp extends ConsumerStatefulWidget{const KhojLiveApp({super.key});@override ConsumerState<KhojLiveApp> createState()=>_KhojLiveAppState();}
class _KhojLiveAppState extends ConsumerState<KhojLiveApp>{bool ready=false;@override void initState(){super.initState();Future.microtask(()async{final signed=await ref.read(apiProvider).isLoggedIn();if(mounted){ref.read(sessionProvider.notifier).state=signed;setState(()=>ready=true);}if(signed)ref.read(syncProvider).start();});}
@override Widget build(BuildContext context)=>MaterialApp(title:'KhojLive Driver',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF0B8079))),home:!ready?const Scaffold(body:Center(child:CircularProgressIndicator())):ref.watch(sessionProvider)?const DriverHome():const LoginScreen());}
