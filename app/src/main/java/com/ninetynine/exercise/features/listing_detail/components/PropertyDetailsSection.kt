package com.ninetynine.exercise.features.listing_detail.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.ninetynine.exercise.core.theme.AppTypography
import com.ninetynine.exercise.core.utils.Formatters
import com.ninetynine.exercise.data.models.ListingDetail

data class PropertyDetailRow(
    val label: String,
    val value: String
)

@Composable
fun PropertyDetailsSection(
    detail: ListingDetail,
    modifier: Modifier = Modifier
) {
    val map = detail.propertyDetailsMap

    val rows = listOf(
        PropertyDetailRow(
            label = "Price/sqft",
            value = Formatters.formatPricePerSqft(
                detail.attributes.price,
                detail.attributes.areaSize,
                isRental = true
            )
        ),
        PropertyDetailRow(
            label = "Floor level",
            value = map["Floor Level"] ?: "Unavailable"
        ),
        PropertyDetailRow(
            label = "Furnishing",
            value = map["Furnishing"] ?: "Unavailable"
        ),
        PropertyDetailRow(
            label = "Facing",
            value = map["Facing"] ?: "Unavailable"
        ),
        PropertyDetailRow(
            label = "Overlooking View",
            value = map["Overlooking View"] ?: "Unavailable"
        ),
        PropertyDetailRow(
            label = "Built year (TOP)",
            value = map["Built year"] ?: "Unavailable"
        ),
        PropertyDetailRow(
            label = "Tenure",
            value = map["Tenure"] ?: "Unavailable"
        ),
        PropertyDetailRow(
            label = "Property type",
            value = Formatters.derivePropertyType(
                detail.address.title,
                fallback = map["Property type"] ?: "Unavailable"
            )
        ),
        PropertyDetailRow(
            label = "Last updated",
            value = map["Last updated"] ?: "Unavailable"
        )
    )

    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        Text(
            text = "Property details",
            style = AppTypography.SectionHeading
        )

        Spacer(modifier = Modifier.height(16.dp))

        rows.forEach { row ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp)
            ) {
                // 50% Flex weight for label
                Text(
                    text = row.label,
                    style = AppTypography.DetailPropertyLabel,
                    modifier = Modifier.weight(0.5f)
                )
                // 50% Flex weight for value
                Text(
                    text = row.value,
                    style = AppTypography.DetailPropertyValue,
                    modifier = Modifier.weight(0.5f)
                )
            }
        }
    }
}
