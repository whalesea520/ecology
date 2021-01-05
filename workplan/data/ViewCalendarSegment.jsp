
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<DIV id="workPlanViewSplash" style="display:none" data="">
<input type="hidden" name="workplanIdView" id="workplanIdView">
<div >
    <div style="padding-top:10px;padding-bottom:10px;">
            <wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}" >
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 16094 ,user.getLanguage())%>
					</wea:item>
     				<wea:item>
     					<span id="workplanTypeView"></span>
     				</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 229 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="planNameView"></span>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 433 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<div id="descriptionView" style="word-break:break-all;"></div>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 15525 ,user.getLanguage())%>
					</wea:item>
   					<wea:item>
   						<span id="memberView"></span>
   					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 15534 ,user.getLanguage())%>
					</wea:item>
         			<wea:item>
         				<span id="urgentLevelView"></span>
         			</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 15148 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
						<table>
							<tr>
								<td class="Field">
									<SPAN ID="remindTypeName"> </SPAN>
								</td>
								<td class="Field" id="remindTimeDescriptionView">
									<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 19784 ,user.getLanguage())%> </span>:&nbsp;
									<span id="remindDateBeforeStartView"></span>
									<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 391 ,user.getLanguage())%> </span>&nbsp;
									<span id="remindTimeBeforeStartView"></span>
									<span style="valign:middle"> <%=SystemEnv.getHtmlLabelName( 15049 ,user.getLanguage())%></span>&nbsp;
								</td>
							</tr>
						</table>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 742 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="beginDateTimeView"></span>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 743 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="endDateTimeView"></span>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 783 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="crmView"></span>
            		</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 857 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="docView"></span>
					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 782 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="projectView"></span>
					</wea:item>
            		<wea:item>
						<%=SystemEnv.getHtmlLabelName( 1044 ,user.getLanguage())%>
					</wea:item>
            		<wea:item>
            			<span id="requestView"></span>
            		</wea:item>
            	</wea:group>
			</wea:layout>
        </form>
    </div>
    </div>
</DIV>
