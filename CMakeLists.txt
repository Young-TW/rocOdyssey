cmake_minimum_required(VERSION 3.16)

# Project name and language (CXX is sufficient for HIP as it uses C++ compiler)
project(OdysseyHIP LANGUAGES CXX)

# -----------------------------------------------------------------------------
# HIP Configuration
# -----------------------------------------------------------------------------
# Set default ROCm path if not set in environment
if(NOT DEFINED ROCM_PATH)
    set(ROCM_PATH "/opt/rocm" CACHE PATH "Path to ROCm installation")
endif()

# Add ROCm to prefix path to find HIP packages
list(APPEND CMAKE_PREFIX_PATH ${ROCM_PATH})

# Find HIP package
find_package(HIP REQUIRED)

# -----------------------------------------------------------------------------
# Source Files
# -----------------------------------------------------------------------------
set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

# Define source files
# Note: Ensure Odyssey.cu is renamed to Odyssey.cpp after running hipify-perl
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

# Include directories (equivalent to -I. -I${CUDA_PATH}/include)
target_include_directories(exec PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${ROCM_PATH}/include
)

# Compiler options (equivalent to -g -Wall)
target_compile_options(exec PRIVATE -g -Wall)

# Link libraries (equivalent to -L... -lcudart)
# hip::device will automatically link necessary runtime libraries
target_link_libraries(exec PRIVATE hip::device)

# Link math library explicitly if needed (equivalent to -lm)
if(UNIX)
    target_link_libraries(exec PRIVATE m)
endif()

# -----------------------------------------------------------------------------
# Custom Targets (Ported from Makefile)
# -----------------------------------------------------------------------------
# Plot target: mimics "make plot"
add_custom_target(plot
    COMMAND gnuplot < ${CMAKE_CURRENT_SOURCE_DIR}/plot/plot_task2.gp
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running gnuplot script..."
)

# Clean is handled automatically by CMake ("make clean"), but we can add 
# a custom cleanup for generated images if needed.
add_custom_target(clean_images
    COMMAND rm -f ${CMAKE_CURRENT_SOURCE_DIR}/*.png
    COMMENT "Cleaning generated PNG images..."
)