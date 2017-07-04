/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* created: 12 Dec 2012
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
import js.Browser;
import js.html.Element;
import js.html.CSSStyleDeclaration;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Element;
import js.html.BodyElement;
import js.html.ImageElement;

class SetupCanvas
{
    
    public var surface:     CanvasRenderingContext2D;
    public var dom:         Element;
    public var image:       ImageElement;
    public var canvas:      CanvasElement;
    public var style:       CSSStyleDeclaration;
    public var body:        Element;
    public function new( ?wid: Int = 1024, ?hi: Int = 768 )
    {
        canvas                      = Browser.document.createCanvasElement();
        dom                         = cast canvas;
        body                        = Browser.document.body;
        surface                     = canvas.getContext2d();
        style                       = dom.style;
        canvas.width                = wid;
        canvas.height               = hi;
        style.paddingLeft           = "0px";
        style.paddingTop            = "0px";
        style.left                  = Std.string( 0 + 'px' );
        style.top                   = Std.string( 0 + 'px' );
        style.position              = "absolute";
        image                       = cast dom;
    }
}