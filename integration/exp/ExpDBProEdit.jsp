<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.expdoc.ExpUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
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

	<!--新增 start  QC284050 [80][90]流程归档集成-将外表字段选择形式从下拉框改造成浏览框的改进-->
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	<!--新增 end QC284050 [80][90]流程归档集成-将外表字段选择形式从下拉框改造成浏览框的改进-->

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
ExpUtil eu=new ExpUtil();
String dbProOptions=eu.getDBProOptions("exp_dbdetail","name","id");

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = "";
//String typename = Util.null2String(request.getParameter("typename"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));

String proId = Util.null2String(request.getParameter("proid"));//方案id
String id = Util.null2String(request.getParameter("id"));//id




String tempajaxdata1="";  //主表
String tempajaxdata2="";//明细

String name ="";//方案名称
String fileSaveType ="";//文件保存方式
String regitType ="";//-注册类型
String expTableType= "";//文档归档目标
String synType = "";//同步方式
String timeModul = "0";//时间模式
String frequency = "";//时间模式为按年时，表示第几天
String frequencyy = "";//时间模式为按年时，表示第几天
String createTime = "";//计算类型，0,为表示正数，1，表示倒数
String createType = "";//同步具体时间

String regitDBId = "";//-注册数据库id
String mainTableKeyType = "";//主表主键生成规则,0,自增长,1,UUID,2,时间戳
String dtTableKeyType = "";//明细表主键生成规则,0,自增长,1,UUID,2,时间戳

String ExpWorkflowFileFlag = "";//导出流程表单文档
String ExpWorkflowFileForZipFlag = "";//-导出流程表单文档为ZIP
String ExpWorkflowRemarkFileFlag = "";//导出流转意见文档
String ExpWorkflowRemarkFileForZip = "";//导出流转意见文档为ZIP
String ExpWorkflowFilePath ="";//出流程文档路径
String ExpWorkflowInfoFlag ="";//导出流程表单
String ExpWorkflowInfoPath = "";//导出流程表单路径
String ExpWorkflowRemarkFlag = "";//导出流转意见
String ExpSignFileFlag = "";//导出签章图片
String ExpSignFilePath = "";//导出签章图片路径


String zwMapFiletype = "";//流程表单正文
String fjMapFiletype = "";//流程表单附件
String dwdMapFiletype = "";//流程表单文档
String mwdMapFiletype = "";//流程表单多文档
String remarkWDMapFiletype = "";//流转意见文档
String remarkFJMapFiletype = "";//流转意见附件
String bdMapFiletype = "";//-流程表单


if(!proId.equals("")){
	RecordSet rs=new RecordSet();
	String sql="select * from exp_DBProSettings where id="+proId;
	rs.executeSql(sql);
	if(rs.next()){
		 name = Util.fromScreen(rs.getString("name"),user.getLanguage());//方案名称
		 fileSaveType = Util.null2String(rs.getString("FileSaveType"));//文件保存方式
		 regitType = Util.null2String(rs.getString("regitType"));//-注册类型
		 expTableType = Util.null2String(rs.getString("expTableType"));//文档归档目标
		 synType = Util.null2String(rs.getString("synType"));//同步方式
		 timeModul = Util.null2String(rs.getString("TimeModul"));//时间模式
		 frequency = Util.null2String(rs.getString("Frequency"));//时间模式为按年时，表示第几天
		 frequencyy = Util.null2String(rs.getString("frequencyy"));//时间模式为按年时，表示第几天
		 createType = Util.null2String(rs.getString("createType"));//计算类型，0,为表示正数，1，表示倒数
		 createTime = Util.null2String(rs.getString("createTime"));//同步具体时间
		
		 regitDBId = Util.null2String(rs.getString("regitDBId"));//注册数据库id
		 mainTableKeyType = Util.null2String(rs.getString("mainTableKeyType"));//主表主键生成规则,0,自增长,1,UUID,2,时间戳
		 dtTableKeyType = Util.null2String(rs.getString("dtTableKeyType"));//明细表主键生成规则,0,自增长,1,UUID,2,时间戳
		
		 ExpWorkflowFileFlag = Util.null2String(rs.getString("ExpWorkflowFileFlag"));//导出流程表单文档
		 ExpWorkflowFileForZipFlag = Util.null2String(rs.getString("ExpWorkflowFileForZipFlag"));//-导出流程表单文档为ZIP
		 ExpWorkflowRemarkFileFlag = Util.null2String(rs.getString("ExpWorkflowRemarkFileFlag"));//导出流转意见文档
		 ExpWorkflowRemarkFileForZip = Util.null2String(rs.getString("ExpWorkflowRemarkFileForZip"));//导出流转意见文档为ZIP
		 ExpWorkflowFilePath = Util.null2String(rs.getString("ExpWorkflowFilePath"));//出流程文档路径
		 ExpWorkflowInfoFlag = Util.null2String(rs.getString("ExpWorkflowInfoFlag"));//导出流程表单
		 ExpWorkflowInfoPath = Util.null2String(rs.getString("ExpWorkflowInfoPath"));//导出流程表单路径
		 ExpWorkflowRemarkFlag = Util.null2String(rs.getString("ExpWorkflowRemarkFlag"));//导出流转意见
		 ExpSignFileFlag = Util.null2String(rs.getString("ExpSignFileFlag"));//导出签章图片
		 ExpSignFilePath = Util.null2String(rs.getString("ExpSignFilePath"));//导出签章图片路径
		 
		 zwMapFiletype = Util.null2String(rs.getString("zwMapFiletype"));//流程表单正文
		 fjMapFiletype = Util.null2String(rs.getString("fjMapFiletype"));//流程表单附件
		 dwdMapFiletype = Util.null2String(rs.getString("dwdMapFiletype"));//流程表单文档
		 mwdMapFiletype = Util.null2String(rs.getString("mwdMapFiletype"));//流程表单多文档
		 remarkWDMapFiletype = Util.null2String(rs.getString("remarkWDMapFiletype"));//流转意见文档
		 remarkFJMapFiletype = Util.null2String(rs.getString("remarkFJMapFiletype"));//流转意见附件
		 bdMapFiletype = Util.null2String(rs.getString("bdMapFiletype"));//流程表单
	}
	
}

StringBuffer tempMainDatas = new StringBuffer();
StringBuffer tempdtDatas = new StringBuffer();
if(!proId.equals("")){
	
	RecordSet rs=new RecordSet();
	String sql="select * from exp_dbmaintablesetting where dbsettingid="+proId+" order by id";
	rs.executeSql(sql);
	while(rs.next()){
		String amaincolumnname=Util.null2String(rs.getString("columnname"));
		String amaincolumntype=Util.null2String(rs.getString("columntype"));
		String amainprimarykey=Util.null2String(rs.getString("primarykey"));
		String amainisdoce=Util.null2String(rs.getString("isdoce"));
		String amaindoctype=Util.null2String(rs.getString("doctype"));
		String amainisdocname=Util.null2String(rs.getString("filename"));
	
		String bl1=amainprimarykey.equals("1")?"true":"false";
		String bl2=amainisdoce.equals("1")?"true":"false";
		String bl3=amaindoctype.equals("1")?"true":"false";
		String bl4=amainisdocname.equals("1")?"true":"false";
		tempMainDatas.append("[");
		tempMainDatas.append("{name:'mainfieldName',value:'"+amaincolumnname  +"',label:'"+ amaincolumnname  +  "',iseditable:true,type:'browser'},");
		tempMainDatas.append("{name:'tempfieldtypespan',value:'"+amaincolumntype+"',iseditable:false,type:'span'},");
		tempMainDatas.append("{name:'mainfieldtype',value:'"+amaincolumntype+"',iseditable:true,type:'input|hidden'},");
		tempMainDatas.append("{name:'tempmainiskey',value:'"+amainprimarykey+"',iseditable:true,checked:"+bl1+",type:'checkbox'},");
		tempMainDatas.append("{name:'mainiskey',value:'"+amainprimarykey+"',iseditable:true,type:'input|hidden'},");
		tempMainDatas.append("{name:'tempmainisdoc',value:'"+amainisdoce+"',iseditable:true,checked:"+bl2+",type:'checkbox'},");
		tempMainDatas.append("{name:'mainisdoc',value:'"+amainisdoce+"',iseditable:true,type:'input|hidden'},");
		tempMainDatas.append("{name:'tempmainisdoctype',value:'"+amaindoctype+"',iseditable:true,checked:"+bl3+",type:'checkbox'},");
		tempMainDatas.append("{name:'mainisdoctype',value:'"+amaindoctype +"',iseditable:true,type:'input|hidden'},");
		
		tempMainDatas.append("{name:'tempmainisdocname',value:'"+amainisdocname+"',iseditable:true,checked:"+bl4+",type:'checkbox'},");
		tempMainDatas.append("{name:'mainisdocname',value:'"+amainisdocname +"',iseditable:true,type:'input|hidden'}");
		tempMainDatas.append("],");
	
	}
	tempajaxdata1=tempMainDatas.toString();
	if(!"".equals(tempajaxdata1))
	{
		tempajaxdata1 = tempajaxdata1.substring(0,(tempajaxdata1.length()-1));
	}
	tempajaxdata1 = "["+tempajaxdata1+"]";
	
	
	 sql="select * from exp_dbdetailtablesetting where dbsettingid="+proId+" order by id";
	rs.executeSql(sql);
	while(rs.next()){
		String ademaildbsettingid=Util.null2String(rs.getString("dbsettingid"));
		String ademailcolumnname=Util.null2String(rs.getString("columnname"));
		String ademailcolumntype=Util.null2String(rs.getString("columntype"));
		String ademailprimarykey=Util.null2String(rs.getString("primarykey"));
		String ademailisdoce=Util.null2String(rs.getString("isdoce"));
		String ademaildoctype=Util.null2String(rs.getString("doctype"));
		String ademailismainkey=Util.null2String(rs.getString("mainid"));
		String ademailisdocname=Util.null2String(rs.getString("filename"));
		
		String bl1=ademailprimarykey.equals("1")?"true":"false";
		String bl2=ademailisdoce.equals("1")?"true":"false";
		String bl3=ademaildoctype.equals("1")?"true":"false";
		String bl4=ademailismainkey.equals("1")?"true":"false";
		String bl5=ademailisdocname.equals("1")?"true":"false";
		tempdtDatas.append("[");
		tempdtDatas.append("{name:'dtfieldName',value:'"+ademailcolumnname +"',label:'"+ ademailcolumnname  + "',iseditable:true,type:'browser'},");
		tempdtDatas.append("{name:'tempdtfieldtypespan',value:'"+ademailcolumntype+"',iseditable:false,type:'span'},");
		tempdtDatas.append("{name:'dtfieldtype',value:'"+ademailcolumntype+"',iseditable:true,type:'input|hidden'},");
		tempdtDatas.append("{name:'tempdtiskey',value:'"+ademailprimarykey+"',iseditable:true,checked:"+bl1+",type:'checkbox'},");
		tempdtDatas.append("{name:'dtiskey',value:'"+ademailprimarykey+"',iseditable:true,type:'input|hidden'},");
		tempdtDatas.append("{name:'tempdtisdoc',value:'"+ademailisdoce+"',iseditable:true,checked:"+bl2+",type:'checkbox'},");
		tempdtDatas.append("{name:'dtisdoc',value:'"+ademailisdoce+"',iseditable:true,type:'input|hidden'},");
		tempdtDatas.append("{name:'tempdtisdoctype',value:'"+ademaildoctype+"',iseditable:true,checked:"+bl3+",type:'checkbox'},");
		tempdtDatas.append("{name:'dtisdoctype',value:'"+ademaildoctype +"',iseditable:true,type:'input|hidden'},");
		
		tempdtDatas.append("{name:'tempdtismainkey',value:'"+ademailismainkey+"',iseditable:true,checked:"+bl4+",type:'checkbox'},");
		tempdtDatas.append("{name:'dtismainkey',value:'"+ademailismainkey +"',iseditable:true,type:'input|hidden'},");
		tempdtDatas.append("{name:'tempdtisdocname',value:'"+ademailisdocname+"',iseditable:true,checked:"+bl5+",type:'checkbox'},");
		tempdtDatas.append("{name:'dtisdocname',value:'"+ademailisdocname +"',iseditable:true,type:'input|hidden'}");
		tempdtDatas.append("],");
	
	}
	tempajaxdata2=tempdtDatas.toString();
	if(!"".equals(tempajaxdata2))
	{
		tempajaxdata2 = tempajaxdata2.substring(0,(tempajaxdata2.length()-1));
	}
	tempajaxdata2 = "["+tempajaxdata2+"]";
}

boolean usedFlag = new weaver.expdoc.ExpUtil().getShowmethod(id+"+3").equals("true");
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
if(HrmUserVarify.checkUserRight("intergration:expsetting", user) && usedFlag){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
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
			<%}
				if(HrmUserVarify.checkUserRight("intergration:expsetting", user) && usedFlag){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
			<%
			}
			%>
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
<FORM id=weaver name=frmMain action="/integration/exp/ExpDBProOperation.jsp" method=post >
<input class=inputstyle type=hidden name="proId" value="<%=proId%>">
<input class=inputstyle type=hidden name="id" value="<%=id%>">
<input class=inputstyle type=hidden name="backto" value="">
<input class=inputstyle type="hidden" name=operation value="edit">
 <wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82743,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">

		<wea:item><%=SystemEnv.getHtmlLabelName(33162,user.getLanguage())%></wea:item><!-- 方案名称 -->
		<wea:item>
            <wea:required id="nameimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18493,86,599",user.getLanguage())%></wea:item><!-- 文件保存方式 -->
		<wea:item>
           <select id="FileSaveType" style='width:120px!important;' name="FileSaveType" onchange="changeFileSaveType(this);">
			  <option value="0" <%if(fileSaveType.equals("0")) out.print("selected"); %>>FTP</option>
			  <option value="1"  <%if(fileSaveType.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(125714,user.getLanguage())%></option><!-- 本地 -->
			   <option value="2"  <%if(fileSaveType.equals("2")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%></option><!-- 数据库 -->
			</select>
		</wea:item>
	   <wea:item attributes="{'samePair':'regitTypeView'}" ><%=SystemEnv.getHtmlLabelNames("31691,63",user.getLanguage())%></wea:item><!-- 注册类型 -->
		<wea:item attributes="{'samePair':'regitTypeView'}" >
		<wea:required id="regitTypeimage" required="true" value="">
           <select id="regitType" style='width:120px!important;' name="regitType" onchange="">
			  <option value=""></option>
			</select>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(125715 ,user.getLanguage())%></wea:item><!-- 文档归档目标 -->
		<wea:item>
           <select id="expTableType" style='width:120px!important;' name="expTableType" onchange="changeexpTableType('')">
			<option value="0"><%=SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())%></option><!-- 主表 -->
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(125716 ,user.getLanguage())%></wea:item><!-- 文档存储数据类型 -->
		<wea:item>
		<span id="filesavetypespan">
		<%=SystemEnv.getHtmlLabelName(125863 ,user.getLanguage())%>
		</span><!-- 文件路径 -->
         
		</wea:item>
		
		
		  <wea:item><%=SystemEnv.getHtmlLabelName(32220 ,user.getLanguage())%></wea:item><!-- 同步方式 -->
		  <wea:item>
						<select id="synType" name="synType" style='width:180px!important;' onchange='changeSynType(this.value);'>
							<option value="0" ><%=SystemEnv.getHtmlLabelName(30107 ,user.getLanguage())%></option><!-- 手动同步 -->
							<option value="1" <%if(synType.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(32221 ,user.getLanguage())%></option><!-- 自动同步 -->
						</select>
		   </wea:item>
		  <wea:item attributes="{'samePair':'timeModulView','display':'none'}"><%=SystemEnv.getHtmlLabelName(32223 ,user.getLanguage())%></wea:item><!-- 同步频率 -->
		   <wea:item attributes="{'samePair':'timeModulView','display':'none'}">
				  	<SPAN class=itemspan>
					  	<SELECT style='width:80px!important;float:left;' id="TimeModul" name="TimeModul" onchange="showFre(this.value)">
							<OPTION value="0" <%if("0".equals(timeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
							<OPTION value="1" <%if("1".equals(timeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
							<OPTION value="2" <%if("2".equals(timeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
							<OPTION value="3" <%if("3".equals(timeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
						</SELECT>
					</SPAN>
					<%
					
						String a="vis4";
				  		String b="vis4";
				  		String c="vis4";
				  		String d="vis4";
				  		if (Util.null2String(timeModul).equals("0"))
						{
						    a="vis3";
						}
						else if (Util.null2String(timeModul).equals("1"))
						{
						    b="vis3";
						}
						else if (Util.null2String(timeModul).equals("2"))
						{
						    c="vis3";
						}
						else if (Util.null2String(timeModul).equals("3"))
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
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "0".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
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
							<%--//QC335317 [80][90][缺陷]流程归档集成-解决归档方案中同步频率不能修改的问题 --%>
							<SELECT style='width:80px!important;' name="fer_0">
				 				<OPTION value="1" <%if (frequency.equals("1") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
				 				<OPTION value="2" <%if (frequency.equals("2") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
				 				<OPTION value="3" <%if (frequency.equals("3") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
				 				<OPTION value="4" <%if (frequency.equals("4") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
				 				<OPTION value="5" <%if (frequency.equals("5") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
				 				<OPTION value="6" <%if (frequency.equals("6") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
				 				<OPTION value="7" <%if (frequency.equals("7") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="weekTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "1".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
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
								<OPTION value="0" <%if (createType.equals("0") && "2".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if (createType.equals("1") && "2".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
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
								<OPTION value="<%=i%>" <%if (Util.null2String(frequency).equals(""+i) && "2".equals(timeModul)) {%>selected<%}%>><%=i%></OPTION>
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
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "2".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
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
							<%--////QC335317 [80][90][缺陷]流程归档集成-解决归档方案中同步频率不能修改的问题 --%>
							<SELECT style='width:80px!important;' name="fer_2">
						 	<%
						 		for (int i = 1; i <= 12; i++) 
						 		{
						 	%>
								<OPTION value="<%= Util.add0(i, 2) %>" <%if (Util.null2String(frequency).equals(""+i) && "3".equals(timeModul)) {%>selected<%}%>><%= Util.add0(i, 2) %></OPTION>
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
								<OPTION value="0" <%if (createType.equals("0") && "3".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if (createType.equals("1") && "3".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
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
								<OPTION value="<%=i%>" <%if(frequencyy.equals(""+i) && "3".equals(timeModul)) {%>selected<%}%>><%=i%></OPTION>
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
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "3".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
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
		
	<!-- 数据库设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(21955, user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelNames("31691,15024", user.getLanguage())%></wea:item><!-- 注册数据库 -->
		<wea:item>
		<wea:required id="regitDBIdimage" required="true" value="">
           <select id="regitDBId" style='width:120px!important;' name="regitDBId" onchange="changeRegitDBId('');checkinput('regitDBId','regitDBIdimage');">
			 <%out.print(dbProOptions);%>
			</select>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("21778,21900", user.getLanguage())%></wea:item><!-- 主表表名 -->
		<wea:item>
           <span id='mainTableSpan'>abcMain</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125717, user.getLanguage())%></wea:item><!-- 主表主键生成规则 -->
		<wea:item>
          <span id="mainTableKeyTypespan">
			<input type=radio name="mainTableKeyType" id="mainTableKeyType0" value=0 <%if(mainTableKeyType.equals("0")) out.print("checked"); %>><%=SystemEnv.getHtmlLabelName(125718,user.getLanguage())%><!-- 自增长 -->
		    <input type=radio name="mainTableKeyType" id="mainTableKeyType1" value=1 <%if(mainTableKeyType.equals("1")) out.print("checked"); %>>UUID
		    <input type=radio name="mainTableKeyType" id="mainTableKeyType2" value=2 <%if(mainTableKeyType.equals("2")) out.print("checked"); %>><%=SystemEnv.getHtmlLabelName(125719,user.getLanguage())%><!-- 时间戳 -->
		</span>
		</wea:item>	
	</wea:group><!-- 主表字段列表 -->
	<%String mainTableFieldListLable = SystemEnv.getHtmlLabelNames("21778,82104", user.getLanguage());%>
	<wea:group context="<%=mainTableFieldListLable%>" attributes="{'samePair':'SetInfo1','groupOperDisplay':'none','itemAreaDisplay':'block',id='mainheader'}">
		<wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow('mainFields')" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow('mainFields')" ACCESSKEY="G" class="delbtn"/>
		  </div>
	    </wea:item>
	    <wea:item attributes="{'colspan':'2','isTableList':'true'}">
	   	<div id="mainFields">
		</div>
	    </wea:item>
	</wea:group><!-- 明细 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%>" attributes="{'samePair':'detailgroupview','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(31900,user.getLanguage())%></wea:item><!-- 明细表名 -->
		<wea:item>
		 <spanid id='dtTableSpan'>abcdetail</span>
         
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125721,user.getLanguage())%></wea:item><!-- 明细表主键生成规则 -->
		<wea:item>
          <span id="detailTableKeyTypespan">
			<input type="radio" name="dtTableKeyType" id="detailTableKeyType0" value="0" <%if(dtTableKeyType.equals("0")) out.print("checked"); %>><%=SystemEnv.getHtmlLabelName(125718,user.getLanguage())%><!-- 自增长 -->
		    <input type="radio" name="dtTableKeyType" id="detailTableKeyType1" value="1" <%if(dtTableKeyType.equals("1")) out.print("checked"); %>>UUID
		    <input type="radio" name="dtTableKeyType" id="detailTableKeyType2" value="2" <%if(dtTableKeyType.equals("2")) out.print("checked"); %>><%=SystemEnv.getHtmlLabelName(125719,user.getLanguage())%><!-- 时间戳 -->
		</span>
		</wea:item>	
		
		</wea:group>
		<!-- 明细表字段列表 -->
			<%String detailTableFieldListLable = SystemEnv.getHtmlLabelNames("84496,82104", user.getLanguage());%>
		<wea:group context="<%=detailTableFieldListLable%>" attributes="{'samePair':'detailgroupview','groupOperDisplay':'none','itemAreaDisplay':'block',id='detailheader'}">
		<wea:item type="groupHead">
		  <div style='float:right;' id='dtHeaddiv'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow('detailFields')" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow('detailFields')" ACCESSKEY="G" class="delbtn"/>
		  </div>
	    </wea:item>
	    <wea:item attributes="{'colspan':'2','isTableList':'true'}" >
	   	<div id="detailFields">
		</div>
	    </wea:item>
	</wea:group>
	  <!-- end -->
	  
	  <!--  流程文档导出设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(125722, user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(125723, user.getLanguage())%></wea:item><!--  导出流程表单文档-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowFileFlag" name="ExpWorkflowFileFlag" value="1" <%if(ExpWorkflowFileFlag.equals("1"))out.println("checked"); %> onclick="showdetailToClear(this,'','ExpWorkflowFileForZipFlag');showdetail1();showdetail(this,'ExpWorkflowFileForZipFlagView,zwMapFiletypeView,fjMapFiletypeView,dwdMapFiletypeView,mwdMapFiletypeView');" >
		</wea:item >
		<!--  导出流程表单文档为ZIP-->
		<wea:item attributes="{'samePair':'ExpWorkflowFileForZipFlagView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125724, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowFileForZipFlagView','display':'none'}">
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowFileForZipFlag" name="ExpWorkflowFileForZipFlag" value="1" <%if(ExpWorkflowFileForZipFlag.equals("1"))out.println("checked"); %>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125725, user.getLanguage())%></wea:item><!--  导出流转意见文档-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowRemarkFileFlag" name="ExpWorkflowRemarkFileFlag" value="1" <%if(ExpWorkflowRemarkFileFlag.equals("1"))out.println("checked"); %> onclick="showdetailToClear(this,'','ExpWorkflowRemarkFileForZip');showdetail1();showdetail(this,'ExpWorkflowRemarkFileForZipView,remarkWDMapFiletypeView,remarkFJMapFiletypeView');">
		</wea:item>
		<!--  导出流转意见文档为ZIP-->
		<wea:item attributes="{'samePair':'ExpWorkflowRemarkFileForZipView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125726, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowRemarkFileForZipView','display':'none'}">
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowRemarkFileForZip" name="ExpWorkflowRemarkFileForZip" value="1" <%if(ExpWorkflowRemarkFileForZip.equals("1"))out.println("checked"); %>>
		</wea:item>
		<!--  导出流程文档路径-->
		<wea:item attributes="{'samePair':'ExpWorkflowFilePathView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125727, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowFilePathView','display':'none'}">
            <wea:required id="ExpWorkflowFilePathimage" required="true" value='<%=ExpWorkflowFilePath%>'>
            	<input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" id="ExpWorkflowFilePath" name="ExpWorkflowFilePath"  value='<%=ExpWorkflowFilePath%>' onchange='checkinput("ExpWorkflowFilePath","ExpWorkflowFilePathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		
		</wea:group>
	  <!-- end -->
	  
	   <!--  流程表单导出设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(125728, user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(125729, user.getLanguage())%></wea:item><!--  导出流程表单-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowInfoFlag" name="ExpWorkflowInfoFlag" value="1" <%if(ExpWorkflowInfoFlag.equals("1"))out.println("checked"); %> onclick="showdetailToClear(this,'','');showdetail3(this,'ExpWorkflowInfoPathView');showdetail(this,'bdMapFiletypeView');">
		</wea:item>
		<!--  导出流程表单路径-->
		<wea:item attributes="{'samePair':'ExpWorkflowInfoPathView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125730, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpWorkflowInfoPathView','display':'none'}">
            <wea:required id="ExpWorkflowInfoPathimage" required="true" value='<%=ExpWorkflowInfoPath%>'>
            	<input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100"  id="ExpWorkflowInfoPath" name="ExpWorkflowInfoPath" value="<%=ExpWorkflowInfoPath %>"  onchange='checkinput("ExpWorkflowInfoPath","ExpWorkflowInfoPathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126171, user.getLanguage())%></wea:item><!--  导出流转意见-->
		<wea:item>
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpWorkflowRemarkFlag" name="ExpWorkflowRemarkFlag" value="1" <%if(ExpWorkflowRemarkFlag.equals("1"))out.println("checked"); %> onclick="showdetailToClear(this,'','ExpSignFileFlag');showdetail3(this,'ExpSignFilePathView');showdetail(this,'ExpSignFileFlagView');showdetail2($('#ExpSignFileFlag'),'ExpSignFilePathView');">
		</wea:item>
		<!--  导出签章图片-->
		<wea:item attributes="{'samePair':'ExpSignFileFlagView','display':''}"><%=SystemEnv.getHtmlLabelName(125731, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpSignFileFlagView','display':''}">
          <input class="inputstyle" type="checkbox" tzCheckbox='true' id="ExpSignFileFlag" name="ExpSignFileFlag" value="1" <%if(ExpSignFileFlag.equals("1"))out.println("checked"); %> onclick="showdetailToClear(this,'','');showdetail3(this,'ExpSignFilePathView');">
		</wea:item>
		<!--  导出签章图片路径-->
		<wea:item attributes="{'samePair':'ExpSignFilePathView','display':'none'}"><%=SystemEnv.getHtmlLabelName(125732, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'ExpSignFilePathView','display':'none'}">
            <wea:required id="ExpSignFilePathimage" required="true" value='<%=ExpSignFilePath%>'>
            	<input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" id="ExpSignFilePath" name="ExpSignFilePath" value="<%=ExpSignFilePath %>"  onchange='checkinput("ExpSignFilePath","ExpSignFilePathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		</wea:group>
	  <!-- end -->
	  
	  
	    <!--  流程文档类型对应文档类型值设置-->
	  <wea:group context="<%=SystemEnv.getHtmlLabelName(125733,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item attributes="{'samePair':'zwMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelNames("34130,1265",user.getLanguage())%></wea:item><!-- 流程表单正文-->
		<wea:item attributes="{'samePair':'zwMapFiletypeView','display':'none'}">
          <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="zwMapFiletype" id="zwMapFiletype"  value="<%=zwMapFiletype%>" _noMultiLang='true'>
         </wea:item>
		<wea:item attributes="{'samePair':'fjMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelNames("34130,156",user.getLanguage())%></wea:item><!-- 流程表单附件 -->
		<wea:item attributes="{'samePair':'fjMapFiletypeView','display':'none'}">
           <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="fjMapFiletype" id="fjMapFiletype"  value="<%=fjMapFiletype%>" _noMultiLang='true'>
		</wea:item>
		<wea:item attributes="{'samePair':'dwdMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelNames("34130,58",user.getLanguage())%></wea:item><!-- 流程表单文档 -->
		<wea:item attributes="{'samePair':'dwdMapFiletypeView','display':'none'}">
          <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="dwdMapFiletype" id="dwdMapFiletype"  value="<%=dwdMapFiletype%>" _noMultiLang='true'>
		</wea:item>
		<wea:item attributes="{'samePair':'mwdMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelNames("34130,6163",user.getLanguage())%></wea:item><!-- 流程表单多文档 -->
		<wea:item attributes="{'samePair':'mwdMapFiletypeView','display':'none'}">
           <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="mwdMapFiletype" id="mwdMapFiletype" value="<%=mwdMapFiletype%>" _noMultiLang='true'>
		</wea:item>
		<wea:item attributes="{'samePair':'remarkWDMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelNames("125734,58",user.getLanguage())%></wea:item><!-- 流转意见文档 -->
		<wea:item attributes="{'samePair':'remarkWDMapFiletypeView','display':'none'}">   
          <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="remarkWDMapFiletype" id="remarkWDMapFiletype"  value="<%=remarkWDMapFiletype%>" _noMultiLang='true'>
		</wea:item>
		<wea:item attributes="{'samePair':'remarkFJMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelNames("125734,156",user.getLanguage())%></wea:item><!-- 流转意见附件 -->
		<wea:item attributes="{'samePair':'remarkFJMapFiletypeView','display':'none'}">
          <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="remarkFJMapFiletype" id="remarkFJMapFiletype"  value="<%=remarkFJMapFiletype%>" _noMultiLang='true'>  
		</wea:item>
		<wea:item attributes="{'samePair':'bdMapFiletypeView','display':'none'}"><%=SystemEnv.getHtmlLabelName(34130,user.getLanguage())%></wea:item><!-- 流程表单 -->
		<wea:item attributes="{'samePair':'bdMapFiletypeView','display':'none'}">
          <input class=inputstyle type="text" style='width:280px!important;' size=100 maxlength="100" name="bdMapFiletype" id="bdMapFiletype"  value="<%=bdMapFiletype%>" _noMultiLang='true'>
		</wea:item>
	
		
		</wea:group>
	  <!-- end -->
	
</wea:layout>
<br>
 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>

<script language="javascript">


var group=null;
var group_dt=null;
jQuery(document).ready(function(){
   iniData();
   showdetail1();
   showdetail($("#ExpWorkflowRemarkFlag"),'ExpSignFileFlagView');
   showdetail3($("#ExpSignFileFlag"),'ExpSignFilePathView');
   showdetail3($("#ExpWorkflowInfoFlag"),'ExpWorkflowInfoPathView');
   showdetail($("#ExpWorkflowInfoFlag"),'bdMapFiletypeView');
    showdetail($("#ExpWorkflowFileFlag"),'ExpWorkflowFileForZipFlagView');
    
    
    showdetail($('#ExpWorkflowFileFlag'),'ExpWorkflowFileForZipFlagView,zwMapFiletypeView,fjMapFiletypeView,dwdMapFiletypeView,mwdMapFiletypeView');
    showdetail($('#ExpWorkflowRemarkFileFlag'),'ExpWorkflowRemarkFileForZipView,remarkWDMapFiletypeView,remarkFJMapFiletypeView');
    
    checkinput("ExpSignFilePath","ExpSignFilePathimage");
    checkinput("name","nameimage");
	checkinput("ExpWorkflowInfoPath","ExpWorkflowInfoPathimage");
	checkinput("ExpWorkflowFilePath","ExpWorkflowFilePathimage");
	checkinput('regitDBId','regitDBIdimage');
    
	changeSynType($("#synType").val());
	changeFileSaveType($("#FileSaveType"));
    changeRegitDBId("true");
    

 	$("#regitType").val("<%=regitType%>");
 	//解绑，绑定
 	$("#regitType").selectbox("detach");
	__jNiceNamespace__.beautySelect("#regitType");
 
    $("#expTableType").val("<%=expTableType%>");
 //解绑，绑定
 $("#expTableType").selectbox("detach");
__jNiceNamespace__.beautySelect("#expTableType");
   changeexpTableType("true");

	checkinput("regitType","regitTypeimage");
});

function iniData() {
 $("#regitDBId").val("<%=regitDBId%>");
 //解绑，绑定
 $("#regitDBId").selectbox("detach");
__jNiceNamespace__.beautySelect("#regitDBId");

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
	var FileSaveType = jQuery("#FileSaveType").val();
	if(FileSaveType!='2'){
		var checked = $(obj).attr("checked");
		if(checked){
			if(val != ''){
				var array = val.split(",");
				for(var i=0; i<array.length; i++){
					showEle(array[i]);
				}
			}
		} else {
			if(val != ''){
				var array = val.split(",");
				for(var i=0; i<array.length; i++){
					hideEle(array[i]);
				}
			}
			
		}
	}
}

function submitData() {
	var fst = jQuery("#FileSaveType").val();
    var expTableType = jQuery("#expTableType").val();
    
    var columnValidateFlag = false;
    if(expTableType == '0'){
    	var tempmainiskeyArray = jQuery("[name='tempmainiskey']");
    	var tempmainisdoctypeArray = jQuery("[name='tempmainisdoctype']");
    	var tempmainisdocnameArray = jQuery("[name='tempmainisdocname']");
    	var tempmainisdocArray = jQuery("[name='tempmainisdoc']");
    	
    	var tempdtiskeyArray = jQuery("[name='tempdtiskey']");
    	
    	var tempmainiskeyIdx = 0;
    	for(var i=0; i<tempmainiskeyArray.length; i++){
    		var tempStatus = jQuery(tempmainiskeyArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempmainiskeyIdx++;
    		}
    	}
    	var tempmainisdoctypeIdx = 0;
    	for(var i=0; i<tempmainisdoctypeArray.length; i++){
    		var tempStatus = jQuery(tempmainisdoctypeArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempmainisdoctypeIdx++;
    		}
    	}
    	var tempmainisdocnameIdx = 0;
    	for(var i=0; i<tempmainisdocnameArray.length; i++){
    		var tempStatus = jQuery(tempmainisdocnameArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempmainisdocnameIdx++;
    		}
    	}
    	var tempmainisdocIdx = 0;
    	for(var i=0; i<tempmainisdocArray.length; i++){
    		var tempStatus = jQuery(tempmainisdocArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempmainisdocIdx++;
    		}
    	}
    	
    	var tempdtiskeyIdx = 0;
    	for(var i=0; i<tempdtiskeyArray.length; i++){
    		var tempStatus = jQuery(tempdtiskeyArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempdtiskeyIdx++;
    		}
    	}
    	
    	if((tempmainiskeyArray>0 && (
    			tempmainiskeyIdx!=1 
    			|| tempmainisdoctypeIdx!=1 
    			|| tempmainisdocnameIdx!=1 
    			|| tempmainisdocIdx!=1)) || (tempdtiskeyArray.length>0&&tempdtiskeyIdx!=1)){
    		//alert("请勾选必填项!");
    		columnValidateFlag = true;
    	}
    	
    }else if (expTableType == '1'){
    	var tempdtiskeyArray = jQuery("[name='tempdtiskey']");
    	var tempdtisdocArray = jQuery("[name='tempdtisdoc']");
    	var tempdtisdoctypeArray = jQuery("[name='tempdtisdoctype']");
    	var tempdtismainkeyArray = jQuery("[name='tempdtismainkey']");
    	var tempdtisdocnameArray = jQuery("[name='tempdtisdocname']");
    	
    	var tempmainiskeyArray = jQuery("[name='tempmainiskey']");
    	
    	var tempdtiskeyIdx = 0;
    	for(var i=0; i<tempdtiskeyArray.length; i++){
    		var tempStatus = jQuery(tempdtiskeyArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempdtiskeyIdx++;
    		}
    	}
    	var tempdtisdocIdx = 0;
    	for(var i=0; i<tempdtisdocArray.length; i++){
    		var tempStatus = jQuery(tempdtisdocArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempdtisdocIdx++;
    		}
    	}
    	var tempdtisdoctypeIdx = 0;
    	for(var i=0; i<tempdtisdoctypeArray.length; i++){
    		var tempStatus = jQuery(tempdtisdoctypeArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempdtisdoctypeIdx++;
    		}
    	}
    	var tempdtismainkeyIdx = 0;
    	for(var i=0; i<tempdtismainkeyArray.length; i++){
    		var tempStatus = jQuery(tempdtismainkeyArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempdtismainkeyIdx++;
    		}
    	}
    	var tempdtisdocnameIdx = 0;
    	for(var i=0; i<tempdtisdocnameArray.length; i++){
    		var tempStatus = jQuery(tempdtisdocnameArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempdtisdocnameIdx++;
    		}
    	}
    	var tempmainiskeyIdx = 0;
    	for(var i=0; i<tempmainiskeyArray.length; i++){
    		var tempStatus = jQuery(tempmainiskeyArray[i]).attr("checked")?"1":"0";
    		if(tempStatus == '1'){
    			tempmainiskeyIdx++;
    		}
    	}
    	
    	if((tempdtiskeyArray.length>0 &&
    			(tempdtiskeyIdx!=1 
    			|| tempdtisdocIdx!=1 
    			|| tempdtisdoctypeIdx!=1 
    			|| tempdtismainkeyIdx!=1 
    			|| tempdtisdocnameIdx!=1)) ||(tempmainiskeyArray.length>0&&tempmainiskeyIdx!=1)){
    		//alert("请勾选必填项!");
    		columnValidateFlag = true;
    	}
    }
    if(columnValidateFlag){
    	alert("<%=SystemEnv.getHtmlLabelName(128193,user.getLanguage())%>");
    	return;
    }
    
    var docValidateFlag = false;
    
    //文档归档目标
    if(expTableType == '0'){
	    //主表 文档校验
		var mainFieldTypeArray = jQuery("input[name='mainfieldtype']");
		for(var i=0; i<mainFieldTypeArray.length; i++){
			var mainFieldType = jQuery(mainFieldTypeArray[i]).val();
			if(mainFieldType == ''){continue;}
			
			var mainisdoc = jQuery(mainFieldTypeArray[i])
								.parent().next().next()
								.find("input[name='mainisdoc']").val();
			if(mainisdoc == '1'){
				if(fst=="0"||fst=="1"){
					if(mainFieldType!="varchar" && mainFieldType!="varchar2"){
						var selectedOptionText = jQuery(mainFieldTypeArray[i])
												.parent().prev()
												.find("select[name='mainfieldName' option:selected]").text();
						alert(selectedOptionText+"  <%=SystemEnv.getHtmlLabelName(125744 ,user.getLanguage())%>");//文档字段类型不匹配！
						docValidateFlag = true;
					}
				}else if(fst=="2"){
					if(mainFieldType!="image" && mainFieldType!="blob" && mainFieldType!="longvarbinary"){
						var selectedOptionText = jQuery(mainFieldTypeArray[i])
												.parent().prev()
												.find("select[name='mainfieldName'] option:selected").text();
						alert(selectedOptionText+"  <%=SystemEnv.getHtmlLabelName(125744 ,user.getLanguage())%>");//文档字段类型不匹配！
						docValidateFlag = true;
					}
				}
			}
		}
    }else if (expTableType == '1'){
    	//明细表 文档校验
    	var dtFieldTypeArray = jQuery("input[name='dtfieldtype']");
    	for(var i=0; i<dtFieldTypeArray.length; i++){
    		var dtFieldType = jQuery(dtFieldTypeArray[i]).val();
    		if(dtFieldType == ''){continue;}
    		
    		var dtisdoc = jQuery(dtFieldTypeArray[i])
    							.parent().next().next()
    							.find("input[name='dtisdoc']").val();
    		if(dtisdoc == '1'){
    			if(fst=="0"||fst=="1"){
    				if(dtFieldType!="varchar" && dtFieldType!="varchar2"){
    					var selectedOptionText = jQuery(dtFieldTypeArray[i])
    											.parent().prev()
    											.find("select[name='dtfieldName' option:selected]").text();
    					alert(selectedOptionText+"  <%=SystemEnv.getHtmlLabelName(125744 ,user.getLanguage())%>");//文档字段类型不匹配！
    					docValidateFlag = true;
    				}
    			}else if(fst=="2"){
    				if(dtFieldType!="image" && dtFieldType!="blob" && dtFieldType!="longvarbinary"){
    					var selectedOptionText = jQuery(dtFieldTypeArray[i])
    											.parent().prev()
    											.find("select[name='dtfieldName'] option:selected").text();
    					alert(selectedOptionText+"  <%=SystemEnv.getHtmlLabelName(125744 ,user.getLanguage())%>");//文档字段类型不匹配！
    					docValidateFlag = true;
    				}
    			}
    		}
    	}
    }
    
	if(docValidateFlag){return false;}
	
	
	
	
	
	
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

	checkvalue+= "name,regitDBId,regitType";
	
    if(check_form(frmMain,checkvalue)){
    	if(fst!=2){
	    	if(!jQuery("#ExpWorkflowInfoFlag").attr("checked")){
	    		jQuery("#ExpWorkflowInfoPath").val("");
	    	}
	    	if(!jQuery("#ExpWorkflowRemarkFlag").attr("checked")){
	    		jQuery("#ExpSignFilePath").val("");
	    	}
	    	if(!jQuery("#ExpSignFileFlag").attr("checked")){
	    		jQuery("#ExpSignFilePath").val("");
	    	}
			if(!jQuery("#ExpWorkflowRemarkFileFlag").attr("checked") && !jQuery("#ExpWorkflowFileFlag").attr("checked")){
				jQuery("#ExpWorkflowFilePath").val("");
			}
    	}else{
    		jQuery("#ExpWorkflowInfoPath").val("");
    		jQuery("#ExpSignFilePath").val("");
    		jQuery("#ExpSignFilePath").val("");
    		jQuery("#ExpWorkflowFilePath").val("");
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
	
}

function onChangeTypeFun(obj){
	
}
function changeParamValue(obj)
{

  var ch=obj.checked;
  var name=$(obj).attr("name");
   if(name=="tempdtisdoctype"||name=="tempmainisdoctype"){  //文档类型
    var type= $(obj).closest("tr").find("input[type=hidden]").eq(2).val();
    if(type!="varchar"&&type!="varchar2"){
     $(obj).trigger("checked",false);
	 $(obj).val("0");
	 $(obj).closest("td").find("input").eq(1).val("0");
	 alert("<%=SystemEnv.getHtmlLabelName(125742 ,user.getLanguage())%>");//文档类型字段类型不匹配！
	 return ;
    }
  
  }
  if(name=="tempdtisdocname"||name=="tempmainisdocname"){  //文档名称
    var type= $(obj).closest("tr").find("input[type=hidden]").eq(2).val();
    if(type!="varchar"&&type!="varchar2"){
     $(obj).trigger("checked",false);
	 $(obj).val("0");
	 $(obj).closest("td").find("input").eq(1).val("0");
	 alert("<%=SystemEnv.getHtmlLabelName(125743 ,user.getLanguage())%>");//文档名称字段类型不匹配！
	 return ;
    }
  
  }
   if(name=="tempdtisdoc"||name=="tempmainisdoc"){  //文档
     var fst=$("#FileSaveType").val();
   
     var type= $(obj).closest("tr").find("input[type=hidden]").eq(2).val();
     if(fst=="0"||fst=="1"){
      if(type!="varchar"&&type!="varchar2"){
     $(obj).trigger("checked",false);
	 $(obj).val("0");
	 $(obj).closest("td").find("input").eq(1).val("0");
	 alert("<%=SystemEnv.getHtmlLabelName(125744 ,user.getLanguage())%>");//文档字段类型不匹配！
	 return ;
    }
   }else if(fst=="2"){
     if(type!="image"&&type!="blob"&&type!="longvarbinary"){
     $(obj).trigger("checked",false);
	 $(obj).val("0");
	 $(obj).closest("td").find("input").eq(1).val("0");
	 alert("<%=SystemEnv.getHtmlLabelName(125744 ,user.getLanguage())%>");//文档字段类型不匹配！
	 return ;
    }
   }

  }
  
  //纵向
var os=$("input[name="+name+"]");
 for(var i=0;i<os.length;i++){

  $(os.eq(i)).trigger("checked",false);
  $(os.eq(i)).val("0");
  $(os.eq(i)).closest("td").find("input").eq(1).val("0");
 }
 
 //横向
 var os1=$(obj).closest("tr").find("input[type=checkbox]");
 for(var i=1;i<os1.length;i++){////QC 286808 [80][90]流程归档集成-注册数据库方案页面，勾选全选会选中所有check框

  $(os1.eq(i)).trigger("checked",false);
  $(os1.eq(i)).val("0");
  $(os1.eq(i)).closest("td").find("input").eq(1).val("0");
 }
 
 
	if(ch){
	   $(obj).trigger("checked",true);
		$(obj).val("1");
		$(obj).closest("td").find("input").eq(1).val("1");
	}	
	else
	{
	 $(obj).trigger("checked",false);
	 $(obj).val("0");
	 $(obj).closest("td").find("input").eq(1).val("0");
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

function addRow(v)
{
	if("mainFields" == v)
	{
	   
		group.addRow(null);
	} else if("detailFields" == v) {
		group_dt.addRow(null);
	} else if("departmentfield" == v){
		group_def.addRow(null);
	}else {
		group.addRow(null);
	}
}
function removeRow(v)
{

        if("mainFields" == v)
		{
			var count = 0;//删除数据选中个数
			jQuery("#"+v+" input[name='mainparamid']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
			});
	
			if(count==0){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
			}else{
				group.deleteRows();
			}
		} else if("detailFields" == v) {
			var count = 0;//删除数据选中个数
			jQuery("#"+v+" input[name='dtparamid']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
			});
	
			if(count==0){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
			}else{
				group_dt.deleteRows();
			}
			
		} 
	
}

var mailTableOptions="";
var detailTableOptions="";
var mailTableFiledNames="";
var mailTableFiledTypes="";
var detailTableFiledNames="";
var detailTableFiledTypes="";
var mainTalbeName="";
var	detailTableName="";
function changeRegitDBId(str)
{


 var temp=jQuery("#regitDBId").val();
 var s=$("#FileSaveType").val();
 if(s=='2'){
 jQuery("#regitType").val(temp);
  //解绑，绑定
	jQuery("#regitType").selectbox("detach");
 	__jNiceNamespace__.beautySelect("#regitType");
 }
  if(temp!=null&&temp!=''){
   $.ajax({ 
        	type:"POST",
            url: "/integration/exp/ExpIniDBProFields.jsp",
             data:{dbProid:temp},
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
            
            var datas=data.split("#");
            if(datas.length>7){
             mailTableOptions=datas[0];
             detailTableOptions=datas[1];
             mailTableFiledNames=datas[2];
             mailTableFiledTypes=datas[3];
             detailTableFiledNames=datas[4];
             detailTableFiledTypes=datas[5];
             mainTalbeName=datas[6];
             detailTableName=datas[7];
            
             }
             }
         });
         
    //更改文档归档目标
    
   $("#expTableType option").remove();
   if(mainTalbeName!=null&&mainTalbeName!=""){
  	$("#expTableType").append("<option value=\"0\"><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>");	//主表
   }
   if(detailTableName!=null&&detailTableName!=""){
   	$("#expTableType").append("<option value=\"1\"><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>");//明细表
  	 showGroup("detailgroupview");
   }else{
     hideGroup("detailgroupview");
   }
 //解绑，绑定
	jQuery("#expTableType").selectbox("detach");
 	__jNiceNamespace__.beautySelect("#expTableType");
 	
 	if(str!="true"){
    changeexpTableType("");
    }
 
	   jQuery("#mainTableSpan").html(mainTalbeName);
	   jQuery("#dtTableSpan").html(detailTableName);
 }else{
 		jQuery("#mainTableSpan").html("");
		jQuery("#dtTableSpan").html("");
		$("#expTableType option").remove();
		$("#expTableType").append("<option value=\"0\"><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>");	//主表
			//解绑，绑定
		jQuery("#expTableType").selectbox("detach");
		__jNiceNamespace__.beautySelect("#expTableType");
		jQuery("#mainFields").empty();
		jQuery("#detailFields").empty();
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
        
       if(temp=='0'||temp=='1')
        {
         $("#filesavetypespan").html("<%=SystemEnv.getHtmlLabelName(125863,user.getLanguage())%>");//文件路径
          showEle("regitTypeView");
           showdetail1();
          showdetail($("#ExpWorkflowInfoFlag"),'ExpWorkflowInfoPathView');
          showdetail($("#ExpSignFileFlag"),'ExpSignFilePathView');
          
        }else if(temp=='2')
        {
         $("#filesavetypespan").html("<%=SystemEnv.getHtmlLabelName(125735,user.getLanguage())%>");//文件内容
         hideEle("regitTypeView");
        // alert($("#regitDBId").val());
         $("#regitType").val($("#regitDBId").val());
         
          hideEle("ExpWorkflowFilePathView");
          hideEle("ExpWorkflowInfoPathView");
         hideEle("ExpSignFilePathView");

         
        } 

}

function changeMainFieldValue(obj)
{
	var currentValue = jQuery(obj).val();
	if(currentValue != ''){
		var currentSbValue = jQuery(obj).attr("sb");
		var selectArray = jQuery("select[name='mainfieldName']");
		for(var i=0; i<selectArray.length; i++){
			var tempSbValue = jQuery(selectArray[i]).attr("sb");
			var tempValue = jQuery(selectArray[i]).val();
			
			if(tempSbValue!=currentSbValue && tempValue!=''){
				if(currentValue == tempValue){
					alert("<%=SystemEnv.getHtmlLabelName(128194,user.getLanguage()) %>");
					
					jQuery(obj).selectbox("change","");
					jQuery(obj).closest("td").next().find("input").val(maintyps[t]);
					jQuery(obj).closest("td").next().find("span").html(maintyps[t]);
					return;
				}
			}
		}
	}
	
 var mainNames=mailTableFiledNames.split(",");
 var maintyps=mailTableFiledTypes.split(",");
 var t=mainNames.indexOf($(obj).val());
 
  $(obj).closest("td").next().find("input").val(maintyps[t]);
  $(obj).closest("td").next().find("span").html(maintyps[t]);
 
}
function changeDetailFieldValue(obj)
{
	var currentValue = jQuery(obj).val();
	if(currentValue != ''){
		var currentSbValue = jQuery(obj).attr("sb");
		var selectArray = jQuery("select[name='dtfieldName']");
		for(var i=0; i<selectArray.length; i++){
			var tempSbValue = jQuery(selectArray[i]).attr("sb");
			var tempValue = jQuery(selectArray[i]).val();
			
			if(tempSbValue!=currentSbValue && tempValue!=''){
				if(currentValue == tempValue){
					alert("<%=SystemEnv.getHtmlLabelName(128194,user.getLanguage()) %>");
					
					jQuery(obj).selectbox("change","");
					jQuery(obj).closest("td").next().find("input").val(maintyps[t]);
					jQuery(obj).closest("td").next().find("span").html(maintyps[t]);
					return;
				}
			}
		}
	}

 var dtNames=detailTableFiledNames.split(",");
 var dtTyps=detailTableFiledTypes.split(",");
 var t=dtNames.indexOf($(obj).val());
 
  $(obj).closest("td").next().find("input").val(dtTyps[t]);
 $(obj).closest("td").next().find("span").html(dtTyps[t]);
 
}


function showdetail(obj,val, needToSkip) {
	if(needToSkip == null){
		needToSkip = false;
	}
	var FileSaveType = jQuery("#FileSaveType").val();
	
	if(!needToSkip || (FileSaveType!='2' && needToSkip)){
	  var checked = $(obj).attr("checked");
		if(checked){
			if(val != ''){
				var array = val.split(",");
				for(var i=0; i<array.length; i++){
					showEle(array[i]);
				}
			}
		} else {
			if(val != ''){
				var array = val.split(",");
				for(var i=0; i<array.length; i++){
					hideEle(array[i]);
				}
			}
		}
	}
}
function showdetail1() {
	var fileSaveType = jQuery("#FileSaveType").val();
	if(fileSaveType!=2){
	  var checked = $("#ExpWorkflowFileFlag").attr("checked");
	  var checked1 = $("#ExpWorkflowRemarkFileFlag").attr("checked");
		if(!checked&&!checked1){
			
			hideEle("ExpWorkflowFilePathView");
			
		} else {
			var temp=$("#FileSaveType").val();	
			if(temp=='0'||temp=='1'){
					showEle("ExpWorkflowFilePathView");
			}
		}
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
function changevalue(obj){
  var ck=obj.checked;
  if(ck){
  $(obj).val("1");
  }else{

   $(obj).val("0");
  }

}
function changeexpTableType(str){
	var tabletype=$("#expTableType").val();
	var regitDBId = jQuery("#regitDBId").val();
	if(tabletype=='0' && regitDBId==''){
		return false;
	}
var datamain="<%=tempajaxdata1%>";
var datadt="<%=tempajaxdata2%>";
 if(str!='true'){
 datamain='';
 datadt='';
 }
 
 var maincheckboxstatus='enabled';
  var dtcheckboxstatus='enabled';

  if(tabletype=='0'){
  maincheckboxstatus='enabled';
  dtcheckboxstatus='disabled';
  }else if(tabletype=='1'){
   maincheckboxstatus='disabled';
  dtcheckboxstatus='enabled';
  }
 
      
//var s1="文档数据保存字段：用于保存文档数据的，可以是文档路径（文本，varchar），或者是文档内容（二进制，sqlserver是image，oracle是blob）";
var s1 = "<%=SystemEnv.getHtmlLabelNames("125736,125737",user.getLanguage())%>";
var str1="<SPAN class='e8tips' id=remind title='"+s1+"'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>";
//var s2="文档类型字段：正文、附件、表单等类型，数据库类型为varchar";
var s2 = "<%=SystemEnv.getHtmlLabelName(125738,user.getLanguage())%>";
var str2="<class='e8tips' id=remind title='"+s2+"'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>";

//var s3="关联主表字段：用来关联主表数据与明细数据";
var s3="<%=SystemEnv.getHtmlLabelName(125739,user.getLanguage())%>";
var str3="<SPAN class='e8tips' id=remind title='"+s3+"'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>";
//var s4="文档名称字段：保存文档的名称，数据库类型为varchar";
var s4="<%=SystemEnv.getHtmlLabelName(125740,user.getLanguage())%>";
var str4="<SPAN class='e8tips' id=remind title='"+s4+"'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>";
    //字段名 字段类型 主键 文档 文档类型 关联主表 文档名称
	var testd2 = onShowDetailTableFieldValue();//QC284050
   var itemsdt=[
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>",itemhtml:"<span class='browser' _callback='onSetTableField' completeurl='/data.jsp?type=164' browserurl='"+ testd2 + "' isAutoComplete='false' isMustInput='1' hasInput='false' name='dtfieldName' isSingle='true'></span>"},//"<SELECT class='InputStyle' name=\"dtfieldName\" onchange='changeDetailFieldValue(this);'>"+detailTableOptions+"</SELECT>"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage())%>",itemhtml:"<span name='tempdtfieldtypespan'></span><INPUT  type='hidden' name='dtfieldtype'  value='' >"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(21027,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle dtiskey ' style='opacity: 0;'  type='checkbox'  name='tempdtiskey' value=0 onclick='changeParamValue(this);'><INPUT type='hidden' name='dtiskey' value='0'>"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>    "+str1,itemhtml:"<INPUT class='Inputstyle dtisdoc ' style='opacity: 0;'  type='checkbox'  name='tempdtisdoc' value=0 onclick='changeParamValue(this);' "+dtcheckboxstatus+"><INPUT type='hidden' name='dtisdoc' value='0'>"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(505,user.getLanguage())%>    "+str2,itemhtml:"<INPUT class='Inputstyle dtisdoctype ' style='opacity: 0;'  type='checkbox'  name='tempdtisdoctype' value=0 onclick='changeParamValue(this);' "+dtcheckboxstatus+"><INPUT type='hidden' name='dtisdoctype' value='0'>"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(125741,user.getLanguage())%>    "+str3,itemhtml:"<INPUT class='Inputstyle dtismainkey ' style='opacity: 0;'  type='checkbox'  name='tempdtismainkey' value=0 onclick='changeParamValue(this);' "+dtcheckboxstatus+"><INPUT type='hidden' name='dtismainkey' value='0'>"},
    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%>    "+str4,itemhtml:"<INPUT class='Inputstyle dtisdocname ' style='opacity: 0;'  type='checkbox'  name='tempdtisdocname' value=0 onclick='changeParamValue(this);' "+dtcheckboxstatus+"><INPUT type='hidden' name='dtisdocname' value='0'>"}];
  
var optiondt = {
    optionHeadDisplay:"none",
	navcolor:"#003399",
    basictitle:"",
    toolbarshow:false,
    colItems:itemsdt,
    addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
    deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
    usesimpledata:true,
    openindex:false,
    addrowCallBack:function() {
    },
    configCheckBox:true,
    checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='dtparamid'><INPUT type='hidden' name='dtparamids' value='-1'>","width":"6%"},
    initdatas:eval(datadt)
};
//字段名 字段类型 主键 文档 文档类型 文档名称
var testd1 = onShowTableFieldValue();//QC284050
var itemsmain=[
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>",itemhtml:"<span class='browser' _callback='onSetTableField' completeurl='/data.jsp?type=164' browserurl='"+ testd1 + "' isAutoComplete='false' isMustInput='1' hasInput='false' name='mainfieldName' isSingle='true'></span>"},//"<SELECT class='InputStyle' name=\"mainfieldName\" onchange='changeMainFieldValue(this);'>"+mailTableOptions+" </SELECT>"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage())%>",itemhtml:"<span name='tempfieldtypespan'></span><INPUT  type='hidden' name='mainfieldtype'  value='' >"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(21027,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle mainiskey ' style='opacity: 0;'  type='checkbox'  name='tempmainiskey' value='0' onclick='changeParamValue(this);'><INPUT type='hidden' name='mainiskey' value='0'>"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>    "+str1,itemhtml:"<INPUT class='Inputstyle mainisdoc ' style='opacity: 0;'  type='checkbox'  name='tempmainisdoc' value='0' onclick='changeParamValue(this);' "+maincheckboxstatus+"><INPUT type='hidden' name='mainisdoc' value='0'>"},
    {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(505,user.getLanguage())%>    "+str2,itemhtml:"<INPUT class='Inputstyle mainisdoctype ' style='opacity: 0;'  type='checkbox'  name='tempmainisdoctype' value='0' onclick='changeParamValue(this);' "+maincheckboxstatus+"><INPUT type='hidden' name='mainisdoctype' value='0'>"},
    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%>    "+str4,itemhtml:"<INPUT class='Inputstyle mainisdocname ' style='opacity: 0;'  type='checkbox'  name='tempmainisdocname' value='0' onclick='changeParamValue(this);' "+maincheckboxstatus+"><INPUT type='hidden' name='mainisdocname' value='0'>"}];


var optionmain = {
    optionHeadDisplay:"none",
	navcolor:"#003399",
    basictitle:"",
    toolbarshow:false,
    colItems:itemsmain,
    addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
    deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
    usesimpledata:true,
    openindex:false,
    addrowCallBack:function() {
    },
    configCheckBox:true,
    checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='mainparamid'><INPUT type='hidden' name='mainparamids' value='-1'>","width":"6%"},
    initdatas:eval(datamain)
};

   
    jQuery("#mainFields").empty();
	group=new WeaverEditTable(optionmain);
    jQuery("#mainFields").append(group.getContainer());
    var params=group.getTableSeriaData();

    jQuery("#detailFields").empty();
     group_dt=new WeaverEditTable(optiondt);
    jQuery("#detailFields").append(group_dt.getContainer());
    var params_dt=group_dt.getTableSeriaData();
    
    
 }
function onDelete(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>", function (){
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}, function () {}, 320, 90);
}

//新增 QC284050
function onShowTableFieldValue(obj){
    var dbProid = jQuery("#regitDBId").val();
    var dbprosetingid = '';
    var datasourceid = '';
    var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&needcheckds=1&datasourceid=" + datasourceid + "&dmlformid="+dbProid + "&dmlisdetail=" + dbprosetingid  + "&ajax=1&url=/integration/exp/ExpTableFieldsBrowser.jsp";
    //alert(urls);
    return urls;
}

function onShowDetailTableFieldValue(obj){
    var dbProid = jQuery("#regitDBId").val();
    var dbprosetingid = '';
    var datasourceid = '';
    var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&needcheckds=2&datasourceid=" + datasourceid + "&dmlformid="+dbProid + "&dmlisdetail=" + dbprosetingid  + "&ajax=1&url=/integration/exp/ExpTableFieldsBrowser.jsp";
    //alert(urls);
    return urls;
}
function onSetTableField(event,data,name,dmltype,tg)
{

    var fieldname;
    var fielddbtype;
    var iscanhandle;
    //Dialog.alert("dmltype : "+dmltype);
    var obj = null;
    //alert(typeof(tg)+"  event : "+event);
    if(typeof(tg)=='undefined'){
        obj= event.target || event.srcElement;
    }
    else
    {
        obj = tg;
    }
    if(data){
        if(data.id != ""){
            fieldname = data.id;
            fielddbtype = data.type;
            iscanhandle = data.a1;
        }else{
            fieldname = "";
            fielddbtype = "";
            iscanhandle = "";
        }
    }
    appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj);
}
function appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj)
{

    try{
        if(fieldname=="")
        {
            fieldname = "";
            fielddbtype = "";
            //return;
        }
        if(typeof(fieldname)=="undefined")
        {
            return;
        }
        //字段名
        var obj = obj.parentElement.parentElement.parentElement.parentElement.parentElement;
        obj = $(obj).closest("td");
        //alert(obj.outerHTML)
        //var objfield = obj.parentElement.nextSi bling;
        //objfield.value = fieldname;
        //字段类型
		var flag = judgeMainFieldValue(obj);
        if(!flag) return ;
        var nameTest = $(obj).find("input").attr("name");
        var nameTest1 = nameTest.substr(0,nameTest.length-4);
        var typespan = '';

        if("dtfield" == nameTest1) {
            typespan = "[name='" + "temp" + nameTest1 + "typespan" + "']";
        }
        if("mainfield" == nameTest1) {
            typespan =  "[name='" + "tempfield" + "typespan" + "']";
        }
        var type = "[name='"+ nameTest1 + "type"+"']";
        $(obj).next("td").find('"'+typespan+'"').text(fielddbtype);
        $(obj).next("td").find('"'+type+'"').val(fielddbtype);

    }catch(e){
        top.Dialog.alert(e);
    }
}
//新增 QC284050
function judgeMainFieldValue(obj)
{
    var flag = true;
    var currentValue = $(obj).find("input").val();
    var currentMainname = $(obj).find("input").attr("name");
    if(currentValue != ''){
        var currentName = $(obj).find("span[name='"+ currentMainname + "']").attr("id");
        var selectArray = jQuery("input[name='"+ currentMainname + "']");
        for(var i=0; i<selectArray.length; i++){
            var tempSbValue = jQuery(selectArray[i]).closest("td").find("span[name='"+ currentMainname + "']").attr("id");
            var tempValue = jQuery(selectArray[i]).val();
            if(tempSbValue!=currentName && tempValue!=''){
                if(currentValue == tempValue){
                    alert("<%=SystemEnv.getHtmlLabelName(128194,user.getLanguage()) %>");
                    $(obj).find("input").val("");
                    $(obj).find("input").next("span").find("a").text("");
                    jQuery(obj).selectbox("change","");
                    flag =false;
                    return flag;
                }
            }
        }
        return flag;
    }

}

</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
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
