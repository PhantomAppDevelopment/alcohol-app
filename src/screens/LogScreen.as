package screens
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class LogScreen extends PanelScreen
	{
		private var alert:Alert;
		private var logList:List;
		private var myStatement:SQLStatement;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this.title = "Log";
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			var doneIcon:ImageLoader = new ImageLoader();
			doneIcon.source = "assets/icons/ic_done_white_36dp.png";
			doneIcon.width = 30;
			doneIcon.height = 30;
			
			var doneButton:Button = new Button();
			doneButton.width = 50;
			doneButton.height = 50;
			doneButton.styleNameList.add("header-button");
			doneButton.defaultIcon = doneIcon;
			doneButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.rightItems = new <DisplayObject>[doneButton];
			
			logList = new List();
			logList.layoutData = new AnchorLayoutData(0, 0, 0, 0, NaN, NaN);
			this.addChild(logList);			
			
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}
		
		
		private function transitionComplete(event:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
				
			Alert.overlayFactory = function():DisplayObject
			{
				var quad:Quad = new Quad(3, 3, 0x000000);
				quad.alpha = .5
				return quad;
			}
			
			logList.itemRendererFactory = function():DefaultListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;
				
				renderer.labelFunction = function(item:Object):String
				{
					return item.alcohol + "% - " + item.quantity + " drinks in " + item.period + " hour(s)" + "\n" + new Date(item.date*1).toLocaleString();
				};
				
				renderer.iconLoaderFactory = function():ImageLoader
				{
					var icon:ImageLoader = new ImageLoader();
					icon.width = icon.height = 40;
					return icon;
				}
				
				renderer.iconSourceFunction = function(item:Object):String
				{
					if(item.gender == "male"){
						return "assets/icons/man.png";
					} else {
						return "assets/icons/woman.png";
					}					
				}
				
				renderer.accessoryFunction = function(item:Object):ImageLoader
				{
					var image:ImageLoader = new ImageLoader();
					image.source = "assets/icons/warning_small.png";
					image.width = image.height = 40;
					image.paddingRight = 10;
					image.color = item.color;
					
					return image;
				}
				
				return renderer;
			}
			
			loadData();
		}
		
		private function listHandler(event:starling.events.Event):void
		{
			
			var description:String = "";
			
			if(logList.selectedItem.alcohol >= 0.001 && logList.selectedItem.alcohol <= 0.029){
;				description = "Average individual appears normal.";
			} else if(logList.selectedItem.alcohol >= 0.030 && logList.selectedItem.alcohol <= 0.059){
				description = "Mild euphoria. Relaxation. Joyousness. Talkativeness. Decreased inhibition";
			} else if(logList.selectedItem.alcohol >= 0.060 && logList.selectedItem.alcohol <= 0.099){
				description = "Blunted feelings. Reduced sensitivity to pain. Euphoria. Disinhibition. Extroversion";
			} else if(logList.selectedItem.alcohol >= 0.100 && logList.selectedItem.alcohol <= 0.199){
				description = "Over-expression. Boisterousness. Possibility of nausea and vomiting";
			} else if(logList.selectedItem.alcohol >= 0.200 && logList.selectedItem.alcohol <= 0.299){
				description = "Nausea. Vomiting. Emotional swings. Anger or sadness. Partial loss of understanding. Impaired sensations. Decreased libido. Possibility of stupor";
			} else if(logList.selectedItem.alcohol >= 0.300 && logList.selectedItem.alcohol <= 0.399){
				description = "Stupor. Central nervous system depression. Loss of understanding. Lapses in and out of consciousness. Low possibility of death";
			} else if(logList.selectedItem.alcohol >= 0.400 && logList.selectedItem.alcohol <= 0.499){
				description = "Severe central nervous system depression. Coma. Possibility of death";
			} else if(logList.selectedItem.alcohol >= 0.599){
				description = "High risk of poisoning. High possibility of death";
			}			
			
			alert = Alert.show(description, "Details", new ListCollection(
				[
					{label:"Delete", triggered:deleteRecord},
					{label:"OK"}
				]));
		}
		
		private function loadData():void
		{
			myStatement = new SQLStatement();
			myStatement.sqlConnection = AlcoholApp.conn;
			myStatement.addEventListener(SQLEvent.RESULT, checkNumberOfRecords);				
			var myQuery:String = "SELECT * FROM userdata ORDER BY id DESC";
			myStatement.text = myQuery;
			myStatement.execute();
		}
		
		private function checkNumberOfRecords(event:SQLEvent):void
		{
			var result:SQLResult = myStatement.getResult();
			
			if(result.data != null){
				logList.dataProvider = new ListCollection(result.data);
				logList.addEventListener(starling.events.Event.CHANGE, listHandler);
			}			
		}
		
		private function deleteRecord():void
		{
			logList.removeEventListener(starling.events.Event.CHANGE, listHandler);
			alert.removeFromParent(true);
						
			myStatement = new SQLStatement();
			myStatement.sqlConnection = AlcoholApp.conn;
			myStatement.addEventListener(SQLEvent.RESULT, recordDeleted);				
			var myQuery:String = "DELETE FROM userdata WHERE id ="+logList.selectedItem.id;
			myStatement.text = myQuery;
			myStatement.execute();
		}
		
		private function recordDeleted(event:SQLEvent):void
		{			
			logList.selectedIndex = +1;
			loadData();
		}
		
		private function goBack():void
		{
			if(alert){
				alert.removeFromParent(true);
			}
			
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
	}
}