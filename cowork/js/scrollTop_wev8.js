/*
 * 协作查看底部箭头，当页面高度大于浏览器高度并滚动滚动条时出现
 * */
var title;
if(languageid==8)
  title="up to the top";
else if(languageid==9)
  title="返回頂部";
else    
  title="返回顶部";
var scrolltotop={

setting: {startline:100, scrollto: 0, scrollduration:1000, fadeduration:[500, 100]},
controlHTML: '<img src="/cowork/images/up_wev8.png" style="width:24px; height:24px" />',
controlattrs: {offsetx:5, offsety:5},
anchorkeyword: '#top',
state: {isvisible:false, shouldvisible:false},
scrollup:function(){
if (!this.cssfixedsupport)
this.$control.css({opacity:0})
var dest=isNaN(this.setting.scrollto)? this.setting.scrollto : parseInt(this.setting.scrollto)
if (typeof dest=="string" && jQuery('#'+dest).length==1)
dest=jQuery('#'+dest).offset().top
else
dest=0
this.$body.animate({scrollTop: dest}, this.setting.scrollduration);
},
keepfixed:function(){
var $window=jQuery(window)
var controlx=$window.scrollLeft() + $window.width() - this.$control.width() - this.controlattrs.offsetx
var controly=$window.scrollTop() + $window.height() - this.$control.height() - this.controlattrs.offsety
this.$control.css({left:controlx+'px', top:controly+'px'})
},
togglecontrol:function(){
var scrolltop=jQuery(window).scrollTop()
if (!this.cssfixedsupport)
this.keepfixed()
this.state.shouldvisible=(scrolltop>=this.setting.startline)? true : false
if (this.state.shouldvisible && !this.state.isvisible){
this.$control.stop().animate({opacity:1}, this.setting.fadeduration[0])
this.state.isvisible=true
}
else if (this.state.shouldvisible==false && this.state.isvisible){
this.$control.stop().animate({opacity:0}, this.setting.fadeduration[1])
this.state.isvisible=false
}
},
init:function(){
jQuery(document).ready(function($){
var mainobj=scrolltotop
var iebrws=document.all
mainobj.cssfixedsupport=!iebrws || iebrws && document.compatMode=="CSS1Compat" && window.XMLHttpRequest //not IE or IE7+ browsers in standards mode
mainobj.$body=(window.opera)? (document.compatMode=="CSS1Compat"? $('html') : $('body')) : $('html,body')
mainobj.$control=$('<div id="topcontrol">'+mainobj.controlHTML+'</div>')
.css({position:mainobj.cssfixedsupport? 'fixed' : 'absolute', bottom:mainobj.controlattrs.offsety, right:mainobj.controlattrs.offsetx, opacity:0, cursor:'pointer'})
.attr({title:title})
.click(function(){mainobj.scrollup(); return false})
.appendTo('body')
if (document.all && !window.XMLHttpRequest && mainobj.$control.text()!='') //loose check for IE6 and below, plus whether control contains any text
mainobj.$control.css({width:mainobj.$control.width()}) //IE6- seems to require an explicit width on a DIV containing text
mainobj.togglecontrol()
$('a[href="' + mainobj.anchorkeyword +'"]').click(function(){
mainobj.scrollup()
return false
})
$(window).bind('scroll resize', function(e){
mainobj.togglecontrol()
})
})
}
}
scrolltotop.init()