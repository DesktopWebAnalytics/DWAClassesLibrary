/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
*/
package com.dwa.common.profile
{
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
	
	[Bindable]
	public class Profile
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _dbId:int;
		private var _websiteId:int;
		private var _websiteName:String;
		private var _websiteUrl:String;
		private var _websitePiwikAccess:String;
		private var _websiteAuth:String;
		private var _websiteIconUrl:String;
		private var _websiteDay:Boolean;
		private var _websitePeriod:Number;
		private var _websiteCreated:Number;
		private var _websiteTimezone:String;
		private var _websiteCurrency:String;
		
		public var selected:Boolean;
		
		/**
		 * Constructor.
		 * 
		 */
		public function Profile()
		{
			//trace("init profile");
		}
		
		public function get dbId():int
		{
			return _dbId;
		}

		public function set dbId(value:int):void
		{
			_dbId = value;
		}

		public function get websiteId():int
		{
			return _websiteId;
		}

		public function set websiteId(value:int):void
		{
			_websiteId = value;
		}

		public function get websiteName():String
		{
			return _websiteName;
		}

		public function set websiteName(value:String):void
		{
			// use escapeStringDecode for old entries in database
			_websiteName = escapeStringDecode(value);
		}

		public function get websiteUrl():String
		{
			return _websiteUrl;
		}

		public function set websiteUrl(value:String):void
		{
			_websiteUrl = value;
		}

		public function get websitePiwikAccess():String
		{
			return _websitePiwikAccess;
		}

		public function set websitePiwikAccess(value:String):void
		{
			_websitePiwikAccess = value;
		}

		public function get websiteAuth():String
		{
			return _websiteAuth;
		}

		public function set websiteAuth(value:String):void
		{
			_websiteAuth = value;
		}

		public function get websiteIconUrl():String
		{
			return _websiteIconUrl;
		}

		public function set websiteIconUrl(value:String):void
		{
			_websiteIconUrl = value;
		}

		public function get websiteDay():Boolean
		{
			return _websiteDay;
		}

		public function set websiteDay(value:Boolean):void
		{
			_websiteDay = value;
		}

		public function get websitePeriod():Number
		{
			return _websitePeriod;
		}

		public function set websitePeriod(value:Number):void
		{
			_websitePeriod = value;
		}

		public function get websiteCreated():Number
		{
			return _websiteCreated;
		}

		public function set websiteCreated(value:Number):void
		{
			_websiteCreated = value;
		}

		public function get websiteTimezone():String
		{
			return _websiteTimezone;
		}

		public function set websiteTimezone(value:String):void
		{
			_websiteTimezone = value;
		}

		public function get websiteCurrency():String
		{
			return _websiteCurrency;
		}

		public function set websiteCurrency(value:String):void
		{
			_websiteCurrency = value;
		}
		
		private function escapeStringDecode(str:String):String{
			var pattern:RegExp = /&quote;/g;
			return str.replace(pattern, "'");
		}

		public function toString():String
		{
			return "[Profile dbId="+dbId+" websiteId="+websiteId+" websiteName="+websiteName+" websiteUrl="+websiteUrl+" websitePiwikAccess="+websitePiwikAccess+" websiteAuth="+websiteAuth+" websiteIconUrl="+websiteIconUrl+" websiteDay="+websiteDay+" websitePeriod="+websitePeriod+" websiteCreated="+websiteCreated+" websiteTimezone="+websiteTimezone+" websiteCurrency="+websiteCurrency+" ]";
		}
		
		
	}
}