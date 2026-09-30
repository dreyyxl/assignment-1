#!/usr/bin/env bash

echo "=== SYSTEM INFORMATION ==="

hostname=$(hostname)
user=$(whoami)
kernel=$(uname -r)
directory=$(pwd)
datetime=$(date)
OS=$(lsb_release -d | cut -f2)
uptime=$(uptime -p)
CPU=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
Memory=$(free -h | grep Mem)


echo "HOSTNAME: $hostname"
echo "USER: $user"
echo "KERNEL: $kernel"
echo "DIRECTORY: $directory"
echo "DATE/TIME: $datetime"
echo "OPERATING SYS: $OS"
echo "UPTIME: $uptime"
echo "CPU Info: $CPU"
echo "MEMORY: $Memory"