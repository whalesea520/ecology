
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.docpile.DocPile" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%	
    //权限判断
    boolean canAllow = false ;
    if(HrmUserVarify.checkUserRight("docactiverep:View",user)){
        canAllow = true ;
    }
    String hrmId = Util.null2String(request.getParameter("hrmTxt")); 
   
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18923,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    String userType ="";     
    if (!canAllow) {
        hrmId = ""+user.getUID();
        userType =""+user.getLogintype();
    } else {
        userType="1";       
        if ("".equals(hrmId)){
            hrmId = ""+user.getUID();
        }
    }

    int docMarkTypeCount1 = DocPile.getDocMarkTypeCount("1",userType,hrmId);
    int docMarkTypeCount2 = DocPile.getDocMarkTypeCount("2",userType,hrmId);
    int docMarkTypeCount3 = DocPile.getDocMarkTypeCount("3",userType,hrmId);
    int docMarkTypeCount4 = DocPile.getDocMarkTypeCount("4",userType,hrmId);
    int docMarkTypeCount5 = DocPile.getDocMarkTypeCount("5",userType,hrmId);
    float totalCount = docMarkTypeCount1 +docMarkTypeCount2+docMarkTypeCount3+docMarkTypeCount4+docMarkTypeCount5 ;

    int tableSize = 400 ;
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
    if (canAllow){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmDpr.submit()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

     <TABLE width=100% height=100% border="0" cellspacing="0">
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
                <form name="frmDpr" method="post" action="DocPileRep.jsp">                       
                  <TABLE class="Shadow">
                    <tr>
                      <td valign="top">
                       <TABLE  class ="ViewForm">
                                <TBODY>
                                <colgroup>
                                <col width="20%">
                                <col width="80%">      
                                <%if (canAllow) {%>
                                    <TR  >
                                        <TD colspan="2" class="field"><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:&nbsp;&nbsp;
                                            <BUTTON class=Browser type="button" onclick="onShowHrm('hrmTxt','hrmSpan')"></BUTTON>      
                                            <SPAN ID=hrmSpan><%=ResourceComInfo.getResourcename(hrmId)%></SPAN>
                                            <INPUT type=hidden id="hrmTxt" name="hrmTxt" value="<%=hrmId%>">
                                        </TD>
                                    </TR>
                                    <TR style="height:2px"><TD  class=Line colspan="2"></TD></TR>
                                <%}%>
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18924,user.getLanguage())%></TD>
                                    <TD class="field"><%=DocPile.getDocAllDocCount()%><%=SystemEnv.getHtmlLabelName(15015,user.getLanguage())%></TD>
                                </TR>
                                <TR>
                                    <TD><%=ResourceComInfo.getResourcename(hrmId)%>&nbsp;<%=SystemEnv.getHtmlLabelName(18925,user.getLanguage())%></TD>
                                    <TD class="field"><%=DocPile.getCreatDocCount(userType,hrmId)%><%=SystemEnv.getHtmlLabelName(15015,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="showCreateSort()"><%=SystemEnv.getHtmlLabelName(18931,user.getLanguage())%>>>></a></TD>
                                </TR>
                                <TR style="height:2px"><TD  class=Line colspan="2"></TD></TR>
                                <TR>
                                    <TD><%=ResourceComInfo.getResourcename(hrmId)%>&nbsp;<%=SystemEnv.getHtmlLabelName(18926,user.getLanguage())%></TD>
                                    <TD class="field"><%=DocPile.getVisitDocCount(userType,hrmId)%>&nbsp;<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="showVisitSort()"><%=SystemEnv.getHtmlLabelName(18931,user.getLanguage())%>>>></a></TD>
                                </TR>
                               <TR style="height:2px"><TD  class=Line colspan="2"></TD></TR>
                                <TR>
                                    <TD><%=ResourceComInfo.getResourcename(hrmId)%>&nbsp;<%=SystemEnv.getHtmlLabelName(18927,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <TABLE width="100%">                                      
                                            <TR>                                                
                                                <TD>                                                
                                                    <TABLE>
                                                        <TR>
                                                            <TD>1&nbsp;<%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></TD>        
                                                            <TD class=redgraph width="<%=docMarkTypeCount1/totalCount*tableSize+1%>"></TD>
                                                            <TD><%=docMarkTypeCount1%>&nbsp;<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%></TD>
                                                        </TR>    
                                                    </TABLE>                                                
                                                </TD>   
                                             </TR>

                                               <TR>                                                
                                                <TD>                                                
                                                    <TABLE>
                                                        <TR>
                                                             <TD>2&nbsp;<%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></TD>                                                       
                                                             <TD class=redgraph width="<%=docMarkTypeCount2/totalCount*tableSize+1%>"></TD>
                                                            <TD><%=docMarkTypeCount2%>&nbsp;<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%></TD>
                                                        </TR>    
                                                    </TABLE>                                                
                                                </TD>   
                                             </TR>


                                             <TR>                                                
                                                <TD>                                                
                                                    <TABLE>
                                                        <TR>
                                                            <TD>3&nbsp;<%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></TD>                                                            
                                                            <TD class=redgraph width="<%=docMarkTypeCount3/totalCount*tableSize+1%>"></TD>
                                                            <TD><%=docMarkTypeCount3%>&nbsp;<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%></TD>
                                                        </TR>    
                                                    </TABLE>                                                
                                                </TD>   
                                             </TR>

                                              <TR>                                                
                                                <TD>                                                
                                                    <TABLE>
                                                        <TR>
                                                            <TD>4&nbsp;<%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></TD>                                                            
                                                            <TD class=redgraph width="<%=docMarkTypeCount4/totalCount*tableSize+1%>"></TD>
                                                            <TD><%=docMarkTypeCount4%>&nbsp;<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%></TD>
                                                        </TR>    
                                                    </TABLE>                                                
                                                </TD>   
                                             </TR>


                                               <TR>                                                
                                                <TD>                                                
                                                    <TABLE>
                                                        <TR>
                                                            <TD>5&nbsp;<%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></TD>                                                         
                                                            <TD class=redgraph width="<%=docMarkTypeCount5/totalCount*tableSize+1%>"></TD>
                                                            <TD><%=docMarkTypeCount5%>&nbsp;<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%></TD>
                                                        </TR>    
                                                    </TABLE>                                                
                                                </TD>   
                                             </TR>

                                        </TABLE>
                                    </TD>
                                </TR>
                                <TR style="height:2px"><TD  class=Line colspan="2"></TD></TR>
                                <TR>
                                    <TD><%=ResourceComInfo.getResourcename(hrmId)%>&nbsp;<%=SystemEnv.getHtmlLabelName(18930,user.getLanguage())%></TD>
                                    <TD class="field"><%=MathUtil.round(DocPile.getDocOfferRate(userType,hrmId)*100,2)%>%</TD>
                                </TR>
                                <TR style="height:2px"><TD  class=Line colspan="2"></TD></TR>
                        </TABLE>
                      </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
          </BODY>
        </HTML>

<SCRIPT LANGUAGE="JavaScript">
     function onShowHrm(inputname,spanname){
         var results = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
         if(results){
           if(results.id!=""){
	            jQuery("#"+inputname).val(results.id);
	            jQuery("#"+spanname).html(results.name);
           }else{
	            jQuery("#"+inputname).val("");
	            jQuery("#"+spanname).html("");
           }
         }
     }

     function showCreateSort(){
        window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docpile/DocCreateSort.jsp?hrmid=<%=hrmId%>");         
     }  
    
     function showVisitSort(){
        window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docpile/DocVisitSort.jsp?hrmid=<%=hrmId%>");         
     } 
 </SCRIPT>