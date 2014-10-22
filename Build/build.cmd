@echo off

set NAME=ZcBoard
set CFGNAME=ZcBoard
set RCC= %QTDIR%\bin\rcc.exe
set SRC=..\Source\
set OUTPUT=.\Deploy

IF NOT EXIST %OUTPUT%\. md %OUTPUT%

copy %SRC%\%CFGNAME%.cfg %OUTPUT%
%RCC% -threshold 70 -binary -o %OUTPUT%\%NAME%.rcc %SRC%\%NAME%.qrc