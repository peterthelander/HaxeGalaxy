
/*
 */

package;

import flash.display.StageScaleMode;
import flash.display.StageDisplayState;
import flash.accessibility.Accessibility;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Matrix;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.ui.Keyboard;

class Matrix4x4
{
	public var x11 : Float; public var x12 : Float; public var x13 : Float; public var x14 : Float;
	public var x21 : Float; public var x22 : Float; public var x23 : Float; public var x24 : Float;
	public var x31 : Float; public var x32 : Float; public var x33 : Float; public var x34 : Float;
	public var x41 : Float; public var x42 : Float; public var x43 : Float; public var x44 : Float;

	public function new()
	{
		setIdentity();
	}
	
	public function setIdentity()
	{
		x11 = 1; x12 = 0; x13 = 0; x14 = 0;
		x21 = 0; x22 = 1; x23 = 0; x24 = 0;
		x31 = 0; x32 = 0; x33 = 1; x34 = 0;
		x41 = 0; x42 = 0; x43 = 0; x44 = 1;
	}
	
	public function multiply(l : Matrix4x4)
	{
		var n11 = l.x11 * x11 + l.x12 * x21 + l.x13 * x31 + l.x14 * x41;
		var n12 = l.x11 * x12 + l.x12 * x22 + l.x13 * x32 + l.x14 * x42;
		var n13 = l.x11 * x13 + l.x12 * x23 + l.x13 * x33 + l.x14 * x43;
		var n14 = l.x11 * x14 + l.x12 * x24 + l.x13 * x34 + l.x14 * x44;
		
		var n21 = l.x21 * x11 + l.x22 * x21 + l.x23 * x31 + l.x24 * x41;
		var n22 = l.x21 * x12 + l.x22 * x22 + l.x23 * x32 + l.x24 * x42;
		var n23 = l.x21 * x13 + l.x22 * x23 + l.x23 * x33 + l.x24 * x43;
		var n24 = l.x21 * x14 + l.x22 * x24 + l.x23 * x34 + l.x24 * x44;
		
		var n31 = l.x31 * x11 + l.x32 * x21 + l.x33 * x31 + l.x34 * x41;
		var n32 = l.x31 * x12 + l.x32 * x22 + l.x33 * x32 + l.x34 * x42;
		var n33 = l.x31 * x13 + l.x32 * x23 + l.x33 * x33 + l.x34 * x43;
		var n34 = l.x31 * x14 + l.x32 * x24 + l.x33 * x34 + l.x34 * x44;
		
		var n41 = l.x41 * x11 + l.x42 * x21 + l.x43 * x31 + l.x44 * x41;
		var n42 = l.x41 * x12 + l.x42 * x22 + l.x43 * x32 + l.x44 * x42;
		var n43 = l.x41 * x13 + l.x42 * x23 + l.x43 * x33 + l.x44 * x43;
		var n44 = l.x41 * x14 + l.x42 * x24 + l.x43 * x34 + l.x44 * x44;
		
		x11 = n11; x12 = n12; x13 = n13; x14 = n14;
		x21 = n21; x22 = n22; x23 = n23; x24 = n24;
		x31 = n31; x32 = n32; x33 = n33; x34 = n34;
		x41 = n41; x42 = n42; x43 = n43; x44 = n44;
	}
	
}

class Matrix4x1
{
	public var x1 : Float;
	public var x2 : Float;
	public var x3 : Float;
	public var x4 : Float;
	
	public function new(x : Float, y : Float, z : Float)
	{
		x1 = x; x2 = y; x3 = z; x4 = 1;
	}

	public function multiply(l : Matrix4x4)
	{
		var n1 = l.x11 * x1 + l.x12 * x2 + l.x13 * x3 + l.x14 * x4;
		var n2 = l.x21 * x1 + l.x22 * x2 + l.x23 * x3 + l.x24 * x4;
		var n3 = l.x31 * x1 + l.x32 * x2 + l.x33 * x3 + l.x34 * x4;
		var n4 = l.x41 * x1 + l.x42 * x2 + l.x43 * x3 + l.x44 * x4;
		
		x1 = n1;
		x2 = n2;
		x3 = n3;
		x4 = n4;
	}
}

class Actor
{
	public var position : Matrix4x1;
	public var index : Int;
	
	public function new(x : Float, y : Float, z : Float, index : Int) 
	{ 
		position = new Matrix4x1(x, y, z);
		this.index = index;
	}
}

class LinkedActor
{
	public var actor : Actor;
	public var next : LinkedActor;
	
	public function new(a, n) { this.actor = a; this.next = n; }
}

class InfoTextField extends TextField
{
	public function new(x : Int, y : Int)
	{
		super();
		autoSize = TextFieldAutoSize.LEFT;
		defaultTextFormat = new TextFormat("Verdana", 18, 0x80ff80);
		Lib.current.addChild(this);
		this.x = x;
		this.y = y;
	}
}

class Main extends Shape
{
	var actors : LinkedActor;
	
	var eyePosition : Matrix4x4;
	var eyeVelocity : Matrix4x4;
	var turnM : Matrix4x4;
	var position4x1 : Matrix4x1;
	var px : Float;
	var py : Float;
	var opx : Float;
	var opy : Float;
	var pvisible : Bool;
	var rx : Float;
	var ry : Float;
	var rz : Float;
	
	var ptop : Matrix4x1;
	var pbottom : Matrix4x1;
	var pleft : Matrix4x1;
	var pright : Matrix4x1;
	var pfront : Matrix4x1;
	var pback : Matrix4x1;
	var ctopfront : Matrix4x1;
	var ctopback : Matrix4x1;
	var ctopright : Matrix4x1;
	var ctopleft : Matrix4x1;
	var cbottomfront : Matrix4x1;
	var cbottomback : Matrix4x1;
	var cbottomleft : Matrix4x1;
	var cbottomright : Matrix4x1;
	var cfrontright : Matrix4x1;
	var cfrontleft : Matrix4x1;
	var cbackright : Matrix4x1;
	var cbackleft : Matrix4x1;
	
	var numStars : UInt;
	
	var textfield1 : InfoTextField;
	var textfield2 : TextField;
	var textfield3 : TextField;
	var textfield4 : TextField;
	var textfield5 : TextField;
	var textfield6 : TextField;
	var textfield7 : TextField;
	var textfield8 : TextField;

	var numStarTypes : UInt;
	var bmd0 : BitmapData;
	var bmd1 : BitmapData;
	var bmd2 : BitmapData;
	var bmd3 : BitmapData;
	
	var mat : Matrix;
	
	var frameNum : UInt;
	var framesPerSecond : UInt;
	
	// keyboard state
	var keyForward : Bool;
	var keyBackward : Bool;
	var keyStrafeLeft : Bool;
	var keyStrafeRight : Bool;
	var keyRollLeft : Bool;
	var keyRollRight : Bool;
	
	// rate of turn, in degrees per second
	var pitch : Float;
	var yaw : Float;
	var roll : Float;
	
	function new()
	{		
		super(); // thanks for asking!
		
		framesPerSecond = 30;
		
		numStarTypes = 4;
		bmd0 = filter(0);
		bmd1 = filter(1);
		bmd2 = filter(2);
		bmd3 = filter(3);
		
		/*
		viewRange = 100; // in light years, the depth of the observed volume of space
		var viewVolume = Math.pow(viewRange, 3); // volume observed in cubic light years
		
		// In the real universe, there are 65 stars within 16.3 light years of the earth
		var starDensity = 65 / (4/3 * Math.PI * Math.pow(16.308, 3)); 

		numStars = Math.floor(viewVolume * starDensity);
		*/
		numStars = 20;
		var galaxyDiameter = 20; // actual diameter is 100,000 ly
		var galaxyThickness = 0.5; // actual thickness is 1,000 ly
		
		var count = 0;
		actors = null;
		var last : LinkedActor = null;
		while (count++ < numStars)
		{
			var radiusRand = Math.random();
			var thetaRand = Math.random();
			
			var theta = thetaRand * Math.PI * 2;
			var radius = radiusRand * galaxyDiameter / 2;
			var height = Math.random() * galaxyThickness - galaxyThickness / 2;
			
			var starSelectorRand = Math.random();
			var starSelector : UInt;
			if (starSelectorRand < (1-radiusRand)*0.7)
				starSelector = 0;
			else if (starSelectorRand < (1-radiusRand))
				starSelector = 1;
			else if (starSelectorRand < (1-radiusRand)*1.8)
				starSelector = 2;
			else
				starSelector = 3;
			
			var x = radius * Math.cos(theta);
			var y = height;
			var z = radius * Math.sin(theta);
			
			actors = new LinkedActor(
				new Actor(x, y, z, starSelector),
				actors
			);
			if (last == null)
				last = actors;
		}
		last.next = actors; // complete the circle
		
		eyePosition = new Matrix4x4();
		eyeVelocity = new Matrix4x4();
		
		eyeVelocity.x14 = 1;
		eyeVelocity.x24 = 1.5;
		eyeVelocity.x34 = 5;
		eyePosition.multiply(eyeVelocity);
		eyeVelocity.setIdentity();
		
		turnM = new Matrix4x4();
		position4x1 = new Matrix4x1(0, 0, 0);
		
		ptop    = new Matrix4x1( 0,  1,  0);
		pbottom = new Matrix4x1( 0, -1,  0);
		pleft   = new Matrix4x1(-1,  0,  0);
		pright  = new Matrix4x1( 1,  0,  0);
		pfront  = new Matrix4x1( 0,  0,  1);
		pback   = new Matrix4x1( 0,  0, -1);
		
		ctopfront   = new Matrix4x1( 0,  1,  1);
		ctopback    = new Matrix4x1( 0,  1, -1);
		ctopleft    = new Matrix4x1(-1,  1,  0);
		ctopright   = new Matrix4x1( 1,  1,  0);
		cbottomfront= new Matrix4x1( 0, -1,  1);
		cbottomback = new Matrix4x1( 0, -1, -1);
		cbottomleft = new Matrix4x1(-1, -1,  0);
		cbottomright= new Matrix4x1( 1, -1,  0);
		cfrontright = new Matrix4x1( 1,  0,  1);
		cfrontleft  = new Matrix4x1(-1,  0,  1);
		cbackright  = new Matrix4x1( 1,  0, -1);
		cbackleft   = new Matrix4x1(-1,  0, -1);
		
		mat = new Matrix();

		frameNum = 0;
		
		var y : Int = 0;
		textfield1 = new InfoTextField(20, y+=20);
		textfield2 = new InfoTextField(20, y+=20);
		textfield3 = new InfoTextField(20, y+=20);
		textfield4 = new InfoTextField(20, y+=20);
		textfield5 = new InfoTextField(20, y+=20);
		textfield6 = new InfoTextField(20, y+=20);
		textfield7 = new InfoTextField(20, y+=20);
		textfield8 = new InfoTextField(20, y+=20);

		Lib.current.addChild(this);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		keyForward = false;
		keyBackward = false;
		keyStrafeLeft = false;
		keyStrafeRight = false;
		keyRollLeft = false;
		keyRollRight = false;
	}
	
	/*
	function assetToBitmapData(name : String) : BitmapData
	{
		var mc : MovieClip = Lib.attach(name);
		var bmd = new BitmapData(Math.floor(mc.width), Math.floor(mc.height), true, 0x00000000);
		bmd.draw(mc);
		return bmd;
	}
	*/
	
	function filter(col : Int) : BitmapData
	{
		var w = 100; // bmd.width;
		var h = 100; // bmd.height;
		
		var bmd = new BitmapData(w, h);
		
		var x = 0;
		while (x < w)
		{
			var y = 0;
			while (y < h)
			{
				var pixelValue : UInt; // = bmd.getPixel32(x, y);
				
				var r1 : UInt;
				var r2 : UInt;
				var g1 : UInt;
				var g2 : UInt;
				var b1 : UInt;
				var b2 : UInt;
				
				if (col == 0)
				{
					r1 = 0xff; g1 = 0xff; b1 = 0xff; // white
					r2 = 0xff; g2 = 0xff; b2 = 0x80; // light yellow
				}
				else if (col == 1)
				{
					r1 = 0xff; g1 = 0xff; b1 = 0x00; // yellow
					r2 = 0xff; g2 = 0x80; b2 = 0x00; // orange
				}
				else if (col == 2)
				{
					r1 = 0xff; g1 = 0x00; b1 = 0x00; // red
					r2 = 0xff; g2 = 0x00; b2 = 0x00; // red
				}
				else if (col == 3)
				{
					r1 = 0x80; g1 = 0x80; b1 = 0xff; // light blue
					r2 = 0x00; g2 = 0x00; b2 = 0xff; // blue
				}
				
				var alphaValue:UInt = pixelValue >> 24 & 0xFF;
				var red:UInt = pixelValue >> 16 & 0xFF;
				var green:UInt = pixelValue >> 8 & 0xFF;
				var blue:UInt = pixelValue & 0xFF;
				
				var pixx = x - Math.floor(w / 2);
				var pixy = y - Math.floor(h / 2);
				var radius = Math.sqrt(pixx * pixx + pixy * pixy);
				var rmax = w/2;
				
				var edge = rmax / 4;
				
				if (radius > rmax)
				{
					alphaValue = 0;
				}
				else if (radius > edge)
				{
					var liner = (radius - edge) / (rmax - edge);
					
					red   = Math.floor((1 - liner) * r1 + liner * r2);
					green = Math.floor((1 - liner) * g1 + liner * g2);
					blue  = Math.floor((1 - liner) * b1 + liner * b2);
					
					alphaValue = Math.floor((1 - liner) * 0xe0);
				}
				else
				{
					red = 0xff;
					green = 0xff;
					blue = 0xff;
					alphaValue = 0xff;					
				}

				pixelValue = (alphaValue << 24) + (red << 16) + (green << 8) + blue;

				bmd.setPixel32(x, y, pixelValue);
				y++;
			}
			x++;
		}
		return bmd;
	}
	
	function onKeyEvent(key : String, keyDown : Bool)
	{
		if (key == "w")			keyForward = keyDown;
		else if (key == "s")	keyBackward = keyDown;
		else if (key == "a")	keyStrafeLeft = keyDown;
		else if (key == "d")	keyStrafeRight = keyDown;
		else if (key == "q")	keyRollLeft = keyDown;
		else if (key == "e")	keyRollRight = keyDown;
			
		/*
		if (key == "f" && keyDown)
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
		if (key == "g" && keyDown)
			stage.displayState = StageDisplayState.NORMAL;
		*/
	}
	
	function onKeyDown(event:KeyboardEvent)
	{
		onKeyEvent(String.fromCharCode(event.charCode), true);
	}

	function onKeyUp(event:KeyboardEvent)
	{
		onKeyEvent(String.fromCharCode(event.charCode), false);
	}

	function shorten(number : Float) : String
	{
		var result : String = "" + number;
		result = result.substr(0, 5);
		return result;
	}
	
	function moveEye()
	{
		eyeVelocity.setIdentity();
		
		var speed = 0.05;

		if (keyForward)		eyeVelocity.x34 += -speed;
		if (keyBackward)	eyeVelocity.x34 += speed;
		if (keyStrafeLeft)	eyeVelocity.x14 += speed;
		if (keyStrafeRight)	eyeVelocity.x14 += -speed;
			
		// translate (and accumulate) by the vel matrix
		eyePosition.multiply(eyeVelocity);

		yaw = -(mouseX - stage.stageWidth/2)/10;
		var yawRadiansPerFrame = yaw / 360 * Math.PI * 2 / framesPerSecond;
		var cs = Math.cos(yawRadiansPerFrame);
		var sn = Math.sin(yawRadiansPerFrame);
		
		turnM.setIdentity();
		turnM.x11 = cs;
		turnM.x31 = -sn;
		turnM.x13 = sn;
		turnM.x33 = cs;
		eyePosition.multiply(turnM);

		// pitch turn (and accum)
		pitch = (mouseY - stage.stageHeight/2)/10;
		var pitchRadiansPerFrame = pitch / 360 * Math.PI * 2 / framesPerSecond;
		var cs = Math.cos(pitchRadiansPerFrame);
		var sn = Math.sin(pitchRadiansPerFrame);
		
		turnM.setIdentity();
		turnM.x22 = cs;
		turnM.x23 = -sn;
		turnM.x32 = sn;
		turnM.x33 = cs;
		eyePosition.multiply(turnM);
		
		roll = 0;
		if (keyRollLeft)
			roll += 15;
		if (keyRollRight)
			roll -= 15;
		var rollRadiansPerSecod = roll * Math.PI * 2 /360 / framesPerSecond;
			
		// roll turn (and accum)
		var cs = Math.cos(rollRadiansPerSecod);
		var sn = Math.sin(rollRadiansPerSecod);
		
		turnM.setIdentity();
		turnM.x11 = cs;
		turnM.x12 = -sn;
		turnM.x21 = sn;
		turnM.x22 = cs;
		eyePosition.multiply(turnM);

	}
	
	function render(p : Matrix4x1)
	{
		position4x1.x1 = p.x1;
		position4x1.x2 = p.x2;
		position4x1.x3 = p.x3;
		position4x1.x4 = p.x4;
		
		position4x1.multiply(eyePosition);
			
		rx = position4x1.x1;
		ry = position4x1.x2;
		rz = position4x1.x3;
			
		if (rz > 0)
		{
			opx = px;
			opy = py;
			
			px = rx * stage.stageWidth / rz * 0.8 + stage.stageWidth/2;
			py = ry * stage.stageWidth / rz * 0.8 + stage.stageHeight/2;
				
			if (px > 0 && px < stage.stageWidth &&
				py > 0 && py < stage.stageHeight)
			{
				pvisible = true;
			}
			else
			{
				pvisible = false;
			}
		}
		else
		{
			pvisible = false;
		}
	}

	function drawPlanet()
	{
		var alpha : Float = 0.4;
		
		graphics.beginFill(0x00ff00, alpha);
		render(pbottom); graphics.moveTo(px, py);
		render(cbottomfront); render(pfront); graphics.curveTo(opx, opy, px, py);
		render(cfrontright); render(pright); graphics.curveTo(opx, opy, px, py);
		render(cbottomright); render(pbottom); graphics.curveTo(opx, opy, px, py);
		graphics.endFill();
		/*
		graphics.beginFill(0x00ff00, alpha);
		render(pbottom); graphics.moveTo(px, py);
		render(pright);	graphics.lineTo(px, py);
		render(pback);	graphics.lineTo(px, py);
		graphics.endFill();
		
		graphics.beginFill(0x0000ff, alpha);
		render(pbottom); graphics.moveTo(px, py);
		render(pback);	graphics.lineTo(px, py);
		render(pleft);	graphics.lineTo(px, py);
		graphics.endFill();
		
		graphics.beginFill(0xffff00, alpha);
		render(pbottom); graphics.moveTo(px, py);
		render(pleft);	graphics.lineTo(px, py);
		render(pfront);	graphics.lineTo(px, py);
		graphics.endFill();
*/		
		
		graphics.beginFill(0xff0000, alpha);
		render(ptop); graphics.moveTo(px, py);
		render(ctopfront); render(pfront); graphics.curveTo(opx, opy, px, py);
		render(cfrontright); render(pright); graphics.curveTo(opx, opy, px, py);
		render(ctopright); render(ptop); graphics.curveTo(opx, opy, px, py);
		graphics.endFill();
		
		graphics.beginFill(0x0000ff, alpha);
		render(ptop); graphics.moveTo(px, py);
		render(ctopright); render(pright); graphics.curveTo(opx, opy, px, py);
		render(cbackright); render(pback); graphics.curveTo(opx, opy, px, py);
		render(ctopback); render(ptop); graphics.curveTo(opx, opy, px, py);
		graphics.endFill();
/*		
		graphics.beginFill(0xffff00, alpha);
		render(ptop); graphics.moveTo(px, py);
		render(pback);	graphics.lineTo(px, py);
		render(pleft);	graphics.lineTo(px, py);
		graphics.endFill();
		
		graphics.beginFill(0xffffff, alpha);
		render(pfront);	graphics.moveTo(px, py);
		render(ptop);   graphics.curveTo(cx, cy, px, py); //graphics.lineTo(px, py);
		render(pleft);	graphics.lineTo(px, py);
		graphics.endFill();
		*/
	}
	
	function drawStars()
	{
		var visibleStars = 0;
		
		var selected : LinkedActor;
		var bestSelectionDistance : Float = 0.0;
		var selectedX : Float;
		var selectedY : Float;
		
		var index = 0;
		var actorIter = actors;
		var previous : LinkedActor = null;
		while (index < numStars)
		{
			var actor = actorIter.actor;
			
			
			position4x1.x1 = actor.position.x1;
			position4x1.x2 = actor.position.x2;
			position4x1.x3 = actor.position.x3;
			position4x1.x4 = 1;
			
			var r = Math.sqrt(
				actor.position.x1 * actor.position.x1 + 
				actor.position.x3 * actor.position.x3);

			if (r > 0)
			{
				actor.position.x3 += position4x1.x1 / 200 / r;
				actor.position.x1 -= position4x1.x3 / 200 / r;
				//actor.position.x1 *= 0.9999;
				//actor.position.x3 *= 0.9999;
			}
			
			render(actor.position);
			
			if (pvisible)
			{
				visibleStars++;
			
				var size = 60 / rz;
					
				var bmd : BitmapData;
				
				var starSelector = actor.index;
				if (starSelector == 0)
					bmd = bmd0; // white
				else if (starSelector == 1)
					bmd = bmd1; // yellow
				else if (starSelector == 2)
					bmd = bmd2; // red
				else
					bmd = bmd3; // blue

				mat.identity();
				mat.scale(size/bmd.width, size/bmd.width);
				
				mat.translate( -size/2, -size/2);
				//if (selection == 4)
				//	mat.rotate(eyeRotation + Math.PI * 2 * actor.index / numStars);
				mat.translate(px, py);
				
				graphics.beginBitmapFill(bmd, mat, false);
				graphics.drawRect(px - size/2, py - size/2, size, size);
				graphics.endFill();
				
				var selectionDistance = ((px-mouseX) * (px-mouseX) + (py-mouseY) * (py-mouseY));
				if (bestSelectionDistance == 0 ||
					bestSelectionDistance > selectionDistance)
				{
					bestSelectionDistance = selectionDistance;
					selectedX = px;
					selectedY = py;
				}					
			}

			previous = actorIter;
			actorIter = actorIter.next;
			index ++;
		}
		
		/*
		var size = 50;
		graphics.beginFill(0x00ff20, 0.5);
		graphics.drawRect(selectedX - size/2, selectedY - size/2, size, size);
		graphics.endFill();
		*/
		
		/*
		//var speed = (stage.stageHeight - mouseY) / 100; // light years per second
		//var speedText : String = "" + speed;
		//speedText = speedText.substr(0, 5);
		textfield1.text = "(" + 
			shorten(eyePosition.x11) + ", " + 
			shorten(eyePosition.x12) + ", " +
			shorten(eyePosition.x13) + ", " +
			shorten(eyePosition.x14) + ",";
			
		textfield2.text = " " + 
			shorten(eyePosition.x21) + ", " + 
			shorten(eyePosition.x22) + ", " +
			shorten(eyePosition.x23) + ", " +
			shorten(eyePosition.x24) + ",";
			
		textfield3.text = " " + 
			shorten(eyePosition.x31) + ", " + 
			shorten(eyePosition.x32) + ", " +
			shorten(eyePosition.x33) + ", " +
			shorten(eyePosition.x34) + ",";
			
		textfield4.text = " " + 
			shorten(eyePosition.x41) + ", " + 
			shorten(eyePosition.x42) + ", " +
			shorten(eyePosition.x43) + ", " +
			shorten(eyePosition.x44) + ")";
			
		textfield5.text = "VisibleStars=" + visibleStars;
			
		//eyePosition.z += speed/30; // 30 frames per second
		//eyeRotation += (mouseX - stage.stageWidth/2) / 10000;
		
		textfield6.text = "Pitch: " + pitch + " deg/sec";
		textfield7.text = "Yaw: " + yaw + " deg/sec";
		textfield8.text = "Roll: " + roll + " deg/sec";
		*/
	
	}
	
	function onEnterFrame(event : Event)
	{
		graphics.clear();
		
		frameNum++;
//		if (frameNum % 100 == 0)
//			trace("frameNum");

		moveEye();

		drawStars();
		
		drawPlanet();
	}
	
	static function main()
	{
		var m = new Main();
	}
}
