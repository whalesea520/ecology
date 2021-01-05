<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify,weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser(request,response);
	boolean canEdit = "true".equals(request.getParameter("canEdit"));
	String approvewfid = request.getParameter("approvewfid");
	String PCreaterSubCompLS = request.getParameter("PCreaterSubCompLS");
	String PCreaterDepartLS = request.getParameter("PCreaterDepartLS");
	String id = request.getParameter("id");
	String PCreater = request.getParameter("PCreater");
	String PCreaterManager = request.getParameter("PCreaterManager");
	String PCreaterSubComp = request.getParameter("PCreaterSubComp");
	String PCreaterDepart = request.getParameter("PCreaterDepart");
	String PCreaterW = request.getParameter("PCreaterW");
	String PCreaterManagerW = request.getParameter("PCreaterManagerW");
%>


        <!-- 安全信息 -->
        <table class=ViewForm style="display:none">
          <colgroup> <col width="30%"> <col width="70%"> <tbody>
          <tr class=Title>
            <th><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></th>
          </tr>
          <tr class=Spacing>
            <td class=Line1 colspan=2></td>
          </tr>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              <button type='button' class=browser onclick="onShowWorkflow()"></button>
              <span id=approvewfspan></span>
              <input type=hidden name="approvewfid" value="<%=approvewfid%>">
              <%}else{%>
              <span>
               <brow:browser viewType="0" name="approvewfid" browserValue='<%=""+approvewfid%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1"
                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
                completeUrl="/data.jsp?type=9" linkUrl="#" 
                browserSpanValue='<%= Util.toScreen(WorkflowComInfo.getWorkflowname(approvewfid),user.getLanguage())%>'></brow:browser>
        </span>					
              <%} %>
              
            </td>
          </tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </tbody>
        </table>
        <div style="display:none">
        <!--创建文档权限设置-->
        <%
           int[] labels = {58,125,385};
           int operationcode = MultiAclManager.OPERATION_CREATEDOC;
           int categorytype = MultiAclManager.CATEGORYTYPE_SEC;
        %>
        <%//@ include file="/docs/category/PermissionList.jsp" %>
        <!--复制文档权限设置-->
        <%
           labels[1] = 77;
           operationcode = MultiAclManager.OPERATION_COPYDOC;
        %>
        <%//@ include file="/docs/category/PermissionList.jsp" %>
        <!--移动文档权限设置-->
        <%
           labels[1] = 78;
           operationcode = MultiAclManager.OPERATION_MOVEDOC;
        %>
        <%//@ include file="/docs/category/PermissionList.jsp" %>
        </div>
        <!--TD2858 新的需求: 添加与文档创建人相关的默认共享(内部人员)  开始-->    
        <table class="viewform" width="100%" style="display:none">      
           <COLGROUP>
            <COL width="30%">
            <COL width="70%">
           </COLGROUP>
           <tr class=Title>
            <th colspan=2><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18590,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(18589,user.getLanguage())%>)</th>
           </tr>
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr class=Spacing style="height: 1px!important;">
            <td class=Line1 colspan=2></td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18582,user.getLanguage())%></td>
            <td class=Field> 
             
                <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PDocCreater">            
                                <option value="0" <%if("0".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                                <option value="3"  <%if("3".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                                </select>
                        </td>
                    </tr>
                </table>
                
            </td>
          </tr>   
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></td>
            <td class=Field>     
            
               <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PCreaterManager">            
                                <option value="0"  <%if("0".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>  
                        </td>
                    </tr>
                </table>  
                  
            </td>
          </tr> 
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>        
           <input type="hidden" name="PCreaterJmanager" value="0">    
           <input type="hidden" name="PCreaterDownOwner" value="0"> 
           <tr>
            <td><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></td>
            <td class=Field>              
                <table width="100%">
                    <tr>
                        <td width="60%">
                            <div id="PCreaterSubCompLDiv"   <%if("0".equals(PCreaterSubComp)) {out.println(" style=\"display:none\"" );}%> align="left">   
                                   <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= <input value="<%=PCreaterSubCompLS%>"  class="inputStyle" type="text" size="4" name="PCreaterSubCompLS">
                            </div>
                        </td>
                        <td width="40%">
                            <select name="PCreaterSubComp" onchange="onSelectChange(this,PCreaterSubCompLDiv)">            
                                <option value="0"  <%if("0".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>   
                                <option value="3"  <%if("3".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>   
                        </td>
                    </tr>
                </table>                  
                
              
            </td>
          </tr>  
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
           <tr>
            <td><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
            <td class=Field>   
                <table width="100%">
                    <tr>
                        <td width="60%">
                            <Div id="PCreaterDepartLDiv"   <%if("0".equals(PCreaterDepart)) {out.println(" style=\"display:none\"" );}%> align="left">                            
                                     <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= <input value="<%=PCreaterDepartLS%>"  class="inputStyle" type="text" size="4" name="PCreaterDepartLS">
                           </Div>
                        </td>
                        <td width="40%">
                            <select name="PCreaterDepart" onchange="onSelectChange(this,PCreaterDepartLDiv)">            
                                <option value="0" <%if("0".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1" <%if("1".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2" <%if("2".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select> 
                        </td>
                    </tr>
                </table>                 
            </td>
          </tr>  
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

           </table>


           <table class="viewform" width="100%" style="display:none">      
           <COLGROUP>
            <COL width="30%">
            <COL width="70%">
           </COLGROUP>
           <tr class=Title>
            <th colspan=2><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18590,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(2209,user.getLanguage())%>)</th>
           </tr>
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr class=Spacing style="height: 1px!important;">
            <td class=Line1 colspan=2></td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18582,user.getLanguage())%></td>
            <td class=Field> 
             
                <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PDocCreaterW">            
                                <option value="0" <%if("0".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                                <option value="3"  <%if("3".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                                </select>
                        </td>
                    </tr>
                </table>
                
            </td>
          </tr>   
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></td>
            <td class=Field>     
            
               <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PCreaterManagerW">            
                                <option value="0"  <%if("0".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>  
                        </td>
                    </tr>
                </table>  
                  
            </td>
          </tr> 
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>          
          <input type="hidden" name="PCreaterJmanagerW" value="0">    
          </Table>
           <!--TD2858 新的需求: 添加与文档创建人相关的默认共享  结束-->           
        
        <!--默认共享-->
        <table class=ViewForm  style="display:none">
          <colgroup>
          <col width="8%">
          <col width="40%">
          <col width="52%">
          <tr class=Title >
            <th colspan=2><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18598,user.getLanguage())%>)</th>
            <td align=right>
            <%if(canEdit){%> 
                <input type="checkbox" name="chkAll" onclick="chkAllClick(this)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
                &nbsp;                         
                <a href="/docs/docs/DocShareAddBrowser.jsp?para=1_<%=id%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;                 
                <a href="javaScript:onDelShare()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
            <%}%>            
            </td>
          </tr>
          <tr class=Spacing style="height: 1px!important;">
            <td class=Line1 colspan=3></td>
          </tr>
<%
	//查找已经添加的默认共享
	RecordSet.executeProc("DocSecCategoryShare_SBySecID",id+"");
	while(RecordSet.next()){
		if(RecordSet.getInt("sharetype")==1)	{%>
	        <TR>
              <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			  
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
	    <%}else if(RecordSet.getInt("sharetype")==2)	{%>
	        <TR>
               <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==3)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==4)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                
			  </TD>			 
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==5)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			  
	        </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
       <%}else if(RecordSet.getInt("sharetype")==9)  {//具体客户%>  
            <TR>
             <TD><INPUT TYPE='checkbox'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
              <TD class=Field><%=SystemEnv.getHtmlLabelName(18647,user.getLanguage())%></TD>
              <TD class=Field>
                <%=CustomerInfoComInfo.getCustomerInfoname(Util.null2String(RecordSet.getString("crmid")))%>/
                <% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
              </TD>           
            </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
	    <%}else if(RecordSet.getInt("sharetype")<0)	{
	    		String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
	    		String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
	    		%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}%>
<%	}%>
        </table>
