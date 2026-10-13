package com.ninetynine.exercise.data.services

import com.ninetynine.exercise.core.constants.ApiConstants
import com.ninetynine.exercise.data.models.Listing
import com.ninetynine.exercise.data.models.ListingDetail
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import java.util.concurrent.TimeUnit

interface ListingApi {
    @GET(ApiConstants.LISTINGS_PATH)
    suspend fun getListings(): List<Listing>

    @GET("details/{id}.json")
    suspend fun getListingDetail(@Path("id") id: Int): ListingDetail?
}

object RetrofitClient {
    private val okHttpClient: OkHttpClient by lazy {
        val logging = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BASIC
        }
        OkHttpClient.Builder()
            .addInterceptor(logging)
            .connectTimeout(ApiConstants.TIMEOUT_SECONDS, TimeUnit.SECONDS)
            .readTimeout(ApiConstants.TIMEOUT_SECONDS, TimeUnit.SECONDS)
            .writeTimeout(ApiConstants.TIMEOUT_SECONDS, TimeUnit.SECONDS)
            .build()
    }

    val listingApi: ListingApi by lazy {
        Retrofit.Builder()
            .baseUrl(ApiConstants.BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ListingApi::class.java)
    }
}
