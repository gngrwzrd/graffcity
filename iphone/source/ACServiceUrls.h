
//All WRITES go to tornado.app
//All READS go to fapws.app

#define ACFacebookShareURL @"http://m.facebook.com/sharer.php?u="

//Use this flag to initiate scale testing.
//#define ACUseScaleTestingDNS
#ifdef ACUseScaleTestingDNS
	#define ACRoutesSignup @"http://tornado.sclapp.graffcityapp.com/registration/create/"
	#define ACRoutesLogin @"http://fapws.sclapp.graffcityapp.com/user/login/"
	#define ACRoutesSearch @"http://fapws.sclapp.graffcityapp.com/search/"
	#define ACRoutesProfileInfo @"http://fapws.sclapp.graffcityapp.com/profile/read/"
	#define ACRoutesTagsForUsername @"http://fapws.sclapp.graffcityapp.com/user/tag/read/"
	#define ACRoutesRateTag @"http://tornado.sclapp.graffcityapp.com/tag/rate/"
	#define ACRoutesPublishTag @"http://tornado.sclapp.graffcityapp.com/tag/create/"
	#define ACRoutesPublishTagWithFileNames @"http://tornado.sclapp.graffcityapp.com/tag2/create/"
	#define ACRoutesNearby @"http://fapws.sclapp.graffcityapp.com/nearby/"
	#define ACRoutesARNearby @"http://fapws.sclapp.graffcityapp.com/arnearby/"
	#define ACRoutesLatest @"http://fapws.sclapp.graffcityapp.com/latest/"
	#define ACRoutesRatings @"http://fapws.sclapp.graffcityapp.com/rating/"
	#define ACRoutesDeleteTag @"http://fapws.sclapp.graffcityapp.com/tag/delete/"
	#define ACRoutesFacebookShare @"http://fapws.sclapp.graffcityapp.com/facebook/share/?imageName="
	#define ACTagStorage @"http://c0006418.cdn2.cloudfiles.rackspacecloud.com/"
	//#define ACTagStorage @"http://storage.graffcityapp.com/"
#endif

//Live
#ifndef ACUseScaleTestingDNS
	#define ACRoutesSignup @"http://tornado.app.graffcityapp.com/registration/create/"
	#define ACRoutesLogin @"http://fapws.app.graffcityapp.com/user/login/"
	#define ACRoutesSearch @"http://fapws.app.graffcityapp.com/search/"
	#define ACRoutesProfileInfo @"http://fapws.app.graffcityapp.com/profile/read/"
	#define ACRoutesTagsForUsername @"http://fapws.app.graffcityapp.com/user/tag/read/"
	#define ACRoutesRateTag @"http://tornado.app.graffcityapp.com/tag/rate/"
	#define ACRoutesPublishTag @"http://tornado.app.graffcityapp.com/tag/create/"
	#define ACRoutesPublishTagWithFileNames @"http://tornado.app.graffcityapp.com/tag2/create/"
	#define ACRoutesNearby @"http://fapws.app.graffcityapp.com/nearby/"
	#define ACRoutesARNearby @"http://fapws.app.graffcityapp.com/arnearby/"
	#define ACRoutesLatest @"http://fapws.app.graffcityapp.com/latest/"
	#define ACRoutesRatings @"http://fapws.app.graffcityapp.com/rating/"
	#define ACRoutesDeleteTag @"http://fapws.app.graffcityapp.com/tag/delete/"
	#define ACRoutesFacebookShare @"http://fapws.app.graffcityapp.com/facebook/share/?imageName="
	#define ACTagStorage @"http://c0006418.cdn2.cloudfiles.rackspacecloud.com/"
	//#define ACTagStorage @"http://storage.graffcityapp.com/"
#endif

//Use this to use dev.* host names.
//#define ACUseDev
#ifdef ACUseDev
	#undef ACRoutesSignup
	#undef ACRoutesLogin
	#undef ACRoutesSearch
	#undef ACRoutesProfileInfo
	#undef ACRoutesTagsForUsername
	#undef ACRoutesRateTag
	#undef ACRoutesPublishTag
	#undef ACRoutesNearby
	#undef ACS3Server
	#undef ACRoutesLatest
	#undef ACRoutesRatings
	#undef ACRoutesDeleteTag
	#undef ACRoutesFacebookShare
	#undef ACRoutesARNearby
	#undef ACRoutesPublishTagWithFileNames
	#define ACRoutesSignup @"http://dev.tornado.app.graffcityapp.com/registration/create/"
	#define ACRoutesLogin @"http://dev.fapws.app.graffcityapp.com/user/login/"
	#define ACRoutesSearch @"http://dev.fapws.app.graffcityapp.com/search/"
	#define ACRoutesProfileInfo @"http://dev.fapws.app.graffcityapp.com/profile/read/"
	#define ACRoutesTagsForUsername @"http://dev.fapws.app.graffcityapp.com/user/tag/read/"
	#define ACRoutesRateTag @"http://dev.tornado.app.graffcityapp.com/tag/rate/"
	#define ACRoutesPublishTag @"http://dev.tornado.app.graffcityapp.com/tag/create/"
	#define ACRoutesPublishTagWithFileNames @"http://dev.tornado.app.graffcityapp.com/tag2/create/"
	#define ACRoutesNearby @"http://dev.fapws.app.graffcityapp.com/nearby/"
	#define ACRoutesARNearby @"http://dev.fapws.app.graffcityapp.com/arnearby/"
	#define ACRoutesLatest @"http://dev.fapws.app.graffcityapp.com/latest/"
	#define ACRoutesRatings @"http://dev.fapws.app.graffcityapp.com/rating/"
	#define ACRoutesDeleteTag @"http://dev.fapws.app.graffcityapp.com/tag/delete/"
	#define ACRoutesFacebookShare @"http://dev.fapws.app.graffcityapp.com/facebook/share/?imageName="
	#define ACTagStorage @"http://c0006418.cdn2.cloudfiles.rackspacecloud.com/"
	//#define ACTagStorage @"http://storage.graffcityapp.com/"
#endif

//Use this to have services hit localhost.
//#define ACUseLocal
#ifdef ACUseLocal
	#undef ACRoutesSignup
	#undef ACRoutesLogin
	#undef ACRoutesSearch
	#undef ACRoutesProfileInfo
	#undef ACRoutesTagsForUsername
	#undef ACRoutesRateTag
	#undef ACRoutesPublishTag
	#undef ACRoutesNearby
	#undef ACS3Server
	#undef ACRoutesLatest
	#undef ACRoutesRatings
	#undef ACRoutesDeleteTag
	#undef ACRoutesFacebookShare
	#undef ACRoutesARNearby
	#undef ACRoutesPublishTagWithFileNames
	#define ACRoutesSignup @"http://127.0.0.1:9011/registration/create/"
	#define ACRoutesLogin @"http://127.0.0.1:9011/user/login/"
	#define ACRoutesSearch @"http://127.0.0.1:9011/search/"
	#define ACRoutesProfileInfo @"http://127.0.0.1:9011/profile/read/"
	#define ACRoutesTagsForUsername @"http://127.0.0.1:9011/user/tag/read/"
	#define ACRoutesRateTag @"http://127.0.0.1:9011/tag/rate/"
	#define ACRoutesPublishTag @"http://127.0.0.1:9011/tag/create/"
	#define ACRoutesPublishTagWithFileNames @"http://127.0.0.1:9011/tag2/create/"
	#define ACRoutesNearby @"http://127.0.0.1:9011/nearby/"
	#define ACRoutesARNearby @"http://127.0.0.1:9011/arnearby/"
	#define ACRoutesLatest @"http://127.0.0.1:9011/latest/"
	#define ACRoutesRatings @"http://127.0.0.1:9011/rating/"
	#define ACRoutesDeleteTag @"http://127.0.0.1:9011/tag/delete/"
	#define ACRoutesFacebookShare @"http://127.0.0.1:9011/facebook/share/?imageName="
	#define ACTagStorage @"http://c0006418.cdn2.cloudfiles.rackspacecloud.com/"
	//#define ACTagStorage @"http://storage.graffcityapp.com/"
#endif


