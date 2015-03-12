﻿package cobaltric
{
	public class Dialogue
	{
		public var msg:String;	// dialogue
		public var nam:String;	// speaker name
		public var img:String;	// background image
		public var snd:String;	// name of sound (optional)

		public function Dialogue(_msg:String, _nam:String, _img:String = "", _snd:String = "")
		{
			msg = _msg;
			img = _img;
			nam = _nam;
			snd = _snd;
		}
	}
}