package screens
{
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.SpinnerList;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class TestScreen extends PanelScreen
	{
		private static const BODY_WATER:Number = 0.806;
		private static const FACTOR:Number = 1.2;
		private var standardDrinks:Number;
				
		private var gender:String;
		private var bodyWater:Number;
		private var bodyWeight:Number;

		private var metabolismRate:Number;
		private var drinkingPeriod:Number;
		
		private var periodList:SpinnerList;
		private var startButton:Button;
		private var manButton:Button;
		private var womanButton:Button;
		private var weightStepper:NumericStepper;
		private var nextButton:Button;
		private var quantityList:SpinnerList;
		private var drinkTypeList:SpinnerList;
		private var ebac:Label;
		private var alertIcon:ImageLoader;		
		private var iconColor:uint;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this.layout = new AnchorLayout();
			this.backButtonHandler = goBack;
			
			this.title = "Drinking Period of Time";
				
		 	periodList = new SpinnerList();
			periodList.layoutData = new AnchorLayoutData(NaN, NaN,NaN, NaN, 0, -50);
			periodList.height = 150;
			periodList.width = 200;
			periodList.dataProvider = new ListCollection(
				[
					{label:"1 Hour", data:1},
					{label:"2 Hours", data:2},
					{label:"3 Hours", data:3},
					{label:"4 Hours", data:4},
					{label:"5 Hours", data:5},
					{label:"6 Hours", data:6},
					{label:"7 Hours", data:7},
					{label:"8 Hours", data:8},
					{label:"9 Hours", data:9},
					{label:"10 Hours", data:10}
				]);
			
			this.addChild(periodList);
			
			
			startButton = new Button();
			startButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				drinkingPeriod = Number(periodList.selectedItem.data);
			
				startButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
				
				var tween:Tween = new Tween(startButton, 0.3);
				tween.fadeTo(0);
				tween.onComplete = function():void
				{
					removeChild(periodList, true);
					removeChild(startButton, true);
					step1();					
				}
				Starling.juggler.add(tween);				
			});
			
			startButton.height = 50;
			startButton.width = 120;
			startButton.alpha = 0;
			startButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 100);
			startButton.label = "Start Test";
			startButton.styleNameList.add("blue-button");
			this.addChild(startButton);
			
			var startButtonTween:Tween = new Tween(startButton, 1.0);
			startButtonTween.fadeTo(1);
			Starling.juggler.add(startButtonTween);
		}
		
		private function step1():void
		{
			this.title = "Select your Gender";
			
			var womanIcon:ImageLoader = new ImageLoader();
			womanIcon.source = "assets/icons/woman.png";
			womanIcon.snapToPixels = true;
			womanIcon.width = 92;
			womanIcon.height = 200;
			womanIcon.color = 0x00E8ED;
			womanIcon.filter = BlurFilter.createGlow(0x0000E8ED, 1.0, 10);
			
			womanButton = new Button();
			womanButton.alpha = 0;
			womanButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				gender = "female";
				metabolismRate = 0.017;
				bodyWater = 0.49;
				
				manButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
				womanButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
								
				var fade1:Tween = new Tween(womanButton, 0.3);
				fade1.fadeTo(0);
				
				var fade2:Tween = new Tween(manButton, 0.3);
				fade2.fadeTo(0);
				
				fade1.onComplete = function():void
				{
					Starling.juggler.add(fade2);	
				}
				Starling.juggler.add(fade1);
				
				fade2.onComplete = function():void
				{
					removeChild(womanButton, true);
					removeChild(manButton, true);
					step2();
				}
			});
			
			womanButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, -75, 0);
			womanButton.defaultIcon = womanIcon;
			womanButton.label = "Female";
			womanButton.styleNameList.add("home-button");
			this.addChild(womanButton);
			
			var womanFade:Tween = new Tween(womanButton, 0.3);
			womanFade.fadeTo(1);
			Starling.juggler.add(womanFade);
			
			var manIcon:ImageLoader = new ImageLoader();
			manIcon.source = "assets/icons/man.png";
			manIcon.snapToPixels = true;
			manIcon.width = 92;
			manIcon.height = 200;
			manIcon.color = 0x00E8ED;
			
			manButton = new Button();
			manButton.alpha = 0;			
			manButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				gender = "male";
				metabolismRate = 0.015;
				bodyWater = 0.58;
	
				manButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
				womanButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
				
				var fade1:Tween = new Tween(manButton, 0.3);
				fade1.fadeTo(0);
				
				var fade2:Tween = new Tween(womanButton, 0.3);
				fade2.fadeTo(0);
				
				fade1.onComplete = function():void
				{
					Starling.juggler.add(fade2);	
				}
				Starling.juggler.add(fade1);
				
				fade2.onComplete = function():void
				{
					removeChild(womanButton, true);
					removeChild(manButton, true);
					step2();
				}
								
			});
			
			manButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 75, 0);
			manButton.defaultIcon = manIcon;
			manButton.label = "Male";
			manButton.styleNameList.add("home-button");
			this.addChild(manButton);
			
			var manFade:Tween = new Tween(manButton, 0.3);
			manFade.fadeTo(1);
			Starling.juggler.add(manFade);
		}
		
		private function step2():void
		{
			this.title = "Select your Weight in lbs";
			
			this.removeChild(manButton, true);
			this.removeChild(womanButton, true);
			
			weightStepper = new NumericStepper();
			weightStepper.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -50);
			weightStepper.alpha = 0;
			weightStepper.minimum = 1;
			weightStepper.maximum = 400;
			weightStepper.value = 150;
			weightStepper.step = 1;
			this.addChild(weightStepper);
			
			var stepperFade:Tween = new Tween(weightStepper, 0.3);
			stepperFade.fadeTo(1);
			Starling.juggler.add(stepperFade);
			
			nextButton = new Button();
			nextButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				bodyWeight = Number(weightStepper.value) / 2.20;
				
				nextButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
				
				var stepperFadeOut:Tween = new Tween(weightStepper, 0.3);
				stepperFadeOut.fadeTo(0);
				Starling.juggler.add(stepperFadeOut);

				var buttonFadeOut:Tween = new Tween(nextButton, 0.3);
				buttonFadeOut.fadeTo(0);
				buttonFadeOut.onComplete = function():void
				{
					removeChild(weightStepper, true);
					removeChild(nextButton, true);
					step3();
				}
				Starling.juggler.add(buttonFadeOut);
			});
			nextButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 50);
			nextButton.height = 50;
			nextButton.width = 120;
			nextButton.alpha = 0;
			nextButton.label = "Next";
			nextButton.styleNameList.add("blue-button");
			this.addChild(nextButton);
			
			var buttonFade:Tween = new Tween(nextButton, 0.3);
			buttonFade.fadeTo(1);
			Starling.juggler.add(buttonFade);
			
		}
		
		private function step3():void
		{
			this.title = "How Many Drinks?";
			
			quantityList = new SpinnerList();
			quantityList.width = 100;
			quantityList.height = 150;
			quantityList.alpha = 0;
			quantityList.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, -100, -50);
			quantityList.dataProvider = new ListCollection(
				[
					{label:"1"},
					{label:"2"},
					{label:"3"},
					{label:"4"},
					{label:"5"},
					{label:"6"},
					{label:"7"},
					{label:"8"},
					{label:"9"},
					{label:"10"}
				]);
			this.addChild(quantityList);
			
			var quantityFade:Tween = new Tween(quantityList, 0.3);
			quantityFade.fadeTo(1);
			Starling.juggler.add(quantityFade);
			
			drinkTypeList = new SpinnerList();
			drinkTypeList.addEventListener(starling.events.Event.CHANGE, function():void
			{
				title = drinkTypeList.selectedItem.title;
			});
			drinkTypeList.width = 200;
			drinkTypeList.height = 150;
			drinkTypeList.alpha = 0;
			drinkTypeList.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 55, -50);
			drinkTypeList.dataProvider = new ListCollection(
				[
					{label:"Beer", title:"How Many Cans?"},
					{label:"Table Wine", title:"How Many Cups?"},
					{label:"Malt Liquor", title:"How Many Glasses?"},
					{label:"80 Proof Spirits", title:"How Many Shots?"}
				]);
			this.addChild(drinkTypeList);
			
			var drinkTypeFade:Tween = new Tween(drinkTypeList, 0.3);
			drinkTypeFade.fadeTo(1);
			Starling.juggler.add(drinkTypeFade);
			
			nextButton = new Button();
			nextButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 100);
			nextButton.addEventListener(starling.events.Event.TRIGGERED, function():void
			{
				standardDrinks = quantityList.selectedItem.label;
				
				nextButton.removeEventListener(starling.events.Event.TRIGGERED, function():void{});
				
				var quantityFadeOut:Tween = new Tween( quantityList, 0.3);
				quantityFadeOut.fadeTo(0);
				Starling.juggler.add(quantityFadeOut);
				
				var typeFadeOut:Tween = new Tween(drinkTypeList, 0.3);
				typeFadeOut.fadeTo(0);
				Starling.juggler.add(typeFadeOut);
				
				var buttonFadeOut:Tween = new Tween(nextButton, 0.3);
				buttonFadeOut.fadeTo(0);				
				buttonFadeOut.onComplete = function():void
				{										
					removeChild(quantityList, true);
					removeChild(drinkTypeList, true);
					removeChild(nextButton, true);
					step4();
				}
				Starling.juggler.add(buttonFadeOut);
			});
			
			nextButton.height = 50;
			nextButton.width = 120;
			nextButton.alpha = 0;
			nextButton.label = "Finish";
			nextButton.styleNameList.add("blue-button");
			this.addChild(nextButton);
			
			var buttonFade:Tween = new Tween(nextButton, 0.3);
			buttonFade.fadeTo(1);
			Starling.juggler.add(buttonFade);
		}
		
		private function step4():void
		{
			this.title = "Your Result";
			
			var result:Number = (BODY_WATER * standardDrinks * 1.2) / (bodyWater * bodyWeight) - (metabolismRate * drinkingPeriod);

			alertIcon = new ImageLoader();
			alertIcon.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -50);
			alertIcon.source = "assets/icons/warning_big.png";
			alertIcon.width = alertIcon.height = 250;
			alertIcon.alpha = 0;
			alertIcon.color = 0xFFFFFF;
			alertIcon.snapToPixels = true;
			this.addChild(alertIcon);
						
			var description:Label = new Label();
description.alpha = 0;
			description.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 25);
			description.textRendererFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.styleProvider = null;
				renderer.elementFormat = new ElementFormat(new FontDescription("_sans"), 24, 0xFFFFFF);
				return renderer;
			};
			description.textRendererProperties.wordWrap = true;
			description.textRendererProperties.leading = 7;
			description.maxWidth = 300;
			this.addChild(description);
									
			ebac = new Label();
			ebac.height = 150;
			ebac.alpha = 0;
			this.addChild(ebac);
			ebac.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -15);
			ebac.textRendererFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.styleProvider = null;
				renderer.elementFormat = new ElementFormat(new FontDescription("_sans"), 80, 0xFFFFFF);
				return renderer;
			}
			
			if(result <= 0.0009){
				ebac.text = "0.001";				 
			} else {
				ebac.text = result.toFixed(3);
			}
							
			var ebacTween:Tween = new Tween(ebac, 0.3);
			ebacTween.fadeTo(1);
			Starling.juggler.add(ebacTween);
			
			var alertFade:Tween = new Tween(alertIcon, 0.3);
			alertFade.fadeTo(0.5);
			
			var finalResult:Number = Number(ebac.text);
						
			if(finalResult >= 0.001 && finalResult <= 0.029){
				alertFade.animate("color", 0x00C807); //Green
				iconColor =  0x00C807;
				description.text = "Average individual appears normal.";
			} else if(finalResult >= 0.030 && finalResult <= 0.059){
				alertFade.animate("color", 0xCCDC00); //Yellow-ish
				iconColor = 0xCCDC00;
				description.text = "Mild euphoria. Relaxation. Joyousness. Talkativeness.";
			} else if(finalResult >= 0.060 && finalResult <= 0.099){
				alertFade.animate("color", 0xDFCC00); //Yellow
				iconColor = 0xDFCC00;
				description.text = "Blunted feelings. Reduced sensitivity to pain. Euphoria. Disinhibition.";
			} else if(finalResult >= 0.100 && finalResult <= 0.199){
				alertFade.animate("color", 0xF98C00); //Orange
				iconColor = 0xF98C00;
				description.text = "Over-expression. Boisterousness";
			} else if(finalResult >= 0.200 && finalResult <= 0.299){
				alertFade.animate("color", 0xEC5F00); //Dark Orange
				iconColor = 0xEC5F00;
				description.text = "Nausea. Vomiting. Emotional swings. Anger or sadness. Decreased libido.";
			} else if(finalResult >= 0.300 && finalResult <= 0.399){
				alertFade.animate("color", 0xEF2B00); //Red
				iconColor = 0xEF2B00;
				description.text = "Loss of understanding. Lapses in and out of consciousness";
			} else if(finalResult >= 0.400 && finalResult <= 0.499){
				alertFade.animate("color", 0xCC0149); //Purple
				iconColor = 0xCC0149;
				description.text = "Severe central nervous system depression, Coma";
			} else if(finalResult >= 0.599){
				alertFade.animate("color", 0x333333); //Black
				iconColor = 0x333333;
				description.text = "High possibility of death";
			}
			
			var descriptionFade:Tween = new Tween(description, 0.3);
			descriptionFade.fadeTo(1);
			Starling.juggler.add(descriptionFade);			
			
			Starling.juggler.add(alertFade);
			
			saveResult();
					
		}
		
		private function saveResult():void
		{
			var myStatement:SQLStatement = new SQLStatement();
			myStatement.sqlConnection = AlcoholApp.conn;
			myStatement.addEventListener(SQLEvent.RESULT, addRecordResult);				
			var myQuery:String = "INSERT INTO userdata (gender, date, alcohol, weight, period, quantity, color) VALUES ('"
					+gender+"','"
					+new Date().getTime()+"','"
					+ebac.text+"','"
					+bodyWeight+"','"
					+drinkingPeriod+"','"
					+standardDrinks+"','"
					+iconColor+"')";
			myStatement.text = myQuery;
			myStatement.execute();
		}
		
		private function addRecordResult(event:SQLEvent):void
		{
			var doneIcon:ImageLoader = new ImageLoader();
			doneIcon.source = "assets/icons/ic_done_white_36dp.png";
			doneIcon.width = 30;
			doneIcon.height = 30;
			doneIcon.snapToPixels = true;
			
			var doneButton:Button = new Button();
			doneButton.width = 50;
			doneButton.height = 50;
			doneButton.styleNameList.add("header-button");
			doneButton.defaultIcon = doneIcon;
			doneButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.rightItems = new <DisplayObject>[doneButton];
		}
						
		private function goBack():void
		{
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
		
	}
}