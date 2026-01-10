cmake_minimum_required(VERSION 3.28)

# -----------------------------------------------------------------------------
# 1. Backend Selection
# -----------------------------------------------------------------------------
set(ODYSSEY_BACKEND "CUDA" CACHE STRING "Select GPU backend: HIP or CUDA")
set_property(CACHE ODYSSEY_BACKEND PROPERTY STRINGS "HIP" "CUDA")

message(STATUS "========================================")
message(STATUS "Odyssey Build Configuration")
message(STATUS "Backend Selected: ${ODYSSEY_BACKEND}")
message(STATUS "========================================")

# -----------------------------------------------------------------------------
# 2. Compiler & Language Setup
# -----------------------------------------------------------------------------
if(ODYSSEY_BACKEND STREQUAL "HIP")
    # [HIP Mode]
    if(NOT DEFINED CMAKE_CXX_COMPILER)
        find_program(HIPCC_PATH hipcc HINTS /opt/rocm/bin /usr/bin ENV PATH)
        if(HIPCC_PATH)
            set(CMAKE_CXX_COMPILER "${HIPCC_PATH}")
        else()
            message(FATAL_ERROR "hipcc not found! Check ROCM_PATH.")
        endif()
    endif()

    project(rocOdyssey LANGUAGES CXX HIP)

    if(NOT DEFINED CMAKE_HIP_ARCHITECTURES)
        set(CMAKE_HIP_ARCHITECTURES "native")
    endif()

elseif(ODYSSEY_BACKEND STREQUAL "CUDA")
    # [CUDA Mode]
    project(rocOdyssey LANGUAGES CXX CUDA)
    if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
        set(CMAKE_CUDA_ARCHITECTURES "native")
    endif()

else()
    message(FATAL_ERROR "Invalid backend: ${ODYSSEY_BACKEND}")
endif()

# -----------------------------------------------------------------------------
# 3. Source Files Selection
# -----------------------------------------------------------------------------
set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

# Host Code (C++)
set(COMMON_SOURCES
    ${SRC_DIR}/main.cpp
    ${SRC_DIR}/task1.cpp
    ${SRC_DIR}/task2.cpp
)

if(ODYSSEY_BACKEND STREQUAL "HIP")
    set(GPU_SOURCE ${SRC_DIR}/Odyssey.hip)  # AMD ROCm HIP
    message(STATUS "Adding source: Odyssey.hip")
else()
    set(GPU_SOURCE ${SRC_DIR}/Odyssey.cu)   # NVIDIA CUDA
    message(STATUS "Adding source: Odyssey.cu")
endif()

# -----------------------------------------------------------------------------
# 4. Target Definition
# -----------------------------------------------------------------------------

add_executable(exec ${COMMON_SOURCES} ${GPU_SOURCE})

# -----------------------------------------------------------------------------
# 5. Include & Link Options
# -----------------------------------------------------------------------------
target_include_directories(exec PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}
)

if(ODYSSEY_BACKEND STREQUAL "HIP")
    target_compile_definitions(exec PRIVATE BACKEND_HIP)
else()
    target_compile_definitions(exec PRIVATE BACKEND_CUDA)
endif()

target_compile_options(exec PRIVATE -g -Wall)


if(UNIX)
    target_link_libraries(exec PRIVATE m)
endif()

# -----------------------------------------------------------------------------
# 6. Utilities (Plot & Clean)
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