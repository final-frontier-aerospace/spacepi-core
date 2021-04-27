# spacepi_has_platform(<result>)
function (spacepi_has_platform SPACEPI_PLATFORM_VAR)
    get_property(res GLOBAL PROPERTY SPACEPI_HAS_PLATFORM DEFINED)
    set("${SPACEPI_PLATFORM_VAR}" "${res}" PARENT_SCOPE)
endfunction()

# spacepi_platform([DEFAULT])
macro (spacepi_platform)
    cmake_parse_arguments(SPACEPI_PLATFORM "DEFAULT" "" "" ${ARGN})

    spacepi_has_platform(hasPlat)
    if (hasPlat)
        return()
    endif()

    if (SPACEPI_PLATFORM_ID)
        file(RELATIVE_PATH p "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
        if (NOT p STREQUAL SPACEPI_PLATFORM_ID)
            return()
        endif()
    elseif (NOT SPACEPI_PLATFORM_DEFAULT)
        return()
    endif()
endmacro()