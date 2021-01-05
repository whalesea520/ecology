
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />


<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
	</HEAD>
<%

	if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(30063,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	
    String Customname = "";
    String Customdesc = "";
	String modename = "";
	String id = Util.null2String(request.getParameter("id"),"0");
	String appid = Util.null2String(request.getParameter("appid"),"1");
	AppInfoService appInfoService = new AppInfoService();
	Map<String, Object> appInfo = new HashMap<String, Object>();
    appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
	String treelevel = Util.null2String(appInfo.get("treelevel"));
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	String sql = "select * from mode_custompage where id="+id;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
	    Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
	    appid = Util.null2String(RecordSet.getString("appid"));
	}
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_custompage a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	
	if(subCompanyId==-1){
	    appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
		subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	
%>
<%if(isrefresh.equals("1")){%>
<script type="text/javascript">
jQuery(function($){
	parent.parent.refreshCustomPage("<%=id%>");
});
</script>
<%}%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
		if(id.equals("0")){
			if(operatelevel>0&&!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
				RCMenuHeight += RCMenuHeightStep;
			}
		}else{
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0")&&!id.equals("0"))||fmdetachable.equals("1")&&!treelevel.equals("0")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>1){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82039,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建自定义页面
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createMenuNew(),_self} " ;//创建菜单
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;//预览
			RCMenuHeight += RCMenuHeightStep;
		}
		%>

		<FORM id=weaver name=frmMain action="/formmode/setup/customPageSettingsAction.jsp" method=post>
			<input type="hidden" name="appid" id="appid" value="<%=appid %>">
			<input type="hidden" name="operation" name="operation" value="saveorupdate">
			<input type="hidden" name="id" id="id" value="<%=id%>">

									<TABLE class="e8_tblForm">
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
									  	<TBODY>
                                            <TR>
									      		<TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
									          	<TD class="e8_tblForm_field">
									        		<INPUT type=text class=Inputstyle style="width:80%" name="Customname" onchange='checkinput("Customname","Customnameimage")' value="<%=Customname%>">
									          		<SPAN id=Customnameimage>
									          		<%if ("".equals(Customname)) { %>
													<img src="/images/BacoError_wev8.gif"/>
													<% } %></SPAN>
									          	</TD>
									        </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82040,user.getLanguage())%><!-- 说明自定义页面的用途 --></div></TD>
                                              <TD class="e8_tblForm_field">
                                                  <textarea  style="width:80%;height:50px;" name="Customdesc" class=Inputstyle><%=Customdesc%></textarea>
                                              </TD>
                                            </TR>  
									 	</TBODY>
									</TABLE>
	
  									<BR>

									<TABLE class="e8_tblForm">
						        		<TBODY>
									        <TR class=title>
									        <td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(82041,user.getLanguage())%><!-- 自定义页面属性 --></td>
									        <td id="btnTD" align=right>
<%if(operatelevel>0){%>
	<button
		type="button"
		title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" 
		class="addbtn2" 
		onclick="addRow()"></button><!-- 添加 -->
<%} %>
									            
<%if(operatelevel>1){%>
	<button 
		type="button"
		title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" 
		class="deletebtn2" 
		onclick="attrdelrow()"></button><!-- 删除 -->
<%} %>									            

												</td>
											</TR>
						        			<tr>
										        <td colspan=2>
													<table class="e8_tblForm" id="oTable" style="margin-top: 5px;">
											            <COLGROUP>
												    		<COL width="5%">
												    		<COL width="20%">
												    		<COL width="20%">
												    		<COL width="20%">
												    		<COL width="20%">
												    		<COL width="15%">
											    		</COLGROUP>
											    		<tr class="header" >
											    		   <th><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></th>
											    		   <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th><!-- 名称 -->
														   <th><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%></th><!-- 提示信息 -->
											    		   <th><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></th><!-- 链接地址 -->
														   <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th><!-- 描述 -->
														   <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th><!-- 显示顺序 -->
											    		</tr>
											    		<%
											    			int rowno =0;
											    			String needcheck = "";
											    			sql = "select * from mode_custompagedetail where mainid = "+id+" order by disorder asc,id asc ";
											    			rs.executeSql(sql);
											    			while(rs.next()){
											    				String detailid = Util.null2String(rs.getString("id"));
											    		    	String hrefname = Util.null2String(rs.getString("hrefname"));
											    		    	String hreftitle = Util.null2String(rs.getString("hreftitle"));
											    		    	String hrefdesc = Util.null2String(rs.getString("hrefdesc"));
											    		    	String hrefaddress = Util.null2String(rs.getString("hrefaddress"));
											    		    	double disorder = Util.getDoubleValue(rs.getString("disorder"),0);
											    		    	needcheck += ",hrefname_"+rowno+",hrefaddress_"+rowno;
											    		%>
											    				<tr>
											    					<td><input type="checkbox" id="check_node" name="check_node"></td>
											    					<td>
											    						<input class=inputstyle type='text' maxlength='400' name='hrefname_<%=rowno%>' id='hrefname_<%=rowno%>' value='<%=hrefname%>' onchange='checkinput("hrefname_<%=rowno%>","hrefname_<%=rowno%>span")'>
											    						<span id="hrefname_<%=rowno%>span"></span>
											    					</td>
											    					<td><input class=inputstyle type='text' maxlength='400' name='hreftitle_<%=rowno%>' id='hreftitle_<%=rowno%>' value='<%=hreftitle%>'></td>
											    					<td>
											    						<input class=inputstyle type='text' maxlength='400' name='hrefaddress_<%=rowno%>' id='hrefaddress_<%=rowno%>' value="<%=hrefaddress%>" onchange='checkinput("hrefaddress_<%=rowno%>","hrefaddress_<%=rowno%>span")'>
											    						<span id="hrefaddress_<%=rowno%>span"></span>
											    					</td>
											    					<td><input class=inputstyle type='text' maxlength='400' name='hrefdesc_<%=rowno%>' id='hrefdesc_<%=rowno%>' value='<%=hrefdesc%>'></td>
											    					<td><input class=inputstyle type='text' maxlength='400' name='disorder_<%=rowno%>' id='disorder_<%=rowno%>' value='<%=disorder%>' size="5"></td>
											    				</tr>
											    		<%		
											    				rowno++;
											    			}
											    		%>
													</table>
										        </td>
									        </tr>
						        		</TBODY>
									</TABLE>  		
									<input type="hidden" id="needcheck" name="needcheck" value="<%=needcheck%>">
									<input type="hidden" id="rowno" name="rowno" value="<%=rowno%>">

			</FORM>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<BR>

<script language="javascript">
function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		enableAllmenu();
		document.frmMain.operation.value="customdelete";
		document.frmMain.submit();
	});
}
function createmenu(){
	var url = "/formmode/custompage/CustomPageData.jsp?id=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function submitData()
{
	var checkfields = 'Customname' + $("#needcheck").val();
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
        frmMain.submit();
    }
}
function doback(){
	enableAllmenu();
	location.href="/formmode/custompage/CustomList.jsp";
}

function doAdd(){
	parent.location.href = "/formmode/setup/customPageInfo.jsp?id=&appid=<%=appid%>";
}

function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("");
		}
	} 
}
var rowColor="" ;
rowindex = "<%=rowno%>";
function addRow()
{
	rowColor = getRowBg();
	oRow = oTable.insertRow(-1);
	
	for(j=0; j<6; j++) {//6列数据
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		//oCell.style.background= rowColor;
		oCell.style.wordBreak = "break-all";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node'>"; 
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='text' maxlength='400' name='hrefname_"+rowindex+"' id='hrefname_"+rowindex+"' onchange='checkinput(\"hrefname_"+rowindex+"\",\"hrefname_"+rowindex+"span\")'>";
					sHtml += "<span id='hrefname_"+rowindex+"span'><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				$("#needcheck").val($("#needcheck").val() + "," + "hrefname_"+rowindex+"");
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='text' maxlength='400' name='hreftitle_"+rowindex+"' id='hreftitle_"+rowindex+"'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='text' maxlength='2000' name='hrefaddress_"+rowindex+"' id='hrefaddress_"+rowindex+"' onchange='checkinput(\"hrefaddress_"+rowindex+"\",\"hrefaddress_"+rowindex+"span\")'>";
					sHtml += "<span id='hrefaddress_"+rowindex+"span'><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				$("#needcheck").val($("#needcheck").val() + "," + "hrefaddress_"+rowindex+"");
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='text' maxlength='400' name='hrefdesc_"+rowindex+"' id='hrefdesc_"+rowindex+"'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
			case 5:
				var max = getMaxNo();
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='text' maxlength='10' name='disorder_"+rowindex+"' id='disorder_"+rowindex+"' onKeyPress='ItemDecimal_KeyPress(this.name,15,2)' onBlur='checknumber1(this);' size='5' value="+max+">";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
		}
	}
	rowindex = rowindex*1 +1;
	$("#rowno").val(rowindex);
	jQuery("#oTable").jNice();
}

function delRow()
{
	var len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	/**
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			rowsum1 += 1;
		}
	}
	**/
	rowsum1 = $("input[name='check_node']").length + 1; 
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	}	
}

function attrdelrow(){
	var len = document.forms[0].elements.length;
	var i=0;
	var delnum = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				delnum +=1;
			}
		}
	}
	if(delnum<1){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
    }else{
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
				var len = document.forms[0].elements.length;
				var i=0;
				var rowsum1 = 1;
				/**
				for(i=len-1; i >= 0;i--) {
					if (document.forms[0].elements[i].name=='check_node'){
						rowsum1 += 1;
					}
				}
				**/
				rowsum1 = $("input[name='check_node']").length + 1; 
				for(i=len-1; i >= 0;i--) {
					if (document.forms[0].elements[i].name=='check_node'){
						if(document.forms[0].elements[i].checked==true) {
							oTable.deleteRow(rowsum1-1);	
						}
						rowsum1 -=1;
					}
				}
		});	
	}
}
function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	 var chks = document.getElementsByName("check_node"); 
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }  
}
function changeCbox(objspan){
	var objbox = $(objspan).find(".jNiceHidden");
	changeCheckboxStatus(objbox.get(0), !objbox.get(0).checked);
}
function getMaxNo(){
	var max = 0;
	$("input[name^='disorder_']").each(function(){
		var temp = $(this).val() * 1.0
		if(temp>max){
			max = temp;
		}
	});

	try{
		var temp = parseFloat(max.toFixed(0));
		if(temp == max){
			max = max + 1;
		}else if(temp<max){
			max = temp + 1;
		}else{
			max = temp;
		}
	}catch(e){
		max = max + 1;
	}
	
	return max;
}

function onPreview(){
	var url = "/formmode/custompage/CustomPageData.jsp?id=<%=id%>";
	window.open(url);
}
function createMenuNew(){
	var url = "/formmode/custompage/CustomPageData.jsp?id=<%=id%>";
	var parmes = escape(url);
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Width = 350;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(23033,user.getLanguage())%>";
	diag_vote.URL = "/formmode/setup/modelMenuAdd.jsp?dialog=1&isFromMode=1&parmes="+parmes;
	diag_vote.isIframe=false;
	diag_vote.show();
}
</script>
</BODY></HTML>
