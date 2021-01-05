
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

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
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<script language="JavaScript" src="/js/addRowBg_wev8.js"></script> 
	</HEAD>
<%

	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(30063,user.getLanguage());//自定义页面设置
	String needfav ="1";
	String needhelp ="";

	
    String Customname = "";
    String Customdesc = "";
	
	String id = Util.null2String(request.getParameter("id"));
	String sql = "select * from mode_custompage where id="+id;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
	    Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
	}
%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createmenu(),_self} " ;//创建菜单
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;//返回
			RCMenuHeight += RCMenuHeightStep;
		%>

		<FORM id=weaver name=frmMain action="/formmode/custompage/CustomPageOperation.jsp" method=post>
			<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<COLGROUP>
					<COL width="10">
					<COL width="">
					<COL width="10">
				<TR>
					<TD height="10" colspan="3"></TD>
				</TR>
				<TR>
					<TD ></TD>
					<TD valign="top">
						<input type="hidden" name="operation" name="operation" value="customedit">
						<input type="hidden" name="id" id="id" value="<%=id%>">
						<TABLE class=Shadow>
							<TR>
								<TD valign="top">
									<TABLE class="viewform">
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
									  	<TBODY>
			        						        
									        <TR class="Spacing" style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
									          	<TD class=Field>
									        		<INPUT type=text class=Inputstyle size=30 name="Customname" onchange='checkinput("Customname","Customnameimage")' value="<%=Customname%>">
									          		<SPAN id=Customnameimage></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><!-- 描述 -->
                                              <TD class=Field>
                                                  <textarea rows="4" cols="80" name="Customdesc" class=Inputstyle><%=Customdesc%></textarea>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
									 	</TBODY>
									</TABLE>
	
  									<BR>

									<TABLE class=viewForm>
						        		<TBODY>
									        <TR class=title>
									            <td  colspan=2 align=right>
													<A href="javascript:addRow();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A><!-- 添加 -->
													<A href="javascript:if(isdel()){delRow();}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	<!-- 删除 -->
												</td>
											</TR>
						        			<TR class=spacing style="height:1px;"><TD class=line1 colspan=2></TD></TR>
						        			<tr>
										        <td colspan=2>
													<table class=liststyle cellspacing=1 id="oTable">
											            <COLGROUP>
												    		<COL width="5%">
												    		<COL width="20%">
												    		<COL width="20%">
												    		<COL width="20%">
												    		<COL width="20%">
												    		<COL width="15%">
											    		</COLGROUP>
											    		<tr class="header">
											    		   <td><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></td>
											    		   <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
														   <td><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%></td><!-- 提示信息 -->
											    		   <td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></td><!-- 链接地址 -->
														   <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td><!-- 描述 -->
														   <td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td><!-- 显示顺序 -->
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
											    						<input class=inputstyle type='text' maxlength='400' name='hrefname_<%=rowno%>' id='hrefname_<%=rowno%>' value="<%=hrefname%>" onchange='checkinput("hrefname_<%=rowno%>","hrefname_<%=rowno%>span")'>
											    						<span id="hrefname_<%=rowno%>span"></span>
											    					</td>
											    					<td><input class=inputstyle type='text' maxlength='400' name='hreftitle_<%=rowno%>' id='hreftitle_<%=rowno%>' value="<%=hreftitle%>"></td>
											    					<td>
											    						<input class=inputstyle type='text' maxlength='400' name='hrefaddress_<%=rowno%>' id='hrefaddress_<%=rowno%>' value="<%=hrefaddress%>" onchange='checkinput("hrefaddress_<%=rowno%>","hrefaddress_<%=rowno%>span")'>
											    						<span id="hrefaddress_<%=rowno%>span"></span>
											    					</td>
											    					<td><input class=inputstyle type='text' maxlength='400' name='hrefdesc_<%=rowno%>' id='hrefdesc_<%=rowno%>' value="<%=hrefdesc%>"></td>
											    					<td><input class=inputstyle type='text' maxlength='400' name='disorder_<%=rowno%>' id='disorder_<%=rowno%>' value="<%=disorder%>" size="5"></td>
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
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD></TD>
				</TR>
				<TR>
					<TD height="10" colspan="3"></TD>
				</TR>
			</TABLE>
			</FORM>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<BR>

<script language="javascript">
function onDelete(){
	if(isdel()) {
        enableAllmenu();
        document.frmMain.action="/formmode/custompage/CustomPageOperation.jsp";
		document.frmMain.operation.value="customdelete";
		document.frmMain.submit();
	}
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
		oCell.style.background= rowColor;
		oCell.style.wordBreak = "break-all";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' id='check_node' name='check_node' value='0'>"; 
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

function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	$("input[name='check_node']").attr("checked",obj.checked);
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
</script>
</BODY></HTML>
