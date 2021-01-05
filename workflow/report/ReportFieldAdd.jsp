<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

var dialog = null;
var parentWin = null;
try{
	dialog = parent.parent.getDialog(parent.window);
	parentWin = parent.parent.getParentWindow(parent.window);
}catch(e){}
</script>
<style>
  img{
    margin:2px;
  }
</style>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
String isBill = Util.null2String(request.getParameter("isBill"));
String formID = Util.null2String(request.getParameter("formID"));
String isclose = Util.null2String(request.getParameter("isclose"));

int dbordercount = Integer.parseInt(Util.null2String(request.getParameter("dbordercount")));

String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) ;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel = 0;
if(detachable == 1){
    rs.executeProc("Workflow_Report_SelectByID",id);
    rs.next();
    String subcompanyid= Util.null2String(rs.getString("subcompanyid"));
	operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", Util.getIntValue(subcompanyid,0));
}else{
    operatelevel = 2;
}
if(operatelevel < 0){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(operatelevel > 0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
}%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/workflow/report/ReportEdit.jsp?id="+id+",_top} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:cancleClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post>
<input type=hidden name="isbill" value="<%=isBill%>">

<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>
<%
// }
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(operatelevel > 0){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="reportFieldAddSubmitBtn" class="e8_btn_top" onclick="submitData()"/>
			<%} %>
			<!--<input type="text" class="searchInput" name="flowTitle"/>-->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>	 
		</td>
	</tr>
</table>
									
<div id="tabDiv" >
	<span class="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(84031,user.getLanguage())%>" onclick="mnToggleleft()"><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%></span>	
	<span id="hoverBtnSpan" class="hoverBtnSpan">
	<span onclick="location='ReportEdit.jsp?id=<%=id%>'" onmouseover="spanOver(this)" onmouseout="spanOut(this)"><%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%></span>
	<span style="margin-left:-4px;" class="selectedTitle" ><%=SystemEnv.getHtmlLabelNames("15101,261",user.getLanguage()) %></span>
	<span style="margin-left:-8px;" onmouseover="spanOver(this)" onmouseout="spanOut(this)" onclick="location='ReportShare.jsp?id=<%=id%>&isBill=<%=isBill %>&formID=<%=formID %>'"><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></span>
	</span>
</div>						
<!-- d p f start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>
  <TABLE class="ListStyle"> 
    <COLGROUP> 
	    <COL width="30%"> 
	    <COL width="15%"> 
	    <!-- <COL width="16%">  -->
	    <COL width="15%"> 
	    <COL width="25%"> 
	    <COL width="15%">
	</COLGROUP>
    <TBODY> 
    <tr class=header> 
      <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(125092,user.getLanguage()) %></td>
      <!-- <td>作为报表条件/默认值</td> -->
      <td><%=SystemEnv.getHtmlLabelName(31889,user.getLanguage()) %></td>
      <td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage()) %> / <%=SystemEnv.getHtmlLabelName(17736,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(18555,user.getLanguage()) %></td>
      <td><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage()) %>(100.00%)&nbsp;&nbsp;<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(81567,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span></td>
    </tr>
    
<%-----------    x w j for td2974 20051026     B E G I N   -----------%>
  <%!
  public String getVal(String val1,String val2,String val3,String val4){
	    String defaultval="";
		if(!val4.equals(""))
	    	  defaultval=val1+"~"+val2+"~"+val3+"~"+val4;
	    else if(!val3.equals(""))
	    	  defaultval=val1+"~"+val2+"~"+val3;
	    else if(!val2.equals(""))
	    	  defaultval=val1+"~"+val2;
	    else if(!val1.equals(""))
	    	  defaultval=val1;
		return defaultval;
  }
  %>
  <%
    int tmpcount = 0;
    tmpcount += 1;
	int fieldcount = 0;
	fieldcount -= 1;
    boolean isshow=false;
    int isstat=-1;
    int dborder=-1;
    int reportcondition = 0;
    String fieldwidth = "";
    String dbordertype = "";
    int compositororder = 0;
    String dsporder="";
    String defaultval="";
    rs.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid="+fieldcount);
    if(rs.next()){
      defaultval="";
      isshow=true;
      isstat=rs.getInt("isstat");
      reportcondition = rs.getInt("reportcondition");
	  fieldwidth=rs.getString("fieldwidth");
      dborder=rs.getInt("dborder");
      dsporder=rs.getString("dsporder");
      defaultval=getVal(rs.getString("valueone"),rs.getString("valuetwo"),rs.getString("valuethree"),rs.getString("valuefour"));
      //System.out.println("defaultval:"+defaultval);
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR>
  	  <!-- 字段名称 -->
      <TD>
      <%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>(requestname)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="-1">
      <input type="hidden" name='<%="default_"+tmpcount%>' value="<%=defaultval%>">
      <input type="hidden" name='<%="title_"+tmpcount%>' value=<%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>>
      </TD>
      <%String strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <!-- 显示列 -->
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
        <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "disabled" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </td>

      <!-- 统计 -->
      <td class=Field>
       
      </td>
      <!-- 排序 -->
      <td class=Field>
      <%if(isshow){%>

              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)" <%if(dborder==1){%> checked <%}%>>
      <%}else{%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="disabled" onclick="onCheck(<%=strtmpcount1%>)">
      <%}%>
              <select id='<%="dbordertype_"+tmpcount%>' name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="disabled"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
					<option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				    <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
		      </select>       
		      <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="disabled"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      <!-- 列宽 -->
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" <%if(!"".equals(fieldwidth)){%> value=<%=fieldwidth%><%}%> >
         <%}
         else{%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" value="<%=fieldwidth%>" disabled = "disabled" >
         <%}%>%
      </TD>
    </TR>
    <tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
    
    <%
     tmpcount += 1;
     fieldcount -= 1;
     isshow=false;
     isstat=-1;
     dborder=-1;
     dbordertype = "";
     compositororder = 0;
     reportcondition = 0;
     fieldwidth = "";
     dsporder="";
   	 rs.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid="+fieldcount);
   	 if(rs.next()){
      defaultval="";
      isshow=true;
      isstat=rs.getInt("isstat");
      dborder=rs.getInt("dborder");
      reportcondition = rs.getInt("reportcondition");
	  fieldwidth=rs.getString("fieldwidth");
      dsporder=rs.getString("dsporder");
      defaultval=getVal(rs.getString("valueone"),rs.getString("valuetwo"),rs.getString("valuethree"),rs.getString("valuefour"));
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR> 
  	  <!-- 字段名称 -->
      <TD>
      <%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>(requestlevel)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="-2">
      <input type="hidden" name='<%="default_"+tmpcount%>' value="<%=defaultval%>">
      <input type="hidden" name='<%="title_"+tmpcount%>' value=<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>>
      </TD>
      <%strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <!-- 显示列 -->
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
        <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "disabled" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </td>
      <!-- 报表条件 -->

      <!-- 统计 -->
      <td class=Field>
      
      </td>
      <!-- 排序 -->
     <td class=Field>
      <%if(isshow){%>


              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)" <%if(dborder==1){%> checked <%}%>>
      <%}else{%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="disabled" onclick="onCheck(<%=strtmpcount1%>)">
      <%}%>
              <select id='<%="dbordertype_"+tmpcount%>' name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="disabled"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
					<option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				    <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
		      </select>       
		      <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="disabled"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" <%if(!"".equals(fieldwidth)){%> value=<%=fieldwidth%> <%}%> >
         <%}
         else{%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" value="<%=fieldwidth%>" disabled = "disabled" >
         <%}%>%
      </TD>
    </TR>
    <tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
	<!--         -->
    <%
     List<String> fieldNameList = new ArrayList<String>();
     fieldNameList.add(SystemEnv.getHtmlLabelName(882, user.getLanguage())+"(creater)");//-10
     fieldNameList.add(SystemEnv.getHtmlLabelName(722, user.getLanguage())+"(createdate)");//-11
     fieldNameList.add(SystemEnv.getHtmlLabelName(259, user.getLanguage())+"(workflowid)");//-12
     fieldNameList.add(SystemEnv.getHtmlLabelName(18564, user.getLanguage())+"(currentnodeid)");//-13
     fieldNameList.add(SystemEnv.getHtmlLabelName(16354, user.getLanguage())+"(nooperator)");//-14
     //最终确认流程状态、归档日期作为显示列
     fieldNameList.add(SystemEnv.getHtmlLabelName(19061, user.getLanguage())+"(requeststatus)");//-15
     fieldNameList.add(SystemEnv.getHtmlLabelName(3000, user.getLanguage())+"(filingdate)");//-16
     //影响报表查询结果，出现多条重复requestid的数据

     //fieldNameList.add("接收日期(receivedate)");
     //影响报表显示美观
     //fieldNameList.add("签字意见(signoption)");
     int fieldcountnew = -9;
     for(int a = 0 ; a < fieldNameList.size() ; a++){
     defaultval="";
     tmpcount += 1;
     fieldcountnew -= 1;
     isshow=false;
     isstat=-1;
     dborder=-1;
     dbordertype = "";
     reportcondition = 0;
     fieldwidth = "";
     compositororder = 0;
     dsporder="";
     rs.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid="+fieldcountnew);
     if(rs.next()){
      isshow=true;
      isstat=rs.getInt("isstat");
      dborder=rs.getInt("dborder");
      reportcondition = rs.getInt("reportcondition");
      fieldwidth=rs.getString("fieldwidth");
      dsporder=rs.getString("dsporder");
      defaultval=getVal(rs.getString("valueone"),rs.getString("valuetwo"),rs.getString("valuethree"),rs.getString("valuefour"));
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR> 
   	  <!-- 字段名称 -->
      <TD>
      <%=fieldNameList.get(a)%>
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="<%=fieldcountnew%>">
      <input type="hidden" name='<%="title_"+tmpcount%>' value=<%=fieldNameList.get(a)%>>
      <input type="hidden" name='<%="default_"+tmpcount%>' value="<%=defaultval%>">
      </TD>
      <%strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <!-- 显示列 -->
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
        <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "disabled" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </td>
      <!-- 统计 -->
      <td class=Field></td>
      <!-- 排序 -->
      <td class=Field>
      <%if(isshow){%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)" <%if(dborder==1){%> checked <%}%>>
      <%}else{%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="disabled" onclick="onCheck(<%=strtmpcount1%>)">
      <%}%>
              <select id='<%="dbordertype_"+tmpcount%>' name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="disabled"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
					<option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				    <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
		      </select>       
		      <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="disabled"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" <%if(!"".equals(fieldwidth)){%> value=<%=fieldwidth%> <%}%> >
         <%}
         else{%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" value="<%=fieldwidth%>" disabled = "disabled" >
         <%}%>%
      </TD>
    </TR>
    <tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
    <%}%>
    
    
	<!--         -->
    
    
<%----------    xwj for td2974 20051026     E N D   -----------%>

<%
String sql="";
if(isBill.equals("0")){
  /*
  1、workflow_formdict,workflow_formdictdetail 两张表的分开，是极糟糕的设计！使得必须使用union操作；

  2、由于workflow_formfield.fieldorder 字段针对头和明细分别记录顺序，使得在union之后对fieldorder使用order by 失去意义；

  3、针对问题2，对 workflow_formfield.fieldorder 作 +100 的操作，以便union后排序，100能够满足绝对多数单据对头字段的要求；
  4、检索字段实际存储类型，屏蔽不能排序字段的排序操作；
  5、添加(明细)标记时要区分sql与oracle的操作差异

  */
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("select bf.*  from                                                                             \n");
	sqlSB.append(" (select workflow_formfield.fieldid      as id,                                               \n");
	sqlSB.append("         fieldname                       as name,                                             \n");
	sqlSB.append("         workflow_fieldlable.fieldlable  as label,                                            \n");
	sqlSB.append("         workflow_formfield.fieldorder as fieldorder,                                         \n");
	sqlSB.append("         workflow_formdict.fielddbtype   as dbtype,                                           \n");
	sqlSB.append("         workflow_formdict.fieldhtmltype as httype,                                           \n");
	sqlSB.append("         workflow_formdict.type as type                                                       \n");
	sqlSB.append("    from workflow_formfield, workflow_formdict, workflow_fieldlable                           \n");
	sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                               \n");
	sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                    \n");
	sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                             \n");
	sqlSB.append("     and workflow_formdict.id = workflow_formfield.fieldid                                    \n");
	sqlSB.append("     and workflow_formfield.formid = " + formID + "                                           \n");
	sqlSB.append("     and (workflow_formfield.isdetail <> '1' or workflow_formfield.isdetail is null)          \n");
	sqlSB.append("  union                                                                                       \n");
	sqlSB.append("  select workflow_formfield.fieldid as id,                                                    \n");
	sqlSB.append("         fieldname as name,                                                                   \n");
	if(rs.getDBType().equals("oracle")){
		sqlSB.append("         concat(workflow_fieldlable.fieldlable,' ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")') as label,                       \n");
	}else if(rs.getDBType().equals("db2")){
		sqlSB.append("         concat(workflow_fieldlable.fieldlable,' ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")') as label,                       \n");
	}else{
		sqlSB.append("         workflow_fieldlable.fieldlable + ' ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")' as label,                             \n");
	}
	sqlSB.append("         workflow_formfield.fieldorder + 100 as fieldorder,                                   \n");
	sqlSB.append("         workflow_formdictdetail.fielddbtype as dbtype,                                       \n");
	sqlSB.append("         workflow_formdictdetail.fieldhtmltype as httype,                                     \n");
	sqlSB.append("         workflow_formdictdetail.type as type                                                 \n");
	sqlSB.append("    from workflow_formfield, workflow_formdictdetail, workflow_fieldlable                     \n");
	sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                               \n");
	sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                    \n");
	sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                             \n");
	sqlSB.append("     and workflow_formdictdetail.id = workflow_formfield.fieldid                              \n");
	sqlSB.append("     and workflow_formfield.formid =" + formID + "                                            \n");
	sqlSB.append("     and (workflow_formfield.isdetail = '1' or workflow_formfield.isdetail is not null)) bf   \n");
	sqlSB.append(" left join (Select * from Workflow_ReportDspField where reportid = " + id + " ) rf            \n");
	sqlSB.append("   on (bf.id = rf.fieldid )                                           \n");
	sqlSB.append("   order by rf.dsporder                                                                       \n");
	sql = sqlSB.toString();
}else if(isBill.equals("1")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("  select bf.* from (                              \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.fieldhtmltype as httype,          \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.dsporder      as dsporder,        \n");
	sqlSB.append("           wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("      from workflow_billfield wfbf                \n");
	sqlSB.append("     where wfbf.billid = " + formID + " AND wfbf.viewtype = 0                       \n");
	sqlSB.append("    Union                                         \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.fieldhtmltype as httype,          \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("		     wfbf.dsporder+100  as dsporder,        \n");
	sqlSB.append("		     wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("		  from workflow_billfield wfbf              \n");
	sqlSB.append("		 where wfbf.billid = " + formID + " AND wfbf.viewtype = 1                     \n");
	sqlSB.append("  ) bf left join (Select * from Workflow_ReportDspField                             \n");
	sqlSB.append("  where reportid = " + id + ") rf on (bf.id = rf.fieldid )  \n");
	sqlSB.append("  order by rf.dsporder, bf.dsporder, bf.detailtable                                 \n");
	sql = sqlSB.toString();
}
rs.executeSql(sql);
//System.out.println("*********sql = "+sql);
while(rs.next()){
//if(rs.getString("type").equals("226")||rs.getString("type").equals("227")||rs.getString("type").equals("224")||rs.getString("type").equals("225")){
	//屏蔽集成浏览按钮-zzl
	//continue;
//}
tmpcount += 1;
String url="";
String fieldid = rs.getString("id"); 
String label = rs.getString("label");
String dbtype= rs.getString("dbtype");
String httype= rs.getString("httype");
String type= rs.getString("type");
String viewtype = rs.getString("viewtype");
String sql2="SELECT a.browserurl FROM workflow_browserurl a LEFT JOIN HtmlLabelIndex b ON a.labelid=b.id where a.ID="+type;
rs1.executeSql(sql2);
if(rs1.next()){
	url=rs1.getString("browserurl");
}
if(isBill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
	int viewType = rs.getInt("viewType");
	if(viewType == 1){
		label += " ("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")";
	}
}
/*-----  xwj for td2974 20051026   B E G I N  ----*/
isshow=false;
isstat=-1;
dborder=-1;
dbordertype = ""; //added by xwj for td2099 on 2005-06-06
compositororder = 0; //added by xwj for td2099 on 2005-06-06
reportcondition = 0;
fieldwidth = "";
dsporder="";

/*-----  xwj for td2974 20051026   E N D  ----*/
rs1.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid="+fieldid);
if(rs1.next()){
  defaultval="";
  isshow=true;
  isstat=rs1.getInt("isstat");
  dborder=rs1.getInt("dborder");
  //reportcondition = rs1.getInt("reportcondition");
  fieldwidth=rs1.getString("fieldwidth");
  defaultval=getVal(rs1.getString("valueone"),rs1.getString("valuetwo"),rs1.getString("valuethree"),rs1.getString("valuefour"));
  //System.out.println("defaultval:"+defaultval);
  dsporder=rs1.getString("dsporder");//modified by xwj for td2974 20051026
  //added by xwj for td2099 on 2005-06-06
  if(!"".equals(rs1.getString("dbordertype"))){
  dbordertype=rs1.getString("dbordertype");
  }
  if(rs1.getInt("compositororder") != -1){
      compositororder = rs1.getInt("compositororder");
  }
}

rs1.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldidbak = "+ fieldid);
if(rs1.next()){
	  dsporder=rs1.getString("dsporder");
}
%>
    <TR> 
      <!-- 字段名称 -->
      <TD>
      <%-----  Modefied  by xwj on 2005-06-06 for td2099   begin  ----%>
      <%=label%>
      (<%=rs.getString("name")%>)<!--added by xwj on 20051026 for td2974-->
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value=<%=fieldid%>>
      <input type="hidden" name='<%="dbtype_"+tmpcount%>' value=<%=dbtype%>>
      <input type="hidden" name='<%="httype_"+tmpcount%>' value=<%=httype%>>
      <input type="hidden" name='<%="type_"+tmpcount%>' value=<%=type%>>
      <input type="hidden" name='<%="url_"+tmpcount%>' value=<%=url%>>
      <input type="hidden" name='<%="default_"+tmpcount%>' value="<%=defaultval%>">
      <input type="hidden" name='<%="viewtype_"+tmpcount%>' value=<%=viewtype%>>
      <input type="hidden" name='<%="title_"+tmpcount%>' value=<%=label%>> <!--added by xwj for td2099 on 20050606-->
      </TD>
      <%String strtmpcount =(new Integer(tmpcount)).toString();%>
      <%strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <!-- 显示列 -->
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount%>)">
        <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "disabled" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </td>
      <!-- 统计 -->
      <td class=Field>
       <!-- Modified  by xwj on 20051026 for td2974 begin -->
       <%
       if("1".equals(rs.getString("httype")) && ( "2".equals(rs.getString("type"))||"3".equals(rs.getString("type"))||"4".equals(rs.getString("type")) )){
       	  if(isshow){%>
         		<input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" <%if(isstat==1){%> checked <%}%> >
          <%}else{%>
           		<input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" disabled=disabled>
          <%}
       }%>
       <!-- 
       <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" disabled=disabled>
       -->

      <!-- Modified  by xwj on 20051026 for td2974 end -->
      </td>
      <!-- 排序 -->
      <td class=Field>
      
        <%--
           1. 在报表中不显示或者不属于可排序类型的字段不参与该报表的字段排序设置

           2. 增加多字段排序方式

           3. 增加排序类型 "desc" or "asc"
           4. 增加排序关键字顺序

        --%>
  
        <%
        if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){
           if(isshow){
        %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}else{%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled=true onclick="onCheck(<%=strtmpcount%>)">
            <%}
        }%>

        <%
          if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){%>
            <select id='<%="dbordertype_"+tmpcount%>' name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled=disabled<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
					<option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				    <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
			</select>
			<input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled=true<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount%>)">
		   <%}%>
      </td>
      <!-- 宽度 -->
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" <%if(!"".equals(fieldwidth)){%> value=<%=fieldwidth%> <%}%> >
         <%}
         else{%>
         <input type="text" class=Inputstyle name='<%="fieldwidth_"+tmpcount%>' size="6" value="<%=fieldwidth%>" disabled = "disabled" >
         <%}%>%
      </TD>
    </TR>
    <tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft18'><div class='intervalDivClass'></div>
    </td></tr>
     <%-----  Modefied  by xwj on 2005-06-06 for td2099   end   ----%>
     
<% } %>
  <input type="hidden" name=operation value=formfieldadd>
	<input type="hidden" name=reportid value=<%=id%>>
  <input type="hidden" name=tmpcount value=<%=tmpcount%>>
    </TBODY> 
  </TABLE>
 </form>

<script language="javascript">
var isenabled;
if(<%=dbordercount%>>0)
  isenabled=false;
else
  isenabled=true;

<!-- Modified  by xwj on 2005-06-06 for td2099 begin -->
function submitData()
{
	
enableAllmenu();
 if (check_form(frmMain,'fieldidimage')){
	len = document.forms[0].elements.length;
  var i=0;
  var index;
  var selectName;
  var checkName;
  var lableName; 
  var compositororderName;
  var titlename;
  submit = true;   

  var rowsum1 = 0;

  for(i=len-1; i >= 0;i--) {

    if (document.forms[0].elements[i].name.substring(0,8)=='dborder_'){
    index = document.forms[0].elements[i].name.substring(8,document.forms[0].elements[i].name.length);
    checkName = "dborder_" + index;
    selectName = "dbordertype_" + index;
    lableName = "label_" + index;
    compositororderName = "compositororder_" + index;
    if(document.all(checkName).checked == true){
        if(document.all(selectName).value=="n"){
            if(document.all(lableName)){
                titlename=document.all(lableName).value;
            }else{
                titlename=document.all("title_"+index).value;
            }
        	alert ("[" + titlename + "] <%=SystemEnv.getHtmlLabelName(23276,user.getLanguage())%>!");
          submit = false;
            displayAllmenu();
          break;
        }
    }
   }
  }
  if(submit){
   if(checkSame()){<!-- Modified  by xwj on 20051031 for td2974  -->
   //提交表单之前，将所有禁用的输入框状态改为可用，否则其值不能保存到数据库中。

    var num = <%=tmpcount%>;
    for(var i=1; i<=num; i++){
    	document.all("dsporder_" + i).disabled = false;
        document.all("fieldwidth_" + i).disabled = false;
    }
   	frmMain.submit();
   }else {
		displayAllmenu();
   }
  }
}
}


<!-- Modified  by xwj on 20051031 for td2974 begin -->
function checkSame(){
var num = <%=tmpcount%>;
var showcount = 0;
var ordervalue = "";
var tempcount = -1;
var checkcount = 0;
for(i=1;i<=num;i++){
if(document.all("isshow_"+i).checked == true){
showcount = showcount+1;
}
}
var arr = new Array(showcount);
for(i=1;i<=num;i++){
	if(document.all("isshow_"+i).checked == true){
		tempcount = tempcount + 1;
		arr[tempcount] = document.all("dsporder_"+i).value;
		if(arr[tempcount] == ""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>");
			return false;
		}
	}
}


for(i=1;i<=num;i++){
checkcount = 0;
if(document.all("isshow_"+i).checked == true){
ordervalue = document.all("dsporder_"+i).value;
 for(a=0;a<arr.length;a++){
   if(parseFloat(ordervalue) == parseFloat(arr[a])){
   checkcount = checkcount + 1;
   }
 }
 if(checkcount>1){
	 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage()) %>!");
  return false;
 }
}
}
return true;
}
<!-- Modified  by xwj on 20051031 for td2974 end -->

function contains(array, e1) {
	for (var i=0; i<array.length; i++) {	
		var e = array[i];
		if (parseFloat(e) == parseFloat(e1)) {
			return true;
		}
	}
	return false;
}

function getNextNumber(){
	var num = <%=tmpcount%>;
	var allorders = new Array();
	var allordereles = $("input[name^=dsporder_]");
	allordereles.each(function (i, e) {
		allorders.push($(e).val());
	});
	var i = 0;
	
	for(i=0; i<num; i++){
		if (!contains(allorders, i)) {
			return (i + ".00");
		}
	}
	return (i + ".00");
}

function selectType(index){
 if(document.all("dbordertype_" + index).value == "a" || document.all("dbordertype_" + index).value == "d"){
      document.all("dborder_" + index).checked = true;
 }
 else{
      document.all("dborder_" + index).checked = false;
 }
}


function onCheck(index)
{
   if(document.all("dborder_" + index).checked == true){
	  jQuery("#dbordertype_"+ index).selectbox("detach");
      document.all("dbordertype_" + index).disabled = false;
      document.all("dbordertype_" + index).selectedIndex = 2;
      //$("input[name=dbordertype_" + index + "]").removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
      document.all("compositororder_" + index).disabled = false;
      document.all("compositororder_" + index).value = "0";  
	  jQuery("#dbordertype_"+ index).selectbox("attach");
   }else{
	  jQuery("#dbordertype_"+ index).selectbox("detach");
      document.all("dbordertype_" + index).disabled = true;
      //$("input[name=dbordertype_" + index + "]").removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      //$("input[name=compositororder_" + index + "]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
      document.all("compositororder_" + index).value = "";
	  jQuery("#dbordertype_"+ index).selectbox("attach");
   }
}

function onCheckShow(index){
var currentIndex = getNextNumber();
   if(document.all("isshow_" + index).checked){
      //changeCheckboxStatus($("input[name=dborder_" + index + "]"),true);
      document.all("dsporder_" + index).disabled = false;
      document.all("dsporder_" + index).value = currentIndex;
      document.all("fieldwidth_" + index).disabled = false;
      $("input[name=dborder_" + index + "]").next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
      document.all("dborder_" + index).disabled = false;
      //changeCheckboxStatus($("input[name=isstat_" + index + "]"),true);
      document.all("isstat_" + index).disabled = false;
      $("input[name=isstat_" + index + "]").next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
      //$("input[name=reportcondition_" + index + "]").next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   
   } else{
      //changeCheckboxStatus($("input[name=dborder_" + index + "]"),false);
      document.all("dsporder_" + index).value = "";
      document.all("dsporder_" + index).disabled = true;
      document.all("fieldwidth_" + index).disabled = true;
      $("input[name=dborder_" + index + "]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
      document.all("dborder_" + index).checked = false;
      document.all("dborder_" + index).disabled = true;
      jQuery("#dbordertype_"+ index).selectbox("detach");
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("dbordertype_" + index).disabled = true;
      document.all("compositororder_" + index).disabled = true;
      jQuery("#dbordertype_"+ index).selectbox("attach");
      //changeCheckboxStatus($("input[name=isstat_" + index + "]"),false);
      document.all("isstat_" + index).disabled = true;
      document.all("isstat_" + index).checked = false;
      $("input[name=isstat_" + index + "]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
      //$("input[name=reportcondition_" + index + "]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
   
   }
}

function checkDsporder(index){ //Modified  by xwj on 20051026 for td2974
     var dsporderValue;
     if(document.all("dsporder_" + index).value == ""){
        document.all("dsporder_" + index).value = "0.00";
     }
     else{
     checkdecimal_length(index,2);
     }
}

function checkCompositororder(index){
     if(document.all("compositororder_" + index).value == ""){
       document.all("compositororder_" + index).value = "0";
     }
     
}


function Count_KeyPress(name,index)
{
 if(!(window.event.keyCode>=48 && window.event.keyCode<=57)) 
  {
     window.event.keyCode=0;
  }
}

<!-- Modified  by xwj on 2005-06-06 for td2099 end -->
 
 
function bak(){
  document.forms[0].elements[i].enabled==false;
  top.Dialog.alert(document.forms[0].elements[i].name.substringData(0,8));
}


<!-- Modified  by xwj on 20051026 for td2974 begin -->

function checkdecimal_length(index,maxlength)
{
	var  elementname = "dsporder_" + index;
	if(!isNaN(parseInt(document.all(elementname).value)) && (maxlength > 0)){
		inputTemp = document.all(elementname).value ;
		if (inputTemp.indexOf(".") !=-1)
		{
			inputTemp = inputTemp.substring(inputTemp.indexOf(".")+1,inputTemp.length);
			if (inputTemp.length > maxlength)
			{
				var tempvalue = document.all(elementname).value;
				tempvalue = tempvalue.substring(0,tempvalue.length-inputTemp.length+maxlength);
				document.all(elementname).value = tempvalue;
			}
		}
	}
}

function Count_KeyPress1(name,index)
{
 var elementname = name + index;
 tmpvalue = document.all(elementname).value;
 var count = 0;
 var len = -1;
 if(elementname){
 len = tmpvalue.length;
 }
 for(i = 0; i < len; i++){
    if(tmpvalue.charAt(i) == "."){
    count++;     
    }
 }
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==46 || window.event.keyCode==45) || (window.event.keyCode==46 && count == 1))
  {  
     
     window.event.keyCode=0;
     
  }
}
<!-- Modified  by xwj on 20051026 for td2974 end -->
function spanOver(obj){
    $(obj).addClass("rightMenuHover");
}

function spanOut(obj){
    $(obj).removeClass("rightMenuHover");
}
		
function mnToggleleft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 			
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
		}
	}
}

function cancleClose(){
	dialog.close();
}

<%if("1".equals(isclose)){%>
	//parentWin.location="/workflow/report/addDefineReport.jsp?id=<%=id%>";
	var id = "<%=id%>";
	parentWin.editDialog(id,dialog);
	//dialog.close();
<%}%>


</script>
</BODY></HTML>

