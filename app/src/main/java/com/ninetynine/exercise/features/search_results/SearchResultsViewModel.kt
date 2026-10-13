package com.ninetynine.exercise.features.search_results

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.ninetynine.exercise.core.error.AppException
import com.ninetynine.exercise.core.state.UiState
import com.ninetynine.exercise.data.models.Listing
import com.ninetynine.exercise.data.repositories.ListingRepository
import com.ninetynine.exercise.di.ServiceLocator
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class SearchResultsViewModel(
    private val repository: ListingRepository
) : ViewModel() {

    private val _state = MutableStateFlow<UiState<List<Listing>>>(UiState.Loading)
    val state: StateFlow<UiState<List<Listing>>> = _state.asStateFlow()

    init {
        load()
    }

    fun load() {
        viewModelScope.launch {
            _state.value = UiState.Loading
            try {
                val listings = repository.getListings()
                _state.value = UiState.Success(listings)
            } catch (e: AppException) {
                _state.value = UiState.Failure(e.message, e)
            } catch (e: Exception) {
                _state.value = UiState.Failure("Something went wrong. Please try again.", e)
            }
        }
    }

    fun refresh() {
        viewModelScope.launch {
            try {
                val listings = repository.getListings()
                _state.value = UiState.Success(listings)
            } catch (e: AppException) {
                // If there's an active failure or empty, report the error
                if (_state.value !is UiState.Success) {
                    _state.value = UiState.Failure(e.message, e)
                }
            } catch (e: Exception) {
                if (_state.value !is UiState.Success) {
                    _state.value = UiState.Failure("Something went wrong. Please try again.", e)
                }
            }
        }
    }

    companion object {
        val Factory: ViewModelProvider.Factory = object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return SearchResultsViewModel(ServiceLocator.listingRepository) as T
            }
        }
    }
}
