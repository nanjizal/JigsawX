/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* created: 9 October 2013
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
import js.html.Event;
import js.Browser;
import js.html.Element;
import js.html.CSSStyleDeclaration;
class CSSenterFrame
{
    
    var onEnterFrame:    Void -> Void;

    public function new( onEnterFrame_: Void->Void )
    {
        onEnterFrame = onEnterFrame_;
        var s = Browser.document.createStyleElement();
        s.innerHTML = "@keyframes spin {  from { transform:rotate( 0deg ); } to { transform:rotate( 360deg ); } }";
        Browser.document.getElementsByTagName("head")[0].appendChild( s );
        //.addEventListener("animationiteration", onEnterFrame, false );
        (cast s).animation = "spin 1s linear infinite";
        loop( 60 );
    }
    
    
    private function loop( tim: Float ):Bool
    {
        Browser.window.requestAnimationFrame( loop );
        onEnterFrame( );
        return true;
    }
    
}
