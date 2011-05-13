#!/bin/bash
ME=`whoami`
sudo mkdir -p "~/Library/MobileDevice/Provisioning Profiles"
sudo mv "provisions/allcity.mobileprovision" "/Users/${ME}/Library/MobileDevice/Provisioning Profiles"