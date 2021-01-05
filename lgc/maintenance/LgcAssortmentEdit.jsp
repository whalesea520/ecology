
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
function initImg(img,w,h){
	var getResize=function(width,height,SCALE_WIDTH,SCALE_HEIGHT){
		var sizes=new Array(2);
		var rate=0;
		if(width<=SCALE_WIDTH && height<=SCALE_HEIGHT){
			sizes[0]=width;
			sizes[1]=height;
			return sizes;
		}
			
		if(width>=height){
			rate=height/width;
			sizes[0]=SCALE_WIDTH;
			sizes[1]=Math.ceil(SCALE_WIDTH*rate);
		}else{//height>width.
			rate=width/height;
			sizes[0]=Math.ceil(SCALE_HEIGHT*rate);
			sizes[1]=SCALE_HEIGHT;
		}
		return sizes;
	}
	var srcImg=new Image();
	srcImg.src=img.src;
	var size=getResize(parseInt(srcImg.width),parseInt(srcImg.height),w,h);
	img.width=size[0];
	img.height=size[1];
}

function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.weaver.operation.value="delpic";
		document.weaver.submit();
	}
}

function checkSubmit(){
    if(check_form(weaver,'assortmentname')){
    	document.weaver.operation.value="editassortment";
        weaver.submit();
    }
}
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "/lgc/maintenance/LgcAssortment.jsp";
	parentWin.closeDialog();
}

jQuery(function(){
	checkinput("assortmentname","assortmentnameimage");
});
</script>
</head>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
String iself = Util.null2String(request.getParameter("iself")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String assortmentid = paraid;

RecordSet.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSet.next();

String assortmentmark = RecordSet.getString("assortmentmark");
String assortmentname = RecordSet.getString("assortmentname");
String seclevel = RecordSet.getString("seclevel");
String resourceid = RecordSet.getString("resourceid");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String assortmentimageid = Util.getFileidOut(RecordSet.getString("assortmentimageid")) ;				 
String subassortmentcount= RecordSet.getString("subassortmentcount");
String assetcount= RecordSet.getString("assetcount");
String tff01name = RecordSet.getString("tff01name");
String tff02name = RecordSet.getString("tff02name");
String tff03name = RecordSet.getString("tff03name");
String tff04name = RecordSet.getString("tff04name");
String tff05name = RecordSet.getString("tff05name");
String nff01name = RecordSet.getString("nff01name");
String nff02name = RecordSet.getString("nff02name");
String nff03name = RecordSet.getString("nff03name");
String nff04name = RecordSet.getString("nff04name");
String nff05name = RecordSet.getString("nff05name");
String dff01name = RecordSet.getString("dff01name");
String dff02name = RecordSet.getString("dff02name");
String dff03name = RecordSet.getString("dff03name");
String dff04name = RecordSet.getString("dff04name");
String dff05name = RecordSet.getString("dff05name");
String bff01name = RecordSet.getString("bff01name");
String bff02name = RecordSet.getString("bff02name");
String bff03name = RecordSet.getString("bff03name");
String bff04name = RecordSet.getString("bff04name");
String bff05name = RecordSet.getString("bff05name");

boolean canedit = HrmUserVarify.checkUserRight("CrmProduct:Add", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(178,user.getLanguage())+" : "+ Util.toScreen(assortmentname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32655,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=weaver action=LgcAssortmentOperation.jsp method=post enctype="multipart/form-data">
<input type="hidden" name="assortmentid" value="<%=assortmentid%>">
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="iself" value="<%=iself%>">
<input type="hidden" name="operation">

<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage()) %></wea:item>
		<wea:item>
			<wea:required id="assortmentnameimage" required="true">
				
					<INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="assortmentname" value="<%=Util.toScreenToEdit(assortmentname,user.getLanguage())%>" onchange='checkinput("assortmentname","assortmentnameimage")' >
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(596,user.getLanguage()) + SystemEnv.getHtmlLabelName(178,user.getLanguage()) %></wea:item>
		<wea:item>
			<span>
				<brow:browser viewType="0" name="supassortmentid" 
	               	browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp?newtype=assort"
	               	browserValue='<%=supassortmentid %>'
	               	browserSpanValue='<%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(supassortmentid),user.getLanguage()) %>'
	               	isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1' 
	               	completeUrl="/data.jsp?type=-99995" width='267px'>
	             </brow:browser>  	
	             
       		</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage()) %></wea:item>
		<wea:item> 
 			<TEXTAREA class=InputStyle style="WIDTH: 284px" name=Remark rows=4><%=assortmentremark %></TEXTAREA>
		</wea:item>
		
        <wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %></wea:item>
        <wea:item> 
         	<% if(assortmentimageid.equals("") || assortmentimageid.equals("0")) {%> 
          	<input class=InputStyle  type="file" name=assortmentimage style='width:284px'>
          	<%} else {%>
          	<img onload="initImg(this,100,100)" style="padding-top:8px;padding-bottom:8px;" border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assortmentimageid%>"> 
          	<input type="button" onclick="javascript:onDelPic()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>">
          	 <% } %>
          	<input type="hidden" name="oldassortmentimage" value="<%=assortmentimageid%>">
        </wea:item>
	</wea:group>
</wea:layout>
			
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>
</HTML>
