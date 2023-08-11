# Copyright (c) Microsoft Corporation
# SPDX-License-Identifier: MIT

set(CMAKE_CXX_STANDARD 20)

Include(FetchContent)

FetchContent_Declare(
  yaml-cpp
  GIT_REPOSITORY https://github.com/jbeder/yaml-cpp.git
  GIT_TAG        0.8.0 # or a later release
)

FetchContent_MakeAvailable(yaml-cpp)

if (PLATFORM_WINDOWS)
  find_program(NUGET nuget)
  if(NOT NUGET)
    message("ERROR: You must first install nuget.exe from https://www.nuget.org/downloads")
  else()
    exec_program(${NUGET} ARGS install "eBPF-for-Windows" -Version 0.10.0 -ExcludeVersion -OutputDirectory ${PROJECT_BINARY_DIR}/packages)
  endif()
  set(EBPF_LIB "ebpfapi")
elseif(PLATFORM_LINUX)
  find_library(LIBBPF libbpf)
  set(EBPF_LIB "bpf")
endif()

include(CheckSymbolExists)

check_symbol_exists(bpf_prog_load "bpf/bpf.h" HAS_BPF_PROG_LOAD)

if(NOT HAS_BPF_PROG_LOAD)
  add_compile_definitions(USE_DEPRECATED_LOAD_PROGRAM)
endif()

add_executable(
  bpf_performance_runner
  runner.cc
)

target_link_libraries(bpf_performance_runner PRIVATE ${EBPF_LIB} "yaml-cpp")



