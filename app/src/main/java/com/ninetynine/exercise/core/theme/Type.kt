package com.ninetynine.exercise.core.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

// In Android without proprietary bundled Avenir Next font files, FontFamily.SansSerif
// provides the native system clean fallback matching Flutter's Nunito Sans / sans-serif fallback.
val DefaultFontFamily = FontFamily.SansSerif

object AppTypography {
    val ScreenTitle = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 18.sp,
        lineHeight = 18.sp,
        color = AppColors.TextPrimary
    )

    val PriceLarge = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Bold, // w700
        fontSize = 23.sp,
        lineHeight = 23.sp,
        color = AppColors.TextPrimary
    )

    val TitleLarge = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 19.sp,
        lineHeight = 19.sp,
        color = AppColors.TextPrimary
    )

    val DetailAddress = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 14.sp,
        lineHeight = 14.sp,
        color = AppColors.TextMuted
    )

    val DetailStat = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 16.sp,
        lineHeight = 16.sp,
        color = AppColors.TextPrimary
    )

    val SectionHeading = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 19.sp,
        lineHeight = 19.sp,
        color = AppColors.TextPrimary
    )

    val DetailPropertyLabel = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Medium, // w500
        fontSize = 16.sp,
        lineHeight = 16.sp,
        color = AppColors.TextPrimary
    )

    val DetailPropertyValue = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 16.sp,
        lineHeight = 16.sp,
        color = AppColors.TextPrimary
    )

    val CardPrice = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 19.sp,
        lineHeight = 19.sp,
        color = AppColors.TextPrimary
    )

    val CardTitle = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 16.sp,
        lineHeight = 16.sp,
        color = AppColors.TextPrimary
    )

    val CardAddress = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 14.sp,
        lineHeight = 14.sp,
        color = AppColors.TextMuted
    )

    val CardAttributes = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 14.sp,
        lineHeight = 14.sp,
        color = AppColors.TextMuted
    )

    val CardStats = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 14.sp,
        lineHeight = 14.sp,
        color = AppColors.TextPrimary
    )

    val CardPsf = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 14.sp,
        lineHeight = 14.sp,
        color = AppColors.TextMuted
    )

    val Body = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.Normal, // w400
        fontSize = 16.sp,
        lineHeight = 28.sp,
        color = AppColors.TextPrimary
    )

    val Link = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 14.sp,
        lineHeight = 14.sp,
        color = AppColors.Link
    )

    val Badge = TextStyle(
        fontFamily = DefaultFontFamily,
        fontWeight = FontWeight.SemiBold, // w600
        fontSize = 12.sp,
        lineHeight = 12.sp,
        color = AppColors.Surface
    )
}

val Typography = Typography()
