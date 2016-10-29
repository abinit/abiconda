#!/bin/bash
RUN="conda build . --keep-old-work"
echo Executing $RUN
$RUN