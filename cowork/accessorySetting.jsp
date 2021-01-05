
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("CoWorkAccessory:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String method = Util.null2String(request.getParameter("method"));
  String pathcategory = "";
  String maincategory = "";
  String subcategory = "";
  String seccategory = "";
  if(method.equals("save")){
	  pathcategory = Util.null2String(request.getParameter("pathcategory"));
	  maincategory = Util.null2String(request.getParameter("maincategory"));
	  subcategory = Util.null2String(request.getParameter("subcategory"));
	  seccategory = Util.null2String(request.getParameter("seccategory"));
	  RecordSet.executeSql("delete from CoworkAccessory");
	  RecordSet.executeSql("insert into CoworkAccessory values('"+pathcategory+"','"+maincategory+"','"+subcategory+"','"+seccategory+"')"); 	
	  %>
    <script language=javascript>
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
	  window.location = "accessorySetting.jsp";
    </script>
  <%}
  int maxsize = 0;
  RecordSet.executeSql("select * from CoworkAccessory");
	if(RecordSet.next()){
		//pathcategory = Util.null2String(RecordSet.getString(1));
	  maincategory = Util.null2String(RecordSet.getString(2));
	  subcategory = Util.null2String(RecordSet.getString(3));
	  seccategory = Util.null2String(RecordSet.getString(4));
	  
	  pathcategory = SecCategoryComInfo.getAllParentName(seccategory,true);
	}
  %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21274,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(21274,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="submitData()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=weaver action="accessorySetting.jsp" method=post>
<input type=hidden id='method' name='method'>
<input type=hidden id='pathcategory' name='pathcategory' value="<%=pathcategory%>">
<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21274,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=Browser onClick="onShowCatalog(mypathspan)" name=selectCategory></BUTTON>
			<span id=mypathspan>
			<%if(pathcategory.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle>
			<%}else{%><%=pathcategory%><%}%>
			</span>
			<INPUT type=hidden id='mypath' name='mypath' value="<%=pathcategory%>">
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>  
function submitData(){
	if(check_form(weaver,"mypath")){
		document.all("method").value="save";
		weaver.submit();
	}
}
function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
          document.all("mypath").value=wuiUtil.getJsonValueByIndex(result,2);
          document.all("pathcategory").value=wuiUtil.getJsonValueByIndex(result,2);
          document.all("maincategory").value=wuiUtil.getJsonValueByIndex(result,3);
          document.all("subcategory").value=wuiUtil.getJsonValueByIndex(result,4);
          document.all("seccategory").value=wuiUtil.getJsonValueByIndex(result,1);
        }else{
          spanName.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
          document.all("mypath").value="";
          document.all("pathcategory").value="";
          document.all("maincategory").value="";
          document.all("subcategory").value="";
          document.all("seccategory").value="";
        }
    }
}
</script>
