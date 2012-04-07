/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
	
	$Id: DataBase.as 348 2012-04-07 12:39:04Z benoit $
*/
package com.dwa.common.database
{
	import com.dwa.common.profile.Profile;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.system.System;
	
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
	public class DataBase implements IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected var dispatcher:EventDispatcher;
		
		private const DATABASE:String = "db_dwa.db";
		
		public var websitesList:Array;
		
		/**
		 * Constructor.
		 * 
		 */
		public function DataBase()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		/**
		 * 
		 * Test if the database exists if not create it.
		 * 
		 */
		public function dataBaseExist():void{
			var db:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			if(db.exists){
				finish();
			}else{
				createDB();
			}
		}
		
		/**
		 * Creation of the database 
		 * 
		 */
		private function createDB():void {
			var conn:SQLConnection = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler, false, 0, true);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler, false, 0, true);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			conn.open(dbFile);
			
			function openHandler(event:SQLEvent):void
			{
				trace("the database was created successfully");
				populateDB();
			}
			
			function errorHandler(event:SQLErrorEvent):void
			{
				trace("Error message:", event.error.message);
				trace("Details:", event.error.details);
			}
			function populateDB():void {
				var createStmt:SQLStatement = new SQLStatement();
				createStmt.sqlConnection = conn;
				
				var sql:String =
					"CREATE TABLE IF NOT EXISTS websites (" +
					"	dbId INTEGER PRIMARY KEY AUTOINCREMENT, " +
					"	websiteId INTEGER, " +
					"	websiteName TEXT, " +
					"	websiteUrl TEXT, " +
					"	websitePiwikAccess TEXT, " +
					"	websiteAuth TEXT, " +
					"	websiteIconUrl TEXT, " +
					"	websiteDay BOOLEAN, " +
					"	websitePeriod NUMBER, " +
					"	websiteCreated NUMBER, " +
					"	websiteTimezone TEXT, " +
					"	websiteCurrency TEXT " +
					")";
				
				createStmt.text = sql;
				
				createStmt.addEventListener(SQLEvent.RESULT, createResult, false, 0, true);
				createStmt.addEventListener(SQLErrorEvent.ERROR, createError, false, 0, true);
				
				createStmt.execute();
				
				function createResult(event:SQLEvent):void
				{
					trace("Table created");
					defaultProfile();
					//finish();
				}
				
				function createError(event:SQLErrorEvent):void
				{
					trace("Error message:", event.error.message);
					trace("Details:", event.error.details);
				}
			}
			
		}
		
		public function getCurrentDBFile():File{
			return File.applicationStorageDirectory.resolvePath(DATABASE);
		}
		/**
		 * Add default profile in the database 
		 * 
		 */
		private function defaultProfile():void {
			var conn:SQLConnection = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler, false, 0, true);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler, false, 0, true);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			conn.open(dbFile);
			
			function openHandler(event:SQLEvent):void
			{
				var insertStmt:SQLStatement = new SQLStatement();
				insertStmt.sqlConnection = conn;
				
				var sql:String = "INSERT INTO websites (websiteId, websiteName, websiteUrl, websitePiwikAccess, websiteAuth, websiteIconUrl, websiteDay, websitePeriod, websiteCreated, websiteTimezone, websiteCurrency)" +
					"VALUES (7, 'Piwik Forums', 'http://forum.piwik.org', 'http://demo.piwik.org/', 'anonymous', '', 'true', 10, '1200096802136', 'UTC', 'USD')";
				
				trace (sql);			
				insertStmt.text = sql;
				
				insertStmt.addEventListener(SQLEvent.RESULT, insertResult, false, 0, true);
				insertStmt.addEventListener(SQLErrorEvent.ERROR, errorResult, false, 0, true);
				insertStmt.execute();
				
				function insertResult(event:SQLEvent):void {
					
					trace ("INSERT succeeded");
					finish();
					
				}
				function errorResult(event:SQLErrorEvent):void {
					trace ("Error insert sql: " + event.error);
				}
			}
			
			function errorHandler(event:SQLErrorEvent):void
			{
				trace("Error message:", event.error.message);
				trace("Details:", event.error.details);
			}
		}
		private function escapeString(str:String):String{
			var pattern:RegExp = new RegExp("'", "sg");
			trace(pattern);
			return str.replace(pattern, "&quote;");
		}
		private function escapeStringDecode(str:String):String{
			var pattern:RegExp = /&quote;/g;
			return str.replace(pattern, "'");
		}
		/**
		 * Add profile in the database
		 * 
		 * @param list Array of profiles
		 * 
		 */
		public function addProfile(list:Array):void {
			var length:int = list.length;
			var index:int = 0;
			
			var conn:SQLConnection = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler, false, 0, true);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler, false, 0, true);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			conn.openAsync(dbFile);
			
			function openHandler(event:SQLEvent):void
			{
				insert();
			}
			function insert():void{
				var insertStmt:SQLStatement = new SQLStatement();
				insertStmt.sqlConnection = conn;
				
				var profile:Profile = list[index];
				
				var sql:String = "INSERT INTO websites (websiteId, websiteName, websiteUrl, websitePiwikAccess, websiteAuth, websiteIconUrl, websiteDay, websitePeriod, websiteCreated, websiteTimezone, websiteCurrency)" +
					"VALUES ('" + profile.websiteId + "', '" + escapeString(profile.websiteName) + "', '" + profile.websiteUrl + "', '" + profile.websitePiwikAccess + "', '" + profile.websiteAuth + "', '" + profile.websiteIconUrl + "', " + profile.websiteDay + ", '" + profile.websitePeriod + "', '" + profile.websiteCreated + "', '" + profile.websiteTimezone + "', '" + profile.websiteCurrency + "')";
				
				trace (sql);			
				insertStmt.text = sql;
				
				insertStmt.addEventListener(SQLEvent.RESULT, insertResult, false, 0, true);
				insertStmt.addEventListener(SQLErrorEvent.ERROR, errorResult, false, 0, true);
				insertStmt.execute();
				
				index++;
			}
			function insertResult(event:SQLEvent):void {
				trace ("INSERT succeeded");
				if(index < length){
					insert();
				}else{
					//finish();
					getAllWebsites(true);
				}
				
			}
			function errorResult(event:SQLErrorEvent):void {
				trace ("Error insert sql: " + event.error);
				error(event.error.message + ' - Details: ' + event.error.details);
			}
			function errorHandler(event:SQLErrorEvent):void
			{
				trace("Error message:", event.error.message);
				trace("Details:", event.error.details);
				error(event.error.message + ' - Details: ' + event.error.details);
			}
		}
		/**
		 * Update a profile
		 * 
		 * @param id database id
		 * @param period Number
		 * @param day Boolean
		 * 
		 */
		public function updateProfile(id:int, period:Number, day:Boolean):void{
			var conn:SQLConnection = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler, false, 0, true);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler, false, 0, true);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			conn.openAsync(dbFile);
			
			function openHandler(event:SQLEvent):void{
				var updateStmt:SQLStatement = new SQLStatement();
				updateStmt.sqlConnection = conn;
				
				var sql:String = "UPDATE websites SET websiteDay = "+day+", websitePeriod = '"+period+"' WHERE dbId='" + id + "'";
				
				updateStmt.text = sql;
				updateStmt.addEventListener(SQLEvent.RESULT, updateResult, false, 0, true);
				updateStmt.addEventListener(SQLErrorEvent.ERROR, updateError, false, 0, true);
				updateStmt.execute();
				
				function updateResult(event:SQLEvent):void {
					trace ("Update sql succeeded");
					//finish();
					getAllWebsites(true);
				}
				function updateError(event:SQLErrorEvent):void {
					trace ("Update sql error: " + event.error);
					error(event.error.toString());
				}
			}
			function errorHandler(event:SQLErrorEvent):void{
				trace("Error message:", event.error.message);
				trace("Details:", event.error.details);
			}
		}
		/**
		 * Remove a profile
		 * 
		 * @param id database id
		 * 
		 */
		public function removeProfile(id:int):void {
			var conn:SQLConnection = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler, false, 0, true);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler, false, 0, true);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			conn.openAsync(dbFile);
			
			function openHandler(event:SQLEvent):void
			{
				removeProfileDB();
			}
			
			function errorHandler(event:SQLErrorEvent):void
			{
				trace("Error message:", event.error.message);
				trace("Details:", event.error.details);
			}
			
			function removeProfileDB():void {
				var removeStmt:SQLStatement = new SQLStatement();
				removeStmt.sqlConnection = conn;
				
				var sql:String = "DELETE FROM websites WHERE dbId='" + id + "'";
				trace (sql);
				removeStmt.text = sql;
				removeStmt.addEventListener(SQLEvent.RESULT, removeResult, false, 0, true);
				removeStmt.addEventListener(SQLErrorEvent.ERROR, removeError, false, 0, true);
				removeStmt.execute();
				
				function removeResult(event:SQLEvent):void {
					trace ("Delete sql succeeded");
					//finish();
					getAllWebsites(true);
				}
				function removeError(event:SQLErrorEvent):void {
					trace ("Delete sql error: " + event.error);
					error(event.error.toString());
				}
				
			}
		}
		/**
		 * 
		 * Get all websites stored in the database
		 * 
		 * 
		 * @param orderByName Sort result by name
		 * 
		 */
		public function getAllWebsites(orderByName:Boolean=false):void {
			var conn:SQLConnection = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler, false, 0, true);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler, false, 0, true);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			conn.open(dbFile, SQLMode.UPDATE);
			
			function openHandler(event:SQLEvent):void
			{
				var selectStmt:SQLStatement = new SQLStatement();
				selectStmt.sqlConnection = conn;
				
				var sql:String;
				if(orderByName){
					sql = "SELECT * FROM websites ORDER BY websiteName";
				}else{
					sql = "SELECT * FROM websites";
				}
				selectStmt.text = sql;
				
				selectStmt.addEventListener(SQLEvent.RESULT, selectResult, false, 0, true);
				selectStmt.addEventListener(SQLErrorEvent.ERROR, selectError, false, 0, true);
				selectStmt.execute();
				
				function selectResult(event:SQLEvent):void {
					var result:SQLResult = selectStmt.getResult();
					
					websitesList = new Array();
					
					if (result.data == null) {	
						finish();
					}else {
						var numRows:int = result.data.length;
						
						for (var i:int=0; i<numRows;i++) {
							var profile:Profile = new Profile();
							var data:Object = result.data[i];
							profile.dbId = data.dbId;
							profile.websiteId = data.websiteId;
							profile.websiteName = escapeStringDecode(data.websiteName);
							profile.websiteUrl = data.websiteUrl;
							profile.websitePiwikAccess = data.websitePiwikAccess;
							profile.websiteAuth = data.websiteAuth;
							profile.websiteIconUrl = data.websiteIconUrl;
							profile.websiteDay = data.websiteDay;
							profile.websitePeriod = data.websitePeriod;
							profile.websiteCreated = data.websiteCreated;
							profile.websiteTimezone = data.websiteTimezone;
							profile.websiteCurrency = data.websiteCurrency;
							
							websitesList.push(profile);
							
						}
						trace("list all websites");
						finish();
					}
					
				}	 
				function selectError(event:SQLErrorEvent):void {
					trace ("SELECT Error " + event.error);
				}
			}
			
			function errorHandler(event:SQLErrorEvent):void
			{
				trace("Error message:", event.error.message);
				trace("Details:", event.error.details);
			}
		}
		/**
		 * 
		 * @param msg
		 * 
		 */
		private function error(msg:String):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, msg));
			clearAll();
		}
		private function finish():void{
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
			clearAll();
		}
		private function clearAll():void{
			System.gc();
		}
		
		//--
		//-- IEventDispatcher
		//--
		
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public function dispatchEvent( event:Event ):Boolean
		{
			return dispatcher.dispatchEvent( event );
		}
		
		public function hasEventListener( type:String ):Boolean
		{
			return dispatcher.hasEventListener( type );
		}
		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			dispatcher.removeEventListener( type, listener, useCapture );
		}
		
		public function willTrigger( type:String ):Boolean
		{
			return dispatcher.willTrigger( type );
		}
	}
}