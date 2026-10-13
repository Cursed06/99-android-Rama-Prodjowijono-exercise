package com.ninetynine.exercise.data.models

import com.google.gson.annotations.SerializedName

data class ListingDetail(
    @SerializedName("address") val address: DetailAddress,
    @SerializedName("attributes") val attributes: Attributes,
    @SerializedName("description") val description: String,
    @SerializedName("photo") val photo: String,
    @SerializedName("project_name") val projectName: String,
    @SerializedName("property_details") val propertyDetails: List<PropertyDetailItem>? = null
) {
    /**
     * Map of label to text for fast O(1) lookup during standardized row generation.
     */
    val propertyDetailsMap: Map<String, String> by lazy {
        propertyDetails?.associate { it.label to it.text } ?: emptyMap()
    }
}

data class DetailAddress(
    @SerializedName("map_coordinates") val mapCoordinates: MapCoordinates,
    @SerializedName("subtitle") val subtitle: String,
    @SerializedName("title") val title: String
)

data class MapCoordinates(
    @SerializedName("lat") val lat: Double,
    @SerializedName("lng") val lng: Double
)

data class PropertyDetailItem(
    @SerializedName("label") val label: String,
    @SerializedName("text") val text: String
)
