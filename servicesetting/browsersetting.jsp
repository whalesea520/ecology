
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ServiceFile:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String type = Util.null2String(request.getParameter("type"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23661,user.getLanguage());
String needfav ="1";
String needhelp ="";


String parabrowserid = Util.null2String(request.getParameter("browserid"));

String moduleid = BrowserXML.getModuleId();
ArrayList pointArrayList = BrowserXML.getPointArrayList();
Hashtable dataHST = BrowserXML.getDataHST();
String browserOPTIONS = "";
String thisServiceId = "";
String thisSearch = "";
String thisSearchById = "";
String thisSearchByName = "";
String thisNameHeader = "";
String thisDescriptionHeader = "";
String outPageURL = "";
String href = "";
String from = "";

ArrayList dsPointArrayList = DataSourceXML.getPointArrayList();
String dsOptions = "";
for(int i=0;i<dsPointArrayList.size();i++){
    String pointid = (String)dsPointArrayList.get(i);
    dsOptions += "<option title='"+pointid+"' value='"+pointid+"'>"+pointid+"</option>";
}

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"2".equals(type))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",browsersettingnew.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
else
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/integration/WsShowEditSet.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(!"2".equals(type))
		{
		%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
		<%
		}
		else
		{
		%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="back()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		<%} %>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="browsersetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="bsnums" name="bsnums" value="<%=pointArrayList.size()%>">
	<TABLE class="ListStyle" cellspacing=1>
		<COLGROUP> 
			<COL width="2%"> 
			<COL width="8%">
			<COL width="6%"> 
			<COL width="10%">
			<COL width="10%"> 
			<COL width="10%">
			<COL width="8%">
			<COL width="8%">
			<COL width="8%">
			<COL width="8%">
			<COL width="4%">
			<COL width="6%">
			<COL width="6%">
			<COL width="4%">
		<TBODY>
		 <%if(!"2".equals(type)){ %>	
		<TR class=Title>
		  <TH colSpan=10><%=titlename%></TH>
		</TR>
		<TR class=Spacing style="height:1px;">
		  <TD class=Line colSpan=10></TD>
		</TR>
		<%} %>
		<TR class=header>
		  <td>&nbsp;</td>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></nobr></td><!-- 浏览框标识 -->
		  <td><nobr><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></nobr></td>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(23676,user.getLanguage())%></nobr></td>
		   <%if(!"2".equals(type)){ %>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(23677,user.getLanguage())%></nobr></td>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(23678,user.getLanguage())%></nobr></td>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(23679,user.getLanguage())%></nobr></td>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(23680,user.getLanguage())%></nobr></td>
		  <%} %>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(28144,user.getLanguage())%></nobr></td>
		  
		  <td><nobr><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></nobr></td>
		  <td><nobr><%=SystemEnv.getHtmlLabelName(32350,user.getLanguage())%></nobr></td><!-- 树状显示 -->
		  <td><nobr><%=SystemEnv.getHtmlLabelName(32351,user.getLanguage())%></nobr></td><!-- 显示标题 -->
		  <td><nobr><%=SystemEnv.getHtmlLabelName(32352,user.getLanguage())%></nobr></td><!-- 上级字段名 -->
		  <td><nobr><%=SystemEnv.getHtmlLabelName(28627,user.getLanguage())%></nobr></td><!-- 多选 -->
		</TR>
		
		<%
		int colorindex = 0;
		int rowindex = 0;
		for(int i=0;i<pointArrayList.size();i++){
		    String pointid = (String)pointArrayList.get(i);
		    if(pointid.equals("")) continue;
		    checkString += "browserid_"+rowindex+",";
		    String showtree = "";
		    String nodename = "";
		    String parentid = "";
		    String ismutil = "";
		    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
		    if(thisDetailHST!=null){
		        thisServiceId = (String)thisDetailHST.get("ds");
		        thisSearch = (String)thisDetailHST.get("search");
		        thisSearchById = (String)thisDetailHST.get("searchById");
		        thisSearchByName = (String)thisDetailHST.get("searchByName");
		        thisNameHeader = (String)thisDetailHST.get("nameHeader");
		        thisDescriptionHeader = (String)thisDetailHST.get("descriptionHeader");
		        outPageURL = Util.null2String((String)thisDetailHST.get("outPageURL"));
		        href = Util.null2String((String)thisDetailHST.get("href"));
		        from = Util.null2String((String)thisDetailHST.get("from"));
		        showtree = Util.null2String((String)thisDetailHST.get("showtree"));
		        nodename = Util.null2String((String)thisDetailHST.get("nodename"));
		        parentid = Util.null2String((String)thisDetailHST.get("parentid"));
		        ismutil = Util.null2String((String)thisDetailHST.get("ismutil"));
		    }
		    if("2".equals(type))
		    {
		    	if(!"2".equals(from))
			    {
			    	continue;
			    }
		    }
		    else
		    {
		    	if("2".equals(from))
			    {
			    	continue;
			    }
		    }
		    String tiptile = "";
		    if("1".equals(from))
		    {
		    	tiptile = SystemEnv.getHtmlLabelName(32353,user.getLanguage());//"来源于表单模块";
		    }
		    else if("2".equals(from))
		    {
		    	tiptile = SystemEnv.getHtmlLabelName(32354,user.getLanguage());//"来源于数据展示集成";
		    }
		    String newthisServiceId = thisServiceId.replaceAll("datasource.","");
		    String thisDsOptions = Util.replace(dsOptions,"<option title='"+newthisServiceId+"' value='"+newthisServiceId+"'>"+newthisServiceId+"</option>","<option value='"+newthisServiceId+"' selected>"+newthisServiceId+"</option>",0);
		    if(colorindex==0){
		    %>
		    <tr class="DataDark">
		    <%
		        colorindex=1;
		    }else{
		    %>
		    <tr class="DataLight">
		    <%
		        colorindex=0;
		    }%>
		    <td valign="top"><%if(!"2".equals(from)){ %><input type="checkbox" id="del_<%=rowindex%>" name="del_<%=rowindex%>" value="0" onchange="if(this.checked){this.value=1;}else{this.value=0;}"><%}else{ %><SPAN style="CURSOR: hand" id=remind title="<%=tiptile %>"><IMG id=ext-gen124  title="<%=tiptile %>" align=absMiddle src="/images/remind_wev8.png"></SPAN><%} %></td>
		    <td valign="top">
		    	<input class="inputstyle" type=text size=8 title="<%=tiptile %>" id="browserid_<%=rowindex%>" name="browserid_<%=rowindex%>" value="<%=pointid%>" onChange="checkinput('browserid_<%=rowindex%>','browseridspan_<%=rowindex%>')" onblur="checkBSName(this.value,<%=rowindex%>)">
		    	<span id="browseridspan_<%=rowindex%>"></span>
		    	<input class="inputstyle" type=hidden id="oldbrowserid_<%=rowindex%>" name="oldbrowserid_<%=rowindex%>" value="<%=pointid%>">
		    </td>
		    <td valign="top">
		    	<select id="ds_<%=rowindex%>" name="ds_<%=rowindex%>" style="width:80px;">
		    		<option></option>
					<%=thisDsOptions%>
				</select>
			</td>
				<!--
				<td><input class="inputstyle" type=text id="search_<%=rowindex%>" name="search_<%=rowindex%>" size="22" value="<%=thisSearch%>">
				<td><input class="inputstyle" type=text id="searchById_<%=rowindex%>" name="searchById_<%=rowindex%>" size="22" value="<%=thisSearchById%>"></td>
				<td><input class="inputstyle" type=text id="searchByName_<%=rowindex%>" name="searchByName_<%=rowindex%>" size="22" value="<%=thisSearchByName%>"></td></td>
				-->
				<td><textarea style="overflow-y: auto;" id="search_<%=rowindex%>" name="search_<%=rowindex%>" rows=5 cols=22><%=thisSearch%></textarea></td>
				<td <%if("2".equals(type)){ %>style='display:none;'<%} %>><textarea style="overflow-y: auto;" id="searchById_<%=rowindex%>" name="searchById_<%=rowindex%>" rows=8 cols=11><%=thisSearchById%></textarea></td>
				<td <%if("2".equals(type)){ %>style='display:none;'<%} %>><textarea style="overflow-y: auto;" id="searchByName_<%=rowindex%>" name="searchByName_<%=rowindex%>" rows=8 cols=11><%=thisSearchByName%></textarea></td>
				<td <%if("2".equals(type)){ %>style='display:none;'<%} %> valign="top"><input class="inputstyle" type=text id="nameHeader_<%=rowindex%>" name="nameHeader_<%=rowindex%>" size="5" value="<%=thisNameHeader%>"></td>
				<td <%if("2".equals(type)){ %>style='display:none;'<%} %> valign="top"><input class="inputstyle" type=text id="descriptionHeader_<%=rowindex%>" name="descriptionHeader_<%=rowindex%>" size="5" value="<%=thisDescriptionHeader%>"></td>
				<td valign="top"><input class="inputstyle" type=text id="outPageURL_<%=rowindex%>" name="outPageURL_<%=rowindex%>" size="8" value="<%=outPageURL%>"></td>
				<td valign="top">
					<input class="inputstyle" type=text id="href_<%=rowindex%>" size="8" name="href_<%=rowindex%>" value="<%=href%>">
					<input class="inputstyle" type=hidden id="from_<%=rowindex%>" size="0" name="from_<%=rowindex%>" value="<%=from%>">
				</td>
				<td valign="top">
					<input type="checkbox" id="showtree_<%=rowindex%>" name="showtree_<%=rowindex%>" value="1" <%if("1".equals(showtree)){out.println("checked");} %> onchange="if(this.checked){this.value=1;}else{this.value=0;}">
				</td>
				<td valign="top">
					<input class="inputstyle" type=text id="nodename_<%=rowindex%>" size="6" name="nodename_<%=rowindex%>" value="<%=nodename%>" maxLength="50">
				</td>
				<td valign="top">
					<input class="inputstyle" type=text id="parentid_<%=rowindex%>" size="6" name="parentid_<%=rowindex%>" value="<%=parentid%>" maxLength="50">
				</td>
				<td valign="top">
					<input type="checkbox" id="ismutil_<%=rowindex%>" name="ismutil_<%=rowindex%>" value="1" <%if("1".equals(ismutil)){out.println("checked");} %> onchange="if(this.checked){this.value=1;}else{this.value=0;}">
				</td>
		</tr>
		<%
		    rowindex++;
		}
		%>
		</TBODY>
    </TABLE>
    <br>
    <wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
			1.<%=SystemEnv.getHtmlLabelName(23953,user.getLanguage())%>；
			<BR>
			2.<%=SystemEnv.getHtmlLabelName(23954,user.getLanguage())%>；
			<BR>
			3.<%=SystemEnv.getHtmlLabelName(23955,user.getLanguage())%>；
			<BR>
			4.<%=SystemEnv.getHtmlLabelName(23956,user.getLanguage())%>；
			<BR>
			5.<%=SystemEnv.getHtmlLabelName(23957,user.getLanguage())%>；
			<BR>
			6.<%=SystemEnv.getHtmlLabelName(23958,user.getLanguage())%>；
			<BR>
			7.<%=SystemEnv.getHtmlLabelName(23959,user.getLanguage())%>。
		  </wea:item>
		</wea:group>
	</wea:layout>
	
  </FORM>
</BODY>

<script language="javascript">
function add()
{
	document.location = "/servicesetting/browsersettingnew.jsp";
}
function back()
{
	document.location = "/integration/WsShowEditSet.jsp";
}
function onSubmit(){
    if(check_form(frmMain,"<%=checkString%>")){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="browser";
        frmMain.method.value="edit";
        frmMain.submit();
    }
}
function onDelete(){
    if(isdel()){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="browser";
        frmMain.method.value="delete";
        frmMain.submit();
    }
}
function checkBSName(thisvalue,rowindex){
    bsnums = document.getElementById("bsnums").value;
    if(thisvalue!=""){
        for(var i=0;i<bsnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("browserid_"+i).value;
                if(thisvalue==otherdsname){
                    alert("<%=SystemEnv.getHtmlLabelName(23992,user.getLanguage())%>");//该自定义浏览框已存在！
                    document.getElementById("browserid_"+rowindex).value = "";
                }
            }
        }
    }
}
</script>

</HTML>
