package servicesScreens
{
	
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import cz.j4w.map.MapLayerOptions;
	import cz.j4w.map.MapOptions;
	import cz.j4w.map.geo.GeoMap;
	import cz.j4w.map.geo.Maps;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PanelScreen;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.DropShadowFilter;
	
	public class VenueDetailsScreen extends PanelScreen
	{
		
		private var geoMap:GeoMap;
				
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
			
			this.title = "Details";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var ratingsIcon:ImageLoader = new ImageLoader();
			ratingsIcon.source = "assets/icons/ic_stars_white_48pt_3x.png";
			ratingsIcon.width = ratingsIcon.height = 30;
			
			var ratingsButton:Button = new Button();
			ratingsButton.width = ratingsButton.height = 50;
			ratingsButton.defaultIcon = ratingsIcon;
			ratingsButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				navigateToURL(new URLRequest(String(_data.businessinfo.mobile_url)));
			});
			this.headerProperties.leftItems = new <DisplayObject>[ratingsButton];
						
			var doneIcon:ImageLoader = new ImageLoader();
			doneIcon.source = "assets/icons/ic_done_white_36dp.png";
			doneIcon.width = doneIcon.height = 30;
			
			var doneButton:Button = new Button();
			doneButton.width = doneButton.height = 50;
			doneButton.styleNameList.add("header-button");
			doneButton.defaultIcon = doneIcon;
			doneButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.rightItems = new <DisplayObject>[doneButton];
									
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		private function transitionComplete(event:Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		
			var mapOptions:MapOptions = new MapOptions();
			mapOptions.initialCenter = new Point(Number(this._data.businessinfo.location.coordinate.longitude), Number(this._data.businessinfo.location.coordinate.latitude));
			mapOptions.initialScale = 1 / 8;
			mapOptions.minimumScale = 1 / 64;
			mapOptions.maximumScale = 1 / 2;
			mapOptions.disableRotation = true;
			
			geoMap = new GeoMap(mapOptions);
			geoMap.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
			this.addChild(geoMap);
			
			var osMaps:MapLayerOptions = Maps.OSM;
			osMaps.notUsedZoomThreshold = 1;
			geoMap.addLayer("osMaps", osMaps);
			
			var myMarker:ImageLoader = new ImageLoader();
			myMarker.source = "assets/icons/ic_location_on_white_48dp.png";
			myMarker.width = myMarker.height = 50;
			myMarker.alignPivot(HorizontalAlign.CENTER, VerticalAlign.BOTTOM);
			myMarker.color = 0xBD0D04;
			myMarker.filter = new DropShadowFilter(4, 0.75, 0x000000);
			
			geoMap.addMarkerLongLat("marker", this._data.businessinfo.location.coordinate.longitude, this._data.businessinfo.location.coordinate.latitude, myMarker);
			
			var backgroundQuad:Quad = new Quad(3, 3, 0x000000);
			backgroundQuad.alpha = 0.65;
			
			var bottomGroup:LayoutGroup = new LayoutGroup();
			bottomGroup.layout = new AnchorLayout();
			bottomGroup.layoutData = new AnchorLayoutData(NaN, 10, 10, 10, NaN, NaN);
			bottomGroup.height = 110;
			bottomGroup.backgroundSkin = backgroundQuad;
			this.addChild(bottomGroup);
			
			var venueLabel:Label = new Label();
			venueLabel.text = this._data.businessinfo.name;
			venueLabel.layoutData = new AnchorLayoutData(15, 70, NaN, 15, NaN, NaN);
			bottomGroup.addChild(venueLabel);
			venueLabel.textRendererFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.styleProvider = null;
				renderer.elementFormat = new ElementFormat(new FontDescription("_sans"), 16, 0xFFFFFF);
				return renderer;
			}
			
			if(this._data.businessinfo.location.display_address != undefined)
			{
				var addressLabel:Label = new Label();
				addressLabel.text = this._data.businessinfo.location.display_address;
				addressLabel.layoutData = new AnchorLayoutData(40, 70, 10, 15, NaN, NaN);
				bottomGroup.addChild(addressLabel);
				addressLabel.textRendererProperties.wordWrap = true;
				addressLabel.textRendererFactory = function():ITextRenderer
				{
					var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
					renderer.styleProvider = null;
					renderer.elementFormat = new ElementFormat(new FontDescription("_sans"), 16, 0x00E8ED);
					renderer.leading = 7;
					return renderer;
				}			
			}
			
			if(this._data.businessinfo.phone != undefined)
			{
				var phoneIcon:ImageLoader = new ImageLoader();
				phoneIcon.source = "assets/icons/ic_local_phone_white_36dp.png";
				phoneIcon.width = phoneIcon.height = 50;
				phoneIcon.color = 0x00E8ED;
				
				var phoneButton:Button = new Button();
				phoneButton.addEventListener(starling.events.Event.TRIGGERED, function():void
				{
					navigateToURL(new URLRequest("tel:"+_data.businessinfo.phone));
				});
				phoneButton.defaultIcon = phoneIcon;
				phoneButton.width = phoneButton.height = 50;
				phoneButton.layoutData = new AnchorLayoutData(10, 15, 10, NaN, NaN);
				bottomGroup.addChild(phoneButton);
			}
		}
		
				
		private function goBack():void
		{
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
		
	}
}