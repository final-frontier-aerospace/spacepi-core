cmake_minimum_required(VERSION 3.10)

if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to 'Debug' as none was specified.")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

option(BUILD_SHARED_LIBS "Build using shared libraries." ON)

file(WRITE "${CMAKE_BINARY_DIR}/.gitignore" "*")

if (NOT SPACEPI_CORE_VERSION)
    include(${CMAKE_CURRENT_LIST_DIR}/Version.cmake)
endif()

if (NOT SPACEPI_CORE_SOURCE_DIR)
    set(SPACEPI_CORE_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../")
endif()

set_property(GLOBAL PROPERTY CXX_STANDARD 14)

find_package(Protobuf REQUIRED)
find_package(Java 1.8 COMPONENTS Development)

function (spacepi_message_library)
    set(sources ${ARGV})
    list(REMOVE_AT sources 0 1)

    set(cxxSources)
    set(javaSources)
    set(dependencies)
    foreach (source IN LISTS sources)
        get_filename_component(namespace "${source}" DIRECTORY)
        get_filename_component(basename "${source}" NAME_WE)
        list(APPEND cxxSources "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/${namespace}/${basename}.pb.cc")
        if (Java_Development_FOUND)
            list(APPEND javaSources "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/java/${namespace}/${basename}.java")
        endif()
        list(APPEND dependencies "${ARGV1}/${source}")
    endforeach()

    add_library("${ARGV0}" STATIC ${cxxSources})
    target_include_directories("${ARGV0}" PUBLIC "${ARGV1}" "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}")

    set(outputs --cpp_out "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}")
    if (Java_Development_FOUND)
        list(APPEND outputs --java_out "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/java")

        configure_file("${SPACEPI_CORE_SOURCE_DIR}/cmake/data/build.gradle" "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/build.gradle")
        configure_file("${SPACEPI_CORE_SOURCE_DIR}/cmake/data/gradle-wrapper.jar" "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/gradle/wrapper/gradle-wrapper.jar" COPYONLY)
        configure_file("${SPACEPI_CORE_SOURCE_DIR}/cmake/data/gradle-wrapper.properties" "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/gradle/wrapper/gradle-wrapper.properties" COPYONLY)
        configure_file("${SPACEPI_CORE_SOURCE_DIR}/cmake/data/gradlew" "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/gradlew" COPYONLY)
        configure_file("${SPACEPI_CORE_SOURCE_DIR}/cmake/data/gradlew.bat" "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/gradlew.bat" COPYONLY)

        if (WIN32)
            set(gradlew ./gradlew.bat)
        else()
            set(gradlew ./gradlew)
        endif()

        add_custom_command(
            OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/${ARGV0}.jar"
            COMMAND ${gradlew}
            ARGS build --warning-mode all
            DEPENDS ${javaSources}
            WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}"
            COMMENT "Running Java compiler on ${ARGV0}"
            VERBATIM
        )

        add_custom_target("${ARGV0}-java" ALL
            DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/${ARGV0}.jar"
        )
    endif()

    add_custom_command(
        OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/java"
        COMMAND cmake
        ARGS -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/java"
    )

    add_custom_command(
        OUTPUT ${cxxSources} ${javaSources}
        COMMAND protobuf::protoc
        ARGS ${outputs} "-I$<JOIN:$<TARGET_PROPERTY:${ARGV0},INCLUDE_DIRECTORIES>,;-I>" ${sources}
        DEPENDS protobuf::protoc ${dependencies} "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}/java"
        COMMENT "Running protocol buffer compiler on ${ARGV0}"
        VERBATIM
        COMMAND_EXPAND_LISTS
    )
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}")
endfunction()

function (spacepi_current_module)
    get_filename_component(modName "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
    file(RELATIVE_PATH relModDir "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    string(REGEX REPLACE "[/\\]" "_" modPrefix "${relModDir}")
    set(${ARGV0} "spacepi-mod_${modPrefix}_${modName}" PARENT_SCOPE)
endfunction()

function (spacepi_module)
    spacepi_current_module(moduleName)

    add_executable("${moduleName}" ${ARGV})
    target_link_libraries("${moduleName}" PUBLIC spacepi)

    install(TARGETS "${moduleName}")
endfunction()

function (spacepi_module_include_directories)
    spacepi_current_module(moduleName)
    
    target_include_directories(${moduleName} ${ARGV})
endfunction()

function (spacepi_module_link_libraries)
    spacepi_current_module(moduleName)

    target_link_libraries(${moduleName} ${ARGV})
endfunction()
