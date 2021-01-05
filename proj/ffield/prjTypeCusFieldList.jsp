<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<%

int strProTypeId = Util.getIntValue(request.getParameter("proTypeId"),0);

%>
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">


function doDel(id,scopeid){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	if(!scopeid){
		scopeid='<%=strProTypeId %>';
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
	jQuery.ajax({
		url:"/docs/category/docajax_operation.jsp",
		type:"post",
		data:{
			src:"prjtypeCusFieldDelete",
			id:id,
			scopeid:scopeid
		},
		success:function(data){
			_table.reLoad();
		}
	});
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id,scopeid){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=56&isdialog=1&fromProj=1&proTypeId=<%=strProTypeId %>";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,17037",user.getLanguage())%>";
		dialog.Height = 500;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=57&isdialog=1&fromProj=1&proTypeId="+scopeid+"&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17037",user.getLanguage())%>";
		dialog.Height = 500;
	}
	dialog.maxiumnable = true;
	dialog.Width = 650;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function htmltypeChange(obj){
	if(obj.value==1){
		jQuery("#typeDiv").html(jQuery("#ftype1").html());
		jQuery("#type").removeAttr("notBeauty");
		beautySelect("#type");
		hideGroup("selectItemArea")
		showEle("type");
	}else if(obj.value==2||obj.value==4){
		jQuery("#typeDiv").html("");
		hideEle("type");
		hideGroup("selectItemArea")
	}else if(obj.value==3){
		jQuery("#typeDiv").html(jQuery("#ftype2").html());
		showEle("type");
		jQuery("#type").removeAttr("notBeauty");
		beautySelect("#type");
		hideGroup("selectItemArea")
	}else if(obj.value==5){
		showGroup("selectItemArea")
		hideEle("type");
	}
	
}


</script>
<script type="text/javascript">
$(function(){
	var cptgroupname='<%=ProjectTypeComInfo.getProjectTypename(""+strProTypeId) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(18630,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});
</script>
<%--
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
 --%>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("fieldlabel"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
String type = Util.null2String(request.getParameter("type"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit",user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit",user)&&strProTypeId>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit",user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit",user)&&strProTypeId>0){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%}%>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"  onchange=""/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form action="" name="searchfrm" id="searchfrm">
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></wea:item>
				<wea:item><input type="text"  class=InputStyle id="fieldlabel"  name="fieldlabel" value='<%=qname%>'></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(23241,user.getLanguage())%></wea:item>
				<wea:item><input type="text"  class=InputStyle id="fieldname"  name="fieldname" value='<%=fieldname%>'></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
				<wea:item>
					<select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)">
						<option value="" ></option>
						<option value="1" <%=fieldhtmltype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
						<option value="2" <%=fieldhtmltype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
						<option value="3" <%=fieldhtmltype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
						<option value="4" <%=fieldhtmltype.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
						<option value="5"<%=fieldhtmltype.equals("5")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
				    </select>
			    </wea:item>
			    <%String typeAttr = "{'samePair':'type','display':'"+((fieldhtmltype.equals("1")||fieldhtmltype.equals("3"))?"":"none")+"'}"; %>
			    <wea:item attributes='<%=typeAttr %>'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				<wea:item attributes='<%=typeAttr %>'>
					<span id="typeDiv">
						<%if(fieldhtmltype.equals("1")){ %>
						<select size=1 name=type">
							<option value="" ></option>
							<option value="1" <%=type.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
							<option value="2" <%=type.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
							<option value="3" <%=type.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						</select>
					<%}else{ %>
						<select size=1 id="type" name=type" >
					    <option value="" ></option>
					    <%while(BrowserComInfo.next()){
					    		 	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
						        	 //屏蔽集成浏览按钮-zzl
									continue;
								}
					    %>
							<option <%=type.equals(BrowserComInfo.getBrowserid())?"selected":"" %> value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
					    <%}%>
						</select>
					<%} %>
					</span>
				</wea:item>
			</wea:group>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="zd_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="zd_btn_cancle" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="zd_btn_cancle" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
	<div style="DISPLAY: none" id="ftype1">
	<select notBeauty="true" size=1 id="type" name=type onChange = "typeChange(this)" >
		<option value="" ></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype2">
	<select notBeauty="true" size=1 id="type" name=type onChange = "broswertypeChange(this)" >
    <option value="" ></option>
    <%while(BrowserComInfo.next()){
    		 	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
	        	 //屏蔽集成浏览按钮-zzl
				continue;
			}
    %>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
    <%}%>
	</select>
</div>
</div>
<%

String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "prj_prjtypefieldlist");//操作项类型
operatorInfo.put("operator_num", 2);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

String userid=""+user.getUID();

String backfields= "  t1.* ,t2.id, t2.fielddbtype, t2.fieldhtmltype, t2.type, t2.fieldname, t2.fieldlabel  ";
String fromsql=" cus_formfield t1, cus_formdict t2 ";
String sqlWhere = " where t1.scope='ProjCustomField'  and t1.fieldid=t2.id ";
if(strProTypeId>0 ){
	sqlWhere+=" and scopeid='"+strProTypeId+"' ";
}

if(!qname.equals("")){
	sqlWhere += " and fieldlabel like '%"+qname+"%'";
}
if(!fieldname.equals("")){
	sqlWhere += " and fieldname like '%"+fieldname+"%'";
}
if(!fieldhtmltype.equals("")){
	sqlWhere += " and fieldhtmltype = '"+fieldhtmltype+"'";
}
if(!type.equals("")){
	sqlWhere += " and type = '"+type+"'";
}
	String  operateString= "";
	/**operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getDocCusFieldOperate\" otherpara=\""+HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit", user)+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog();\" otherpara='column:scopeid' text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" otherpara='column:scopeid' text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	**/
	 String tabletype="none";
	 if(HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit",user)){
	 	tabletype = "checkbox";
	 }
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_CUSFIELDLIST+"\" instanceid=\"docMouldTable\" needPage=\"false\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_CUSFIELDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.proj.util.ProjectTransUtil.getCanDelPrjtypeField\" popedompara = \"column:id+column:scopeid+column:fieldname\"  />"+
	   "<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\""+Util.toHtmlForSplitPage(fromsql)+"\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"15%\" transmethod=\"weaver.general.KnowledgeTransMethod.getCusFieldName\" text=\""+SystemEnv.getHtmlLabelName(23241,user.getLanguage())+"\" otherpara=\"column:id\" column=\"fieldname\"  orderkey=\"fieldname\"/>"+
			 "<col width=\"15%\"  transmethod=\"weaver.proj.util.ProjectTransUtil.getHtmlLabelName\" text=\""+SystemEnv.getHtmlLabelName(30828,user.getLanguage())+"\" column=\"prj_fieldlabel\" otherpara=\""+(""+user.getLanguage())+"+column:fieldlable\" orderkey=\"prj_fieldlabel\"/>";
if(strProTypeId<=0){
tableString+="<col width=\"20%\"  transmethod=\"weaver.proj.Maint.ProjectTypeComInfo.getProjectTypename\" text=\""+SystemEnv.getHtmlLabelName(586,user.getLanguage())+"\" column=\"scopeid\"  orderkey=\"scopeid\"/>";
}
tableString+="<col width=\"15%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getCusFieldType\" text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" otherpara=\"column:type+"+user.getLanguage()+"\" orderkey=\"fieldhtmltype\"/>"+
			"<col width=\"15%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"fielddbtype\"/>"+
			"<col width=\"8%\"  transmethod=\"weaver.proj.util.ProjectTransUtil.getImgTrueOrFalse\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" column=\"isuse\"/>"+
			"<col width=\"8%\"  transmethod=\"weaver.proj.util.ProjectTransUtil.getImgTrueOrFalse\" text=\""+SystemEnv.getHtmlLabelName(18019,user.getLanguage())+"\" column=\"ismand\"/>"+
			"<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(88,user.getLanguage())+"\" column=\"fieldorder\"/>"+
	   "</head>"+
	   "<operates width=\"5%\">"+
       "   <popedom column='id' otherpara='column:scopeid+column:fieldname+"+user.getUID()+"+"+user.getLoginid()+"+"+user.getLogintype()+"+"+user.getLanguage()+"' transmethod='weaver.proj.util.ProjectTransUtil.getPrjtypeFieldOperates'  ></popedom>"+
    	"    <operate href=\"javascript:openDialog()\" otherpara='column:scopeid' text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
    	"    <operate href=\"javascript:doDel()\" otherpara='column:scopeid' text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
    	"</operates>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_CUSFIELDLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

<script type="text/javascript">
$(function(){
	$("#topTitle").topMenuTitle({});
});
</script>
</BODY>
</HTML>
