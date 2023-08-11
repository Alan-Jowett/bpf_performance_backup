[![CI/CD](https://github.com/Alan-Jowett/bpf_performance/actions/workflows/CICD.yml/badge.svg)](https://github.com/Alan-Jowett/bpf_performance/actions/workflows/CICD.yml)[![Coverage Status](https://coveralls.io/repos/github/Alan-Jowett/bpf_performance/badge.svg)](https://coveralls.io/github/Alan-Jowett/bpf_performance)


# bpf_performance
A set of platform agnostic to measure the performance of various BPF helper functions.

## Overview
Tests are defined as BPF programs, with each program having a map_state_preparation phase and a test phase.

Tests are then described in a yaml file.

As an example:

```yaml
tests:
  - name: Baseline
    description: The Baseline test with an empty eBPF program.
    elf_file: baseline.o
    iteration_count: 10000000
    program_cpu_assignment:
      baseline_program: all

  - name: Hash-table Map Read
    description: Tests reading from a BPF_MAP_TYPE_HASH map.
    elf_file: generic_map.o
    map_state_preparation:
      program: prepare_HASH_state_generic_read
      iteration_count: 1024
    iteration_count: 10000000
    program_cpu_assignment:
      read_HASH: all

  - name: Hash-table Map Update / Read
    description: Tests reading and writing to a BPF_MAP_TYPE_HASH map.
    elf_file: generic_map.o
    map_state_preparation:
      program: prepare_HASH_state_generic_read
      iteration_count: 1024
    iteration_count: 10000000
    program_cpu_assignment:
      update_HASH: [0]
      read_HASH: unassigned
```

Test programs can be pinned to specific CPUs to permit mixed behavior tests (such as concurrent reads and updates to a map).

## Building
```shell
cmake -B build -S .
cmake --build build
```

This builds on both Windows (using eBPF for Windows) and Linux.

For Linux, the following packages are required:
1. gcc-multilib
2. libbpf-dev
3. Clang / llvm

For Windows, the following tools are required:
1. Nuget
2. Clang / LLVM

## Running the tests

Linux
```shell
cd build/bin
sudo ./bpf_performance_runner tests.yml
```

Windows (after installing eBPF for Windows MSI)
```cmd
cd build\bin\Debug
.\bpf_performance_runner tests.yml
```
