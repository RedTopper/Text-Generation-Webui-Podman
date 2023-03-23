#!/bin/bash
# Docker does not support ,Z selinux labels, so remove them
sed 's/\/root\/\.cache\/pip,Z/\/root\/\.cache\/pip/g' Containerfile > Dockerfile
