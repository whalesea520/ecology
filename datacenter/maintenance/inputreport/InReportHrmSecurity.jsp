<%@ page contentType="text/html; charset=GBK" language="java"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page"/>
<%
	this.req=request;
	this.rs=RecordSet;
    String action = getParam("action");
    String change = getParam("change");
    String sUrl=null;
	Map map1=null;
	int id=Util.getIntValue(getParam("id"),0);
	int inprepId=Util.getIntValue(getParam("inprepid"),0);
	if(action.equalsIgnoreCase("addHrm")){//新增录入人员
		String hrmIds=getParam("hrmIds");
		this.addHrm(hrmIds,inprepId);//hrmIds=,$id,$id,$id
		sUrl="InputReportEdit.jsp?inprepid="+inprepId/*+"#inputNameList"*/;
	}else if(action.equalsIgnoreCase("delHrm")){//删除录入人员
		this.delHrm(id);
		sUrl="InputReportEdit.jsp?inprepid="+inprepId/*+"#inputNameList"*/;
	}else if(action.equalsIgnoreCase("saveHrm")){//保存权限设置
		if(this.saveHrmSecurity(inprepId,id)==0)
		sUrl="InputReportEdit.jsp?inprepid="+inprepId;
	}else if(action.equalsIgnoreCase("ShowSql")){
        if("1".equals(change)) this.saveHrmSecurity(inprepId,id);
        sUrl="ShowCollectSql.jsp?id="+id+"&inprepid="+inprepId;
    }else{//获取权限信息使编辑
		map1=this.getHrmSecurityInfo(id,REPORT_HRM_ID);
	}
	if(sUrl!=null)response.sendRedirect(sUrl);

    String chkfields="crmIds";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Untitled Document</title>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet" />
<script language="JavaScript" src="/js/weaver.js" type="text/javascript"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20717,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(20769,user.getLanguage())+",javascript:onShowSql(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10"/>
<col width=""/>
<col width="10"/>
</colgroup>
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<table class="Shadow" width="100%">
<tr>
<td valign="top">
<iframe width="0" height="0" src="about:blank" id="uploadFrm" name="uploadFrm"></iframe>
<form action="saveCustomeTemplate.jsp" name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" target="uploadFrm">
<div id="fileDiv" style="position:absolute;display:none;width:80%;">
<input type="file" class="InputStyle" size="50" name="customTemplate" id="customTemplate" />
<%
String userTemplateName="User_"+getTableNameByInprepId(inprepId)+id;
String sTmp=getExistUserExcelTemplate(userTemplateName);
if(sTmp!=null)out.print("<a href=\"/datacenter/inputexcellfile/"+sTmp+"\" target=\"_blank\">"+sTmp+"</a>");
%>
<input type="hidden" name="fileName" value="<%=userTemplateName%>" />
</div>
</form>
<!-- ======================================= -->
<form name="form1" id="form1" action="#" method="post">
<input type="hidden" name="action" value="saveHrm" />
<input type="hidden" name="change" value="0" />
<!----------------------------------------------->
<table class="viewform" cellspacing="1" width="100%">
    <tbody> 
    <tr class="title"> 
      <td colspan="2" align="left"><b><%=SystemEnv.getHtmlLabelName(20718,user.getLanguage())%></b></td>
    </tr>
	<tr class="spacing"><td class="line1" colspan="2"></td></tr>
    <tr class="datadark">
      <td width="20%"><%=SystemEnv.getHtmlLabelName(16902,user.getLanguage())%></td>
      <td width="80%" class="Field"><button class="Browser" onClick="onShowCRM('crmIds','crmIdHtml');">&nbsp;</button>
	  	<input type="hidden" name="crmIds" id="crmIds" value="<%=map1.get("crmIds")%>"/><span id="crmIdHtml">
			<%
			String crmIds=map1.get("crmIds").toString();
			if(!crmIds.equalsIgnoreCase("")){
				out.print(this.getCrmNameByCrmIds(customerInfoComInfo,crmIds));
			}else out.print("<img alt='!' src='/images/BacoError.gif' align='absMiddle'>");
			%></span>		</td>
    </tr>
    <tr class="spacing"><td class="line" colspan="2"></td></tr>    
    <tr class="datadark">
      <td><%=SystemEnv.getHtmlLabelName(20719,user.getLanguage())%></td>
      <td class="Field"><input type="text" class="inputstyle" size="50" name="modulefilename" value="<%=map1.get("moduleFileName")%>" onChange="dochange()"></td>
    </tr>
    <tr class="spacing"><td class="line" colspan="2"></td></tr>
	<tr class="DataDark">
	<td><%=SystemEnv.getHtmlLabelName(73,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())%><!--自定义模板--></td>
	<td class="Field" id="customExcel"></td>
	</tr>
	<tr class="spacing"><td class="line" colspan="2"></td></tr>
    </tbody> 
  </table>
<!----------------------------------------------->
<table class="viewform" cellspacing="1" width="100%">
    <tbody> 
    <tr class="title"> 
      <td colspan="2" align="left"><b><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></b></td>
    </tr>
	<tr class="spacing"><td class="line1" colspan="2"></td></tr>
    <tr class="datadark">
      <td width="30%"><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></td>
      <td width="70%" class="Field"><button class=Browser  onclick="onShowBrowser2(flowId,flowIdSpan)">&nbsp;</button>
	  <input type="hidden" name="flowId" id="flowId" value="<%=map1.get("workflowId")%>"/>
        <span id="flowIdSpan"><%=workflowComInfo.getWorkflowname(map1.get("workflowId").toString())%></span>
   </td>
    </tr>
    <tr class="spacing"><td class="line" colspan="2"></td></tr>    
    </tbody> 
  </table>
  <!----------------------------------------------->
<table class="viewform" cellspacing="1" width="100%">
    <tbody> 
    <tr class="title"> 
      <td align="left"><b><%=SystemEnv.getHtmlLabelName(20720,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
	  <label for="allSel" style="cursor:hand"><input type="checkbox" name="allSel" id="allSel" onClick="allSelField(this)" /><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></label>
      &nbsp;&nbsp;&nbsp;&nbsp;<label id="allshow" style="cursor:hand" onClick="allShow(this,'all')"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%></label></b>
      </td>
    </tr>
	<tr class="spacing"><td class="line1" colspan="2"></td></tr>
	<%
	List list1=this.getFieldList(inprepId);
	int sizes=list1.size();
	Map m=null,m1;
	String chks=null;
	List selFields=(List)map1.get("fields");
	for(int i=0;i<sizes;i++){
		m=(Map)list1.get(i);
	%>
	<tr bgcolor='#cccccc'><td colspan="2"><%=m.get("itemName")%>&nbsp;&nbsp;&nbsp;
	<label for="allSel<%=i%>" style="cursor:hand"><input type="checkbox" name="allSel<%=i%>" id="allSel<%=i%>" onClick="allSelField(this)" /><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></label>
    &nbsp;&nbsp;&nbsp;&nbsp;<label id="allshow<%=i%>" style="cursor:hand" onClick="allShow(this,'type<%=i%>')"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%></label>
    </td></tr>
    <tr class="spacing"><td class="line" colspan="2"></td></tr>    
    <%
		List fieldsList=(List)m.get("fieldList");
		int sizes2=fieldsList.size();
        for(int n=0;n<sizes2;n++){
			m1=(Map)fieldsList.get(n);
			chks=(selFields.contains(m1.get("id")))?" checked='checked' ":"";
            if(n==0){
    %>
	<tr class="datadark" id="type<%=i%>" style="display:">
    <%
        }else
        if(n%2==0){
    %>
    </tr>
    <tr class="datadark" id="type<%=i%>" style="display:">
    <%
        }
    %>
      <td  width="50%" class="Field"><label for="fieldId<%=m1.get("id")%>" style="cursor:hand"><input groupid="allSel<%=i%>" <%=chks%> type="checkbox" name="fieldIds" id="fieldId<%=m1.get("id")%>" value="<%=m1.get("id")%>" onChange="dochange()"/>
	  	<%out.print(m1.get("name")+"("+m1.get("fieldName")+")");%></label></td>
	<%}
	%>
    </tr>
    <%}%>
    </tbody> 
  </table>
<!----------------------------------------------->
<table class="viewform" cellspacing="1" width="100%">
    <tbody>
    <tr class="title">
      <td  align="left"><b><%=SystemEnv.getHtmlLabelName(20722,user.getLanguage())%></b></td>
      <td  align="right"><button class=btnNew accessKey=I onClick="addRow(oTable);"><u>I</u>-<%=SystemEnv.getHtmlLabelName(20723,user.getLanguage())%></button><button class=btnDelete accessKey=T onClick="javascript:if(isdel()){deleteRow(oTable,'check_jl')};"><u>T</u>-<%=SystemEnv.getHtmlLabelName(20724,user.getLanguage())%></button></td>
    </tr>
	<tr class="spacing"><td class="line1" colspan="2"></td></tr>
    </tbody>
  </table>
<table class=liststyle cellspacing=1 id="oTable" cols=2>
      <colgroup>
      <col width="3%">
      <col width="97%">
      <tbody>
      <%
          RecordSet.executeSql("select * from T_CollectSettingInfo where reporthrmid="+id+" order by id");
          int recordexindex = -1 ;
          while(RecordSet.next()){
              recordexindex++;
              int Collectid=RecordSet.getInt("id");
              String tcrmids=Util.null2String(RecordSet.getString("crmids"));
              int cycle=Util.getIntValue(RecordSet.getString("cycle"),0);
              String sortfields=Util.null2String(RecordSet.getString("sortfields"));
              String sqlwhere=Util.null2String(RecordSet.getString("sqlwhere"));
              ArrayList tablelist=new ArrayList();
              ArrayList tablealialist=new ArrayList();
              ArrayList resfields=new ArrayList();
              ArrayList desfields=new ArrayList();
              rs1.executeSql("select * from T_CollectTableInfo where Collectid="+Collectid+" order by id");
              while(rs1.next()){
                  tablelist.add(rs1.getString("inprepid"));
                  tablealialist.add(rs1.getString("tablealia"));
              }
              rs1.executeSql("select * from T_FieldComparisonInfo where Collectid="+Collectid+" order by id");
              while(rs1.next()){
                  resfields.add(rs1.getString("sourcefield"));
                  desfields.add(rs1.getString("desfield"));
              }
              chkfields+=",crmIds_"+recordexindex;
      %>
          <tr>
              <td bgcolor="#c5c5c5"><input type='checkbox' name='check_jl' value="<%=recordexindex%>">
                  <input type='hidden' name='thevalue_<%=recordexindex%>' value=1>
                  <input type="hidden" name="tablenum_<%=recordexindex%>" value="<%=(tablelist.size()>0)?tablelist.size():1%>">
                  <input type="hidden" name="fieldnum_<%=recordexindex%>" value="<%=resfields.size()%>">
              </td>
              <td>
                  <table class=viewform cellspacing=1 >
                      <tbody>
                      <tr class="title">
                          <td colspan="2" align="left"><b><%=SystemEnv.getHtmlLabelName(16484,user.getLanguage())%></b></td>
                      </tr>
                      <tr class="spacing"><td class="line1" colspan="2"></td></tr>
                      <tr>
                          <td width="20%"><%=SystemEnv.getHtmlLabelName(20725,user.getLanguage())%></td>
                          <td width="80%" class="Field"><button class="Browser" onClick="onShowCRM('crmIds_<%=recordexindex%>','crmIdHtml_<%=recordexindex%>');">&nbsp;</button>
                            <input type="hidden" name="crmIds_<%=recordexindex%>" id="crmIds_<%=recordexindex%>" value="<%=tcrmids%>"/><span id="crmIdHtml_<%=recordexindex%>">
                                <%
                                if(!tcrmids.equalsIgnoreCase("")){
                                    out.print(this.getCrmNameByCrmIds(customerInfoComInfo,tcrmids));
                                }else out.print("<img alt='!' src='/images/BacoError.gif' align='absMiddle'>");
                                %></span>		</td>
                        </tr>
                        <tr class="spacing"><td class="line" colspan="2"></td></tr>
                        <tr>
                          <td width="20%"><%=SystemEnv.getHtmlLabelName(20726,user.getLanguage())%></td>
                          <td width="80%" class="Field">
                              <input type="radio" name="cycle_<%=recordexindex%>" value="1" <%if(cycle==1){%>checked<%}%> onChange="dochange()"><%=SystemEnv.getHtmlLabelName(20728,user.getLanguage())%>
                              <input type="radio" name="cycle_<%=recordexindex%>" value="2" <%if(cycle==2){%>checked<%}%> onChange="dochange()"><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
                              <input type="radio" name="cycle_<%=recordexindex%>" value="3" <%if(cycle==3){%>checked<%}%> onChange="dochange()"><%=SystemEnv.getHtmlLabelName(18280,user.getLanguage())%>
                              <input type="radio" name="cycle_<%=recordexindex%>" value="4" <%if(cycle==4){%>checked<%}%> onChange="dochange()"><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage())%>
                              <input type="radio" name="cycle_<%=recordexindex%>" value="5" <%if(cycle==5){%>checked<%}%> onChange="dochange()"><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
                              <input type="radio" name="cycle_<%=recordexindex%>" value="0" <%if(cycle==0){%>checked<%}%> onChange="dochange()"><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>
                          </td>
                        </tr>
                        <tr class="spacing"><td class="line" colspan="2"></td></tr>
                        <tr>
                          <td width="20%"><%=SystemEnv.getHtmlLabelName(20727,user.getLanguage())%></td>
                          <td width="80%" class="Field">
                              <table class=viewform cellspacing=1 id="oTable_<%=recordexindex%>" cols=4>
                                  <colgroup>
                                  <col width="60%">
                                  <col width="10%">
                                  <col width="10%">
                                  <col width="20%">
                                  <tbody>
                              <%
                                  if(tablelist.size()>0){
                                      for(int i=0;i<tablelist.size();i++){
                              %>
                                  <tr>
                                      <td>
                                          <select name="tableid_<%=recordexindex%>_<%=i%>"  onchange="dochange()">
                                              <option value=""></option>
                                              <%
                                                  InputReportComInfo.setTofirstRow();
                                                  while(InputReportComInfo.next()){
                                              %>
                                              <option value="<%=InputReportComInfo.getinprepid()%>" <%if(tablelist.get(i).equals(InputReportComInfo.getinprepid())){%>selected<%}%>><%=InputReportComInfo.getinprepname()+"("+InputReportComInfo.getinpreptablename()+")"%></option>
                                              <%
                                                  }
                                              %>
                                          </select>
                                      </td>
                                      <td align="right"><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>
                                      <td><input type="text" class=inputstyle size=5 maxlength=2 name="tablealia_<%=recordexindex%>_<%=i%>" value="<%=tablealialist.get(i)%>"  onchange="dochange()"></td>
                                      <td><%if(i==0){%><button class=btnNew onClick="addRow1(oTable_<%=recordexindex%>,tablenum_<%=recordexindex%>,<%=recordexindex%>);"><%=SystemEnv.getHtmlLabelName(20730,user.getLanguage())%></button><%}else{%>&nbsp;<%}%></td>
                                  </tr>
                              <%
                                        }
                                  }else{
                              %>
                                  <tr>
                                      <td>
                                          <select name="tableid_<%=recordexindex%>_0"  onchange="dochange()">
                                              <option value=""></option>
                                              <%
                                                  InputReportComInfo.setTofirstRow();
                                                  while(InputReportComInfo.next()){
                                              %>
                                              <option value="<%=InputReportComInfo.getinprepid()%>"><%=InputReportComInfo.getinprepname()+"("+InputReportComInfo.getinpreptablename()+")"%></option>
                                              <%
                                                  }
                                              %>
                                          </select>
                                      </td>
                                      <td align="right"><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>
                                      <td><input type="text" class=inputstyle size=5 maxlength=2 name="tablealia_<%=recordexindex%>_0" value="" onChange="dochange()"></td>
                                      <td><button class=btnNew onClick="addRow1(oTable_<%=recordexindex%>,tablenum_<%=recordexindex%>,<%=recordexindex%>);"><%=SystemEnv.getHtmlLabelName(20730,user.getLanguage())%></button></td>
                                  </tr>
                              <%
                                  }
                              %>
                                  </tbody>
                              </table>
                          </td>
                        </tr>
                        <tr class="spacing"><td class="line" colspan="2"></td></tr>
                        <tr>
                          <td width="20%"><%=SystemEnv.getHtmlLabelName(20731,user.getLanguage())%></td>
                          <td width="80%" class="Field">
                              <textarea type="text" class=inputstyle cols=120 rows=4 name="sortfields_<%=recordexindex%>" onChange="dochange()"><%=Util.convertDB2Input(sortfields)%></textarea><br><font color="red"><%=SystemEnv.getHtmlLabelName(20732,user.getLanguage())%></font>
                          </td>
                        </tr>
                        <tr class="spacing"><td class="line" colspan="2"></td></tr>
                        <tr>
                          <td width="20%"><%=SystemEnv.getHtmlLabelName(20734,user.getLanguage())%></td>
                          <td width="80%" class="Field">
						  <jsp:useBean id="xss" class="weaver.filter.XssUtil" scope="page" />
                              <textarea type="text" class=inputstyle cols=120 rows=4 name="sqlwhere_<%=recordexindex%>" onChange="dochange()" ><%=xss.put(Util.convertDB2Input(sqlwhere))%></textarea><br><font color="red"><%=SystemEnv.getHtmlLabelName(20733,user.getLanguage())%></font>
                          </td>
                        </tr>
                        <tr class="spacing"><td class="line" colspan="2"></td></tr>
                        <tr class="title">
                          <td width="20%" align="left"><b><%=SystemEnv.getHtmlLabelName(20735,user.getLanguage())%></b></td>
                          <td width="80%" align="right">
                          <button class=btnNew onClick="addRow2(oTable<%=recordexindex%>,fieldnum_<%=recordexindex%>,<%=recordexindex%>);"><%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></button><button class=btnDelete onClick="javascript:if(isdel()){deleteRow1(oTable<%=recordexindex%>,'checkfield<%=recordexindex%>')};"><%=SystemEnv.getHtmlLabelName(702,user.getLanguage())%></button>
                          </td>
                        </tr>
                        <tr class="spacing"><td class="line1" colspan="2"></td></tr>
                        <tr>
                            <td colspan="2">
                                <table Class=ListStyle id="oTable<%=recordexindex%>" cols=3>
                                    <colgroup>
                                    <col width="3%">
                                    <col width="60%">
                                    <col width="37%">
                                    <tbody>
                                    <tr class=header>
                                        <td>&nbsp;</td>
                                        <td><%=SystemEnv.getHtmlLabelName(20736,user.getLanguage())%></td>
                                        <td><%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%></td>
                                    </tr>
                                    <%
                                    for(int i=0;i<resfields.size();i++){
                                    %>
                                    <tr>
                                        <td class="Field"><input type='checkbox' name='checkfield<%=recordexindex%>' value=1>
                                            <input type='hidden' name='field<%=recordexindex%>' value=1>
                                        </td>
                                        <td class="Field"><input type='text' class=inputstyle size=50 name='sourcefield<%=recordexindex%>_<%=i%>' value="<%=resfields.get(i)%>" onChange="dochange()"></td>
                                        <td class="Field"><input type='text' class=inputstyle name='desfield<%=recordexindex%>_<%=i%>' value="<%=desfields.get(i)%>" onChange="dochange()"></td>
                                    </tr>    
                                    <%
                                    }
                                    %>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                      </tbody>
                  </table>
              </td>
          </tr>
      <%
          }
          recordexindex++;
      %>
      </tbody>
</table>
<input type="hidden" name="totalvalue" value="<%=recordexindex%>">
<input type="hidden" name="chkfields" value="<%=chkfields%>">
  <!----------------------------------------------->
</form>
</td>
</tr>
</table>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language="javascript" type="text/javascript">
function dochange(){
    document.form1.change.value="1";
}
function allSelField(obj){
	var ids=document.getElementsByName("fieldIds");
	var isAll=(obj.id=="allSel")?true:false;
	var groupId=null;
    if(isAll){
        <%for(int i=0;i<sizes;i++){%>
            document.getElementById("allSel<%=i%>").checked=obj.checked;
        <%}%>
    }
    for(var i=0;i<ids.length;i++){
		if(!isAll) {
			groupId=ids[i].getAttribute("groupid");
			if(groupId!=obj.id)continue;
		}
		ids[i].checked=obj.checked;
	}
    dochange();
}
function allShow(obj,trname){
	var isAll=(trname=="all")?true:false;
    var isshow=(obj.innerText=="<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>")?true:false;
    if(isAll){
        if(isshow)
            document.getElementById("allshow").innerText="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>";
        else
            document.getElementById("allshow").innerText="<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>";
        <%for(int i=0;i<sizes;i++){%>
            var ids=document.getElementsByName("type<%=i%>");
            for(var j=0;j<ids.length;j++){
                if(isshow)
                    ids[j].style.display='';
                else
                    ids[j].style.display='none';
            }
            if(isshow)
                document.getElementById("allshow<%=i%>").innerText="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>";
            else
                document.getElementById("allshow<%=i%>").innerText="<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>";
        <%}%>
    }else{
        var ids=document.getElementsByName(trname);
        for(var j=0;j<ids.length;j++){
            if(isshow)
                ids[j].style.display='';
            else
                ids[j].style.display='none';
        }
        if(isshow)
            obj.innerText="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>";
        else
            obj.innerText="<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>";
    }
}
function chk(){
    var chkfield=form1.chkfields.value.split(",");
	var ret=true;
    for(var i=0;i<chkfield.length;i++){
        var crmIds=document.getElementById(chkfield[i]);
        if(crmIds.value==""){
            alert("<%=SystemEnv.getHtmlLabelName(20737,user.getLanguage())%>");
            ret=false;
            break;
        }
    }
    return ret;
}
function onCancel(){
	window.history.back(-1);
}
String.prototype.endsWith=function(suffix){
	return this.substring(this.length-suffix.length).toLowerCase()==suffix.toLowerCase();
}
function onSave(){
	if(chk()){
		var fileName=document.getElementById("customTemplate").value;
		if(fileName!=""){
			if(!fileName.endsWith(".xls")){
				alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
				return;
			}
			//设置监控自定义模板文件上传。
			var frmDoc=document.getElementById("uploadFrm");
			frmDoc.attachEvent("onreadystatechange",function(){
				if(frmDoc.readyState=="complete"){
					document.form1.submit();
				}//End if.
			});
			document.fileForm.submit();//上传模板文件

		}else document.form1.submit();
    }
}
function onShowSql(){
    if(chk()){
        document.form1.action.value="ShowSql";
        document.form1.submit();
    }
}

rowindex=<%=recordexindex%>;
function addRow(obj)
{
    ncol = obj.cols;
	oRow = obj.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
        switch(j) {
			case 0:
                oCell.style.background= "#c5c5c5";
				var sHtml = "<input type='checkbox' name='check_jl' value="+rowindex+">"+
                            "<input type='hidden' name='thevalue_"+rowindex+"' value=1>"+
                            "<input type='hidden' name='tablenum_"+rowindex+"' value=1>"+
                            "<input type='hidden' name='fieldnum_"+rowindex+"' value=0>" ;
				break;
			case 1:
				var sHtml = "<table class=viewform cellspacing=1 >"+
                      "<tbody>"+
                      "<tr class='title'>"+
                          "<td colspan=2 align=left><b><%=SystemEnv.getHtmlLabelName(16484,user.getLanguage())%></b></td>"+
                      "</tr>"+
                      "<tr class=spacing><td class=line1 colspan=2></td></tr>"+
                      "<tr>"+
                          "<td width='20%'><%=SystemEnv.getHtmlLabelName(20725,user.getLanguage())%></td>"+
                          "<td width=\"80%\" class=\"Field\"><button class=\"Browser\" onclick=\"onShowCRM('crmIds_"+rowindex+"','crmIdHtml_"+rowindex+"');\">&nbsp;</button>"+
                            "<input type=\"hidden\" name=\"crmIds_"+rowindex+"\" id=\"crmIds_"+rowindex+"\" value=\"\" /><span id=\"crmIdHtml_"+rowindex+"\">"+
                                "<img alt='!' src='/images/BacoError.gif' align='absMiddle'>"+
                                "</span>		</td>"+
                        "</tr><tr class=spacing><td class=line colspan=2></td></tr>"+
                        "<tr>"+
                          "<td width=\"20%\"><%=SystemEnv.getHtmlLabelName(20726,user.getLanguage())%></td>"+
                          "<td width=\"80%\" class=\"Field\">"+
                              "<input type=\"radio\" name=\"cycle_"+rowindex+"\" value=1 ><%=SystemEnv.getHtmlLabelName(20728,user.getLanguage())%>"+
                              "<input type=\"radio\" name=\"cycle_"+rowindex+"\" value=2 ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>"+
                              "<input type=\"radio\" name=\"cycle_"+rowindex+"\" value=3 ><%=SystemEnv.getHtmlLabelName(18280,user.getLanguage())%>"+
                              "<input type=\"radio\" name=\"cycle_"+rowindex+"\" value=4><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage())%>"+
                              "<input type=\"radio\" name=\"cycle_"+rowindex+"\" value=5><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>"+
                              "<input type=\"radio\" name=\"cycle_"+rowindex+"\" value=0 checked><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>"+
                          "</td>"+
                        "</tr><tr class=spacing><td class=line colspan=2></td></tr>"+
                        "<tr>"+
                          "<td width=\"20%\"><%=SystemEnv.getHtmlLabelName(20727,user.getLanguage())%></td>"  +
                          "<td width=\"80%\" class=\"Field\">" +
                              "<table class=viewform cellspacing=1 id=\"oTable_"+rowindex+"\" cols=4>"+
                                  "<COLGROUP>"+
                                  "<COL width=\"60%\">" +
                                  "<COL width=\"10%\">"+
                                  "<COL width=\"10%\">" +
                                  "<COL width=\"20%\">"+
                                  "<TBODY>"+
                                  "<tr>"+
                                      "<td>"+
                                          "<select name=\"tableid_"+rowindex+"_0\">"+
                                              "<option value=\"\"></option>"+
                                              <%
                                                  InputReportComInfo.setTofirstRow();
                                                  while(InputReportComInfo.next()){
                                              %>
                                              "<option value=\"<%=InputReportComInfo.getinprepid()%>\"><%=InputReportComInfo.getinprepname()%>(<%=InputReportComInfo.getinpreptablename()%>)</option>"+
                                              <%
                                                  }
                                              %>
                                          "</select>"+
                                      "</td>"+
                                      "<td align=\"right\"><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>"+
                                      "<td><input type=\"text\" class=inputstyle size=5 maxlength=2 name=\"tablealia_"+rowindex+"_0\" value=''></td>"+
                                      "<td><BUTTON class=btnNew onClick=\"addRow1(oTable_"+rowindex+",tablenum_"+rowindex+","+rowindex+");\"><%=SystemEnv.getHtmlLabelName(20730,user.getLanguage())%></BUTTON></td>"+
                                  "</tr>"+
                                  "</TBODY>"+
                              "</table>"+
                          "</td>"+
                        "</tr><tr class=spacing><td class=line colspan=2></td></tr>"+
                        "<tr>"+
                          "<td width=\"20%\"><%=SystemEnv.getHtmlLabelName(20731,user.getLanguage())%></td>"+
                          "<td width=\"80%\" class=\"Field\">"+
                              "<textarea type=\"text\" class=inputstyle cols=120 rows=4 name=\"sortfields_"+rowindex+"\" ></textarea><br><font color=\"red\"><%=SystemEnv.getHtmlLabelName(20732,user.getLanguage())%></font>"+
                          "</td>"+
                        "</tr><tr class=spacing><td class=line colspan=2></td></tr>"+
                        "<tr>"+
                          "<td width=\"20%\"><%=SystemEnv.getHtmlLabelName(20734,user.getLanguage())%></td>"+
                          "<td width=\"80%\" class=\"Field\">"+
                              "<textarea type=\"text\" class=inputstyle cols=120 rows=4 name=\"sqlwhere_"+rowindex+"\" ></textarea><br><font color=\"red\"><%=SystemEnv.getHtmlLabelName(20733,user.getLanguage())%></font>"+
                          "</td>"+
                        "</tr><tr class=spacing><td class=line colspan=2></td></tr>"+
                        "<tr class=\"title\">"+
                          "<td width=\"20%\" align=\"left\"><b><%=SystemEnv.getHtmlLabelName(20735,user.getLanguage())%></b></td>"+
                          "<td width=\"80%\" align=\"right\">"+
                          "<BUTTON class=btnNew onClick=\"addRow2(oTable"+rowindex+",fieldnum_"+rowindex+","+rowindex+");\"><%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></BUTTON><BUTTON class=btnDelete onClick=\"javascript:if(isdel()){deleteRow1(oTable"+rowindex+",'checkfield"+rowindex+"')};\"><%=SystemEnv.getHtmlLabelName(702,user.getLanguage())%></BUTTON>"+
                          "</td>"+
                        "</tr>"+
                        "<tr class=\"spacing\"><td class=\"line1\" colspan=\"2\"></td></tr>"+
                        "<tr>"+
                            "<td colspan=\"2\">"+
                                "<table Class=ListStyle id=\"oTable"+rowindex+"\" cols=3>"+
                                    "<COLGROUP>"+
                                    "<COL width=\"3%\">"+
                                    "<COL width=\"60%\">"+
                                    "<COL width=\"37%\">"+
                                    "<TBODY>"+
                                    "<tr class=header>"+
                                        "<td>&nbsp;</td>"+
                                        "<td><%=SystemEnv.getHtmlLabelName(20736,user.getLanguage())%></td>"+
                                        "<td><%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%></td>"+
                                    "</tr>"+
                                    "</TBODY>"+
                                "</table>"+
                            "</td>"+
                        "</tr>"+
                      "</tbody>"+
                  "</table>" ;
				break;
		}
        var oDiv = document.createElement("div");
        oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
    }
    form1.chkfields.value=form1.chkfields.value+",crmIds_"+rowindex;
    rowindex = rowindex*1 +1;
	form1.totalvalue.value = rowindex;
    dochange();
}

function addRow1(obj,tabletotal,recordexindex)
{
    tablerowindex=tabletotal.value;
    ncol = obj.cols;
    oRow = obj.insertRow();
    for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
        //oCell.style.background= "#EAEAEA";
        //oCell.className="Field";
        switch(j) {
			case 0:
				var sHtml = "<select name=\"tableid_"+recordexindex+"_"+tablerowindex+"\">"+
                 "<option value=\"\"></option>"+
                 <%
                     InputReportComInfo.setTofirstRow();
                     while(InputReportComInfo.next()){
                 %>
                 "<option value=\"<%=InputReportComInfo.getinprepid()%>\"><%=InputReportComInfo.getinprepname()%>(<%=InputReportComInfo.getinpreptablename()%>)</option>"+
                 <%
                      }
                 %>
                 "</select>";
				break;
			case 1:
                oCell.align="right";
                var sHtml = "<%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%>";
				break;
            case 2:
				var sHtml = "<input type=\"text\" class=inputstyle size=5 maxlength=2 name=\"tablealia_"+recordexindex+"_"+tablerowindex+"\" value=''>";
				break;
            case 3:
				var sHtml = "&nbsp;";
				break;
        }
        var oDiv = document.createElement("div");
        oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
    }
    tablerowindex = tablerowindex*1 +1;
	tabletotal.value = tablerowindex;
    dochange();
}

function addRow2(obj,fieldtotal,recordexindex)
{
    fieldrowindex=fieldtotal.value;
    ncol = obj.cols;
	oRow = obj.insertRow();
    for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
        oCell.className="Field";
        switch(j) {
			case 0:
				var sHtml = "<input type='checkbox' name='checkfield"+recordexindex+"' value=1>"+
                 "<input type='hidden' name='field"+recordexindex+"' value=1>";
				break;
			case 1:
                var sHtml = "<input type='text' class=inputstyle size=50 name='sourcefield"+recordexindex+"_"+fieldrowindex+"' value=''>";
				break;
            case 2:
				var sHtml = "<input type=\"text\" class=inputstyle  name=\"desfield"+recordexindex+"_"+fieldrowindex+"\" value=''>";
				break;
        }
        var oDiv = document.createElement("div");
        oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
    }
    fieldrowindex = fieldrowindex*1 +1;
	fieldtotal.value = fieldrowindex;
    dochange();
}

function deleteRow(obj,chkname)
{
    chks=document.getElementsByName(chkname);
    len = chks.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (chks[i].name==chkname)
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (chks[i].name==chkname){
			if(chks[i].checked==true) {
                var delid;
                if(obj.rows(rowsum1-1).cells(0).children.length>1){
                    delid=obj.rows(rowsum1-1).cells(0).children(0).value;
                }else{
                    delid=obj.rows(rowsum1-1).children(0).all(1).value;
                }
                var chkvalues=form1.chkfields.value.split(",");
                form1.chkfields.value="";
                for(var j=0;j<chkvalues.length;j++){
                    if(chkvalues[j]!="crmIds_"+delid){
                        if(form1.chkfields.value==""){
                            form1.chkfields.value=chkvalues[j];
                        }else{
                            form1.chkfields.value+=","+chkvalues[j];
                        }
                    }
                }
                obj.deleteRow(rowsum1-1);
                dochange();
            }
			rowsum1 -=1;
		}
	}
}

function deleteRow1(obj,chkname)
{
    chks=document.getElementsByName(chkname);
    len = chks.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (chks[i].name==chkname)
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (chks[i].name==chkname){
			if(chks[i].checked==true) {
				obj.deleteRow(rowsum1);
                dochange();
            }
			rowsum1 -=1;
		}
	}
}
function _initFileInput(){
	function _getPosition(o){
		var p1= o.offsetLeft,p2= o.offsetTop;
		do {
			o = o.offsetParent;
			p1 += o.offsetLeft;
			p2 += o.offsetTop;
		}while( o.tagName.toLowerCase()!="body");
		return {"x":p1,"y":p2};
	}
	var pos=_getPosition(document.getElementById('customExcel'));
	var oDiv=document.getElementById("fileDiv");
	oDiv.style.left=pos.x+"px";
	oDiv.style.top=pos.y+"px";
	//oDiv.style.width="80%"
	oDiv.style.display="inline";
}
window.attachEvent('onload',_initFileInput);
window.attachEvent('onresize',_initFileInput);

</script>
<script language="vbscript" type="text/vbscript">
Sub onShowBrowser2(inputId,spanId)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=<%=InputReportComInfo.getbillid(""+inprepId)%>")
	If isEmpty(id) Then Exit Sub
	
	If id(0)= 0 Then
		id(1) = ""
		id(0) = "0"
	End If
	spanId.innerHtml = id(1)
	inputId.value=id(0)
    dochange()
End Sub


Sub onShowCRM(inputname,spanname)
	Dim temp,id1
	temp = document.all(inputname).value
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+temp)
	If IsEmpty(id1) Then Exit Sub
		
	If (Len(id1(0)) > 500) Then
		Rem 500为表结构相关客户字段的长度
		result = msgbox("<%=SystemEnv.getHtmlLabelName(20738,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>")
		document.all(spanname).innerHtml =""
		document.all(inputname).value=""
        dochange() 
    ElseIf id1(0)<> "" Then
		resourceids = id1(0)
		resourcename = id1(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		document.all(inputname).value= resourceids
		resourcename = Mid(resourcename,2,len(resourcename))
		While InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href='/CRM/data/ViewCustomer.jsp?CustomerID="&curid&"' target='_blank'>"&curname&"</a>&nbsp"
		Wend
		sHtml = sHtml&"<a href='/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&"' target='_blank'>"&resourcename&"</a>&nbsp"
		document.all(spanname).innerHtml = sHtml
        dochange()
    Else
		document.all(spanname).innerHtml ="<img alt='!' src='/images/BacoError.gif' align='absMiddle'>"
		document.all(inputname).value=""
        dochange()
    End If
End Sub

</script>
</body></html>
