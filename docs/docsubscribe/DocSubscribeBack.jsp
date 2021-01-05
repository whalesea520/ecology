
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
		response.sendRedirect("/docs/search/DocMain.jsp?urlType=9&ishow=false&"+request.getQueryString());
		return;
	}
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17715,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    //以下得搜索时的变量值
    String docTxt = Util.null2String(request.getParameter("docTxt"));
    String SubscriberTxt = Util.null2String(request.getParameter("SubscriberTxt"));    
    String subscribeDateFrom = Util.null2String(request.getParameter("subscribeDateFrom"));
    String subscribeDateTo = Util.null2String(request.getParameter("subscribeDateTo"));   

    //构建where语句
    String andSql="";
    if (!"".equals(docTxt)) andSql+=" and docid="+docTxt;
    if (!"".equals(SubscriberTxt)) andSql+=" and hrmid="+SubscriberTxt;
    if (!"".equals(subscribeDateFrom)) andSql+=" and subscribedate>='"+subscribeDateFrom+"'";
    if (!"".equals(subscribeDateTo)) andSql+=" and subscribedate<='"+subscribeDateTo+"'";      
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

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18666,user.getLanguage())+",javascript:onGetBack(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onSubscribeSearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(17713,user.getLanguage())+",javascript:onGoSubsHistory()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17714,user.getLanguage())+",javascript:onApprove()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onCleanAll()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td style="width:30%;">
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33243,user.getLanguage())%>" class="e8_btn_top"/>
			<input type="text" class="searchInput" name="flowTitle"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div id="tabDiv">
		<span id="hoverBtnSpan">
			<span id="history"><%=SystemEnv.getHtmlLabelName(17713,user.getLanguage()) %></span>
			<span   id="approve"><%=SystemEnv.getHtmlLabelName(17714,user.getLanguage()) %></span>
			<span class="selectedTitle" id="back"><%=SystemEnv.getHtmlLabelName(17715,user.getLanguage()) %></span>
		</span>
	</div>

    <TABLE width=100% height=100% border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td valign="top">  
                <form name="frmSubscribleGetBack" method="post" action="DocSubscribeBack.jsp" >
                <input type="hidden" name="operation">
                <input type="hidden" name="lastNumPage"> 
                <input type="hidden" name="nextUrl">                 
                  <TABLE class=Shadow cellpadding="0" cellspacing="0">
                    <tr>
                      <td valign="top">
                      <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
                         <!--搜索部分-->
                            <TABLE  class ="ViewForm" cellpadding="0" cellspacing="0">
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
                                        <input type="hidden" id="docTxt" name="docTxt" class="wuiBrowser" value="<%=docTxt%>"  _displayText="<%=DocComInfo.getDocname(docTxt)%>" 
                                        	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" 
                                        />
                                    </TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18665,user.getLanguage())%></TD>
                                    <TD class="field">
                                      
                                          <input type="hidden" id="SubscriberTxt" name="SubscriberTxt" class="wuiBrowser" value="<%=SubscriberTxt%>"  _displayText="<%=ResourceComInfo.getResourcename(SubscriberTxt)%>" 
                                        	_url="/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
                                        />
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
                                    <TD>&nbsp;</TD>
                                    <TD class="field">&nbsp;
                                    </TD>
                                </TR>        
                                <TR style="height: 1px"><TD class=Line colSpan=5></TD></TR>
								<tr>
									<td style="text-align:center;padding:5px;" colspan="8" class="field">
										<input type="button"  onclick="onSearch();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_submit"/>
										<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage()) %>" class="btn" id="cancel"/>
									</td>
								</tr>                        
                                </TBODY>
                                 
                            </TABLE>  
                            </div>
                         <!--列表部分-->
                          <%
                                //得到pageNum 与 perpage
                                int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                                int perpage = UserDefaultManager.getNumperpage();
                                if(perpage <2) perpage=10;
                                
                                //设置好搜索条件
                                String backFields ="a.id,a.docid,a.subscribedate,a.approvedate,a.searchcase,a.othersubscribe,a.subscribedesc,a.hrmid, a.subscribetype,b.id bid";
                                String fromSql = " docsubscribe a,DocDetail b";
                                String sqlWhere = " where a.ownertype="+user.getLogintype()+" and a.ownerId ="+user.getUID()+" and a.state=2 "+andSql+" and a.docId = b.id ";
                                String orderBy="subscribedate";

                                String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">"+
                                       "<browser returncolumn=\"docid\"/>"+
                                       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
                                       "<head>"+
                                             "<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                             "<col width=\"27%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\"  href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"  target=\"_fullwindow\" column=\"docid\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" column=\"approvedate\" orderkey=\"approvedate\"/>"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18665,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:subscribetype\"/>"+
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" column=\"subscribedesc\" orderkey=\"subscribedesc\"/>"+
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15774,user.getLanguage())+"\" column=\"searchcase\" orderkey=\"searchcase\"/>"+
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" column=\"othersubscribe\"  orderkey=\"othersubscribe\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNames\"/>"+
                                       "</head>"+
                                       "</table>";                                             
                              %>
                                            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
                      </td>
                    </tr>
                  </TABLE>  
                       <input type="hidden" name="subscribeIds">
                      <input type="hidden" name="docIds">
                  </form>
                </td>
              </tr>
            </table>
          </BODY>
        </HTML>
		
         <SCRIPT LANGUAGE="vbScript">
            sub onShowDoc(inputname,spanname)
                id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
                if Not isempty(id) then
                    inputname.value=id(0)&""
                    spanname.innerHtml = id(1)&""	
                end if	
            end sub

            sub onShowSubscriber(inputname,spanname)
                id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
                if Not isempty(id) then
                    inputname.value=id(0)&""
                    spanname.innerHtml = id(1)&""	
                end if	
            end sub
        </SCRIPT>

         <SCRIPT LANGUAGE="JavaScript">
        <!--        
			 
			 function onShowDoc(inputname,spanname){
				id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogHeight=535px;dialogWidth=505px;");
				if (id){
					inputname.value=id[0];
					jQuery(spanname).html(id[1]) ;
				}
			}

			function onShowSubscriber(inputname,spanname){
				id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
			   if(id) {
					inputname.value=id[0];
					jQuery(spanname).html(id[1]); 	
					
				}
			}
              function onSearch() {
                frmSubscribleGetBack.submit();
              }
              function onGetBack(obj) {                          
                frmSubscribleGetBack.operation.value="getback";       
                frmSubscribleGetBack.action="DocSubscribeOperate.jsp" ;                
                frmSubscribleGetBack.subscribeIds.value=_xtable_CheckedCheckboxId();
                frmSubscribleGetBack.docIds.value=_xtable_CheckedCheckboxValue();
                obj.disabled = true ;
                frmSubscribleGetBack.submit();;
              }
              
              function onSubscribeSearch(){
                  window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
              }

              function onGoSubsHistory() {
                window.location="/docs/docsubscribe/DocSubscribeHistory.jsp";
              }
              
              function onApprove() {
                window.location="/docs/docsubscribe/DocSubscribeApprove.jsp";
              }
               function onBack(){
                   window.history.go(-1);
              }           
              function onCleanAll(){
                 _xtable_CleanCheckedCheckbox();
              }
         
        //-->
        </SCRIPT>
        <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
        <SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
