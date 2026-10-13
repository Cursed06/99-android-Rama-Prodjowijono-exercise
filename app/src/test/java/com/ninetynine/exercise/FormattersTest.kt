package com.ninetynine.exercise

import com.ninetynine.exercise.core.utils.Formatters
import org.junit.Assert.assertEquals
import org.junit.Test

class FormattersTest {

    @Test
    fun `formatRentalPrice formats price with dollar sign and per month`() {
        assertEquals("$2,561/mo", Formatters.formatRentalPrice(2561))
        assertEquals("$4,000/mo", Formatters.formatRentalPrice(4000))
        assertEquals("$12,500/mo", Formatters.formatRentalPrice(12500))
    }

    @Test
    fun `formatDetailPrice formats price without per month`() {
        assertEquals("$2,561", Formatters.formatDetailPrice(2561))
    }

    @Test
    fun `formatArea formats square footage with thousands separators`() {
        assertEquals("2,561 sqft", Formatters.formatArea(2561))
        assertEquals("915 sqft", Formatters.formatArea(915))
    }

    @Test
    fun `formatBedrooms handles singular and plural counts`() {
        assertEquals("1 Bed", Formatters.formatBedrooms(1))
        assertEquals("2 Beds", Formatters.formatBedrooms(2))
        assertEquals("3 Beds", Formatters.formatBedrooms(3))
    }

    @Test
    fun `formatBathrooms handles singular and plural counts`() {
        assertEquals("1 Bath", Formatters.formatBathrooms(1))
        assertEquals("2 Baths", Formatters.formatBathrooms(2))
    }

    @Test
    fun `formatTenure formats tenure in years`() {
        assertEquals("99 yrs", Formatters.formatTenure(99))
    }

    @Test
    fun `formatStreetAndDistrict joins street and district with middot`() {
        assertEquals(
            "12 Meyappa Chettiar Rd · D13",
            Formatters.formatStreetAndDistrict("12 Meyappa Chettiar Rd", "D13")
        )
    }

    @Test
    fun `formatListingAttributes joins category, completed year, and tenure`() {
        assertEquals(
            "Condo · 2020 · 99 yrs",
            Formatters.formatListingAttributes("Condo", "2020", 99)
        )
    }

    @Test
    fun `formatBedBathArea joins beds, baths, and area size`() {
        assertEquals(
            "3 Beds · 2 Baths · 2,561 sqft",
            Formatters.formatBedBathArea(3, 2, 2561)
        )
    }

    @Test
    fun `formatPricePerSqft calculates PSF dynamically`() {
        assertEquals("$1.00 psf", Formatters.formatPricePerSqft(2561, 2561, isRental = true))
        assertEquals("$3.95 psf", Formatters.formatPricePerSqft(4000, 1012, isRental = true))
        assertEquals("Unavailable", Formatters.formatPricePerSqft(1000, 0, isRental = true))
    }

    @Test
    fun `derivePropertyType extracts type from title`() {
        assertEquals(
            "Condo",
            Formatters.derivePropertyType("1 Keppel Bay View · Condo for Rent", "HDB 5 Rooms")
        )
        assertEquals(
            "Apartment",
            Formatters.derivePropertyType("Wallich · Apartment for Rent", "Condo")
        )
        assertEquals(
            "HDB",
            Formatters.derivePropertyType("", "HDB")
        )
    }
}
