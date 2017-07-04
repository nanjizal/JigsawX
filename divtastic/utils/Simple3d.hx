/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* ported and update to haxe3: 2 April 2012
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* * Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
* * Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
* * Neither the name of the Justinfront Ltd nor the
* names of its contributors may be used to endorse or promote products
* derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY Justinfront Ltd ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Justinfront Ltd BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package utils;
typedef Point2D = 
{
    var x: Float;
    var y: Float;
}
typedef Point3D = 
{
    > Point2D,
    var z : Float;
}

class Simple3D
{
    public static inline var fl: Float = 420;
    
	public function new()
	{
		
	}
	
	public static inline function scale( z: Float )
	{
	    return 1-(-z)/fl;
	}
	
	public static inline function twoD( p: Point3D ): Point2D
	{
	    var s = scale( p.z );
	    return { x: p.x/s, y: p.y/s };
	}
	
	public static inline function rgbTwoD( rgb: Array<Float>, offSet: Point2D ): Point2D
	{
	    var s = scale( rgb[2] );
	    return { x: rgb[0]/s + offSet.x, y: rgb[1]/s + offSet.y };
	}
	
}
