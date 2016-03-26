package yelp
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import yelp.events.YelpErrorEvent;
	import yelp.events.YelpRequestEvent;
	import yelp.utils.getOAuthParameters;
	import yelp.utils.makeAuthorizationHeader;
	import yelp.utils.makeOAuthSignature;
	import yelp.utils.mergeObjects;
	import yelp.utils.MultipartFormData;
	import yelp.utils.objectToSortedQueryString;
	
	public class YelpRequest extends EventDispatcher
	{
		
		private var _urlRequest:URLRequest;
		private var _urlLoader:URLLoader;
		
		private var _tokenSet:YelpTokenSet;
		private var _url:String;
		private var _method:String;
		private var _data:Object;
		private var _proxy:String;
		private var _response:String;
		private var _complete:Boolean;
		
		public function YelpRequest(tokenSet:YelpTokenSet, url:String, method:String = "GET", data:Object = null, proxy:String = null)
		{
			_tokenSet = tokenSet;
			_url = url;
			_method = method;
			_data = data;
			_proxy = proxy;
			_response = "";
			_complete = false;
			
			_urlRequest = new URLRequest();
			_urlRequest.method = _method;
			
			_urlLoader = new URLLoader();
			addListeners();
		}
		
		public function get tokenSet():YelpTokenSet
		{
			return _tokenSet;
		}
		public function set tokenSet(value:YelpTokenSet):void
		{
			_tokenSet=value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get method():String
		{
			return _method;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get proxy():String
		{
			return _proxy;
		}
		public function set proxy(value:String):void
		{
			_proxy = value;
		}
		
		public function get response():String
		{
			return _response;
		}
		
		public function get complete():Boolean
		{
			return _complete;
		}
		
		public function send():void
		{
			_response = "";
			_complete = false;
			
			var parameters:Object;
			var query:String;
			var base:String;
			var signature:String;
			
			if(_method.toUpperCase() == "GET")
			{
				if(_proxy == null)
				{
					_urlRequest.url = _url;
				}
				else
				{
					_urlRequest.url = _proxy;
				}
				parameters = mergeObjects(_data,getOAuthParameters(_tokenSet));
				//convert to query
				query = objectToSortedQueryString(parameters);
				//base to make signature
				base = _method.toUpperCase() + "&" + encodeURIComponent(_url) + "&" + encodeURIComponent(query);
				//base = "GET\\u0026" + encodeURIComponent(_url) + "\\u0026" + encodeURIComponent(query);
				//make signature
				
				signature = encodeURIComponent(makeOAuthSignature(_tokenSet, base));
				
				_urlRequest.data = query + "&oauth_signature=" + signature + (_proxy != null ? "&url=" + _url : "");
				
				_urlRequest.requestHeaders = [];
				_urlRequest.contentType = "application/x-www-form-urlencoded";
			}
			else
			{
				_urlRequest.url = _url;
				var oauthParameters:Object = getOAuthParameters(_tokenSet);
				if(_data is MultipartFormData)
				{
					query = objectToSortedQueryString(oauthParameters);
					base = _method.toUpperCase() + "&" + encodeURIComponent(_url) + "&" + encodeURIComponent(query);
					
					//trace(base);
					
					signature = encodeURIComponent(makeOAuthSignature(_tokenSet, base));
					oauthParameters["oauth_signature"] = signature;
					
					_urlRequest.data = _data.getByteArray();
					_urlRequest.requestHeaders = [makeAuthorizationHeader(oauthParameters)];
					_urlRequest.contentType = "multipart/form-data, boundary=" + _data.boundary;
				}
				else
				{
					parameters = mergeObjects(_data, oauthParameters);
					query = objectToSortedQueryString(parameters);
					base = _method.toUpperCase() + "&" + encodeURIComponent(_url) + "&" + encodeURIComponent(query);
					signature = encodeURIComponent(makeOAuthSignature(_tokenSet, base));
					oauthParameters["oauth_signature"] = signature;
					
					_urlRequest.data = objectToSortedQueryString(_data);
					_urlRequest.requestHeaders = [makeAuthorizationHeader(oauthParameters)];
					_urlRequest.contentType = "application/x-www-form-urlencoded";
				}
			}
			
			_urlLoader.load(_urlRequest);
		}
		
		private function addListeners():void
		{
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function removeListeners():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, onComplete);
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function onComplete(e:Event):void
		{
			removeListeners();
			
			_response = _urlLoader.data.toString();
			_complete = true;
			
			dispatchEvent(new YelpRequestEvent(YelpRequestEvent.COMPLETE));
		}
		
		private function onHTTPStatus(e:HTTPStatusEvent):void
		{
			if(e.status >= 400 && e.status < 500)
			{
				if(!dispatchEvent(new YelpErrorEvent(YelpErrorEvent.CLIENT_ERROR, false, true, e.status)))
				{
					_complete=true;
				}
			}
			else if(e.status >= 500)
			{
				if(!dispatchEvent(new YelpErrorEvent(YelpErrorEvent.SERVER_ERROR, false, true, e.status)))
				{
					_complete = true;
				}
			}
			else
			{
				_complete=true;
			}
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			if(!_complete)
			{
				removeListeners();
				_complete = true;
				
				dispatchEvent(e);
			}
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			removeListeners();
			_complete = true;
			
			dispatchEvent(e);
		}
		
	}
	
}