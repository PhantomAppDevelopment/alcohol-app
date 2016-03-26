package yelp.events{
	
	import flash.events.Event;
	
	public class YelpRequestEvent extends Event{
		
		public static const COMPLETE:String="complete";
		
		public function YelpRequestEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false){
			super(type,bubbles,cancelable);
		}
		
		override public function clone():Event{
			return (new YelpRequestEvent(type,bubbles,cancelable));
		}
		
		override public function toString():String{
			return formatToString("YelpRequestEvent","type","bubbles","cancelable");
		}
		
	}
	
}