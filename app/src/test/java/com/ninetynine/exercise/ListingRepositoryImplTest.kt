package com.ninetynine.exercise

import com.ninetynine.exercise.core.error.AppException
import com.ninetynine.exercise.data.models.Address
import com.ninetynine.exercise.data.models.Attributes
import com.ninetynine.exercise.data.models.DetailAddress
import com.ninetynine.exercise.data.models.Listing
import com.ninetynine.exercise.data.models.ListingDetail
import com.ninetynine.exercise.data.models.MapCoordinates
import com.ninetynine.exercise.data.repositories.ListingRepositoryImpl
import com.ninetynine.exercise.data.services.ListingApi
import io.mockk.coEvery
import io.mockk.mockk
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Before
import org.junit.Test
import java.io.IOException

class ListingRepositoryImplTest {

    private val api: ListingApi = mockk()
    private lateinit var repository: ListingRepositoryImpl

    private val sampleListing = Listing(
        id = 0,
        projectName = "Parkview Apartments",
        photo = "https://picsum.photos/id/10/450/300",
        category = "Condo",
        completedAt = "2020",
        tenure = 99,
        address = Address(district = "D13", streetName = "12 Meyappa Chettiar Rd"),
        attributes = Attributes(areaSize = 2561, bathrooms = 2, bedrooms = 3, price = 2561)
    )

    private val sampleDetail = ListingDetail(
        projectName = "Parkview Apartments",
        photo = "https://picsum.photos/id/10/450/300",
        description = "A spacious 3-bedroom apartment.",
        address = DetailAddress(
            title = "1 Keppel Bay View · Condo for Rent",
            subtitle = "Telok Blangah / Harbourfront (D4)",
            mapCoordinates = MapCoordinates(lat = 1.2657, lng = 103.8185)
        ),
        attributes = Attributes(areaSize = 2561, bathrooms = 2, bedrooms = 3, price = 2561),
        propertyDetails = emptyList()
    )

    @Before
    fun setup() {
        repository = ListingRepositoryImpl(api)
    }

    @Test
    fun `getListings delegates to api and returns listings`() = runTest {
        coEvery { api.getListings() } returns listOf(sampleListing)

        val result = repository.getListings()

        assertEquals(1, result.size)
        assertEquals("Parkview Apartments", result[0].projectName)
    }

    @Test
    fun `getListings maps IOException to NetworkException`() = runTest {
        coEvery { api.getListings() } throws IOException("No route to host")

        try {
            repository.getListings()
            org.junit.Assert.fail("Expected NetworkException")
        } catch (e: AppException.NetworkException) {
            assertEquals("No internet connection. Please check your network.", e.message)
        }
    }

    @Test
    fun `getListingDetail throws NotFoundException when api returns null`() = runTest {
        coEvery { api.getListingDetail(999) } returns null

        try {
            repository.getListingDetail(999)
            org.junit.Assert.fail("Expected NotFoundException")
        } catch (e: AppException.NotFoundException) {
            assertEquals("Listing not found.", e.message)
        }
    }

    @Test
    fun `getListingDetail returns detail successfully`() = runTest {
        coEvery { api.getListingDetail(0) } returns sampleDetail

        val result = repository.getListingDetail(0)

        assertEquals("Parkview Apartments", result.projectName)
        assertEquals(1.2657, result.address.mapCoordinates.lat, 0.0001)
    }
}
