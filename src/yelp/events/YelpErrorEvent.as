package yelp.events{
	
	import flash.events.Event;
	
	public class YelpErrorEvent extends Event{
		
		public static const CLIENT_ERROR:String="clientError";
		public static const SERVER_ERROR:String="serverError";
		
		public var statusCode:int;
		public var message:String;
		
		public function YelpErrorEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,statusCode:int=0,message:String=""){
			super(type,bubbles,cancelable);
			this.statusCode=statusCode;
			this.message=message;
		}
		
		override public function clone():Event{
			return (new YelpErrorEvent(type,bubbles,cancelable,statusCode,message));
		}
		
		override public function toString():String{
			return formatToString("YelpErrorEvent","type","bubbles","cancelable","statusCode","message");
		}
		
	}
	
}