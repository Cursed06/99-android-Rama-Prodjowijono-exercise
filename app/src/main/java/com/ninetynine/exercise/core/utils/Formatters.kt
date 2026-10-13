package com.ninetynine.exercise.core.utils

import java.text.NumberFormat
import java.util.Locale

object Formatters {

    private val numberFormat: NumberFormat = NumberFormat.getNumberInstance(Locale.US)
    private val decimalFormat: NumberFormat = NumberFormat.getNumberInstance(Locale.US).apply {
        minimumFractionDigits = 2
        maximumFractionDigits = 2
    }

    fun formatRentalPrice(price: Int): String {
        return "$${numberFormat.format(price)}/mo"
    }

    fun formatDetailPrice(price: Int): String {
        return "$${numberFormat.format(price)}"
    }

    fun formatArea(areaSize: Int): String {
        return "${numberFormat.format(areaSize)} sqft"
    }

    fun formatBedrooms(count: Int): String {
        return if (count == 1) "1 Bed" else "$count Beds"
    }

    fun formatBathrooms(count: Int): String {
        return if (count == 1) "1 Bath" else "$count Baths"
    }

    fun formatTenure(years: Int): String {
        return "$years yrs"
    }

    fun formatStreetAndDistrict(street: String, district: String): String {
        return "$street · $district"
    }

    fun formatListingAttributes(category: String, completedAt: String, tenure: Int): String {
        val parts = mutableListOf<String>()
        if (category.isNotBlank()) parts.add(category)
        if (completedAt.isNotBlank()) parts.add(completedAt)
        if (tenure > 0) parts.add(formatTenure(tenure))
        return parts.joinToString(" · ")
    }

    fun formatBedBathArea(beds: Int, baths: Int, areaSize: Int): String {
        return "${formatBedrooms(beds)} · ${formatBathrooms(baths)} · ${formatArea(areaSize)}"
    }

    fun formatPricePerSqft(price: Int, areaSize: Int, isRental: Boolean = true): String {
        if (areaSize <= 0) return "Unavailable"
        val psf = price.toDouble() / areaSize.toDouble()
        return if (isRental) {
            "$${decimalFormat.format(psf)} psf"
        } else {
            "$${numberFormat.format(psf.toInt())} psf"
        }
    }

    fun derivePropertyType(title: String, fallback: String): String {
        if (title.isBlank()) return fallback.ifBlank { "Unavailable" }
        val parts = title.split("·")
        if (parts.size >= 2) {
            val typePart = parts[1].trim()
            val words = typePart.split(" ")
            if (words.isNotEmpty()) {
                val candidate = words[0].trim()
                if (candidate.isNotEmpty()) return candidate
            }
        }
        return fallback.ifBlank { "Unavailable" }
    }
}
