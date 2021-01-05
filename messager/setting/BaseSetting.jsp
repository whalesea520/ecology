
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MessagerSettingCominfo" class="weaver.messager.MessagerSettingCominfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />


<%  
	if(!HrmUserVarify.checkUserRight("Messages:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24127, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16261, user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <script language="javascript" src="/js/weaver_wev8.js"></script>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onSubmit(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
                <form name="frmMain" method="post" action="BaseSettingOpreate.jsp">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
                        <table class="ViewForm">
                            <colgroup>
                            <col width="20%">
                            <col width="80%">
                            
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24487, user.getLanguage())%></td>                               
                                <td class="field">																	
                                <input class='inputstyle' name="msgServerAddr" value="<%=MessagerSettingCominfo.getSettingValueByName("msgServerAddr")%>"  
                                 onchange='checkinput1("msgServerAddr","spanMsgServerAddr")' />
                                 	<span id="spanMsgServerAddr">
										<%
											if("".equals(MessagerSettingCominfo.getSettingValueByName("msgServerAddr"))){
												out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
											}
										%>
									</span>
                                
                                </td>
                            </tr>
                            <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
                            <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24488, user.getLanguage())%></td>
                                <td class="field">
                                	<%
                                	String msgRecordInterval=MessagerSettingCominfo.getSettingValueByName("msgRecordInterval");
                                	%>
                                	<select name="msgRecordInterval">
                                		<option value='no' <%if("no".equals(msgRecordInterval)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(24489, user.getLanguage())%></option>
                                		<option value='onemonth' <%if("onemonth".equals(msgRecordInterval)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(24490, user.getLanguage())%></option>
                                		<option value='threemonth' <%if("threemonth".equals(msgRecordInterval)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(24491, user.getLanguage())%></option>
                                		<option value='halfyear' <%if("halfyear".equals(msgRecordInterval)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(20729, user.getLanguage())%></option>
                                	</select>
                                </td>
                            </tr>
                            <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24492, user.getLanguage())%></td>
                                <td class="field">
                                	<%
                                	String accSaveDir=MessagerSettingCominfo.getSettingValueByName("accSaveDir");
                                	
                                	%>
                                	<button type=button  class="Browser" onClick="onShowCatalog('sapnAccSaveDir','accSaveDir')"></BUTTON>
								    <span id="sapnAccSaveDir">
								    <%
								    if(!"".equals(accSaveDir)){
								    	out.println(SecCategoryComInfo.getAllParentName(accSaveDir,true));
								    }
								    %>								    
								    </span>	
								    <br>(<%=SystemEnv.getHtmlLabelName(24493, user.getLanguage())%>)							    
                                   <input  type="hidden" class='inputstyle' name="accSaveDir" id="accSaveDir" value="<%=accSaveDir%>"/>
                                </td>
                            </tr>
                            <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
                            
                            <!-- 
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24496, user.getLanguage())%></td>
                                <td class="field">
                                	<%=SystemEnv.getHtmlLabelName(207, user.getLanguage())%>:<input name="MessageWindowHeight" style="width:30px" class="inputstyle" value="<%=MessagerSettingCominfo.getSettingValueByName("MessageWindowHeight")%>">px
                                	<%=SystemEnv.getHtmlLabelName(24497, user.getLanguage())%>:<input name="MessageWindowMaxHeight" length=3  style="width:30px" class="inputstyle" value="<%=MessagerSettingCominfo.getSettingValueByName("MessageWindowMaxHeight")%>">px
                                	<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>:<input name="MessageWindowWidth" length=3  style="width:30px" class="inputstyle" value="<%=MessagerSettingCominfo.getSettingValueByName("MessageWindowWidth")%>">px
                                </td>
                            </tr>
                            <TR><TD class=Line colSpan=6>
                            
                            
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24498, user.getLanguage())%></td>
                                <td class="field">
                                	<%=SystemEnv.getHtmlLabelName(207, user.getLanguage())%>:<input name="ChatWindowHeight" length=3  style="width:30px" class="inputstyle" value="<%=MessagerSettingCominfo.getSettingValueByName("ChatWindowHeight")%>">px
                                	<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>:<input name="ChatWindowWidth" length=3  style="width:30px" class="inputstyle" value="<%=MessagerSettingCominfo.getSettingValueByName("ChatWindowWidth")%>">px
                                </td>
                            </tr>
                            <TR><TD class=Line colSpan=6>
                             -->
                            
                            <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24494, user.getLanguage())%></td>
                                <td class="field"> 
									<input name="MaxUploadImageSize" id="MaxUploadImageSize" 
									  onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="ime-mode:Disabled"
									  onchange='checkinput1("MaxUploadImageSize","spanMaxUploadImageSize")'  style="width:30px" class="inputstyle" onkeypress="onMaxImageSizePress()" value="<%=MessagerSettingCominfo.getSettingValueByName("MaxUploadImageSize")%>">M
									<span id="spanMaxUploadImageSize">
										<%
											if("".equals(MessagerSettingCominfo.getSettingValueByName("MaxUploadImageSize"))){
												out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
											}
										%>
									</span>
                                </td>
                            </tr>
                            <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
                            
                            <%
                            int pingInterval = Util.getIntValue(Util.null2String(MessagerSettingCominfo.getSettingValueByName("PingInterval")),15000);
                            pingInterval = pingInterval/1000;
                            %>
                            <tr>
                                <td><%=SystemEnv.getHtmlLabelName(25524, user.getLanguage())%></td>
                                <td class="field"> 
									<input name="PingInterval" id="PingInterval" 
									  onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="ime-mode:Disabled" maxLength=6 size=6
									  onchange='checkinput1("PingInterval","spanPingInterval")'  style="width:30px" class="inputstyle" onkeypress="ItemCount_KeyPress()" value="<%=(pingInterval>0?pingInterval:0)%>">
									<span id="spanPingInterval">
										<%
											if(pingInterval<0){
												out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
											}
										%>
									</span>
                                </td>
                            </tr>
                            <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
                            
                         	<!-- 
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24499, user.getLanguage())%></td>
                                <td class="field">
                                	<input name="USE_DEBUGJID"   class="inputstyle"  value="<%=MessagerSettingCominfo.getSettingValueByName("USE_DEBUGJID")%>">                               	
                                </td>
                            </tr>
                            <TR><TD class=Line colSpan=6>
                            
                            
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24500, user.getLanguage())%></td>
                                <td class="field">                                	
                                	<input name="DebugLoginid"   class="inputstyle"  value="<%=MessagerSettingCominfo.getSettingValueByName("DebugLoginid")%>">                                	                               	
                                </td>
                            </tr>
                            <TR><TD class=Line colSpan=6>
                            
                            
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(24501, user.getLanguage())%></td>
                                <td class="field">                                	
                                	<input name="timerval"   class="inputstyle"  value="<%=MessagerSettingCominfo.getSettingValueByName("timerval")%>">                                	
                                </td>
                            </tr>
                            <TR><TD class=Line colSpan=6>
                             
                            
                            </TD></TR>-->
                        </table>
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
        <!--    
        function onShowCatalog(spanId,inputId) {
            var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
            if (result != null) {
                if (result != 0){
                  document.getElementById(spanId).innerHTML=wuiUtil.getJsonValueByIndex(result, 2);
                  document.getElementById(inputId).value=wuiUtil.getJsonValueByIndex(result, 1);

                }else{
               	  document.getElementById(spanId).innerHTML="";
                  document.getElementById(inputId).value="";
                }
            }
        }

        function onMaxImageSizePress(){            
        	if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)))){
        	     window.event.keyCode=0;
        	 }
        }

        function checkinput1(elementname,spanid){
        	var tmpvalue = document.all(elementname).value;

        	while(tmpvalue.indexOf(" ") >= 0){
        		tmpvalue = tmpvalue.replace(" ", "");
        	} 
        	if(tmpvalue != ""&&tmpvalue.substring(0,1) != "0"){
        		while(tmpvalue.indexOf("\r\n") >= 0){ 
        			tmpvalue = tmpvalue.replace("\r\n", "");
        		}
        		if(tmpvalue != ""){
        			document.all(spanid).innerHTML = "";
        		}else{
        			document.all(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        			document.all(elementname).value = "";
        		}
        	}else{
        		document.all(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        		document.all(elementname).value = "";
        	}
        }
              
          function onSubmit(obj){ 
        	  if(check_form( frmMain,"MaxUploadImageSize,msgServerAddr,PingInterval")){
       			obj.disabled = true; 
       			frmMain.submit();
       		 }       
          }

           function onBack(){ 
             window.history.go(-1);
          }
           function onResearch(){
              window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
          }         
        //-->
        </SCRIPT>