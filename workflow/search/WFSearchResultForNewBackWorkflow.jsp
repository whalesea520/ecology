
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="HomepageElementCominfo" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(20288,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<FORM id=weaver name=frmmain method=post action="WFSearchResultForNewBackWorkflow.jsp">



<%

String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String fromdate2 ="" ;
String todate2 ="" ;
String workcode ="" ;

String fromself =Util.null2String(request.getParameter("fromself"));
String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
String isfirst =Util.null2String(request.getParameter("isfirst"));


int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
if(fromself.equals("1")) {
	workflowid = Util.null2String(request.getParameter("workflowid"));
	nodetype = Util.null2String(request.getParameter("nodetype"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestlevel = Util.null2String(request.getParameter("requestlevel"));
	fromdate2 = Util.null2String(request.getParameter("fromdate2"));
	todate2 = Util.null2String(request.getParameter("todate2"));
    workcode = Util.null2String(request.getParameter("workcode"));
}
else {
	String eid=Util.null2String(request.getParameter("eid"));
	String strsqlwhere=HomepageElementCominfo.getStrsqlwhere(eid);
	String tempSqlWhereKey=Util.StringReplace(strsqlwhere,"^,^",",");
	if(!"".equals(tempSqlWhereKey)){
		fromselfSql=" t2.workflowtype in("+tempSqlWhereKey+")";
	}
}


String newsql="";


if(fromself.equals("1")) {
	if(!workflowid.equals(""))
		newsql+=" and t1.workflowid in("+workflowid+")" ;

	if(!nodetype.equals(""))
		newsql += " and t1.currentnodetype='"+nodetype+"'";


	if(!fromdate.equals(""))
		newsql += " and t1.createdate>='"+fromdate+"'";

	if(!todate.equals(""))
		newsql += " and t1.createdate<='"+todate+"'";

	if(!fromdate2.equals(""))
		newsql += " and t2.receivedate>='"+fromdate2+"'";

	if(!todate2.equals(""))
		newsql += " and t2.receivedate<='"+todate2+"'";

    if(!workcode.equals(""))
		newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%"+workcode+"%')";
    
    if(!createrid.equals("")){
		newsql += " and t1.creater='"+createrid+"'";
		newsql += " and t1.creatertype= '"+creatertype+"' ";
	}

	if(!requestlevel.equals("")){
		newsql += " and t1.requestlevel="+requestlevel;
	}

	if (!fromselfSql.equals("")){
		newsql += " and " + fromselfSql;
	}
}else{
	if (!fromselfSql.equals("")){
		newsql += " and " + fromselfSql;
	}
}


String userID = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2")) usertype= 1;

String sqlwhere="where t1.requestid = t2.requestid and t1.deleted<>1  ";
sqlwhere +=" "+newsql ;

String orderby = "t2.receivedate ,t2.receivetime";


int perpage=10;
boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =true;
boolean hasrequestname =true;
boolean hasreceivetime =true;
boolean hasstatus =true;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}
/*如果所有的列都不显示，那么就显示所有的，避免页面出错*/
if(!hascreatetime&&!hascreater&&!hasworkflowname&&!hasrequestlevel&&!hasrequestname&&!hasreceivetime&&!hasstatus&&!hasreceivedpersons&&!hascurrentnode){
	hascreatetime =true;
	hascreater =true;
	hasworkflowname =true;
	hasrequestlevel =true;
	hasrequestname =true;
	hasreceivetime =true;
	hasstatus =true;
	hasreceivedpersons =true;
	hascurrentnode =true;			
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>

<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<input type=hidden name=fromself value="<%=fromself%>">
<input type=hidden name=isfirst value="<%=isfirst%>">
<input type=hidden name=fromselfSql value="<%=fromselfSql%>">

<input type=hidden name=isovertime value="<%=isovertime%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="5">
  <col width="10%">
  <col width="20%">
  <col width="5%">
  <col width="10%">
  <col width="20">
  <tbody>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
     <button class=browser onClick="onShowWorkFlow('workFlowId','workflowspan')"></button>
	<span id=workflowspan>
	<%=WorkflowComInfo.getWorkflowname(workflowid)%>
	</span>
	<input name=workflowid type=hidden value="<%=workflowid%>">
    
    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=nodetype style=width:150>
     <option value="">&nbsp;</option>
     <option value="0" <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
    </td>
    <td>&nbsp;</td>
    <td ><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
	<td class=field>
	<select class=inputstyle  name=requestlevel style=width:140 size=1>
	  <option value=""> </option>
	  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</td>
  </tr>
  <TR><TD class=Line colSpan=8></TD></TR>
 <tr>

    <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
    <td class=field><BUTTON class=calendar id=SelectDate  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<BUTTON class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
      <SPAN id=todatespan ><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
    </td>

      <td>&nbsp;</td>
      <td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	  <td class=field>
	  <select class=inputstyle  name=creatertype>
<%if(!user.getLogintype().equals("2")){%>
	  <option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
<%}%>
	  <option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  </select>
	  &nbsp
	  <button class=browser onClick="onShowResource()"></button>
	<span id=resourcespan><% if(creatertype.equals("0")){%><%=ResourceComInfo.getResourcename(createrid)%><%}%>
    <% if(creatertype.equals("1")){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%><%}%></span>
	<input name=createrid type=hidden value="<%=createrid%>"></td>
	<td>&nbsp;</td>

    <td><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></td>
    <td class=field><BUTTON class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
      <SPAN id=fromdatespan2 ><%=fromdate2%></SPAN>
      -&nbsp;&nbsp;<BUTTON class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
      <SPAN id=todatespan2 ><%=todate2%></SPAN>
	  <input type="hidden" name="fromdate2" value="<%=fromdate2%>"><input type="hidden" name="todate2" value="<%=todate2%>">
	  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SEARCH_WFSEARCHRESULTFORNEWBACKWORKFLOW %>"/>
    </td>
  </tr> <TR><TD class=Line colSpan=8></TD></TR>
  <tr>

    <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
    <td class=field>
	  <input type="text" name="workcode" value="<%=workcode%>">
    </td>

      <td>&nbsp;</td>
      <td ></td>
	  <td >
	  </td>
	<td>&nbsp;</td>

    <td></td>
    <td>
    </td>
  </tr> <TR><TD class=Line colSpan=8></TD></TR>
  </tbody>
</table>

</form>


 <TABLE width="100%">
 
                 
                   
                    <tr>
                     
                      <td valign="top">                                                                                    
                          <%
                           String tableString = "";
                          
                            if(perpage <2) perpage=10;                                 
                        
                            String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime ";
                            String fromSql  = " from workflow_requestbase t1, ( select  workflowtype,receivedate,receivetime,requestid,viewtype,isreminded from workflow_currentoperator where id in( select max(id) from workflow_currentoperator " +
                            		"where needwfback=1 and viewtype=-1 and isremark in('2','4') and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1)+"  group by requestid) "+
					") t2 ";
                            String sqlWhere = sqlwhere;
                            if(RecordSet.getDBType().equals("oracle"))
                            {
                            	sqlWhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                            }
                            else
                            {
                            	sqlWhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                            }
                            String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage();
                            String para4=user.getLanguage()+"+"+user.getUID();                 
                         tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SEARCH_WFSEARCHRESULTFORNEWBACKWORKFLOW,user.getUID())+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                                                 "			<head>";
                          if(hascreatetime)
                                    tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          if(hascreater)
                                    tableString+="				<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                          if(hasworkflowname)
                                    tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                          if(hasrequestlevel)
                                    tableString+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                          if(hasrequestname)
                                    tableString+="				<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para2+"\"/>";
                          if(hascurrentnode)
                                    tableString+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                          if(hasreceivetime)
                                    tableString+="			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          if(hasstatus)
                                    tableString+="			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
                          if(hasreceivedpersons)
                                    tableString+="			    <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\"  otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";

                                    tableString+="			</head>"+   			
                                                 "</table>"; 
                      
                          %>
                          
                          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                      </td>
                    </tr>
                  </TABLE>

     
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
   %>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
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



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script language=vbs>
sub onShowResource()
	tmpval = document.all("creatertype").value
	if tmpval = "0" then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	end if
	if NOT isempty(id) then
	        if id(0)<> "" then
		resourcespan.innerHtml = id(1)
		frmmain.createrid.value=id(0)
		else
		resourcespan.innerHtml = ""
		frmmain.createrid.value=""
		end if
	end if

end sub
</script>

<SCRIPT language="javascript">

function OnSearch(){
        document.frmmain.fromself.value="1";
        document.frmmain.isfirst.value="1";
		document.frmmain.submit();
}


var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(requestid,returntdid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
	
    ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态
    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}

</script>
<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
