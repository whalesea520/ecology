
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause"
	scope="session" />
<jsp:useBean id="CustomerInfoComInfo"
	class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML>
	<head>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	</head>
	<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/request/requestAgentList.jsp,_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
		<%
String workflowid = Util.null2String(request.getParameter("workflowid"));
String allwfids = Util.null2String(request.getParameter("allwfids"));
String allwfids1 = Util.null2String(request.getParameter("allwfids1"));
String requestname = Util.null2String(request.getParameter("requestname"));
String agentorid = Util.null2String(request.getParameter("agentorid"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String agenttype = Util.null2String(request.getParameter("agenttype"));

String userID = String.valueOf(user.getUID());

//String newsql=" where t2.requestid=t1.requestid and t2.agenttype=2 and t2.agentorbyagentid="+userID+" and t2.isremark='2' ";
String newsql=" where t2.requestid=t1.requestid  and t2.agenttype='2' and t2.isremark='2' ";

if(!todate.equals("")) newsql += " and t2.operatedate<='"+todate+"' ";
if(!agenttype.equals("")) {
	if(agenttype.equals("2")) newsql += " and t2.agentorbyagentid ='"+userID+"' ";
	if(agenttype.equals("1")) newsql += " and t2.userid ='"+userID+"' ";
}else{ newsql += " and (t2.userid ='"+userID+"' or t2.agentorbyagentid ='"+userID+"') ";}
if(!fromdate.equals("")) newsql += " and t2.operatedate>='"+fromdate+"' ";
if(!requestlevel.equals("")) newsql += " and t1.requestlevel="+requestlevel+" " ;
if(!agentorid.equals("")) newsql += " and (t2.userid in ("+agentorid+") or t2.agentorbyagentid in ("+agentorid+")) ";
if(!requestname.equals("")) newsql += " and t1.requestname like '%"+requestname+"%' " ;
if(!workflowid.equals("")) newsql+=" and t2.workflowid="+workflowid+" " ;
else if(!allwfids.equals("") && !allwfids1.equals("")) newsql+=" and t2.workflowid in ("+allwfids+","+allwfids1+") " ;

int perpage=10;
%>

		<div id='divshowreceivied'
			style='background: #FFFFFF; padding: 3px; width: 100%' valign='top'>
		</div>
		<FORM id=weaver name=frmmain method=post
			action="requestDetailAgentList.jsp">
			<!-- 
<input type="hidden" id="allwfids" name="allwfids" value="<%=allwfids%>">
<input type="hidden" id="allwfids1" name="allwfids1" value="<%=allwfids1%>">
<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
 -->
			<table width=100% height=94% border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">

									<TABLE class=ViewForm>
										<TR>
											<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
												<TD CLASS="Field">
													<input type=text value="<%=requestname%>"

												name="requestname" class = "InputStyle" style="width:60%">
											</TD>

											<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(792,user.getLanguage())%></TD>
											<TD CLASS="Field">
												<!--<button  class=Browser  onclick="onShowMHrm('agentornamespan','agentorid')"></button>  -->
												 <!-- 在这个button里面加一个type="button" 2012-08-15 ypc 修改 -->
												<BUTTON type="button" class=Browser onclick="onShowMHrm('agentornamespan','agentorid')"></BUTTON>
												<span id="agentornamespan"> 
												<%
												if(!agentorid.equals("")){
													ArrayList agentors = Util.TokenizerString(agentorid,",");
													for(int i = 0; i < agentors.size(); i++){
											     %> <%=ResourceComInfo.getResourcename((String)agentors.get(i))%> <%
													}
													} %> </span>
												<input name="agentorid" type=hidden value="<%=agentorid%>">
											</TD>
										</TR>
										<!-- 给该行指定行高 用 % 比 做单位 2012-08-14 ypc 修改 -->
										<TR style="height: 5%;">
											<td colspan="4" class="line"></td>
										</TR>
										<TR>
											<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TD>
											<TD WIDTH="20%" CLASS="Field">
												<select class=inputstyle name=requestlevel
													style="width: 60%" size=1>
													<option value="">
													</option>
													<option value="0"
														<%if(requestlevel.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
													<option value="1"
														<%if(requestlevel.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
													<option value="2"
														<%if(requestlevel.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
												</select>
											</TD>
											<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(19680,user.getLanguage())%></TD>
											<TD width="20%" CLASS="Field">
												<!-- onclick="gettheDate(fromdate,fromdatespan)" class=calendar -->
												<!-- 此处以修改 start -->
												<!-- <BUTTON  id=SelectDate3 onclick="gettheDate(fromdate,fromdatespan)" class=calendar></BUTTON>-->

												<!--<SPAN id=fromdatespan><%=fromdate%></SPAN>-->
												<!-- -&nbsp;&nbsp;-->
												<!--class=calendar  onclick="gettheDate(todate,todatespan)" -->
												<!--  <BUTTON  id=SelectDate4   class=calendar  onclick="gettheDate(todate,todatespan)"></BUTTON>
												<SPAN id=todatespan><%=todate%></SPAN>
												<input type="hidden" name="fromdate" value="<%=fromdate%>">
												<input type="hidden" name="todate" value="<%=todate%>"> -->
												<!-- 此处以修改 end -->

												<!--2012-08-14 ypc 修改后 start -->

												<button type="button" id=SelectDate3 class=calendar
													onclick="gettheDate(fromdate,fromdatespan)"></button>
												<SPAN id=fromdatespan><%=fromdate%></SPAN> -&nbsp;&nbsp;
												<button type="button" id=SelectDate4 class=calendar
													onclick="gettheDate(todate,todatespan)"></button>
												<SPAN id=todatespan><%=todate%></SPAN>

												<input type="hidden" name="fromdate" value="<%=fromdate%>">
												<input type="hidden" name="todate" value="<%=todate%>">

												<!--2012-08-14 ypc 修改后 end -->
											</TD>
										</TR>
										<!-- 给该行指定行高 用 % 比 做单位 2012-08-14 ypc 修改 -->
										<TR style="height: 5%;">
											<td colspan="4" class="line"></td>
										</TR>
										<TR>
											<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(24535,user.getLanguage())%></TD>
											<TD WIDTH="20%" CLASS="Field">
												<select class=inputstyle name=agenttype style="width: 60%"
													size=1>
													<option value="">
													</option>
													<option value="2"
														<%if(agenttype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24536,user.getLanguage())%></option>
													<option value="1"
														<%if(agenttype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24537,user.getLanguage())%></option>
												</select>
											</TD>
										</TR>
									</TABLE>

									<TABLE width="100%">
										<tr>
											<td valign="top">
												<%
                          	String tableString = "";
                            String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype ";
                            String fromSql  = " from workflow_requestbase t1,workflow_currentoperator t2 ";
                            String sqlWhere = newsql;
                            int isovertime = 0;
                            String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage()+"+column:nodeid+column:isremark+"+userID+"+column:agentorbyagentid+column:agenttype";
                            String para4=user.getLanguage()+"+"+user.getUID();
                            String orderby="";
                                                                                
                            tableString ="<table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_REQUESTDETAILAGENTLIST,user.getUID())+"\" >"+
                                         "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                                         "<head>";
                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                            tableString+="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                            tableString+="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                            tableString+="<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""+para2+"\"/>";
                            tableString+="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                            tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                            tableString+="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
                            tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\"  otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
                            tableString+="</head></table>"; 
                          %>

												<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
											</td>
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
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_REQUESTDETAILAGENTLIST %>"/>
		</form>
	</body>
<!--  
<script language=vbs>
sub onShowResource()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
    if NOT isempty(id) then
        if id(0)<> "" then
            agentornamespan.innerHtml = id(1)
            frmmain.agentorid.value=id(0)
        else
            agentornamespan.innerHtml = ""
            frmmain.agentorid.value=""
        end if
    end if
end sub

sub onShowMHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
				end if
end sub
</script>-->

<!-- vbs转换过的 函数onShowMHrm() 2012-08-15 ypc 修改-->
<script language="javascript">
	function onShowMHrm(spanname,inputename){
	    tmpids = $GetEle(inputename).value
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids)
		if (data){
			if(data.id!=""){
				resourceids = data.id
				resourcename = data.name
				var sHtml = ""
				
				resourceids = resourceids.substring(1);
				$GetEle(inputename).value= resourceids
				resourcename = resourcename.substring(1);
				  var ids = resourceids.split(",");
				  var  names =resourcename.split(",");
				  for( var i=0;i<ids.length;i++){
				      if(ids[i]!=""){
				       sHtml = sHtml+"<a href='/hrm/resource/HrmResource.jsp?id="+ids[i]+"'>"+names[i]+"</a>&nbsp";
				      }
				 }
				$GetEle(spanname).innerHTML = sHtml
				
			}else{
				$GetEle(spanname).innerHTML =""
				$GetEle(inputename).value=""
			}
		}
	}
</script>
<SCRIPT language="javascript">
		function OnSearch(){
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
			//2012-08-14 ypc 修改 把此方法屏蔽掉
		    //showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
		    var ajax=ajaxinit();
			
		    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
		    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
		    //获取执行状态
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
