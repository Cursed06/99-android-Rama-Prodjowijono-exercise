package com.ninetynine.exercise

import app.cash.turbine.test
import com.ninetynine.exercise.core.error.AppException
import com.ninetynine.exercise.core.state.UiState
import com.ninetynine.exercise.data.models.Attributes
import com.ninetynine.exercise.data.models.DetailAddress
import com.ninetynine.exercise.data.models.ListingDetail
import com.ninetynine.exercise.data.models.MapCoordinates
import com.ninetynine.exercise.data.repositories.ListingRepository
import com.ninetynine.exercise.features.listing_detail.ListingDetailViewModel
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
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class ListingDetailViewModelTest {

    private val testDispatcher = StandardTestDispatcher()
    private val repository: ListingRepository = mockk()

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
        Dispatchers.setMain(testDispatcher)
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun `emits Loading then Success when detail is loaded`() = runTest {
        coEvery { repository.getListingDetail(0) } returns sampleDetail

        val viewModel = ListingDetailViewModel(0, repository)

        viewModel.state.test {
            assertTrue(awaitItem() is UiState.Loading)

            testDispatcher.scheduler.advanceUntilIdle()

            val successState = awaitItem()
            assertTrue(successState is UiState.Success)
            assertEquals("Parkview Apartments", (successState as UiState.Success).data.projectName)
        }
    }

    @Test
    fun `emits Loading then Failure when repository throws NotFoundException`() = runTest {
        coEvery { repository.getListingDetail(999) } throws AppException.NotFoundException("Listing not found.")

        val viewModel = ListingDetailViewModel(999, repository)

        viewModel.state.test {
            assertTrue(awaitItem() is UiState.Loading)

            testDispatcher.scheduler.advanceUntilIdle()

            val failureState = awaitItem()
            assertTrue(failureState is UiState.Failure)
            assertEquals("Listing not found.", (failureState as UiState.Failure).message)
        }
    }

    @Test
    fun `toggleDescription toggles boolean state`() = runTest {
        coEvery { repository.getListingDetail(0) } returns sampleDetail

        val viewModel = ListingDetailViewModel(0, repository)

        assertFalse(viewModel.isDescriptionExpanded.value)

        viewModel.toggleDescription()
        assertTrue(viewModel.isDescriptionExpanded.value)

        viewModel.toggleDescription()
        assertFalse(viewModel.isDescriptionExpanded.value)
    }
}
