package com.ninetynine.exercise

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.ninetynine.exercise.core.theme.NinetyNineTheme
import com.ninetynine.exercise.features.listing_detail.ListingDetailScreen
import com.ninetynine.exercise.features.listing_detail.ListingDetailViewModel
import com.ninetynine.exercise.features.search_results.SearchResultsScreen
import com.ninetynine.exercise.features.search_results.SearchResultsViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            NinetyNineTheme {
                NinetyNineAppNavHost()
            }
        }
    }
}

@Composable
fun NinetyNineAppNavHost() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "search_results"
    ) {
        composable("search_results") {
            val searchViewModel: SearchResultsViewModel = viewModel(
                factory = SearchResultsViewModel.Factory
            )
            SearchResultsScreen(
                viewModel = searchViewModel,
                onListingClick = { listingId ->
                    navController.navigate("listing_detail/$listingId")
                }
            )
        }

        composable(
            route = "listing_detail/{listingId}",
            arguments = listOf(
                navArgument("listingId") { type = NavType.IntType }
            )
        ) { backStackEntry ->
            val listingId = backStackEntry.arguments?.getInt("listingId") ?: 0
            val detailViewModel: ListingDetailViewModel = viewModel(
                key = "detail_$listingId",
                factory = ListingDetailViewModel.provideFactory(listingId)
            )
            ListingDetailScreen(
                viewModel = detailViewModel,
                onBackClick = {
                    navController.popBackStack()
                }
            )
        }
    }
}
