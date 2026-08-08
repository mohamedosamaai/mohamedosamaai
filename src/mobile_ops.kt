package com.bagback.laforma.ops

import java.time.Instant

data class FieldAgentTask(
    val taskId: String,
    val tenantId: String,
    val title: String,
    val latitude: Double,
    val longitude: Double,
    val status: TaskStatus = TaskStatus.ASSIGNED,
    val timestamp: String = Instant.now().toString()
)

enum class TaskStatus {
    ASSIGNED, IN_PROGRESS, COMPLETED, CANCELLED
}

class MobileDispatchEngine(private val tenantId: String) {
    private val taskList = mutableListOf<FieldAgentTask>()

    fun assignTask(title: String, lat: Double, lng: Double): FieldAgentTask {
        val task = FieldAgentTask(
            taskId = "task_${System.currentTimeMillis()}",
            tenantId = tenantId,
            title = title,
            latitude = lat,
            longitude = lng
        )
        taskList.add(task)
        println("Assigned new field task: ${task.taskId} for tenant $tenantId")
        return task
    }

    fun updateTaskState(taskId: String, newStatus: TaskStatus): FieldAgentTask? {
        val index = taskList.indexOfFirst { it.taskId == taskId }
        if (index != -1) {
            val updated = taskList[index].copy(status = newStatus)
            taskList[index] = updated
            println("Updated task $taskId to status $newStatus")
            return updated
        }
        return null
    }

    fun getActiveTasks(): List<FieldAgentTask> {
        return taskList.filter { it.status != TaskStatus.COMPLETED && it.status != TaskStatus.CANCELLED }
    }
}

fun main() {
    val dispatch = MobileDispatchEngine("t_102")
    val task = dispatch.assignTask("Inspect Field Router #84", 25.2048, 55.2708)
    dispatch.updateTaskState(task.taskId, TaskStatus.IN_PROGRESS)
}
