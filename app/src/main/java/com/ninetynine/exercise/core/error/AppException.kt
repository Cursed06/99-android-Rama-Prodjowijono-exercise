package com.ninetynine.exercise.core.error

sealed class AppException(
    override val message: String,
    override val cause: Throwable? = null
) : Exception(message, cause) {

    class NetworkException(
        message: String = "No internet connection. Please check your network and try again.",
        cause: Throwable? = null
    ) : AppException(message, cause)

    class ParseException(
        message: String = "Failed to process data from server.",
        cause: Throwable? = null
    ) : AppException(message, cause)

    class NotFoundException(
        message: String = "Listing not found.",
        cause: Throwable? = null
    ) : AppException(message, cause)

    class UnknownException(
        message: String = "Something went wrong. Please try again.",
        cause: Throwable? = null
    ) : AppException(message, cause)
}
