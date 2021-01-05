
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript>
	function onClose(returnValue){
		parent.getParentWindow(window).MainCallback();	
	}
</script>
</HEAD>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String name = Util.null2String(request.getParameter("name"));
	String sqlwhere = "";
	int useapprovewf = Util.getIntValue(request.getParameter("useapprovewf"), 0);
	int approvewf = Util.getIntValue(request.getParameter("approvewf"), 0);
	int remindtype = Util.getIntValue(request.getParameter("remindtype"), 0);
	int beforestart = Util.getIntValue(request.getParameter("beforestart"), 0);
	int beforestarttime = Util.getIntValue(request.getParameter("beforestarttime"), 0);
	int beforestarttype = Util.getIntValue(request.getParameter("beforestarttype"), 0);
	int beforestartper = Util.getIntValue(request.getParameter("beforestartper"), 0);
	int beforeend = Util.getIntValue(request.getParameter("beforeend"), 0);
	int beforeendtime = Util.getIntValue(request.getParameter("beforeendtime"), 0);
	int beforeendtype = Util.getIntValue(request.getParameter("beforeendtype"), 0);
	int beforeendper = Util.getIntValue(request.getParameter("beforeendper"), 0);
	String sql = "";
	String sql_delete = "";
	String sql_insert = "";
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	int usesettotype = Util.getIntValue(request.getParameter("usesettotype"), 0);
	String mothed = Util.null2String(request.getParameter("mothed"));
	ArrayList idList = new ArrayList();
	ArrayList nameList = new ArrayList();
	
	//System.out.println("method====="+mothed);
	if("save".equals(mothed)){
		String[] worktaskids = request.getParameterValues("worktaskid");
		for(int i=0; i<worktaskids.length; i++){
			int worktaskid = Util.getIntValue(worktaskids[i], 0);
			if(worktaskid == wtid){
				continue;
			}
			if(usesettotype == 0){//WorktaskFieldEdit
				sql_delete = "delete from worktask_taskfield where taskid="+worktaskid;
				sql_insert = "insert into worktask_taskfield (taskid, fieldid, crmname, isshow, isedit, ismand, orderid, defaultvalue, defaultvaluecn) select "+worktaskid+", fieldid, crmname, isshow, isedit, ismand, orderid, defaultvalue, defaultvaluecn from worktask_taskfield where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 1){//WorktaskListEdit
				sql_delete = "delete from worktask_tasklist where taskid="+worktaskid;
				sql_insert = "insert into worktask_tasklist (taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width, needorder) select "+worktaskid+", fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width, needorder from worktask_tasklist where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 2){//WorkTaskShareSet
				sql_delete = "delete from worktaskshareset where taskid="+worktaskid;
				sql_insert = "insert into worktaskshareset (taskid, taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) select "+worktaskid+", taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype from worktaskshareset where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 3){//worktaskCreateRight
				sql_delete = "delete from worktaskcreateshare where taskid="+worktaskid;
				sql_insert = "insert into worktaskcreateshare (taskid, sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser) select "+worktaskid+", sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser from worktaskcreateshare where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 4){//WTApproveWfEdit
				//sql_delete = "delete from worktaskcreateshare where taskid="+worktaskid;
				sql_insert = "update worktask_base set useapprovewf="+useapprovewf+", approvewf="+approvewf+" where id="+worktaskid;
				rs.execute(sql_insert);
			}else if(usesettotype == 5){//worktaskMonitorSet
				sql_delete = "delete from worktask_monitor where taskid="+worktaskid;
				sql_insert = "insert into worktask_monitor (taskid, monitor, monitortype) select "+worktaskid+", monitor, monitortype from worktask_monitor where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 6){//RemindedSet
				sql_insert = "update worktask_base set remindtype="+remindtype+", beforestart="+beforestart+", beforestarttime="+beforestarttime+", beforestarttype="+beforestarttype+", beforestartper="+beforestartper+", beforeend="+beforeend+", beforeendtime="+beforeendtime+", beforeendtype="+beforeendtype+", beforeendper="+beforeendper+" where id="+worktaskid;
				//System.out.println(sql_insert);
				rs.execute(sql_insert);
			}
			//System.out.println("sql_insert = " + sql_insert);
		}
%>
		<script language=javascript>
			onClose("1");	
		</script>

<%
	}else{
		
		sqlwhere = " isvalid=1 and id <>"+wtid;
		if(!name.equals("")){
				sqlwhere += " and name like '%";
				sqlwhere += Util.fromScreen2(name,user.getLanguage());
				sqlwhere += "%'";
		}

		sql = "select * from worktask_base where "+sqlwhere;
	}
//System.out.println(accessorString);
%>

<BODY>

<Form name="frmSearch" method="method" action="WorktaskList.jsp">
<input type="hidden" name="mothed" />
<input type="hidden" name="wtid" value="<%=wtid%>">
<input type="hidden" name="usesettotype" value="<%=usesettotype%>">
<input type="hidden" name="useapprovewf" value="<%=useapprovewf%>">
<input type="hidden" name="approvewf" value="<%=approvewf%>">
<input type="hidden" name="remindtype" value="<%=remindtype%>">
<input type="hidden" name="beforestart" value="<%=beforestart%>">
<input type="hidden" name="beforestarttime" value="<%=beforestarttime%>">
<input type="hidden" name="beforestarttype" value="<%=beforestarttype%>">
<input type="hidden" name="beforestartper" value="<%=beforestartper%>">
<input type="hidden" name="beforeend" value="<%=beforeend%>">
<input type="hidden" name="beforeendtime" value="<%=beforeendtime%>">
<input type="hidden" name="beforeendtype" value="<%=beforeendtype%>">
<input type="hidden" name="beforeendper" value="<%=beforeendper%>">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parentDialog.close(),_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(22321,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		    <span title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onSearch()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<wea:layout type="2col">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></wea:item>
	<wea:item> <input name='name' class='inputstyle' value='<%=name%>'></wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
  	<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<Table class='ListStyle' style="margin-bottom: 50px !important"> 
			<colgroup>
			<col width='10%'>
			<col width='90%'>
			<tr class="header">
				<td><input type="checkbox" class="inputstyle" id="allCheck" name="allCheck" value="1" onClick="checkAll()"></td>
				<td><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%></td>
			</tr>
			
			<%
				rs.execute(sql);
				while(rs.next()){
					String id = rs.getString("id");
					String namestr = rs.getString("name");
			%>
			<tr class="DataDark">
				<td ><input type="checkbox" class="inputstyle" name="worktaskid" value="<%=id%>"></td>
				<td><%=namestr%></td>
			</tr>
			<%
			  }
			%>
			</table>
	</wea:item>
  </wea:group>
    
  
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

</FORM>


</BODY>


<script language=javascript>



	function onSave(){
	     //判断有没有 选中需要应用的记录
	    var ids = "";
	    $("input[name='worktaskid']:checked").each(function(){
	       ids += $(this).val()+",";
	    });
		
		if(ids.length==0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83840,user.getLanguage())%>");
		 }else{		 
			 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83841,user.getLanguage())%>',function(){
		       	frmSearch.action="WorktaskList.jsp";
				frmSearch.mothed.value="save";
				frmSearch.submit();
		   });
		 }
		
	}
	
	function onSearch(){
       	frmSearch.action="WorktaskList.jsp";
		frmSearch.submit();
	}

	function checkAll(){
	    if($("#allCheck").attr("checked")){	
			$("input[name='worktaskid']").each(function(){
		        changeCheckboxStatus($(this),true);
		    });
		}else{
		    $("input[name='worktaskid']").each(function(){
		        changeCheckboxStatus($(this),false);
		    });
		}
	}
</script>
</HTML>
