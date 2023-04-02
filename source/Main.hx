package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		// Aca va el state con el que quieres empezar, por default esta PlayState
		addChild(new FlxGame(0, 0, MenuState, 60, 60, true));
	}
}
