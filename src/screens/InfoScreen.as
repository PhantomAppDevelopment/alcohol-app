package screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollText;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class InfoScreen extends PanelScreen
	{
		override protected function initialize():void
		{
			super.initialize();
			
			this.title = "Info";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var doneIcon:ImageLoader = new ImageLoader();
			doneIcon.source = "assets/icons/ic_done_white_36dp.png";
			doneIcon.width = doneIcon.height = 30;
			
			var doneButton:Button = new Button();
			doneButton.width = 50;
			doneButton.height = 50;
			doneButton.styleNameList.add("header-button");
			doneButton.defaultIcon = doneIcon;
			doneButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.rightItems = new <DisplayObject>[doneButton];
			
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		private function transitionComplete(event:Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
			
			var scrollText:ScrollText = new ScrollText();
			scrollText.layoutData = new AnchorLayoutData(10, 10, 10, 10, NaN, NaN);
			scrollText.text = "Phantom App Development - 2016\n"+
				"<a href='http://phantom.im/'>http://phantom.im/</a>\n\n"+
				"This application uses the following APIs and Libraries:\n\n"+
				"<a href='https://www.yelp.com/developers/documentation/v2/overview'>Yelp V2 API</a>\n"+
				"<a href='https://en.wikipedia.org/wiki/Blood_alcohol_content'>Wikipedia</a>\n"+
				"<a href='https://github.com/ZwickTheGreat/feathers-maps'>AS3 Starling/Feathers maps</a>\n"+
				"<a href='https://github.com/susisu/Twitter-for-AS3'>Twitter for AS3</a>";
			this.addChild(scrollText);
		}
		
		private function goBack():void
		{
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
		
	}
}