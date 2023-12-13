package kr.or.kddsa.kdmp_cm_app

import android.content.ActivityNotFoundException
import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URISyntaxException

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "kdmp_cm"

    //MethodChannel 구현
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppUrl" -> {                // Intent:// 스키마를 통한 URL파싱
                    try {
                        val url: String? = call.argument("url")

                        if (url == null) {
                            result.error("9999", "URL PARAMETER IS NULL", null)
                        } else {
                            Log.i("[getAppUrl] url", url)
                            val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
                            result.success(intent.dataString)
                        }
                    } catch (e: URISyntaxException) {
                        result.notImplemented()
                    } catch (e: ActivityNotFoundException) {
                        result.notImplemented()
                    }
                }
                "getMarketUrl" -> {          // 들어온 URL을 통해 package 명 및 market 다운로드 주소 반환
                    try {
                        val url: String? = call.argument("url")
                        if (url == null) {
                            result.error("9999", "URL PARAMETER IS NULL", null)
                        } else {
                            Log.i("[getMarketUrl] url", url)
                            val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
                            val scheme = intent.scheme
                            val packageName = intent.getPackage()
                            if (packageName != null) {
                                result.success("market://details?id=$packageName")
                            }
                            result.notImplemented()
                        }
                    } catch (e: URISyntaxException) {
                        result.notImplemented()
                    } catch (e: ActivityNotFoundException) {
                        result.notImplemented()
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
