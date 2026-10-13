package com.ninetynine.exercise.data.models

import com.google.gson.annotations.SerializedName

data class Listing(
    @SerializedName("id") val id: Int,
    @SerializedName("project_name") val projectName: String,
    @SerializedName("photo") val photo: String,
    @SerializedName("category") val category: String,
    @SerializedName("completed_at") val completedAt: String,
    @SerializedName("tenure") val tenure: Int,
    @SerializedName("address") val address: Address,
    @SerializedName("attributes") val attributes: Attributes
)

data class Address(
    @SerializedName("district") val district: String,
    @SerializedName("street_name") val streetName: String
)

data class Attributes(
    @SerializedName("area_size") val areaSize: Int,
    @SerializedName("bathrooms") val bathrooms: Int,
    @SerializedName("bedrooms") val bedrooms: Int,
    @SerializedName("price") val price: Int
)
