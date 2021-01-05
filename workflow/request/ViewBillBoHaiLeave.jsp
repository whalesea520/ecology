
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo1" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page"/>
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="leaveTypeColorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
%>


<%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>

<%
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
%>

<form name="frmmain" method="post" action="BillBoHaiLeaveOperation.jsp" enctype="multipart/form-data" >

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="isbill" value="1">
<input type=hidden name="billid" value=<%=billid%>>
<input type=hidden name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
<input type=hidden name="f_weaver_belongto_usertype" value=<%=f_weaver_belongto_usertype%>>
<div>

<%if(canactive&&deleted==1){%>
<BUTTON class=btn accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%></button>
<%}%>
</div>
<%if (!fromFlowDoc.equals("1")  || isprint) {%>
<BR>
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->
<%}%>
<BR>
<table class="ViewForm">
	<colgroup> <col width="20%"> <col width="80%"> 
	<tr class="Spacing" style="height:1px;"> 
	  <td class="Line1" colspan=4></td>
	</tr>
	<tr> 
      <td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class="fieldvalueClass" colspan=3> 
      <%=Util.toScreen(requestname,user.getLanguage())%>
        <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">  
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span id=levelspan>
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      </span>
      </td>
    </tr>
	<tr class="Spacing" style="height:1px;"> 
	  <td class="Line2" colspan=4></td>
	</tr>
			<%
    	int rqMessageType=-1;
    	int wfMessageType=-1;
			String sqlWfMessage = "select a.messagetype,b.docCategory,b.messagetype as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
			RecordSet.executeSql(sqlWfMessage);
			if (RecordSet.next()) {
				wfMessageType=RecordSet.getInt("wfMessageType");
				rqMessageType=RecordSet.getInt("messagetype");
			}
			if(wfMessageType==1){
			%>
	<tr>

				<TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
				<td class=field colspan=3>
					<%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%><%}%>
		    	<%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%><%}%>
		    	<%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%><%}%>
		    </td>

	</tr>
    <tr class="Spacing" style="height:1px;">
      <td class="Line2" colspan=4></td>
    </tr>
         	<%}%>
<%
  Calendar today = Calendar.getInstance() ; 
  String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
  String currentWFCreater = creater+"";
  String leaveType = "";
  String getUserIdSQL = "select * from bill_bohaileave where requestid = '" + requestid + "' ";
  rs1.executeSql(getUserIdSQL);
  if(rs1.next()) {
	  currentWFCreater = Util.null2String(rs1.getString("resourceId"));
	  leaveType = Util.null2String(rs1.getString("newLeaveType"));
  }
  String userannualinfo = HrmAnnualManagement.getUserAannualInfo(currentWFCreater,currentdate);
  String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
  String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
  String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
  String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(""+currentWFCreater, currentdate,leaveType);
  String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
  String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
  String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
  String strleaveTypes = leaveTypeColorManager.getPaidleaveStr();
%>
<%
List fieldids=new ArrayList();
List fieldnames=new ArrayList();
List fieldvalues=new ArrayList();
List fieldlabels=new ArrayList();
List fieldhtmltypes=new ArrayList();
List fieldtypes=new ArrayList();
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
ArrayList fieldrealtype=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
		fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
}
RecordSet.executeSql("select * from Bill_BoHaiLeave  where id ="+billid);
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
}
String resourceId=Util.null2String(RecordSet.getString("resourceId"));
String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId));
float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];
if(freezeDays[1] > 0) allpsldays += " - "+freezeDays[1];
if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];

List isfieldids=new ArrayList();              //字段队列
List isviews=new ArrayList();
List isedits=new ArrayList();
List ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}
String fielddbtype="";                              //字段数据类型
int isfieldidindex=-1;
boolean showOtherLeaveType=false;
boolean showAnnualInfo=false;
boolean showPSLInfo=false;
boolean showPaidLeaveInfo=false;
boolean isShow = false;
String beginDate = currentdate ;			
for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldname=(String)fieldnames.get(i);	
	String fieldvalue=(String)fieldvalues.get(i);

    isfieldidindex = isfieldids.indexOf(fieldid) ;

    if( isfieldidindex == -1 ) {
		continue;
    }
    int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数
	String isview=(String)isviews.get(isfieldidindex);
	String isedit=(String)isedits.get(isfieldidindex);
	String ismand=(String)ismands.get(isfieldidindex);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	fielddbtype=(String)fieldrealtype.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(i),0);
	fieldimgheight=Util.getIntValue((String)fieldimgheights.get(i),0);
	fieldimgnum=Util.getIntValue((String)fieldimgnums.get(i),0);
	if(("newLeaveType").equals(fieldname)&&fieldvalue.equals(String.valueOf(HrmAttVacation.L6))){showAnnualInfo=true;}
	if(("newLeaveType").equals(fieldname)&&fieldvalue.equals(String.valueOf(HrmAttVacation.L12))){showPSLInfo = true;}
	if(("newLeaveType").equals(fieldname)&&fieldvalue.equals(String.valueOf(HrmAttVacation.L13))){showPaidLeaveInfo = true;}
	if(("newLeaveType").equals(fieldname)&&!"".equals(fieldvalue)&&strleaveTypes.indexOf(","+fieldvalue+",") > -1){showPSLInfo = true;}
	
	if(("fromDate").equals(fieldname)) {
		beginDate = fieldvalue ;
		if(StringUtils.isBlank(beginDate)){
			beginDate = currentdate ;
		}
	}
	
	if(isview.equals("1")){
		
%>

<%if(fieldhtmltype.equals("5")&&("otherLeaveType").equals(fieldname)&&!showOtherLeaveType){
%>
    <tr id=oTrOtherLeaveType style="display:none">
<%}else if(fieldname.equals("lastyearannualdays")||fieldname.equals("thisyearannualdays")||fieldname.equals("allannualdays")){%>
    <tr id="field<%=fieldid%>tr"  style='display:none'> 
<%}else if(fieldname.equals("lastyearpsldays")||fieldname.equals("thisyearpsldays")||fieldname.equals("allpsldays")){%>
    <tr id="field<%=fieldid%>tr"  style='display:none'> 
<%}else{%>
    <tr <%if(fieldname.equals("vacationInfo")){ if(showAnnualInfo || showPSLInfo || showPaidLeaveInfo) out.println("style='display:'"); else out.println("style='display:none'");}%>> 
<%}%>

      <%if(fieldhtmltype.equals("2")){%>
      <td class="fieldnameClass" valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td class="fieldnameClass"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class="fieldvalueClass" class=field> 
        <%
        if(fieldhtmltype.equals("1") || fieldhtmltype.equals("2") ){  // 单行,多行文本框
			if(fieldname.equals("lastyearannualdays")) out.println(lastyearannual); 
			else if(fieldname.equals("thisyearannualdays")) out.println(thisyearannual);
			else if(fieldname.equals("vacationInfo")) {
				if(showAnnualInfo) {
					String userannualinfoTemp = HrmAnnualManagement.getUserAannualInfo(currentWFCreater,beginDate);
					String thisyearannualTemp = Util.TokenizerString2(userannualinfoTemp,"#")[0];
					String lastyearannualTemp = Util.TokenizerString2(userannualinfoTemp,"#")[1];
					String allannualTemp = Util.TokenizerString2(userannualinfoTemp,"#")[2];
				%>
					<%=SystemEnv.getHtmlLabelName(21614,user.getLanguage())+"&nbsp;:&nbsp;"+lastyearannualTemp%><br><%=SystemEnv.getHtmlLabelName(21615,user.getLanguage())+"&nbsp;:&nbsp;"+thisyearannualTemp%><br><%=SystemEnv.getHtmlLabelName(21616,user.getLanguage())+"&nbsp;:&nbsp;"+allannualTemp%>
				<%} else if(showPSLInfo) {%>
					<%=SystemEnv.getHtmlLabelName(131649,user.getLanguage())+"&nbsp;:&nbsp;"+lastyearpsldays%><br><%=SystemEnv.getHtmlLabelName(131650,user.getLanguage())+"&nbsp;:&nbsp;"+thisyearpsldays%><br><%=SystemEnv.getHtmlLabelName(131651,user.getLanguage())+"&nbsp;:&nbsp;"+allpsldays%>
				<%} else if(showPaidLeaveInfo) {
					out.println(SystemEnv.getHtmlLabelName(82854,user.getLanguage())+"&nbsp;:&nbsp;"+paidLeaveDays);
				}
			}
			else if(fieldname.equals("allannualdays")) out.println(allannual);
			else if(fieldname.equals("lastyearpsldays")) out.println(lastyearpsldays); 
			else if(fieldname.equals("thisyearpsldays")) out.println(thisyearpsldays);
			else if(fieldname.equals("allpsldays")) out.println(allpsldays); 
			else if(fieldhtmltype.equals("1") && fieldtype.equals("4")){
      %>
            <TABLE cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                    <script language="javascript">
                     window.document.write(milfloatFormat(floatFormat(<%=fieldvalue%>)));
                    </script>
                </td></tr>
                <tr><td>
                    <script language="javascript">
                     window.document.write(numberChangeToChinese(<%=fieldvalue%>));
                    </script>
                </td></tr>
            </table>
      <%}else{%>
<%
	          if(fieldhtmltype.equals("2") && fieldtype.equals("2")){
%>
        <span style="word-wrap:break-word"><%=fieldvalue%></span>
<%
	          }else{
%>
        <span style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
<%
	          }
%>					
      <%}
	}		
	else if(fieldhtmltype.equals("3")){
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值
            String tablename=""; //浏览框对应的表,比如人力资源表
             String columname=""; //浏览框对应的表名称字段
             String keycolumname="";   //浏览框对应的表值字段
             if(fieldname.equals("manager")) linkurl = "";
            if(fieldtype.equals("2") || fieldtype.equals("19")){    // 日期和时间
      %>
        <%=fieldvalue%>
      <%
            } else if(!fieldvalue.equals("")) {
                ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl)||"/hrm/hrmTab.jsp?_fromURL=HrmResource&id=".equals(linkurl)){
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("161") || fieldtype.equals("162")){
                                                //自定义单选浏览框，自定义多选浏览框
									try{
												Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
                                                for(int k=0;k<tempshowidlist.size();k++){
													try{
                                                        BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
			                                            String desc=Util.null2String(bb.getDescription());
			                                            String name=Util.null2String(bb.getName());							showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
													}catch (Exception e){
													}
                                                }
										}catch (Exception e){
											}
                }
				else if(fieldtype.equals("160")){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                       if(!linkurl.equals("")){
                           showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//????
                       String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='javascript:createDoc("+fieldid+","+tempDoc+")' >"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp<button id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("+fieldid+","+tempDoc+")></button>";
                       
                        }
                        else
                        {
                        if(!linkurl.equals("") && !isprint){
                            //showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"&desrequestid="+desrequestid+"' target='_blank'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";

                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldtype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("16") || fieldtype.equals("152")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
//add by fanggsh for TD4528   20060621 begin
                else if(fieldtype.equals("141")){
                    //人力资源条件
					showname+=ResourceConditionManager.getFormShowName(fieldvalue,user.getLanguage());
                }
//add by fanggsh for TD4528   20060621 end
				else{
                    tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                    if(fieldvalue.indexOf(",")!=-1){
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }
                    RecordSet.executeSql(sql);
                    while(RecordSet.next()){
                        if(!linkurl.equals("") && !isprint){
                            showname += "<a href='"+linkurl+RecordSet.getString(1)+"' target='_new'>"+Util.toScreen(RecordSet.getString(2),user.getLanguage())+"</a>&nbsp";
                        }else{
                            showname +=Util.toScreen(RecordSet.getString(2),user.getLanguage())+" ";
                        }
                    }    // end of while
                }
            %>
                    <%=showname%>
          <%
            }
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <%
	}
	else if(fieldhtmltype.equals("5")){
String tmpName = "";
		if(("leaveType").equals(fieldname)&&fieldvalue.equals("4")){showOtherLeaveType=true;}//显示其它请假类型
        if(("otherLeaveType").equals(fieldname)&&fieldvalue.equals("2")&&showOtherLeaveType){showAnnualInfo=true;}//显示年假信息
		if(("otherLeaveType").equals(fieldname)&&fieldvalue.equals("11")&&showOtherLeaveType){showPSLInfo = true;}
	%>
        <select style="display: none" name="field<%=fieldid%>" DISABLED >
        <option value=""></option><!--added by xwj for td3297 20051130 -->
       <%
            // 查询选择框的所有可以选择的值
            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                if(fieldvalue.equals(tmpselectvalue)){tmpName=tmpselectname;}
       %>
        <option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
       <%
            }
       %>
        </select>
        <%=tmpName %>
        <%}
	else if(fieldhtmltype.equals("6")){
        %>
          <%
          if(!fieldvalue.equals("")) {
          //modify by xhheng @20050512 for 1803
          %>
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="50%" >
            <COL width="25%" >
            <COL width="25%">
            <%
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            int imgnum=fieldimgnum;
            boolean isfrist=false;
            RecordSet.executeSql(sql);
            while(RecordSet.next()){
              isfrist=false;  
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
                  isfrist=true;
              %>
            <tr>
                <td colSpan=3>
                    <table cellpadding="0" cellspacing="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table>
                      <tr>
                          <td align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>');return false;">
                          </td>
                      </tr>
                      <tr>
                              <%
                                  if (!isprint && !isurger && !wfmonitor) {
                              %>
                              <td align="center"><nobr><a href="#" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>';return false;" style="text-decoration:underline">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a></td>
                              <%}%>
                      </tr>
                        </table>
                    </td>
              <%}else{%>
              <tr>
              <td>
              <%=imgSrc%>
              <%if(isprint){%>
              <%=tempshowname%>
              <%}else{ if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&versionId=<%=versionId%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <!--<a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp-->
                <a href="javascript:addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}}%>
              </td>
              <%if(accessoryCount==1 && !isprint && !isurger && !wfmonitor){%>
              <td >
                <span id = "selectDownload">
                  <BUTTON class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
                </span>
              </td>
              <%}%>
              <td>&nbsp;</td>
              </tr>
              <%}}
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
              </tbody>
              </table>
              <%
            }
        }     // 选择框条件结束 所有条件判定结束
       else if(fieldhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }
%>
      </td>
    </tr>

<%if(fieldhtmltype.equals("5")&&("otherLeaveType").equals(fieldname)&&!showOtherLeaveType){
%>
    <tr class="Spacing"  id=oTrOtherLeaveTypeLine2 style="height:1px;" style="display:none">
      <td class="Line2" colspan=2></td>
    </tr>
<%}else if(fieldname.equals("lastyearannualdays")||fieldname.equals("thisyearannualdays")||fieldname.equals("allannualdays")){%>
    <tr class="Spacing" style="height:1px;" <%if(showAnnualInfo) out.println("style='display:block'"); else out.println("style='display:none'");%>>
      <td class="Line2" colspan=2></td>
    </tr>
<%}else if(fieldname.equals("lastyearpsldays")||fieldname.equals("thisyearpsldays")||fieldname.equals("allpsldays")){%>
    <tr class="Spacing" style="height:1px;" <%if(showPSLInfo) out.println("style='display:block'"); else out.println("style='display:none'");%>>
      <td class="Line2" colspan=2></td>
    </tr>
<%}else if(fieldname.equals("vacationInfo")){%>
    <tr class="Spacing" style="height:1px;" <%if(showAnnualInfo || showPSLInfo || showPaidLeaveInfo) out.println("style='display:'"); else out.println("style='display:none'");%>>
      <td class="Line2" colspan=2></td>
    </tr>
<%}else{%>
    <tr class="Spacing" style="height:1px;">
      <td class="Line2" colspan=2></td>
    </tr>
<%}%>


    <%
   }
}
%>     
  </table>
  <br>
  <br>
 <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>
 
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
function openAccessory(fileId){
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fileid="+fileId+"&requestid=<%=requestid%>");
}
</script>
</body>
</html>
