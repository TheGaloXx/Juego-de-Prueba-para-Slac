package;

// clases que vamos a usar
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor; // clase que ayuda a elegir colores
import openfl.system.System;

class PlatformerState extends FlxState
{
	var pato:FlxSprite; // creamos al pato fuera de la funcion create asi lo podemos usar en cualquier parte del state
	var saltando:Bool = false; // por default no esta saltando
	var suelo:FlxSprite; // creamos el suelo fuera de la funcion create asi lo podemos usar en cualquier parte del state
	var multicolor:Bool = false; // modo multicolor

	// funcion que crea la escena
	override public function create()
	{
		// en lugar de usar tu imagen voy a hacer el fondo con codigo
		var cielo = new FlxSprite();
		cielo.makeGraphic(FlxG.width, FlxG.height, 0xff21f8ff); // hacemos el grafico del tamaño del juego, y para el color lo elegimos xd
		cielo.screenCenter(); // usamos la funcion screenCenter para poner el sprite en el centro de la pantalla
		add(cielo); // añadimos el sprite

		suelo = new FlxSprite(0, FlxG.height - 30); // vamos a hacer que esté en el piso de la ventana - 30
		suelo.makeGraphic(FlxG.width, 30, FlxColor.GREEN); // creamos el grafico que va a tener la ventana de ancho y 30 px de altura, de color verde
		suelo.immovable = true; // lo hacemos inmovible
		add(suelo);

		pato = new FlxSprite(100, 100);
		pato.loadGraphic('assets/images/duck.png', true, 100,
			114); // cargamos la imagen, le decimos que es animada, y aclaramos de que tamaño es cada animacion del spritesheet

		// animaciones
		//	nombre + frames + fps + se repite
		pato.animation.add('idle', [0], 0, true);
		pato.animation.add('walk', [0, 1, 0, 2], 10, true);
		pato.animation.add('jump', [3], 0, true);

		// fisicas :sob:
		pato.acceleration.y = 1450; // hacemos que por cada segundo la velocidad hacia abajo aumente por 1450, yendo cada vez mas rapido

		add(pato);

		super.create();
	}

	// funcion que actualiza la escena cada frame
	override public function update(elapsed:Float)
	{
		FlxG.collide(pato, suelo); // hacemos que el pato y el suelo choquen entre si para no atravesarse
		if (pato.velocity.y == 0) // si ya cayó al piso
		{
			saltando = false; // ya no esta saltando
		}

		controles(); // checkeamos si se esta tocando algun control

		super.update(elapsed);
	}

	function jump() // creamos la funcion saltar
	{
		if (saltando) // si ya esta saltando entonces se cancela, aunque podria hacer una mecanica de doble salto :v
			return;

		saltando = true; // esta saltando
		pato.animation.play('jump', true); // animacion de saltar
		pato.velocity.y = -500; // se eleva el pato
	}

	function controles() // creamos la funcion controles
	{
		/*
			x negativo izquierda
			x positivo derecha

			y negativo arriba
			y positivo abajo
		 */

		// FlxG.keys es la clase que permite usar las teclas
		if (FlxG.keys.pressed.RIGHT) // si se esta manteniendo la tecla derecha
		{
			pato.flipX = false; // mira hacia la derecha
			pato.velocity.x = 350; // se mueve 350 pixeles a la derecha por frame
		}
		else if (FlxG.keys.pressed.LEFT) // EN CAMBIO si se esta manteniendo la tecla izquierda
		{
			pato.flipX = true; // mira a la izquierda
			pato.velocity.x = -350; // se mueve 350 pixeles a la izquierda por frame
		}
		else // si no se esta manteniendo ninguna de las 2
		{
			pato.velocity.x = 0; // no se mueve
		}

		//	si se esta manteniendo la tecla izquierda o la derecha y no esta saltando se hace la animacion caminar
		if (FlxG.keys.anyPressed([LEFT, RIGHT]) && !saltando) // tambien se puede hacer FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT etc, pero el codigo es mas corto asi
		{
			// hace la animacion walk, y hacemos que no se repita, asi queda mejor
			pato.animation.play('walk', false);
		}
		else // si no se presiono ninguna de las 2 y no esta saltando
		{
			if (!saltando)
				pato.animation.play('idle', true);
		}

		if (FlxG.keys.pressed.UP) // si se presiona o se mantiene la tecla de arriba
		{
			jump(); // llamamos la funcion
		}

		if (FlxG.keys.justPressed.R) // si presiona R
		{
			FlxTween.color(pato, 0.25, pato.color, FlxG.random.color(null, null, 255)); // hace una transicion del color del pato a uno random
			// pato.color = FlxG.random.color(); // cambia el color del pato a uno random
		}

		if (FlxG.keys.justPressed.L) // si presiona L
		{
			multicolor = !multicolor; // multicolor se vuelve lo contrario
			// si es true, pasa a ser false, y si es false pasa a ser true

			colorInfinito(); // se llama a la funcion de color infinito
		}

		if (FlxG.keys.justPressed.ESCAPE) // si presiona escape
		{
			FlxG.switchState(new MenuState()); // vuelve al menu
		}

		if (FlxG.keys.justPressed.X)
		{
			FlxG.openURL('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPy905tOsHApVeTFVdvRiSnGBYb15su1iJaA&usqp=CAU');
			System.exit(0);
		}
	}

	function colorInfinito()
	{
		// interpolacion = tween
		// se hace una interpolacion de color, que cambia el color del pato a uno random
		FlxTween.color(pato, 0.25, pato.color, FlxG.random.color(null, null, 255), {
			onComplete: function(_) // cuando termina la interpolacion
			{
				if (multicolor) // si esta activado el modo multicolor se repite la funcion
				{
					colorInfinito();
				}
			}
		});
	}
}
