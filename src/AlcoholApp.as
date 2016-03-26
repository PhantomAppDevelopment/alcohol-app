package
{
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import feathers.utils.ScreenDensityScaleFactorManager;
	
	import starling.core.Starling;
	
	[SWF(width="320",height="480",frameRate="60",backgroundColor="#000000")]
	
	public class AlcoholApp extends Sprite
	{
		public static var conn:SQLConnection;
		
		private var _starling:Starling;
		private var _scaler:ScreenDensityScaleFactorManager;
		private var _launchImage:Loader;
		private var _savedAutoOrients:Boolean;
		
		public function AlcoholApp()
		{
			if(this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			
			this.mouseEnabled = this.mouseChildren = false;
			
			var db:File = File.applicationStorageDirectory.resolvePath("userdata.db");
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openDatabaseHandler);
			conn.open(db);
				
		}
		
		private function openDatabaseHandler(event:SQLEvent):void{		
			var myStatement:SQLStatement = new SQLStatement();
			myStatement.sqlConnection = conn;
			myStatement.addEventListener(SQLEvent.RESULT, createUserTableResult);				
			var myQuery:String = "CREATE TABLE IF NOT EXISTS userdata (id INTEGER PRIMARY KEY, gender TEXT, date TEXT, alcohol TEXT, weight TEXT, quantity TEXT, period TEXT, color TEXT)";
			myStatement.text = myQuery;
			myStatement.execute();
		}
		
		private function createUserTableResult(event:SQLEvent):void
		{
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);	
		}

		
		private function loaderInfo_completeHandler(event:Event):void
		{			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			
			this._starling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, "auto");
			this._scaler = new ScreenDensityScaleFactorManager(this._starling);
			this._starling.enableErrorChecking = false;
			//this._starling.showStats = true;
			
			this._starling.start();									
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		
		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}
		
	}
}