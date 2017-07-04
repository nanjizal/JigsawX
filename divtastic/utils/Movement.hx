/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* originally part of my Divtastic
* created 1 Septemeber 2011
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

class Movement
{
    
    // See this link for more information...
    // http://jonmanatee.blogspot.com/2011/03/moving-beyond-linear-bezier.html
    // you just need to use one for each axis..
    // see http://www.codng.com/2005/07/intersecting-quadcurve2d-part-ii.html
    // and then modify it to go through the point I think penner has a curveThru
    // for instance see my code here:
    // http://forums.swishzone.com/index.php?s=d8b09993f33ccb9361b069fda0bbae89&showtopic=923
    // 
    public static function quadraticBezierThru  (   t:            Float
                                                ,   startPoint:   Float
                                                ,   controlPoint: Float
                                                ,   endPoint:     Float
                                                )
    {
        
        var newControlPoint = ( 2*controlPoint ) - .5*( startPoint + endPoint );
        var u = 1 - t;
        return  Math.pow( u, 2) * startPoint + 2 * u * t * newControlPoint + Math.pow( t, 2 ) * endPoint; 
        
    }
    
    
    public static function quadraticBezier  (   t:                  Float
                                                ,   startPoint:     Float
                                                ,   controlPoint:   Float
                                                ,   endPoint:       Float
                                                )
    {
        
        var u = 1 - t;
        return  Math.pow( u, 2) * startPoint + 2 * u * t * controlPoint + Math.pow( t, 2 ) * endPoint; 
        
    }
    
    
    public static function cubicBezier( t:                Float
                                , startPoint:       Float
                                , controlPoint1:    Float
                                , controlPoint2:    Float
                                , endPoint:         Float 
                                ) 
    {
        
        var u = 1 - t;
        
        return  Math.pow( u, 3 ) * startPoint + 3 * Math.pow( u, 2 ) * t * controlPoint1 +
                3* u * Math.pow( t, 2 ) * controlPoint2 + Math.pow( t, 3 ) * endPoint;
                
    }
    
    
}


