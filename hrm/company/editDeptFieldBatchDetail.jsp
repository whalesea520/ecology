
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%--<jsp:useBean id="formmanager1" class="weaver.hrm.company.FormManager" scope="page"/>--%>
<jsp:useBean id="DeptFieldManager2" class="weaver.hrm.company.DeptFieldManager" scope="page"/>
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
	if(!HrmUserVarify.checkUserRight("DeptDefineInfo1:DeptMaintain1", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}


int formid = Util.getIntValue(request.getParameter("formid"),0);
boolean isoracle = (rs.getDBType()).equals("oracle") ;

boolean canDelete = true;
boolean canChange = false;
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124, user.getLanguage())+SystemEnv.getHtmlLabelName(17088, user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(60, user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<Table>
<TBODY>

<%
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
%>
  	  <table class=ListStyle id="oTable" cols=6  border=0 cellspacing=1>
      	<COLGROUP>
				<COL width="5%">
				<COL width="25%">
				<COL width="25%">
				<COL width="15%">
				<COL width="15%">
				<COL width="15%">
          <tr class=HeaderForXtalbe>
            <th><input type="checkbox" name="checkall0" onClick="formCheckAll(checkall0.checked)" value="ON"></th>
            <th><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></th>
            <th>
            <input type="checkbox" name="checkallstatus" onClick="formStatusCheckAll(checkallstatus.checked)" value="ON">
            <%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></th>
            <th><input type="checkbox" name="checkallMand" onClick="formMandCheckAll(checkallMand.checked)" value="ON">
            <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></th>
            <th style="display: none"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></th>
          </tr>
<%

			String trClass="DataLight";
			int rowsum=0;
			String dbfieldnamesForCompare = ",";
      String qname=Util.null2String(request.getParameter("qname"));
      String fieldname_kwd = Util.null2String(request.getParameter("fieldname_kwd"));
      String fieldlabel_kwd = Util.null2String(request.getParameter("fieldlabel_kwd"));
			String fieldname = "";//数据库字段名称
  		int fieldlabel = 0;//字段显示名标签id
  		String fielddbtype = "";//字段数据库类型
  		String fieldhtmltype = "";//字段页面类型
  		String type = "";//字段详细类型
  		String dsporder = "";//显示顺序
  		String isopen = "";//是否启用 0-不启用(默认) 1-启用
  		String ismand = "";//是否启用 0-不启用(默认) 1-启用
  		String imgwidth="";
      String imgheight="";
      int textheight = 0;

			String sql = "select * from departmentDefineField " 
					 			 + " where viewtype=0 "; 
			if(qname.length()>0){
				sql +=" and (fieldname like '%"+qname+"%' or fieldlabel like '%"+qname+"%' )";
			} 
			
			if(fieldname_kwd.length()>0){
				sql +=" and fieldname like '%"+fieldname_kwd+"%' ";
			} 
			
			if(fieldlabel_kwd.length()>0){
				sql +=" and exists (select * from HtmlLabelInfo where fieldlabel = indexid and labelname like '%"+fieldlabel_kwd+"%' )";
			} 
				sql += " order by dsporder,id";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String fieldid = RecordSet.getString("id");
				fieldname = RecordSet.getString("fieldname");
				dbfieldnamesForCompare += fieldname.toUpperCase()+",";
				fieldlabel = RecordSet.getInt("fieldlabel");
				String fieldlabelname = SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
				fielddbtype = RecordSet.getString("fielddbtype");
				String fieldlength = "";
				fieldhtmltype = RecordSet.getString("fieldhtmltype");
				type = RecordSet.getString("type");
				if(fieldhtmltype.equals("1")&&type.equals("1")){
					fieldlength = fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"));
				}
				dsporder = Util.null2String(RecordSet.getString("dsporder"));
				isopen = Util.null2String(RecordSet.getString("isopen"));
				ismand = Util.null2String(RecordSet.getString("ismand"));
				
				textheight = Util.getIntValue(Util.null2String(RecordSet.getString("textheight")),0);
				imgwidth = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgwidth")),0);
                imgheight = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgheight")),0);
				String para = fieldname+"+0+"+fieldhtmltype+"+ +"+formid;
				String canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox1(para);
%>
          <TR class=<%=trClass%> forsort="ON">
			<td  height="23" >
			    <input type='checkbox' name='check_select' value="<%=fieldid%>_<%=rowsum%>" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%> >
			    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
		    </td>
			<td NOWRAP >
			  <%
			  //System.out.println(">>>>>>>>>>>>>>>>>>canChange="+canChange);
			  if(canDeleteCheckBox.equals("false")){
			  %>
			  <input class=Inputstyle type=hidden name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>">
			  <span id="itemDspName_<%=rowsum%>_span"><%=Util.toScreen(fieldname,user.getLanguage())%></span>
			  <%}else{%>
			  <input class=Inputstyle type=text name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>" onchange="checkinput('itemDspName_<%=rowsum%>','itemDspName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
			  <span id="itemDspName_<%=rowsum%>_span"></span>
			  <%}%>
			  <input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
			</td>
			<td NOWRAP >
			  <input   class=Inputstyle type=text name="itemFieldName_<%=rowsum%>" style="width:90%"   value="<%=Util.toScreen(fieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_<%=rowsum%>','itemFieldName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
			  <span id="itemFieldName_<%=rowsum%>_span"></span>
			</td>
			<td NOWRAP >
				  <input name='itemFieldType_<%=rowsum%>' type="hidden" value="3">
				  <!--
				  <select class='InputStyle' name='itemFieldType_<%=rowsum%>' <%if("false".equals(canDeleteCheckBox)){%> disabled <%}%> onChange="onChangItemFieldType(<%=rowsum%>);setChange(<%=rowsum%>)">
				  	<%--
				  	<option value='1' <%if(fieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
				  	<option value='2' <%if(fieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
				  	--%>
				  	<option value='3' <%if(fieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
				  	<%--
				  	<option value='4' <%if(fieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
				  	<option value='5' <%if(fieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
				  	<option value='6' <%if(fieldhtmltype.equals("6")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
					<option value='7' <%if(fieldhtmltype.equals("7")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
				    --%>
				  </select>
				  -->
				  <%if("false".equals(canDeleteCheckBox)){%>
				  <input type="hidden" value="<%=fieldhtmltype%>" name="itemFieldType_<%=rowsum%>">
				  <%}%>
				 
				  <div id="div3_<%=rowsum%>" <%if(fieldhtmltype.equals("3")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				  	<select class='InputStyle' id='broswerType_<%=rowsum%>' name='broswerType_<%=rowsum%>' onChange="onChangBroswerType(<%=rowsum%>);setChange(<%=rowsum%>)" style="width: 100px">
				  		<%
				  		while(browserComInfo.next()){
				  		   if((!"1".equals(browserComInfo.getBrowserid()))&&!"17".equals(browserComInfo.getBrowserid())){
				  	          continue;
			               }
				  		%>
				  			<option value="<%=browserComInfo.getBrowserid()%>" <%if(type.equals(""+browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				  		<%}%>
				  	</select>
				  	<%if("false".equals(canDeleteCheckBox)){%><input type="hidden" value="<%=type%>" name="broswerType_<%=rowsum%>"><%}%>
				  	<script type="text/javascript">
				  	<%if("false".equals(canDeleteCheckBox)){%>
				  		jQuery("#broswerType_<%=rowsum%>").selectbox("disable");
				  	<%}%>
				  	</script>
				  </div>
		  		    		
		    </td>
			<td  height="23" >
			    <input type='checkbox' name='isopen_<%=rowsum%>' value="<%=isopen%>" <%if("1".equals(isopen)){%>checked<%}%>  onchange='setChange(<%=rowsum%>)'>
		    </td>	
		   <td  height="23" >
			    <input type='checkbox' name='ismand_<%=rowsum%>' value="<%=ismand%>" <%if("1".equals(ismand)){%>checked<%}%>  onchange='setChange(<%=rowsum%>)'>
		    </td>		    
		    <td NOWRAP style="display: none" >
               <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_<%=rowsum%>'  value = '<%=dsporder%>' onKeyPress='ItemNum_KeyPress("itemDspOrder_<%=rowsum%>")' onchange='checknumber("itemDspOrder_<%=rowsum%>");checkDigit("itemDspOrder_<%=rowsum%>",15,2);setChange(<%=rowsum%>)' style='text-align:right;'>
    		</td>
		</tr>
<%	
				if(trClass.equals("DataLight")){
					trClass="DataDark";
			    }else{
					trClass="DataLight";
				}
				rowsum++;
			}
%>


	  </table>

</TBODY>
</table>