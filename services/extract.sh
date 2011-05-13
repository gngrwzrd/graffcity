unzip services_deploy.zip
rm -rf __MACOSX/
mv services_deploy/* .
rm services_deploy.zip
rm -rf services_deploy/
chmod 777 init.sh
chmod 777 clean.sh
chmod 777 clean_uploads.sh
chmod 777 extract.sh