
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmUtil"%>
<%@page import="weaver.conn.RecordSet"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="CRMFreeFieldManage" class="weaver.crm.Maint.CRMFreeFieldManage" scope="page"/>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>

<%
	String usetable = Util.null2String(request.getParameter("usetable"));
	boolean canedit = false; 
	if(usetable.equals("CRM_CustomerInfo")){
		canedit = HrmUserVarify.checkUserRight("CustomerAccountFreeFeildEdit:Edit", user);
	}else if(usetable.equals("CRM_CustomerContacter")){
		canedit = HrmUserVarify.checkUserRight("CustomerContactorFreeFeildEdit:Edit", user);
	}else if(usetable.equals("CRM_CustomerAddress")){
		canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
	}else if(usetable.equals("CRM_SellChance")){
		canedit = HrmUserVarify.checkUserRight("CustomerAddressFreeFeildEdit:Edit", user);
	}
	boolean isoracle = (rs.getDBType()).equals("oracle") ;
	
	
	String customerMust = ",name,status,type,manager,";
	String contacterMust = ",firstname,";
	String customerDisplay = ",name,status,type,manager,";
%>
<TABLE class=ListStyle id="oTable" cols=9  border=0 cellspacing=0>
	<COLGROUP>
		<%if(usetable.equals("CRM_CustomerAddress")){ %>
			<%if(canedit){ %>
				<COL width="7%">
			<%} %>
			<COL width="15%">
			<COL width="15%">
			<COL width="33%">
			<COL width="14%">
			<COL width="5%">
			<COL width="5%">
			<COL width="4%">
		<%}else{ %>
			<%if(canedit){ %>
				<COL width="7%">
			<%} %>
			<COL width="11%">
			<COL width="11%">
			<COL width="25%">
			<COL width="6%">
			<COL width="6%">
			<COL width="6%">
			<COL width="6%">
			<%if(usetable.equals("CRM_CustomerInfo")){ %>
			<COL width="8%">
			<COL width="8%">
			<%} %>
			<COL width="8%">
		<%} %>	
	</COLGROUP>
	<TBODY>
    	<tr class=header>
    		<%if(canedit){ %>
            	<td><input type="checkbox" name="checkall0" onClick="formCheckAll(checkall0)" value="ON"></td>
            <%} %>
            <td><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(31520,user.getLanguage())%></td>
            <td><input type="checkbox" onClick="formCheckAll1(checkall1)" name="checkall1"  value="ON" <%if(!canedit){%>disabled="disabled"<%}%>> <%=SystemEnv.getHtmlLabelNames("18095,83842",user.getLanguage())%></td>
            <td><input type="checkbox" onClick="formCheckAll2(checkall2)" name="checkall2"  value="ON" <%if(!canedit){%>disabled="disabled"<%}%>> <%=SystemEnv.getHtmlLabelNames("18019,83842",user.getLanguage())%></td>
            <%if(!usetable.equals("CRM_CustomerAddress")){ %>
            <td><input type="checkbox" onClick="formCheckAll3(checkall3)" name="checkall3"  value="ON" <%if(!canedit){%>disabled="disabled"<%}%>> <%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%></td>
          	<%} %>
          	<%if(usetable.equals("CRM_CustomerInfo")){ %>
			<td><input type="checkbox" onClick="formCheckAll4(checkall4)" name="checkall4"  value="ON" <%if(!canedit){%>disabled="disabled"<%}%>> <%=SystemEnv.getHtmlLabelName(22391,user.getLanguage())%></td>
			<td><input type="checkbox" onClick="formCheckAll5(checkall5)" name="checkall5"  value="ON" <%if(!canedit){%>disabled="disabled"<%}%>> <%=SystemEnv.getHtmlLabelNames("17416,83842",user.getLanguage())%></td>
			<%} %>
	    <td>现有字段</td>
          </tr>
          
          <%
			String trClass="DataLight";
			int rowsum=0;
			String dbfieldnamesForCompare = ",";

			String fieldname = "";//数据库字段名称
	  		int fieldlabel = 0;//字段显示名标签id
	  		String fieldsyslabel = "";
	  		String fielddbtype = "";//字段数据库类型
	  		String fieldhtmltype = "";//字段页面类型
	  		String type = "";//字段详细类型
	  		String dsporder = "";//显示顺序
	  		String isopen = "";//是否启用 0-不启用(默认) 1-启用
	  		String ismust = "";//是否必填 0-不必填(默认) 1-必填
	  		String imgwidth="";
	        String imgheight="";
	        int textheight = 0;
	        String fieldid = "";
	        String fieldlength = "";
	        String places = "";
			String sql = "select * from CRM_CustomerDefinField where viewtype=0 and usetable='"+usetable+"' order by groupid asc, dsporder asc";
			RecordSet.executeSql(sql);
			String candel = "";
			String groupid = "";
			String groupname = "";
			String issearch = "";
			String isdisplay = "";
			String isexport = "";
			String dmlUrl = "";
			boolean needsys = false;
			
			while(RecordSet.next()){
				
				fieldid = RecordSet.getString("id");
				fieldname = RecordSet.getString("fieldname");
				dbfieldnamesForCompare += fieldname.toUpperCase()+",";
				String fieldlabelname =CrmUtil.getHtmlLableName(RecordSet.getString("fieldlabel"),user);
				fielddbtype = RecordSet.getString("fielddbtype");
				fieldsyslabel = RecordSet.getString("fieldsyslabel");
				fieldhtmltype = RecordSet.getString("fieldhtmltype");
				type = RecordSet.getString("type");
				dsporder = Util.null2String(RecordSet.getString("dsporder"));
				isopen = Util.null2String(RecordSet.getString("isopen"));
				ismust = Util.null2String(RecordSet.getString("ismust"));
				issearch = Util.null2String(RecordSet.getString("issearch"));
				isdisplay = Util.null2String(RecordSet.getString("isdisplay"));
				isexport = Util.null2String(RecordSet.getString("isexport"));
				textheight = Util.getIntValue(Util.null2String(RecordSet.getString("textheight")),0);
				imgwidth = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgwidth")),0);
                imgheight = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgheight")),0);
                candel = Util.null2String(RecordSet.getString("candel"));
                dmlUrl = Util.null2String(RecordSet.getString("dmlUrl"));
                needsys = false;
                groupid = RecordSet.getString("groupid");
                
                
                if(usetable.equals("CRM_CustomerInfo")){
                	if(groupid.equals("1")) groupname=	SystemEnv.getHtmlLabelName(154,user.getLanguage());
                	if(groupid.equals("2")) groupname=	SystemEnv.getHtmlLabelName(16378,user.getLanguage());
                	if(groupid.equals("3")) groupname=	SystemEnv.getHtmlLabelName(15125,user.getLanguage());
                	if(groupid.equals("4")) groupname=	SystemEnv.getHtmlLabelName(572,user.getLanguage());
                	if(groupid.equals("5")) groupname=	SystemEnv.getHtmlLabelName(17088,user.getLanguage());
                }
                
                if(fieldhtmltype.equals("1")&&(type.equals("1") || type.equals("3") || type.equals("5"))){
					fieldlength = fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"));
					if(type.equals("5"))
					{
						places = RecordSet.getString("places");
						fieldlength = places;
					}
				}
                if(fieldlabel == -1 && candel.equals("n")){
                	needsys = true;
                }	
               // System.err.println(fieldname+"  "+fieldlabelname+"   "+isopen+"   "+ismust+"   "+RecordSet.getString("fieldlabel"));
                
			%>
			<TR class=<%=trClass%> forsort="ON">
				<%if(canedit){ %>
					<TD>
						<%if(candel.equals("y")){ %>
							<input type='checkbox' name='check_select' value="<%=fieldid%>_<%=rowsum%>">
						    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
						    <input type="hidden" name="candel_<%=rowsum %>" value="y">
					    <%}else{ %>
					    	<input type='hidden' name='check_select' value="<%=fieldid%>_<%=rowsum%>">
						    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
						    <input type="hidden" name="candel_<%=rowsum %>" value="n">
						    <input type="checkbox" disabled="disabled">
						<%} %>	
						<img moveimg="" src="/CRM/images/move_wev8.png" title="拖动" >				    
					</TD>
				<%} %>
				
				<TD>
					<%if(candel.equals("y") && canedit){ %>
						<input class=Inputstyle type=<%=(candel.equals("n"))?"hidden":"text" %> name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>" onchange="checkinput('itemDspName_<%=rowsum%>','itemDspName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
				  		<span id="itemDspName_<%=rowsum%>_span"><%=(candel.equals("n"))?Util.toScreen(fieldname,user.getLanguage()):"" %></span>
				  		<input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
			  		<%}else{%>
			  			<input type="hidden" name="itemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>">
				  		<span id="itemDspName_<%=rowsum%>_span"><%=Util.toScreen(fieldname,user.getLanguage())%></span>
				  		<input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
			  		<%}%>
				</TD>
				<TD NOWRAP >
					<%if(candel.equals("y") && canedit){ %>
				  		<input   class=Inputstyle type=text name="itemFieldName_<%=rowsum%>" style="width:90%"   value="<%=needsys?Util.toScreen(fieldsyslabel,user.getLanguage()):Util.toScreen(fieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_<%=rowsum%>','itemFieldName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
				  		<span id="itemFieldName_<%=rowsum%>_span">
				  			<%if(fieldlabelname.equals("")){%>
				  				<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
				  			<%}%>
				  		</span>
			  		<%}else{%>
			  			<input  type="hidden" name="itemFieldName_<%=rowsum%>" value="<%=Util.toScreen(fieldlabelname,user.getLanguage())%>" >
			  			<%=fieldlabelname %>
			  		<%}%>
				</TD>
				<TD NOWRAP>
					<div><%=CRMFreeFieldManage.getItemFieldTypeSelectForReviewMainRow(user,rowsum+"",fieldhtmltype,type,fieldlength,textheight,imgwidth,imgheight,candel,fieldid,dmlUrl)%></div>
				</TD>
				<td>
		    		<%=CRMFreeFieldManage.getTableGroupInfo(usetable,rowsum+"",groupid,user,canedit) %>
		    	</td>
				<TD  height="23" >
					<%if((usetable.equals("CRM_CustomerInfo") && -1 != customerMust.indexOf(fieldname))||
							(usetable.equals("CRM_CustomerContacter") && -1 != contacterMust.indexOf(fieldname))){ %>
						<input type='checkbox' name='isopen_<%=rowsum%>' value="<%=isopen%>" checked disabled="disabled">
						<input type='hidden' name='isopen_<%=rowsum%>' value="1">
					<%}else{ %>		
				    	<input type='checkbox' name='isopen_<%=rowsum%>' value="<%=isopen%>" <%if("1".equals(isopen)){%>checked<%}%>  
				    		onchange='setChange(<%=rowsum%>)' <%if(!canedit){%>disabled="disabled"<%}%>>
				    <%} %>
		    	</TD>
		    	<TD>
		    		<%if((usetable.equals("CRM_CustomerInfo") && -1 != customerMust.indexOf(fieldname))||
							(usetable.equals("CRM_CustomerContacter") && -1 != contacterMust.indexOf(fieldname))){ %>
						<input type='checkbox' name='ismust_<%=rowsum%>' value="<%=ismust%>" checked disabled="disabled">
						<input type='hidden' name='ismust_<%=rowsum%>' value="1">
					<%}else{ %>		
			    		<input type='checkbox' name='ismust_<%=rowsum%>' value="<%=ismust%>" <%if("1".equals(ismust)){%>checked<%}%> 
			    			onchange='setChange(<%=rowsum%>)' <%if(!canedit){%>disabled="disabled"<%}%>>
			    	<%} %>
		    	</TD>
		    	
		    	<%if(!usetable.equals("CRM_CustomerAddress")){ %>
		    	<TD>
		    		<input type='checkbox' name='issearch_<%=rowsum%>' value="<%=issearch%>" <%if("1".equals(issearch)){%>checked<%}%>  
		    		<%if(fieldhtmltype.equals("6")){ %> disabled="disabled" <%} %>	onchange='setChange(<%=rowsum%>)' <%if(!canedit){%>disabled="disabled"<%}%>>
		    	</TD>
		    	<%} %>
		    	<%if(usetable.equals("CRM_CustomerInfo")){ %>
		    	<TD>
		    	<%if(-1==customerDisplay.indexOf(","+fieldname+",")){%>
		    		<input type='checkbox' name='isdisplay_<%=rowsum%>' value="<%=isdisplay%>" <%if("1".equals(isdisplay)){%>checked<%}%>  
		    		<%if(fieldhtmltype.equals("6")){ %> disabled="disabled" <%} %>	onchange='setChange(<%=rowsum%>)' <%if(!canedit){%>disabled="disabled"<%}%>>
		    	<%}else{%>
		    		<input type='checkbox' name='isdisplay_<%=rowsum%>' value="<%=isdisplay%>" checked disabled="disabled">
					<input type='hidden' name='isdisplay_<%=rowsum%>' value="1">
		    	<%} %>
		    	</TD>
		    	<TD>
		    	<input type='checkbox' name='isexport_<%=rowsum%>' value="<%=isexport%>" <%if("1".equals(isexport)){%>checked<%}%>
		    	<%if(fieldhtmltype.equals("6")){ %> disabled="disabled" <%} %>	onchange='setChange(<%=rowsum%>)' <%if(!canedit){%>disabled="disabled"<%}%>>
		    	</TD>
		    	<%} %>
                <TD>
                    <input type='checkbox' name='isfixed_<%=rowsum%>' disabled value="1">
                </TD>
		    	
	    	</TR>	
			<%
				rowsum++;
			} %>
	</TBODY>
</TABLE>
<%!
public String getName(String showname) {
	RecordSet rs = new RecordSet();
	if (showname != null && !"".equals(showname)) {
		//兼容老数据，如果id有moduleid，则去掉
		int index = showname.indexOf(".");
		if (index > 0) {
			showname = showname.substring(index + 1);
		}
		String sql = "select name from datashowset where showname='" + showname + "'";
		rs.executeSql(sql);
		if (rs.next()) {
			return Util.null2String(rs.getString("name"));
		}	
	}
	return "";
}
%>
