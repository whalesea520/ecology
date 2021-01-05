 
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>

<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <style type="text/css">
    	.tableField{
    		width:50%!important;
    	}
    </style>
</HEAD>

<BODY>
<%
//判断当前目录是否允许打分
String secId = Util.null2String(request.getParameter("secId"));

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
if (!DocMark.isAllowMark(secId)) return ;
session.putValue("secId",secId);

String docId = Util.null2String(request.getParameter("docId"));
String fromUrl = Util.null2String(request.getParameter("fromUrl"));
if("".equals(fromUrl)){
	fromUrl = "/docs/docmark/DocMarkAdd.jsp"+"?docId="+docId+"&secId="+secId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
} else {
	fromUrl = fromUrl+"?id="+docId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
}

int trHeight = 80;

int docMarkCount = DocMark.getDocMarkCount(docId); //打分的个数
int docMarkSum = DocMark.getDocMarkSum(docId);   //总分

double docMarkAve =MathUtil.round(DocMark.getDocMarkAve(docId),2);  //平均分

int markTypeCount1 =  DocMark.getMarkTypeCount(1,docId);
int markTypeCount2 =  DocMark.getMarkTypeCount(2,docId);
int markTypeCount3 =  DocMark.getMarkTypeCount(3,docId);
int markTypeCount4 =  DocMark.getMarkTypeCount(4,docId);
int markTypeCount5 =  DocMark.getMarkTypeCount(5,docId);
%>

<wea:layout attributes="{'cw1':'50%','cw2':'50%'}" >
<wea:group context="" attributes="{'groupDisplay':'none'}">
    <wea:item attributes="{'isTableList':'true','colspan':'half'}">
           <FORM   name="frmMark" action="/docs/docmark/DocMarkOperate.jsp">         
           <input type="hidden" name="fromUrl" value="<%=fromUrl%>">
           <input type="hidden" name="docId" value="<%=docId%>">
		    <input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>">
			 <input type="hidden" name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>">
            <input type="hidden" name="operate" value="add">
            <wea:layout needImportDefaultJsAndCss="false">
                <wea:group context="" attributes="{'groupDisplay':'none'}">
                	<wea:item attributes="{'colspan':'full'}"><%=SystemEnv.getHtmlLabelName(18991,user.getLanguage())%></wea:item>
					<wea:item attributes="{'colspan':'full'}">
							<TABLE  height="100%" style="background:transparent;">
                                  <TR> 
                                    <TD style="background:transparent;">&nbsp;</TD>
                                    <TD style="background:transparent;" align="center">1</TD>
                                    <TD style="background:transparent;" align="center">2</TD>
                                    <TD style="background:transparent;" align="center">3</TD>
                                    <TD style="background:transparent;" align="center">4</TD>
                                    <TD style="background:transparent;" align="center">5</TD>
                                    <TD style="background:transparent;" align="center">&nbsp;</TD>
                                 </TR>
                                  <TR>
                                    <TD style="background:transparent;"><%=SystemEnv.getHtmlLabelName(18992,user.getLanguage())%></TD>
                                    <TD style="background:transparent;"><input name="rdoMark" type="radio" value="1"></TD>
                                    <TD style="background:transparent;"><input name="rdoMark" type="radio" value="2"></TD>
                                    <TD style="background:transparent;"><input name="rdoMark" type="radio" value="3"></TD>
                                    <TD style="background:transparent;"><input name="rdoMark" type="radio" value="4"></TD>
                                    <TD style="background:transparent;"><input name="rdoMark" type="radio" value="5"></TD>
                                    <TD style="background:transparent;"><%=SystemEnv.getHtmlLabelName(18993,user.getLanguage())%></TD>
                                 </TR>
                            </TABLE> 
                    </wea:item>
                    <wea:item attributes="{'colspan':'full'}">
                        <%=SystemEnv.getHtmlLabelName(18994,user.getLanguage())%><br>
                        <br>
                        <TEXTAREA NAME="remark" ROWS="3" COLS="70" style="InputStyle"></TEXTAREA> 
                        <br>
                    </wea:item>
				</wea:group>
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" class="e8_btn_submit"  accesskey=S onClick="onMarkSubmit()" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>"></input>
	                </wea:item>
                </wea:group>
            </wea:layout>
            </FORM>
        </wea:item>
        <wea:item attributes="{'isTableList':'true','colspan':'half'}">
            <wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'colspan':'full'}"><%=SystemEnv.getHtmlLabelName(18995,user.getLanguage())%>:<%=docMarkSum%> <%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%>　<%=SystemEnv.getHtmlLabelName(18996,user.getLanguage())%>:<%=docMarkAve%> <%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></wea:item>
					<wea:item attributes="{'colspan':'full'}">
							<Table>
								<tr  valign="bottom" height="<%=trHeight%>">
									<td style="text-align:center;">
									<Table border="0" width="20" cellspacing="0" cellpadding="0">                                
									<tr><td><font color="#FF0099"><%=markTypeCount1%></font></td></tr>
									</Table>
									</td>
									<td width="1">&nbsp;<td>

									<td style="text-align:center;">                                
									<Table border="0" width="20" cellspacing="0" cellpadding="0">                                
									<tr><td><font color="#FF0099"><%=markTypeCount2%></font></td></tr>
									</Table>
									</td>
									<td width="1">&nbsp;<td>

									<td style="text-align:center;">                                
									<Table border="0" width="20" cellspacing="0" cellpadding="0">                                
									<tr><td><font color="#FF0099"><%=markTypeCount3%></font></td></tr>
									</Table>
									</td>
									<td width="1">&nbsp;<td>


									<td style="text-align:center;">                                
									<Table border="0" width="20" cellspacing="0" cellpadding="0">                                
									<tr><td><font color="#FF0099"><%=markTypeCount4%></font></td></tr>
									</Table>
									</td>
									<td width="1">&nbsp;<td>


									<td style="text-align:center;">                                
									<Table border="0" width="20" cellspacing="0" cellpadding="0">                                
									<tr><td><font color="#FF0099"><%=markTypeCount5%></font></td></tr>
									</Table>
									</td>
									<td width="1">&nbsp;<td>
								   

								</tr>
								<tr align="center">
									<td>1</td>
									<td width="1">&nbsp;<td>
									<td>2</td>
									<td width="1">&nbsp;<td>
									<td>3</td>
									<td width="1">&nbsp;<td>
									<td>4</td>
									<td width="1">&nbsp;<td>
									<td>5</td>
									<td width="1">&nbsp;<td>
								</tr>
							</Table>
						</wea:item>               
					<wea:item attributes="{'colspan':'full'}">
					<%=SystemEnv.getHtmlLabelName(18998,user.getLanguage())%> <%=docMarkCount%> <%=SystemEnv.getHtmlLabelName(18999,user.getLanguage())%>
					<br/><br/>
					<TEXTAREA ROWS="3" readOnly="readonly" disabled="disabled" style="overflow:hidden;border:1px solid transparent!important;background:transparent;" COLS="70" class="InputStyle"></TEXTAREA>
					<br/>
					</wea:item>
				</wea:group>
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" class="e8_btn_submit"  accesskey=S onClick="openLogView()" value="<%=SystemEnv.getHtmlLabelName(18997,user.getLanguage())+">>>"%>"></input>
	                </wea:item>
                </wea:group>
            </wea:layout>
        </wea:item>
	</wea:group>
</wea:layout>
</BODY>
</HTML>

 <SCRIPT LANGUAGE="JavaScript">
    <!--  
     function openLogView(){
        //window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docmark/DocMarkLogView.jsp?docId=<%=docId%>");
        dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docmark/DocMarkLogView.jsp?docId=<%=docId%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("30041,6072",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();         
     }  
    
     function onMarkSubmit(){
         if (!frmMark.rdoMark[0].checked&&!frmMark.rdoMark[1].checked&&!frmMark.rdoMark[2].checked&&!frmMark.rdoMark[3].checked&&!frmMark.rdoMark[4].checked) {
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19000,user.getLanguage())%>");
         } else {
            frmMark.submit();
         }
     }
     //-->
     jQuery(document).ready(function(){
	     jQuery(".e8_btn_submit").hover(function(){
			jQuery(this).addClass("e8_submit_btnHover");
		},function(){
			jQuery(this).removeClass("e8_submit_btnHover");
		});
	});
 </SCRIPT>