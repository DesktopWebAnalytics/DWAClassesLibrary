/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	Licence http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
	
	$Id: Reports.as 277 2012-03-01 21:24:33Z benoit $
*/
package com.dwa.common.reports
{
	import com.dwa.common.piwik.PiwikAPI;
	import com.dwa.common.profile.Profile;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.System;
	
	import mx.collections.XMLListCollection;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * 
	 * @author Benoit Pouzet
	 * 
	 * @langversion 3.0
	 * @productversion Flex 4
	 * 
	 * @see https://github.com/DesktopWebAnalytics
	 * 
	 */
	public class Reports implements IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected var dispatcher:EventDispatcher;
		
		private var piwikApi:PiwikAPI;
		
		private var mobiles:Array = new Array("AND", "BLB", "IPA", "IPH", "MAE", "POS", "SYM", "WOS", "WP7");
		
		public var result:XML;
		public var resultCollection:XMLListCollection;
		public var resultCollectionRow:XMLListCollection;
		public var resultCollectionBasic:XMLListCollection;
		
		/**
		 * Constructor.
		 * 
		 */
		public function Reports()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		/**
		 * Get visists
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getVisits(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("VisitsSummary.get");
		}
		/**
		 * Get visists to draw the chart
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getVisitsChart(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPISimple("VisitsSummary.get");
		}
		/**
		 * Get visists per local time
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getVisitsPerLocalTime(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.filter = true;
			piwikApi.filterValue = 24;
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("VisitTime.getVisitInformationPerLocalTime");
		}
		/**
		 * Get visists per server time
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getVisitsPerServerTime(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.filter = true;
			piwikApi.filterValue = 24;
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("VisitTime.getVisitInformationPerServerTime");
		}
		/**
		 * Get configuration
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getConfiguration(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getConfiguration");
		}
		/**
		 * Get browser type
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getBrowserType(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getBrowserType");
		}
		/**
		 * Get browser
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getBrowser(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getBrowser");
		}
		/**
		 * Get os
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getOs(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getOS");
		}
		/**
		 * Get resolution
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getResolution(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getResolution");
		}
		/**
		 * Get widescreen
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getWideScreen(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getWideScreen");
		}
		/**
		 * Get plugin
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getPlugin(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getPlugin");
		}
		/**
		 * Get country
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getCountry(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserCountry.getCountry");
		}
		/**
		 * Test if GeoIP is available
		 *  
		 * @param profile
		 * 
		 */
		public function testGeoIP(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callUrlGeoIPTest(profile);
		}
		/**
		 * Get GeoIP country
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getGeoIPCountry(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("GeoIP.getGeoIPCountry");
		}
		/**
		 * Get provider
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getProvider(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Provider.getProvider");
		}
		/**
		 * Get mobile os
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getMobileOs(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			var segment:String = "";
			for each(var mob:String in mobiles){
				segment += "operatingSystem=="+mob+",";
			}
			piwikApi.callPiwikAPISegment("UserSettings.getOS", segment);
		}
		
		
		/**
		 * Get page urls
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getPageUrls(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getPageUrls", desktop);
		}
		/**
		 * Get page titles
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getPageTitles(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getPageTitles", desktop);
		}
		/**
		 * Get page outlinks
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getOutlinks(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getOutlinks", desktop);
		}
		/**
		 * Get downloads
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getDownloads(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getDownloads", desktop);
		}
		
		
		/**
		 * Get referer type
		 *  
		 * @param profile
		 * @param date
		 * 
		 */
		public function getRefererType(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getRefererType");
		}
		/**
		 * Get search engines
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getSearchEngines(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getSearchEngines", desktop);
		}
		/**
		 * Get keywords
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getKeywords(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getKeywords", desktop);
		}
		/**
		 * Get websites
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getWebsites(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getWebsites", desktop);
		}
		/**
		 * Get campaigns
		 *  
		 * @param profile
		 * @param date
		 * @param desktop
		 * 
		 */
		public function getCampaigns(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getCampaigns", desktop);
		}
		/**
		 * Get seo rankings
		 *  
		 * @param profile
		 * @param url
		 * 
		 */
		public function getSeoRankings(profile:Profile, url:String):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPISeo("SEO.getRank", url);
		}
		
		
		/**
		 * Get all goals
		 *  
		 * @param profile
		 * 
		 */
		public function getAllGoals(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Goals.getGoals");
		}
		/**
		 * Get goal
		 *  
		 * @param profile
		 * @param date
		 * @param idGoal
		 * 
		 */
		public function getGoal(profile:Profile, date:String, idGoal:int):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikGoal("Goals.get", idGoal);
		}
		
		/**
		 * Get live 
		 * @param profile
		 * 
		 */
		public function getLive(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.filter = true;
			piwikApi.filterValue = 30;
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPISimple("Live.getLastVisitsDetails");
		}
		/**
		 * Check and get API key
		 *  
		 * @param url
		 * @param user
		 * @param pass
		 * 
		 */
		public function checkAndGetAPIKey(url:String, user:String, pass:String):void{
			piwikApi = new PiwikAPI();
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikUsers(url, "UsersManager.getTokenAuth", user, pass);
		}
		/**
		 * Get sites with view access
		 *  
		 * @param profile
		 * 
		 */
		public function getSitesWithViewAccess(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("SitesManager.getSitesWithAtLeastViewAccess", false, true);
		}
		/**
		 * Get Piwik version
		 *  
		 * @param profile
		 * 
		 */
		public function getPiwikVersion(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("ExampleAPI.getPiwikVersion");
		}
		
		private function resultApi(event:Event):void{
			result = piwikApi.xml;
			resultCollection = piwikApi.xmlCollection;
			resultCollectionBasic = piwikApi.xmlCollectionBasic;
			resultCollectionRow = piwikApi.xmlCollectionRow;
			
			finish();
		}
		private function error(event:ErrorEvent):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text));
			clearAll();
		}
		
		private function finish():void{
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
			clearAll();
		}
		private function clearAll():void{
			piwikApi = null;
			
			result = null;
			resultCollection = null;
			resultCollectionBasic = null;
			resultCollectionRow = null;
			
			System.gc();
		}
		
		
		//--
		//-- IEventDispatcher
		//--
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
	}
}