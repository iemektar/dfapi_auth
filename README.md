# DfApi Authentication
dfapi_auth, kullanıcının dfapi ile kimlik doğrulamasını sağlayan flutter paketidir.

### Kullanım

Paketi sorunsuz kullanabilmek için öncelikle android ve ios için ayarlamaların yapılması gereklidir.
Android için:
    Projede; ./android/app/build.gradle dosyasında aşağıdaki gibi ***appAuthRedirectScheme*** eklemesi yapılması gereklidir.
```
...
android {
    ...
    defaultConfig {
        ...
        manifestPlaceholders = [
                'appAuthRedirectScheme': 'dfapi.<ekip_adı>.<uygulama_adı>'
        ]
    }
}
```
 
IOS için:
  Projede ./ios/Runner/Info.plist dosyasına aşağıdaki eklemelerin yapılması gereklidir.
  
```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>dfapi.<ekip_adı>.<uygulama_adı></string>
        </array>
    </dict>
</array>
```


**Örnek şema -> dfapi.supplychain.wmstrong**

Şema adı identity server daki callback url için kullanılacaktır.


Şema işlemleri tamamlandıktan sonra altyapı tarafından sağlanan client bilgileri ile konfigurasyonların oluşturulması gerekir. Bu işlem için ***AuthConfiguration*** dosyası kullanılır.

Örnek konfigurasyon dosyası:

```dart
  var demoIdentityServerConfig = AuthConfiguration(
    issuer: "https://demo.identityserver.io",                        // -> sunucu adresi
    clientId: "interactive.public",                                  // -> client id'si
    redirectUrl: "io.identityserver.demo:/oauthredirect",            // -> callback url (oluşturulan şema kullanılmalıdır.)
                                                                     //       Örnek: dfapi.supplychain.wmstong:/callback   
    scopes: ['openid', 'profile', 'email', 'offline_access', 'api'], // -> scope bilgileri
  );
```

Oluşturulan bu konfigürasyon dosyası, ***DfApiAuthRequest*** tipindeki bir request objesi ile ***DfApiApp*** widget' ına parametre olarak geçirilir.

Örnek:

```dart
  
  class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var demoIdentityServerConfig = AuthConfiguration(
    issuer: "https://demo.identityserver.io",
    clientId: "interactive.public",
    redirectUrl: "io.identityserver.demo:/oauthredirect",
    scopes: ['openid', 'profile', 'email', 'offline_access', 'api'],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          child: DfApiApp(
            request: DfApiAuthRequest(
              child: Container(
                  color: Colors.white,
                  child: OutlinedButton(
                    onPressed: () {
                      DfApiApp.functions.logOut();
                    },
                    child: Text("Log Out"),
                  )),
              configuration: demoIdentityServerConfig,
              loginWidget: LoginPage(),
            ),
          ),
        ),
      ),
    );
  }
}
  
```

DfApiAuthRequest nesnesinde, child ve configuration zorunlu alanlardır. child, kullanıcı başarılı bir şekilde giriş yaptığı durumda render edilir. Bundan dolayı child ana uygulama widget' ı yada anasayfa gibi bir widget olabilir.


Uygulama agacı içerisinde, farklı yerlerde oturum açan kullanıcının bilgilerine veya kullanıcı ile ilişkili token' a ihtiyacınız olabilir. Bu durumda ***DfApiAppFunctions*** tipindeki yardımcı class kullanılabilir. Bu class' a DfApiApp içerisindeki functions alanı ile erişilir.

Örnek: 

```dart
  var token = await DfApiApp.functions.getToken();
  //ya da
  token = DfApiApp.token;
``` 
 

Kullanıcı girişi esnasında çeşitli yerlerde gösterilen loading, login ve error widgetları özelleştirilmek istenirse eğer ***DfApiAuthRequest*** nesnesine parametre olarak verilebilir.

Örnek:
```dart
  
...

child: DfApiApp(
  request: DfApiAuthRequest(
    child: Container(
        color: Colors.white,
        child: OutlinedButton(
          onPressed: () {
            DfApiApp.functions.logOut();
          },
          child: Text("Log Out"),
        )),
    configuration: demoIdentityServerConfig,
    loginWidget: LoginPage(), // ->  İsteğe Bağlı
    loadingWidget: Text("Loading ..."), // ->  İsteğe Bağlı
    callBack: (String token, DfApiUserInfo userInfo) { //... }, // ->  İsteğe Bağlı
    splashWidget: Container(), // -> Uygulama ilk açıldığında loading yerine kullanılır (isteğe bağlı)
  ),
),

...        
  
```

Kullanıcı giriş yaptıktan sonra token veya kullanıcı bilgilerine ihtiyacınız varsa request' te bulunan callBack parametresine ***Function(String, DfApiUserInfo)*** tipinde fonksiyon geçirilerek token ve kullanıcının claims gibi diğer bilgilerine ulaşabilirsiniz.

callBack fonskiyonundan alınan token aşağıdaki gibi api çağrılarında kullanılmak üzere ayarlanabilir.

```dart
...

child: DfApiApp(
  request: DfApiAuthRequest(
    ...
    callBack: apiHelperInitializer,
    ...
  ),
),

...

void apiHelperInitializer(String token, DfApiUserInfo userInfo) {
  if (GetIt.I.isRegistered<ApiHelper>()) return;

  var uri = Uri.parse("api url");
  List<ApiHelperPathItem> paths = [
    ApiHelperPathItem.get("Key", "Path/SamplePath"),
  ];

  var apiHelper = ApiHelper.setup(
    uri,
    token,
    paths,
    responseResolverFunc: (json) => (json) { //... },
  );
  GetIt.I.registerLazySingleton<ApiHelper>(() => apiHelper);
}

```
---
Api çağrıları için ***api_helper*** paketi kullanılabilir. 

https://pub.dev/packages/api_helper