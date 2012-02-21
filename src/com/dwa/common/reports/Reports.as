/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	Licence http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
	
	$Id: Reports.as 262 2012-02-04 22:01:13Z benoit $
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

	public class Reports implements IEventDispatcher
	{
		protected var dispatcher:EventDispatcher;
		
		private var piwikApi:PiwikAPI;
		
		private var mobiles:Array = new Array("AND", "BLB", "IPA", "IPH", "MAE", "POS", "SYM", "WOS", "WP7");
		
		public var result:XML;
		public var resultCollection:XMLListCollection;
		public var resultCollectionRow:XMLListCollection;
		public var resultCollectionBasic:XMLListCollection;
		
		public function Reports()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		public function getVisits(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("VisitsSummary.get");
		}
		public function getVisitsChart(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPISimple("VisitsSummary.get");
		}
		public function getVisitsPerLocalTime(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.filter = true;
			piwikApi.filterValue = 24;
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("VisitTime.getVisitInformationPerLocalTime");
		}
		public function getVisitsPerServerTime(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.filter = true;
			piwikApi.filterValue = 24;
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("VisitTime.getVisitInformationPerServerTime");
		}
		public function getConfiguration(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getConfiguration");
		}
		public function getBrowserType(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getBrowserType");
		}
		public function getBrowser(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getBrowser");
		}
		public function getOs(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getOS");
		}
		public function getResolution(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getResolution");
		}
		public function getWideScreen(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getWideScreen");
		}
		public function getPlugin(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserSettings.getPlugin");
		}
		public function getCountry(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("UserCountry.getCountry");
		}
		public function testGeoIP(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callUrlGeoIPTest(profile);
		}
		public function getGeoIPCountry(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("GeoIP.getGeoIPCountry");
		}
		public function getProvider(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Provider.getProvider");
		}
		
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
		
		
		public function getPageUrls(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getPageUrls", desktop);
		}
		public function getPageTitles(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getPageTitles", desktop);
		}
		public function getOutlinks(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getOutlinks", desktop);
		}
		public function getDownloads(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Actions.getDownloads", desktop);
		}
		
		
		public function getRefererType(profile:Profile, date:String):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getRefererType");
		}
		public function getSearchEngines(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getSearchEngines", desktop);
		}
		public function getKeywords(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getKeywords", desktop);
		}
		public function getWebsites(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getWebsites", desktop);
		}
		public function getCampaigns(profile:Profile, date:String, desktop:Boolean=true):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Referers.getCampaigns", desktop);
		}
		public function getSeoRankings(profile:Profile, url:String):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPISeo("SEO.getRank", url);
		}
		
		
		public function getAllGoals(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("Goals.getGoals");
		}
		public function getGoals(profile:Profile, date:String, idGoal:int):void{
			piwikApi = new PiwikAPI(profile, date);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikGoal("Goals.get", idGoal);
		}
		
		public function getLive(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.filter = true;
			piwikApi.filterValue = 30;
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPISimple("Live.getLastVisitsDetails");
		}
		public function checkAndGetAPIKey(url:String, user:String, pass:String):void{
			piwikApi = new PiwikAPI();
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikUsers(url, "UsersManager.getTokenAuth", user, pass);
		}
		public function getSitesWithViewAccess(profile:Profile):void{
			piwikApi = new PiwikAPI(profile);
			piwikApi.addEventListener(Event.COMPLETE, resultApi);
			piwikApi.addEventListener(ErrorEvent.ERROR, error);
			piwikApi.callPiwikAPI("SitesManager.getSitesWithAtLeastViewAccess", false, true);
		}
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