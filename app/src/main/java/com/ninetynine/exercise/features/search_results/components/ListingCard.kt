package com.ninetynine.exercise.features.search_results.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.ninetynine.exercise.core.theme.AppColors
import com.ninetynine.exercise.core.theme.AppTypography
import com.ninetynine.exercise.core.utils.Formatters
import com.ninetynine.exercise.data.models.Listing

@Composable
fun ListingCard(
    listing: Listing,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = AppColors.CardBackground),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            // Photo with 16:9 aspect ratio and 60dp bottom gradient overlay
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(16f / 9f)
                    .clip(RoundedCornerShape(8.dp))
            ) {
                AsyncImage(
                    model = listing.photo,
                    contentDescription = listing.projectName,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize()
                )

                // 60dp bottom gradient overlay matching Figma (40% black)
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(60.dp)
                        .align(Alignment.BottomCenter)
                        .background(
                            brush = Brush.verticalGradient(
                                colors = listOf(Color.Transparent, AppColors.PhotoOverlay)
                            )
                        )
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Price: "$2,561/mo"
            Text(
                text = Formatters.formatRentalPrice(listing.attributes.price),
                style = AppTypography.CardPrice
            )

            Spacer(modifier = Modifier.height(4.dp))

            // Project Name: "Parkview Apartments"
            Text(
                text = listing.projectName,
                style = AppTypography.CardTitle
            )

            Spacer(modifier = Modifier.height(2.dp))

            // Address: "12 Meyappa Chettiar Rd · D13"
            Text(
                text = Formatters.formatStreetAndDistrict(
                    listing.address.streetName,
                    listing.address.district
                ),
                style = AppTypography.CardAddress
            )

            Spacer(modifier = Modifier.height(2.dp))

            // Category · Year · Tenure: "Condo · 2020 · 99 yrs"
            Text(
                text = Formatters.formatListingAttributes(
                    listing.category,
                    listing.completedAt,
                    listing.tenure
                ),
                style = AppTypography.CardAttributes
            )

            Spacer(modifier = Modifier.height(8.dp))

            // Bed · Bath · Area and Price/sqft row
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = Formatters.formatBedBathArea(
                        listing.attributes.bedrooms,
                        listing.attributes.bathrooms,
                        listing.attributes.areaSize
                    ),
                    style = AppTypography.CardStats,
                    modifier = Modifier.weight(1f)
                )

                Text(
                    text = Formatters.formatPricePerSqft(
                        listing.attributes.price,
                        listing.attributes.areaSize,
                        isRental = true
                    ),
                    style = AppTypography.CardPsf
                )
            }
        }
    }
}
