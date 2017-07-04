/*
* Divtastic3
* Copyright (c) 2011 to 2013, Justinfront Ltd
* author: Justin L Mills
* email: JLM at Justinfront dot net
* originally part of my zpartanlite
* created: 28 November 2011
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
package zpartanlite;

class DispatchTo
{
    
    // don't use an array unless there are lots of signals.
    // have to return dynamic because sometimes need to allow a return type not void
    private var func0:                          Void -> Void ;
    private var times0:                         Int;
    
    private var func:                           Array<Void -> Void> ;
    private var times:                          Array<Int> ;
    public var length( get_length, null ):      Int ;
    
    // Allows events like mouse down to be added removed.
    public var tellEnabled:                     Void -> Void;
    public var tellDisabled:                    Void -> Void;
    public var kill:                            Void -> Void;
    
    public function enableKill()
    {
        
        kill = killAll;
        
    }
    
    public function disableKill()
    {
        
        kill = function()
        {
            trace("Can't kill other listeners unless enableKill");
        }
        
    }
    
    private function get_length(): Int
    {
        
        if( func == null )
        if( func0 != null )
        {
            
            return 1;
            
        }
        else
        {
            return null;
        }
        
        return func.length;
        
    }
    
    
    public function new()
    {
        
        // by default...
        disableKill();
        
    }
    
    
    public function add( f_: Void -> Void, ?once: Bool, ?amount: Int )
    {
        
        // Store first...
        
        if( length == null )
        {
            
            func0 = f_;
            if( tellEnabled != null )
            {
                tellEnabled();
            }
            if( once != null )
            {
                
                if( once == true )
                {
                    
                    times0 = 1;
                    
                }
                else
                {
                    
                    times0 = -1;
                    
                }
                
            }
            else if( amount != null )
            {
                
                times0 = amount;
                
            }
            else
            {
                times0 = -1;
            }
            
            return;
            
        }
        else if( func == null )
        {
            
            func    = new Array() ;
            times   = new Array() ;
            func.push( func0 );
            times.push( times0 );
            func0 = null;
            times0 = null;
        }
        
        // Store second... 
        
        func.push( f_ ) ;
        
        if( once != null )
        {
            
            if( once == true )
            {
                
                times.push( 1 ) ;
                
            }
            else
            {
                
                times.push( -1 ) ;
                
            }
            
        }
        else if( amount != null )
        {
            
            times.push( amount ) ;
            
        }
        else
        {
            
            times.push( -1 ) ;
            
        }
        
    }
    
    
    public function swap( current_: Void -> Void, new_: Void -> Void  )
    {
        
        remove( current_ );
        add( new_ );
        
    }
    
    
    public function remove( f_: Void -> Void )
    {
        
        if( length == null ) return;
        if( length == 1  )
        {
            
            if( Reflect.compareMethods( f_, func0 ) )
            {
                
                func0   = null;
                times0  = null;
                if( tellDisabled != null )
                {
                    
                    tellDisabled();
                    
                }
            }
            return;
        }
        for( i in 0...func.length )
        {
            
            if( Reflect.compareMethods( func[ i ], f_ ) )
            {
                
                func.splice( i, 1 ) ;
                times.splice( i, 1 ) ;
                
            }
            
        }
        if( length == 1 )
        {
            func0   = func[0];
            times0  = times[0];
            func    = null;
            times0  = null;
        }
    }
    
    // This is private by default and accessed by kill if enableKill
    // seems over the top but should not be able to remove all listeners by default
    // only in special cases.
    private function killAll()
    {
        
        if( length == 1 )
        {
            
            func0   = null;
            times0  = null;
            return;
            
        }
        
        for( i in 0...func.length )
        {
            
            func.splice( i, 1 ) ;
            times.splice( i, 1 ) ;
            
        }
        func    = new Array() ;
        times   = new Array() ;
        
    }
    
    
    public function dispatch()
    {
        
        if( length == null ) return;
        var count: Int ;
        
        if( length == 1 )
        {
            
            func0();
            if( times0 == -1 )
            {
                // don't remove if -1 as implies infinite Signal use until removed.
            }
            else
            {
                times0--;
                if( times0 == 0 )
                {
                    remove( func0 );
                }
            }
            return;
        }
        
        for( i in 0...func.length )
        {
            
            func[ i ]() ;
            count       = times[ i ] ;
            
            if( count == -1 )
            {
                
                // don't remove if -1 as implies infinite Signal use until removed.
                
            }
            else
            {
                
                count--;
                times[ i ]  = count ;
                
                if( count == 0 )
                {
                    
                    remove( func[ i ] );
                    //func.splice( i, 1 ) ;
                    //times.splice( i, 1 ) ;
                    
                }
                
            }
            
        }
        
    }
    
}