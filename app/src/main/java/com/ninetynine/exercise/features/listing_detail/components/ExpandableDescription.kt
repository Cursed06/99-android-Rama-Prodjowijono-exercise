package com.ninetynine.exercise.features.listing_detail.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.ninetynine.exercise.core.theme.AppTypography

@Composable
fun ExpandableDescription(
    description: String,
    isExpanded: Boolean,
    onToggle: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Text(
            text = "Description",
            style = AppTypography.SectionHeading
        )

        Spacer(modifier = Modifier.height(12.dp))

        Text(
            text = description,
            style = AppTypography.Body,
            maxLines = if (isExpanded) Int.MAX_VALUE else 5,
            overflow = TextOverflow.Ellipsis
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = if (isExpanded) "Show less" else "Read more",
            style = AppTypography.Link,
            modifier = Modifier
                .clickable(onClick = onToggle)
                .padding(vertical = 4.dp)
        )
    }
}
