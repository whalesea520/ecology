
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String itemtype = Util.null2String(request.getParameter("itemtype"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

boolean canedit=false;
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}
if(!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
					<form id=weaver name=weaver action="/CRM/data/ShareOperation.jsp" method="post">
						<input type="hidden" id="method" name="method" value="add">
						<input type="hidden" id="CustomerID" name="CustomerID" value="<%=CustomerID%>">
						<input type="hidden" id="itemtype" name="itemtype" value="<%=itemtype%>">
						<input type="hidden" id="isfromtab" name="isfromtab" value="<%=isfromtab %>">
						<table class="viewlist" style="margin-top: 5px;">
        					<colgroup><col width="20%"/><col width="80%"/></colgroup>
        					<tbody>
        						<tr>
          							<td>
										<select id="sharetype" name="sharetype" onchange="onChangeSharetype()">
										  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
										  <option value="2" selected="selected"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
										  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
										  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
										</select>
		  							</td>
          							<td>
										<button type="button" class="btn_browser3" style="display:none" onclick="onShowResource('showrelatedsharename','relatedshareid')" id="showresource" name="showresource"></button> 
										<button type="button" class="btn_browser3" style="display:''" onclick="onShowDepartment('showrelatedsharename','relatedshareid')" id="showdepartment" name="showdepartment"></button> 
										<button type="button" class="btn_browser3" style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" id="showrole" name="showrole"></button>
 										<input type="hidden" id="relatedshareid" name="relatedshareid" value="<%=user.getUserDepartment()%>" />
 										<span id="showrelatedsharename" style="margin-left: 2px;"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
										<span id="showrolelevel" style="display: none;margin-left: 5px;"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
											<select id="rolelevel" name="rolelevel">
											  <option value="0" selected="selected"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
											  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
											  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
											</select>
										</span>
										<span id="showseclevel" style="margin-left: 5px;"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
										<input maxlength=3 size=5 id="shareseclevel" name="shareseclevel" onkeypress="ItemCount_KeyPress()" onblur="checknumber('shareseclevel');checkmyinput('shareseclevel','shareseclevelImage')" value="10" />
										</span>
										<span id="shareseclevelImage"></span>
		  							</td>
		  						</tr>
		  						<tr>		
          							<td><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
							        <td>
										<select id="sharelevel" name="sharelevel">
										  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
										  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
										</select>
									</td>		
								</tr>
								<tr>
									<td colspan="2" style="border-bottom: 0px;">
										<div class="sharebtn" onclick="cancelAddShare()">取消</div><div class="sharebtn" onclick="execAddShare()">保存</div>
									</td>
								</tr>
							</tbody>
	  					</table>
	  				</form>
	  					<script language=javascript>
  							function onChangeSharetype(){
								var thisvalue=$("#sharetype").val();
								$("#relatedshareid").val("");
								$("#showseclevel").show();
								$("#showrelatedsharename").html("<img src='/images/BacoError_wev8.gif' align='center'/>");

								if(thisvalue==1){
							 		$("#showresource").show();
									$("#showseclevel").hide();
									if($.trim($("#shareseclevel").val())==""){
										$("#shareseclevel").val('10');
									}
							        $("#shareseclevelImage").html('');
								}else{
									$("#showresource").hide();
									checkmyinput("shareseclevel","shareseclevelImage");
								}
								if(thisvalue==2){
							 		$("#showdepartment").show();
								}else{
									$("#showdepartment").hide();
								}
								if(thisvalue==3){
							 		$("#showrole").show();
									$("#showrolelevel").show();
								}else{
									$("#showrole").hide();
									$("#showrolelevel").hide();
							    }
								if(thisvalue==4){
									$("#showrelatedsharename").html("");
									$("#relatedshareid").val("-1");
								}
							}
 
						  	var opts={
									_dwidth:'550px',
									_dheight:'550px',
									_url:'about:blank',
									_scroll:"no",
									_dialogArguments:"",
									
									value:""
							};
							var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
							var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
							opts.top=iTop;
							opts.left=iLeft;
							function onShowDepartment(tdname,inputename){
								var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+document.all(inputename).value,
									"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
								if (data){
								    if(data.id!=""&&data.name!="0"){
									    $("#"+tdname).html(data.name);
									    $("#"+inputename).val(data.id);
								    }else{
								    	$("#"+tdname).html("<img src='/images/BacoError_wev8.gif' align='center'/>");
								    	$("#"+inputename).val("");
								    }
								}
							}
							function onShowResource(tdname,inputename){
								var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
										"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
								if (data){
								    if(data.id!=""&&data.name!="0"){
								    	$("#"+tdname).html(data.name);
									    $("#"+inputename).val(data.id);
								    }else{
								    	$("#"+tdname).html("<img src='/images/BacoError_wev8.gif' align='center'/>");
								    	$("#"+inputename).val("");
								    }
								}
							}
							function onShowRole(tdname,inputename){
								var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp",
										"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
								if (data){
								    if(data.id!=""&&data.name!="0"){
								    	$("#"+tdname).html(data.name);
									    $("#"+inputename).val(data.id);
								    }else{
								    	$("#"+tdname).html("<img src='/images/BacoError_wev8.gif' align='center'/>");
								    	$("#"+inputename).val("");
								    }
								}
							}
						</script>
