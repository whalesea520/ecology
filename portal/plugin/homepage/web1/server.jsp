
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util"%>  
<%@ page import="weaver.general.TimeUtil"%>  
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.portal.PortalMenu" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	int leftid = Util.getIntValue((request.getParameter("leftid")),0);

	//System.out.println("leftid:"+leftid);
	String method = Util.null2String((request.getParameter("method")));
	
	if("navinfo".equals(method)){		
		PortalMenu pmenu=(PortalMenu)session.getValue("pmenu");
		String srcUrl=pmenu.getMenuAddress(leftid);
		String srcNav=pmenu.getMenuNav(leftid);
		out.println(srcNav);
		return;
	} else if("getChild".equals(method)){
		int parentid= Util.getIntValue((request.getParameter("mainMenuId")),0);

		MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
		rs=mu.getMenuRs(parentid);
		String s="";
		ArrayList menuIds=new ArrayList();
		while(rs.next()){
			boolean hasSubMenu = false;
			int infoid=rs.getInt("infoid");
			
			if(infoid==1 || infoid==10  || infoid==26 ||  infoid==27 ||  infoid==19) continue;
		 
			//TD4425=========================================
			if(menuIds.contains(String.valueOf(infoid))) continue;
			menuIds.add(String.valueOf(infoid));
			//===============================================
			
			int labelId = rs.getInt("labelId");
			
			boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
			String customName = rs.getString("customName");
			String customName_e = rs.getString("customName_e");
			String customName_t = rs.getString("customName_t"); 
			 
			
			boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true	: false;
			String infoCustomName = rs.getString("infoCustomName");
			String infoCustomName_e = rs.getString("infoCustomName_e");
			String infoCustomName_t = rs.getString("infoCustomName_t");
			String baseTarget = rs.getString("baseTarget");
			if("".equals(baseTarget)) baseTarget="mainFrame";
			
			
			String text = mu.getMenuText(labelId, useCustomName, customName, customName_e,customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());		
			
			//System.out.println("text:"+text);

			String sql = "SELECT id FROM MainMenuInfo WHERE parentid="+infoid;
			rs2.executeSql(sql);
			if(rs2.next()) hasSubMenu=true;
			
			String linkAddress=Util.replace(rs.getString("linkAddress"), "&", "&#38;", 0);

		
			String subSpanStyle="";
			String mainMenuId="";
			if(hasSubMenu){
				subSpanStyle="spanRight";
				mainMenuId=infoid+"";
			}else{
				subSpanStyle="spanRightNone";
				mainMenuId="";
			}
			%>
			<li>
				<div>
					<span class="spanLeft">
						<a onclick="javascript:onLeftMenuClick(this,'<%=infoid%>','<%=linkAddress%>','<%=baseTarget%>','<%=mainMenuId%>')" style="cursor:hand">
							<img border="0" src="images/entitysub_wev8.jpg" />
							<%=text%>
						</a>
					</span>

					<span onclick="showorhidden(this,'<%=mainMenuId%>')" class="<%=subSpanStyle%>">6</span>
				</div>
			</li>

		<%}				
	} else if("news".equals(method)){	
		rs.executeSql("select * from newstype order by dspnum,id");
		while (rs.next()){
	%>
		<li>
				<div>
					<span class="spanLeft">
						<a onclick="javascript:onLeftMenuClick(this,'','','mainFrame','')" style="cursor:hand">
							<img border="0" src="images/entitysub_wev8.jpg" />
							<%=rs.getString("typename")%>
						</a>
					</span>

					
		 		

	<% 
			String strSql="select  id,frontpagename from DocFrontpage where isactive='1' and publishtype=1 and newstypeid="+rs.getString("id")+" order by typeordernum,id";
			rs2.executeSql(strSql);
			boolean isFirst=true;
			String subSpanStyle="";
			if(rs2.getCounts()>0){
				subSpanStyle="spanRight";
			} else {
				subSpanStyle="spanRightNone";
			}
			%>
				<span onclick="showorhidden(this,'')" class="<%=subSpanStyle%>">6</span>
				</div>
		 

			<%while (rs2.next()){
				if(isFirst) {
					out.println("<ul>");
					isFirst=false;
				}
			%> 
			
				<li>
					<div>
						<span class="spanLeft">
							<a onclick="javascript:onLeftMenuClick(this,'','/docs/news/NewsDsp.jsp?id=<%=rs2.getString("id")%>','mainFrame','')" style="cursor:hand">
								<img border="0" src="images/entitysub_wev8.jpg" />
								<%=rs2.getString("frontpagename")%>
							</a>
						</span>

						<span onclick="showorhidden(this,'')" class="spanRightNone">6</span>
					</div>
			  </li>
			<%}
			  if(!isFirst) out.println("</ul>");
		}	
	%>	
		 </li>
				
		<li>
				<div>
					<span class="spanLeft">
						<a onclick="javascript:onLeftMenuClick(this,'','','mainFrame','')" style="cursor:hand">
							<img border="0" src="images/entitysub_wev8.jpg" />
							<%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%>
						</a>
					</span>
	<%
		String strSql="select id,frontpagename from DocFrontpage where isactive='1' and publishtype=1 and (newstypeid=0 or newstypeid is null) order by typeordernum,id";
		rs2.executeSql(strSql);
		boolean isFirst=true;
		String subSpanStyle="";
		if(rs2.getCounts()>0){
			subSpanStyle="spanRight";
		} else {
			subSpanStyle="spanRightNone";
		}
		%>
			<span onclick="showorhidden(this,'')" class="<%=subSpanStyle%>">6</span>
			</div>
	 

		<%while (rs2.next()){
			if(isFirst) {
				out.println("<ul>");
				isFirst=false;
			}
		%>	
			<li>
				<div>
					<span class="spanLeft">
						<a onclick="javascript:onLeftMenuClick(this,'','/docs/news/NewsDsp.jsp?id=<%=rs2.getString("id")%>','mainFrame','')" style="cursor:hand">
							<img border="0" src="images/entitysub_wev8.jpg" />
							<%=rs2.getString("frontpagename")%>
						</a>
					</span>

					<span onclick="showorhidden(this,'')" class="spanRightNone">6</span>
				</div>
		  </li>
		<%}
			if(!isFirst) out.println("</ul> </li>");
	}else if("remind".equals(method)){	
			String strSql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+user.getUID()+"  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+user.getUID()+"  and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+user.getUID()+" and usertype='"+user.getUID()+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+user.getUID()+" and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and workflow_currentoperator.isremark in ('0','1','8','9','7')) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3'))  or isremark='5') and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1 and (t1.coworkers like '%,"+user.getUID()+",%' or t1.creater="+user.getUID()+") and t1.isnew not like '%,"+user.getUID()+",%'))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
			rs.executeSql(strSql);
			while(rs.next()){
				String strCount="";
				if(rs.getString("statistic").equals("y")){   
				   int count=rs.getInt("count");
				   strCount="("+count+")";
				}else{
					strCount="";

				}%>
				<li>
						<div>
							<span class="spanLeft">
								<a onclick="javascript:onLeftMenuClick(this,'','<%=rs.getString("link")%>','mainFrame','')" style="cursor:hand">
									<img border="0" src="images/entitysub_wev8.jpg" />
									<%=SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+strCount%>
								</a>
							</span>

							<span onclick="showorhidden(this,'')" class="spanRightNone">6</span>
						</div>
				  </li>
			<%}



	}else if("voting".equals(method)){	
		String CurrentDate=TimeUtil.getCurrentDateString();
		String CurrentTime=TimeUtil.getOnlyCurrentTimeString();
		//String strSql = "SELECT DISTINCT t1.id,t1.subject FROM voting t1,VotingShareDetail t2 WHERE t1.id=t2.votingid AND t2.resourceid="+user.getUID()+" AND t1.status=1 AND t1.id NOT IN (SELECT DISTINCT votingid FROM votingresource WHERE resourceid="+user.getUID()+")"+" and t1.beginDate<='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"')   ";
		String strSql ="SELECT DISTINCT t1.id,t1.subject  from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+user.getUID()+" and t1.status=1 "+ " and t1.id not in (select distinct votingid from votingresource where resourceid ="+user.getUID()+")" 
+" and (t1.beginDate<'"+CurrentDate+"' or (t1.beginDate='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"'))) "; 
		rs.executeSql(strSql);
		//System.out.println(strSql);
		while(rs.next()){
		%>
			<li>
				<div>
					<span class="spanLeft">
						<a onclick="javascript:onLeftMenuClick(this,'','/voting/VotingPoll.jsp?votingid=<%=rs.getInt("id")%>','mainFrame','')" style="cursor:hand">
							<img border="0" src="images/entitysub_wev8.jpg" />
							<%=rs.getString("subject")%>
						</a>
					</span>

					<span onclick="showorhidden(this,'')" class="spanRightNone">6</span>
				</div>
		   </li>
			
		<%}
	}
	%>


	