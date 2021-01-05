function compdate(a, b) {
    var arr = a.split("-");
    var starttime = new Date(arr[0], arr[1], arr[2]);
    var starttimes = starttime.getTime();

    var arrs = b.split("-");
    var lktime = new Date(arrs[0], arrs[1], arrs[2]);
    var lktimes = lktime.getTime();

    if (starttimes > lktimes) {
        return false;
    }
    else
        return true;
}
function comptime(beginTime,endTime) {
    var beginTimes = beginTime.substring(0, 10).split('-');
    var endTimes = endTime.substring(0, 10).split('-');

    beginTime = beginTimes[1] + '-' + beginTimes[2] + '-' + beginTimes[0] + ' ' + beginTime.substring(10, 19);
    endTime = endTimes[1] + '-' + endTimes[2] + '-' + endTimes[0] + ' ' + endTime.substring(10, 19);
    var a = (Date.parse(endTime) - Date.parse(beginTime)) / 3600 / 1000;
    if (a < 0) {
        alert("endTime小!");
    } else if (a > 0) {
        alert("endTime大!");
    } else if (a == 0) {
        alert("时间相等!");
    } else {
        return 'exception'
    }
}
function startWith(str,dim){     
	var reg=new RegExp("^"+dim);     
	return reg.test(str);        
}  
function openFullWindowHaveBar(url){
	  var redirectUrl = url ;
	  var width = screen.availWidth-10 ;
	  var height = screen.availHeight-50 ;
	  //if (height == 768 ) height -= 75 ;
	  //if (height == 600 ) height -= 60 ;
	   var szFeatures = "top=0," ;
	  szFeatures +="left=0," ;
	  szFeatures +="width="+width+"," ;
	  szFeatures +="height="+height+"," ;
	  szFeatures +="directories=no," ;
	  szFeatures +="status=yes,toolbar=no,location=no," ;
	  szFeatures +="menubar=no," ;
	  szFeatures +="scrollbars=yes," ;
	  szFeatures +="resizable=yes" ; //channelmode
	  window.open(redirectUrl,"",szFeatures) ;
}

 function doAjax(url,data,passobj,dataType){
 	    dataType=dataType||"html";
		jQuery.ajax({
			type: "post",
		    url:url,
		    data:data,
		    dataType:dataType,  
		    async: false ,
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    success:function (data, textStatus) {
		    	if (data == undefined || data == null) {
		    		alert("服务器运行出错!\n请联系系统管理员!");
		    		return;
		    	} else { 
		    		passobj.call(this,data);
		    	}
		    } 
	    });
}

function onShowHrm(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'add');
    }
}
function onShowHrms(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'add');
    }
}
function onShowDoc(fieldname) {
    var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function onShowWF(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function onShowCRM(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function onShowProj(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}

function transName(fieldname,id,name){
	var delname = fieldname;
	if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
	var restr = "";
	if(fieldname=="principalid"){
		restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
	}else{
		restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
	}
	restr += "<div style='float: left;'>";
	if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
		restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
	}else if(fieldname=="docids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
	}else if(fieldname=="wfids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
	}else if(fieldname=="crmids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
	}else if(fieldname=="projectids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
	}else if(fieldname=="taskids"){
		restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
	}else if(fieldname=="tag"){
		restr += name;
	}
	
	restr +="</div>"
		+ "<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>"
		+ "<div class='btn_wh'></div>"
		+ "</div>";
	return restr;
}