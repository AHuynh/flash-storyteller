package cobaltric
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	
	public class Storyteller extends MovieClip
	{
		public var transcript:Array;
		private var diag:Dialogue;
		private var stringInd:uint;
		private var stringTgt:String;
		
		private var eng:MovieClip;			// the containing MovieClip, Engine
		private var snd:SoundManager;		// initalized by Engine
		
		public function Storyteller()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			transcript = [];
			eng = MovieClip(parent);
			snd = eng.soundMan;
			box.adv.addEventListener(MouseEvent.CLICK, boxPressed);
			box.done.visible = false;
			stringTgt = "";
			stage.stageFocusRect = false;
			stage.focus = this;
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function addLine(d:Dialogue):void
		{
			transcript.push(d);
		}
		
		public function nextSay():void
		{
			diag = transcript.shift();	// grab the next dialogue
			
			stringTgt = diag.msg;		// setup the text
			stringInd = 0;
			box.text = "";
			box.done.visible = false;
			
			if (diag.img != "")
			{
				try
				{
					bg.errText.visible = false;
					bg.gotoAndStop(diag.img);	// set the image
				} catch (e:Error)
				{
					bg.gotoAndStop("default");
					bg.errText.visible = true;
					bg.errText.text = "Error: could not find the given image label:\n\"" + diag.img + "\"";
				}
			}
			
			box.tName.text = diag.nam;	// set the name
				
			// handle SFX: add a + prefix to start a loop, and a - prefix to stop the loop
			/*if (diag.sfx != "")
			{
				if (diag.sfx.charAt(0) == '+')
					snd.startLoop(diag.sfx.substring(1));
				else if (diag.sfx.charAt(0) == '-')
					snd.stopLoop(diag.sfx.substring(1));
				else
					snd.playSound(diag.sfx);
			}*/
				
			addEventListener(Event.ENTER_FRAME, updateText);
			box.tText.text = "";
		}
		
		private function updateText(e:Event):void
		{
			if (stringTgt == "") return;
			if (box.tText.text.length == stringTgt.length)
			{
				textDone();
				return;
			}
			stringInd += 4;
			if (stringInd > stringTgt.length - 1)
				stringInd = stringTgt.length;
			box.tText.text = stringTgt.substr(0, stringInd);
		}
		
		private function boxPressed(e:MouseEvent):void
		{
			//sfx_beep.play();
			if (box.tText.text.length != stringTgt.length)
				textDone();

			if (transcript.length > 0)
				nextSay();
		}
		
		private function textDone():void
		{
			removeEventListener(Event.ENTER_FRAME, updateText);
			box.tText.text = stringTgt;
			box.done.visible = true;
		}
		
		private function setTextTgt(t:String):void
		{
			stringTgt = t;
			stringInd = 0;
			box.text = "";
			box.done.visible = false;
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
				boxPressed(null);
		}
	}
}
