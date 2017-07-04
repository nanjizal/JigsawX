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
import zpartanlite.Enumerables;

class Pages<T>
{
    
    
    private var index:      Int ;
    private var lastIndex:  Int ;
    private var len:        Int ;
    private var order:      Array<T> ;
    private var history:    Array<Int> ;
    public var circle:      Bool ;
    public var last:        T ;
    public var curr:        T ;
    public var pageChange:  DispatchTo ;
    public var hideNext:    DispatchTo ;
    public var hidePrev:    DispatchTo ;
    public var dir:         Travel;
    public var looped:      DispatchTo ;
    
    public function new( ?arr_: Array<T>, ?circle_: Bool = false )
    {
        
        circle      = circle_ ;
        pageChange  = new DispatchTo() ;
        hideNext    = new DispatchTo() ;
        hidePrev    = new DispatchTo() ;
        looped      = new DispatchTo() ;
        reset( arr_ ) ;
        
    }
    
    
    public function reset( ?arr_: Array<T> ) : Void
    {
        
        if( arr_ == null )
        {
            order   = new Array() ;
        }
        else
        {   
            order  = arr_ ;   
        }
        index = 0;
        len = order.length;
        history = new Array() ;
        
    }
    
    
    public function next() : T
    {
        
        lastIndex   = index ;
        last        = order[ index ];
        dir = Forward;
        
        index++ ;
        if( index == len )
        {
            if( circle )
            {
                index = 0 ;
                looped.dispatch();
            }
            else
            {
                index = len - 1 ;
            }
        }
        
        curr = order[ index ] ;
        if( lastIndex != index )
        {
            
            history.push( index ) ;
            
            if( !circle )
            {
                
                if( !hasNext() )
                {
                    
                    hideNext.dispatch();
                    
                }
                
            }
            pageChange.dispatch();
            
        }
        
        return curr;
        
    }
    
    
    public function previous(): T
    {
        
        lastIndex   = index ;
        last = order[ index ];
        dir = Back;
        
        index-- ;
        if( index == -1 )
        {
            
            if( circle )
            {
                
                index = len - 1 ;
                
            }
            else
            {
                
                index = 0 ;
            }
            
        }
        
        curr = order[ index ]; 
        if( lastIndex != index )
        {
            
            history.push( index ) ;
            
            if( !circle )
            {
                
                if( !hasPrevious() )
                {
                    
                    hidePrev.dispatch();
                    
                }
                
            }
            pageChange.dispatch();
        }
        
        
        return curr;
        
    }
    
    
    public function getCurrent(): T
    {
        
        return order[ index ] ;
        
    }
    
    
    public function hasPrevious(): Bool
    {
        
        if( circle )
        {
            
            return true ;
            
        }
        
        if( index == 0 )
        {
            
            return false ;
            
        }
        
        return true ;
        
    }
    
    
    public function hasNext() : Bool
    {
        
        if( circle )
        {
            
            return true ;
            
        }
        
        if( index == len )
        {
            
            return false ;
            
        }
        
        return true ;
        
    }
    
    
    public function goto( index_: Int ): T
    {
        
        lastIndex   = index ;
        last        = order[ index ] ;
        
        
        index = index_ ;
        
        curr = order[ index ];
        if( lastIndex != index )
        {
            
            history.push( index ) ;
            
            if( !circle )
            {
                
                if( !hasNext() )
                {
                    
                    hideNext.dispatch();
                    
                }
                if( !hasPrevious() )
                {
                    
                    hidePrev.dispatch();
                    
                }
            }
            
            pageChange.dispatch();
            
        }
        
        
        return curr;
        
    }
    
    
    public function back(): T
    {
        
        lastIndex = index ;
        last = order[ index ] ;
        
        index = history.pop() ;
        
        if( lastIndex != index )
        {
            if( !circle )
            {
                
                if( !hasNext() )
                {
                    
                    hideNext.dispatch() ;
                    
                }
                if( !hasPrevious() )
                {
                    
                    hidePrev.dispatch() ;
                    
                }
                
            }
            pageChange.dispatch() ;
            
        }
        
        curr = order[ index ] ;
        return curr;
        
    }
    
    public function isLast():Bool
    {
        
        if( index == len - 1 ) return true;
        return false;
        
    }
    
    public function getIndex(): Int
    {
        
        return index ;
        
    }
    
    public function getLastIndex(): Int
    {
        
        return lastIndex;
        
    }
    
    
}