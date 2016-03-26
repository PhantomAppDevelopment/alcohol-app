package
{
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.motion.Fade;
	
	import screens.HomeScreen;
	import screens.LogScreen;
	import screens.InfoScreen;
	import screens.TestScreen;
	
	import servicesScreens.ServicesScreen;
	import servicesScreens.VenueDetailsScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var myNavigator:StackScreenNavigator;		
		private var NAVIGATOR_DATA:NavigatorData;
		
		private static const HOME_SCREEN:String = "homeScreen";
		private static const TEST_SCREEN:String = "testScreen";
		private static const SERVICES_SCREEN:String = "servicesScreen";
		private static const VENUE_DETAULS_SCREEN:String = "venueDetailScreen";
		private static const LOG_SCREEN:String = "logScreen";
		private static const INFO_SCREEN:String = "infoScreen";
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			this.NAVIGATOR_DATA = new NavigatorData();
			
			new CustomTheme();
			
			myNavigator = new StackScreenNavigator();
			myNavigator.pushTransition = Fade.createFadeOutTransition();
			myNavigator.popTransition = Fade.createFadeOutTransition();
			addChild(myNavigator);
			
			var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_TEST, TEST_SCREEN);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_SERVICES, SERVICES_SCREEN);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_LOG, LOG_SCREEN);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_INFO, INFO_SCREEN);
			myNavigator.addScreen(HOME_SCREEN, homeScreenItem);
			
			var testScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TestScreen);
			testScreenItem.addPopEvent(Event.COMPLETE);
			myNavigator.addScreen(TEST_SCREEN, testScreenItem);
			
			var servicesScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ServicesScreen);
			servicesScreenItem.addPopEvent(Event.COMPLETE);
			servicesScreenItem.properties.data = NAVIGATOR_DATA;
			servicesScreenItem.setScreenIDForPushEvent(ServicesScreen.GO_DETAILS, VENUE_DETAULS_SCREEN);
			myNavigator.addScreen(SERVICES_SCREEN, servicesScreenItem);
			
			var venueDetailsScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(VenueDetailsScreen);
			venueDetailsScreenItem.addPopEvent(Event.COMPLETE);
			venueDetailsScreenItem.properties.data = NAVIGATOR_DATA;
			myNavigator.addScreen(VENUE_DETAULS_SCREEN, venueDetailsScreenItem);
			
			var logScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(LogScreen);
			logScreenItem.addPopEvent(Event.COMPLETE);
			myNavigator.addScreen(LOG_SCREEN, logScreenItem);
			
			var infoScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(InfoScreen);
			infoScreenItem.addPopEvent(Event.COMPLETE);
			myNavigator.addScreen(INFO_SCREEN, infoScreenItem);
			
			
			myNavigator.rootScreenID = HOME_SCREEN;
		}
		
	}
}