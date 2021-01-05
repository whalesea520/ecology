    var rightMenu ;
    var curTab;
	var languageid=readCookie("languageidweaver");
	var msg = "";
	if(languageid==7){
		msg = "正在载入数据...";
	}else if(languageid==8){
		msg = "Loading data...";
	}
	var loading="<img src='/js/src/widget/templates/images/progress_wev8.gif'/>&nbsp;"+msg;
	
    function showRightClickMenu(e) {
    	
    	 var event = e?e:(window.event?window.event:null);
        var rightedge = document.body.clientWidth - event.clientX;
        var bottomedge = document.body.clientHeight - event.clientY;
        //rightMenu =document.getElementById("rightMenu")
        if (rightedge < rightMenu.offsetWidth)
            rightMenu.style.left = document.body.scrollLeft + event.clientX - rightMenu.offsetWidth + curTab.scrollLeft;
        else
            rightMenu.style.left = document.body.scrollLeft + event.clientX + curTab.scrollLeft;
        if (bottomedge < rightMenu.offsetHeight)
            rightMenu.style.top = document.body.scrollTop + event.clientY - rightMenu.offsetHeight + curTab.scrollTop - curTab.offsetTop;
        else
            rightMenu.style.top = document.body.scrollTop + event.clientY + curTab.scrollTop- curTab.offsetTop;
        
        rightMenu.style.visibility="visible";
    	rightMenu.style.display="";	
       // alert(jQuery("div[name='rightMenu']").length)
        //jQuery("div[name='rightMenu']").show();
        //alert(rightMenu.innerHTML)
    		//evt.stopPropagation();
        event.cancelBubble = true;
        event.returnValue = false; 
        return false;
    }

    function hideRightClickMenu() {
    	//rightMenu =document.getElementById("rightMenu")
        rightMenu.style.visibility = "hidden";
    }

    function initMenu(tab) {
    	
        curTab = tab;
        elements = tab.getElementsByTagName("div");
        /*for (i = 0; i < elements.length; i++) {
            elem = elements[i];
            alert(elem.name)
            if (elem.name == "rightMenu") {
            	//rightMenu = JQuery.(tab) document.getElementById("rightMenu")
                rightMenu = elem;
                break;
            }

        }*/
        rightMenu = jQuery(tab).find("div[name=rightMenu]")[0];
        if (document.all && window.print) {
        	//rightMenu =document.getElementById("rightMenu")
            rightMenu.className = "clickRightMenu"
            document.oncontextmenu = showRightClickMenu
            document.body.onclick = hideRightClickMenu

            // rightMenu.style.left = document.body.clientWidth - rightMenu.offsetWidth - 20
            // rightMenu.style.top = 35
            //rightMenu.style.visibility = "visible"
        }else{
        	//rightMenu =document.getElementById("rightMenu")
            rightMenu.className = "clickRightMenu"
        	document.oncontextmenu = showRightClickMenu
        	//document.oncontextmenu=showRightClickMenu
        	document.body.onclick = hideRightClickMenu
        }
    }

    function doGet(tab, str) {
    	
    	//jQuery("div[dojoType='Tab']").not("iframe").html('');
    	/*jQuery("div[dojoType='Tab']").each(function(i,obj){
    		if(jQuery(obj).children(":first").attr("tagName")!="IFRAME"){
    			jQuery(obj).html("");
    		}
    	})*/
    	//jQuery("div[id^='ajax']").remove();
    	//jQuery("div[id^='rightMenu']").remove();
    	
    	
        tab.innerHTML = "<img src='/js/src/widget/templates/images/progress_wev8.gif'/>&nbsp;"+msg;
        var bindArgs = {
            url:  str,
            load: function(type, data, evt) {
        	
        		//alert(data)
                tab.innerHTML = data;
            }
        };
        dojo.io.bind(bindArgs);

    }
    function doPost(form,container, secCallback) {
        //tab11.innerHTML = "Loading...";
    	form=document.getElementsByName(form.name).length>0?document.getElementsByName(form.name)[0]:undefined;
    	
    	if(form==undefined){
    		return;
    	}
        var kw = {
            formNode: form,
            load: function(t, txt, e) {
            	container.innerHTML = txt;
                if (secCallback) {
                	secCallback();
                }
            },
            error: function(t, e) {
                alert("Error!... " + e.message);
            }
        };
        dojo.io.bind(kw);
        container.innerHTML = "<img src='/js/src/widget/templates/images/progress_wev8.gif'/>&nbsp;"+msg;
        return false;

    }
    function viewSource()
{
	window.location = "view-source:" + window.location.href ;
}

function viewProperty(url)
{
	window.prompt("theUrlIs:","E:/ecology/ecology2643"+url) ;
}
function cmdCopy(){
	document.execCommand('Copy') ;
}

//only TEXTAREA and (type="text" INPUT) can paste
function cmdPaste(){
    var activeTagName = document.activeElement.tagName;
    var activeTagType = document.activeElement.type;
    if(activeTagName=="TEXTAREA"){
        document.execCommand('Paste');
    }
    if(activeTagName=="INPUT"&&activeTagType=="text"){
        document.execCommand('Paste');
    }
}