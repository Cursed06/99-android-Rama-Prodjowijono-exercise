package com.ninetynine.exercise

import app.cash.turbine.test
import com.ninetynine.exercise.core.error.AppException
import com.ninetynine.exercise.core.state.UiState
import com.ninetynine.exercise.data.models.Address
import com.ninetynine.exercise.data.models.Attributes
import com.ninetynine.exercise.data.models.Listing
import com.ninetynine.exercise.data.repositories.ListingRepository
import com.ninetynine.exercise.features.search_results.SearchResultsViewModel
import io.mockk.coEvery
import io.mockk.mockk
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.test.setMain
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class SearchResultsViewModelTest {

    private val testDispatcher = StandardTestDispatcher()
    private val repository: ListingRepository = mockk()

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

    @Before
    fun setup() {
        Dispatchers.setMain(testDispatcher)
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun `emits Loading then Success when repository returns listings`() = runTest {
        coEvery { repository.getListings() } returns listOf(sampleListing)

        val viewModel = SearchResultsViewModel(repository)

        viewModel.state.test {
            // Initial state is Loading
            assertTrue(awaitItem() is UiState.Loading)

            // Advance coroutines
            testDispatcher.scheduler.advanceUntilIdle()

            val successState = awaitItem()
            assertTrue(successState is UiState.Success)
            val data = (successState as UiState.Success).data
            assertEquals(1, data.size)
            assertEquals("Parkview Apartments", data[0].projectName)
        }
    }

    @Test
    fun `emits Loading then Failure when repository throws NetworkException`() = runTest {
        coEvery { repository.getListings() } throws AppException.NetworkException("No internet connection")

        val viewModel = SearchResultsViewModel(repository)

        viewModel.state.test {
            assertTrue(awaitItem() is UiState.Loading)

            testDispatcher.scheduler.advanceUntilIdle()

            val failureState = awaitItem()
            assertTrue(failureState is UiState.Failure)
            assertEquals("No internet connection", (failureState as UiState.Failure).message)
        }
    }
}
