
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="recordSetCreateSegment" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
%>
<div id="editBox" class="editBox" style="display:none;">
	<div style="padding-top:10px;padding-bottom:10px;">
		<input name="workplanId" id="workplanId" type="hidden"/>
		<form action="" name="editBox">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}" >
					<wea:item>
            			<%=SystemEnv.getHtmlLabelName( 16094 ,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<select id="workPlanTypeSelect" name="workPlanTypeSelect" onchange="jQuery('#workPlanType').val(this.value)" style="width:90%">
							<option value="0"><%=SystemEnv.getHtmlLabelName( 15090 ,user.getLanguage())%> </option>
						</select>
						<INPUT type=hidden id="workPlanType" name="workPlanType" value="">
					</wea:item>
     				<wea:item>
						<%=SystemEnv.getHtmlLabelName( 229 ,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name="planName" id="planName" style="width:90%" class="InputStyle" style="" size="30" onblur="if(this.value)$(this).next().hide();else $(this).next().show()"/>
            			<img align="absmiddle" src="/images/BacoError_wev8.gif">
					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 433 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
            			<textarea id="description" name="description" rows="5" class="InputStyle" style="width: 90%;"></textarea>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 15525 ,user.getLanguage())%>
   					</wea:item>
					<wea:item>
						<brow:browser viewType="0" name="memberIDs" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="150px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
   					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 15534 ,user.getLanguage())%>
         			</wea:item>
					<wea:item>
						<select id="urgentLevel" class="styled" name="urgentLevel" style="width:80px;">
							<option value="1"><%=SystemEnv.getHtmlLabelName( 154 ,user.getLanguage())%> </option>
							<option value="2"><%=SystemEnv.getHtmlLabelName( 15533 ,user.getLanguage())%> </option>
							<option value="3"><%=SystemEnv.getHtmlLabelName( 2087 ,user.getLanguage())%> </option>
						</select>
         			</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 15148 ,user.getLanguage())%>
            		</wea:item>
					<wea:item>
						<table cellpadding="0" cellspacing="0">
							<tr>
								<td style="padding-left:0px;width:100px;" class="Field">
									<select class="styled" id="remindType" name="remindType" style="width:100px;" onchange="onChangeRemindType(this);">
										<option value="1"> <%=SystemEnv.getHtmlLabelName( 19782 ,user.getLanguage())%> </option>
										<option value="2"><%=SystemEnv.getHtmlLabelName( 22825,user.getLanguage())%> </option>
										<option value="3"><%=SystemEnv.getHtmlLabelName(  71 ,user.getLanguage())%> </option>
									</select>
								</td>
								<td class="Field">
									
						
								</td>
							</tr>
							<tr  id="remindInfo">
								<td class="Field" colspan=2>
									<table>
										<tr>
											<td class="Field">
												<input type="hidden" name="remindId"/>
												<input type="checkbox" name="remindBeforeStart" id="remindBeforeStart" value="1" />
												<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 19784 ,user.getLanguage())%> </span>
												<input style="width:30px!important" class="InputStyle" value="0" name="remindDateBeforeStart" id="remindDateBeforeStart"/>
												<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 391 ,user.getLanguage())%> </span>
												<input style="width:30px!important" class="InputStyle" value="10" name="remindTimeBeforeStart" id="remindTimeBeforeStart"/>
												<span style="valign:middle"> <%=SystemEnv.getHtmlLabelName( 15049 ,user.getLanguage())%></span>
											</td>
											
										</tr>
										<tr>
											<td class="Field">
												<input type="checkbox" name="remindBeforeEnd" id="remindBeforeEnd" value="1"/>
												<span><%=SystemEnv.getHtmlLabelName( 19785 ,user.getLanguage())%> </span>
												<input style="width:30px!important" value="0" class="InputStyle"   name="remindDateBeforeEnd" id="remindDateBeforeEnd" />
												<span><%=SystemEnv.getHtmlLabelName( 391 ,user.getLanguage())%> </span>
												<input style="width:30px!important" value="10" class="InputStyle"  name="remindTimeBeforeEnd" id="remindTimeBeforeEnd"/>
												<span><%=SystemEnv.getHtmlLabelName( 15049 ,user.getLanguage())%>  </span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 742 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
						<button type="button" class="Calendar" onclick="getTheDate('beginDate', 'beginDateSpan')"></button>
						<input type="hidden" name="beginDate"  id="beginDate"/>
						<span style="height: 16px;" id="beginDateSpan"></span>
						<button type="button" class="Calendar"  onclick="onWorkPlanShowTime('beginTimeSpan','beginTime')"></button>
						<input type="hidden" name="beginTime"  id="beginTime"/>
						<span id="beginTimeSpan">00-00</span>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 743 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
						<button type="button" class="Calendar"  onclick="getTheDate('endDate', 'endDateSpan')"></button>
						<input type="hidden" name="endDate"  id="endDate"/>
						<span id="endDateSpan">2012-01-09</span>
						<button type="button" class="Calendar" onclick="onWorkPlanShowTime('endTimeSpan','endTime')"></button>
						<input type="hidden" name="endTime"  id="endTime"/>
						<span id="endTimeSpan">23:59</span>
            		</wea:item>
            		<wea:item>
            			<%=SystemEnv.getHtmlLabelName( 783 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
						<brow:browser viewType="0" name="crmIDs" browserValue="" 
						browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="150px"
						completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
						browserSpanValue=""></brow:browser>
					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 857 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
						<brow:browser viewType="0" name="docIDs" browserValue="" 
						browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="150px"
						completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id=" 
						browserSpanValue=""></brow:browser>
					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 782 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
						<brow:browser viewType="0" name="projectIDs" browserValue="" 
						browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="%>'
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="150px"
						completeUrl="/data.jsp?type=18" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
						browserSpanValue=""></brow:browser>
					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 1044 ,user.getLanguage())%>
            		</wea:item>
            		<wea:item>
						<brow:browser viewType="0" name="requestIDs" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
						hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="150px" 
						completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
						browserSpanValue=""></brow:browser>
            		</wea:item>
				</wea:group>
			</wea:layout>
		</form>
	</div>
</div>
<SCRIPT language="JavaScript">
function onChangeRemindType(obj){
	if(obj.value!="1") {
		$('#remindInfo').show();
	} else {
		$('#remindInfo').hide();
	}
}
</SCRIPT>
