# If you have selected SDL2 component when installed Vulkan SDK
# The following settings will work
if (NOT TARGET SDL2)
    if (WIN32)  # Windows, use clang or MSVC
        # 打印环境变量
        set(VULKAN_INCLUDE_DIR "${VULKAN_DIR}/Include")
        message(STATUS "VULKAN_INCLUDE_DIR: ${VULKAN_INCLUDE_DIR}")

        set(SDL2_INCLUDE_DIR "${VULKAN_DIR}/Include/SDL2")
        message(STATUS "SDL2_INCLUDE_DIR: ${SDL2_INCLUDE_DIR}")

        set(SDL2_LIB_DIR "$ENV{VULKAN_SDK}/Lib")
        set(SDL2_BIN_DIR "$ENV{VULKAN_SDK}/Bin")
        add_library(SDL2::SDL2 SHARED IMPORTED GLOBAL)
        set_target_properties(
            SDL2::SDL2
            PROPERTIES
                IMPORTED_LOCATION "${SDL2_BIN_DIR}/SDL2.dll"
                IMPORTED_IMPLIB "${SDL2_LIB_DIR}/SDL2.lib"
                INTERFACE_INCLUDE_DIRECTORIES ${SDL2_INCLUDE_DIR}
        )
        add_library(SDL2::SDL2main SHARED IMPORTED GLOBAL)
        set_target_properties(
            SDL2::SDL2main
            PROPERTIES
                IMPORTED_LOCATION "${SDL2_BIN_DIR}/SDL2.dll"
                IMPORTED_IMPLIB "${SDL2_LIB_DIR}/SDL2main.lib"
                INTERFACE_INCLUDE_DIRECTORIES ${SDL2_INCLUDE_DIR}
        )
        add_library(SDL2 INTERFACE IMPORTED GLOBAL)
        target_link_libraries(SDL2 INTERFACE SDL2::SDL2 SDL2::SDL2main)
    else()  # Linux, MacOSX
        find_package(SDL2 QUIET)
        if (SDL2_FOUND)
            add_library(SDL2 ALIAS SDL2::SDL2)
        else()
            find_package(PkgConfig REQUIRED)
            pkg_check_modules(SDL2 sdl2 REQUIRED IMPORTED_TARGET)
            add_library(SDL2 ALIAS PkgConfig::SDL2)
        endif()
    endif()
endif()
