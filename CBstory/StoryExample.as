﻿package CBstory
{
	import cobaltric.Storyteller;
	import cobaltric.Dialogue;
	import flash.display.MovieClip;

	public class StoryExample extends Story
	{
		public function StoryExample(_st:MovieClip)
		{
			super(_st);
		}

		override protected function init():void
		{
			// fireplace
			st.addLine(new Dialogue("You have the goods, yes?", "Ruben", "fireplace"));
			st.addLine(new Dialogue("Yeh, got 'em right here.", "Kara"));
			st.addLine(new Dialogue("Excellent. Now get out of my sight.", "Ruben"));
			
			// woods
			st.addLine(new Dialogue("Did I do the right thing, Robin?", "Kara", "woods"));
			st.addLine(new Dialogue("I don't know, Kara. Only time will tell.", "Robin"));
			
			// error
			st.addLine(new Dialogue("This should error out because *SOMEBODY* didn't set up their images correctly!", "Alex", "doesntExist"));
		}
	}
}

/*
Image attributions

"fireplace"		http://pmdunity.tumblr.com/post/87098807132/
"woods"			http://pmdunity.tumblr.com/post/87098891667/
*/