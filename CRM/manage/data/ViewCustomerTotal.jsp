
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


String CustomerID = Util.null2String(request.getParameter("CustomerID"));
int userid = user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

//TD5394
/**
String mailAddress = "";
String mailAddressContacter = "";
RecordSet.executeSql("SELECT email FROM CRM_CustomerContacter WHERE customerid="+CustomerID+"");
while(RecordSet.next()){
	mailAddressContacter = Util.null2String(RecordSet.getString("email"));
	if(!mailAddressContacter.equals("")){
		mailAddress += mailAddressContacter + ",";
	}
}*/



DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setCrmid(CustomerID);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();

//get cowork count

int allCount = CoworkDAO.getAllCoworkCountByCustomerID(CustomerID);
int canViewCount = CoworkDAO.getCoworkCountByCustomerID(userid,CustomerID);


//get request count

int tempid=Util.getIntValue(CustomerID,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(userid);
RelatedRequestCount.setUsertype(usertype);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("crm");
RelatedRequestCount.selectRelatedCount();


//get crm count
SearchComInfo1.resetSearchInfo();
SearchComInfo1.setcustomer(CustomerID);

String Prj_SearchSql="";
String prjcount="0";
Prj_SearchSql = "select count(*) from Prj_ProjectInfo  t1,PrjShareDetail t2 "+SearchComInfo1.FormatSQLSearch(user.getLanguage()) +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
RecordSet.executeSql(Prj_SearchSql);
if(RecordSet.next()){
	prjcount = ""+RecordSet.getInt(1);
}
String Creater = "";
String CreaterType = "";
String CreateDate = "";
RecordSet.executeProc("CRM_Find_Creater",CustomerID);
if(RecordSet.first()){
	Creater = Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	CreaterType = Util.toScreen(RecordSet.getString("submitertype"),user.getLanguage());
	CreateDate = RecordSet.getString("submitdate");
}

String Modifier = "";
String ModifierType = "";
String ModifyDate = "";
//RecordSet.executeProc("CRM_Find_LastModifier",CustomerID); Modified by xwj for td:1242 on 2005-03-16
String sqlModifier = "select submiter,submitdate,submitertype,submittime from CRM_Log " +
"where customerid ='" + CustomerID + "' and logtype <> 'n' and submitdate = (select max(submitdate) from CRM_Log where customerid ='" + CustomerID + "' and logtype <> 'n') " +
"order by submittime desc";
RecordSet.executeSql(sqlModifier);
if(RecordSet.first()){
	Modifier = Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	ModifierType = Util.toScreen(RecordSet.getString("submitertype"),user.getLanguage());
	ModifyDate = RecordSet.getString("submitdate");
}
RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

String bankName = RecordSet.getString("bankName");
String accountName = RecordSet.getString("accountName");
String accounts = RecordSet.getString("accounts");
String crmCode = RecordSet.getString("crmcode");
String customerName = RecordSet.getString("name");

//TD5394
/**
mailAddress = RecordSet.getString("email") +","+ mailAddress;
if(mailAddress.endsWith(",")) mailAddress=mailAddress.substring(0, mailAddress.length()-1);
*/

/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;
boolean isCustomerSelf=false;
boolean isCreater=false;
boolean canApply=false; //是否可以申请级别状态的变化
boolean canApplyPortal=false; //是否可以申请门户状态的变化
boolean canApplyPwd=false; //是否可以申请门户密码变化
boolean canApproveLevel=false; //是否可以批准级别变化
boolean canApprovePortal=false; //是否可以批准门户状态变化
boolean canApprovePwd=false; //是否可以批准门户密码变化

String levelMsg = ""; //级别申请中的显示信息
String portalMsg = ""; //门户申请中的显示信息
String portalPwdMsg = ""; //门户密码申请中的显示信息

String isrequest = Util.null2String(request.getParameter("isrequest")); //客户审批描述
String requestid = Util.null2String(request.getParameter("requestid")); //客户审批描述
requestid = requestid.equals("")?requestid="-1":requestid;
boolean hasApply = false;
boolean hasApplyPortal = false;
boolean hasApplyPwd = false;

String levelstatus = "";
String portalstatus = "";
String portalstatus2 = "";
String portalpwdstatus = "";
String levelMenu = "";
String portalMenu = "";
String portalpwdMenu = "";



RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=1 and status<>'1' and approveid="+CustomerID);
if(RecordSetV.next()){
    levelMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    levelstatus = RecordSetV.getString("status");
    hasApply = true;
}
RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=2 and status<>'1' and approveid="+CustomerID);
if(RecordSetV.next()){
    portalMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    portalstatus = RecordSetV.getString("status");
    hasApplyPortal = true;
}
RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=3 and status<>'1' and approveid="+CustomerID);
if(RecordSetV.next()){
    portalPwdMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    portalpwdstatus = RecordSetV.getString("status");
    hasApplyPwd = true;
}


    if(isrequest.equals("1")){
        canApproveLevel=hasApply;
        canApprovePortal=hasApplyPortal;
        canApprovePwd=hasApplyPwd;
    }

    //取得客户审批工作流的信息
    String approveid= "" ;
    String approvetype= "" ;
    String approvevalue = "";
    String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where requestid="+requestid;
    //System.out.println("sql = " + sql);
    RecordSetV.executeSql(sql);
    if(RecordSetV.next()){
        approveid=RecordSetV.getString("approveid");
        approvetype=RecordSetV.getString("approvetype");
        approvevalue = RecordSetV.getString("approvevalue");

    }
    //System.out.println("approvevalue = " + approvevalue);


//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 canviewlog=true;
//	 canmailmerge=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;
//		canapprove=true;
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}

if(useridcheck.equals(RecordSet.getString("agent"))) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

if((RecordSet.getString("manager")).equals(""+ResourceComInfo.getManagerID(RecordSet.getString("manager")))){
	canapprove=true;
}


if((RecordSet.getString("manager")).equals(useridcheck)){
	isCreater=true;
    if(!hasApply){
        canApply=true; //只有客户的经理才可以申请升级、降级以及冻结和解冻操作
    }
    if(!hasApplyPortal){
        canApplyPortal = true; //只有客户的经理才可以申请开放门户、以及冻结和解冻操作
    }
    if(!hasApplyPwd){
        canApplyPwd = true; //只有客户的经理才可以申请重新生成密码
    }
}

/*check right end*/

portalstatus2 =  Util.getIntValue(RecordSet.getString("PortalStatus"),0)+"";
boolean onlyview=false;
if(!canview && !isCustomerSelf && !CoworkDAO.haveRightToViewCustomer(Integer.toString(userid),CustomerID)){
    if(!WFUrgerManager.UrgerHaveCrmViewRight(Util.getIntValue(requestid),userid,Util.getIntValue(logintype),CustomerID) && !WFUrgerManager.getMonitorViewObjRight(Util.getIntValue(requestid),userid,""+CustomerID,"1")){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }else{
        onlyview=true;
    }
}

RecordSetC.executeProc("CRM_Find_CustomerContacter",CustomerID);

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

//写viewlog表
String needlog = Util.null2String(request.getParameter("log"));
if(!needlog.equals("n"))
{
char flag=Util.getSeparator() ;
String clientip=request.getRemoteAddr();
RecordSetLog.executeProc("CRM_ViewLog1_Insert",CustomerID+""+flag+userid+""+flag+user.getLogintype()+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);
}


CustomerModifyLog.deleteCustomerLog(Util.getIntValue(CustomerID,-1),user.getUID());
%>


<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(647,user.getLanguage())+" - "+Util.toScreen(customerName,user.getLanguage());

String temStr="";

   /* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- begin ----------*/
if(!Creater.equals(""))	{
	temStr+="<B>"+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>"+ResourceComInfo.getClientDetailModifier(Creater,CreaterType,user.getLogintype())+"<B> "+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>";
	temStr+=CreateDate+"； ";
}
if(!Modifier.equals("")){
	temStr+="<B>"+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>"+ResourceComInfo.getClientDetailModifier(Modifier,ModifierType,user.getLogintype())+"<B> "+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":</B>";
	temStr+=ModifyDate+"； ";
}

 /* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- end ----------*/

titlename += "  "+temStr;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


	  <TABLE class=ViewForm cellpadding="0" cellspacing="0">
        <TBODY>
        <br>
        <TR class=Title>
        	<!-- TODO -->
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=5></TD>
		</TR>
                          <TR>
                              <TD colSpan=4>
                               <TABLE class="ViewForm">
								<COLGROUP> <COL width="30%"> <COL width="70%">
                                  <TBODY>
                                  
									<%if(!user.getLogintype().equals("2")){%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="#" onclick="urlForward('/CRM/data/ContractList.jsp?CustomerID=<%=CustomerID%>')"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
										</TD>
									</TR>

									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<%}%>
									<%if(!user.getLogintype().equals("2")){%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></TD>
										<TD class=Field>
										  <a href="#" onclick="urlForward('/fna/report/expense/FnaExpenseCrmDetail.jsp?crmid=<%=CustomerID%>&custoridss=1')"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<%}%>

									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
										<TD class=Field>
										<a href="#" onclick="urlForward('/proj/search/SearchOperation.jsp?customer=<%=CustomerID%>')"><%=prjcount%></a>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>


									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="#" onclick="urlForward('/docs/search/DocSearchTemp.jsp?crmid=<%=CustomerID%>&docstatus=6')"><%=doccount%></a>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<%if(!user.getLogintype().equals("2")){%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="#" onclick="urlForward('/cowork/coworkview.jsp?CustomerID=<%=CustomerID%>&type=all')"><%=allCount%></a>(<%=(allCount-canViewCount)%>个不可见)
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<%}%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="#" onclick="urlForward('/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=0')"><%=RelatedRequestCount.getCount0()%></A>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="#" onclick="urlForward('/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=1')"><%=RelatedRequestCount.getCount1()%></A>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="#" onclick="urlForward('/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=2')"><%=RelatedRequestCount.getCount2()%></A>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(553,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="#" onclick="urlForward('/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=3')"><%=RelatedRequestCount.getCount3()%></A>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="#" onclick="urlForward('/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>')"><%=RelatedRequestCount.getTotalcount()%></a>
										</TD>
									</TR>
									<tr  style="height: 1px"><td class=Line colspan=2> </TD></TR>
                                  </TBODY>
                                </TABLE>
                              </TD>
                            </TR>
					     </TBODY>
		</TABLE>

<script language=vbs>

sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
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
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub
</script>
<script language=javascript>
 function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}

function urlSubmit(obj,url){
    obj.disabled= true;
    location=url;
}

function doAddWorkPlan() {
	document.location.href = "/workplan/data/WorkPlan.jsp?crmid=<%=CustomerID%>&add=1";
}

//add by ws 2010-12-01
function urlForward(url){
    var left = (screen.availWidth-800)/2;
    var top = (screen.availHeight-600)/2;
    window.open(url,'','width=800,height=600,left='+left+',top='+top+',scrollbars=no,resizable=yes');
}


</script>

</BODY>
</HTML>



