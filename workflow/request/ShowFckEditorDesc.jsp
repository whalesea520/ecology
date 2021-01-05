<%
weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser (request , response) ;
if(user == null){
	return ;
}
%>
<html>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<body bgColor="transparent" onload="bodyresize()" onclick="parent.triggerMouseupHandle()"> 
<%
    int requestid=weaver.general.Util.getIntValue((String)request.getParameter("requestid"));
    int userid=weaver.general.Util.getIntValue((String)request.getParameter("userid"));
    int fieldid=weaver.general.Util.getIntValue((String)request.getParameter("fieldid"));
    int rowno=weaver.general.Util.getIntValue((String)request.getParameter("rowno"));
    response.setContentType("text/html;charset=UTF-8");
    String pagestr=weaver.general.Util.null2String((String)session.getAttribute("FCKEDDesc_"+requestid+"_"+userid+"_"+fieldid+"_"+rowno));	
	session.removeAttribute("FCKEDDesc_"+requestid+"_"+userid+"_"+fieldid+"_"+rowno);
    java.util.Enumeration seccionANames = session.getAttributeNames();
    boolean hasSession = false;
    try{
    while(seccionANames!=null && seccionANames.hasMoreElements()){
    	String seccionAName = weaver.general.Util.null2String((String)seccionANames.nextElement());
    	if(seccionAName.equals("FCKEDDesc_"+requestid+"_"+userid+"_"+fieldid+"_"+rowno)){
    		hasSession = true;
    		break;
    	}
    }
    }catch(Exception e){}
    if(hasSession == false){
    	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
    	rs.execute("select workflowid from workflow_requestbase where requestid="+requestid);
    	if(rs.next()){
    		int workflowid = weaver.general.Util.getIntValue(rs.getString(1));
    		rs.execute("select formid, isbill from workflow_base where id="+workflowid);
    		if(rs.next()){
    			int formid = weaver.general.Util.getIntValue(rs.getString(1));
    			int isbill = weaver.general.Util.getIntValue(rs.getString(2));
    			String tablename = " workflow_form ";
    			if(isbill == 1){
    				rs.execute("select tablename from workflow_bill where id="+formid);
    				if(rs.next()){
    					tablename = weaver.general.Util.null2String(rs.getString(1));
    				}
    			}
    			if(!"".equals(tablename)){
    				String fieldname = "";
    				if(isbill == 1){
    					rs.execute("select fieldname from workflow_billfield where id="+fieldid);
    				}else{
    					rs.execute("select fieldname from workflow_formdict where id="+fieldid);
    				}
    				if(rs.next()){
    					fieldname = weaver.general.Util.null2String(rs.getString(1));
    					if(!"".equals(fieldname)){
    						rs.execute("select "+fieldname+" from "+tablename+" where requestid="+requestid);
    						if(rs.next()){
    							pagestr = weaver.general.Util.null2String(rs.getString(1));
    						}
    					}
    				}
    			}
    		}
    	}
    }
    String retrunstr="";
%>
<script>
function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ; 
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function bodyresize2() {
    parent.jQuery("#FCKiframe<%=fieldid%>").css("height", (document.body.scrollHeight + 25) + "px");
}

function bodyresize(){
	if(document.body.scrollHeight==0){
		window.setTimeout("bodyresize()", 100);
	} else {
		//alert(document.body.scrollHeight)
		//parent.document.getElementById("FCKiframe<%=fieldid%>").style.height=document.body.scrollHeight + 10;
		//parent.jQuery("#FCKiframe<%=fieldid%>").css("height", (document.body.scrollHeight + 25) + "px");
		setTimeout("bodyresize2()", 200);
	}

	var objAList=document.getElementsByTagName("A");
	for(var i=0;i<objAList.length;i++){
		var obj=objAList[i];
		var href=obj.href;
		//alert(href+":"+href.indexOf("javascript:"))
		var target=obj.target;
		if(href.indexOf("javascript:")==-1) {
			 //if(target==""){
				 obj.target="_blank";
			 //}
		}
	}
}



  //作用：点右键的时候显示右键菜单
  document.oncontextmenu = fckshowrightmenu;
  document.onclick = fckhiddenrightmenu;
  function fckhiddenrightmenu(){
      parent.hideRightClickMenu();
  }
function   getAbsolutePosition(obj)
{
    position   =   new   Object();
    position.x   =   0;
    position.y   =   0;
    var   tempobj   =   obj;
    while(tempobj!=null   &&   tempobj!=document.body)
    {
    position.x   +=   tempobj.offsetLeft   +   tempobj.clientLeft;
    position.y   +=   tempobj.offsetTop   +   tempobj.clientTop;
    tempobj   =   tempobj.offsetParent
    }
    position.x   +=   parent.document.body.scrollLeft;
    if(parent.document.getElementById("divWfBill")) position.y   -=   parent.document.getElementById("divWfBill").scrollTop;
    return  position;
}
function fckshowrightmenu(){

	var _left = 0;
	var _top = 0;
	
	var event = getEvent();
	//var position = getAbsolutePosition(parent.document.getElementById("FCKiframe<%=fieldid%>"));
	var position = jQuery("#FCKiframe<%=fieldid%>",parent.document).offset();
	var rightedge = parent.document.body.clientWidth-event.clientX-position.left;
	var bottomedge = parent.document.body.clientHeight-event.clientY-position.top+jQuery(parent).scrollTop();
	if (rightedge<parent.rightMenu.offsetWidth){
		_left = parent.document.body.clientWidth-parent.rightMenu.offsetWidth;
	}else{
		_left = position.left+event.clientX;
	}
	//console.log(bottomedge+"::"+position.top+"::"+parent.rightMenu.offsetHeight+"::"+parent.document.getElementById("FCKiframe<%=fieldid%>").offsetHeight+"::"+parent.document.body.clientHeight);
	if (bottomedge<parent.rightMenu.offsetHeight && parent.document.getElementById("FCKiframe<%=fieldid%>").offsetHeight<=parent.document.body.clientHeight){
		//_top = parent.document.body.clientHeight-parent.rightMenu.offsetHeight;
		_top = position.top+event.clientY-parent.rightMenu.offsetHeight;
		//console.log(_top);
	}else{
		_top = position.top+event.clientY;
	}
	console.log(_top);
	parent.showRightClickMenuByHand(_left,_top);
	
	return false
}

function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}
</script>
<%
    //System.out.println(pagestr);
    //脚本过滤
    int startindx = pagestr.toLowerCase().indexOf("<script");
    int endindx = pagestr.toLowerCase().indexOf("</script>");
    while(startindx != -1 && endindx != -1 && endindx > startindx){
        retrunstr += pagestr.substring(0, startindx);
        pagestr = pagestr.substring(endindx + 9);
        
        startindx = pagestr.toLowerCase().indexOf("<script");
        endindx = pagestr.toLowerCase().indexOf("</script>");
    }
    retrunstr+=pagestr;
    //System.out.println(retrunstr);
    out.print(retrunstr);
%>
</body>

</html>