<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.fna.general.FnaCommon" %>
<%@page import="org.json.JSONObject"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if (!HrmUserVarify.checkUserRight("intergration:expsetting", user)) {
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />


<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	
	table.setbutton td
	{
		padding-top:10px; 
	}
	table ul#tabs
	{
		width:85%!important;
	}
</STYLE>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = "";
//String typename = Util.null2String(request.getParameter("typename"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));


String TimeModul = "0";
String createTime = "";
String Frequency = "";
String createType = "";
String frequencyy = "";
String xmltext="";
xmltext+=
"<Results>\r\n"+
"<Sn>${RequestId}</Sn>\r\n"+
"<Version>1</Version>\r\n"+
"<Time>${CurrentDatetime}</Time>\r\n"+
"<WorkflowId>${WorkflowId}</WorkflowId>\r\n"+
"<WorkflowType>${WorkflowTypename}</WorkflowType>\r\n"+
"<Title>${RequestName}</Title>\r\n"+
"<RequestCreator>${RequestCreator}</RequestCreator>\r\n"+
"<RequestCreateDate>${RequestCreateDate}</RequestCreateDate>\r\n"+
"<RequestOverDate>${RequestOverDate}</RequestOverDate>\r\n"+
"<Fields>\r\n"+
"<#list FieldList as Field>\r\n"+
"<Field>\r\n"+
"<FieldLabel>${Field.FieldLabel}</FieldLabel>\r\n"+
"<FieldName>${Field.FieldName}</FieldName>\r\n"+
"<#if Field.FieldType!=\"file\">\r\n"+
"<FieldValue>${Field.FieldValue}</FieldValue>\r\n"+
"<#else>\r\n"+
"<FieldValue>\r\n"+
"<#list Field.FileList as File>\r\n"+
"<File>\r\n"+
"<FileName>${File.FileName}</FileName>\r\n"+
"<FileContent>${File.FileContent}</FileContent>\r\n"+
"</File>\r\n"+
"</#list>\r\n"+
"</FieldValue>\r\n"+
"</#if>\r\n"+
"</Field>\r\n"+
"</#list>\r\n"+
"</Fields>\r\n"+
"<#if OpinionType==\"opinion\">\r\n"+
"<Opinions>\r\n"+
"<#list OpinionList as Opinion>\r\n"+
"<Opinion>\r\n"+
"<NodeName>${Opinion.NodeName}</NodeName>\r\n"+
"<Operator>${Opinion.Operator}</Operator>\r\n"+
"<OperateTime>${Opinion.OperateTime}</OperateTime>\r\n"+
"<OpinionContent>${Opinion.OpinionContent}</OpinionContent>\r\n"+
"<#if Opinion.OpFieldType==\"file\">\r\n"+
"<OpinionList>\r\n"+
"<#list Opinion.OpFileList as File>\r\n"+
"<File>\r\n"+
"<FileName>${File.FileName}</FileName>\r\n"+
"<FileContent>${File.FileContent}</FileContent>\r\n"+
"</File>\r\n"+
"</#list>\r\n"+
"</OpinionList>\r\n"+
"</#if>\r\n"+
"</Opinion>\r\n"+
"</#list>\r\n"+
"</Opinions>\r\n"+
"</#if>\r\n"+
"<Status>0</Status>\r\n"+
"</Results>";

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<script language=javascript>
<%
if(msgid!=-1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!');
<%}%>
</script>
<FORM id=weaver name=frmMain action="/integration/exp/ExpXMLProOperation.jsp" method=post >

<input class=inputstyle type=hidden name="backto" value="">
<input class=inputstyle type="hidden" name=operation value="add">
 <wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82743,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">

		<wea:item><%=SystemEnv.getHtmlLabelName(33162,user.getLanguage())%></wea:item><!-- 方案名称 -->
		<wea:item>
            <wea:required id="nameimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="name"  value="" onchange='checkinput("name","nameimage")'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125758,user.getLanguage())%></wea:item><!-- 文件保存方式 -->
		<wea:item>
           <select id="FileSaveType" style='width:120px!important;' name="FileSaveType" onchange="changeFileSaveType(this);">
			  <option value="0">FTP</option>
			  <option value="1" ><%=SystemEnv.getHtmlLabelName(125714,user.getLanguage())%></option><!-- 本地 -->
			</select>
		</wea:item>
	   <wea:item><%=SystemEnv.getHtmlLabelNames("31691,63",user.getLanguage())%></wea:item><!-- 注册类型 -->
		<wea:item>
			<wea:required id="regitTypeimage" required="true" value="">
	           <select id="regitType" style='width:120px!important;' name="regitType" onchange='checkinput("regitType","regitTypeimage")' >
				  <option value=""></option>
				</select>
			</wea:required>
		</wea:item>
		
		
		   <wea:item><%=SystemEnv.getHtmlLabelName(32220,user.getLanguage())%></wea:item><!-- 同步方式 -->
		  <wea:item>
						<select id="synType" name="synType" style='width:180px!important;' onchange='changeSynType(this.value);'>
							<option value="0" ><%=SystemEnv.getHtmlLabelName(30107,user.getLanguage())%></option><!-- 手动同步 -->
							<option value="1" ><%=SystemEnv.getHtmlLabelName(32221,user.getLanguage())%></option><!-- 自动同步 -->
						</select>
		   </wea:item>
		  <wea:item attributes="{'samePair':'timeModulView','display':'none'}"><%=SystemEnv.getHtmlLabelName(32223,user.getLanguage())%></wea:item><!-- 同步频率 -->
		   <wea:item attributes="{'samePair':'timeModulView','display':'none'}">
				  	<SPAN class=itemspan>
					  	<SELECT style='width:80px!important;float:left;' id="TimeModul" name="TimeModul" onchange="showFre(this.value)">
							<OPTION value="0" <%if("0".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
							<OPTION value="1" <%if("1".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
							<OPTION value="2" <%if("2".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
							<OPTION value="3" <%if("3".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
						</SELECT>
					</SPAN>
					<%
						/*String TimeModul = "";
						String Frequency = "";
						String frequencyy = "";
						String createType = "";
						String createTime = "";*/
			
						String a="vis4";
				  		String b="vis4";
				  		String c="vis4";
				  		String d="vis4";
				  		if (Util.null2String(TimeModul).equals("0"))
						{
						    a="vis3";
						}
						else if (Util.null2String(TimeModul).equals("1"))
						{
						    b="vis3";
						}
						else if (Util.null2String(TimeModul).equals("2"))
						{
						    c="vis3";
						}
						else if (Util.null2String(TimeModul).equals("3"))
						{
						    d="vis3";
						}
					%>
					<SPAN class=itemspan>
					&nbsp;&nbsp;&nbsp;
					</SPAN>
					<!--================== 天 ==================-->
					<SPAN id="show_0" class="<%=a%> itemspan" >
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%>&nbsp;
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="dayTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "0".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</SPAN>
					  	<SPAN class=itemspan>
					  		<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
					  	</SPAN>
					</SPAN>
						
					<!--================== 周 ==================-->
					<SPAN id="show_1" class="<%=b%> itemspan">
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="fer_0">
				 				<OPTION value="1" <%if (Frequency.equals("1") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
				 				<OPTION value="2" <%if (Frequency.equals("2") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
				 				<OPTION value="3" <%if (Frequency.equals("3") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
				 				<OPTION value="4" <%if (Frequency.equals("4") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
				 				<OPTION value="5" <%if (Frequency.equals("5") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
				 				<OPTION value="6" <%if (Frequency.equals("6") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
				 				<OPTION value="7" <%if (Frequency.equals("7") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="weekTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "1".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</span>
					  	<SPAN class=itemspan>
					  		<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
					  	</SPAN>
					</SPAN>
					
					<!--================== 月 ==================-->
					<SPAN id="show_2" class="<%=c%> itemspan">
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="monthType">
								<OPTION value="0" <%if (createType.equals("0") && "2".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if (createType.equals("1") && "2".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="fer_1">
							<%
								for (int i = 1; i <= 28; i++) 
								{
							%>
								<OPTION value="<%=i%>" <%if (Util.null2String(Frequency).equals(""+i) && "2".equals(TimeModul)) {%>selected<%}%>><%=i%></OPTION>
							<%
								}
							%>
							</SELECT>
						</span>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>&nbsp;
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="monthTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "2".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</SPAN>
					  	<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
						</SPAN>
					</SPAN>
					
					<!--================== 年 ==================-->
					<SPAN id="show_3" class="<%=d%> itemspan">
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="fer_2">
						 	<%
						 		for (int i = 1; i <= 12; i++) 
						 		{
						 	%>
								<OPTION value="<%= Util.add0(i, 2) %>" <%if (Util.null2String(Frequency).equals(""+i) && "3".equals(TimeModul)) {%>selected<%}%>><%= Util.add0(i, 2) %></OPTION>
							<%
								}
							%>
							</SELECT>
						</span>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="yearType">														
								<OPTION value="0" <%if (createType.equals("0") && "3".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if (createType.equals("1") && "3".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>
						</span>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
						</span>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="frey">
							<%
								for (int i = 1; i <= 28; i++) 
								{
							%>
								<OPTION value="<%=i%>" <%if(frequencyy.equals(""+i) && "3".equals(TimeModul)) {%>selected<%}%>><%=i%></OPTION>
							<%
								}
							%>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>&nbsp;
						</span>
						<SPAN class=itemspan>
							<%//=Util.null2String(wp.getFrequencyy())%>
							<SELECT style='width:80px!important;' name="yearTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "3".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</SPAN>
					  	<SPAN class=itemspan>
					  		&nbsp;<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
					  	</SPAN>
					</SPAN>
			</wea:item>
	</wea:group>
	<!--  XML设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(125781, user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(125781, user.getLanguage())%></wea:item><!--  XML设置-->
		<wea:item>
           <select id="XMLType" style='width:120px!important;' name="XMLType" onchange="changeXMLType();">
			  <option value="0"><%=SystemEnv.getHtmlLabelName(125775, user.getLanguage())%></option><!--  中信格式-->
			  <option value="1" selected><%=SystemEnv.getHtmlLabelName(125782, user.getLanguage())%></option><!--  自由格式-->
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125783, user.getLanguage())%></wea:item><!--  XML文件编码-->
		<wea:item>
           <select id="XMLEcoding" style='width:120px!important;' name="XMLEcoding" onchange="">
			  <option value="0">UTF-8</option>
			  <option value="1" >GB2312</option>
			    <option value="2">GBK</option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125784, user.getLanguage())%></wea:item><!--  XML文件信息格式-->
		<wea:item>
           <select id="XMLFileType" style='width:120px!important;' name="XMLFileType" onchange="XMLchange(this);">
			  <option value="0"><%=SystemEnv.getHtmlLabelName(125785, user.getLanguage())%></option><!--  FTP路径 -->
			  <option value="1" ><%=SystemEnv.getHtmlLabelName(125786, user.getLanguage())%></option><!--  BASE64编码 -->
			</select>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(125787, user.getLanguage())%></wea:item><!-- XML包含流转意见 -->
	    <wea:item>
			<input class="inputstyle" type="checkbox" tzCheckbox='true' id="XMLHaveRemark" name="XMLHaveRemark" value="1" checked>
	    </wea:item>
	    
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(125773, user.getLanguage())%></wea:item><!-- XML模板设置 -->
	   	<wea:item attributes="{'samePair':'webserviceout'}"><!-- XML模板 -->
							<textarea class="InputStyle" temptitle="<%=SystemEnv.getHtmlLabelName(125781, user.getLanguage())%>" id="xmltext" name="xmltext" rows="7" style="width:90%"  onChange="checkinput('xmltext','xmltextspan')"><%=xmltext%></textarea>
							<span id="xmltextspan">
								<%
									if (xmltext.equals("")){
								%>
								<img src="/images/BacoError_wev8.gif" align=absmiddle>
								<%
									}
								%>
							</span>
							
						</wea:item>
		</wea:group>
	  <!-- end -->
	  
	  <!--  流程文档导出设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(125722, user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(125723, user.getLanguage())%></wea:item><!--  导出流程表单文档-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true'  id="ExpWorkflowFileFlag" name="ExpWorkflowFileFlag" value="1"  onclick="showdetailToClear(this,'','ExpWorkflowFileForZipFlag');showdetail1();showdetail(this,'ExpWorkflowFileForZipFlagView');" >
		</wea:item>
		<!--  导出流程表单文档为ZIP-->
		<wea:item attributes="{'samePair':'ExpWorkflowFileForZipFlagView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125724, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowFileForZipFlagView','display':'none'}">
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowFileForZipFlag" name="ExpWorkflowFileForZipFlag" value="1" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125725, user.getLanguage())%></wea:item><!--  导出流转意见-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowRemarkFileFlag" name="ExpWorkflowRemarkFileFlag" value="1"  onclick="showdetailToClear(this,'','ExpWorkflowRemarkFileForZip');showdetail1();showdetail(this,'ExpWorkflowRemarkFileForZipView');">
		</wea:item>
		<!--  导出流转意见文档为ZIP-->
		<wea:item attributes="{'samePair':'ExpWorkflowRemarkFileForZipView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125726, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowRemarkFileForZipView','display':'none'}">
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowRemarkFileForZip" name="ExpWorkflowRemarkFileForZip" value="1" >
		</wea:item>
		<!--  导出流程文档路径-->
		<wea:item attributes="{'samePair':'ExpWorkflowFilePathView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125727, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowFilePathView','display':'none'}">
            <wea:required id="ExpWorkflowFilePathimage" required="true" value="">
            	<input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="ExpWorkflowFilePath" id="ExpWorkflowFilePath"  value="" onchange='checkinput("ExpWorkflowFilePath","ExpWorkflowFilePathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		
		</wea:group>
	  <!-- end -->
	  
	   <!--  流程表单导出设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(125728, user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(125729, user.getLanguage())%></wea:item><!--  导出流程表单-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowInfoFlag" name="ExpWorkflowInfoFlag" value="1" onclick="showdetailToClear(this,'','');showdetail(this,'ExpWorkflowInfoPathView');">
		</wea:item>
		<!--  导出流程表单路径-->
		<wea:item attributes="{'samePair':'ExpWorkflowInfoPathView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125730, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowInfoPathView','display':'none'}">
            <wea:required id="ExpWorkflowInfoPathimage" required="true" value="">
            	<input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" id="ExpWorkflowInfoPath" name="ExpWorkflowInfoPath"  value="" onchange='checkinput("ExpWorkflowInfoPath","ExpWorkflowInfoPathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126171, user.getLanguage())%></wea:item><!--  导出流转意见-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowRemarkFlag" name="ExpWorkflowRemarkFlag" value="1" onclick="showdetailToClear(this,'','ExpSignFileFlag');showdetail(this,'ExpSignFilePathView');showdetail(this,'ExpSignFileFlagView');showdetail2($('#ExpSignFileFlag'),'ExpSignFilePathView');" >
		</wea:item>
		<!--  导出签章图片-->
		<wea:item attributes="{'samePair':'ExpSignFileFlagView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125731, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpSignFileFlagView','display':'none'}">
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpSignFileFlag" name="ExpSignFileFlag" value="1" onclick="showdetailToClear(this,'','');showdetail3(this,'ExpSignFilePathView');">
		</wea:item>
		<!--  导出签章图片路径-->
		<wea:item attributes="{'samePair':'ExpSignFilePathView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125732, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpSignFilePathView','display':'none'}">
            <wea:required id="ExpSignFilePathimage" required="true" value="">
            	<input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" id="ExpSignFilePath" name="ExpSignFilePath"  value="" onchange='checkinput("ExpSignFilePath","ExpSignFilePathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		
		<wea:item></wea:item>
		<wea:item>  
		</wea:item>
		
		</wea:group>
	  <!-- end -->
	
</wea:layout>
<br>
 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>

<script language=javascript>
jQuery(document).ready(function(){
	changeFileSaveType($("#FileSaveType"));
	changeEncryptType('');
	reshowCheckBox();
	
	XMLchange();
	changeXMLType();
	checkinput("regitType","regitTypeimage");
});

function XMLchange(obj){
	if(obj == null){
		obj = jQuery("#XMLFileType");
	}
	
	if(jQuery(obj).val() == '1'){
		hideEle("ExpWorkflowFilePathView");
		//hideEle("ExpWorkflowInfoPathView");
		hideEle("ExpSignFilePathView");
		
		//jQuery("#ExpWorkflowFilePath").val("");
		//jQuery("#ExpWorkflowInfoPath").val("");
		//jQuery("#ExpSignFilePath").val("");
	}else if(jQuery(obj).val() == '0'){
		var checked = $("#ExpWorkflowFileFlag").attr("checked");
		var checked1 = $("#ExpWorkflowRemarkFileFlag").attr("checked");
		if(checked || checked1){
			showEle("ExpWorkflowFilePathView");
		}
		
		/* checked = $("#ExpWorkflowInfoFlag").attr("checked");
		if(checked){
			showEle("ExpWorkflowInfoPathView");
		} */
		
		checked = $("#ExpWorkflowRemarkFlag").attr("checked");
		checked1 = $("#ExpSignFileFlag").attr("checked");
		if(checked && checked1){
			showEle("ExpSignFilePathView");
		}
	}
}

function showdetailToClear(obj, inputObj, checkboxObj){
	var checked = jQuery(obj).attr("checked");
	if(!checked){
		if(inputObj != ''){
			jQuery("#"+inputObj).val("");
		}
		if(checkboxObj != ''){
			jQuery("#"+checkboxObj).val("0");
			jQuery("#"+checkboxObj).trigger("checked",false);
		}
	}
}

function showdetail3(obj,val) {
	var XMLFileType = jQuery("#XMLFileType").val();
	if(XMLFileType == '1'){
		return false;
	}
	  var checked = $(obj).attr("checked");
		if(checked){
			showEle(val);
		} else {
			hideEle(val);
		}
}
function submitData() {
	var checkvalue = "";
	
	var diplayExpWorkflowFilePath = jQuery("td[_samepair='ExpWorkflowFilePathView']").parent().css("display");
	var diplayExpWorkflowInfoPath = jQuery("td[_samepair='ExpWorkflowInfoPathView']").parent().css("display");
	var diplayExpSignFilePath = jQuery("td[_samepair='ExpSignFilePathView']").parent().css("display");
	
	if(diplayExpWorkflowFilePath != 'none'){
		checkvalue += "ExpWorkflowFilePath,";
	}
	if(diplayExpWorkflowInfoPath != 'none'){
		checkvalue += "ExpWorkflowInfoPath,";
	}
	if(diplayExpSignFilePath != 'none'){
		checkvalue += "ExpSignFilePath,";
	}
	
	checkvalue+="name,xmltext,regitType";
 
    if(check_form(frmMain,checkvalue)){
    	if(diplayExpWorkflowFilePath == 'none'){
    		jQuery("#ExpWorkflowFilePath").val("");
    	}
    	if(diplayExpWorkflowInfoPath == 'none'){
    		jQuery("#ExpWorkflowInfoPath").val("");
    	}
    	if(diplayExpSignFilePath == 'none'){
    		jQuery("#ExpSignFilePath").val("");
    	}
        frmMain.submit();
    }
	
}
function doBack()
{
	//document.location.href="/interface/outter/OutterSys.jsp?typename=""";
}
function changeEncryptType(val)
{
	if(val=="1")
	{
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").show();
		$(".isencrypt").show();
		$(".maybelast").attr("colspan","1");
		
	}
	else if(val=="2")
	{
		showEle("encrypt1");
		showEle("encrypt2");
		$(".encryptcode").hide();
		$(".isencrypt").show();
		$(".maybelast").attr("colspan","2");
	}
	else
	{
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").hide();
		$(".isencrypt").hide();
		$(".maybelast").attr("colspan","3");
	}
}
	
function onTypeChange(obj){
	if(obj.value==0){
		obj.nextSibling.nextSibling.style.display='inline-block';
	}
    else{
		obj.nextSibling.nextSibling.style.display='none';
	}
}
function onInitTypeChange(){
	var paramtypes = jQuery("select[name='paramtypes']");
    jQuery.each(paramtypes, function(i, n){
      var obj = n;
      //alert( "Item #" + i + ": " + n +" obj.value : "+obj.outerHTML);
      onTypeChange(obj);
   });
}

function onChangeTypeFun(obj){
	if(obj == "1") {
		document.all("baseparam1").readOnly = true;
		document.all("baseparam2").readOnly = true;
		document.getElementById("baseparam1image").style.display = "none";
		document.getElementById("baseparam2image").style.display = "none";
  		showEle("acc_id1");
  		document.getElementById("ncpkcode_id1").style.display = "";
	} else {
	    document.all("baseparam1").readOnly = false;
		document.all("baseparam2").readOnly = false;
		document.getElementById("baseparam1image").style.display = "none";
		document.getElementById("baseparam2image").style.display = "none";
		hideEle("acc_id1");
  		document.getElementById("ncpkcode_id1").style.display = "none";
	}
}
function changeParamValue(obj)
{
	if(obj.checked)
		obj.nextSibling.nextSibling.value='1';
	else
		obj.nextSibling.nextSibling.value='0';
	//alert(obj.nextSibling.outerHTML);
}
var items=[
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(20968,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='paramnames'  value='' >"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='labelnames'  value='' >"},
    {width:"23%",tdclass:"maybelast",colname:"<%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%>",itemhtml:"<select name=paramtypes onchange='onTypeChange(this)' style='width:80px;'><option value=0><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><option value=3><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option><select><INPUT class='Inputstyle' style='display:inline-block;width:80px!important;' type='text' name='paramvalues'  value=''>"},
    {width:"10%",tdclass:"isencrypt",colname:"<%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='radio' tzCheckbox='true' name='tempparaencrypts' value=1 onclick='changeParamValue(this)'><INPUT type='hidden' name='paraencrypts' value='1'>"},
    {width:"20%",tdclass:"encryptcode",colname:"<%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='password' name='encryptcodes' value=''>"}];

var option= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:false,
   optionHeadDisplay:"none",
   colItems:items,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   addAccesskey:"A",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   delAccesskey:"D",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
      changeEncryptType(jQuery("#encrypttype").val());
      //alert(jQuery("#typename").val());
      onChangeTypeFun(jQuery("#typename").val());
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>",width:"7%"},
   initdatas:eval('')
};
var group=null;
jQuery(document).ready(function(){
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#outtersetting").append(group.getContainer());
    var params=group.getTableSeriaData();
    
    var paramnctr = "<TR id='ncpkcode_id1' >"+
		            "<TD><INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'></TD>"+
		            "<TD><INPUT class='Inputstyle' type='text' name='paramnames_nc'  value='pkcorp'></TD>"+
					"<TD><INPUT class='Inputstyle' type='text' name='labelnames_nc'  value='<%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>'></TD>"+
		            "<TD class='maybelast'>"+
		            "     <%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>"+
		            "     <INPUT class='Inputstyle' type='hidden' name='paramtypes_nc'  value='1'>"+
		            "     <INPUT class='Inputstyle' type='text' name='paramnames_nc'  value='pkcorp'></TD>"+
		            "<TD class='isencrypt'><INPUT class='Inputstyle' type='checkbox' tzCheckbox='true' name='paraencrypt_nc'  value='1'></TD>"+
		            "<TD class='encryptcode'><INPUT class='Inputstyle' type='text' name='encryptcode_nc'  value='pkcorp'></TD>"+
		            "</TR>";
	group.addCustomRow(paramnctr);
    reshowCheckBox();
    changeEncryptType('');
    //onChangeTypeFun('');
    onInitTypeChange();
    jQuery(".optionhead").hide();
    jQuery(".tablecontainer").css("padding-left","0px");
});
function addRow()
{
	if(null!=group)
	{
		group.addRow(null);
	}
}
function removeRow()
{
	var count = 0;//删除数据选中个数
	jQuery("#outtersetting input[name='paramid']").each(function(){
		if($(this).is(':checked')){
			count++;
		}
	});
	//alert(v+":"+count);
	if(count==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
	}else{
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        if(null!=group)
		{
			group.deleteRows();
		}
    }, function () {}, 320, 90);
	}
}
function onBack()
{
	parentWin.closeDialog();
}

function onChangeRequestType(obj){

//var radiovar=document.getElementsByName("urlencodeflag");
//alert(radiovar.length);
	if(obj == "1") {  //get
	
	 jQuery("#urlencodeflag1").trigger("checked",true);
	  jQuery("#encodespan").show();
	 
	
    } else { 
	 jQuery("#urlencodeflag0").trigger("checked",true);
	  jQuery("#encodespan").hide();
	 
	}
	//alert($("#urlencodeflag").val());
}

  function isimag(obj){   
	
	  var file = obj.value.match(/[^\/\\]+$/gi)[0]; 
	  var rx = new RegExp('\\.(gif)$','gi');
	   var rx1 = new RegExp('\\.(png)$','gi');
	    var rx2 = new RegExp('\\.(jpg)$','gi');
		 var rx3 = new RegExp('\\.(jpeg)$','gi');
		  var rx4 = new RegExp('\\.(ico)$','gi');
		    var rx5 = new RegExp('\\.(bmp)$','gi');
	  if(file&&!file.match(rx)&&!file.match(rx1)&&!file.match(rx2)&&!file.match(rx3)&&!file.match(rx4)&&!file.match(rx5))
		  {    
		  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82744,user.getLanguage())%>.gif,png,jpg,jpeg,ico,bmp<%=SystemEnv.getHtmlLabelName(82745,user.getLanguage())%>!");
		  //alert("选择的文件不是图片文件，请选择图片文件！");       //重新构建input file       
	
		var file=document.getElementById("urllinkimagid");
		file.outerHTML=file.outerHTML;
	 
			}   
	  }
	  
function showFre(mode)
{
	for(i = 0; i < 4; i++)
	{
		document.getElementById("show_" + i).className = "vis4";
	}
	if("9" != mode)
	{
		document.getElementById("show_" + mode).className = "vis3";
	}
}

function changeSynType(obj)
{

    if(obj=="0"){
   
    hideEle("timeModulView");
   
    }else{
     showEle("timeModulView");
     
    }
}

function changeFileSaveType(obj)
{
   var temp=$(obj).val();
    $.ajax({ 
        	type:"POST",
            url: "/integration/exp/ExpGetRegitTypeOptons.jsp?"+Math.random(),
             data:{type:temp},
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
            
              //更改注册类型
    
  			$("#regitType option").remove();
   			$("#regitType").append(data);
  			
 		//解绑，绑定
		jQuery("#regitType").selectbox("detach");
 		__jNiceNamespace__.beautySelect("#regitType");
 
       }
        });

}
function showdetail1() {
	var XMLFileType = jQuery("#XMLFileType").val();
	if(XMLFileType == '1'){
		return false;
	}
	  var checked = $("#ExpWorkflowFileFlag").attr("checked");
	  var checked1 = $("#ExpWorkflowRemarkFileFlag").attr("checked");
		if(!checked&&!checked1){
			
			hideEle("ExpWorkflowFilePathView");
			
		} else {
			showEle("ExpWorkflowFilePathView");
		}

}
function showdetail(obj,val) {
	  var checked = $(obj).attr("checked");
		if(checked){
			showEle(val);
			
		} else {
			hideEle(val);
		}

}

function showdetail2(obj,val) {
      var checked1=$("#ExpWorkflowRemarkFlag").attr("checked");
	  var checked = $(obj).attr("checked");
		if(checked&&checked1){
			showEle(val);
			
		} else {
			hideEle(val);
		}
}

function changeXMLType()
{
	if($("#XMLType").val()=="0"){
		$("#ExpWorkflowFilePath").val("file");
		
		var xmltext = document.getElementById("xmltext");
		xmltext.value = (<%=JSONObject.quote(xmltext)%>);
	}else{
		$("#ExpWorkflowFilePath").val("");
		jQuery("#xmltext").val("");
	}
	checkinput("ExpWorkflowFilePath","ExpWorkflowFilePathimage");
	checkinput('xmltext','xmltextspan');
}
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class="zd_btn_submit" accessKey="S"  id="btnsearch" value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class="zd_btn_cancle" accessKey="T"  id="btncancel" value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>
