rm -rf services_deploy.zip
cp -r services/ services_deploy/
rm -rf services_deploy/uploads/
rm -rf services_deploy/serve/
zip -r services_deploy.zip services_deploy/
rm -rf services_deploy/