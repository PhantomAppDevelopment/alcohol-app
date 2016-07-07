package
{
	
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollText;
	import feathers.controls.SpinnerList;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.themes.StyleNameFunctionTheme;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class CustomTheme extends StyleNameFunctionTheme
	{
		[Embed(source="assets/font.ttf", fontFamily="MyFont", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="true")]
		private static const MY_FONT:Class;
				
		public function CustomTheme()
		{
			super();
			this.initialize();
		}
		
		private function initialize():void
		{
			this.initializeGlobals();
			this.initializeStyleProviders();	
		}
		
		private function initializeGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{
				return new TextBlockTextRenderer();
			}
			
			FeathersControl.defaultTextEditorFactory = function():ITextEditor
			{
				return new StageTextTextEditor();
			}
		}
		
		private function initializeStyleProviders():void
		{
			this.getStyleProviderForClass(Button).setFunctionForStyleName("blue-button", this.setBlueButtonStyle);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("home-button", this.setHomeButtonStyle);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("header-button", this.setHeaderButtonStyles);
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;
			this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);
		}
				
		
		//-------------------------
		// Misc.
		//-------------------------
				
		private function createSmallBlueLine(alpha:Number):Quad
		{
			var blueQuad:Quad = new Quad(3, 3.5, 0x00E8ED);
			blueQuad.alpha = alpha;
			blueQuad.y = 50;
			return blueQuad;
		}
				
		//-------------------------
		// Alert
		//-------------------------
										
		private function setAlertStyles(alert:Alert):void
		{
			
			alert.minHeight = 140;
			alert.minWidth = 270;
			alert.maxWidth = 270;
			alert.padding = 20;
			alert.backgroundSkin = new Quad(3, 3, 0x333333);			
			
			alert.buttonGroupFactory = function():ButtonGroup
			{
				var buttonGroup:ButtonGroup = new ButtonGroup();
				buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
				buttonGroup.gap = 5;
				buttonGroup.padding = 5;
				
				buttonGroup.buttonFactory = function():Button
				{
					var button:Button = new Button();
					button.height = 45;
					button.minWidth = 50;
					
					button.labelFactory = function():ITextRenderer
					{
						var font:FontDescription = new FontDescription("MyFont");
						font.fontLookup = FontLookup.EMBEDDED_CFF;
						
						var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
						renderer.elementFormat = new ElementFormat(font, 20, 0x000000);
						return renderer;
					}
					
					var defaultSkin:Quad = new Quad(45, 45);
					defaultSkin.setVertexColor(0, 0x00696D);
					defaultSkin.setVertexColor(1, 0x00696D);
					defaultSkin.setVertexColor(2, 0x00E8ED);
					defaultSkin.setVertexColor(3, 0x00E8ED);
					button.defaultSkin = defaultSkin;
					
					var downSkin:Quad = new Quad(45, 45);
					downSkin.alpha = 0.5;
					downSkin.setVertexColor(0, 0x00696D);
					downSkin.setVertexColor(1, 0x00696D);
					downSkin.setVertexColor(2, 0x00E8ED);
					downSkin.setVertexColor(3, 0x00E8ED);
					button.downSkin = downSkin;
					
					
					return button;
				}
				
				return buttonGroup;
			}
			
			alert.messageFactory = function():ITextRenderer
			{
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(new FontDescription("_sans"), 16, 0xFFFFFF);
				renderer.wordWrap = true;
				renderer.width = 150;
				renderer.leading = 10;
				return renderer;
			}
		}
		
		//-------------------------
		// Button
		//-------------------------
		
		private function setHomeButtonStyle(button:Button):void
		{
			button.iconPosition = Button.ICON_POSITION_TOP;
			button.gap = 15;
			
			button.labelFactory = function():ITextRenderer
			{
				var font:FontDescription = new FontDescription("MyFont");
				font.fontLookup = FontLookup.EMBEDDED_CFF;
				
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(font, 20, 0xFFFFFF);
				return renderer;				
			}
		}
		
		private function setHeaderButtonStyles(button:Button):void
		{
			var transparentQuad:Quad = new Quad(3, 3, 0xFFFFFF);
			transparentQuad.alpha = 0.2;
			
			var invisibleQuad:Quad = new Quad(3, 3, 0xFFFFFF);
			invisibleQuad.alpha = 0.0
			
			button.defaultSkin = invisibleQuad;
			button.downSkin = transparentQuad;
		}
		
		private function setBlueButtonStyle(button:Button):void
		{			
			button.labelFactory = function():ITextRenderer
			{
				var font:FontDescription = new FontDescription("MyFont");
				font.fontLookup = FontLookup.EMBEDDED_CFF;
				
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(font, 20, 0x000000);
				return renderer;
			}
			
			var defaultSkin:Quad = new Quad(3, 3);			
			defaultSkin.setVertexColor(0, 0x00696D);
			defaultSkin.setVertexColor(1, 0x00696D);
			defaultSkin.setVertexColor(2, 0x00E8ED);
			defaultSkin.setVertexColor(3, 0x00E8ED);
			button.defaultSkin = defaultSkin;
			
			var downSkin:Quad = new Quad(3, 3);
			downSkin.alpha = 0.5;
			downSkin.setVertexColor(0, 0x00696D);
			downSkin.setVertexColor(1, 0x00696D);
			downSkin.setVertexColor(2, 0x00E8ED);
			downSkin.setVertexColor(3, 0x00E8ED);
			button.downSkin = downSkin;
		}
		
		//-------------------------
		// Header
		//-------------------------
		
		private function setHeaderStyles(header:Header):void
		{
			var skin:Sprite = new Sprite();
			skin.height = 50;
			
			skin.addChild(new Quad(3, 50, 0x000000));
			
			var blueBar:Quad = new Quad(3, 3.5, 0x00E8ED);
			blueBar.y = skin.height;
			skin.addChild(blueBar);
			
			header.backgroundSkin = skin;
			
			header.titleFactory = function():ITextRenderer
			{
				var font:FontDescription = new FontDescription("MyFont");
				font.fontLookup = FontLookup.EMBEDDED_CFF;
				
				var renderer:TextBlockTextRenderer = new TextBlockTextRenderer();
				renderer.elementFormat = new ElementFormat(font, 16, 0xFFFFFF);
				return renderer;
			}
		}
		
		//-------------------------
		// List
		//-------------------------
				
		private function setListStyles(list:List):void
		{
			list.backgroundSkin = new Quad(3, 3, 0x444444);
		}
		
		private function setItemRendererStyles(renderer:DefaultListItemRenderer):void
		{
			renderer.defaultSkin = new Quad(3, 3, 0x333333);
			renderer.defaultSelectedSkin = new Quad(3, 3, 0x00E8ED);
			renderer.downSkin = new Quad(3, 3, 0x00E8ED);
		
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingLeft = 10;
			renderer.paddingRight = 0;
			renderer.paddingTop = 5;
			renderer.paddingBottom = 5;
			renderer.gap = 10;
			renderer.minHeight = 55;
			renderer.defaultLabelProperties.leading = 7;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			
			renderer.defaultLabelProperties.elementFormat = new ElementFormat(new FontDescription("_sans"), 14, 0xFFFFFF);
		}		
		
		//-------------------------
		// NumericStepper
		//-------------------------
				
		private function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.incrementButtonFactory = function():Button
			{
				var icon:ImageLoader = new ImageLoader();
				icon.source = "assets/icons/next.png";
				icon.width = icon.height = 30;
				
				var button:Button = new Button();
				button.defaultIcon = icon;
				button.width = button.height = 60;
				button.styleNameList.add("blue-button");
				return button;
			}
				
			stepper.decrementButtonFactory = function():Button
			{
				var icon:ImageLoader = new ImageLoader();
				icon.source = "assets/icons/prev.png";
				icon.width = icon.height = 30;
				
				var button:Button = new Button();
				button.defaultIcon = icon;
				button.width = button.height = 60;
				button.styleNameList.add("blue-button");
				return button;
			}
				
			stepper.textInputFactory = function():TextInput
			{
				var input:TextInput = new TextInput();
				input.isEditable = false;
				input.backgroundSkin = new Quad(3, 3, 0x444444);
				input.padding = 20;
				
				input.textEditorFactory = function():ITextEditor
				{
					var editor:StageTextTextEditor = new StageTextTextEditor();
					editor.fontFamily = "_sans";
					editor.fontSize = 26;
					editor.color = 0xFFFFFF;
					editor.textAlign = "center";
					return editor;
				}
				
				return input;
			}
		}
		
		//-------------------------
		// Panel
		//-------------------------
				
		private function setPanelScreenStyles(screen:PanelScreen):void
		{						
			screen.backgroundSkin = new Quad(3, 3, 0x000000);
		}
		
		//-------------------------
		// ScrollText
		//-------------------------
		
		private function setScrollTextStyles(scrolltext:ScrollText):void
		{
			scrolltext.textFormat = new TextFormat("_sans", 12, 0xFFFFFF);
			scrolltext.isHTML = true;
		}
		
		//-------------------------
		// SpinnerList
		//-------------------------
		
		private function setSpinnerListStyles(spinner:SpinnerList):void
		{
			
			var overlay:Quad = new Quad(3, 3, 0x000000);
			overlay.alpha = 0.3;
			
			spinner.selectionOverlaySkin = overlay;
			
			spinner.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.styleProvider = null;
				renderer.defaultLabelProperties.elementFormat = new ElementFormat(new FontDescription("_sans"), 20, 0xFFFFFF);
				renderer.gap = 10;
				renderer.minHeight = 50;
				renderer.minWidth = 50;
				
				renderer.defaultSkin = new Quad(3, 3, 0x333333);
				renderer.defaultSelectedSkin = new Quad(3, 3, 0x00E8ED);
				renderer.downSkin = new Quad(3, 3, 0x00E8ED);
				
				return renderer;				
			}
			
		}
		
		//-------------------------
		// TabBar
		//-------------------------
		
		private function setTabStyles(button:ToggleButton):void
		{					
			var skin:Sprite = new Sprite();
			skin.addChild(new Quad(3, 3, 0x000000));
			skin.addChild(createSmallBlueLine(1.0));
			
			var skin2:Sprite = new Sprite();
			skin2.addChild(new Quad(3, 3, 0x000000));
			skin2.addChild(createSmallBlueLine(0.5));
			
			button.defaultSkin = skin2;
			button.downSkin = skin;
			button.selectedDownSkin = skin;
			button.defaultSelectedSkin = skin;
		}
						
	}
}