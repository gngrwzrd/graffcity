rm -rf uploads/
mv uploads_defaults/ uploads/
chmod 777 uploads/
echo "THE DATABASE WILL BE OUT OF SYNC."
echo "YOU SHOULD TRUNCATE AND START FROM"
echo "DEFAULT FIXTURES"