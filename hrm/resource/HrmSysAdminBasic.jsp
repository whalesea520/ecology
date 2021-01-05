
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SystemLogItemTypeComInfo" class="weaver.systeminfo.SystemLogItemTypeComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%!
private Hashtable<Integer,Integer> gethtItemTypeNum(String startdate, String startdateto, String userid, String qname) throws Exception{
	weaver.conn.RecordSet RecordSet = new RecordSet();
	Hashtable<Integer,Integer> htItemTypeNum = new Hashtable<Integer,Integer>();
	
	String sqlWhere = " and operateuserid = "+userid;
	if(!"".equals(startdate)){
		sqlWhere += " and SysMaintenanceLog.operatedate >= '"+startdate+"'"; 
	}
	
	if(!"".equals(startdateto)){
		sqlWhere += " and SysMaintenanceLog.operatedate <= '"+startdateto+"'"; 
	}
	
	if(!qname.equals("")){
		sqlWhere += " and relatedName like '%"+qname+"%'";
	}	
	
	RecordSet.executeSql(" SELECT SystemLogItem.typeid, COUNT(*) num FROM SysMaintenanceLog , SystemLogItem" 
											+" WHERE SysMaintenanceLog.operateitem = SystemLogItem.itemid"
											+" AND SystemLogItem.typeid is not null and SystemLogItem.itemid != 60 "
											+sqlWhere
											+" GROUP BY SystemLogItem.typeid");

	while(RecordSet.next()){
		htItemTypeNum.put(RecordSet.getInt("typeid"),RecordSet.getInt("num"));
	}
	
	RecordSet.executeSql(" SELECT COUNT(*) num FROM SysMaintenanceLog , SystemLogItem" 
											+" WHERE SysMaintenanceLog.operateitem = SystemLogItem.itemid"
											+" and SystemLogItem.itemid != 60"
											+sqlWhere
											+" AND SystemLogItem.typeid is null ");

	if(RecordSet.next()){
		htItemTypeNum.put(-1,RecordSet.getInt("num"));
	}
	return htItemTypeNum;
}
%>

<%
//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
int userid=user.getUID();
String sqlUid = "select count(*) cnt from HrmResourceManager where id="+userid;
rs.executeSql(sqlUid);
if(!rs.next() || rs.getInt("cnt") <= 0){
   response.sendRedirect("/notice/noright.jsp");	
   return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(803,user.getLanguage());
String needfav ="1";
String needhelp ="";

String typeid = Util.null2String(request.getParameter("typeid"));

String qname = Util.null2String(request.getParameter("flowTitle"));

int perpage=Util.getIntValue(request.getParameter("perpage"),0);
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}

if(perpage<=1 )	perpage=10;

String type = Util.null2String(request.getParameter("type"));
String startdate = Util.null2String(request.getParameter("startdate"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
if(!type.equals("") && !type.equals("0") && !type.equals("6")){
	startdate = TimeUtil.getDateByOption(type,"0");
	startdateto = TimeUtil.getDateByOption(type,"1");
}
/*
7	流程			流程维护		
1	文档			文档维护	
2	人力资源	人力资源
11	客户			客户维护		
10	项目			项目维护		
5	资产			资产维护
4	财务			财务
8	协作			协作维护
-1	其他			其他	
*/
Hashtable<Integer,Integer> htItemTypeNum = gethtItemTypeNum(startdate,startdateto,""+user.getUID(), qname);
String id = Util.null2String(request.getParameter("id"));
if(id.length()==0)id=""+user.getUID();
rs.executeSql("select lastname from HrmResourceManager where id="+id);

String lastname = "";
if(rs.next()){
	lastname = rs.getString("lastname");
}

if(lastname.length()==0){
	
}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var common = new MFCommon();
try{
	parent.setTabObjName("<%=lastname%>");
}catch(e){
	if(window.console)console.log(e+"-->HrmSysAdminBasic.jsp");
}
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function jsOnTypeIdChange(typeid){
	jQuery("#typeid").val(typeid);
		jQuery("#searchfrm").submit();
}

function doSet(){
	common.showDialog("/hrm/HrmDialogTab.jsp?_fromURL=sysadminSet&id=<%=userid%>", "<%=SystemEnv.getHtmlLabelNames("1507,32496",user.getLanguage())%>");
}

</script>
</HEAD>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" action="HrmSysAdminBasic.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" onclick="doSet();" value="<%=SystemEnv.getHtmlLabelName(32496, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></wea:item>
			<wea:item>
				<select name="type" id="type" onchange="changeDate(this,'spanStartdate');" style="width: 135px">
      		<option value="0" <%=type.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=type.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=type.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=type.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=type.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=type.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=type.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       	<span id=spanStartdate style="<%=type.equals("6")?"":"display:none;" %>">
      		<BUTTON type="button" class=Calendar id=selectstartdate onclick="getDate('startdatespan','startdate')"></BUTTON>
       		<SPAN id=startdatespan ><%=startdate%></SPAN>－
       		<BUTTON type="button" class=Calendar id=selectstartdateto onclick="getDate('startdatetospan','startdateto')"></BUTTON>
       		<SPAN id=startdatetospan ><%=startdateto%></SPAN>
       	</span>
       	<input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>">
       	<input class=inputstyle type="hidden" id="startdateto" name="startdateto" value="<%=startdateto%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19049, user.getLanguage())%></wea:item>
			<wea:item>
				<select id="typeid" name="typeid">
					<option value=""><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
					<%
					SystemLogItemTypeComInfo.setTofirstRow();
					while(SystemLogItemTypeComInfo.next()){
					%>
					<option value="<%=SystemLogItemTypeComInfo.getSystemLogItemTypeId() %>" <%=typeid.equals(""+SystemLogItemTypeComInfo.getSystemLogItemTypeId())?"selected":"" %>><%=SystemEnv.getHtmlLabelName(SystemLogItemTypeComInfo.getSystemLogItemlabelid(),user.getLanguage()) %></option>
					<%} %>
				</select>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
</form>
<table style="width: 100%;height: 113px">
	<tr style="text-align: center;">
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_workflow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33259,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33259,user.getLanguage())%></td>
							</tr>
							<tr>
								<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_workflow" href="javascript:jsOnTypeIdChange(7)"><%=htItemTypeNum.get(7)==null?"0":htItemTypeNum.get(7) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_doc_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33260,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33260,user.getLanguage())%></td>
							</tr>
							<tr>
								<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_word"  href="javascript:jsOnTypeIdChange(1)"><%=htItemTypeNum.get(1)==null?"0":htItemTypeNum.get(1) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_hrmresource_wev8.png" title="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
							</tr>
							<tr>
								<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_custom"  href="javascript:jsOnTypeIdChange(2)"><%=htItemTypeNum.get(2)==null?"0":htItemTypeNum.get(2) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_custom_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33261,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33261,user.getLanguage())%></td>
							</tr>
							<tr>
								<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_project"  href="javascript:jsOnTypeIdChange(11)"><%=htItemTypeNum.get(11)==null?"0":htItemTypeNum.get(11) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_project_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33262,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33262,user.getLanguage())%></td>
							</tr>
							<tr>
								<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_cpt"  href="javascript:jsOnTypeIdChange(10)"><%=htItemTypeNum.get(10)==null?"0":htItemTypeNum.get(10) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_cpt_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33263,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33263,user.getLanguage())%></td>
							</tr>
							<tr>
								<td id="item_cowork" style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_cowork"  href="javascript:jsOnTypeIdChange(5)"><%=htItemTypeNum.get(5)==null?"0":htItemTypeNum.get(5) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_financial_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33274,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33274,user.getLanguage())%></td>
							</tr>
							<tr>
								<td id="item_weibo" style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_weibo"  href="javascript:jsOnTypeIdChange(4)"><%=htItemTypeNum.get(4)==null?"0":htItemTypeNum.get(4) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_cowork_wev8.png" title="<%=SystemEnv.getHtmlLabelName(33264,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(33264,user.getLanguage())%></td>
							</tr>
							<tr>
								<td id="item_weibo" style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_weibo"  href="javascript:jsOnTypeIdChange(8)"><%=htItemTypeNum.get(8)==null?"0":htItemTypeNum.get(8) %></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
		<td>
			<table style="width: 100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td style="text-align: right;"><img src="/images/hrm/sysadmin_other_wev8.png" title="<%=SystemEnv.getHtmlLabelName(20824,user.getLanguage())%>"></td>
					<td style="vertical-align: top;">
						<table style="border-collapse:collapse;border-spacing:0;">
							<tr>
								<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(20824,user.getLanguage())%></td>
							</tr>
							<tr>
								<td id="item_weibo" style="text-align: left;font-size: 16px;vertical-align: bottom;">
									<a id="item_weibo"  href="javascript:jsOnTypeIdChange(-1)"><%=htItemTypeNum.get(-1)==null?"0":htItemTypeNum.get(-1)%></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table style="width:100%;margin-top: -20px">
	<tr>
		<td style="border-bottom: 1px solid;border-color: #F3F2F2;">&nbsp;</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33258,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">	
			<%
			//时间		类型					项目					对象										客户端地址	
			String backfields = " id, operatedate, operateTime, operatetype, lableId, relatedName, clientaddress, typeid "; 
			String fromSql  = " from SysMaintenanceLog, SystemLogItem ";
			String sqlWhere = " where SysMaintenanceLog.operateItem = SystemLogItem.itemId and SystemLogItem.itemid != 60 ";
			String orderby = " operatedate " ;
			String tableString = " ";

			sqlWhere += " and operateuserid =  " + user.getUID();
			
			if(!qname.equals("")){
				sqlWhere += " and relatedName like '%"+qname+"%'";
			}		
			if (!"".equals(typeid)) { 
				if(typeid.equals("-1")){
					sqlWhere += " and SystemLogItem.typeid is null ";
				}else{
					sqlWhere += " and SystemLogItem.typeid = "+typeid;
				}
			}
			
			if(!"".equals(startdate)){
				sqlWhere += " and SysMaintenanceLog.operatedate >= '"+startdate+"'"; 
			}
			
			if(!"".equals(startdateto)){
				sqlWhere += " and SysMaintenanceLog.operatedate <= '"+startdateto+"'"; 
			}

			tableString =" <table instanceid=\"HrmSysAdminBasicTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
					"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"SysMaintenanceLog.id\" sqlsortway=\"desc\" />"+
			    "			<head>"+
			    "			<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(97, user.getLanguage())+"\" column=\"operateDate\" orderkey=\"operateDate\" otherpara=\"column:operateTime\" transmethod=\"weaver.splitepage.transform.SptmForCowork.combineDateTime\" />"+
			    "			<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("25037,63", user.getLanguage())+"\" column=\"operateType\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"operateType\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getTypeName\"/>"+
			    "			<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(33281, user.getLanguage())+"\" column=\"lableId\" orderkey=\"lableId\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getItemLableName\"/>"+
			    "			<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"relatedName\" orderkey=\"relatedName\"/>"+
			    "			<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(19049, user.getLanguage())+"\" column=\"typeid\" orderkey=\"typeid\" transmethod=\"weaver.systeminfo.SystemLogItemTypeComInfo.getSystemLogItemlabelname\" otherpara=\"" + user.getLanguage() + "\"/>"+
			    "			<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(108, user.getLanguage())+SystemEnv.getHtmlLabelName(110, user.getLanguage())+"\" orderkey=\"clientAddress\" column=\"clientAddress\"/>"+
			    "			</head>"+
			    " </table>";
			%>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
		</wea:item>
	</wea:group>
</wea:layout>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
