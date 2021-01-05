
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<HTML><HEAD>
<% 
	String scope = Util.null2String(request.getParameter("scope"));
	if(scope.equals(""))scope = "DocCustomFieldBySecCategory";
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
	jQuery.ajax({
		url:"docajax_operation.jsp",
		type:"post",
		data:{
			src:"docCusFieldDelete",
			id:id
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

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=56&isdialog=1&scope=<%=scope%>";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,17037",user.getLanguage())%>";
		dialog.Height = 400;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=57&isdialog=1&scope=<%=scope%>&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17037",user.getLanguage())%>";
		dialog.Height = 400;
	}
	dialog.maxiumnable = true;
	dialog.Width = 600;
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
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(684,user.getLanguage())%>");
</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
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
if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(271),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%}%>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"  onchange="setKeyword('flowTitle','fieldname','searchfrm');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form action="" name="searchfrm" id="searchfrm">
		<input type="hidden" name="scope" id="scope" value="<%=scope %>">
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
						<select size=1 name="type">
							<option value="" ></option>
							<option value="1" <%=type.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
							<option value="2" <%=type.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
							<option value="3" <%=type.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						</select>
					<%}else{ %>
						<select size=1 id="type" name="type" >
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
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
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
	String sqlWhere = "(scope='"+scope+"' or id in(select fieldid from cus_formfield where scope = '"+scope+"'))";
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
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getDocCusFieldOperate\" otherpara=\""+HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user)+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
	 String tabletype="none";
	 if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)){
	 	tabletype = "checkbox";
	 }
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_CUSFIELDLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_CUSFIELDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDocCusFieldCheckbox\" popedompara = \"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"cus_formdict\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\"  column=\"id\"  orderkey=\"id\"/>"+
			 "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.getCusFieldName\" text=\""+SystemEnv.getHtmlLabelName(23241,user.getLanguage())+"\" otherpara=\"column:id\" column=\"fieldname\"  orderkey=\"fieldname\"/>"+
			 "<col width=\"30%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getCusFieldLabel\" text=\""+SystemEnv.getHtmlLabelName(30828,user.getLanguage())+"\" column=\"fieldlabel\" otherpara=\"column:id\" orderkey=\"fieldlabel\"/>"+
			 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getCusFieldType\" text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" otherpara=\"column:type+"+user.getLanguage()+"\" orderkey=\"fieldhtmltype\"/>"+
			 "<col width=\"10%\" pkey=\"fielddbtype+weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"fielddbtype\"/>"+
	   "</head>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_CUSFIELDLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</BODY>
</HTML>
