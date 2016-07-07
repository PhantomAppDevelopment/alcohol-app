package servicesScreens
{
	import flash.events.GeolocationEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.sensors.Geolocation;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	import yelp.YelpRequest;
	import yelp.YelpTokenSet;
	import yelp.events.YelpRequestEvent;
	
	public class ServicesScreen extends PanelScreen
	{
		//Copy your own keys from the Yelp developer portal.
		private static const CONSUMER_KEY:String = "";
		private static const CONSUMER_SECRET:String = "";
		private static const TOKEN:String = "";
		private static const TOKEN_SECRET:String = "";
		
		private var tokenSet:YelpTokenSet;
		private var yelpLoader:YelpRequest;
		private var geo:Geolocation;
		
		public static const GO_DETAILS:String = "goVenueDetails";
		
		
		private var myBusy:ImageLoader;
		private var alert:Alert;
		private var mainTabBar:TabBar;
		private var businessList:List;
		private var businessLoader:URLLoader;
		private var searchTerm:String;	
		private var myLL:String;
		
		protected var _data:NavigatorData;
		
		public function get data():NavigatorData
		{
			return this._data;
		}		
		
		public function set data(value:NavigatorData):void
		{
			this._data = value;	
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
				
			var downloadIcon:ImageLoader = new ImageLoader();
			downloadIcon.source = "assets/icons/ic_get_app_white_36dp.png";
			downloadIcon.width = downloadIcon.height = 30;
			
			var downloadButton:Button = new Button();
			downloadButton.width = downloadButton.height = 50;
			downloadButton.defaultIcon = downloadIcon;
			downloadButton.styleNameList.add("header-button");
			downloadButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				navigateToURL(new URLRequest("https://play.google.com/store/apps/details?id=com.yelp.android"));
			});
			
			this.headerProperties.leftItems = new <DisplayObject>[downloadButton];
						
			var yelpLogo:ImageLoader = new ImageLoader();
			yelpLogo.source = "assets/icons/yelp_logo_large.png";
			yelpLogo.height = 30;
			yelpLogo.minWidth = 45;
			this.headerProperties.centerItems = new <DisplayObject>[yelpLogo];
			
			var doneIcon:ImageLoader = new ImageLoader();
			doneIcon.source = "assets/icons/ic_done_white_36dp.png";
			doneIcon.width = doneIcon.height = 30;
			
			var doneButton:Button = new Button();
			doneButton.width = doneButton.height = 50;
			doneButton.styleNameList.add("header-button");
			doneButton.defaultIcon = doneIcon;
			doneButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.rightItems = new <DisplayObject>[doneButton];
			
			var barsIcon:ImageLoader = new ImageLoader();
			barsIcon.width = barsIcon.height = 30;
			barsIcon.source = "assets/icons/ic_local_bar_white_48dp.png";
			
			var taxiIcon:ImageLoader = new ImageLoader();
			taxiIcon.width = taxiIcon.height = 30;
			taxiIcon.source = "assets/icons/ic_local_taxi_white_48dp.png";
			
			var hotelIcon:ImageLoader = new ImageLoader();
			hotelIcon.width = hotelIcon.height = 30;
			hotelIcon.source = "assets/icons/ic_local_hotel_white_48dp.png";
			
			var hospitalIcon:ImageLoader = new ImageLoader();
			hospitalIcon.width = hospitalIcon.height = 30;
			hospitalIcon.source = "assets/icons/ic_local_hospital_white_36dp.png";
			
			mainTabBar = new TabBar();
			mainTabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0, NaN, NaN);
			mainTabBar.height = 50;
			mainTabBar.dataProvider = new ListCollection(
				[
					{label:"", data:"bars", defaultIcon:barsIcon},
					{label:"", data:"taxis", defaultIcon:taxiIcon},
					{label:"", data:"hotels", defaultIcon:hotelIcon},
					{label:"", data:"hospitals", defaultIcon:hospitalIcon}				
				]);
			this.addChild(mainTabBar);
			
			businessList = new List();
			businessList.addEventListener(starling.events.Event.CHANGE, listHandler);
			businessList.layoutData = new AnchorLayoutData(50, 0, 0, 0, NaN, NaN);
			businessList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;
				
				renderer.labelFunction = function(item:Object):String
				{					
					return item.name + "\n" + item.location.address;
				}
													
				renderer.iconLoaderFactory = function():ImageLoader
				{
					var image:ImageLoader = new ImageLoader();
					image.width = image.height = 50;
					return image;
				}
					
				renderer.iconSourceFunction = function(item:Object):String
				{
					return 	item.image_url;
				}
				
				renderer.accessoryFunction = function(item:Object):Button
				{
					var image:ImageLoader = new ImageLoader();
					image.source = item.rating_img_url_large;
					image.width = 70;
					image.height = 30;
					image.paddingRight = 10;
					
					var button:Button = new Button();
					button.defaultIcon = image;
					button.iconPosition = Button.ICON_POSITION_TOP;
					button.label = item.review_count + " reviews";
					button.labelFactory = function():ITextRenderer
					{
						var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
						renderer.elementFormat = new ElementFormat(new FontDescription("_sans"), 12, 0xFFFFFF);
						return renderer;
					}
					
					return button;
				}
								
				return renderer;
			}
			
			this.addChild(businessList);
					
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		
		private function transitionComplete(event:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
						
			myBusy = new ImageLoader();
			myBusy.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			myBusy.source = "assets/icons/spinner.png";
			myBusy.width = myBusy.height = 50;
			myBusy.visible = false;
			myBusy.pivotX = myBusy.width  * 0.5;
			myBusy.pivotY = myBusy.height * 0.5;
			this.addChild(myBusy);
			
			var busyTween:Tween = new Tween(myBusy, 5.0);
			busyTween.repeatCount = 0;
			busyTween.animate("rotation", -45);
			Starling.juggler.add(busyTween);
			
			tokenSet = new YelpTokenSet(CONSUMER_KEY, CONSUMER_SECRET, TOKEN, TOKEN_SECRET);
			mainTabBar.selectedIndex = 0;
			mainTabBar.addEventListener(starling.events.Event.CHANGE, searchBusiness);
			
			Alert.overlayFactory = function():DisplayObject
			{
				var quad:Quad = new Quad(3, 3, 0x000000);
				quad.alpha = .5
				return quad;
			}
						
			if (Geolocation.isSupported) { 
				geo = new Geolocation(); 
				
				if (!geo.muted){
					myBusy.visible = true;
					geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler); 
				} else {
					alert = Alert.show("Your GPS is turned off, please turn it ON and try again.", "Error", new ListCollection([{label:"OK", triggered:goBack}]));
				}				
				geo.addEventListener(StatusEvent.STATUS, geoStatusHandler);
			} else {
				alert = Alert.show("GPS is not supported on your device.", "Error", new ListCollection([{label:"OK", triggered:goBack}]));
			}			

		}
		
		private function geoUpdateHandler(event:GeolocationEvent):void 
		{			
			var lat:String = event.latitude.toString();
			var lon:String = event.longitude.toString();
			
			geo.removeEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
			geo = null;			
			
			myLL = lat+","+lon;
			searchBusiness();
		} 
		
		private function geoStatusHandler(event:StatusEvent):void 
		{ 
			if (geo.muted) {
				geo.removeEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
			} else {
				geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
			}
		}
		
		private function searchBusiness():void
		{
			myBusy.visible = true;
			
			var myObject:Object = new Object();				
			//myObject.location = escape("san Francisco");
			
			/*
			If you want to use an address instead of GPS coordinates uncomment the previous line and comment the next line.
			Remember to escape() the address or else it won't be successfully sent.
			This Yelp API implementation was adapted from: https://github.com/susisu/Twitter-for-AS3
			*/
			
			myObject.ll = escape(myLL);
			myObject.radius_filter = 20000;
			myObject.category_filter = mainTabBar.selectedItem.data;
			
			yelpLoader = new YelpRequest(tokenSet, "https://api.yelp.com/v2/search/", "GET", myObject);
			yelpLoader.addEventListener(YelpRequestEvent.COMPLETE, yelpResponse);
			yelpLoader.send();
		}
		
		private function listHandler(event:starling.events.Event):void
		{			
			this._data.businessinfo = businessList.selectedItem;
			this.dispatchEventWith(GO_DETAILS);
		}
		
		private function yelpResponse(event:YelpRequestEvent):void
		{
			myBusy.visible = false;
			
			var rawData:Object = JSON.parse(String(yelpLoader.response));			
			businessList.dataProvider = new ListCollection(rawData.businesses as Array);
		}
		
		private function goBack():void
		{
			if (geo){
				geo.removeEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
				geo = null;
			}
			
			if(alert){
				alert.removeFromParent(true);
			}
			
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
	}
}