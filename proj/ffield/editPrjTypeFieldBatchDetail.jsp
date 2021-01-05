<%@page import="weaver.proj.util.PrjTypeFieldManager"%>
<%@page import="weaver.docs.docs.CustomFieldManager"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.proj.util.PrjFieldManager"%>
<%@page import="java.util.List"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Hashtable"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<%
	

User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
int proTypeId = Util.getIntValue(request.getParameter("proTypeId"),0);
if(proTypeId<=0){
	return;
}

int formid = Util.getIntValue(request.getParameter("formid"),0);


boolean isoracle = (rs.getDBType()).equals("oracle") ;

boolean canDelete = true;
boolean canChange = false;
String tablename = "cptcapital";

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124, user.getLanguage())+SystemEnv.getHtmlLabelName(17088, user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(60, user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%
DecimalFormat decimalFormat=new DecimalFormat("##0.00");//使用系统默认的格式
%>

<table class=ListStyle id="oTable" cols=6  border=0 cellspacing=1>
      	<COLGROUP>
		<COL width="7%">
		<COL width="20%">
		<COL width="40%">
		<COL width="5%">
		<COL width="5%">
		<COL width="10%">
          <tr class=header>
            <td>
            <input style="display:;" type="checkbox" name="checkall0" onClick="formCheckAll(checkall0.checked)" value="ON">
            <%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
            <td nowrap>
            <input style="display:;" type="checkbox" name="checkall_isopen" id="checkall_isopen"  value="1">
            <%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>
            </td>
            <td nowrap>
            <input style="display:;" type="checkbox" name="checkall_ismand" id="checkall_ismand"  value="1">
            <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
          </tr>
		<%
		String qname=Util.null2String(request.getParameter("qname"));
	    String fieldname_kwd = Util.null2String(request.getParameter("fieldname_kwd"));
	    String fieldlabel_kwd = Util.null2String(request.getParameter("fieldlabel_kwd"));
	    String isopen = "";
  		String ismand = "";
  		String isused = "";
	    
		String trClass="DataLight";
		int rowsum=0;
		String dbfieldnamesForCompare = ",";
		
		String fieldname = "";//数据库字段名称
		int fieldlabel = 0;//字段显示名标签id
		String fielddbtype = "";//字段数据库类型
		String fieldhtmltype = "";//字段页面类型
		String type = "";//字段详细类型
		String dsporder = "";//显示顺序
		String imgwidth="";
		String imgheight="";
		int textheight = 0;

			String sql = ""+
					" select t1.* ,t2.* "+
					" from cus_formfield t1, cus_formdict t2 "+
					" where t1.scope='ProjCustomField'  and t1.fieldid=t2.id "+
					" and scopeid='"+proTypeId+"' ";
					
			if(qname.length()>0){
				sql +=" and (fieldname like '%"+qname+"%' or fieldlabel like '%"+qname+"%' )";
			} 
			
			if(fieldname_kwd.length()>0){
				sql +=" and fieldname like '%"+fieldname_kwd+"%' ";
			} 
			
			if(fieldlabel_kwd.length()>0){
				sql +=" and exists (select * from HtmlLabelInfo where fieldlabel = indexid and labelname like '%"+fieldlabel_kwd+"%' )";
			} 
				sql += " order by t1.fieldorder";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					isopen = Util.null2String( RecordSet.getString("prj_isopen"));
					ismand = Util.null2String( RecordSet.getString("ismand"));
					isused = Util.null2String( RecordSet.getString("isuse"));
					String fieldid = RecordSet.getString("id");
					fieldname = "field"+fieldid;
					dbfieldnamesForCompare += fieldname.toUpperCase()+",";
					fieldlabel = RecordSet.getInt("prj_fieldlabel");
					String fieldlabelname = SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
					fielddbtype = RecordSet.getString("fielddbtype");
					String fieldlength = "";
					fieldhtmltype = RecordSet.getString("fieldhtmltype");
					type = RecordSet.getString("type");
					if(fieldhtmltype.equals("1")&&type.equals("1")){
						fieldlength = fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"));
					}
					dsporder =decimalFormat.format( Util.getDoubleValue(RecordSet.getString("fieldorder"),0.0));
					textheight = 0;
					imgwidth = "0";
	                imgheight = "0";
					int childfieldid_tmp = 0;
					String childfieldStr = "";
					Hashtable childItem_hs = new Hashtable();
					String para = fieldname+"+0+"+fieldhtmltype+"+ +"+formid;
					boolean isFieldUsed="1".equals(isused)||PrjTypeFieldManager.isFieldUsed(fieldname);
%>
          <TR class=<%=trClass%>>
			<td  height="23" >
			    <input type='checkbox' name='check_select' value="<%=fieldid%>_<%=rowsum%>" <%if(isFieldUsed){%>disabled<%}%> >
			    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
		    </td>
			<td NOWRAP>
			  <input   class=InputStyle type=hidden name="itemDspName_<%=rowsum%>" style="width:0%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>">
			  <input   class=InputStyle type=text name="itemFieldName_<%=rowsum%>" style="width:90%"   value="<%=Util.toScreen(fieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_<%=rowsum%>','itemFieldName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
			  <span id="itemFieldName_<%=rowsum%>_span"></span>
			</td>
			<td NOWRAP>
				  <select class='InputStyle' style="width:100px!important;" name='itemFieldType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="onChangItemFieldType(<%=rowsum%>);setChange(<%=rowsum%>)">
				  	<option value='1' <%if(fieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
				  	<option value='2' <%if(fieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
				  	<option value='3' <%if(fieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
				  	<option value='4' <%if(fieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
				  	<option value='5' <%if(fieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
				  </select>
				  <%if(!canChange){%>
				  <input type="hidden" value="<%=fieldhtmltype%>" name="itemFieldType_<%=rowsum%>">
				  <%}%>
				  
				  <div id="div1_<%=rowsum%>" <%if(fieldhtmltype.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					  <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
					  <select class='InputStyle' style="width:100px!important;" name='documentType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange='onChangType(<%=rowsum%>);setChange(<%=rowsum%>)'>
					  	<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
					  	<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
					  	<option value='3' <%if(type.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
					  	<option value='4' <%if(type.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
					  	<option value='5' <%if(type.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					  </select>
						<%if(!canChange){%><input type="hidden" value="<%=type%>" name="documentType_<%=rowsum%>"><%}%>
					</div>
					<div id="div1_1_<%=rowsum%>" <%if(fieldhtmltype.equals("1")&&type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					  <%
					      int maxlength = 0;
					      if(isoracle){
					          rs.executeSql("select max(lengthb("+fieldname+")) from "+tablename);
					          if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
					      }else{
					          rs.executeSql("select max(datalength("+fieldname+")) from "+tablename);
					          if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
					      }
					      //out.println("maxlength=="+maxlength);
					  %>
				  		<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>
					  	<input class='InputStyle' style="width:100px!important;" type='text' size=3 maxlength=3 value='<%=fieldlength%>' id='itemFieldScale1_<%=rowsum%>' name='itemFieldScale1_<%=rowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChange(<%=rowsum%>)' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_<%=rowsum%>,itemFieldScale1span_<%=rowsum%>);checkcount1(itemFieldScale1_<%=rowsum%>);checkmaxlength(<%=maxlength%>,itemFieldScale1_<%=rowsum%>)' style='text-align:right;'><span id=itemFieldScale1span_<%=rowsum%>><%if(fieldlength.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
					</div>
					<div id="div1_3_<%=rowsum%>" <%if(fieldhtmltype.equals("1")&&type.equals("3")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					  <%
					      int decimaldigits = 2;
						if(fieldhtmltype.equals("1")&&type.equals("3")){
							int digitsIndex = fielddbtype.indexOf(",");
				        	if(digitsIndex > -1){
				        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
				        	}else{
				        		decimaldigits = 2;
				        	}
						}
					  %>
				  		<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
						<%if(!canChange){%>
							<input type="hidden" id="decimaldigits_<%=rowsum%>" name="decimaldigits_<%=rowsum%>" value="<%=decimaldigits%>">
							<select style="width:100px!important;" id="decimaldigitshidden_<%=rowsum%>" name="decimaldigitshidden_<%=rowsum%>" size="1" disabled>
						<%}else{%>
							<select style="width:100px!important;" id="decimaldigits_<%=rowsum%>" name="decimaldigits_<%=rowsum%>" size="1">
						<%}%>
								<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
								<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
								<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
								<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
							</select>
					</div>
				  <div id="div2_<%=rowsum%>" <%if(fieldhtmltype.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
				  	<input class='InputStyle' style="width:100px!important;"  type='text' size=4 maxlength=2 value='<%=textheight%>' id='textheight_<%=rowsum%>' name='textheight_<%=rowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChange(<%=rowsum%>)' onblur='checkPlusnumber1(this);checkcount1(textheight_<%=rowsum%>)' style='text-align:right;'>
				  	<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
				  	<input type='checkbox' <%if(type.equals("2")){%> checked <%}%> <%if(!canChange){%>disabled<%}%>>
				  	<%if(!canChange){%><input type="hidden" value="<%=type%>" name="htmledit_<%=rowsum%>"><%}%>
					</div>
				  
				  <div id="div3_<%=rowsum%>" <%if(fieldhtmltype.equals("3")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				  	<select class='InputStyle' style="width:100px!important;" name='broswerType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="onChangBroswerType(<%=rowsum%>);setChange(<%=rowsum%>)">
				  		<%while(browserComInfo.next()){%>
				  			<option value="<%=browserComInfo.getBrowserid()%>" <%if(type.equals(""+browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				  		<%}%>
				  	</select>
				  	<%if(!canChange){%><input type="hidden" value="<%=type%>" name="broswerType_<%=rowsum%>"><%}%>
				  </div>
				  <div id="div3_0_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162")||type.equals("224")||type.equals("225"))&&fielddbtype.equals("")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				  </div>
				  
					<div id="div3_1_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<select class='InputStyle' style="width:100px!important;" name='definebroswerType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="div3_0_show(<%=rowsum%>);setChange(<%=rowsum%>)">
				  		</select>
				  		<%if(!canChange){%><input type="hidden" value="<%=fielddbtype%>" name="definebroswerType_<%=rowsum%>"><%}%>
					</div>
					<div id="div3_4_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<select class='InputStyle' style="width:100px!important;" name='sapbrowser_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="div3_4_show(<%=rowsum%>);setChange(<%=rowsum%>)">
				  			<%
				  			List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
				  			for(int j=0;j<AllBrowserId.size();j++){
				  			%>
				  			<option value='<%=AllBrowserId.get(j)%>' <%if(fielddbtype.equals(""+AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
				  			<%}%>
				  		</select>
				  		<%if(!canChange){%><input type="hidden" value="<%=fielddbtype%>" name="definebroswerType_<%=rowsum%>"><%}%>
				  		<%if(!canChange){%><input type="hidden" value="<%=fielddbtype%>" name="sapbrowser_<%=rowsum%>"><%}%>
					</div>
					<div id="div3_2_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("165")||type.equals("166")||type.equals("167")||type.equals("168"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>
				  		<select class='InputStyle' style="width:100px!important;" name='decentralizationbroswerType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="setChange(<%=rowsum%>)">
				  			<option value='1' <%if(RecordSet.getString("textheight").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
				  			<option value='2' <%if(RecordSet.getString("textheight").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
				  		</select>
				  		<%if(!canChange){%><input type="hidden" value="<%=RecordSet.getString("textheight")%>" name="decentralizationbroswerType_<%=rowsum%>"><%}%>
					</div>  
				  
				  <div id="div5_<%=rowsum%>" <%if(fieldhtmltype.equals("5")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<button type='button' class=addbtn id=btnaddRow name=btnaddRow onclick='addoTableRow(<%=rowsum%>)' value="<%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%>"></BUTTON>
				  	<button type='button' class=delbtn id=btnsubmitClear name=btnsubmitClear onclick='submitClear(<%=rowsum%>)' value="<%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%>"></BUTTON>
					<span style='display:none;'><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<button type='button' style='display:none;' id='showChildFieldBotton' class=Browser onClick="onShowChildField(childfieldidSpan_<%=rowsum%>,childfieldid_<%=rowsum%>,'_<%=rowsum%>')"></BUTTON>
					<span style='display:none;' id='childfieldidSpan_<%=rowsum%>'><%=childfieldStr%></span>
					<input type='hidden' value='<%=childfieldid_tmp%>' name='childfieldid_<%=rowsum%>' id='childfieldid_<%=rowsum%>'>
					</div>
					<div id="div5_5_<%=rowsum%>" <%if(fieldhtmltype.equals("5")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<table class='ViewForm' id='choiceTable_<%=rowsum%>' cols=7 border=0>
						<COL width="10%">
						<COL width="40%">
						<COL width="40%">
						<COL width="10%">
						<COL width="0%">
						<COL width="0%">
						<col width="0%">
				  		<tr>
				  			<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
				  			<td style="display:none;"><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>
							<td style="display:none;"><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
				  			<td style="display:none;"><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td>
						</tr>
				  		<%
				  		int recordchoicerowindex = 0;
				  		RecordSet1.executeSql("select selectvalue, selectname, fieldorder from cus_selectitem where fieldid=" + fieldid + " order by fieldorder");
				  		while(RecordSet1.next()){
				  		recordchoicerowindex+=1;
						String childitemid_tmp = "";
						String childitemidStr = "";
						int isAccordToSubCom_tmp = 0;
						String isAccordToSubCom_Str = "";
						if(isAccordToSubCom_tmp == 1){
							isAccordToSubCom_Str = " checked ";
						}
						String[] childitemid_sz = Util.TokenizerString2(childitemid_tmp, ",");
						for(int cx=0; (childitemid_sz!=null && cx<childitemid_sz.length); cx++){
							String childitemidTemp = Util.null2String(childitemid_sz[cx]);
							String childitemnameTemp = Util.null2String((String)childItem_hs.get("item_"+childitemidTemp));
							if(!"".equals(childitemnameTemp)){
								childitemidStr += (childitemnameTemp+",");
							}
						}
						if(!"".equals(childitemidStr)){
							childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
						}
				  		%>
				  		<tr>
				  		<td><input type="checkbox" name="chkField" index="<%=recordchoicerowindex%>" value="0" <%if(isFieldUsed){%>disabled<%}%>>
				  		<td><input class="InputStyle" value="<%=RecordSet1.getString("selectname")%>" type="text" size="10" name="field_<%=rowsum%>_<%=recordchoicerowindex%>_name" style="width=90%" onchange="checkinput('field_<%=rowsum%>_<%=recordchoicerowindex%>_name','field_<%=rowsum%>_<%=recordchoicerowindex%>_span');setChange(<%=rowsum%>)">
				  		<span id="field_<%=rowsum%>_<%=recordchoicerowindex%>_span"><%if(RecordSet1.getString("selectname").equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span></td>
				  		<td><input class="InputStyle" type="text" size="4" value = "<%=RecordSet1.getString("listorder")%>" name="field_count_<%=rowsum%>_<%=recordchoicerowindex%>_name" style="width=90%" onchange="setChange(<%=rowsum%>)" onKeyPress="ItemNum_KeyPress('field_count_<%=rowsum%>_<%=recordchoicerowindex%>_name')"></td>
				  		<td><input type="checkbox" name="field_checked_<%=rowsum%>_<%=recordchoicerowindex%>_name" onchange='setChange(<%=rowsum%>)' onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(RecordSet1.getString("isdefault").equals("y")){%>checked<%}%> value="1"></td>
				  			
				  		<td style="display:none;"><input type="hidden" id="selectvalue<%=rowsum%>_<%=recordchoicerowindex%>" name="selectvalue<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet1.getString("selectvalue")%>">
							<input type='checkbox' name='isAccordToSubCom<%=rowsum%>_<%=recordchoicerowindex%>' value='1' <%=isAccordToSubCom_Str%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
							<button type='button' class=Browser name="selectCategory" onClick="onShowCatalog(mypath_<%=rowsum%>_<%=recordchoicerowindex%>,'<%=rowsum%>','<%=recordchoicerowindex%>')"></BUTTON>
							<span id="mypath_<%=rowsum%>_<%=recordchoicerowindex%>"><%=RecordSet1.getString("docPath")%></span>
						  <input type=hidden id="pathcategory_<%=rowsum%>_<%=recordchoicerowindex%>" name="pathcategory_<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet1.getString("docPath")%>">
						  <input type=hidden id="maincategory_<%=rowsum%>_<%=recordchoicerowindex%>" name="maincategory_<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet1.getString("docCategory")%>"></td>
						  <td style="display:none;">
							<button type='button' class="Browser" onClick="onShowChildSelectItem(childItemSpan_<%=rowsum%>_<%=recordchoicerowindex%>,childItem_<%=rowsum%>_<%=recordchoicerowindex%>,'_<%=rowsum%>')" id="selectChildItem_<%=rowsum%>_<%=recordchoicerowindex%>" name="selectChildItem_<%=rowsum%>_<%=recordchoicerowindex%>"></BUTTON>
							<input type="hidden" id="childItem_<%=rowsum%>_<%=recordchoicerowindex%>" name="childItem_<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=childitemid_tmp%>" >
							<span id="childItemSpan_<%=rowsum%>_<%=recordchoicerowindex%>" name="childItemSpan_<%=rowsum%>_<%=recordchoicerowindex%>"><%=childitemidStr%></span>
						  </td>
				  		 <td style="display:none;"><input type="checkbox" name="cancel_<%=rowsum%>_<%=recordchoicerowindex%>_name" onchange='setChange(<%=rowsum%>)'  value="<%=RecordSet1.getString("cancel")%>" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(RecordSet1.getString("cancel").equals("1")){%>checked<%}%>></td> 
						</tr>
				  		<%}%>
				  		<input type="hidden" value="<%=recordchoicerowindex%>" name="choiceRows_<%=rowsum%>">
				  	</table>
				  </div>
				  
				 
				  				  		    		
		    </td>
				    
			<td  height="23" >
			    <input type='checkbox'  name='isopen_<%=rowsum%>' value="1" <%if("1".equals(isopen)){%>checked<%}%>  onchange='setChange(<%=rowsum%>)'>
		    </td>		
		    <td height="23" >
			    <input type='checkbox'  name='ismand_<%=rowsum %>' value="1" <%if("1".equals(ismand )){%>checked<%}%> onchange='setChange(<%=rowsum%>);linkageIsopen(<%=rowsum%>);'>
		    </td>	    
		    <td NOWRAP >
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


<script type="text/javascript">
<!--
$(function(){
	$("body").jNice();
	//$("select").selectbox();
	
	$("#checkall_isopen").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'isopen_']:checkbox").attr("checked", true).trigger('change').next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'isopen_']:checkbox").attr("checked", false).trigger('change').next("span").removeClass("jNiceChecked");
		}
	});
	$("#checkall_ismand").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'isopen_']:checkbox").attr("checked", true).trigger('change').next("span").addClass("jNiceChecked");
			$("[name ^= 'ismand_']:checkbox").attr("checked", true).trigger('change').next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'ismand_']:checkbox").attr("checked", false).trigger('change').next("span").removeClass("jNiceChecked");
		}
	});
	
});


//-->
</script>
