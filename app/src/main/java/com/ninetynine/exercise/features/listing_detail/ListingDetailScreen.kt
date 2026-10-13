package com.ninetynine.exercise.features.listing_detail

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.ninetynine.exercise.core.components.ErrorView
import com.ninetynine.exercise.core.components.LoadingView
import com.ninetynine.exercise.core.state.UiState
import com.ninetynine.exercise.core.theme.AppColors
import com.ninetynine.exercise.features.listing_detail.components.DetailHero
import com.ninetynine.exercise.features.listing_detail.components.ExpandableDescription
import com.ninetynine.exercise.features.listing_detail.components.PriceHeader
import com.ninetynine.exercise.features.listing_detail.components.PropertyDetailsSection
import kotlinx.coroutines.launch

@Composable
fun ListingDetailScreen(
    viewModel: ListingDetailViewModel,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val uiState by viewModel.state.collectAsStateWithLifecycle()
    val isDescriptionExpanded by viewModel.isDescriptionExpanded.collectAsStateWithLifecycle()

    val context = LocalContext.current
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
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
                        val detail = state.data
                        val scrollState = rememberScrollState()

                        Column(
                            modifier = Modifier
                                .fillMaxSize()
                                .background(AppColors.Surface)
                                .verticalScroll(scrollState)
                        ) {
                            DetailHero(
                                photoUrl = detail.photo,
                                onBackClick = onBackClick
                            )

                            PriceHeader(
                                detail = detail,
                                onViewOnMapClick = {
                                    val lat = detail.address.mapCoordinates.lat
                                    val lng = detail.address.mapCoordinates.lng
                                    val mapUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng")
                                    val intent = Intent(Intent.ACTION_VIEW, mapUri)
                                    try {
                                        context.startActivity(intent)
                                    } catch (e: ActivityNotFoundException) {
                                        scope.launch {
                                            snackbarHostState.showSnackbar("No maps or browser app found to display coordinates.")
                                        }
                                    } catch (e: Exception) {
                                        scope.launch {
                                            snackbarHostState.showSnackbar("Unable to open map: ${e.message}")
                                        }
                                    }
                                }
                            )

                            HorizontalDivider(
                                color = AppColors.Divider,
                                thickness = 1.dp,
                                modifier = Modifier.padding(horizontal = 16.dp)
                            )

                            PropertyDetailsSection(detail = detail)

                            HorizontalDivider(
                                color = AppColors.Divider,
                                thickness = 1.dp,
                                modifier = Modifier.padding(horizontal = 16.dp)
                            )

                            ExpandableDescription(
                                description = detail.description,
                                isExpanded = isDescriptionExpanded,
                                onToggle = { viewModel.toggleDescription() }
                            )
                        }
                    }
                }
            }
        }
    }
}
