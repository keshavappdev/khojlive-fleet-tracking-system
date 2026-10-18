class Config {
 static const url=String.fromEnvironment('API_URL',defaultValue:'http://10.0.2.2:4000');
 static String get apiUrl => url;
 static const demoEmail='driver@khojlive.test';
}
