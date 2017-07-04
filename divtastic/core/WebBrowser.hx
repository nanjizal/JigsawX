/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* originally part of my Divtastic and then refactored to browserhx
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

import js.Lib;
import js.Browser;
enum BrowserType
{
    Chrome;
    Safari;
    WebKitOther;
    FireFox;
    Opera;
    IE;
}

class WebBrowser
{
	
    private static var _browserType:    BrowserType;
	private static var _userAgent:		String;
	
    public static var browserType( get_browserType, null ): BrowserType;
    private static var _hasCanvas2d:	Bool;
	public static var hasCanvas2d( get_hasCanvas2d, null ): Bool;
    
	private static function get_hasCanvas2d(): Bool
	{
		
		if( _hasCanvas2d == null )
		{
			
			set_hasCanvas2d();
			
		}
		return _hasCanvas2d;
		
	}
	
	private static function set_hasCanvas2d()
	{
		
		if( Browser.document.createCanvasElement().getContext == null )
		{
			
			_hasCanvas2d = false;
			
		}
		else
		{
			
			_hasCanvas2d = true;
			
		}
		
	}
	
    private static function get_browserType(): BrowserType
    {
        
        if( _browserType == null )
        {
            
            set_browserType( Browser.window.navigator.userAgent );
            
        }
        
        return _browserType;
        
    }
    
	public static function traceAgent()
	{
		get_browserType();
		trace( _userAgent );
	}
    
    private static function set_browserType( agent: String ): BrowserType
    {
		
        _userAgent = agent;
		
        if( (~/WebKit/).match( agent ) )
        {
            
            if((~/Chrome/).match( agent ) )
            {
                
                _browserType = Chrome;
                
            }
            else if( (~/Safari/).match( agent ) )
            {
                
                _browserType = Safari;
                
            }
            else
            {
            
                _browserType = Opera;
            
            }
            
        }
        else if( (~/Opera/).match( agent ) )
        {
            //(__js__("typeof window!='undefined'") && window.opera != null );
            _browserType = Opera;
            
        }
        else if( (~/Mozilla/).match( agent ) )
        {
			 
			var isIE = untyped (__js__("typeof document!='undefined'") && document.all != null && __js__("typeof window!='undefined'") && window.opera == null );
            if ( isIE )
            {
                _browserType = IE;
            }
            else
            {
                _browserType = FireFox;
			}
        }
        else
        {
            _browserType = IE;
        }
        
        return _browserType;
        
    }
    
}
