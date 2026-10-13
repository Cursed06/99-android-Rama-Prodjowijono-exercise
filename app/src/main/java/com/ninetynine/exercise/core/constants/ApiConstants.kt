package com.ninetynine.exercise.core.constants

object ApiConstants {
    const val BASE_URL = "https://ninetyninedotco-b7299.asia-southeast1.firebasedatabase.app/"
    const val LISTINGS_PATH = "listings.json"
    const val TIMEOUT_SECONDS = 10L

    fun detailPath(id: Int): String = "details/$id.json"
}
