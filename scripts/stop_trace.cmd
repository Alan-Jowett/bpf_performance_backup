rem Copyright (c) Microsoft Corporation
rem SPDX-License-Identifier: MIT
@echo off
wpr.exe -stop "%1\%2.etl" >> wpr.log
exit 0