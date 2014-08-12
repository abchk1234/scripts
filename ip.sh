#!/bin/bash
# To find out external IP address
curl www.iptolatlng.com?ip=$(curl whatismyip.akamai.com)
