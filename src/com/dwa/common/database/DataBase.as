/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
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
		
		private var sqlConn:SQLConnection;
		private var sqlStmt:SQLStatement;
		
		private var selectedId:int;
		private var selectedPeriod:Number;
		private var selectedDay:Boolean;
		
		private var insertList:Array;
		
		private var orderByName:Boolean;
		
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
		 * Test if the database exists. If not, create it.
		 * 
		 */
		public function dataBaseExist():void{
			var db:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			if(db.exists){
				//finish();
				getAllWebsites(true);
			}else{
				createDB();
			}
		}
		
		/**
		 * Creation of the database 
		 * 
		 */
		private function createDB():void {
			sqlConn = new SQLConnection();
			sqlConn.addEventListener(SQLEvent.OPEN, openCreateHandler);
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorCreateHandler);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			sqlConn.open(dbFile);
		}
		private function clearCreateHandler():void{
			sqlConn.removeEventListener(SQLEvent.OPEN, openCreateHandler);
			sqlConn.removeEventListener(SQLErrorEvent.ERROR, errorCreateHandler);
			sqlConn = null;
		}
		private function errorCreateHandler(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			
			clearCreateHandler();
		}
		private function openCreateHandler(event:SQLEvent):void
		{
			trace("the database was created successfully");
			sqlStmt = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn;
			
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
			
			sqlStmt.text = sql;
			
			sqlStmt.addEventListener(SQLEvent.RESULT, createResult);
			sqlStmt.addEventListener(SQLErrorEvent.ERROR, createError);
			
			sqlStmt.execute();
		}
		private function clearCreate():void{
			sqlStmt.removeEventListener(SQLEvent.RESULT, createResult);
			sqlStmt.removeEventListener(SQLErrorEvent.ERROR, createError);
			sqlStmt = null;
		}
		private function createResult(event:SQLEvent):void
		{
			trace("Table created");
			
			// clear all eventListeners
			clearCreate();
			clearCreateHandler();
			
			insertDefaultProfile();
			//finish();
		}
				
		private function createError(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			
			// clear all eventListeners
			clearCreate();
			clearCreateHandler();
		}
		
		public function getCurrentDBFile():File{
			return File.applicationStorageDirectory.resolvePath(DATABASE);
		}
		/**
		 * Add default profile in the database 
		 * 
		 */
		private function insertDefaultProfile():void {
			sqlConn = new SQLConnection();
			sqlConn.addEventListener(SQLEvent.OPEN, openInsertDefaultHandler);
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorInsertDefaultHandler);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			sqlConn.open(dbFile);
		}
		private function clearInsertDefaultHandler():void{
			sqlConn.removeEventListener(SQLEvent.OPEN, openInsertDefaultHandler);
			sqlConn.removeEventListener(SQLErrorEvent.ERROR, errorInsertDefaultHandler);
			sqlConn = null;
		}
		private function errorInsertDefaultHandler(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			
			clearInsertDefaultHandler();
		}
		private function openInsertDefaultHandler(event:SQLEvent):void
		{
			sqlStmt = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn;
			
			var sql:String = "INSERT INTO main.websites (websiteId, websiteName, websiteUrl, websitePiwikAccess, websiteAuth, websiteIconUrl, websiteDay, websitePeriod, websiteCreated, websiteTimezone, websiteCurrency)" +
				"VALUES (7, 'Piwik Forums', 'http://forum.piwik.org', 'http://demo.piwik.org/', 'anonymous', '', 'true', 10, '1200096802136', 'UTC', 'USD')";
			
			trace (sql);			
			sqlStmt.text = sql;
			
			sqlStmt.addEventListener(SQLEvent.RESULT, insertDefaultResult);
			sqlStmt.addEventListener(SQLErrorEvent.ERROR, errorInsertDefaultResult);
			sqlStmt.execute();
		}
		private function clearInsertDefault():void{
			sqlStmt.removeEventListener(SQLEvent.RESULT, insertDefaultResult);
			sqlStmt.removeEventListener(SQLErrorEvent.ERROR, errorInsertDefaultResult);
			sqlStmt = null;
		}
		private function insertDefaultResult(event:SQLEvent):void {
			trace ("INSERT succeeded");
			
			// clear all eventListeners
			clearInsertDefault();
			clearInsertDefaultHandler();
			
			//finish();
			getAllWebsites(true);
		}
		private function errorInsertDefaultResult(event:SQLErrorEvent):void {
			trace ("Error insert sql: " + event.error);
			
			// clear all eventListeners
			clearInsertDefault();
			clearInsertDefaultHandler();
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
		public function insertProfiles(list:Array):void {
			insertList = list;
			
			sqlConn = new SQLConnection();
			sqlConn.addEventListener(SQLEvent.OPEN, openInsertHandler);
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorInsertHandler);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			sqlConn.open(dbFile);
		}
		private function clearInsertHandler():void{
			sqlConn.removeEventListener(SQLEvent.OPEN, openInsertHandler);
			sqlConn.removeEventListener(SQLErrorEvent.ERROR, errorInsertHandler);
		}
		private function errorInsertHandler(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			error(event.error.message + ' - Details: ' + event.error.details);
			
			clearInsertHandler();
			sqlConn = null;
		}
		private function openInsertHandler(event:SQLEvent):void
		{
			clearInsertHandler();
			
			// add all list
			sqlStmt = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn;
			
			var sql:String = "INSERT INTO main.websites (websiteId, websiteName, websiteUrl, websitePiwikAccess, websiteAuth, websiteIconUrl, websiteDay, websitePeriod, websiteCreated, websiteTimezone, websiteCurrency)" +
				"VALUES (@websiteId, @websiteName, @websiteUrl, @websitePiwikAccess, @websiteAuth, @websiteIconUrl, @websiteDay, @websitePeriod, @websiteCreated, @websiteTimezone, @websiteCurrency)";
			
			sqlStmt.text = sql;
			
			sqlConn.begin();
			
			for each(var profile:Profile in insertList){
				sqlStmt.parameters['@websiteId'] = profile.websiteId;
				sqlStmt.parameters['@websiteName'] = profile.websiteName;
				sqlStmt.parameters['@websiteUrl'] = profile.websiteUrl;
				sqlStmt.parameters['@websitePiwikAccess'] = profile.websitePiwikAccess;
				sqlStmt.parameters['@websiteAuth'] = profile.websiteAuth;
				sqlStmt.parameters['@websiteIconUrl'] = profile.websiteIconUrl;
				sqlStmt.parameters['@websiteDay'] = profile.websiteDay;
				sqlStmt.parameters['@websitePeriod'] = profile.websitePeriod;
				sqlStmt.parameters['@websiteCreated'] = profile.websiteCreated;
				sqlStmt.parameters['@websiteTimezone'] = profile.websiteTimezone;
				sqlStmt.parameters['@websiteCurrency'] = profile.websiteCurrency;
				
				sqlStmt.execute();
			}
			
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorInsertResult);
			sqlConn.addEventListener(SQLEvent.COMMIT, insertResult);
			sqlConn.commit();
		}
		private function clearInsert():void{
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorInsertResult);
			sqlConn.addEventListener(SQLEvent.COMMIT, insertResult);
			sqlConn = null;
		}
		private function insertResult(event:SQLEvent):void {
			trace ("INSERT succeeded");
			
			// clear eventListeners
			clearInsert();
			
			//finish();
			getAllWebsites(true);
		}
		private function errorInsertResult(event:SQLErrorEvent):void {
			trace ("Error insert sql: " + event.error);
			error(event.error.message + ' - Details: ' + event.error.details);
			
			// clear eventListeners
			clearInsert();
			clearInsertHandler();
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
			selectedId = id;
			selectedPeriod = period;
			selectedDay = day;
			
			sqlConn = new SQLConnection();
			sqlConn.addEventListener(SQLEvent.OPEN, openUpdateHandler);
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorUpdateHandler);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			sqlConn.openAsync(dbFile);
		}
		private function clearUpdateHandler():void{
			sqlConn.removeEventListener(SQLEvent.OPEN, openUpdateHandler);
			sqlConn.removeEventListener(SQLErrorEvent.ERROR, errorUpdateHandler);
			sqlConn = null;
		}
		private function errorUpdateHandler(event:SQLErrorEvent):void{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			
			clearUpdateHandler();
		}
		private function openUpdateHandler(event:SQLEvent):void{
			sqlStmt = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn;
			
			var sql:String = "UPDATE websites SET websiteDay = "+selectedDay+", websitePeriod = '"+selectedPeriod+"' WHERE dbId='" + selectedId + "'";
			
			sqlStmt.text = sql;
			sqlStmt.addEventListener(SQLEvent.RESULT, updateResult);
			sqlStmt.addEventListener(SQLErrorEvent.ERROR, updateError);
			sqlStmt.execute();
		}
		private function clearUpdate():void{
			sqlStmt.removeEventListener(SQLEvent.RESULT, updateResult);
			sqlStmt.removeEventListener(SQLErrorEvent.ERROR, updateError);
			sqlStmt = null;
		}
		private function updateResult(event:SQLEvent):void {
			trace ("Update sql succeeded");
			
			// clear eventListeners
			clearUpdate();
			clearUpdateHandler();
			
			//finish();
			getAllWebsites(true);
		}
		private function updateError(event:SQLErrorEvent):void {
			trace ("Update sql error: " + event.error);
			error(event.error.toString());
			
			// clear eventListeners
			clearUpdate();
			clearUpdateHandler();
		}
		/**
		 * Remove a profile
		 * 
		 * @param id database id
		 * 
		 */
		public function removeProfile(id:int):void {
			selectedId = id;
			
			sqlConn = new SQLConnection();
			sqlConn.addEventListener(SQLEvent.OPEN, openRemoveHandler);
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorRemoveHandler);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			sqlConn.openAsync(dbFile);
		}
		private function clearRemoveHandler():void{
			sqlConn.removeEventListener(SQLEvent.OPEN, openRemoveHandler);
			sqlConn.removeEventListener(SQLErrorEvent.ERROR, errorRemoveHandler);
			sqlConn = null;
		}
		private function errorRemoveHandler(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			clearRemoveHandler();
		}
			
		private function openRemoveHandler(event:SQLEvent):void {
			sqlStmt = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn;
			
			var sql:String = "DELETE FROM websites WHERE dbId='" + selectedId + "'";
			trace (sql);
			sqlStmt.text = sql;
			
			sqlStmt.addEventListener(SQLEvent.RESULT, removeResult);
			sqlStmt.addEventListener(SQLErrorEvent.ERROR, removeError);
			sqlStmt.execute();
		}
		private function clearRemove():void{
			sqlStmt.removeEventListener(SQLEvent.RESULT, removeResult);
			sqlStmt.removeEventListener(SQLErrorEvent.ERROR, removeError);
			sqlStmt = null;
		}
		private function removeResult(event:SQLEvent):void {
			trace ("Delete sql succeeded");
			
			// clear eventListeners
			clearRemove();
			clearRemoveHandler();
			
			//finish();
			getAllWebsites(true);
		}
		private function removeError(event:SQLErrorEvent):void {
			trace ("Delete sql error: " + event.error);
			error(event.error.toString());
			
			// clear eventListeners
			clearRemove();
			clearRemoveHandler();
		}
		
		/**
		 * 
		 * Get all websites stored in the database
		 * 
		 * 
		 * @param orderByName Sort result by name
		 * 
		 */
		public function getAllWebsites(askOrderByName:Boolean=false):void {
			orderByName = askOrderByName;
			
			sqlConn = new SQLConnection();
			sqlConn.addEventListener(SQLEvent.OPEN, openSelectHandler);
			sqlConn.addEventListener(SQLErrorEvent.ERROR, errorSelectHandler);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath(DATABASE);
			
			sqlConn.openAsync(dbFile, SQLMode.UPDATE);
		}
		private function clearSelectHandler():void{
			sqlConn.removeEventListener(SQLEvent.OPEN, openSelectHandler);
			sqlConn.removeEventListener(SQLErrorEvent.ERROR, errorSelectHandler);
			sqlConn = null;
		}
		private function errorSelectHandler(event:SQLErrorEvent):void
		{
			trace("Error message:", event.error.message);
			trace("Details:", event.error.details);
			clearSelectHandler();
		}
		private function openSelectHandler(event:SQLEvent):void
		{
			sqlStmt = new SQLStatement();
			sqlStmt.sqlConnection = sqlConn;
			
			var sql:String;
			if(orderByName){
				sql = "SELECT * FROM main.websites ORDER BY websiteName";
			}else{
				sql = "SELECT * FROM main.websites";
			}
			sqlStmt.text = sql;
			
			// set item class
			sqlStmt.itemClass = Profile;
			
			sqlStmt.addEventListener(SQLEvent.RESULT, selectResult);
			sqlStmt.addEventListener(SQLErrorEvent.ERROR, selectError);
			sqlStmt.execute();
		}
		private function clearSelect():void{
			sqlStmt.removeEventListener(SQLEvent.RESULT, selectResult);
			sqlStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			sqlStmt = null;
		}
		private function selectError(event:SQLErrorEvent):void {
			trace ("SELECT Error " + event.error);
			clearSelect();
			clearSelectHandler();
		}
		private function selectResult(event:SQLEvent):void {
			var result:SQLResult = sqlStmt.getResult();
			
			// clear eventlisteners
			clearSelect();
			clearSelectHandler();
			
			websitesList = new Array();
			
			if (result.data == null) {	
				finish();
			}else {
				
				websitesList = result.data;
				
				trace("list all websites");
				finish();
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