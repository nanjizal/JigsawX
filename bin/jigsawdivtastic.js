(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
}
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	last: function() {
		return this.q == null?null:this.q[0];
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,__class__: List
}
var IMap = function() { }
IMap.__name__ = true;
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
var core = {}
core.DisplayDiv = function(img) {
	if(this.isVideo(img)) {
		this._vid = core.GlobalDiv.ROOT(this).createElement("video");
		this._dom = this._vid;
	} else if(img == "canvas") this._dom = core.GlobalDiv.ROOT(this).createElement("canvas"); else this._dom = core.GlobalDiv.ROOT(this).createElement("div");
	this._style = this._dom.style;
	this.isIE = core.WebBrowser.get_browserType() == core.BrowserType.IE;
	this.out = new zpartanlite.DispatchTo();
	this.out.tellEnabled = $bind(this,this.outEnabled);
	this.out.tellDisabled = $bind(this,this.outDisabled);
	this.over = new zpartanlite.DispatchTo();
	this.over.tellEnabled = $bind(this,this.overEnabled);
	this.over.tellDisabled = $bind(this,this.overDisabled);
	this.release = new zpartanlite.DispatchTo();
	this.release.tellEnabled = $bind(this,this.releaseEnabled);
	this.release.tellDisabled = $bind(this,this.releaseDisabled);
	this.press = new zpartanlite.DispatchTo();
	this.press.tellEnabled = $bind(this,this.pressEnabled);
	this.press.tellDisabled = $bind(this,this.pressDisabled);
	this.dragging = new zpartanlite.DispatchTo();
	this.dragInform = false;
	this.draggingParent = new zpartanlite.DispatchTo();
	this.set_tile(false);
	if(img != null) this.set_image(img);
	this._style.position = "absolute";
};
core.DisplayDiv.__name__ = true;
core.DisplayDiv.prototype = {
	set_alpha: function(alpha_) {
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 3:
		case 4:
		case 2:
		case 0:
		case 1:
			this._style.opacity = alpha_;
			break;
		case 5:
			this._style.filter = "alpha(opacity=" + Std.String(Math.round(alpha_ * 10)) + ")";
			break;
		}
		this._alpha = alpha_;
		return this._alpha;
	}
	,get_alpha: function() {
		if(this._alpha == null) this._alpha = 1;
		return this._alpha;
	}
	,get_rotation: function() {
		if(this._rotation == null) {
			this._rotation = 0;
			this._angle = 0;
		}
		return this._rotation;
	}
	,set_rotation: function(angle) {
		this._rotation = angle;
		this._angle = angle | 0;
		var rad = this._rotation * (Math.PI / 180);
		var cos = Math.cos(rad);
		var sin = Math.sin(rad);
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 2:
		case 1:
		case 0:
			this._style.WebkitTransform = "rotate(" + Std.string(this._angle) + "deg)";
			break;
		case 4:
			this._style.OTransform = "rotate(" + Std.string(this._angle) + "deg)";
			break;
		case 3:
			this._style.MozTransform = "rotate(" + Std.string(this._angle) + "deg)";
			break;
		case 5:
			this.affineTrans(cos,-sin,sin,cos,0,0);
			break;
		}
		return angle;
	}
	,affineTransIE: function(a,b,c,d,e,f) {
		this._style.filter = "progid:DXImageTransform.Microsoft.Matrix(M11=" + a + ", M21=" + b + ", M12=" + c + ", M22=" + d + ", SizingMethod=\"auto expand\")";
		var w2 = this.get_width() / 2;
		var h2 = this.get_height() / 2;
		this.set_x(Math.round(this.get_x() + e - (Math.abs(a) - 1) * w2 + Math.abs(c) * h2));
		this.set_y(Math.round(this.get_y() + f - Math.abs(b) * w2 + (Math.abs(d) - 1) * h2));
	}
	,affineTrans: function(a,b,c,d,e,f) {
		this.afflines = [a,b,c,d,e,f];
		var mat0 = "matrix( " + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ", " + Std.string(d) + ", ";
		var matrixFirefox = mat0 + Std.string(e) + "px, " + Std.string(e) + "px ) ";
		var matrixGeneral = mat0 + Std.string(e) + Std.string(e) + " ) ";
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 2:
		case 0:
		case 1:
			this._style.WebkitTransform = matrixGeneral;
			break;
		case 4:
			this._style.OTransform = matrixGeneral;
			break;
		case 3:
			this._style.MozTransform = matrixFirefox;
			break;
		case 5:
			this.affineTransIE(a,b,c,d,e,f);
			break;
		}
	}
	,set_scaleX: function(scaleX_) {
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 2:
		case 1:
		case 0:
			this._style.WebkitTransform = "scaleX(" + Std.string(scaleX_) + ")";
			break;
		case 4:
			this._style.OTransform = "scaleX(" + Std.string(scaleX_) + ")";
			break;
		case 3:
			this._style.MozTransform = "scaleX(" + Std.string(scaleX_) + ")";
			break;
		case 5:
			this.affineTrans(scaleX_,0,0,this.get_scaleY(),0,0);
			break;
		}
		this._scaleX = scaleX_;
		return this._scaleX;
	}
	,get_scaleX: function() {
		if(this._scaleX == null) this._scaleX = 1;
		return this._scaleX;
	}
	,set_scaleY: function(scaleY_) {
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 2:
		case 0:
		case 1:
			this._style.WebkitTransform = "scaleY(" + Std.string(scaleY_) + ")";
			break;
		case 4:
			this._style.OTransform = "scaleY(" + Std.string(scaleY_) + ")";
			break;
		case 3:
			this._style.MozTransform = "scaleY(" + Std.string(scaleY_) + ")";
			break;
		case 5:
			this.affineTrans(this.get_scaleX(),0,0,scaleY_,0,0);
			break;
		}
		this._scaleY = scaleY_;
		return this._scaleY;
	}
	,get_scaleY: function() {
		if(this._scaleY == null) this._scaleY = 1;
		return this._scaleY;
	}
	,set_scale: function(scale_) {
		var scaleStr = Std.string(scale_);
		var str = "scale(" + scaleStr + ", " + scaleStr + ")";
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 2:
		case 1:
		case 0:
			this._style.WebkitTransform = str;
			break;
		case 4:
			this._style.OTransform = str;
			break;
		case 3:
			this._style.MozTransform = str;
			break;
		case 5:
			this.affineTrans(scale_,0,0,scale_,0,0);
			break;
		}
		this._scale = scale_;
		this._scaleX = scale_;
		this._scaleY = scale_;
		return this._scale;
	}
	,get_scale: function() {
		if(this._scale == null) {
			this._scale = 1;
			this._scaleX = 1;
			this._scaleY = 1;
		}
		return this._scale;
	}
	,get_twoD: function() {
		if(this._canvas == null) this._canvas = this._dom;
		if(this._twoD == null) this._twoD = this._canvas.getContext("2d");
		return this._twoD;
	}
	,get_x: function() {
		return this._x;
	}
	,set_x: function(val) {
		this._x = val;
		this._style.left = val + "px";
		return val;
	}
	,get_y: function() {
		return this._y;
	}
	,set_y: function(val) {
		this._y = val;
		this._style.top = val + "px";
		return val;
	}
	,get_width: function() {
		if(this._width == null || this._width < this._dom.clientWidth) this._width = this._dom.clientWidth;
		return this._width;
	}
	,set_width: function(val) {
		this._width = val;
		if(this._twoD == null) this._style.paddingLeft = val + "px"; else this._style.paddingLeft = "0px";
		return val;
	}
	,get_height: function() {
		if(this._height == null || this._height < this._dom.clientHeight) this._height = this._dom.clientHeight;
		return this._height;
	}
	,set_height: function(val) {
		this._height = val;
		if(this._twoD == null) this._style.paddingTop = val + "px"; else this._style.paddingTop = "0px";
		return val;
	}
	,updateSizeBasedOnChild: function(mc) {
		if(this.get_width() < mc.get_width() + mc.get_x()) this.set_width(mc.get_width() + mc.get_x());
		if(this.get_height() < mc.get_height() + mc.get_y()) this.set_height(mc.get_height() + mc.get_y());
	}
	,updateSizeBasedOnChild2: function(mc) {
		if(this.get_width() < mc.get_width() + mc.get_x()) this.set_width(mc.get_width() + mc.get_x());
		if(this.get_height() < mc.get_height() + mc.get_y()) this.set_height(mc.get_height() + mc.get_y());
	}
	,get_parent: function() {
		return this._parent;
	}
	,set_parent: function(mc) {
		this._parent = mc;
		return mc;
	}
	,appended: function() {
	}
	,addChild2: function(mc) {
		this._dom.appendChild(mc.getInstance());
		mc.set_parent(this);
		this.updateSizeBasedOnChild2(mc);
		mc.appended();
		return mc;
	}
	,addChild: function(mc) {
		this._dom.appendChild(mc.getInstance());
		mc.set_parent(this);
		this.updateSizeBasedOnChild(mc);
		mc.appended();
		return mc;
	}
	,get_fill: function() {
		return this._bgColor;
	}
	,set_fill: function(c) {
		if(this.isIE) {
			this.createImageDivIfNot();
			this.imageDiv.set_fill(c);
		} else this._style.backgroundColor = c;
		this._bgColor = c;
		return c;
	}
	,get_visible: function() {
		if(this.viz == null) this.viz = true;
		return this.viz;
	}
	,set_visible: function(val) {
		if(val) this._style.visibility = "visible"; else this._style.visibility = "hidden";
		this.viz = val;
		return this.viz;
	}
	,get_text: function() {
		return this._dom.innerHTML;
	}
	,updateText: function(txt) {
		this._dom.innerHTML = "";
		this.set_width(0);
		this.set_height(0);
		this._dom.innerHTML = txt;
		this._style.width = Std.string(this.fixedTextWidth);
		if(this.fixedTextHeight != null) this._style.height = Std.string(this.fixedTextHeight);
		this._style.overflow = "Hidden";
	}
	,set_text: function(txt) {
		this._dom.innerHTML = "";
		this.set_width(0);
		this.set_height(0);
		if(this.get_parent() != null) this.get_parent().updateSizeBasedOnChild(this);
		this._dom.innerHTML = txt;
		var _g = core.WebBrowser.get_browserType();
		switch( (_g)[1] ) {
		case 3:
			this._style.MozUserSelect = "none";
			break;
		case 2:
		case 1:
		case 0:
			this._style.webkitUserSelect = "none";
			break;
		case 5:
		case 4:
			this._style.unselectable = "on";
			break;
		}
		this.set_width(this._width);
		this.set_height(this._height);
		if(this.get_parent() != null) this.get_parent().updateSizeBasedOnChild(this);
		return txt;
	}
	,getStyle: function() {
		return this._style;
	}
	,getInstance: function() {
		return this._dom;
	}
	,createImageDivIfNot: function() {
		if(this.imageDiv == null) {
			this.imageDiv = new core.ImageDiv();
			this.imageDiv.set_x(0);
			this.imageDiv.set_y(0);
			this.addChild2(this.imageDiv);
		}
		this.imageDiv.set_width(this.get_width());
		this.imageDiv.set_height(this.get_height());
		return this.imageDiv;
	}
	,set_tile: function(tile_) {
		this._tile = tile_;
		if(this.isIE) this.createImageDivIfNot();
		if(this._tile) {
			if(this.isIE) this.imageDiv.set_tile(true); else this._style.backgroundRepeat = "repeat";
		} else if(this.isIE) this.imageDiv.set_tile(false); else this._style.backgroundRepeat = "no-repeat";
		return tile_;
	}
	,get_tile: function() {
		if(this._tile == null) this.set_tile(false);
		return this._tile;
	}
	,setClip: function() {
		this._style.overflow = "Hidden";
	}
	,set_image: function(img) {
		this._img = img;
		if(this.isIE) this.createImageDivIfNot();
		if(img.split(".").length > 1) {
			if(this.isIE) this.imageDiv.set_image(img); else if(this._vid == null) this._style.backgroundImage = "url(" + img + ")"; else {
				this._dom.setAttribute("src",img);
				this._dom.setAttribute("type",this.videoType);
			}
		} else if(this.isIE) this.imageDiv.set_image(img); else this._dom.className = img;
	}
	,isVideo: function(img) {
		if(img == null) return false;
		var arr = img.split(".");
		if(arr.length == null) return false;
		var str = arr[1];
		switch(str) {
		case "ogv":case "mpeg":case "mov":case "mp4":case "webm":
			this.videoType = "video/" + str;
			return true;
		}
		return false;
	}
	,play: function() {
		if(this._vid != null) this._vid.play();
	}
	,parentDrag: function(e) {
		if(this.dragInform) this.draggingParent.dispatch();
		var em = e;
		this.get_parent().set_x(em.clientX - this.offSetX);
		this.get_parent().set_y(em.clientY - this.offSetY);
	}
	,parentStopDrag: function() {
		core.GlobalDiv.ROOT(this).onmousemove = null;
	}
	,parentStartDrag: function() {
		this.offSetX = this._clientX - this.get_parent().get_x() | 0;
		this.offSetY = this._clientY - this.get_parent().get_y() | 0;
		core.GlobalDiv.ROOT(this).onmousemove = $bind(this,this.parentDrag);
	}
	,setupParentDrag: function() {
		var me = this;
		this._style.cursor = "pointer";
		this.press.add($bind(this,this.parentStartDrag));
		this.release.add($bind(this,this.parentStopDrag));
	}
	,drag: function(e) {
		if(this.dragInform) this.dragging.dispatch();
		var em = e;
		this.set_x(em.clientX - this.offSetX);
		this.set_y(em.clientY - this.offSetY);
	}
	,stopDrag: function() {
		core.GlobalDiv.ROOT(this).onmousemove = null;
	}
	,startDrag: function() {
		this.offSetX = this._clientX - this.get_x() | 0;
		this.offSetY = this._clientY - this.get_y() | 0;
		core.GlobalDiv.ROOT(this).onmousemove = $bind(this,this.drag);
	}
	,setupDrag: function() {
		this._style.cursor = "pointer";
		this.press.add($bind(this,this.startDrag));
		this.release.add($bind(this,this.stopDrag));
	}
	,outDisabled: function() {
		this._dom.onmouseout = null;
	}
	,outEnabled: function() {
		var _g = this;
		this._dom.onmouseout = function(e) {
			_g.out.dispatch();
		};
	}
	,overDisabled: function() {
		this._dom.onmouseover = null;
	}
	,overEnabled: function() {
		var _g = this;
		this._dom.onmouseover = function(e) {
			_g.over.dispatch();
		};
	}
	,releaseDisabled: function() {
		this._dom.onmouseup = null;
	}
	,releaseEnabled: function() {
		var _g = this;
		this._dom.onmouseup = function(e) {
			var em = e;
			_g._clientX = em.clientX;
			_g._clientY = em.clientY;
			_g.release.dispatch();
		};
	}
	,pressDisabled: function() {
		this._dom.onmousedown = null;
	}
	,pressEnabled: function() {
		var _g = this;
		this._dom.onmousedown = function(e) {
			var em = e;
			_g._clientX = em.clientX;
			_g._clientY = em.clientY;
			_g.press.dispatch();
		};
	}
	,getGlobalXY: function() {
		var p = this;
		var gX = p.get_x();
		var gY = p.get_y();
		while(p.get_parent() != null) {
			p = p.get_parent();
			gX += p.get_x();
			gY += p.get_y();
		}
		var pos = new List();
		pos.add(gX);
		pos.add(gY);
		return pos;
	}
	,getGlobalMouseXY: function() {
		var globalPos = this.getGlobalXY();
		var pos = new List();
		pos.add(globalPos.first() + this._clientX);
		pos.add(globalPos.last() + this._clientY);
		return pos;
	}
	,__class__: core.DisplayDiv
}
var js = {}
js.Browser = function() { }
js.Browser.__name__ = true;
core.GlobalDiv = function() { }
core.GlobalDiv.__name__ = true;
core.GlobalDiv.ROOT = function(d) {
	return core.GlobalDiv._root;
}
core.GlobalDiv.addChild = function(d,mc) {
	core.GlobalDiv._root.body.appendChild(mc.getInstance());
}
core.ImageDiv = function(img) {
	console.log("imageDiv");
	this._dom = core.GlobalDiv.ROOT(this).createElement("div");
	this._style = this._dom.style;
	this.set_tile(false);
	if(img != null) this.set_image(img);
	this._style.position = "absolute";
	this._d = 0;
};
core.ImageDiv.__name__ = true;
core.ImageDiv.prototype = {
	get_parent: function() {
		return this._parent;
	}
	,set_parent: function(mc) {
		this._parent = mc;
		return mc;
	}
	,get_x: function() {
		return this._x;
	}
	,set_x: function(val) {
		this._x = val;
		this._style.left = val + "px";
		return val;
	}
	,get_y: function() {
		return this._y;
	}
	,set_y: function(val) {
		this._y = val;
		this._style.top = val + "px";
		return val;
	}
	,get_width: function() {
		if(this._width == null || this._width < this._dom.clientWidth) this._width = this._dom.clientWidth;
		return this._width;
	}
	,set_width: function(val) {
		this._width = val;
		this._style.paddingLeft = val + "px";
		return val;
	}
	,get_height: function() {
		if(this._height == null || this._height < this._dom.clientHeight) this._height = this._dom.clientHeight;
		return this._height;
	}
	,set_height: function(val) {
		this._height = val;
		this._style.paddingTop = val + "px";
		return val;
	}
	,get_fill: function() {
		return this._bgColor;
	}
	,set_fill: function(c) {
		this._bgColor = c;
		this._style.backgroundColor = c;
		return c;
	}
	,get_visible: function() {
		if(this.viz == null) this.viz = true;
		return this.viz;
	}
	,set_visible: function(val) {
		if(val) this._style.visibility = "visible"; else this._style.visibility = "hidden";
		this.viz = val;
		return this.viz;
	}
	,getStyle: function() {
		return this._style;
	}
	,getInstance: function() {
		return this._dom;
	}
	,set_tile: function(tile_) {
		this._tile = tile_;
		if(this._tile) this._style.backgroundRepeat = "repeat"; else this._style.backgroundRepeat = "no-repeat";
		return tile_;
	}
	,get_tile: function() {
		if(this._tile == null) this.set_tile(false);
		return this._tile;
	}
	,setClip: function() {
		this._style.overflow = "Hidden";
	}
	,appended: function() {
	}
	,set_image: function(img) {
		this._img = img;
		if(img.split(".").length > 1) this._style.backgroundImage = "url(" + img + ")"; else this._dom.className = img;
	}
	,__class__: core.ImageDiv
}
core.ImageLoader = function(imageNames,loaded_) {
	this.images = new haxe.ds.StringMap();
	this.loaded = loaded_;
	this.count = imageNames.length;
	var _g = 0;
	while(_g < imageNames.length) {
		var name = imageNames[_g];
		++_g;
		this.load(name);
	}
};
core.ImageLoader.__name__ = true;
core.ImageLoader.prototype = {
	store: function(image,name,e) {
		this.count--;
		console.log("store " + name + " " + this.count);
		this.images.set(name,image);
		if(this.count == 0) this.loaded();
	}
	,load: function(img) {
		var image = js.Browser.document.createElement("img");
		var imgStyle = image.style;
		imgStyle.left = "0px";
		imgStyle.top = "0px";
		imgStyle.paddingLeft = "0px";
		imgStyle.paddingTop = "0px";
		image.onload = (function(f,a1,a2) {
			return function(e) {
				return f(a1,a2,e);
			};
		})($bind(this,this.store),image,img.split("/").pop());
		imgStyle.position = "absolute";
		image.src = img;
	}
	,__class__: core.ImageLoader
}
core.SetupCanvas = function(wid,hi) {
	if(hi == null) hi = 768;
	if(wid == null) wid = 1024;
	this.canvas = js.Browser.document.createElement("canvas");
	this.dom = this.canvas;
	this.body = js.Browser.document.body;
	this.surface = this.canvas.getContext("2d");
	this.style = this.dom.style;
	this.canvas.width = wid;
	this.canvas.height = hi;
	this.style.paddingLeft = "0px";
	this.style.paddingTop = "0px";
	this.style.left = Std.string(0 + "px");
	this.style.top = Std.string(0 + "px");
	this.style.position = "absolute";
	this.image = this.dom;
};
core.SetupCanvas.__name__ = true;
core.SetupCanvas.prototype = {
	__class__: core.SetupCanvas
}
core.BrowserType = { __ename__ : true, __constructs__ : ["Chrome","Safari","WebKitOther","FireFox","Opera","IE"] }
core.BrowserType.Chrome = ["Chrome",0];
core.BrowserType.Chrome.toString = $estr;
core.BrowserType.Chrome.__enum__ = core.BrowserType;
core.BrowserType.Safari = ["Safari",1];
core.BrowserType.Safari.toString = $estr;
core.BrowserType.Safari.__enum__ = core.BrowserType;
core.BrowserType.WebKitOther = ["WebKitOther",2];
core.BrowserType.WebKitOther.toString = $estr;
core.BrowserType.WebKitOther.__enum__ = core.BrowserType;
core.BrowserType.FireFox = ["FireFox",3];
core.BrowserType.FireFox.toString = $estr;
core.BrowserType.FireFox.__enum__ = core.BrowserType;
core.BrowserType.Opera = ["Opera",4];
core.BrowserType.Opera.toString = $estr;
core.BrowserType.Opera.__enum__ = core.BrowserType;
core.BrowserType.IE = ["IE",5];
core.BrowserType.IE.toString = $estr;
core.BrowserType.IE.__enum__ = core.BrowserType;
core.WebBrowser = function() { }
core.WebBrowser.__name__ = true;
core.WebBrowser.get_hasCanvas2d = function() {
	if(core.WebBrowser._hasCanvas2d == null) core.WebBrowser.set_hasCanvas2d();
	return core.WebBrowser._hasCanvas2d;
}
core.WebBrowser.set_hasCanvas2d = function() {
	if(($_=js.Browser.document.createElement("canvas"),$bind($_,$_.getContext)) == null) core.WebBrowser._hasCanvas2d = false; else core.WebBrowser._hasCanvas2d = true;
}
core.WebBrowser.get_browserType = function() {
	if(core.WebBrowser._browserType == null) core.WebBrowser.set_browserType(js.Browser.window.navigator.userAgent);
	return core.WebBrowser._browserType;
}
core.WebBrowser.traceAgent = function() {
	core.WebBrowser.get_browserType();
	console.log(core.WebBrowser._userAgent);
}
core.WebBrowser.set_browserType = function(agent) {
	core.WebBrowser._userAgent = agent;
	if(new EReg("WebKit","").match(agent)) {
		if(new EReg("Chrome","").match(agent)) core.WebBrowser._browserType = core.BrowserType.Chrome; else if(new EReg("Safari","").match(agent)) core.WebBrowser._browserType = core.BrowserType.Safari; else core.WebBrowser._browserType = core.BrowserType.Opera;
	} else if(new EReg("Opera","").match(agent)) core.WebBrowser._browserType = core.BrowserType.Opera; else if(new EReg("Mozilla","").match(agent)) {
		var isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
		if(isIE) core.WebBrowser._browserType = core.BrowserType.IE; else core.WebBrowser._browserType = core.BrowserType.FireFox;
	} else core.WebBrowser._browserType = core.BrowserType.IE;
	return core.WebBrowser._browserType;
}
var haxe = {}
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = true;
haxe.Timer.prototype = {
	run: function() {
		console.log("run");
	}
	,__class__: haxe.Timer
}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
var jigsawx = {}
jigsawx.JigsawMagicNumbers = function() { }
jigsawx.JigsawMagicNumbers.__name__ = true;
jigsawx.Compass = { __ename__ : true, __constructs__ : ["NORTH","SOUTH","EAST","WEST"] }
jigsawx.Compass.NORTH = ["NORTH",0];
jigsawx.Compass.NORTH.toString = $estr;
jigsawx.Compass.NORTH.__enum__ = jigsawx.Compass;
jigsawx.Compass.SOUTH = ["SOUTH",1];
jigsawx.Compass.SOUTH.toString = $estr;
jigsawx.Compass.SOUTH.__enum__ = jigsawx.Compass;
jigsawx.Compass.EAST = ["EAST",2];
jigsawx.Compass.EAST.toString = $estr;
jigsawx.Compass.EAST.__enum__ = jigsawx.Compass;
jigsawx.Compass.WEST = ["WEST",3];
jigsawx.Compass.WEST.toString = $estr;
jigsawx.Compass.WEST.__enum__ = jigsawx.Compass;
jigsawx.JigsawPiece = function(xy_,row,col,lt,rt,rb,lb,sideData_) {
	this.enabled = true;
	this.xy = new jigsawx.math.Vec2(xy_.x,xy_.y);
	this.sideData = sideData_;
	this.points = [];
	this.stepAngle = 10 / 1.5 * Math.PI / 180;
	this.first = lt;
	if(this.sideData.north != null) this.createVertSide(lt,rt,this.sideData.north,jigsawx.Compass.NORTH);
	this.points.push(rt);
	if(this.sideData.east != null) this.createHoriSide(rt,rb,this.sideData.east,jigsawx.Compass.EAST);
	this.points.push(rb);
	if(this.sideData.south != null) this.createVertSide(rb,lb,this.sideData.south,jigsawx.Compass.SOUTH);
	this.points.push(lb);
	if(this.sideData.west != null) this.createHoriSide(lb,lt,this.sideData.west,jigsawx.Compass.WEST);
	this.points.push(lt);
};
jigsawx.JigsawPiece.__name__ = true;
jigsawx.JigsawPiece.prototype = {
	drawSide: function(dx,dy,sideData,compass) {
		var halfPI = Math.PI / 2;
		var dimensions = new jigsawx.math.Vec2();
		var offsetCentre = new jigsawx.math.Vec2();
		var bubble = sideData.bubble;
		this.centre = (function($this) {
			var $r;
			switch( (compass)[1] ) {
			case 0:
				$r = new jigsawx.math.Vec2(dx,dy + 6 * (function($this) {
					var $r;
					switch( (bubble)[1] ) {
					case 0:
						$r = 1;
						break;
					case 1:
						$r = -1;
						break;
					}
					return $r;
				}($this)));
				break;
			case 2:
				$r = new jigsawx.math.Vec2(dx - 6 * (function($this) {
					var $r;
					switch( (bubble)[1] ) {
					case 0:
						$r = 1;
						break;
					case 1:
						$r = -1;
						break;
					}
					return $r;
				}($this)),dy);
				break;
			case 1:
				$r = new jigsawx.math.Vec2(dx,dy - 6 * (function($this) {
					var $r;
					switch( (bubble)[1] ) {
					case 0:
						$r = 1;
						break;
					case 1:
						$r = -1;
						break;
					}
					return $r;
				}($this)));
				break;
			case 3:
				$r = new jigsawx.math.Vec2(dx + 6 * (function($this) {
					var $r;
					switch( (bubble)[1] ) {
					case 0:
						$r = 1;
						break;
					case 1:
						$r = -1;
						break;
					}
					return $r;
				}($this)),dy);
				break;
			}
			return $r;
		}(this));
		this.curveBuilder = new jigsawx.OpenEllipse();
		this.curveBuilder.centre = this.centre;
		dimensions.x = (1 + (0.5 - sideData.centreWide) / 2) * 7.5;
		dimensions.y = (1 + (0.5 - sideData.centreHi) / 2) * 7.5;
		this.curveBuilder.dimensions = dimensions;
		this.curveBuilder.beginAngle = Math.PI / 8;
		this.curveBuilder.finishAngle = -Math.PI / 8;
		this.curveBuilder.stepAngle = this.stepAngle;
		this.curveBuilder.rotation = (function($this) {
			var $r;
			switch( (bubble)[1] ) {
			case 0:
				$r = 0;
				break;
			case 1:
				$r = Math.PI;
				break;
			}
			return $r;
		}(this));
		switch( (compass)[1] ) {
		case 0:
			break;
		case 2:
			this.curveBuilder.rotation += halfPI;
			break;
		case 1:
			this.curveBuilder.rotation += Math.PI;
			break;
		case 3:
			this.curveBuilder.rotation += 3 * halfPI;
			break;
		}
		var secondPoints = this.curveBuilder.getRenderList();
		if(bubble == jigsawx.Bubble.IN) secondPoints.reverse();
		var theta = this.curveBuilder.beginAngle - this.curveBuilder.finishAngle + Math.PI;
		var cosTheta = Math.cos(theta);
		var sinTheta = Math.sin(theta);
		var hyp = this.curveBuilder.getBeginRadius();
		dimensions.x = (1 + (0.5 - sideData.leftWide) / 2) * 4.;
		dimensions.y = (1 + (0.5 - sideData.leftHi) / 2) * (22 / 6 / 1.5);
		this.curveBuilder.dimensions = dimensions;
		this.curveBuilder.beginAngle = halfPI;
		this.curveBuilder.finishAngle = -halfPI;
		this.curveBuilder.stepAngle = this.stepAngle;
		this.curveBuilder.rotation = theta + (function($this) {
			var $r;
			switch( (bubble)[1] ) {
			case 0:
				$r = 0;
				break;
			case 1:
				$r = halfPI;
				break;
			}
			return $r;
		}(this));
		switch( (compass)[1] ) {
		case 0:
			break;
		case 2:
			this.curveBuilder.rotation += halfPI;
			break;
		case 1:
			this.curveBuilder.rotation += Math.PI;
			break;
		case 3:
			this.curveBuilder.rotation += 3 * halfPI;
			break;
		}
		var hypLeft = hyp + this.curveBuilder.dimensions.x;
		switch( (compass)[1] ) {
		case 0:
			offsetCentre.x = this.centre.x + hypLeft * cosTheta;
			offsetCentre.y = this.centre.y + (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = hypLeft * sinTheta;
					break;
				case 1:
					$r = -hypLeft * sinTheta;
					break;
				}
				return $r;
			}(this));
			break;
		case 2:
			offsetCentre.x = this.centre.x + (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = -hypLeft * cosTheta;
					break;
				case 1:
					$r = hypLeft * cosTheta;
					break;
				}
				return $r;
			}(this));
			offsetCentre.y = this.centre.y + hypLeft * sinTheta;
			break;
		case 1:
			offsetCentre.x = this.centre.x - hypLeft * cosTheta;
			offsetCentre.y = this.centre.y - (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = hypLeft * sinTheta;
					break;
				case 1:
					$r = -hypLeft * sinTheta;
					break;
				}
				return $r;
			}(this));
			break;
		case 3:
			offsetCentre.x = this.centre.x + (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = hypLeft * cosTheta;
					break;
				case 1:
					$r = -hypLeft * cosTheta;
					break;
				}
				return $r;
			}(this));
			offsetCentre.y = this.centre.y - hypLeft * sinTheta;
			break;
		}
		this.curveBuilder.centre = offsetCentre;
		var startPoint = this.curveBuilder.getBegin();
		var firstPoints = this.curveBuilder.getRenderList();
		if(sideData.bubble == jigsawx.Bubble.OUT) firstPoints.reverse();
		firstPoints.pop();
		firstPoints.pop();
		secondPoints.shift();
		secondPoints.shift();
		secondPoints.shift();
		this.points = this.points.concat(firstPoints.concat(secondPoints));
		dimensions.x = (1 + (0.5 - sideData.rightWide) / 2) * 4.;
		dimensions.y = (1 + (0.5 - sideData.rightHi) / 2) * (22 / 6 / 1.5);
		this.curveBuilder.dimensions = dimensions;
		this.curveBuilder.beginAngle = halfPI;
		this.curveBuilder.finishAngle = -halfPI;
		this.curveBuilder.stepAngle = this.stepAngle;
		this.curveBuilder.rotation = theta + (function($this) {
			var $r;
			switch( (bubble)[1] ) {
			case 0:
				$r = -halfPI;
				break;
			case 1:
				$r = Math.PI;
				break;
			}
			return $r;
		}(this));
		switch( (compass)[1] ) {
		case 0:
			break;
		case 2:
			this.curveBuilder.rotation += halfPI;
			break;
		case 1:
			this.curveBuilder.rotation += Math.PI;
			break;
		case 3:
			this.curveBuilder.rotation += 3 * halfPI;
			break;
		}
		var hypRight = hyp + this.curveBuilder.dimensions.x;
		switch( (compass)[1] ) {
		case 0:
			offsetCentre.x = this.centre.x - hypRight * cosTheta;
			offsetCentre.y = this.centre.y + (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = hypRight * sinTheta;
					break;
				case 1:
					$r = -hypRight * sinTheta;
					break;
				}
				return $r;
			}(this));
			break;
		case 2:
			offsetCentre.x = this.centre.x + (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = -hypLeft * cosTheta;
					break;
				case 1:
					$r = hypLeft * cosTheta;
					break;
				}
				return $r;
			}(this));
			offsetCentre.y = this.centre.y - hypLeft * sinTheta;
			break;
		case 1:
			offsetCentre.x = this.centre.x + hypRight * cosTheta;
			offsetCentre.y = this.centre.y - (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = hypRight * sinTheta;
					break;
				case 1:
					$r = -hypRight * sinTheta;
					break;
				}
				return $r;
			}(this));
			break;
		case 3:
			offsetCentre.x = this.centre.x + (function($this) {
				var $r;
				switch( (bubble)[1] ) {
				case 0:
					$r = hypLeft * cosTheta;
					break;
				case 1:
					$r = -hypLeft * cosTheta;
					break;
				}
				return $r;
			}(this));
			offsetCentre.y = this.centre.y + hypLeft * sinTheta;
			break;
		}
		this.curveBuilder.centre = offsetCentre;
		var thirdPoints = this.curveBuilder.getRenderList();
		if(bubble == jigsawx.Bubble.OUT) thirdPoints.reverse();
		thirdPoints.shift();
		thirdPoints.shift();
		this.points.pop();
		this.points.pop();
		this.points.pop();
		this.points = this.points.concat(thirdPoints);
	}
	,createHoriSide: function(A,B,side,compass) {
		this.drawSide(A.x + (B.x - A.x) / 2 + 10 / 1.5 / 2 - side.inout * (10 / 1.5),A.y + (B.y - A.y) / 2 + 8. - side.squew * 16.,side,compass);
	}
	,createVertSide: function(A,B,side,compass) {
		this.drawSide(A.x + (B.x - A.x) / 2 + 8. - side.squew * 16.,A.y + (B.y - A.y) / 2 + 10 / 1.5 / 2 - side.inout * (10 / 1.5),side,compass);
	}
	,getFirst: function() {
		return this.first;
	}
	,getPoints: function() {
		return this.points;
	}
	,__class__: jigsawx.JigsawPiece
}
jigsawx.Bubble = { __ename__ : true, __constructs__ : ["IN","OUT"] }
jigsawx.Bubble.IN = ["IN",0];
jigsawx.Bubble.IN.toString = $estr;
jigsawx.Bubble.IN.__enum__ = jigsawx.Bubble;
jigsawx.Bubble.OUT = ["OUT",1];
jigsawx.Bubble.OUT.toString = $estr;
jigsawx.Bubble.OUT.__enum__ = jigsawx.Bubble;
jigsawx.JigsawSideData = function() {
};
jigsawx.JigsawSideData.__name__ = true;
jigsawx.JigsawSideData.halfPieceData = function() {
	return { north : null, east : jigsawx.JigsawSideData.create(), south : jigsawx.JigsawSideData.create(), west : null};
}
jigsawx.JigsawSideData.createBubble = function() {
	return Math.round(Math.random()) == 1?jigsawx.Bubble.IN:jigsawx.Bubble.OUT;
}
jigsawx.JigsawSideData.swapBubble = function(bubble) {
	if(bubble == jigsawx.Bubble.OUT) return jigsawx.Bubble.IN;
	if(bubble == jigsawx.Bubble.IN) return jigsawx.Bubble.OUT;
	return null;
}
jigsawx.JigsawSideData.reflect = function(j) {
	var side = new jigsawx.JigsawSideData();
	side.bubble = jigsawx.JigsawSideData.swapBubble(j.bubble);
	side.squew = j.squew;
	side.inout = j.inout;
	side.leftWide = j.rightWide;
	side.leftHi = j.rightHi;
	side.centreWide = j.centreWide;
	side.centreHi = j.centreHi;
	side.rightWide = j.leftWide;
	side.rightHi = j.leftHi;
	return side;
}
jigsawx.JigsawSideData.createSimple = function() {
	var side = new jigsawx.JigsawSideData();
	side.bubble = jigsawx.JigsawSideData.createBubble();
	side.squew = 0.5;
	side.inout = 0.5;
	side.leftWide = 0.5;
	side.leftHi = 0.5;
	side.centreWide = 0.5;
	side.centreHi = 0.5;
	side.rightWide = 0.5;
	side.rightHi = 0.5;
	return side;
}
jigsawx.JigsawSideData.create = function() {
	var side = new jigsawx.JigsawSideData();
	side.bubble = jigsawx.JigsawSideData.createBubble();
	side.squew = Math.random();
	side.inout = Math.random();
	side.leftWide = Math.random();
	side.leftHi = Math.random();
	side.centreWide = Math.random();
	side.centreHi = Math.random();
	side.rightWide = Math.random();
	side.rightHi = Math.random();
	return side;
}
jigsawx.JigsawSideData.prototype = {
	__class__: jigsawx.JigsawSideData
}
jigsawx.Jigsawx = function(dx_,dy_,rows_,cols_) {
	this.pieces = [];
	this.jigs = [];
	this.sides = [];
	this.dx = dx_;
	this.dy = dy_;
	this.rows = rows_;
	this.cols = cols_;
	var xy = new jigsawx.math.Vec2(20,20);
	var lt = new jigsawx.math.Vec2(20,20);
	var rt = new jigsawx.math.Vec2(20 + this.dx,20);
	var rb = new jigsawx.math.Vec2(20 + this.dx,this.dy + 20);
	var lb = new jigsawx.math.Vec2(20,this.dy + 20);
	this.length = 0;
	var last;
	var _g1 = 0, _g = this.rows;
	while(_g1 < _g) {
		var row = _g1++;
		last = { north : null, east : null, south : null, west : null};
		this.sides.push(new Array());
		var _g3 = 0, _g2 = this.cols;
		while(_g3 < _g2) {
			var col = _g3++;
			var jigsawPiece = jigsawx.JigsawSideData.halfPieceData();
			if(last.east != null) jigsawPiece.west = jigsawx.JigsawSideData.reflect(last.east);
			if(col == this.cols - 1) jigsawPiece.east = null;
			this.sides[row][col] = jigsawPiece;
			last = jigsawPiece;
			this.length++;
		}
	}
	var _g1 = 0, _g = this.cols;
	while(_g1 < _g) {
		var col = _g1++;
		last = { north : null, east : null, south : null, west : null};
		var _g3 = 0, _g2 = this.rows;
		while(_g3 < _g2) {
			var row = _g3++;
			var jigsawPiece = this.sides[row][col];
			if(last.south != null) jigsawPiece.north = jigsawx.JigsawSideData.reflect(last.south);
			if(row == this.rows - 1) jigsawPiece.south = null;
			last = jigsawPiece;
		}
	}
	var jig;
	var _g1 = 0, _g = this.rows;
	while(_g1 < _g) {
		var row = _g1++;
		this.pieces.push(new Array());
		var _g3 = 0, _g2 = this.cols;
		while(_g3 < _g2) {
			var col = _g3++;
			jig = new jigsawx.JigsawPiece(xy,row,col,lt,rt,rb,lb,this.sides[row][col]);
			this.pieces[row][col] = jig;
			this.jigs.push(jig);
			xy.x += this.dx;
		}
		xy.x = 20;
		xy.y += this.dy;
	}
};
jigsawx.Jigsawx.__name__ = true;
jigsawx.Jigsawx.prototype = {
	__class__: jigsawx.Jigsawx
}
jigsawx.OpenEllipse = function() {
};
jigsawx.OpenEllipse.__name__ = true;
jigsawx.OpenEllipse.prototype = {
	createPoint: function(centre,dimensions,theta) {
		var offSetA = 3 * Math.PI / 2 - this.rotation;
		var dx = dimensions.x * Math.sin(theta);
		var dy = -dimensions.y * Math.cos(theta);
		var dxNew = centre.x - dx * Math.sin(offSetA) + dy * Math.cos(offSetA);
		var dyNew = centre.y - dx * Math.cos(offSetA) - dy * Math.sin(offSetA);
		return new jigsawx.math.Vec2(dxNew,dyNew);
	}
	,getRenderList: function() {
		this._points = new Array();
		if(this.circleIter == null) this.setUp();
		this._points.push(this.createPoint(this.centre,this.dimensions,this.beginAngle));
		var $it0 = jigsawx.ds.CircleIter.pi2pi(this.beginAngle,this.finishAngle,this.stepAngle).reset();
		while( $it0.hasNext() ) {
			var theta = $it0.next();
			this._points.push(this.createPoint(this.centre,this.dimensions,theta));
		}
		return this._points;
	}
	,setUp: function() {
		this.circleIter = jigsawx.ds.CircleIter.pi2pi(this.beginAngle,this.finishAngle,this.stepAngle);
	}
	,pointDistance: function(A,B) {
		var dx = A.x - B.x;
		var dy = A.y - B.y;
		return Math.sqrt(dx * dx + dy * dy);
	}
	,getFinishRadius: function() {
		return this.pointDistance(this.centre,this.getFinish());
	}
	,getBeginRadius: function() {
		return this.pointDistance(this.centre,this.getBegin());
	}
	,getFinish: function() {
		return this.createPoint(this.centre,this.dimensions,this.finishAngle);
	}
	,getBegin: function() {
		return this.createPoint(this.centre,this.dimensions,this.beginAngle);
	}
	,__class__: jigsawx.OpenEllipse
}
jigsawx.ds = {}
jigsawx.ds.Sign = { __ename__ : true, __constructs__ : ["UP","DOWN"] }
jigsawx.ds.Sign.UP = ["UP",0];
jigsawx.ds.Sign.UP.toString = $estr;
jigsawx.ds.Sign.UP.__enum__ = jigsawx.ds.Sign;
jigsawx.ds.Sign.DOWN = ["DOWN",1];
jigsawx.ds.Sign.DOWN.toString = $estr;
jigsawx.ds.Sign.DOWN.__enum__ = jigsawx.ds.Sign;
jigsawx.ds.CircleIter = function(begin_,fin_,step_,min_,max_) {
	this.begin = begin_;
	this.current = this.begin;
	this.fin = fin_;
	this.step = step_;
	this.min = min_;
	this.max = max_;
	this.onDirection = this.step > 0?jigsawx.ds.Sign.UP:jigsawx.ds.Sign.DOWN;
};
jigsawx.ds.CircleIter.__name__ = true;
jigsawx.ds.CircleIter.pi2 = function(begin_,fin_,step_) {
	return new jigsawx.ds.CircleIter(begin_,fin_,step_,0,2 * Math.PI);
}
jigsawx.ds.CircleIter.pi2pi = function(begin_,fin_,step_) {
	return new jigsawx.ds.CircleIter(begin_,fin_,step_,-Math.PI,Math.PI);
}
jigsawx.ds.CircleIter.prototype = {
	next: function() {
		this.current += this.step;
		var _g = this;
		switch( (_g.onDirection)[1] ) {
		case 0:
			if(this.current > this.max) this.current = this.min + this.current - this.max;
			break;
		case 1:
			if(this.current < this.min) this.current = this.max + this.current - this.min;
			break;
		}
		if(!this.hasNext()) return this.fin;
		return this.current;
	}
	,hasNext: function() {
		var _g = this;
		switch( (_g.onDirection)[1] ) {
		case 0:
			return this.current < this.fin && this.current + this.step > this.fin || this.current == this.fin?false:true;
		case 1:
			return this.current > this.fin && this.current - this.step < this.fin || this.current == this.fin?false:true;
		}
	}
	,reset: function() {
		this.current = this.begin;
		return this;
	}
	,__class__: jigsawx.ds.CircleIter
}
jigsawx.math = {}
jigsawx.math.Vec2 = function(x_,y_) {
	if(y_ == null) y_ = .0;
	if(x_ == null) x_ = .0;
	this.x = x_;
	this.y = y_;
};
jigsawx.math.Vec2.__name__ = true;
jigsawx.math.Vec2.prototype = {
	__class__: jigsawx.math.Vec2
}
var jigsawxtargets = {}
jigsawxtargets.hxjs = {}
jigsawxtargets.hxjs.JigsawDivtastic = function() {
	this.holder = new core.DisplayDiv();
	this.holder.set_x(0);
	this.holder.set_y(0);
	this.holder.set_width(520);
	this.holder.set_height(260);
	this.count = 0;
	core.GlobalDiv.addChild(this,this.holder);
	this.createVisuals();
	this.createHit();
	this.loader = new core.ImageLoader(["tablecloth.jpg"],$bind(this,this.onLoaded));
};
jigsawxtargets.hxjs.JigsawDivtastic.__name__ = true;
jigsawxtargets.hxjs.JigsawDivtastic.main = function() {
	new jigsawxtargets.hxjs.JigsawDivtastic();
}
jigsawxtargets.hxjs.JigsawDivtastic.prototype = {
	copyAcross: function() {
		this.count++;
		var xy = new jigsawx.math.Vec2(20,20);
		console.log(this.visualSource.getInstance());
		var image = this.visualSource.getInstance();
		var count = 0;
		var _g1 = 0, _g = this.rows;
		while(_g1 < _g) {
			var row = _g1++;
			var _g3 = 0, _g2 = this.cols;
			while(_g3 < _g2) {
				var col = _g3++;
				this.surfaces[count].drawImage(image,-xy.x,-xy.y);
				xy.x += this.wid;
				count++;
			}
			xy.x = 20;
			xy.y += this.hi;
		}
	}
	,createVisuals: function() {
		var sp;
		var canvasSp;
		var surface;
		var first;
		this.surfaces = [];
		this.tiles = [];
		this.rows = 3;
		this.cols = 4;
		this.wid = 70;
		this.hi = 70;
		this.jigsawx = new jigsawx.Jigsawx(this.wid,this.hi,this.rows,this.cols);
		this.depth = 0;
		var _g = 0, _g1 = this.jigsawx.jigs;
		while(_g < _g1.length) {
			var jig = _g1[_g];
			++_g;
			sp = new core.DisplayDiv();
			this.holder.addChild(sp);
			this.tiles.push(sp);
			sp.set_x(jig.xy.x);
			sp.set_y(jig.xy.y);
			sp.set_width(0);
			sp.set_height(0);
			canvasSp = new core.DisplayDiv("canvas");
			canvasSp.set_x(-this.wid / 2 + -5);
			canvasSp.set_y(-this.hi / 2 + -5);
			surface = canvasSp.get_twoD();
			sp.getStyle().zIndex = Std.string(this.depth++);
			sp.addChild(canvasSp);
			if(Math.random() * 5 > 2) {
				sp.set_x(475. - Math.random() * 170);
				sp.set_y(130. - Math.random() * 255 / 2 + 15);
				sp.set_alpha(0.74);
				this.drawEdge(surface,jig,"white");
			} else {
				jig.enabled = false;
				this.drawEdge(surface,jig,"white");
			}
			this.surfaces.push(surface);
		}
	}
	,visualDisplay: function() {
		this.visualSource = new core.DisplayDiv("big_buck_bunny.webm");
		this.visualSource.set_x(0);
		this.visualSource.set_y(0);
		this.visualSource.set_width(10);
		this.visualSource.set_height(10);
		this.holder.addChild(this.visualSource);
		this.visualSource.play();
		this.visualSource.getStyle().position = "absolute";
		this.atimer = new haxe.Timer(40);
		this.atimer.run = $bind(this,this.copyAcross);
	}
	,drawEdge: function(surface,jig,c) {
		surface.strokeStyle = c;
		surface.lineWidth = 2;
		surface.beginPath();
		var first = jig.getFirst();
		surface.moveTo(first.x + 3,first.y + 3);
		var _g = 0, _g1 = jig.getPoints();
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			surface.lineTo(v.x + 3,v.y + 3);
		}
		surface.stroke();
		surface.closePath();
		surface.clip();
	}
	,checkForDrag: function() {
		var _g = this;
		core.GlobalDiv.ROOT(this).onmousemove = null;
		var pos = this.hit.getGlobalMouseXY();
		var px = pos.first();
		var py = pos.last();
		var distance = 1000000000.;
		var closest = this.tiles[0];
		var jig = this.jigsawx.jigs[0];
		var surface = this.surfaces[0];
		var currI = 0;
		var dx;
		var dy;
		var dr2;
		var vXY;
		var _g1 = 0, _g2 = this.tiles.length;
		while(_g1 < _g2) {
			var i = _g1++;
			if(this.jigsawx.jigs[i].enabled) {
				dx = this.tiles[i].get_x() - px;
				dy = this.tiles[i].get_y() - py;
				dr2 = dx * dx + dy * dy;
				if(dr2 < distance) {
					closest = this.tiles[i];
					jig = this.jigsawx.jigs[i];
					surface = this.surfaces[i];
					distance = dr2;
					currI = i;
				}
			}
		}
		var wid_ = this.wid / 2;
		var hi_ = this.hi / 2;
		if(distance < this.wid * this.hi) {
			closest.getStyle().zIndex = Std.string(this.depth++);
			core.GlobalDiv.ROOT(this).onmouseup = function(e) {
				var em = e;
				if(closest.get_alpha() != 1) {
					closest.set_x(em.clientX - wid_ / 2);
					closest.set_y(em.clientY - hi_ / 2);
					closest.set_alpha(0.74);
				}
				if(Math.abs(jig.xy.x - closest.get_x()) < (wid_ + hi_) / 6 && Math.abs(jig.xy.y - closest.get_y()) < (wid_ + hi_) / 6) {
					closest.set_x(jig.xy.x);
					closest.set_y(jig.xy.y);
					closest.set_alpha(1);
					jig.enabled = false;
				}
				core.GlobalDiv.ROOT(_g).onmousemove = null;
			};
			core.GlobalDiv.ROOT(this).onmousemove = function(e) {
				var em = e;
				if(closest.get_alpha() != 1) {
					closest.set_x(em.clientX - wid_ / 2);
					closest.set_y(em.clientY - hi_ / 2);
					closest.set_alpha(0.87);
				}
			};
		}
	}
	,createHit: function() {
		this.hit = new core.DisplayDiv();
		this.hit.set_x(0);
		this.hit.set_y(0);
		this.hit.set_width(1000);
		this.hit.set_height(1000);
		this.hit.getStyle().cursor = "pointer";
		this.hit.getStyle().zIndex = "1000000000";
		core.GlobalDiv.addChild(this,this.hit);
		this.hit.press.add($bind(this,this.checkForDrag));
	}
	,onLoaded: function() {
		var count = 0;
		var images = this.loader.images;
		var tablecloth = images.get("tablecloth.jpg");
		var xy = new jigsawx.math.Vec2(20,20);
		var _g1 = 0, _g = this.rows;
		while(_g1 < _g) {
			var row = _g1++;
			var _g3 = 0, _g2 = this.cols;
			while(_g3 < _g2) {
				var col = _g3++;
				this.surfaces[count].drawImage(tablecloth,32 - xy.x,42 - xy.y,tablecloth.width * 0.81,tablecloth.height * 0.81);
				xy.x += this.wid;
				count++;
			}
			xy.x = 20;
			xy.y += this.hi;
		}
	}
	,__class__: jigsawxtargets.hxjs.JigsawDivtastic
}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
var zpartanlite = {}
zpartanlite.DispatchTo = function() {
	this.disableKill();
};
zpartanlite.DispatchTo.__name__ = true;
zpartanlite.DispatchTo.prototype = {
	dispatch: function() {
		if(this.get_length() == null) return;
		var count;
		if(this.get_length() == 1) {
			this.func0();
			if(this.times0 == -1) {
			} else {
				this.times0--;
				if(this.times0 == 0) this.remove(this.func0);
			}
			return;
		}
		var _g1 = 0, _g = this.func.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.func[i]();
			count = this.times[i];
			if(count == -1) {
			} else {
				count--;
				this.times[i] = count;
				if(count == 0) this.remove(this.func[i]);
			}
		}
	}
	,killAll: function() {
		if(this.get_length() == 1) {
			this.func0 = null;
			this.times0 = null;
			return;
		}
		var _g1 = 0, _g = this.func.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.func.splice(i,1);
			this.times.splice(i,1);
		}
		this.func = new Array();
		this.times = new Array();
	}
	,remove: function(f_) {
		if(this.get_length() == null) return;
		if(this.get_length() == 1) {
			if(Reflect.compareMethods(f_,this.func0)) {
				this.func0 = null;
				this.times0 = null;
				if(this.tellDisabled != null) this.tellDisabled();
			}
			return;
		}
		var _g1 = 0, _g = this.func.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.func[i],f_)) {
				this.func.splice(i,1);
				this.times.splice(i,1);
			}
		}
		if(this.get_length() == 1) {
			this.func0 = this.func[0];
			this.times0 = this.times[0];
			this.func = null;
			this.times0 = null;
		}
	}
	,swap: function(current_,new_) {
		this.remove(current_);
		this.add(new_);
	}
	,add: function(f_,once,amount) {
		if(this.get_length() == null) {
			this.func0 = f_;
			if(this.tellEnabled != null) this.tellEnabled();
			if(once != null) {
				if(once == true) this.times0 = 1; else this.times0 = -1;
			} else if(amount != null) this.times0 = amount; else this.times0 = -1;
			return;
		} else if(this.func == null) {
			this.func = new Array();
			this.times = new Array();
			this.func.push(this.func0);
			this.times.push(this.times0);
			this.func0 = null;
			this.times0 = null;
		}
		this.func.push(f_);
		if(once != null) {
			if(once == true) this.times.push(1); else this.times.push(-1);
		} else if(amount != null) this.times.push(amount); else this.times.push(-1);
	}
	,get_length: function() {
		if(this.func == null) {
			if(this.func0 != null) return 1; else return null;
		}
		return this.func.length;
	}
	,disableKill: function() {
		this.kill = function() {
			console.log("Can't kill other listeners unless enableKill");
		};
	}
	,enableKill: function() {
		this.kill = $bind(this,this.killAll);
	}
	,__class__: zpartanlite.DispatchTo
}
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
core.GlobalDiv._root = js.Browser.document;
jigsawx.JigsawMagicNumbers.dMore = 16.;
jigsawx.JigsawMagicNumbers.dinout = 10 / 1.5;
jigsawx.JigsawMagicNumbers.ellipseSmallx = 4.;
jigsawx.JigsawMagicNumbers.ellipseSmally = 22 / 6 / 1.5;
jigsawx.JigsawMagicNumbers.ellipseLargex = 7.5;
jigsawx.JigsawMagicNumbers.ellipseLargey = 6.;
jigsawx.JigsawMagicNumbers.stepSize = 10 / 1.5;
jigsawxtargets.hxjs.JigsawDivtastic.videoSrc = "big_buck_bunny.webm";
jigsawxtargets.hxjs.JigsawDivtastic.imageSrc = "tablecloth.jpg";
jigsawxtargets.hxjs.JigsawDivtastic.main();
})();
