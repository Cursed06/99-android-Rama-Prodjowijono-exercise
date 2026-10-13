package com.ninetynine.exercise.features.search_results

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.ninetynine.exercise.core.components.EmptyView
import com.ninetynine.exercise.core.components.ErrorView
import com.ninetynine.exercise.core.components.LoadingView
import com.ninetynine.exercise.core.state.UiState
import com.ninetynine.exercise.core.theme.AppColors
import com.ninetynine.exercise.core.theme.AppTypography
import com.ninetynine.exercise.features.search_results.components.ListingCard

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchResultsScreen(
    viewModel: SearchResultsViewModel,
    onListingClick: (Int) -> Unit,
    modifier: Modifier = Modifier
) {
    val uiState by viewModel.state.collectAsStateWithLifecycle()

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text(text = "Search Results", style = AppTypography.ScreenTitle)
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = AppColors.Surface
                )
            )
        },
        containerColor = AppColors.Background,
        modifier = modifier
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .background(AppColors.Background),
            contentAlignment = Alignment.TopCenter
        ) {
            // Constrain content width to 600dp for responsive tablet layout
            Box(modifier = Modifier.widthIn(max = 600.dp)) {
                when (val state = uiState) {
                    is UiState.Loading -> {
                        LoadingView()
                    }

                    is UiState.Failure -> {
                        ErrorView(
                            message = state.message,
                            onRetry = { viewModel.load() }
                        )
                    }

                    is UiState.Success -> {
                        val listings = state.data
                        if (listings.isEmpty()) {
                            EmptyView(message = "No listings found")
                        } else {
                            LazyColumn(
                                contentPadding = PaddingValues(16.dp),
                                verticalArrangement = Arrangement.spacedBy(16.dp),
                                modifier = Modifier.fillMaxSize()
                            ) {
                                items(
                                    items = listings,
                                    key = { it.id }
                                ) { listing ->
                                    ListingCard(
                                        listing = listing,
                                        onClick = { onListingClick(listing.id) }
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
