<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify,weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%
User user = HrmUserVarify.getUser(request,response);
String id = Util.null2String(request.getParameter("id"));
String isDialog = Util.null2String(request.getParameter("isDialog"));
String isUseFTPOfSystem = Util.null2String(request.getParameter("isUseFTPOfSystem"));
boolean canEdit = "true".equals(request.getParameter("canEdit"));
String groupAttrs2="{'groupDisplay':'none','itemAreaDisplay':'none'}"; 
String groupAttrs="{'groupDisplay':''}";  

						String isUseFTP="0";
						int FTPConfigId=0;
						String FTPConfigName="";
						String FTPConfigDesc="";
						String serverIP="";
						String serverPort="";
						String userName="";
						String userPassword="";
						String defaultRootDir="";
						int maxConnCount=0;
						float showOrder=0;

						RecordSet.executeSql("select * from DocSecCatFTPConfig where secCategoryId=" + id);
						if(RecordSet.next()){
							isUseFTP = Util.null2String(RecordSet.getString("isUseFTP"));
							FTPConfigId = Util.getIntValue(RecordSet.getString("FTPConfigId"),0);
						}

						if(FTPConfigId==0){
							DocFTPConfigComInfo.setTofirstRow();
							if(DocFTPConfigComInfo.next()){
								FTPConfigId=Util.getIntValue(DocFTPConfigComInfo.getId(),0);
							}
						}

						FTPConfigName = Util.null2String(DocFTPConfigComInfo.getFTPConfigName(""+FTPConfigId));
						FTPConfigDesc = Util.null2String(DocFTPConfigComInfo.getFTPConfigDesc(""+FTPConfigId));
						serverIP = Util.null2String(DocFTPConfigComInfo.getServerIP(""+FTPConfigId));
						serverPort = Util.null2String(DocFTPConfigComInfo.getServerPort(""+FTPConfigId));
						userName = Util.null2String(DocFTPConfigComInfo.getUserName(""+FTPConfigId));
						userPassword = Util.null2String(DocFTPConfigComInfo.getUserPassword(""+FTPConfigId));
						if(!userPassword.equals("")){
							userPassword="●●●●●●";
						}
						defaultRootDir = Util.null2String(DocFTPConfigComInfo.getDefaultRootDir(""+FTPConfigId));
						maxConnCount = Util.getIntValue(DocFTPConfigComInfo.getMaxConnCount(""+FTPConfigId),0);
						showOrder = Util.getFloatValue(DocFTPConfigComInfo.getShowOrder(""+FTPConfigId),0);
				%>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%>'  attributes='<%=!isDialog.equals("1")?groupAttrs:groupAttrs2 %>'>
					<wea:item type="groupHead">
						<a name="ftpconfig" id="ftpconfig">
					</wea:item>
					<wea:item>
						<INPUT type="hidden" name="isUseFTPOfSystem" value="<%=isUseFTPOfSystem%>">
						<%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%>
					</wea:item>
					<wea:item attributes="{\"colspan\":\"full\"}">
						<INPUT type="checkbox" id="isUseFTP" class=InputStyle name="isUseFTP" value="1" onclick="showFTPConfig()"  <%if("1".equals(isUseFTP)){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>>
					</wea:item>
					<%String attrs = "{\"isTableList\":true,'colspan':'full'"; %>
					<%
					attrs += ",\"samePair\":\"FTPConfigDiv\"";
					attrs += ",\"display\":\""+("1".equals(isUseFTP)?"":"none")+"\"}";
							%>
					<wea:item attributes='<%=attrs %>'>
							
							<wea:layout needImportDefaultJsAndCss="false">
								<wea:group context="" attributes="{'groupDisplay':'none'}">
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%></wea:item>
									<wea:item>
										 <SELECT class=inputstyle name="FTPConfigId" onChange="loadDocFTPConfigInfo(this)">
											<%
											DocFTPConfigComInfo.setTofirstRow();
											while(DocFTPConfigComInfo.next()){
											%>
												<OPTION value=<%= DocFTPConfigComInfo.getId() %> <% if(Util.getIntValue(DocFTPConfigComInfo.getId(),-1) == FTPConfigId) { %> selected <% } %> ><%= DocFTPConfigComInfo.getFTPConfigName() %></OPTION>
											<%
											}
											%>
										</SELECT>
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="FTPConfigNameSpan"><%=FTPConfigName%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="FTPConfigDescSpan"><%=FTPConfigDesc%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
									<wea:item> <SPAN id="serverIPSpan"><%=serverIP%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="serverPortSpan"><%=serverPort%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="userNameSpan"><%=userName%></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="userPasswordSpan"><%=userPassword%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="defaultRootDirSpan"><%=defaultRootDir%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></wea:item>
									<wea:item> <SPAN id="maxConnCountSpan"><%=maxConnCount%></SPAN></wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
									<wea:item><SPAN id="showOrderSpan"><%=showOrder%></SPAN></wea:item>
								</wea:group>
							</wea:layout>
					</wea:item>
				</wea:group>