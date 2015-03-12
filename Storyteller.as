package utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import utils.SoundManager;
	
	public class Storyteller extends MovieClip
	{
		public var transcript:Array;
		private var diag:Dialogue;
		private var stringInd:uint;
		private var stringTgt:String;
		private var adv:Boolean;
		public var advancable:Boolean;
		
		private var par:MovieClip;
		private var snd:SoundManager;		// SoundManager
		
		private var shakeAmt:int;
		private var boxAnchorX:Number;
		private var boxAnchorY:Number;
		
		public var pauseEnabled:Boolean = true;
		public var skipLabel:String = null;
		
		private var sfx_beep:Sound = new SFX_textAdv();
		
		public function Storyteller()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			transcript = [];
			par = MovieClip(parent);				// ContainerIntro, etc.
			snd = MovieClip(par.parent).soundMan;	// Engine
			par.box.adv.addEventListener(MouseEvent.CLICK, boxPressed);
			par.box.hex.visible = false;
			adv = false;
			advancable = false;
			stringTgt = "";
			
			boxAnchorX = par.box.x;
			boxAnchorY = par.box.y;

			stage.stageFocusRect = false;
			stage.focus = this;
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function addLine(d:Dialogue):void
		{
			transcript.push(d);
		}
		
		public function nextSay():void
		{
			diag = transcript.shift();
			setTextTgt(diag.msg);
			adv = diag.adv;
			if (diag.img != "")
			{
				act.ind = diag.img;
				act.gotoAndPlay("slideOut");
			}
			if (diag.nam != "")
				par.box.tName.text = diag.nam;
				
			// handle SFX: add a + prefix to start a loop, and a - prefix to stop the loop
			if (diag.sfx != "")
			{
				if (diag.sfx.charAt(0) == '+')
					snd.startLoop(diag.sfx.substring(1));
				else if (diag.sfx.charAt(0) == '-')
					snd.stopLoop(diag.sfx.substring(1));
				else
					snd.playSound(diag.sfx);
			}
				
			addEventListener(Event.ENTER_FRAME, updateText);
			par.box.tText.text = "";
		}
		
		private function updateText(e:Event):void
		{
			if (stringTgt == "") return;
			if (par.box.tText.text.length == stringTgt.length)
			{
				textDone();
				return;
			}
			stringInd += 4;
			if (stringInd > stringTgt.length - 1)
				stringInd = stringTgt.length;
			par.box.tText.text = stringTgt.substr(0, stringInd);
		}
		
		private function boxPressed(e:MouseEvent):void
		{
			if (!advancable) return;
			sfx_beep.play();
			if (par.box.tText.text.length != stringTgt.length)
				textDone();
			else if (adv)
			{
				advancable = false;
				par.play();
			}
			else if (transcript.length > 0)
				nextSay();
		}
		
		private function textDone():void
		{
			removeEventListener(Event.ENTER_FRAME, updateText);
			par.box.tText.text = stringTgt;
			par.box.hex.visible = true;
		}
		
		private function setTextTgt(t:String):void
		{
			stringTgt = t;
			stringInd = 0;
			par.box.text = "";
			par.box.hex.visible = false;
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			if (skipLabel && e.keyCode == Keyboard.P)
			{
				gotoAndPlay(skipLabel);
				disableSkip();
			}
			else if (!pauseEnabled) return;
			if (e.keyCode == Keyboard.P)
			{
				if (!par.box.obj_pause.visible)
					par.box.obj_pause.gotoAndPlay(2);
				else if (par.box.obj_pause.currentLabel == "halt")
					par.box.obj_pause.gotoAndPlay("out");
			}
			else if (e.keyCode == Keyboard.SPACE)
				boxPressed(null);
		}
		
		public function enableSkip(lbl:String):void
		{
			skipLabel = lbl;
		}
		
		public function disableSkip():void
		{
			skipLabel = null;
		}
		
		public function shakeOn(amt:int = 4):void
		{
			addEventListener(Event.ENTER_FRAME, updateShake);
			shakeAmt = amt;
		}
		
		public function shakeOff():void
		{
			removeEventListener(Event.ENTER_FRAME, updateShake);
			x = 0; y = 0;
			par.box.x = boxAnchorX; par.box.y = boxAnchorY;
		}
		
		private function updateShake(e:Event):void
		{
			x = getRand(-shakeAmt, shakeAmt);
			y = getRand(-shakeAmt, shakeAmt);
			par.box.x = boxAnchorX + getRand(-shakeAmt, shakeAmt);
			par.box.y = boxAnchorY + getRand(-shakeAmt, shakeAmt);
		}
		
		protected function getRand(min:Number, max:Number):Number   
		{  
			return (Math.floor(Math.random() * (max - min + 1)) + min);  
		} 
		
		public function kill():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			removeEventListener(Event.ENTER_FRAME, updateText);
			removeEventListener(Event.ENTER_FRAME, updateShake);
			if (par) if (par.box) if (par.box.adv)
				par.box.adv.removeEventListener(MouseEvent.CLICK, boxPressed);
		}
		
		private function onRemoved(e:Event)
		{
			kill();
		}
	}
}
