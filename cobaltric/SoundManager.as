package cobaltric
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class SoundManager
	{
		public var eng:MovieClip;									// a reference to the Engine
		
		public var sndMap:Object = new Object();					// maps a String to a Sound
		
		public var bgm:SoundChannel;								// the single background music
		public var sndTF:SoundTransform = new SoundTransform();		// for fading the BGM out
		
		// fading helpers
		public var timer:Timer;
		public var fade:int = 0;
		public var maxFade:int = 1;
		
		// holds any sounds that are set to loop
		public var sndLoop:Object = new Object();

		public function SoundManager(_eng:MovieClip)
		{
			eng = _eng;
			// -- add sound definitions here		
			//sndMap["sfx_dest"] = new SFX_destroyer();
				
			//sndMap["BGM_Menu"] = new BGM_Menu();
		}
		
		// play the given sound effect numTimes, or once if not provided
		public function playSound(s:String, numTimes:int = -1):void
		{
			if (numTimes != -1)
			{
				startLoop(s, numTimes);
				return;
			}
			sndMap[s].play();
		}
		
		// play the specified background music at the given volume (or 100% if not provided)
		public function playBGM(s:String, vol:Number = 1):void
		{
			stopBGM();
			bgm = sndMap[s].play(0, int.MAX_VALUE);				// loop forever
			if (vol != 1)
				bgm.soundTransform = new SoundTransform(vol);
		}
		
		// stop the background music
		public function stopBGM():void
		{
			if (bgm)
			{
				bgm.stop();
				fade = 0;
				if (timer)
				{
					if (timer.hasEventListener(TimerEvent.TIMER))
						timer.removeEventListener(TimerEvent.TIMER, tick);
					timer.stop();
				}
			}
			bgm = null;
		}
		
		// fade the background music out, duration in frames
		public function fadeBGM(duration:int = 30):void
		{
			fade = maxFade = duration;
			sndTF.volume = 1;
			timer = new Timer(33);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
		}
		
		// fade helper
		private function tick(e:TimerEvent):void
		{
			sndTF.volume = fade / maxFade;
			if (bgm)
				bgm.soundTransform = sndTF;
			if (--fade <= 0)
				stopBGM();
		}
		
		public function startLoop(s:String, numTimes:int = int.MAX_VALUE):SoundChannel
		{
			if (!sndLoop[s])
				sndLoop[s] = new SoundChannel();
			sndLoop[s] = sndMap[s].play(0, numTimes);
			return sndLoop[s];
		}
		
		public function stopLoop(s:String):void
		{
			if (!sndLoop[s]) return;
			sndLoop[s].stop();
			sndLoop[s] = null;
		}
		
		public function shutUp():void
		{
			stopBGM();
			SoundMixer.stopAll();
			sndLoop = new Object();
		}
	}
}
