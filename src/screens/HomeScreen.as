package screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class HomeScreen extends PanelScreen
	{
		public static const GO_TEST:String = "goTest";
		public static const GO_SERVICES:String = "goServices";
		public static const GO_LOG:String = "goLog";
		public static const GO_INFO:String = "goSettings";
				
		override protected function initialize():void
		{
			super.initialize();
			
			this.title = "Drinking Pal";
			this.layout = new VerticalLayout();
					
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		private function transitionComplete(event:Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		
			var topGroup:LayoutGroup = new LayoutGroup();
			topGroup.layout = new HorizontalLayout();
			topGroup.layoutData = new VerticalLayoutData(100, 50);
			this.addChild(topGroup);
			
			
			var bottomGroup:LayoutGroup = new LayoutGroup();
			bottomGroup.layout = new HorizontalLayout();
			bottomGroup.layoutData = new VerticalLayoutData(100, 50);
			this.addChild(bottomGroup);
			
			var alcoholTestIcon:ImageLoader = new ImageLoader();
			alcoholTestIcon.source = "assets/icons/ic_local_bar_white_48dp.png";
			alcoholTestIcon.width = 100;
			alcoholTestIcon.height = 100;
			alcoholTestIcon.color = 0x00E8ED;
			
			var alcoholTestButton:Button = new Button();
			alcoholTestButton.layoutData = new HorizontalLayoutData(50, 100);
			alcoholTestButton.addEventListener(Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_TEST);
			});
			alcoholTestButton.alpha = 0;
			alcoholTestButton.defaultIcon = alcoholTestIcon;
			alcoholTestButton.label = "Take Test";
			alcoholTestButton.styleNameList.add("home-button");
			topGroup.addChild(alcoholTestButton);
						
			var servicesIcon:ImageLoader = new ImageLoader();
			servicesIcon.source = "assets/icons/ic_location_on_white_48dp.png";
			servicesIcon.width = servicesIcon.height = 100;
			servicesIcon.color = 0x00E8ED;
			
			var servicesButton:Button = new Button();
			servicesButton.layoutData = new HorizontalLayoutData(50, 100);
			servicesButton.addEventListener(Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_SERVICES);
			});
			servicesButton.alpha = 0;
			servicesButton.defaultIcon = servicesIcon;
			servicesButton.label = "Services";
			servicesButton.styleNameList.add("home-button");
			topGroup.addChild(servicesButton);
									
			var logIcon:ImageLoader = new ImageLoader();
			logIcon.source = "assets/icons/ic_content_paste_white_48dp.png";
			logIcon.width = logIcon.height = 100;
			logIcon.color = 0x00E8ED;
			
			var logButton:Button = new Button();
			logButton.layoutData = new HorizontalLayoutData(50, 100);
			logButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_LOG);
			});
			logButton.alpha = 0;
			logButton.defaultIcon = logIcon;
			logButton.label = "Log";
			logButton.styleNameList.add("home-button");
			bottomGroup.addChild(logButton);

			var infoIcon:ImageLoader = new ImageLoader();
			infoIcon.source = "assets/icons/ic_info_outline_white_48dp.png";
			infoIcon.width = infoIcon.height = 100;
			infoIcon.color = 0x00E8ED;
			
			var infoButton:Button = new Button();
			infoButton.layoutData = new HorizontalLayoutData(50, 100);
			infoButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				dispatchEventWith(GO_INFO);
			});
			infoButton.alpha = 0;
			infoButton.defaultIcon = infoIcon;
			infoButton.label = "Info";
			infoButton.styleNameList.add("home-button");
			bottomGroup.addChild(infoButton);

			
			var alcoholTestTween:Tween = new Tween(alcoholTestButton, 0.3);			
			var servicesTween:Tween = new Tween(servicesButton, 0.3);
			var logTween:Tween = new Tween(logButton, 0.3);
			var settingsTween:Tween = new Tween(infoButton, 0.3);
			
			alcoholTestTween.onComplete = function():void
			{
				servicesTween.fadeTo(1);
				Starling.juggler.add(servicesTween);
			}

			alcoholTestTween.fadeTo(1);
			Starling.juggler.add(alcoholTestTween);
			
			servicesTween.onComplete = function():void
			{
				logTween.fadeTo(1);
				Starling.juggler.add(logTween);
			}
				
			logTween.onComplete = function():void
			{
				settingsTween.fadeTo(1);
				Starling.juggler.add(settingsTween);
			}
			
			
			
		}
	}
}