import 'package:googleapis_auth/auth_io.dart';
import 'dart:async';

class AccessFirebase {
  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "ihelpcrm",
      "private_key_id": "f9716be158e8fd65c07dd216f1c52037952869c2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDFIrWsV+aMn9mQ\nre1X6KA9aiCjruacPQ0Bsem7S4DrX9ERzlWaGuw+RuWH06OlOE9p5n6lsWJnuc4o\n+RZss6zYABltcrmt/gyUTqoqnmenMPcwOogkBSsbzdsRyiLttCs+LLMAaIoddJ+J\nHw24LZTOjbQOGZhFgfltMFvFGfm8kRBu7zix9e968CsQ3BUeliyW849sXZQ1iTlw\nQrMS8JFvFwubaEWzJGw/d4BVW0CAHPuEn6lO8TsoRJ7jj9fb5IhVOMhVCjXaM0iR\nQGWs8YWOcW0a0/yIM25oZljb92liyKi0tfnxTy69kQgEEeykFR68jLzux5EkoQCj\nOr2bSjQFAgMBAAECggEAMgwTz0Mplr3mQCLHxK+cLrtIugVnKncdXDbMve33NspG\ni5y0gsEfBNh+4TLLsuBO2PXZZTtZXjf/rMs/9CzRTq0Hx49+sDt0+hnWfadlbT6z\nIp1ZfruJLC/g0+1bXLmG2OwELbBckAnRjsBBfWalBqNW+NVqoQrURfIm+i0UB9jh\nqtmmZQKPsEMa/XB+BNCf1L7XpYrtP1hH7XVGlo7IZQeh4a+xGLK4f75leuo2v++F\n3Wyh3TCAiTq981zsV00Z+HrxQDi7Gbkb9lbsa/cy3GzChhRYHPnfJzfXEWyFO2jZ\nGTc0FSm1qnsRff2NMsmcQg2tcThNWw5LLi2E5+efKQKBgQD1u5eArkmE76aqL7C9\n+aPKhdriO6Yp5/BZYoE6zauBfVTVKsr2QbWIGSTqnvVYtxZuBCKBrQtFnkUhODvh\nj7UkX0hVohmur/A8YaRejWVM9Sl9vdjD2QMjOEHt6/AOHf8gbQezlOvR/XHDZ9/p\nTo2Btbj+6bU0Hv/a4DgbDQ230wKBgQDNX0/x41jjQO1xPRCzCv7OLoklQqX0cEkX\nmla3wfirUdyxsiraj79QL7HO5jFxVoPsusPhx9XuQAAOs1DEKkBLx5THlWXYRon7\n6mM1k6EKqRqnR7QxzTkngWX1rF2KmToXhuobtDefCE3bz+C5MmfHMNVJ5lVgwWFp\nwz7nCMQVxwKBgGsb53+peFY/d2/69Zj49VHTYoL16QmfFX6Alz+gYj9A9/cqfek0\n3wGBpDu4Kc0PkPFHUBsh6CXiRNOkBUXeM+C0v3zD+VnRSm+nR9QG4b7XpcwvMgq7\nzshNPz+LdclRfeEOZSr7oIaZaDr6TfkNylRdd1N1Xwxm7rLixNHVsMMNAoGAWT9S\nPovN1PQiO1OOLkBY+sC+WLLd65vgJ6GqjbB9n/WzMoV6mgBd4zrWylK+qcIvEnEX\nLsbo8OBfJgRG1PiHeGcDALiryZDd5du1wVKmaTuTmZ5PcFT+wWw6IskE3XY5CIBY\nvDFU+odhTmTIA7Mj5iwShErUT3e6HXv7mer1S4ECgYBLuu2R90kLOe7HbWXbbizu\nJui8/Qe4uwmXVcEavvyec23cKheLxyRh9wSUgYFRE6HQJZVrhDfNP/JJwm3nMy0U\nkAg0K+jdUbqhExBqh77njYBGYhnIqwutkZlz6pA6NmiBdBw3EgGLv7/U+GAEHRs5\nymRWvohc1+kv20+LMxWlqg==\n-----END PRIVATE KEY-----\n",
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
    });

    final client =
        await clientViaServiceAccount(credentials, [firebaseMessagingScope]);
    return client.credentials.accessToken.data;
  }
}
