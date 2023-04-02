import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var rpg:FlxText; // clase para el texto
	var platform:FlxText;
	var seleccion:Int = 0; // variable de numeros, que indica la seleccion

	override public function create()
	{
		// x, y, noimporta, texto, tamaño
		rpg = new FlxText(0, 200, 0, "Nivel RPG", 24);
		rpg.screenCenter(X); // hacemos que el texto este a la mitad de la pantalla
		add(rpg);

		platform = new FlxText(0, 400, 0, "Nivel plataformero", 24);
		platform.screenCenter(X); // hacemos que el texto este a la mitad de la pantalla
		add(platform);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.DOWN) // si se presiona la tecla de abajo, la seleccion sube
		{
			seleccion++; // la seleccion sube 1
		}

		if (FlxG.keys.justPressed.UP) // si se presiona la tecla de arriba, la seleccion baja
		{
			seleccion--; // la seleccion baja 1
		}

		if (seleccion > 1) // no puede ser mas de 1
			seleccion = 1;
		if (seleccion < 0) // no puede ser menos de 0
			seleccion = 0;

		// para preguntar por un valor se usa ==, para asignar un valor se usa =
		/* ejemplo:
			if (monedas == 10) pregunta por el valor

			monedas = 5; asigna un valor
		 */

		if (seleccion == 1) // si la seleccion es 1
		{
			platform.color = FlxColor.RED; // platform es de color rojo, y rpg blanco
			rpg.color = FlxColor.WHITE;
		}
		else if (seleccion == 0)
		{
			rpg.color = FlxColor.RED; // rpg es de color rojo, y platform blanco
			platform.color = FlxColor.WHITE;
		}
		else // si no es ninguno de los dos (por si acaso)
		{
			rpg.color = FlxColor.WHITE; // los dos de color blanco
			platform.color = FlxColor.WHITE;
		}

		if (FlxG.keys.anyJustPressed([ENTER, SPACE])) // si se presiona enter o espacio
		{
			if (seleccion == 1) // si platform esta seleccionado
			{
				FlxG.switchState(new PlatformerState()); // cambiar state a platformer state
			}
			else if (seleccion == 0) // si rpg esta seleccionado
			{
				FlxG.switchState(new RPGState()); // cambiar state a rpgstate
			}
			else // si no es ninguno de los 2
			{
				trace("que");
			}
		}

		super.update(elapsed);
	}
}
