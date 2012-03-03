# DWA Classes Library

This library is a common library for the desktop and mobile DWA applications.

You can use it, of course, in other project.

This library is under LGPL v3 licence.


## Classes

### DataBase

This class allows you to use the SQLite database. Works with Profile class.

"websites" table: dbId | websiteId | websiteName | websiteUrl | websitePiwikAccess | websiteAuth | websiteIconUrl | websiteDay | websitePeriod | websiteCreated | websiteTimezone | websiteCurrency


### LoadIcons

This class allows you to load icons to a local cache.

### Languages

This class allows you to manage the locale languages and list them. Works with locale files in assets/languages/locale/ 

### PiwikAPI

This class allows you to call the Piwik API. Works with Reports class and adobe/crypto/MD5 class.

### Profile

This class list all properties of a profile.

* dbId
* websiteId
* websiteName
* websiteUrl
* websitePiwikAccess
* websiteAuth
* websiteIconUrl
* websiteDay
* websitePeriod
* websiteCreated
* websiteTimezone
* websiteCurrency

* selected

### Reports

This class allows you to call all the reports available. Works with PiwikAPI and Profile classes.

* getVisits
* getVisitsChart
* getVisitsPerLocalTime
* getVisitsPerServerTime
* getConfiguration
* getBrowserType
* getBrowser
* getOs
* getResolution
* getWideScreen
* getPlugin
* getCountry
* getGeoIPCountry
* getProvider

* getPageUrls
* getPageTitles
* getOutlinks
* getDownloads

* getRefererType
* getSearchEngines
* getKeywords
* getWebsites
* getCampaigns
* getSeoRankings

* getAllGoals
* getGoal

* getLive

## Contributing

Everybody is welcome to contribute. You can help out in several ways.

- Reporting [issues](https://github.com/DesktopWebAnalytics/DWAClassesLibrary/issues) on GitHub
- Sending pull requests for bug fixes or new features and improvements.
- Help to making the docs.


## More info

DWA (Desktop Web Analytics): http://www.desktop-web-analytics.com

About Piwik: http://piwik.org