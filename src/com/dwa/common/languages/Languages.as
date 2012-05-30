/*
	DWAClassesLibrary
	
	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/lgpl-3.0-standalone.html LGPL v3 or later
*/
package com.dwa.common.languages
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name='complete', type='flash.events.Event')]
	[Event(name='error', type='flash.events.ErrorEvent')]
	
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
	public class Languages implements IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected var dispatcher:EventDispatcher;
		
		private var locales:Array = new Array(
			{label: "አማርኛ", locale: "am_ET", short: "am", direction: "ltr"},
			{label: "العربية", locale: "ar_EG", short: "ar", direction: "rtl"},
			{label: "Беларуская", locale: "be_BY", short: "be", direction: "ltr"},
			{label: "Български", locale: "bg_BG", short: "bg", direction: "ltr"},
			{label: "Català", locale: "ca_ES", short: "ca", direction: "ltr"},
			{label: "Česky", locale: "cs_CZ", short: "cs", direction: "ltr"},
			{label: "Dansk", locale: "da_DK", short: "da", direction: "ltr"},
			{label: "Deutsch", locale: "de_DE", short: "de", direction: "ltr"},
			{label: "Ελληνικά", locale: "el_GR", short: "el", direction: "ltr"},
			{label: "English", locale: "en_US", short: "en", direction: "ltr"},
			{label: "Español", locale: "es_ES", short: "es", direction: "ltr"},
			{label: "Eesti keel", locale: "et_ET", short: "et", direction: "ltr"},
			{label: "Euskara", locale: "eu_ES", short: "eu", direction: "ltr"},
			{label: "Suomi", locale: "fi_FI", short: "fi", direction: "ltr"},
			{label: "Français", locale: "fr_FR", short: "fr", direction: "ltr"},
			{label: "Galego", locale: "gl_ES", short: "gl", direction: "ltr"},
			{label: "עברית", locale: "he_IL", short: "he", direction: "rtl"},
			{label: "Magyar", locale: "hu_HU", short: "hu", direction: "ltr"},
			{label: "Bahasa Indonesia", locale: "id_ID", short: "id", direction: "ltr"},
			{label: "Íslenska", locale: "is_IS", short: "is", direction: "ltr"},
			{label: "Italiano", locale: "it_IT", short: "it", direction: "ltr"},
			{label: "日本語", locale: "ja_JP", short: "ja", direction: "ltr"},
			{label: "ქართული", locale: "ka_GE", short: "ka", direction: "ltr"},
			{label: "한국어", locale: "ko_KR", short: "ko", direction: "ltr"},
			{label: "Lietuvių", locale: "lt_LT", short: "lt", direction: "ltr"},
			{label: "Latviešu", locale: "lv_LV", short: "lv", direction: "ltr"},
			{label: "Norsk (bokmål)", locale: "nb_NO", short: "nb", direction: "ltr"},
			{label: "Nederlands", locale: "nl_NL", short: "nl", direction: "ltr"},
			{label: "Nynorsk", locale: "nn_NO", short: "nn", direction: "ltr"},
			{label: "Polski", locale: "pl_PL", short: "pl", direction: "ltr"},
			{label: "Português brasileiro", locale: "pt_BR", short: "pt-br", direction: "ltr"},
			{label: "Português", locale: "pt_PT", short: "pt", direction: "ltr"},
			{label: "Română", locale: "ro_RO", short: "ro", direction: "ltr"},
			{label: "Русский", locale: "ru_RU", short: "ru", direction: "ltr"},
			{label: "Slovensky", locale: "sk_SK", short: "sk", direction: "ltr"},
			{label: "Slovenian", locale: "sl_SI", short: "sl", direction: "ltr"},
			{label: "Shqip", locale: "sq_AL", short: "sq", direction: "ltr"},
			{label: "Srpski", locale: "sr_RS", short: "sr", direction: "ltr"},
			{label: "Svenska", locale: "sv_SE", short: "sv", direction: "ltr"},
			{label: "తెలుగు", locale: "te_IN", short: "te", direction: "ltr"},
			{label: "ไทย", locale: "th_TH", short: "th", direction: "ltr"},
			{label: "Türkçe", locale: "tr_TR", short: "tr", direction: "ltr"},
			{label: "Українська", locale: "uk_UA", short: "uk", direction: "ltr"},
			{label: "简体中文", locale: "zh_CN", short: "zn-cn", direction: "ltr"},
			{label: "正體中文", locale: "zh_TW", short: "zh-tw", direction: "ltr"}
		);
		
		/**
		 * Constructor.
		 * 
		 */
		public function Languages()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		/**
		 * Get all available locales
		 * 
		 * @return Array of locales
		 * 
		 */
		public function getAvailableLocales():Array{
			return locales;
		}
		
		/**
		 * Check if the locale exists
		 * 
		 * @param locale
		 * @return Boolean
		 * 
		 */
		public function checkLanguage(locale:String):Boolean{
			var find:Boolean = false;
			for each(var loc:Object in locales){
				if(loc.locale == locale){
					find = true;
					break;
				}
			}
			
			return find;
		}
		
		/**
		 * Get the locale.
		 * 
		 * Test if the locale is available; if not, test if the localeSystem is availble; if not, get "en" locale
		 * 
		 * @param locale Locale wanted
		 * @param localeSystem Locale system
		 * @return Locale object
		 * 
		 */
		public function getLocale(locale:String, localeSystem:String):Object{
			var localeOb:Object;
			
			if(locale && checkLanguage(locale)){
				for each(var l:Object in locales){
					if(l.locale == locale){
						localeOb = l;
						break;
					}
				}
			}else if(checkLanguage(localeSystem)){
				for each(var ls:Object in locales){
					if(ls.locale == localeSystem){
						localeOb = ls;
						break;
					}
				}
			}else{
				localeOb = {label: "English", locale: "en_US", short: "en", direction: "ltr"};
			}
			return localeOb;
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