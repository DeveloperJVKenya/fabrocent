package com.example.fabrocent

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.database.Cursor
import android.net.Uri
import android.telephony.SmsMessage as AndroidSmsMessage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SmsPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context
    private var eventSink: EventChannel.EventSink? = null
    private var smsReceiver: BroadcastReceiver? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, "com.fabrocent/sms")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, "com.fabrocent/sms_stream")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getInboxSms") {
            val address = call.argument<String>("address")
            try {
                result.success(readInboxSms(address))
            } catch (e: Exception) {
                result.error("SMS_READ_ERROR", e.message, null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun readInboxSms(filterAddress: String?): List<Map<String, Any?>> {
        val messages = mutableListOf<Map<String, Any?>>()
        val uri = Uri.parse("content://sms/inbox")
        val projection = arrayOf("address", "body", "date")
        val selection = filterAddress?.let { "address = ?" }
        val selectionArgs = filterAddress?.let { arrayOf(it) }

        val cursor: Cursor? = context.contentResolver.query(
            uri, projection, selection, selectionArgs, "date DESC"
        )
        cursor?.use {
            val addrIdx = it.getColumnIndex("address")
            val bodyIdx = it.getColumnIndex("body")
            val dateIdx = it.getColumnIndex("date")
            while (it.moveToNext()) {
                messages.add(
                    mapOf(
                        "address" to it.getString(addrIdx),
                        "body" to it.getString(bodyIdx),
                        "date" to it.getLong(dateIdx)
                    )
                )
            }
        }
        return messages
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        smsReceiver = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                if (intent.action != "android.provider.Telephony.SMS_RECEIVED") return
                val pdus = intent.extras?.get("pdus") as? Array<*> ?: return
                for (pdu in pdus) {
                    val msg = AndroidSmsMessage.createFromPdu(pdu as ByteArray)
                    events?.success(
                        mapOf(
                            "address" to (msg.originatingAddress ?: ""),
                            "body" to (msg.messageBody ?: ""),
                            "date" to System.currentTimeMillis()
                        )
                    )
                }
            }
        }
        val filter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
        context.registerReceiver(smsReceiver, filter)
    }

    override fun onCancel(arguments: Any?) {
        smsReceiver?.let { context.unregisterReceiver(it) }
        smsReceiver = null
        eventSink = null
    }
}
