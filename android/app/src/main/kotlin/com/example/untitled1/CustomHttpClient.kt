package com.example.untitled1

import java.net.URL
import javax.net.ssl.*
import java.security.cert.X509Certificate
import android.util.Log
import java.io.BufferedReader
import java.io.DataOutputStream
import java.io.InputStreamReader

object CustomHttpClient {
    private val TAG = "CustomHttpClient"

    private val trustAllCerts = arrayOf<TrustManager>(object : X509TrustManager {
        override fun getAcceptedIssuers(): Array<X509Certificate>? = null
        override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}
        override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}
    })

    init {
        try {
            val sc = SSLContext.getInstance("SSL")
            sc.init(null, trustAllCerts, java.security.SecureRandom())
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.socketFactory)
            HttpsURLConnection.setDefaultHostnameVerifier { _, _ -> true }
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing SSL context: ${e.message}")
        }
    }

    fun post(urlString: String, headers: Map<String, String>, postData: String): String {
        var connection: HttpsURLConnection? = null
        try {
            val url = URL(urlString)
            connection = url.openConnection() as HttpsURLConnection
            
            connection.requestMethod = "POST"
            connection.doOutput = true
            connection.doInput = true
            
            // Set headers
            headers.forEach { (key, value) ->
                connection.setRequestProperty(key, value)
            }

            // Send post data
            DataOutputStream(connection.outputStream).use { it.writeBytes(postData) }

            // Read response
            val responseCode = connection.responseCode
            Log.d(TAG, "Response Code: $responseCode")

            return if (responseCode == HttpsURLConnection.HTTP_OK) {
                BufferedReader(InputStreamReader(connection.inputStream)).use { reader ->
                    val response = StringBuilder()
                    var line: String?
                    while (reader.readLine().also { line = it } != null) {
                        response.append(line)
                    }
                    response.toString()
                }
            } else {
                BufferedReader(InputStreamReader(connection.errorStream)).use { reader ->
                    val response = StringBuilder()
                    var line: String?
                    while (reader.readLine().also { line = it } != null) {
                        response.append(line)
                    }
                    throw Exception("HTTP Error: $responseCode - ${response.toString()}")
                }
            }
        } finally {
            connection?.disconnect()
        }
    }
}
