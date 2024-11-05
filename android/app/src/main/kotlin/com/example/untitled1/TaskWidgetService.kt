package com.example.untitled1

import android.content.Intent
import android.widget.RemoteViewsService
import android.widget.RemoteViews
import android.util.Log
import kotlinx.coroutines.runBlocking
import org.json.JSONObject
import java.net.URL
import javax.net.ssl.HttpsURLConnection
import android.content.Context
import java.text.SimpleDateFormat
import java.util.*

class TaskWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TaskWidgetItemFactory(applicationContext)
    }
}

class TaskWidgetItemFactory(private val context: Context) : 
    RemoteViewsService.RemoteViewsFactory {
    
    private var tasks: List<Task> = listOf()
    private val TAG = "TaskWidgetItemFactory"
    
    override fun onCreate() {
        Log.d(TAG, "Widget Factory Created")
    }
    
    override fun onDataSetChanged() {
        Log.d(TAG, "onDataSetChanged called")
        try {
            runBlocking {
                tasks = fetchTasks()
                Log.d(TAG, "Fetched ${tasks.size} tasks")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onDataSetChanged: ${e.message}")
            e.printStackTrace()
        }
    }
    
    private fun fetchTasks(): List<Task> {
    try {
        val sharedPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val token = sharedPrefs.getString("flutter.token", "")
        val userId = sharedPrefs.getString("flutter.id", "")
        
        Log.d(TAG, "Token: $token")
        Log.d(TAG, "UserId: $userId")
        
        if (token.isNullOrEmpty() || userId.isNullOrEmpty()) {
            Log.e(TAG, "Token or UserId is empty")
            return emptyList()
        }
        
        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val today = dateFormat.format(Date())
        
        val headers = mapOf(
            "Authorization" to "Bearer $token",
            "user_id" to userId,
            "Content-Type" to "application/x-www-form-urlencoded"
        )
        
        val postData = "start_date=$today&end_date=$today&user_id=$userId&session_user_id=&status=&next_task_start_time=&lead_id=&task_type_id="
        
        val response = CustomHttpClient.post(
            "https://crm.ihelpbd.com/api/crm-lead-task-list",
            headers,
            postData
        )
        
        Log.d(TAG, "API Response: $response")
        
        val jsonResponse = JSONObject(response)
        val data = jsonResponse.getJSONArray("data")
        
        return List(data.length()) { i ->
            val taskObj = data.getJSONObject(i)
            val companyNameObj = taskObj.optJSONObject("company_name")
            val taskNameObj = taskObj.optJSONObject("task_name")
            
            Task(
                companyName = companyNameObj?.optString("company_name") ?: "No Company",
                taskName = taskNameObj?.optString("name") ?: "No Task Name",
                endTime = taskObj.optString("end_time", "No Time")
            )
        }
    } catch (e: Exception) {
        Log.e(TAG, "Error fetching tasks: ${e.message}")
        e.printStackTrace()
        return emptyList()
    }
}

    
    override fun getViewAt(position: Int): RemoteViews {
        if (position < 0 || position >= tasks.size) {
            return RemoteViews(context.packageName, R.layout.task_list_item)
        }
        
        val views = RemoteViews(context.packageName, R.layout.task_list_item)
        val task = tasks[position]
        
        try {
            views.setTextViewText(R.id.company_name, task.companyName)
            views.setTextViewText(R.id.task_name, task.taskName)
            views.setTextViewText(R.id.end_time, task.endTime)
            
            // Add click intent
            val fillInIntent = Intent()
            views.setOnClickFillInIntent(R.id.task_list_item_container, fillInIntent)
            
            Log.d(TAG, "Rendered view for task: ${task.companyName}")
        } catch (e: Exception) {
            Log.e(TAG, "Error setting view at position $position: ${e.message}")
        }
        
        return views
    }
    
    override fun getCount(): Int = tasks.size
    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true
    override fun onDestroy() {
        Log.d(TAG, "Widget Factory Destroyed")
    }
}

data class Task(
    val companyName: String,
    val taskName: String,
    val endTime: String
)
