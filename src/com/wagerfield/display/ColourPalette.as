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
	/**
	 * @author Matthew Wagerfield
	 */
	public class ColourPalette
	{
		public static const SLATE:uint = 0;



		public static function colourA(palette:uint):uint
		{
			switch (palette)
			{
				case SLATE:
					return 0x050505;
					break;
				default:
					return 0x000000;
					break;
			}
		}
		public static function colourB(palette:uint):uint
		{
			switch (palette)
			{
				case SLATE:
					return 0x1A1A1A;
					break;
				default:
					return 0x000000;
					break;
			}
		}
		public static function colourC(palette:uint):uint
		{
			switch (palette)
			{
				case SLATE:
					return 0x2A2A2A;
					break;
				default:
					return 0x000000;
					break;
			}
		}
		public static function colourD(palette:uint):uint
		{
			switch (palette)
			{
				case SLATE:
					return 0x5C5C5C;
					break;
				default:
					return 0x000000;
					break;
			}
		}
		public static function colourE(palette:uint):uint
		{
			switch (palette)
			{
				case SLATE:
					return 0xEEEEEE;
					break;
				default:
					return 0x000000;
					break;
			}
		}
	}
}