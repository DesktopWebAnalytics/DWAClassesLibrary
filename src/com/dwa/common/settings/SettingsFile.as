/*
	DWAClassesLibrary

	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
	
	$Id: SettingsFile.as 348 2012-04-07 12:39:04Z benoit $
*/
package com.dwa.common.settings
{
	import com.dwa.common.icons.LoadIcons;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
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
	public class SettingsFile implements IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected var dispatcher:EventDispatcher;
		
		public var locale:String;
		
		/**
		 * Constructor.
		 * 
		 */
		public function SettingsFile()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		/**
		 * Check settings
		 *  
		 * @param version
		 * 
		 */
		public function checkSettings(version:String):void{	
			var settingsFile:File = File.applicationStorageDirectory.resolvePath("prefs/settings.xml");
			
			if(settingsFile.exists){
				readSettings(version);
			}else{
				createSettings(version);
			}
		}
		private function createSettings(version:String):void{
			var settingsXML:XML = new XML("<settings><version>" + version + "</version><locale></locale></settings>");
			
			var file:File = File.applicationStorageDirectory.resolvePath("prefs/settings.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += settingsXML.toXMLString();
			
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
			trace("create settings");
			
			finish();
		}
		private function readSettings(version:String):void{
			var file:File = File.applicationStorageDirectory.resolvePath("prefs/settings.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var settingsFile:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			var loc:String = settingsFile.locale.text();
			if(loc != ""){
				trace('locale setting found');
				locale = settingsFile.locale.text();
			}
			if(settingsFile.version.text() != version){
				trace("update setting version");
				clearCache();
				settingsFile.version = version;
				
				fileStream.open(file, FileMode.WRITE);
				var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
				outputString += settingsFile.toXMLString();
				
				fileStream.writeUTFBytes(outputString);
				fileStream.close();
			}
			
			finish();
		}
		private function clearCache():void{
			var delCache:LoadIcons = new LoadIcons();
			delCache.clearAllCache();
			
			delCache = null;
		}
		/**
		 * Save locale to settings
		 *  
		 * @param locale
		 * 
		 */
		public function saveLocaleToSettings(locale:String):void{
			var file:File = File.applicationStorageDirectory.resolvePath("prefs/settings.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var settingsFile:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			settingsFile.locale = locale;
			
			fileStream.open(file, FileMode.WRITE);
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += settingsFile.toXMLString();
			
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
			
			finish();
		}
		
		
		private function error(msg:String):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, msg));
		}
		private function finish():void{
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
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