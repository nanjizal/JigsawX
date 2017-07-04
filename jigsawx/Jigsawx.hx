/*
* Copyright (c) 2012, Justinfront Ltd
*   author:  Justin L Mills
*   email:   JLM at Justinfront dot net
*   created: 17 June 2012
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the Justinfront Ltd nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
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


package jigsawx ;

import jigsawx.OpenEllipse ;
import jigsawx.JigsawPiece ;
import jigsawx.math.Vec2;
import jigsawx.JigsawSideData;

class Jigsawx
{
    
    
    private var rows:                       Int;
    private var cols:                       Int;
    private var pieces:                     Array<Array<JigsawPiece>>;
    public var jigs:                        Array<JigsawPiece>;
    private var sides:                      Array<Array<JigsawPieceData>>;
    private var lt:                         Float;
    private var rt:                         Float;
    private var rb:                         Float;
    private var lb:                         Float;
    private var dx:                         Float;
    private var dy:                         Float;
    private var length:                     Int;
    
    
    
    public function new(    dx_:            Float
                        ,   dy_:            Float
                        ,   rows_:          Int
                        ,   cols_:          Int
                        )
    {    
        
        pieces                              = [];
        jigs                                = [];
        sides                               = [];
        dx                                  = dx_;
        dy                                  = dy_;
        rows                                = rows_;
        cols                                = cols_;
        
        //corners, theoretically JigsawSideData could be modified to allow these to have a random element.
        var xy                              = new Vec2( 20,      20 );
        var lt                              = new Vec2( 20,      20 );
        var rt                              = new Vec2( 20 + dx, 20 );
        var rb                              = new Vec2( 20 + dx, dy + 20 );
        var lb                              = new Vec2( 20,      dy + 20 );
        length                              = 0;
        
        var last:   JigsawPieceData; 
        
        for( row in 0...rows  )
        {
            
            last                            = { north: null, east: null, south: null, west: null };
            
            sides.push( new Array() );
            
            for( col in 0...cols )
            {
                
                var jigsawPiece             = JigsawSideData.halfPieceData();
                
                if( last.east != null )     jigsawPiece.west = JigsawSideData.reflect( last.east );
                if( col == cols - 1 )       jigsawPiece.east = null;
                
                sides[ row ][ col ]         = jigsawPiece;
                last                        = jigsawPiece;
                length++;
                
            }
            
        }
        
        for( col in 0...cols  )
        {
            
            last                            = { north: null, east: null, south: null, west: null };
            
            for( row in 0...rows )
            {
                
                var jigsawPiece             = sides[ row ][ col ];
                
                if( last.south != null )    jigsawPiece.north = JigsawSideData.reflect( last.south );
                if( row == rows - 1 )       jigsawPiece.south = null;
                
                last                        = jigsawPiece;
                
            }
            
        }
        
        var jig:    JigsawPiece;
        
        for( row in 0...rows  )
        {
            
            pieces.push( new Array() );
            
            for( col in 0...cols )
            {
                
                jig                         = new JigsawPiece( xy, row, col, lt, rt, rb, lb, sides[ row ][ col ] );
                pieces[ row ][ col ]        = jig;
                jigs.push( jig );
                
                xy.x                        += dx;
                
            }
            
            xy.x                            = 20;
            xy.y                            += dy;
            
        }
        
    }
    
    
}
