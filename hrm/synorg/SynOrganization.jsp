
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.file.*," %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
	</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(31151, user.getLanguage());
    String needfav = "";
    String needhelp = "";
    
    String flag = Util.null2String(request.getParameter("flag"));
    String msg = Util.null2String((String)session.getAttribute(flag));
	
	boolean isoracle = rs.getDBType().equals("oracle");
	ExcelSheet es = null;
	ExcelFile.init() ;
	ExcelFile.setFilename(SystemEnv.getHtmlLabelName(31152, user.getLanguage())) ;
	ExcelStyle ess = ExcelFile.newExcelStyle("Header") ;
	ess.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
	ess.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
	ess.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
	ess.setAlign(ExcelStyle.WeaverHeaderAlign) ;
	
	String sql = "select id,tablename,datakey from Syn_Organization order by id asc";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String tablename = Util.null2String(RecordSet.getString("tablename")).toLowerCase();
		String datakey = Util.null2String(RecordSet.getString("datakey")).toLowerCase();
		if(isoracle){//oracle
			sql = "select COLUMN_NAME name,data_type type from user_tab_columns where upper(table_name)=upper('" + tablename + "') ORDER BY COLUMN_ID asc";
		}else{
			sql = "select c.name name,t.name type from sysobjects o,syscolumns c,systypes t where c.xtype=t.xusertype and o.id=c.id and upper(o.name)=upper('"+tablename+"') order by c.colid asc";
		}
		rs.executeSql(sql);
		String columnnames[] = new String[rs.getCounts()];
		String columntypes[] = new String[rs.getCounts()];
		int  index = 0;
		while(rs.next()){
			String columnname = Util.null2String(rs.getString("name")).toLowerCase();
			String colunmtype = Util.null2String(rs.getString("type")).toLowerCase();
			columnnames[index] = columnname;
			columntypes[index++] = colunmtype;
		}
		
	    es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
	    ExcelRow er = es.newExcelRow () ;
	    for(int i=0;i<columnnames.length;i++){
	        String columnname = Util.null2String(columnnames[i]);
	        String colunmtype = Util.null2String(columntypes[i]);
	        er.addStringValue(columnname+"|"+colunmtype,"Header");
	        es.addExcelRow(er);//加入一行
	    }
		sql = "select * from "+tablename;
		if(!datakey.equals("")){
			sql += " order by " + datakey + " asc ";
		}
		rs.executeSql(sql);
		while(rs.next()){
			er = es.newExcelRow () ;
			for(int i=0;i<columnnames.length;i++){
				String columnname = Util.null2String(columnnames[i]);
	    		String columnvalue = Util.null2String(rs.getString(columnname));
	            er.addStringValue(columnvalue);
			}
	        es.addExcelRow(er);//加入一行
		}
		ExcelFile.addSheet(tablename, es); //为EXCEL文件插入一个SHEET
	}

%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    //RCMenu += "{导出组织结构,javascript:onSave(this),_self} ";
    //RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<!-- 数据导入中，请稍等... -->
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(31153, user.getLanguage())%></span>
</div>

<div id="content">
	<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	</colgroup>
	<tr>
	    <td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
						<form name="detailimportform" method="post" action="/hrm/synorg/SynOrganizationOperation.jsp" enctype="multipart/form-data">
							<TABLE class=viewform cellspacing=1 id="freewfoTable" width="100%">
								<colgroup>
								    <col width="20%">
								    <col width="80%">
							    </colgroup>
								<TBODY>
									<TR>
									    <TD colspan="2"><b><%=SystemEnv.getHtmlLabelName(31154, user.getLanguage())%></b></TD>
									</TR>
									<TR class="Spacing">
									    <TD class="Line1" colspan="2"></TD>
									</TR>
									<TR>
									    <TD><%=SystemEnv.getHtmlLabelName(31154, user.getLanguage())%></TD>
									    <TD class="Field"><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=SystemEnv.getHtmlLabelName(31156, user.getLanguage())%></a></TD>
									</TR>
									<TR class="Spacing">
									    <TD class="Line" colspan="2"></TD>
									</TR>
									
									<TR>
									    <TD colspan="2"><b><%=SystemEnv.getHtmlLabelName(31155, user.getLanguage())%></b></TD>
									</TR>
									<TR class="Spacing">
									    <TD class="Line1" colspan="2"></TD>
									</TR>
									<TR>
									    <TD><%=SystemEnv.getHtmlLabelName(16630, user.getLanguage())%></TD>
									    <TD class="Field"><input type="file" name="excelfile" size="35"></TD>
									</TR>
									<TR class="Spacing">
									    <TD class="Line" colspan="2"></TD>
									</TR>
									<tr>
										<td>
											<!-- 导入 -->
											<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>
										</td>
										<td class=Field>
											<button type=BUTTON  class=btnSave onclick="onSave(this);" title="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>">
												<!-- 开始导入-->
												<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>
											</button>
										</td>
									</tr>
									<TR class=Spacing style="height:1px;">
										<TD class=Line colSpan=2></TD>
									</TR>
									<%
										if(!msg.equals("")) {
									%>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%></td>
												<td><font color="red"><%=msg.replace("\\n", "<br>") %></font></td>
											</tr>
											<TR class="Spacing">
											    <TD class="Line" colspan="2"></TD>
											</TR>
									<%
										}
									%>
									<TR>
									    <TD colspan="2">
									        <br><b><%=SystemEnv.getHtmlLabelName(19010, user.getLanguage())%>：</b><br>
									        1、<%=SystemEnv.getHtmlLabelName(31157, user.getLanguage())%><br>
											2、<%=SystemEnv.getHtmlLabelName(31158, user.getLanguage())%><br>
									        <b><%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%></b><br>
									        1、<font color="red"><b><%=SystemEnv.getHtmlLabelName(31159, user.getLanguage())%></b></font><br>
									        2、<%=SystemEnv.getHtmlLabelName(31160, user.getLanguage())%><br>
									        3、<%=SystemEnv.getHtmlLabelName(31161, user.getLanguage())%><br>
									        4、<%=SystemEnv.getHtmlLabelName(31162, user.getLanguage())%><br>
									    </TD>
									</TR>
								</TBODY>
							</TABLE>
						</form>
					</td>
				</tr>
			</TABLE>
		</td>
		<td></td>
	</tr>
	<tr>
	    <td height="10" colspan="3"></td>
	</tr>
	</table>
</div>

<script language=javascript>
	$(document).ready(function(){//onload事件
		$("#loading").hide(); //隐藏加载图片
	});

    function onSave(obj) {
        if(confirm("<%=SystemEnv.getHtmlLabelName(31163,user.getLanguage())%>")){
	        var fileName=$G("excelfile").value;
			if(fileName!=""&&fileName.length>4){
				if(fileName.substring(fileName.length-4).toLowerCase()!=".xls"){
					alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
					return;
				}
				jQuery("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%>");
				jQuery("#loading").show();
				jQuery("#content").hide();
				$G("detailimportform").submit();//上传文件
	            obj.disabled=true;
			}else{
	            alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
	        }
        }
    }
</script>
</body>
</html>
