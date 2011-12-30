/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	Licence http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
	
	$Id: PiwikAPI.as 238 2011-12-15 15:28:16Z benoit $
*/
package com.dwa.common.piwik
{
	import com.adobe.crypto.MD5;
	import com.dwa.common.profile.Profile;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestDefaults;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.XMLListCollection;
	
	[Event(name='complete', type='flash.events.Event')]
	[Event(name='error', type='flash.events.ErrorEvent')]
	
	public class PiwikAPI implements IEventDispatcher
	{
		protected var dispatcher:EventDispatcher;
		
		private var currentProfile:Profile;
		private var currentDate:String;
		
		public var filter:Boolean = false;
		public var filterValue:Number;
		
		private var loader:URLLoader;
		
		private var urlRequest:URLRequest;
		private var requestVars:URLVariables;
		
		public var xmlCollection:XMLListCollection;
		public var xmlCollectionRow:XMLListCollection;
		public var xmlCollectionBasic:XMLListCollection;
		public var xml:XML;
		
		public function PiwikAPI(profile:Profile=null, date:String='')
		{
			dispatcher = new EventDispatcher(this);
			trace("init piwik api");
			
			currentProfile = profile;
			currentDate = date;
			
			xmlCollection = new XMLListCollection();
			xmlCollectionRow = new XMLListCollection();
			xmlCollectionBasic = new XMLListCollection();
			xml = new XML();
			
			URLRequestDefaults.idleTimeout = 3600000;
			URLRequestDefaults.cacheResponse = false;
			URLRequestDefaults.useCache = false;
			
			setUrlRequest();
			setRequestVars();
		}
		private function setUrlRequest():void{
			urlRequest = new URLRequest();
			if(currentProfile) urlRequest.url = currentProfile.websitePiwikAccess;
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.contentType = "application/x-www-form-urlencoded";
			
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			urlRequest.requestHeaders.push(header);
		}
		private function setRequestVars():void{
			requestVars = new URLVariables();
			
			requestVars.module = "API";
			if(currentProfile) requestVars.idSite = currentProfile.websiteId;
			requestVars.period = "range";
			requestVars.date = currentDate;
			requestVars.format = "xml";
			if(currentProfile) requestVars.token_auth = currentProfile.websiteAuth;
		}
		private function callUrl(method:String, expand:Boolean = false, segment:String=null):void{
			requestVars.method = method;
			
			if(filter == true) requestVars.filter_limit = filterValue;
			if(expand == true) requestVars.expanded = 1;
			if(segment != null) requestVars.segment = segment;
			
			loadResults();
		}
		private function callUrlSimple(method:String, expand:Boolean = false, segment:String=null):void{
			requestVars.method = method;
			requestVars.period = "day";
			
			if(filter == true) requestVars.filter_limit = filterValue;
			if(expand == true) requestVars.expanded = 1;
			if(segment != null) requestVars.segment = segment;
			
			loadResults();
		}
		private function callUrlBasic(method:String):void{
			requestVars.method = method;
			requestVars.period = "day";
			
			loadResults();
		}
		public function callUrlGeoIPTest(profile:Profile):void{
			requestVars.method = "GeoIP.getGeoIPCountry";
			requestVars.period = "day";
			requestVars.date = "yesterday";

			loadResults();
		}
		
		public function callPiwikAPI(method:String, expand:Boolean = false, basic:Boolean = false, goals:Boolean = false, idGoal:int = 0):void{
			
			if(basic == false){
				callUrl(method, expand);
			}else{
				callUrlBasic(method);
			}
		}
		public function callPiwikAPISimple(method:String):void{
			callUrlSimple(method);
		}
		public function callPiwikAPISeo(method:String, url:String):void{
			requestVars.method = method;
			requestVars.url = url;
			
			loadResults();
		}
		public function callPiwikAPISegment(method:String, segment:String):void{
			callUrl(method, false, segment);
		}
		public function callPiwikGoal(method:String, idGoal:int):void{
			requestVars.method = method;
			requestVars.period = "day";
			requestVars.idGoal = idGoal;
			
			loadResults();
		}
		
		public function callPiwikUsers(url:String, method:String, user:String, pass:String):void
		{
			var md5pass:String = MD5.hash(pass);
			//urlR = url + MODULE + method + "&userLogin=" + user + "&md5Password=" + md5pass;
			
			urlRequest.url = url;
			
			requestVars.method = method;
			requestVars.userLogin = user;
			requestVars.md5Password = md5pass;
			
			loadResults();
		}
		private function loadResults():void{
			trace("url: " + urlRequest.url);
			trace("vars: " + requestVars.toString());
			urlRequest.data = requestVars;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			loader.addEventListener(Event.OPEN, open);
			loader.addEventListener(ProgressEvent.PROGRESS, progress);
			loader.addEventListener(Event.COMPLETE, getResults);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponse);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			
			loader.load(urlRequest);
		}
		private function removeListeners():void{
			loader.removeEventListener(Event.OPEN, open);
			loader.removeEventListener(ProgressEvent.PROGRESS, progress);
			loader.removeEventListener(Event.COMPLETE, getResults);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponse);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
		}
		private function progress(event:ProgressEvent):void{
			
		}
		private function open(event:Event):void{
			//trace(event);
		}
		private function httpResponse(event:HTTPStatusEvent):void{
			//trace("HTTP response: " +event);
			if(event.status != 200) {
				loader.close();
				removeListeners();
				errorIn(event);
			}
		}
		private function httpStatus(event:HTTPStatusEvent):void{
			//trace("HTTP Status: " + event);
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			removeListeners();
			errorIn(event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
			removeListeners();
			errorIn(event);
		}
		private function getResults(e:Event):void{
			removeListeners();
			
			try{
				xml = new XML(e.currentTarget.data);
				// Test error xml result from server
				var err:XMLList = new XMLList(xml.error);
				
				if(err.length() != 0){
					var message:String = err.@message;
					errorIn("[Piwik Error] " + message);
				}else{
					var xmlResult:XMLList = new XMLList(xml.result);
					xmlCollectionBasic = new XMLListCollection(xml.row);
					xmlCollection.source = xmlResult;
					xmlCollectionRow.source = xmlResult.row;
					finish();
				}
			}catch(event:ErrorEvent){
				trace("error result: " + event.toString());
				errorIn("error result");
			}
		}
		
		private function finish():void{
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
			clearAll();
		}
		private function clearAll():void{
			loader = null;
			
			xmlCollection = null;
			xmlCollectionRow = null;
			xmlCollectionBasic = null;
			xml = null;
		}
		private function errorIn(message:*=''):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, message));
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