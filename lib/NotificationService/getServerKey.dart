import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "ihelpcrm",
          "private_key_id": "667442941fdee47105b900b3dcad59f1e7c11ddd",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2rhCCGMQBCLAX\nLm7cdWerP45ntNnpd5N+Vj5OgT/XCB6gRX0BX2cyZA2FFYppLQRilN/fidUGfAo9\nwteHX99VfQ1CqMunsLWKs1jmshWRcoVUWyfBI9gZHxG0oL9IeRPiJao2KnYhK/3P\njPDwFED9VjCmrss+L1QjVnTdRXzfLjY2X6OOP4NN7vF9X/KMbj6rnzbW/90Imtyr\nsZMhuZtczTzlksGtWx5EgO4ub04pq/lrdkn+G9PLbRYI8cDfQrFQCNWBqep/NRLr\nXTlnrCAqm+omu+wNLvlYy9AkkdRuOhCBGx8qaRXpjvQsE0U7nt4eVBtgytT6Wx9j\n3B7uP9PBAgMBAAECggEACyhK+FMwZ3rDHItYuIzQKeCuHy3n0E9eGg2E7TEON+E2\nU6Yi2ipcSHLdc4crBrz541aB7OqDcQuy6W5E0S8dGiDS5kMeey27DM9i6uYuFI3Y\n0Fvn6+83Q+OGppBZ1oCUow+XW4sQ33pLHHnYfmVSSdbRjmCnJ7Nm0Wi2pwwXMh9L\nNVQ01T44xrcAecGtqzwPYA6XnkMh/FBY58pr4MwzzpZyhRkRXSvECU7ng/wjXgFI\nUT5k+9qz7HsAanU+uTRgTzwSXMIK9HSsTRjC8cYsJ+UId8zrMsvXat73SZiwrHKj\nRxZu3VtU6/lRh8vPqZdRnxwFBVZX31uP/iykdg+BUQKBgQDnG3vTxNynaKRba0Al\nt+fOi1ipWj3dcRz6vHPYuR7ytJbKubddMhim8L18Ejp4+RT+tKYX3oAvvwWK0/4c\nD+2ZKuKf5rMxnvQektSLPY+gyTh5nDtUJ2bUF3ZNOBYi/ufMzbQwvr5aUY8LyTfj\ncmD7Q6ys2iwUSXEkihRVWw6ReQKBgQDKW0BIH4gMVJbLK3T6c88Z257x1/mbulOT\n3gxLm1UFHnN8MYshT/gWhmeJRPPYz2Yk8HzxRap1+O9D3dE9ZW5KxnQ2q+b1mjKc\npRXUIthG5ygIgt3nv7m1s8px5Dfh55pL55vTdec/1dRq2WCrQwf9ViTjn10i6iim\nfli8Ld9KiQKBgQClUcq9jUiO1NMltk337Vt8K8ArvSseGkkxr9drA9n4omhv8nQR\nzcFGwlW5yExdt0hmf5GE55xpC0uKqOVQ66/6bmwZGG29JEjbCgvS4yG4Udj9XV4v\nb9QmCfaNfH6RYCkvH0Mzz27ZqxgZxUIeiPaJJzsBlzwK8xJlogSznmSIeQKBgQCS\ncemaiJ9H9SvQS1n0Kz21Q/jKo3f0WKtFtwwE55xnAPuo5J4A9MPhYVGqySkEPkx4\n7UYuwjE0AXz/C5fzK+Xe3bKbIlsaYYbBUMP0a2dEIOQbDMKVhm5a7ovTUsuShK9o\nwWxHY+uAijqZPUo1h2RP1jkKNnoL25ShsYx8W2JeqQKBgDf1i6S90X8VB16hFmzy\nahqOzlbmMi65RCdenHqEnFdR6KbkJ75D+62ZySTNqaMyT0wByvM5mEYTbSmrBJiW\nnUTlc3NBeBOjAlVeXKGtoGzz5bVdw+QFNaG++UsvS+BhYMt6Aos8kX1aGIdmSBtq\nHM/Tsj/BGqBai6E0Rb/04ha5\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-iezgg@ihelpcrm.iam.gserviceaccount.com",
          "client_id": "101416183021842129785",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-iezgg%40ihelpcrm.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);

    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
