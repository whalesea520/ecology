
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
<BODY>

<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String needfav = "1";
	String needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(19027 , user.getLanguage());

	String userRights = ReportAuthorization.getUserRights("-1", user);//得到用户查看范围
    if ("-100".equals(userRights)) {
	    response.sendRedirect("/notice/noright.jsp");
		return;
    }

	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
	String workflowname="";
	String exportSQL="";

    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList workflowcountst=new ArrayList();     //总计流程类型
	ArrayList nodeTypes=new ArrayList();           //节点类型
    ArrayList newremarkwfcounts0=new ArrayList(); //草稿总数
    ArrayList newremarkwfcounts1=new ArrayList(); //待批准

    ArrayList newremarkwfcounts2=new ArrayList(); //待提交

    ArrayList newremarkwfcounts3=new ArrayList();  //归档
    ArrayList wftypecounts0=new ArrayList(); //草稿总数总计
    ArrayList wftypecounts1=new ArrayList(); //待批准总计
    ArrayList wftypecounts2=new ArrayList(); //待提交总计
    ArrayList wftypecounts3=new ArrayList();  //归档总计
    ArrayList wftypess=new ArrayList();
    int totalcount=0;
    String sqlCondition="";
    String fromdate = Util.null2String(request.getParameter("fromdate"));
    String todate = Util.null2String(request.getParameter("todate"));

    String fromdateOver = Util.null2String(request.getParameter("fromdateOver"));
    String todateOver = Util.null2String(request.getParameter("todateOver"));

	String search = Util.null2String(request.getParameter("search"));
  
    String requestParam="fromdate="+fromdate+"&todate="+todate+"&fromdateOver="+fromdateOver+"&todateOver="+todateOver+"&search="+search;
    //创建日期 
    if (userRights.equals(""))
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    //if (!"search".equals(search)) {
	//	sqlCondition += " and 1=2";
	//}
    if(!fromdate.equals("")){
		sqlCondition+=" and workflow_requestbase.createdate>='"+fromdate+"'";
	}
	if(!todate.equals("")){
		sqlCondition+=" and workflow_requestbase.createdate<='"+todate+"'";
	}
	//归档日期
	if (!todateOver.equals("")||!todateOver.equals(""))
	{
	 sqlCondition+=" and workflow_requestbase.currentnodetype='3' ";
	}
	if(!fromdateOver.equals("")){
	sqlCondition+=" and workflow_requestbase.lastoperatedate>='"+fromdateOver+"'";
	}
	
	if(!todateOver.equals("")){
		sqlCondition+=" and workflow_requestbase.lastoperatedate<='"+todateOver+"'";
	}
    String sql="select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  currentnodetype,"+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and workflow_currentoperator.workflowtype>1  "+sqlCondition+" group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,currentnodetype "+
    " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	//System.out.println("=================================>sql:"+ sql);
	recordSet.executeSql(sql) ;
	while(recordSet.next()){       
        String theworkflowid = Util.null2String(recordSet.getString("workflowid")) ;  
        String theworkflowtype = Util.null2String(recordSet.getString("workflowtype")) ;
        int nodetype=Util.getIntValue(recordSet.getString("currentnodetype"),0) ;
		int theworkflowcount = Util.getIntValue(recordSet.getString("workflowcount"),0) ;
		theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
        if(workflowComInfo.getIsValid(theworkflowid).equals("1")){
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
                if(nodetype==0){
                    newremarkwfcounts0.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts0.get(wfindex),0)+theworkflowcount)) ;
                }
                if(nodetype==1){
                    newremarkwfcounts1.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts1.get(wfindex),0)+theworkflowcount)) ;
                }
                if(nodetype==2){
                    newremarkwfcounts2.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts2.get(wfindex),0)+theworkflowcount)) ;
                }
                if(nodetype==3){
                    newremarkwfcounts3.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts3.get(wfindex),0)+theworkflowcount)) ;
                }
            }else{
                workflows.add(theworkflowid) ;
                workflowcounts.add(""+theworkflowcount) ;	
                if(nodetype==0){
                    newremarkwfcounts0.add(""+theworkflowcount);
                    newremarkwfcounts1.add(""+0);
                    newremarkwfcounts2.add(""+0);
                    newremarkwfcounts3.add(""+0);
                }else if(nodetype==1){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+theworkflowcount);
                    newremarkwfcounts2.add(""+0);
                    newremarkwfcounts3.add(""+0);
                }else if(nodetype==2){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+0);
                    newremarkwfcounts2.add(""+theworkflowcount);
                    newremarkwfcounts3.add(""+0);
                }
                else if(nodetype==3){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+0);
                    newremarkwfcounts2.add(""+0);
                    newremarkwfcounts3.add(""+theworkflowcount);
                    
                }
                
            }

            int wftindex = wftypes.indexOf(theworkflowtype) ;
            if(wftindex != -1) {
            if(wfindex != -1) {
	            //wftypess.set(wftindex,""+(Util.getIntValue((String)wftypess.get(wftindex),0)+1));
	            }
	            else
	            {
	            wftypess.set(wftindex,""+(Util.getIntValue((String)wftypess.get(wftindex),0)+1));
	            //wftypess.add(""+1);
	            }
	            wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
	             if(nodetype==0){
	                wftypecounts0.set(wftindex,""+(Util.getIntValue((String)wftypecounts0.get(wftindex),0)+theworkflowcount)) ;
	            }
	            else if(nodetype==1){
	                wftypecounts1.set(wftindex,""+(Util.getIntValue((String)wftypecounts1.get(wftindex),0)+theworkflowcount)) ;
	            }
	              else if(nodetype==2){
	                wftypecounts2.set(wftindex,""+(Util.getIntValue((String)wftypecounts2.get(wftindex),0)+theworkflowcount)) ;
	            }
	              else if(nodetype==3){
	                wftypecounts3.set(wftindex,""+(Util.getIntValue((String)wftypecounts3.get(wftindex),0)+theworkflowcount)) ;
	            }
	            
	            }
            else {
                wftypess.add(""+1);
                wftypes.add(theworkflowtype) ;
                wftypecounts.add(""+theworkflowcount) ;
                 if(nodetype==0){
                    wftypecounts0.add(""+theworkflowcount);
                    wftypecounts1.add(""+0);
                    wftypecounts2.add(""+0);
                    wftypecounts3.add(""+0);
                }else if(nodetype==1){
                   wftypecounts0.add(""+0);
                    wftypecounts1.add(""+theworkflowcount);
                    wftypecounts2.add(""+0);
                    wftypecounts3.add(""+0);
                }else if(nodetype==2){
                   wftypecounts0.add(""+0);
                    wftypecounts1.add(""+0);
                    wftypecounts2.add(""+theworkflowcount);
                    wftypecounts3.add(""+0);
                }
                else if(nodetype==3){
                    wftypecounts0.add(""+0);
                    wftypecounts1.add(""+0);
                    wftypecounts2.add(""+0);
                    wftypecounts3.add(""+theworkflowcount);
                    
                }
            }

            totalcount += theworkflowcount;
            
        }
	}

    int sumNode0=0;
    int sumNode1=0;
    int sumNode2=0;
    int sumNode3=0;
    int sumNodes=0;
    float percents=0;
    String percentString="";
%>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:submitData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343, user.getLanguage())+",javascript:doExportExcel(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmMain name=frmMain action=FlowTypeStat.jsp method=post>
	
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="createdateselect" >
								<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
								<input class=wuiDateSel type="hidden" name="todate" value="<%=todate%>">
							</span>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="overdateselect">
								<input class=wuiDateSel type="hidden" name="fromdateOver" value="<%=fromdateOver%>">
								<input class=wuiDateSel type="hidden" name="todateOver" value="<%=todateOver%>">
							</span>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<input type="hidden" name="search" value="search" />
							<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
								<!--详细内容在此-->
								  <COLGROUP> 
								  <col width="250px;"> 
								  <col width="100px;"> 
								  <col width="100px;"> 
								  <col width="100px;"> 
								  <col width="100px;"> 
								  <col width="100px;">
								  </COLGROUP>
								<thead>
								
								 <TR class="HeaderForXtalbe"> 
								    <TH><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%>）</TH>
								    <TH><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></TH><!--创建-->
								    <TH><%=SystemEnv.getHtmlLabelName(19044,user.getLanguage())%></TH><!--待批准-->
								    <TH><%=SystemEnv.getHtmlLabelName(19045,user.getLanguage())%></TH><!--戴提交-->
								    <TH><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></TH><!--归档-->
								    <TH><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TH><!--总计-->
								    <TH>
								    	<span><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></span>
										<span class="xTable_algorithmdesc" title="<%=SystemEnv.getHtmlLabelName(24518, user.getLanguage())%>=<%=SystemEnv.getHtmlLabelName(124807, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(124808, user.getLanguage())%>">

										<img style="vertical-align:top;" src="/images/info_wev8.png">
										</span>
									</TH><!--%-->
								   
								  </TR>
								  </thead>
								  <tbody>
								  		<%if (wftypes.size()>0) {%><TR name="headSum" style="vertical-align: middle;"></TR>
										   <%}%>
								  </tbody>
							</table>
							<div id="mytableflow" style="overflow:auto;">
	  						 <div>
							<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
								<COLGROUP> 
								  <col width="250px;"> 
								  <col width="100px;"> 
								  <col width="100px;"> 
								  <col width="100px;"> 
								  <col width="100px;"> 
								  <col width="100px;">
								  </COLGROUP>
								  	<tbody>
										  
										  <%  
										      for(int i=0;i<wftypes.size();i++){
										       typeid=(String)wftypes.get(i);
										       typecount=(String)wftypecounts.get(i);
										       typename=workTypeComInfo.getWorkTypename(typeid);
										 %> <tr style="vertical-align: middle;">
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">
										   
										    <span id="img<%=i%>" onclick="changImg('img<%=i%>','detail<%=i%>')" style="cursor:hand"><IMG SRC="/images/+_wev8.png"  BORDER="0" HEIGHT="9px" WIDTH="9px"></img>
										    </span>&nbsp;
										    <b><%=Util.toScreen(typename,user.getLanguage())%>（<%=wftypess.get(i)%>）</b></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=wftypecounts0.get(i)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=wftypecounts1.get(i)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=wftypecounts2.get(i)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=wftypecounts3.get(i)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=wftypecounts.get(i)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%
										    if (Util.getIntValue(""+totalcount,0)!=0)
										    {
										    
										    percentString=""+((Util.getFloatValue(""+wftypecounts.get(i),0)/Util.getFloatValue(""+totalcount,0))*100);
										    
										    percentString=Util.round(percentString,2)+"%";
										    }
										    
										    %>
										   	<div class="e8_outPercent">
												<span class="e8_innerPercent" style="width:<%=percentString%>"></span>
												<span class="e8_innerText"><%=percentString%></span>
											</div>
										  </TD><!--%-->
										    </tr>
										    <%
										    for(int j=0;j<workflows.size();j++){
										     workflowid=(String)workflows.get(j);
										     String curtypeid=workflowComInfo.getWorkflowtype(workflowid);
										     if(!curtypeid.equals(typeid))	continue;
										     workflowname=workflowComInfo.getWorkflowname(workflowid);
										    %>
										    <tr name="detail<%=i%>" style="display:none;">
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=workflowname%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=newremarkwfcounts0.get(j)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=newremarkwfcounts1.get(j)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=newremarkwfcounts2.get(j)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=newremarkwfcounts3.get(j)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%=workflowcounts.get(j)%></TD>
										    <TD style="border-top:1px #E9E9E2 solid;height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; word-break: keep-all; overflow: hidden;"><%
										    percentString="0";
										    if (Util.getIntValue(""+wftypecounts.get(i),0)!=0)
										    {
										    
										    percentString=""+((Util.getFloatValue(""+workflowcounts.get(j),0)/Util.getFloatValue(""+wftypecounts.get(i),0))*100);
										    
										    percentString=Util.round(percentString,2) + "%";
										    }
										    
										    %>
										    <div class="e8_outPercent" style="border:1px solid #F2D39C;">
												<span class="e8_innerPercent" style="background-color:#F2D39C;width:<%=percentString%>"></span>
												<span class="e8_innerText"><%=percentString%></span>
											</div>
											</TD><!--%-->
										    </tr>
										  <%
										  workflows.remove(j);
										  workflowcounts.remove(j);
										  newremarkwfcounts0.remove(j);
										  newremarkwfcounts1.remove(j);
										  newremarkwfcounts2.remove(j);
										  newremarkwfcounts3.remove(j);
										  j--;
										  }%>
										  <%
										  sumNode0+=Util.getIntValue(""+wftypecounts0.get(i),0);
										  sumNode1+=Util.getIntValue(""+wftypecounts1.get(i),0);
										  sumNode2+=Util.getIntValue(""+wftypecounts2.get(i),0);
										  sumNode3+=Util.getIntValue(""+wftypecounts3.get(i),0);
										  sumNodes+=Util.getIntValue(""+wftypecounts.get(i),0);
										  }
										   
										  %>
										  <%if (wftypes.size()>0) {%>
										  <tr name="headSum" style="vertical-align: middle;"></tr>
										   <%}%>
									</tbody>
								  </TABLE>
								  </div>
								  </div>

						</wea:item>
					</wea:group>
					</wea:layout>

			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="flowTime"></jsp:param>
			<jsp:param name="exportSQL" value="<%=exportSQL%>"></jsp:param>
		</jsp:include>
		<!-- end -->

	</body>

	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

	<script type="text/javascript">
		function resizeMyTable() {
			var height = jQuery('#mainDiv').parent().parent('.tab_box').height() - 200
			if (height <= 100) {
				height = 100;
			}
			jQuery('#mytableflow').height(height);
		}

		jQuery(document).ready(function() {
			jQuery('.ListStyle td,.ListStyle th').each(function() {
				jQuery(this).attr('title', jQuery(this).text().trim());
			});
			resizeMyTable();
			jQuery('#mainDiv').parent().parent('.tab_box').resize(function(){
		    	resizeMyTable();
		    });
		});

		function doExportExcel(){
		   jQuery("#loadingExcel").show();
		   var requestParam=getParamValues(frmMain);
		   document.getElementById("exportExcel").src="FlowTypeStatXLS.jsp?"+requestParam;
		}

		<%if (wftypes.size()>0) {%>
		 tempspan="<TD style='text-align:right;background:#ECFDEA;'><b><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></b></TD>"+
		          "<TD style='color:#0D93F6;background:#ECFDEA;'><%=sumNode0%></TD>"+
		          "<TD style='color:#0D93F6;background:#ECFDEA;'><%=sumNode1%></TD>"+
		    	  "<TD style='color:#0D93F6;background:#ECFDEA;'><%=sumNode2%></TD>"+
		    	  "<TD style='color:#0D93F6;background:#ECFDEA;'><%=sumNode3%></TD>"+
		    	  "<TD style='color:#0D93F6;background:#ECFDEA;'><%=sumNodes%></TD>"+
		    	  "<TD style='color:#0D93F6;background:#ECFDEA;'></td>";
		jQuery('tr[name="headSum"]').html(tempspan);
		<%}%>

		function changImg(obj1, obj2) {
			var trs = jQuery('tr[name=' + obj2 + ']');
			if (trs.length > 0) {
				if (trs.css('display') == 'none') {
					document.all(obj1).innerHTML="<IMG SRC='/images/-_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>";
					trs.show();
				} else {
					document.all(obj1).innerHTML="<IMG SRC='/images/+_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>";
					trs.hide();
				}
			}
		}

		function submitData() {
			frmMain.submit();
		}
	</script>
</html>
