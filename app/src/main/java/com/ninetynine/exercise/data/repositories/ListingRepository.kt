package com.ninetynine.exercise.data.repositories

import com.google.gson.JsonParseException
import com.ninetynine.exercise.core.error.AppException
import com.ninetynine.exercise.data.models.Listing
import com.ninetynine.exercise.data.models.ListingDetail
import com.ninetynine.exercise.data.services.ListingApi
import retrofit2.HttpException
import java.io.IOException
import java.net.SocketTimeoutException

interface ListingRepository {
    suspend fun getListings(): List<Listing>
    suspend fun getListingDetail(id: Int): ListingDetail
}

class ListingRepositoryImpl(
    private val api: ListingApi
) : ListingRepository {

    override suspend fun getListings(): List<Listing> {
        return safeApiCall {
            api.getListings()
        }
    }

    override suspend fun getListingDetail(id: Int): ListingDetail {
        return safeApiCall {
            val detail = api.getListingDetail(id)
            detail ?: throw AppException.NotFoundException("Listing not found.")
        }
    }

    private suspend fun <T> safeApiCall(block: suspend () -> T): T {
        return try {
            block()
        } catch (e: AppException) {
            throw e
        } catch (e: SocketTimeoutException) {
            throw AppException.NetworkException("Request timed out. Please try again.", e)
        } catch (e: IOException) {
            throw AppException.NetworkException("No internet connection. Please check your network.", e)
        } catch (e: HttpException) {
            throw AppException.NetworkException("Server error (${e.code()}). Please try again.", e)
        } catch (e: JsonParseException) {
            throw AppException.ParseException("Unexpected data format from server.", e)
        } catch (e: Exception) {
            throw AppException.UnknownException(e.message ?: "Something went wrong.", e)
        }
    }
}
