CURDIR=`pwd`
DEST="release/adhoc/"
APP_SHORT_NAME=${PROJECT}
APP="AllCity.app"
VERSION=`./scripts/echo-plist-node.rb Info.plist CFBundleShortVersionString`
BUILD_VERSION=`./scripts/echo-plist-node.rb Info.plist CFBundleVersion`
VERSION="${VERSION}.${BUILD_VERSION}"
DYSM="${APP}.dSYM"
DYSM_FILE="${APP}.${VERSION}.dSYM"
WRAPPER="${APP_SHORT_NAME}.${VERSION}"
ZIPNAME="${WRAPPER}.zip"
cd "$DEST"
mkdir -p "${WRAPPER}"
cp -Rpf "../../provisions/All_City_iPhone_Ad_Hoc_Distribution.mobileprovision" "${WRAPPER}"
cp -Rpf "${TARGET_BUILD_DIR}/${APP}" "${WRAPPER}/${APP}"
ditto -cj --keepParent "${WRAPPER}" "$ZIPNAME"
rm -rf "$WRAPPER"
cd "$CURDIR"