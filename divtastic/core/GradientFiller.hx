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
package core;
import js.html.DivElement;
import js.html.CSSStyleDeclaration;
class GradientFiller
{
    
    private var _grads:     List<DivElement>;
    private var _tot:       Int;
    private var _c0:        Int;
    private var _c1:        Int;
    private var _c0r:       Int;
    private var _c0g:       Int;
    private var _c0b:       Int;
    private var _c1r:       Int;
    private var _c1g:       Int;
    private var _c1b:       Int;
    
    public function setGrads( grads_: List<DivElement> )
    {
        
        _grads  = grads_;
        _tot    = _grads.length;
        
    }
    
    public function new( ?grads_: List<DivElement> )
    {
        if( grads_ != null )
        {
            _grads  = grads_;
            _tot    = _grads.length;
        }
    }
    
    
    public function fill( c0_: Int, ?c1_: Int )
    {
        if( c1_ != null && c0_ != c1_ )
        {
            _c0     = c0_;
            _c1     = c1_;
            _c0r    = ( _c0 >> 16);
            _c0g    = ( _c0 >> 8 & 0xff);
            _c0b    = ( _c0 & 0xff );
            _c1r    = ( _c1 >> 16);
            _c1g    = ( _c1 >> 8 & 0xff);
            _c1b    = ( _c1 & 0xff );
            
            var newInt: List<DivElement> = Lambda.mapi( _grads, colorMap );
            
        } 
        else
        {
            
            Lambda.map( _grads, 
                function( div: DivElement )
                {
                    div.style.backgroundColor = '#' + StringTools.lpad( StringTools.hex( (c0_ >> 16) << 16 | ( c0_ >> 8 & 0xff) << 8 | ( c0_ & 0xff ) ), '0', 6 ); 
                }
            );
            
        }
        
    }
    
    
    private function colorMap( i:Int,  grad: DivElement ):DivElement
    {
        
        var t:          Float   = i*1/_tot;
        var __style:    CSSStyleDeclaration   = grad.style;
        
        __style.backgroundColor = '#' + StringTools.lpad( StringTools.hex( cast(_c0r+(_c1r-_c0r)*t) << 16 | cast(_c0g+(_c1g-_c0g)*t) << 8 | cast(_c0b+(_c1b-_c0b)*t) ), '0', 6 );
        
        return grad;
        
    }
    
}