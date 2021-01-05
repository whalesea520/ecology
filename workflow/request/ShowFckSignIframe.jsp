<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%
weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser (request , response) ;
if(user == null){
	return ;
}
%>
<html>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<%@ page import="weaver.general.BaseBean" %>
<body bgColor="transparent" onload="bodyresize()">
<%
	response.setContentType("text/html;charset=UTF-8");
	int logid = weaver.general.Util.getIntValue(request.getParameter("logid"), 0);
	String pagestr = "";
	//weaver.general.Util.null2String((String)session.getAttribute("FCKsignDesc_"+logid));
	java.util.Enumeration seccionANames = session.getAttributeNames();
	boolean hasSession = false;
    try{
    while(seccionANames!=null && seccionANames.hasMoreElements()){
    	String seccionAName = weaver.general.Util.null2String((String)seccionANames.nextElement());
    	if(seccionAName.equals("FCKsignDesc_"+logid)){
    		//hasSession = true;
    		break;
    	}
    }
    }catch(Exception e){}
    if(hasSession == false){
    	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
    	rs.execute("select remark,HandWrittenSign,remarklocation from workflow_requestlog where logid="+logid);
    	if(rs.next()){
    		//pagestr = weaver.general.Util.null2String(rs.getString(1));
    		int attachmentID = weaver.general.Util.getIntValue(rs.getString("HandWrittenSign"), 0);
    		if(attachmentID > 0){
            	pagestr += "<BR/><img name=\"handWrittenSign\" src=\"/weaver/weaver.file.FileDownload?fileid="+ attachmentID +"\" />";
            }
			pagestr += weaver.general.Util.null2String(rs.getString(1));
			
            String location = rs.getString("remarkLocation");
            String[] datas = location.split(",");
            if(!location.equals("") &&  datas.length ==4 ){ 
                String addr = datas[3];
                String lng = datas[1];
                String lat = datas[2];
                pagestr += "<br/><a __noShow style='height:20px;text-decoration:none;background: url(/ueditor/custbtn/images/positionSmall.png) no-repeat -2px 0px;text-indent: 30px;line-height:20px;cursor:pointer;color:#123885;font-family: &quot;微软雅黑&quot;,&quot;Microsoft YaHei&quot!important;display: inline-block;' onclick='try {parent.openMap("+lng+","+lat+",\""+addr+"\");} catch(e){openMap("+lng+","+lat+",\""+addr+"\");}' title='"+addr+"'>"+addr+"</a>";


            }
    	}
    }
	String retrunstr="";
	BaseBean baseBeanRigthMenu = new BaseBean();
	int userightmenu = 1;
	try{
		userightmenu = weaver.general.Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
%>
<script language="javascript">
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

var timecnt = 0;

function bodyresize(){

    if (timecnt > 20) {
        return ;
    } 
    timecnt++;
    
	if(document.body.scrollHeight==0){
		window.setTimeout("bodyresize()", 100);
		return;
	} else {
		parent.document.getElementById("FCKsigniframe<%=logid%>").height = parent.jQuery(contentTd).height() + 26;
	}

	var objAList=document.getElementsByTagName("A");
	for(var i=0; i<objAList.length; i++){
		var obj = objAList[i];
		var href = obj.href;
		var target = obj.target;
		if(href.indexOf("javascript:") == -1){
			obj.target = "_blank";
		}
	}
	
	//window.setTimeout("bodyresize()", 100);
}

<%if(userightmenu == 1){%>
  //作用：点右键的时候显示右键菜单
if(document.all && window.print){
	document.oncontextmenu = fckshowrightmenu;
	document.onclick = fckhiddenrightmenu;
}
function fckhiddenrightmenu(){
	parent.rightMenu.style.visibility="hidden";
}
function getAbsolutePosition(obj){
	position = new Object();
	position.x = 0;
	position.y = 0;
	var tempobj = obj;
	while(tempobj!=null && tempobj!=document.body){
		position.x += tempobj.offsetLeft + tempobj.clientLeft;
		position.y += tempobj.offsetTop + tempobj.clientTop;
		tempobj = tempobj.offsetParent
	}
	position.x += parent.document.body.scrollLeft;
	if(parent.document.getElementById("divWfBill")) position.y -= parent.document.getElementById("divWfBill").scrollTop;
	return position;
}
function fckshowrightmenu(){
	var position=getAbsolutePosition(parent.document.getElementById("FCKsigniframe<%=logid%>"));
	var rightedge=parent.document.body.clientWidth-event.clientX-position.x
	var bottomedge=parent.document.body.clientHeight-event.clientY-position.y
	if (rightedge<parent.rightMenu.offsetWidth){
		parent.rightMenu.style.left=parent.document.body.clientWidth-parent.rightMenu.offsetWidth
	}else{
		parent.rightMenu.style.left=position.x+event.clientX
	}
	if(bottomedge<parent.rightMenu.offsetHeight){
		parent.rightMenu.style.top=parent.document.body.clientHeight-parent.rightMenu.offsetHeight
	}else{
		parent.rightMenu.style.top=position.y+event.clientY
	}
	parent.rightMenu.style.visibility="visible"
	return false
}
<%}%>
</script>
<table class="ViewForm">
<tr>
<td style="WORD-break:break-all;" id="contentTd">
<%
	//System.out.println(pagestr);
	//脚本过滤
	while(pagestr.toLowerCase().indexOf("<script")!=-1){
		int startindx=pagestr.toLowerCase().indexOf("<script");
		int endindx=pagestr.toLowerCase().indexOf("</script>");
		if(endindx!=-1 && endindx>startindx){
			retrunstr+=pagestr.substring(0,startindx);
			pagestr=pagestr.substring(endindx+9);
		}
	}
	retrunstr+=pagestr;
	if(retrunstr.indexOf("<img")>-1){
		///////////
	  	String begin_logRemark = "";
	  	String new_logRemark = "";
	  	String end_logRemark = "";
	  	String cycleString = retrunstr;
	  	int f = 0;
		while(cycleString.indexOf("<img") > -1 ){
			f++;
		  	int b = cycleString.indexOf("<img");

		  	begin_logRemark = cycleString.substring(0,b);
		  	new_logRemark += begin_logRemark;
			cycleString = cycleString.substring(b);
			String imgString = "";
			int e = cycleString.indexOf("/>");
			imgString = cycleString.substring(0, e);
			new_logRemark += "<div class=\"small_pic\"><a pichref=\"pic_one"+f+"\" style=\"cursor:url('/images/preview/amplification_wev8.png'),auto;color:white!important;\" title=\""+SystemEnv.getHtmlLabelName(129381, user.getLanguage())+"\" >" + imgString + " onload=\"parent.image_resize(this);\" onresize=\"parent.image_resize(this);\" /> </a></div><div id=\"pic_one"+f+"\" style=\"display:none;\">" + imgString +" class=\"maxImg\" /></div>" ;			
			cycleString = cycleString.substring(e+2);
			end_logRemark = cycleString;
		}
		new_logRemark += end_logRemark;
		retrunstr = new_logRemark;
	  	///////////
  	}
	
	//System.out.println(retrunstr);
	out.print(retrunstr);
%>
</td>
</tr>
</table>
</body>
</html>