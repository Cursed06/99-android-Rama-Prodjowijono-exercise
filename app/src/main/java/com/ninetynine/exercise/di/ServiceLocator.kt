package com.ninetynine.exercise.di

import com.ninetynine.exercise.data.repositories.ListingRepository
import com.ninetynine.exercise.data.repositories.ListingRepositoryImpl
import com.ninetynine.exercise.data.services.ListingApi
import com.ninetynine.exercise.data.services.RetrofitClient

object ServiceLocator {
    val listingApi: ListingApi by lazy {
        RetrofitClient.listingApi
    }

    val listingRepository: ListingRepository by lazy {
        ListingRepositoryImpl(listingApi)
    }
}
