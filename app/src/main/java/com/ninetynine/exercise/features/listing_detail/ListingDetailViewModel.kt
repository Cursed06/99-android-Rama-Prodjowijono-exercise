package com.ninetynine.exercise.features.listing_detail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.ninetynine.exercise.core.error.AppException
import com.ninetynine.exercise.core.state.UiState
import com.ninetynine.exercise.data.models.ListingDetail
import com.ninetynine.exercise.data.repositories.ListingRepository
import com.ninetynine.exercise.di.ServiceLocator
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class ListingDetailViewModel(
    val listingId: Int,
    private val repository: ListingRepository
) : ViewModel() {

    private val _state = MutableStateFlow<UiState<ListingDetail>>(UiState.Loading)
    val state: StateFlow<UiState<ListingDetail>> = _state.asStateFlow()

    private val _isDescriptionExpanded = MutableStateFlow(false)
    val isDescriptionExpanded: StateFlow<Boolean> = _isDescriptionExpanded.asStateFlow()

    init {
        load()
    }

    fun load() {
        viewModelScope.launch {
            _state.value = UiState.Loading
            try {
                val detail = repository.getListingDetail(listingId)
                _state.value = UiState.Success(detail)
            } catch (e: AppException) {
                _state.value = UiState.Failure(e.message, e)
            } catch (e: Exception) {
                _state.value = UiState.Failure("Something went wrong. Please try again.", e)
            }
        }
    }

    fun toggleDescription() {
        _isDescriptionExpanded.value = !_isDescriptionExpanded.value
    }

    companion object {
        fun provideFactory(
            listingId: Int,
            repository: ListingRepository = ServiceLocator.listingRepository
        ): ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return ListingDetailViewModel(listingId, repository) as T
            }
        }
    }
}
