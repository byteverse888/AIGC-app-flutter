// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
// import 'package:openim_common/src/config.dart';

// //add for parse-server
// Future<void> parse_init(String ParseServer_IP) async {
//   await Parse().initialize("BTG", "https://$ParseServer_IP/parse",
//       clientKey: "BTG", // Required for some setups
//       debug: true, // When enabled, prints logs to console
//       //liveQueryUrl: keyLiveQueryUrl, // Required if using LiveQuery
//       autoSendSessionId: false, // Required for authentication and ACL
//       //securityContext: securityContext, // Again, required for some setups
//       coreStore: await CoreStoreSharedPrefsImp
//           .getInstance()); // Local data storage method. Will use SharedPreferences instead of Sembast as an internal DB
//   // Check server is healthy and live - Debug is on in this instance so check logs for result
//   final ParseResponse response = await Parse().healthCheck();
//   String text = '';

//   if (response.success) {
//     //await repositoryGetAllItems();
//     text += 'runTestQueries\n';
//     print(text);
//     print(response.toString());
//   } else {
//     text += 'Server health check failed 2';
//     print(text);
//     print(response.toString());
//   }

//   // //minio init
//   // Config().minio_client = Minio(
//   //   endPoint: '$ParseServer_IP',
//   //   accessKey: Config().minio_access_key,
//   //   secretKey: Config().minio_secret_key,
//   //   useSSL: false,
//   //   // enableTrace: true,
//   // );

//   //Delete minio because minio confilict with flutter_local_notifications
//   // var minio_client = Config.minio_client;
//   // String bucket = Config.minio_bucket;

//   // if (!await minio_client.bucketExists(bucket)) {
//   //   await minio_client.makeBucket(bucket);
//   //   print('bucket $bucket created');
//   // } else {
//   //   print('bucket $bucket already exists');
//   // }
//   // Future<void> repositoryGetAllItems() async {
//   //   final ApiResponse response = await dietPlanRepo.getAll();
//   //   if (response.success) {
//   //     print(response.result);
//   //   }
//   // }

//   // Future<void> initRepository() async {
//   //   dietPlanRepo ??= DietPlanRepository.init(await getDB());
//   //   userRepo ??= UserRepository.init(await getDB());
//   // }

//   /// Available options:
//   /// SharedPreferences - Not secure but will work with older versions of SDK - CoreStoreSharedPrefsImpl
//   /// Sembast - NoSQL DB - Has security - CoreStoreSembastImpl
//   // Future<CoreStore> initCoreStore() async {
//   //   //return CoreStoreSembastImp.getInstance();
//   //   return CoreStoreSharedPrefsImp.getInstance();
//   // }
// }
