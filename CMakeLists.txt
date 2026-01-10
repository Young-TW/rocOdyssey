cmake_minimum_required(VERSION 3.28)

# Find hipcc compiler if CMAKE_CXX_COMPILER is not set
if(NOT DEFINED CMAKE_CXX_COMPILER)
    find_program(HIPCC_PATH hipcc HINTS /opt/rocm/bin /usr/bin ENV PATH)

    if(HIPCC_PATH)
        set(CMAKE_CXX_COMPILER "${HIPCC_PATH}")
        message(STATUS "Found hipcc: ${HIPCC_PATH}")
        message(STATUS "Forcing CMAKE_CXX_COMPILER to hipcc")
    else()
        message(FATAL_ERROR "Could not find hipcc. Please ensure ROCm is installed or set CMAKE_CXX_COMPILER manually.")
    endif()
endif()

# -----------------------------------------------------------------------------
# Project Setup
# -----------------------------------------------------------------------------
# Enable C++ and HIP languages
project(rocOdyssey LANGUAGES CXX HIP)

if(NOT DEFINED CMAKE_HIP_ARCHITECTURES)
    set(CMAKE_HIP_ARCHITECTURES "native")
endif()

# -----------------------------------------------------------------------------
# Source Files
# -----------------------------------------------------------------------------
set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

set(SOURCES
    ${SRC_DIR}/main.cpp
    ${SRC_DIR}/task1.cpp
    ${SRC_DIR}/task2.cpp
    ${SRC_DIR}/Odyssey.hip
)

# -----------------------------------------------------------------------------
# Executable Target
# -----------------------------------------------------------------------------
add_executable(exec ${SOURCES})

# Set include directories and compile options
target_include_directories(exec PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CXX_COMPILER_PARENT_DIR}/../include 
)

target_compile_options(exec PRIVATE -g -Wall)

# -----------------------------------------------------------------------------
# Libraries
# -----------------------------------------------------------------------------
# Link Math library on UNIX systems
if(UNIX)
    target_link_libraries(exec PRIVATE m)
endif()

# -----------------------------------------------------------------------------
# Custom Targets
# -----------------------------------------------------------------------------
add_custom_target(plot
    COMMAND gnuplot < ${CMAKE_CURRENT_SOURCE_DIR}/plot/plot_task2.gp
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running gnuplot script..."
)

add_custom_target(clean_images
    COMMAND rm -f ${CMAKE_CURRENT_SOURCE_DIR}/*.png
    COMMENT "Cleaning generated PNG images..."
)