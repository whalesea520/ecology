
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docSubscribeExt_wev8.js"></script>
<%
	if(true){
		response.sendRedirect("/docs/search/DocMain.jsp?urlType=7&ishow=false&"+request.getQueryString());
		return;
	}
	 
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17713,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    //以下得搜索时的变量值
    String docTxt = Util.null2String(request.getParameter("docTxt"));
    String owenerTxt = Util.null2String(request.getParameter("owenerTxt"));    
    String subscribeDateFrom = Util.null2String(request.getParameter("subscribeDateFrom"));
    String subscribeDateTo = Util.null2String(request.getParameter("subscribeDateTo"));
    String approveDateFrom = Util.null2String(request.getParameter("approveDateFrom"));
    String approveDateTo = Util.null2String(request.getParameter("approveDateTo"));
    String currentState = Util.null2String(request.getParameter("currentState"));

    //构建where语句
    String andSql="";
    if (!"".equals(docTxt)) andSql+=" and docid="+docTxt;
    if (!"".equals(owenerTxt)) andSql+=" and ownerid="+owenerTxt;
    if (!"".equals(subscribeDateFrom)) andSql+=" and subscribedate>='"+subscribeDateFrom+"'";
    if (!"".equals(subscribeDateTo)) andSql+=" and subscribedate<='"+subscribeDateTo+"'";
    if (!"".equals(approveDateFrom)) andSql+=" and approvedate>='"+approveDateTo+"'";
    if (!"".equals(approveDateTo)) andSql+=" and approvedate<='"+approveDateTo+"'";
    if (!"".equals(currentState)) andSql+=" and state="+currentState;
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onSubscribeSearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(17714,user.getLanguage())+",javascript:onApprove()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17715,user.getLanguage())+",javascript:onBackSubscrible()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	
	<div id="tabDiv">
		<span id="hoverBtnSpan">
			<span class="selectedTitle" id="history"><%=SystemEnv.getHtmlLabelName(17713,user.getLanguage()) %></span>
			<span id="approve"><%=SystemEnv.getHtmlLabelName(17714,user.getLanguage()) %></span>
			<span id="back"><%=SystemEnv.getHtmlLabelName(17715,user.getLanguage()) %></span>
		</span>
	</div>

    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td valign="top">  
                
                  <TABLE class=Shadow  cellpadding="0" cellspacing="0">
                    <tr>
                      <td valign="top">
                      <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
                      <form name="frmSubscribleHistory" method="post" action="">
                         <!--搜索部分-->
                            <TABLE  class ="ViewForm"  cellpadding="0" cellspacing="0">
                             
                                <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="15%">
                                <col width="30%">
                                </colgroup>
                                   <TBODY>
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <button type="button" class=Browser onclick="onShowDoc(docTxt,docSpan)"></BUTTON>      
                                        <SPAN ID=docSpan><%=DocComInfo.getDocname(docTxt)%></SPAN>
                                        <INPUT type=hidden id="docTxt" name="docTxt" value="<%=docTxt%>">
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18656,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <button type="button" class=Browser onclick="onShowOwener(owenerTxt,owenerSpan)"></BUTTON>      
                                        <SPAN ID=owenerSpan><%=ResourceComInfo.getResourcename(owenerTxt)%></SPAN>
                                        <INPUT type=hidden id="owenerTxt" name="owenerTxt" value="<%=owenerTxt%>">
                                    </TD>
                                </TR>
                                 <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                                 <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18657,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <button type="button" class=calendar  onclick="gettheDate(subscribeDateFrom,subscribeDateFromSpan)"></BUTTON>
                                         <SPAN id=subscribeDateFromSpan ><%=subscribeDateFrom%></SPAN>
                                          -
                                         <button type="button" class=calendar onclick="gettheDate(subscribeDateTo,subscribeDateToSpan)"></BUTTON>
                                         <SPAN id=subscribeDateToSpan ><%=subscribeDateTo%></SPAN>

                                         <input type="hidden" name="subscribeDateFrom" value="<%=subscribeDateFrom%>">
                                         <input type="hidden" name="subscribeDateTo" value="<%=subscribeDateTo%>">
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18658,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <button type="button" class=calendar  onclick="gettheDate(approveDateFrom,approveDateFromSpan)"></BUTTON>
                                         <SPAN id=approveDateFromSpan ><%=approveDateFrom%></SPAN>
                                          -
                                         <button type="button" class=calendar onclick="gettheDate(approveDateTo,approveDateToSpan)"></BUTTON>
                                         <SPAN id=approveDateToSpan ><%=approveDateTo%></SPAN>

                                         <input type="hidden" name="approveDateFrom" value="<%=approveDateFrom%>">
                                         <input type="hidden" name="approveDateTo" value="<%=approveDateTo%>">
                                    </TD>
                                </TR>
                                <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                                 <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <SELECT NAME="currentState">
                                            <OPTION value=""  <%if (currentState.equals("")){%> selected<%}%>>&nbsp;</OPTION>
                                            <OPTION value="1" <%if (currentState.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%></OPTION>
                                            <OPTION value="2" <%if (currentState.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18660,user.getLanguage())%></OPTION>
                                            <OPTION value="3" <%if (currentState.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18661,user.getLanguage())%></OPTION>  
                                        </SELECT>
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD>&nbsp;</TD>
                                    <TD class="field"></TD>
                                </TR>
                                 <TR style="height: 1px"><TD class=Line colSpan=5></TD></TR>
								<tr>
									<td style="text-align:center;padding:5px;" colspan="8" class="field">
										<input type="button" onclick="onSearch();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_submit"/>
										<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage()) %>" class="btn" id="cancel"/>
									</td>
								</tr>
                                </TBODY>
                            </TABLE>  
                             </form>
                            </div>
                         <!--列表部分-->
                          <%
                                //得到pageNum 与 perpage
                                int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                                int perpage = UserDefaultManager.getNumperpage();
                                if(perpage <2) perpage=10;
                                
                                //设置好搜索条件
                                String backFields ="id,docid,subscribedate,approvedate,state,ownerid,othersubscribe,subscribedesc,ownerType";
                                String fromSql = " docsubscribe";
                                String sqlWhere = " where hrmid ="+user.getUID()+andSql;
                                String orderBy="subscribedate";
                                
                                String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">"+
                                       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
                                       "<head>"+
                                             "<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                             "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" column=\"docid\" otherpara=\"column:state\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" column=\"subscribedate\" orderkey=\"subscribedate\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18658,user.getLanguage())+"\" column=\"approvedate\" orderkey=\"approvedate\"/>"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"state\" orderkey=\"state\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubscribeStats\"  otherpara=\""+user.getLanguage()+"\"/>"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(2094,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:ownerType\"/>"+
                                             "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" column=\"othersubscribe\" otherpara=\"column:state\" orderkey=\"othersubscribe\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubscribes\"/>"+
                                             "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" column=\"subscribedesc\" orderkey=\"subscribedesc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getSubscribedesc\" />"+
                                       "</head>"+
                                       "</table>";                                             
                              %>             
                                            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
                       
                      </td>
                    </tr>
                  </TABLE>  
                 
                </td>
              </tr>
            </table>
            
          </BODY>
        </HTML>
		  <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
          <SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
 

         <SCRIPT LANGUAGE="JavaScript">
        <!--           
			
			function onShowDoc(inputname,spanname){
               data = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogHeight=535px;dialogWidth=505px;")
			
                if (data){
                    if(data.id!=""){
	                    inputname.value=data.id;
	                    jQuery(spanname).html(data.name) ;
                    }else{
                    	 inputname.value="";
                         jQuery(spanname).html("") ;
                    }
                }
            }
			
            function onShowOwener(inputname,spanname){
            	data = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");

                if (data){
                    if(data.id!=""){
	                    inputname.value=data.id;
	                    jQuery(spanname).html(data.name) ;
                    }else{
                    	 inputname.value="";
                         jQuery(spanname).html("") ;
                    }
                }
            }
              function onSearch() {
                frmSubscribleHistory.submit();
              }
              
              function onSubscribeSearch(){
                  window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
              }

              function onApprove() {
                window.location="/docs/docsubscribe/DocSubscribeApprove.jsp";
              }
              
              function onBackSubscrible() {
                window.location="/docs/docsubscribe/DocSubscribeBack.jsp";
              }
               function onBack(){
                   window.history.go(-1);
              }
         
        //-->
        </SCRIPT>
