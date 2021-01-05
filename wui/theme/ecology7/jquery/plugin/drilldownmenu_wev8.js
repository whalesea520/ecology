//** Drill Down Menu v1.0- (c) Dynamic Drive DHTML code library: http://www.dynamicdrive.com
//** Script Download/ instructions page: http://www.dynamicdrive.com/dynamicindex1/drilldownmenu.htm
//** June 8th, 2009: Script Creation date
//** June 10th, 2009: v1.01: Minor update

//Version 1.5: June 21st, 09':
//**1) Ability to include menu from external file and added to page via Ajax
//**2) Adds support for arbitrary links to act as "back buttons" for a drill menu. Just give the link a rel="drillback-menuid" attribute
//**3) Adds drillmenuinstance.back() method, which can be called on demand to go back one level within drill menu
//**4) Fixes bug with background ULs being visible following foreground UL contents
//**5) Updated css so browsers with JS disabled will get a scrolling, fixed height UL

//Version 1.6: August 9th, 09': Adds ability to specify explicit height for main menu, instead of defaulting to top UL's natural height.


function drilldownmenu(setting){
	this.sublevelarrow={src:'/wui/theme/ecology7/page/images/leftmenu/item_right_wev8.gif', width:'8px', top:'3px', left:'6px'}; //full URL to image used to indicate there's a sub level
	this.breadcrumbarrow='/wui/theme/ecology7/page/images/leftmenu/url_right_wev8.gif'; //full URL to image separating breadcrumb links (if it's defined)
	this.loadingimage='/wui/theme/ecology7/page/images/leftmenu/loader_wev8.gif'; //full URL to 'loading' image, if menu is loaded via Ajax
	this.homecrumbtext = (setting.homeDir == undefined || setting.homeDir == null || setting.homeDir == "") ? '门户' : setting.homeDir; //Top level crumb text
	this.titlelength=35; //length of parent LI text to extract from to use as crumb titles
	this.backarrow='/wui/theme/ecology7/page/images/leftmenu/leftarrow_wev8.gif'; //full URL to image added in front of back LI 

	////////// No need to edit beyond here /////////////
	this.menuid=setting.menuid
	this.$menudiv=null
	this.mainul=null
	this.$uls=null
	this.navdivs={}
	this.menuheight=setting.menuheight || 'auto'
	this.selectedul=setting.selectedul || null
	this.speed=setting.speed || 70
	this.persist=setting.persist || {enable: false, overrideselectedurl: false}
	this.$arrowimgs=null
	this.currentul=0
	this.filesetting=setting.filesetting || {url: null, targetElement: null}
	this.zIndexvalue=100
	this.arrowposx=0 //default arrow x position relative to parent LI
	var thisdrill=this
	jQuery(document).ready(function($){
		if (thisdrill.filesetting.url && thisdrill.filesetting.url.length>0){ //menu defined inside external file (use Ajax)?
			var $dest=(typeof thisdrill.filesetting.targetElement=="string")? $('#'+thisdrill.filesetting.targetElement) : null
			if (!$dest || $dest.length!=1){ //if target element isn't defined or multiple targets found
				alert("Error: The target element \"" + thisdrill.filesetting.targetElement + "\" to add the menu into doesn't exist or is incorrectly specified.")
				return
			}
			$dest.html('<img src="'+thisdrill.loadingimage+'" style="vertical-align:middle" /> <b>Loading Drill Down Menu...</b>')
			$.ajax({
				url: thisdrill.filesetting.url,
				error:function(ajaxrequest){
					alert('Error fetching Ajax content.\nServer Response: '+ajaxrequest.responseText)
				}, //end error
				success:function(content){
					$dest.html(content)
					thisdrill.init($, setting)
				} //end success
			}) //end ajax
		}
		else{ //if inline menu
			thisdrill.init($, setting)
		}
	}) //end document.ready
}

drilldownmenu.prototype.init=function($, setting){
		var thisdrill=this
		var $maindiv=$('#'+setting.menuid).css({position:'relative'}) //relative position main DIV
		var $uls=$maindiv.find('ul')
		$uls.css({position:'absolute', left:0, top:0, visibility:'hidden'}) //absolutely position ULs
		this.$maindiv=$maindiv
		this.$uls=$uls
		this.navdivs.$crumb=$('#'+setting.breadcrumbid)
		this.navdivs.$backbuttons=$('a[rel^="drillback-'+setting.menuid+'"]').css({outline:'none'}).click(function(e){

			thisdrill.back()
			e.preventDefault()
		})
		this.buildmenu($)
		$(window).bind('unload', function(){
			thisdrill.uninit()
		})
		setting=null	
}

drilldownmenu.prototype.buildmenu=function($){
	var thisdrill=this
	var liparent = null;
	this.$uls.each(function(i){ //loop through each UL
		var $thisul=$(this)
		if (i==0){ //if topmost UL
			//$('<li class="backcontroltitle">Site Navigation</li>').prependTo($thisul).click(function(e){e.preventDefault()})
			thisdrill.$maindiv.css({height:(thisdrill.menuheight=='auto')? $thisul.outerHeight() : parseInt(thisdrill.menuheight), overflow:'hidden'}) //set main menu DIV's height to top level UL's height
				.data('h', parseInt(thisdrill.$maindiv.css('height')))
			
		}
		else{ //if this isn't the topmost UL
			var $parentul=$thisul.parents('ul:eq(0)')
			var $parentli=$thisul.parents('li:eq(0)')
			/*
			$('<li class="backcontrol"><img src="'+thisdrill.backarrow+'" style="border-width:0" /> Back one level</li>') //add back LI item
				.click(function(e){thisdrill.back(); e.preventDefault()})
				.prependTo($thisul)
			*/
			var $anchorlink=$parentli.children('a:eq(0)').css({outline:'none'}).data('control', {order:i}) //remove outline from anchor links
			//var $arrowimg=$('<img class="arrowclass" />').attr('src', thisdrill.sublevelarrow.src).css({position:'absolute', borderWidth:0, paddingTop:thisdrill.sublevelarrow.top, left:$parentli.width()-parseInt(thisdrill.sublevelarrow.width)-parseInt(thisdrill.sublevelarrow.left)}).prependTo($anchorlink)
			var $arrowimg=$('<img class="arrowclass" style="margin-top:4px;display:block; "/>').attr('src', thisdrill.sublevelarrow.src).css({position:'absolute', borderWidth:0, paddingTop:thisdrill.sublevelarrow.top, left:$parentli.width()-parseInt(thisdrill.sublevelarrow.width)-parseInt(thisdrill.sublevelarrow.left)}).prependTo($anchorlink)
			
			$anchorlink.click(function(e){ //assign click behavior to anchor link
				thisdrill.slidemenu(jQuery(this).data('control').order);
				e.preventDefault();
				callback("hide", $anchorlink, $parentli);
			})
		}
		var ulheight=($thisul.outerHeight() < thisdrill.$maindiv.data('h'))? thisdrill.$maindiv.data('h') : 'auto'
		$thisul.css({visibility:'visible', width:'100%', height:ulheight, left:(i==0)? 'auto' : $parentli.outerWidth(), top:0})
		$thisul.data('specs', {w:$thisul.outerWidth(), h:$thisul.outerHeight(), order:i, parentorder:(i==0)? -1 : $anchorlink.parents('ul:eq(0)').data('specs').order, x:(i==0)? $thisul.position().left : $parentul.data('specs').x+$parentul.data('specs').w, title:(i==0)? thisdrill.homecrumbtext : $parentli.find('a:eq(0)').text().substring(0, thisdrill.titlelength)})
	}) //end UL loop
	var selectedulcheck=this.selectedul && document.getElementById(this.selectedul) //check if "selectedul" defined, plus if actual element exists
	this.$arrowimgs=this.$maindiv.find('img.arrowclass')
	this.arrowposx=parseInt(this.$arrowimgs.eq(0).css('left')) //get default x position of arrow
	if (window.opera)
		this.$uls.eq(0).css({zIndex: this.zIndexvalue}) //Opera seems to require this in order for top level arrows to show
	if (this.persist.enable && (this.persist.overrideselectedul || !this.persist.overrideselectedul && !selectedulcheck) && drilldownmenu.routines.getCookie(this.menuid)){ //go to last persisted UL?
		var ulorder=parseInt(drilldownmenu.routines.getCookie(this.menuid))
		this.slidemenu(ulorder, true)
	}
	else if (selectedulcheck){ //if "selectedul" setting defined, slide to that UL by default
		var ulorder=$('#'+this.selectedul).data('specs').order
		this.slidemenu(ulorder, true)
	}
	else{
		this.slidemenu(0, true)
	}
	this.navdivs.$crumb.click(function(e){ //assign click behavior to breadcrumb div
		if (e.target.tagName=="A"){
			var order=parseInt(e.target.getAttribute('rel'))
			if (!isNaN(order)){ //check link contains a valid rel attribute int value (is anchor link)
				thisdrill.slidemenu(order)
				e.preventDefault();
				callback("show", null, null);
			}
		}
		
	})
}

drilldownmenu.prototype.slidemenu=function(order, disableanimate){
	var order=isNaN(order)? 0 : order
	this.$uls.css({display: 'none'})
	var $targetul=this.$uls.eq(order).css({zIndex: this.zIndexvalue++})

	$targetul.parents('ul').andSelf().css({display: 'block'})
	this.currentul=order
	if ($targetul.data('specs').h > this.$maindiv.data('h')){
		//this.$maindiv.css({overflowY:'auto'}).scrollTop(0)
		this.$maindiv.css("height", $targetul.data('specs').h);
		this.$arrowimgs.css('left', this.arrowposx-15) //adjust arrow position if scrollbar is added
	}
	else{
		this.$maindiv.css({overflowY: 'hidden'}).scrollTop(0)
		this.$arrowimgs.css('left', this.arrowposx)
	}
	
	this.updatenav($, order)
	this.$uls.eq(0).animate({left:-$targetul.data('specs').x}, typeof disableanimate!="undefined"? 0 : this.speed)
}

drilldownmenu.prototype.back=function(){
	if (this.currentul>0){
		var order=this.$uls.eq(this.currentul).parents('ul:eq(0)').data('specs').order
		this.slidemenu(order)
	}
}

drilldownmenu.prototype.updatenav=function($, endorder){
	var $currentul=this.$uls.eq(endorder)
	if (this.navdivs.$crumb.length==1){ //if breadcrumb div defined
		var $crumb=this.navdivs.$crumb.empty()
		if (endorder>0){ //if this isn't the topmost UL (no point in showing crumbs if it is)
			var crumbhtml=''
			while ($currentul && $currentul.data('specs').order>=0){
				crumbhtml=' <img src="'+this.breadcrumbarrow+'" /> <a href="#nav" rel="'+$currentul.data('specs').order+'">'+$currentul.data('specs').title+'</a>'+crumbhtml
				$currentul=($currentul.data('specs').order>0)? this.$uls.eq($currentul.data('specs').parentorder) : null
			}
			$crumb.append(crumbhtml).find('img:eq(0)').remove().end().find('a:last').replaceWith(this.$uls.eq(endorder).data('specs').title) //remove link from very last crumb trail
		}
		else{
			$crumb.append(this.homecrumbtext)
		}
	}
	if (this.navdivs.$backbuttons.length>0){ //if back buttons found
		if	(!/Safari/i.test(navigator.userAgent)) //exclude Safari from button state toggling due to bug when the button is an image link
			this.navdivs.$backbuttons.css((endorder>0)? {opacity:1, cursor:'pointer'} : {opacity:0.5, cursor:'default'})
	}
}

drilldownmenu.prototype.uninit=function(){
	if (this.persist.enable)
		drilldownmenu.routines.setCookie(this.menuid, this.currentul)
}

drilldownmenu.routines={

	getCookie:function(Name){ 
		var re=new RegExp(Name+"=[^;]*", "i"); //construct RE to search for target name/value pair
		if (document.cookie.match(re)) //if cookie found
			return document.cookie.match(re)[0].split("=")[1] //return its value
		return null
	},

	setCookie:function(name, value){
		document.cookie = name+"="+value+"; path=/"
	}

}
