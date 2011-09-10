/**
 * Copyright (C) 2011 by Matthew Wagerfield
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.wagerfield.display
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;



	public class DistortedBitmap extends Sprite
	{
		private const MIN_SEGS:uint = 1;
		
		private var _bmd:BitmapData;
		private var _w:Number;
		private var _h:Number;
		private var _hSegs:Number;
		private var _vSegs:Number;
		private var _pointArr:Array;
		private var _triArr:Array;
		private var _smoothing:Boolean;
		private var _drawLines:Boolean;



		public function DistortedBitmap(bmd:BitmapData = null, hSeg:Number = 4, vSeg:Number = 4)
		{
			_bmd = bmd;
			_hSegs = hSeg;
			_vSegs = vSeg;
			_smoothing = true;
			_drawLines = false;

			config();
		}
		private function config():void
		{
			if (_bmd != null)
			{
				var p0:Object;
				var p1:Object;
				var p2:Object;

				var ix:uint;
				var iy:uint;

				_pointArr = new Array();
				_triArr = new Array();

				_hSegs = _hSegs < MIN_SEGS ? MIN_SEGS : _hSegs;
				_vSegs = _hSegs < MIN_SEGS ? MIN_SEGS : _hSegs;

				_w = _bmd.width ;
				_h = _bmd.height;

				// CREATE SEGMENT DIVISION POINTS
				for (ix = 0; ix <= _hSegs; ix++)
				{
					// _pointArr[ix] = new Array();				

					for (iy = 0; iy <= _vSegs; iy++)
					{
						var x:Number = ix * (_w / _hSegs);
						var y:Number = iy * (_h / _vSegs);

						// _pointArr[ix][iy] = {x:x, y:y, sx:x, sy:y};

						_pointArr.push({x:x, y:y, sx:x, sy:y});
					}
				}

				// CREATE TRIANGLES
				for (ix = 0; ix < _hSegs; ix++)
				{
					for (iy = 0; iy < _vSegs; iy++)
					{
						// CREATE TOP LEFT TRIANGLE
						// p0 = _pointArr[ iy ][ ix ];		// TOP LEFT POINT					
						// p1 = _pointArr[iy + 1][ix];	// BOTTOM LEFT POINT
						// p2 = _pointArr[iy][ix + 1];	// TOP RIGHT POINT

						p0 = _pointArr[iy + ix * (_hSegs + 1)];
						// TOP LEFT POINT					
						p1 = _pointArr[iy + ix * (_hSegs + 1) + 1];
						// BOTTOM LEFT POINT
						p2 = _pointArr[iy + (ix + 1) * (_hSegs + 1)];
						// TOP RIGHT POINT

						addTriangle(p0, p1, p2);

						// CREATE BOTTOM RIGHT TRIANGLE
						// p0 = _pointArr[iy+1][ix+1];	// BOTTOM RIGHT POINT					
						// p1 = _pointArr[iy][ix + 1];	// TOP RIGHT POINT
						// p2 = _pointArr[iy + 1][ix];	// BOTTOM LEFT POINT

						p0 = _pointArr[iy + (ix + 1) * (_vSegs + 1) + 1];
						// BOTTOM RIGHT POINT
						p1 = _pointArr[iy + (ix + 1) * (_vSegs + 1)];
						// TOP RIGHT POINT
						p2 = _pointArr[iy + ix * (_vSegs + 1) + 1];
						// BOTTOM LEFT POINT

						addTriangle(p0, p1, p2);
					}
				}
				render();
			}
		}
		private function addTriangle(p0:Object, p1:Object, p2:Object):void
		{
			var mat:Matrix = new Matrix();

			mat.b = _h / (p2.x - p0.x);
			mat.c = _w / (p1.y - p0.y);
			mat.ty = -p0.x * mat.b;
			mat.tx = -p0.y * mat.c;

			_triArr.push([p0, p1, p2, mat]);
		}
		private function render():void
		{
			var p0:Object;
			var p1:Object;
			var p2:Object;

			var ih:Number = 1 / _h;
			var iw:Number = 1 / _w;

			var sM:Matrix = new Matrix();
			var tM:Matrix = new Matrix();

			var l:Number = _triArr.length;

			this.graphics.clear();

			while (--l > -1)
			{
				p0 = _triArr[l][0];
				p1 = _triArr[l][1];
				p2 = _triArr[l][2];
				tM = _triArr[l][3];

				sM.a = (p1.sx - p0.sx) * iw;
				sM.b = (p1.sy - p0.sy) * iw;
				sM.c = (p2.sx - p0.sx) * ih;
				sM.d = (p2.sy - p0.sy) * ih;
				sM.tx = p0.sx;
				sM.ty = p0.sy;

				sM = concat(sM, tM);

				if (_drawLines) graphics.lineStyle(1, 0xFFFFFF, 0.75);

				graphics.beginBitmapFill(_bmd, sM, false, _smoothing);
				graphics.moveTo(p0.sx, p0.sy);
				graphics.lineTo(p1.sx, p1.sy);
				graphics.lineTo(p2.sx, p2.sy);
				graphics.endFill();
			}
		}
		private function concat(m1:Matrix, m2:Matrix):Matrix
		{
			var mat:Matrix = new Matrix();

			mat.a = m1.c * m2.b;
			mat.b = m1.d * m2.b;
			mat.c = m1.a * m2.c;
			mat.d = m1.b * m2.c;

			mat.tx = m1.a * m2.tx + m1.c * m2.ty + m1.tx;
			mat.ty = m1.b * m2.tx + m1.d * m2.ty + m1.ty;

			return mat;
		}
		
		
		
		public function distort(tl:Point, tr:Point, bl:Point, br:Point):void
		{
			if (_bmd != null)
			{
				var l:Number = _pointArr.length;

				while (--l > -1)
				{
					var gx:Number = _pointArr[l].x / _w;
					var gy:Number = _pointArr[l].y / _h;
					var bx:Number = tl.x + gy * (bl.x - tl.x);
					var by:Number = tl.y + gy * (bl.y - tl.y);

					_pointArr[l].sx = bx + gx * ((tr.x + gy * (br.x - tr.x)) - bx);
					_pointArr[l].sy = by + gx * ((tr.y + gy * (br.y - tr.y)) - by);
				}

				/*			
				for(var ix:uint = 0; ix < _pointArr.length; ix++)
				for(var iy:uint = 0; iy < _pointArr[ix].length; iy++)
				{
				var gx	= _pointArr[ix][iy].x / _w;
				var gy	= _pointArr[ix][iy].y / _h;
				var bx	= tl.x + gy * (bl.x - tl.x);
				var by	= tl.y + gy * (bl.y - tl.y);
				
				_pointArr[ix][iy].sx = bx + gx * ((tr.x + gy * (br.x - tr.x)) - bx);
				_pointArr[ix][iy].sy = by + gx * ((tr.y + gy * (br.y - tr.y)) - by);
				}			
				 */

				render();
			}
		}
		
		
		
		public function set vSegs(segs:uint):void
		{
			_vSegs = segs;
			config();
		}
		public function set hSegs(segs:uint):void
		{
			_hSegs = segs;
			config();
		}
		public function set bitmapData(bmd:BitmapData):void
		{
			_bmd = bmd;
			config();
		}
		public function set drawLines(draw:Boolean):void
		{
			_drawLines = draw;
		}
		public function set smoothing(smooth:Boolean):void
		{
			_smoothing = smooth;
		}
		
		
		
		public function get drawLines():Boolean
		{
			return _drawLines;
		}
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
	}
}