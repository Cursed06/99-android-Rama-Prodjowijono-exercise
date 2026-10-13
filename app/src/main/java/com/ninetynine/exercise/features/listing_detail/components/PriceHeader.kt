package com.ninetynine.exercise.features.listing_detail.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.LocationOn
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import com.ninetynine.exercise.core.theme.AppColors
import com.ninetynine.exercise.core.theme.AppTypography
import com.ninetynine.exercise.core.utils.Formatters
import com.ninetynine.exercise.data.models.ListingDetail

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun PriceHeader(
    detail: ListingDetail,
    onViewOnMapClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        // Price: "$2,561"
        Text(
            text = Formatters.formatDetailPrice(detail.attributes.price),
            style = AppTypography.PriceLarge
        )

        Spacer(modifier = Modifier.height(4.dp))

        // Project Name: "Parkview Apartments"
        Text(
            text = detail.projectName,
            style = AppTypography.TitleLarge
        )

        Spacer(modifier = Modifier.height(4.dp))

        // Address title: "1 Keppel Bay View · Condo for Rent"
        Text(
            text = detail.address.title,
            style = AppTypography.DetailAddress
        )

        Spacer(modifier = Modifier.height(2.dp))

        // Address subtitle: "Telok Blangah / Harbourfront (D4)"
        Text(
            text = detail.address.subtitle,
            style = AppTypography.DetailAddress
        )

        Spacer(modifier = Modifier.height(12.dp))

        // "View on map" action
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier
                .clip(RoundedCornerShape(4.dp))
                .clickable(onClick = onViewOnMapClick)
                .padding(vertical = 4.dp)
        ) {
            Icon(
                imageVector = Icons.Outlined.LocationOn,
                contentDescription = "Location Pin",
                tint = AppColors.Link,
                modifier = Modifier.size(16.dp)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text(
                text = "View on map",
                style = AppTypography.Link
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        // FlowRow of Quick Stats badges (resilient to enlarged accessibility fonts)
        FlowRow(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            StatBadge(text = Formatters.formatBedrooms(detail.attributes.bedrooms))
            StatBadge(text = Formatters.formatBathrooms(detail.attributes.bathrooms))
            StatBadge(text = Formatters.formatArea(detail.attributes.areaSize))
        }
    }
}

@Composable
private fun StatBadge(
    text: String,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .clip(RoundedCornerShape(6.dp))
            .background(AppColors.Background)
            .padding(horizontal = 10.dp, vertical = 6.dp)
    ) {
        Text(
            text = text,
            style = AppTypography.DetailStat
        )
    }
}
