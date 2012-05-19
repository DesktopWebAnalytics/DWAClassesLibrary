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
		
		public var dbId:int;
		public var websiteId:int;
		public var websiteName:String;
		public var websiteUrl:String;
		public var websitePiwikAccess:String;
		public var websiteAuth:String;
		public var websiteIconUrl:String;
		public var websiteDay:Boolean;
		public var websitePeriod:Number;
		public var websiteCreated:Number;
		public var websiteTimezone:String;
		public var websiteCurrency:String;
		
		public var selected:Boolean;
		
		/**
		 * Constructor.
		 * 
		 */
		public function Profile()
		{
			trace("init profile");
		}

	}
}