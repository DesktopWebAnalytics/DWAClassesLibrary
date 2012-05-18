/*
	DWAClassesLibrary
	
	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
*/
package com.dwa.common.icons
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
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
	public class LoadIcons implements IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected var dispatcher:EventDispatcher;
		
		protected var storageDir:File = File.applicationStorageDirectory;
		
		private const DIR:String = "cache/";
		
		public var path:String;
		
		private var file:File;
		
		/**
		 * Constructor.
		 * 
		 */
		public function LoadIcons()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		/**
		 * Store icon on the local storage
		 * 
		 * @param url url of the icon
		 * 
		 */
		public function cache(url:String):void{
			
			var icon:String = url.substring(url.lastIndexOf('/')+1);
			
			file = storageDir.resolvePath(DIR+icon);
			
			path = file.url;
			
			if(!file.exists){
				//trace("file don't exist");
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, result);
				loader.addEventListener(IOErrorEvent.IO_ERROR, error);
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.load(new URLRequest(url));
				
			}else{
				//trace("file exist");
				finish();
			}
		}
		private function error(event:IOErrorEvent):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text));
		}
		private function result(event:Event):void{
			var data:ByteArray = event.currentTarget.data as ByteArray;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			/*fileStream.position = 0;
			fileStream.endian = data.endian;
			fileStream.objectEncoding = data.objectEncoding;*/
			fileStream.writeBytes(data);
			fileStream.close();
			
			//trace("file saved");
			
			finish();
		}
		
		/**
		 * 
		 * 
		 */
		public function clearAllCache():void{
			file = storageDir.resolvePath(DIR);
			if(file.exists){
				file.deleteDirectory(true);
			}
		}
		
		private function finish():void{
			//trace("cache event");
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
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