<!DOCTYPE html>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.formmode.FormModeConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.workflow.form.FormManager"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportItemManager" class="weaver.datacenter.InputReportItemManager" scope="page" />
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="formmanager" class="weaver.workflow.form.FormManager" scope="page"/>
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<jsp:useBean id="UserDefinedBrowserTypeComInfo" class="weaver.workflow.field.UserDefinedBrowserTypeComInfo" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	select{
		width:75px!important;
	}
	
	input.InputStyle0{
		width:95px!important;
	}
	
	input.InputStyle1{
		width:80px!important;
	}
	
	input.InputStyle{
		width:75px!important;
	}
</style>
<%!
	//判断表单建模的字段是否能编辑
	public boolean isFormModeFieldCanChange(boolean isFormmodeUse,boolean isFieldNoValueCanEdit,String tableName,String fieldName,String fieldhtmltype,String type,String fielddbtype){
	     if((isFormmodeUse && isFieldNoValueCanEdit) || !isFormmodeUse){
	    	 RecordSet rsformmode = new RecordSet();
	    	 String sql = "";
	    	 if(rsformmode.getDBType().equals("oracle")&&fieldhtmltype.equals("4")&&type.equals("1")){
	    	 	sql ="select count(1) from "+tableName+" where "+fieldName+" is not null ";
	    	 }else{
		    	 if(fielddbtype.toUpperCase().indexOf("varchar(".toUpperCase())>-1||fielddbtype.toUpperCase().indexOf("char(".toUpperCase())>-1){
		    	 	sql ="select count(1) from "+tableName+" where "+fieldName+" is not null and "+fieldName+" !='' ";
		    	 }else if(fielddbtype.toUpperCase().indexOf("varchar2(".toUpperCase())>-1||fielddbtype.toUpperCase().indexOf("decimal(".toUpperCase())>-1||fielddbtype.toUpperCase().indexOf("INTEGER")>-1
		    	 	||fielddbtype.toUpperCase().indexOf("NUMBER(")>-1||fielddbtype.toUpperCase().indexOf("int".toUpperCase())>-1){
		    	 	sql ="select count(1) from "+tableName+" where "+fieldName+" is not null ";
		    	 }else{
	    			 sql ="select count(1) from "+tableName+" where "+fieldName+" is not null and "+fieldName+" !='' ";
		    	 }
	    	 }
	    	 //System.out.println("fieldName:"+fieldName+">fieldhtmltype:"+fieldhtmltype+">type:"+type+">fielddbtype:"+fielddbtype+">"+sql);
	    	 rsformmode.executeSql(sql);
	    	 if(rsformmode.next()){
	    		 return rsformmode.getInt(1)==0?true:false;
	    	 }
	     }
	     return false;
	}
%>
<%

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
List notExitsList = new ArrayList();
int formid = Util.getIntValue(request.getParameter("formid"),0);
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
boolean isoracle = (rs.getDBType()).equals("oracle") ;
boolean canDelete = true;
String tablename = "";
rs.executeSql("select tablename from workflow_bill where id="+formid);//如果表单已使用，则表单字段不能删除
if(rs.next()){
	tablename = Util.null2String(rs.getString("tablename"));
	if(!tablename.equals("")){
		String sql_tmp = "";
		if("ORACLE".equalsIgnoreCase(rs.getDBType())){
			sql_tmp = "select * from "+tablename+" where rownum<2";
		}else{
			sql_tmp = "select top 1 * from "+tablename;
		}
		rs.executeSql(sql_tmp);//如果表单已使用，则表单字段不能删除
		if(rs.next()) canDelete = false;
	}
}
String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
boolean canChange = false;
//添加判断表单建模中，是否应用
rs.executeSql("select 1 from workflow_base where formid="+formid);
if(rs.getCounts()<=0){//如果表单还没有被引用，字段可以修改。
    canChange = true;
}
boolean isFormmodeUse = false;
rs.executeSql("select 1 from modeinfo where formid="+formid);
if(rs.getCounts()>0){
	isFormmodeUse = true;
}
boolean isFieldNoValueCanEdit = false;
if(isFromMode==1){
	FormModeConfig formModeConfig = new FormModeConfig();
	isFieldNoValueCanEdit = formModeConfig.isFieldNoValueCanEdit();
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>


<%
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
int detailtables = 0;
int detailtableMaxIndex = 0;
String detailtableIndexs = ",";
RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
while(RecordSet.next()){
	detailtables++;
	detailtableMaxIndex = RecordSet.getInt("orderid");
	detailtableIndexs += ""+detailtableMaxIndex+",";
}

String tablenameString = SystemEnv.getHtmlLabelName(15190,user.getLanguage())+"："+tablename;

String sql = "select * from workflow_billfield where billid="+formid+" and viewtype=0 order by dsporder,id";
RecordSet.executeSql(sql);

String treeSql = "select a.id,a.treename from mode_customtree a where a.showtype=1  order by a.treename";
rs2.executeSql(treeSql);
List treeList = new ArrayList();
while(rs2.next()){
	Map map = new HashMap();
	map.put("id",rs2.getString("id"));
	map.put("treebrowsername",rs2.getString("treename"));
	treeList.add(map);
}


String textheight_2 = "";
Map th_2_map = FormManager.getRightAttr(user.getLanguage());
%>

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())+ tablenameString%>'>
		<wea:item type="groupHead">
			<button type=button  class=addbtn accessKey=A onClick="addRow()" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></button> 
			<button type=button  class=delbtn accessKey=E onClick="deleteRow()" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></button>
			<button type=button  class=copybtn accessKey=C onClick="copyRow()" title="C-<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"></button>		
		</wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	  	    <table class=ListStyle id="oTable" cols=2  border=0 cellspacing=1>
		      	<colgroup>
					<col width="5%">
					<col width="12%">
					<col width="10%">
					<col width="68%">
					<col width="5%">
				</colgroup>
	            <tr class=header>
		            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
		            <td><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
		            <td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
		            <td><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
		            <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
	            </tr>
				<%
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
		        String locateType = "";  //定位方式： 1：手动，2自动
		        int selectitem = 0;
		        int linkfield = 0;
		        int textheight = 0;
		        int qfws=0;	
		        
		        String selectItemType = "0";
				int pubchoiceId = 0;
				String pubchoicespan = "";
				int pubchilchoiceId = 0;
				String pubchilchoicespan = "";
				boolean isShowPubChildOption = false;
				
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
					locateType = Util.null2String(RecordSet.getString("locatetype"));
					qfws=Util.getIntValue(Util.null2String(RecordSet.getString("qfws")),2);
					dsporder = Util.null2String(RecordSet.getString("dsporder"));
					textheight = Util.getIntValue(Util.null2String(RecordSet.getString("textheight")),0);
					textheight_2 = Util.null2String(RecordSet.getString("textheight_2"));
					imgwidth = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgwidth")),0);
	                imgheight = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgheight")),0);
					int childfieldid_tmp = Util.getIntValue(RecordSet.getString("childfieldid"));
					selectitem = Util.getIntValue(Util.null2String(RecordSet.getString("selectitem")),0);
					linkfield = Util.getIntValue(Util.null2String(RecordSet.getString("linkfield")),0);
					
					selectItemType = Util.null2o(RecordSet.getString("selectItemType"));
				    pubchoiceId = Util.getIntValue(Util.null2String(RecordSet.getString("pubchoiceId")),0);
				    pubchilchoiceId = Util.getIntValue(Util.null2String(RecordSet.getString("pubchilchoiceId")),0);
				    pubchoicespan = SelectItemManager.getPubchoiceName(pubchoiceId);
					pubchilchoicespan = SelectItemManager.getPubchilchoiceFieldName(pubchilchoiceId,user.getLanguage());
					if(!pubchoicespan.equals("")){
						pubchoicespan = "<a title='" + pubchoicespan + "' href='javaScript:eidtSelectItem("+pubchoiceId+")'>" + pubchoicespan + "</a>&nbsp";
					}
					
					isShowPubChildOption = SelectItemManager.hasPubChoice(formid,0,"");
					
					String childfieldStr = "";
					Hashtable childItem_hs = new Hashtable();
					if(childfieldid_tmp > 0){
						rs_child.execute("select fieldlabel from workflow_billfield where id="+childfieldid_tmp);
						if(rs_child.next()){
							int childfieldlabel = rs_child.getInt("fieldlabel");
							childfieldStr = SystemEnv.getHtmlLabelName(childfieldlabel, user.getLanguage());
						}
						rs_child.execute("select * from workflow_SelectItem where isbill=1 and fieldid="+childfieldid_tmp);
						while(rs_child.next()){
							int selectvalue_tmp = Util.getIntValue(rs_child.getString("selectvalue"), -1);
							String selectname_tmp = Util.null2String(rs_child.getString("selectname"));
							childItem_hs.put("item_"+selectvalue_tmp, selectname_tmp);
						}
					}
					String para = fieldname+"+0+"+fieldhtmltype+"+ +"+formid+"+"+type;
					String canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox(para);
					boolean isFieldCannotChange = false;
					if(isFromMode!=1){//流程表单
						isFieldCannotChange = !canChange;
					}else{//表单建模表单
						isFieldCannotChange = !isFormModeFieldCanChange(isFormmodeUse,isFieldNoValueCanEdit, tablename, fieldname,fieldhtmltype,type,fielddbtype);
					}
	%>
				<tr class="DataDark">
					<td NOWRAP> 
						<input type='checkbox' notBeauty=true name='check_select' value="<%=fieldid%>_<%=rowsum%>" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%> >
						<input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
					</td>
					<td NOWRAP >
						<%if(isFieldCannotChange){%>
						<input   class=InputStyle0 type=hidden name="itemDspName_<%=rowsum%>"   value="<%=Util.toScreen(fieldname,user.getLanguage())%>">
						<span id="itemDspName_<%=rowsum%>_span"><%=Util.toScreen(fieldname,user.getLanguage())%></span>
						<%}else{%>
						<input class=InputStyle0 type=text name="itemDspName_<%=rowsum%>"   value="<%=Util.toScreen(fieldname,user.getLanguage())%>" onchange="checkKey(this);checkinput('itemDspName_<%=rowsum%>','itemDspName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
						<span id="itemDspName_<%=rowsum%>_span"></span>
						<%}%>
						<input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
					</td>
					<td NOWRAP >
						<input class='InputStyle1' type=text name="itemFieldName_<%=rowsum%>" value="<%=Util.toScreen(fieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_<%=rowsum%>','itemFieldName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
						<span id="itemFieldName_<%=rowsum%>_span"></span>
					</td>
					<td NOWRAP >
						<div style="display:block;float:left;">
						<select class='InputStyle' notBeauty=true style="float:left;width:90px!important;" name='itemFieldType_<%=rowsum%>' <%if(isFieldCannotChange){%>disabled<%}%> onChange="onChangItemFieldType(<%=rowsum%>);setChange(<%=rowsum%>)">
							<option value='1' <%if(fieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
							<option value='2' <%if(fieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
							<option value='3' <%if(fieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
							<option value='4' <%if(fieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
							<option value='5' <%if(fieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
							<option value='6' <%if(fieldhtmltype.equals("6")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
							<option value='7' <%if(fieldhtmltype.equals("7")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
							<%if(isFromMode !=1){%>
							<option value='9' <%if(fieldhtmltype.equals("9")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(125583,user.getLanguage())%></option>
							<%}%>
						</select>&nbsp;&nbsp;
						<%if(isFieldCannotChange){%>
						<input type="hidden" value="<%=fieldhtmltype%>" name="itemFieldType_<%=rowsum%>">
						<%}%>
						</div>
						<div id="div1_<%=rowsum%>" <%if(fieldhtmltype.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
							<select class='InputStyle' style="width:90px!important;" notBeauty=true name='documentType_<%=rowsum%>' <%if(isFieldCannotChange){%>disabled<%}%> onChange='onChangType(<%=rowsum%>);setChange(<%=rowsum%>)'>
								<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
								<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
								<option value='3' <%if(type.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
								<option value='4' <%if(type.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
								<option value='5' <%if(type.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
							</select>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=type%>" name="documentType_<%=rowsum%>"><%}%>
						</div>
						<div id="div1_1_<%=rowsum%>" <%if(fieldhtmltype.equals("1")&&type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%
							int maxlength = 0;
							if(isoracle){
								if(!fieldhtmltype.equals("3")&&!type.equals("17")){
								    rs.executeSql("select max(lengthb("+fieldname+")) from "+tablename);
								    if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
								}
							}else{
							    rs.executeSql("select max(datalength("+fieldname+")) from "+tablename);
							    if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
							}
							//out.println("maxlength=="+maxlength);
							%>
							<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>
							<input class='InputStyle' type='text' size=3 maxlength=3 value='<%=fieldlength%>' id='itemFieldScale1_<%=rowsum%>' name='itemFieldScale1_<%=rowsum%>' onKeyPress='setChange(<%=rowsum%>);ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_<%=rowsum%>,itemFieldScale1span_<%=rowsum%>);checkcount1(itemFieldScale1_<%=rowsum%>);checkmaxlength(<%=maxlength%>,itemFieldScale1_<%=rowsum%>)' style='text-align:right;padding-right:1px;'><span id=itemFieldScale1span_<%=rowsum%>><%if(fieldlength.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
						</div>
						<div id="div1_3_<%=rowsum%>" <%if((fieldhtmltype.equals("1")&&type.equals("3"))||(fieldhtmltype.equals("1")&&type.equals("5"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
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

						   		if(fieldhtmltype.equals("1")&&type.equals("5")){
								  decimaldigits=qfws;
							   }
							%>
							<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
							<%if(isFieldCannotChange){%>
							<input type="hidden" id="decimaldigits_<%=rowsum%>" name="decimaldigits_<%=rowsum%>" value="<%=decimaldigits%>">
							<select id="decimaldigitshidden_<%=rowsum%>" notBeauty=true name="decimaldigitshidden_<%=rowsum%>" size="1" disabled>
							<%}else{%>
							<select id="decimaldigits_<%=rowsum%>" notBeauty=true name="decimaldigits_<%=rowsum%>" onchange="setChange(<%=rowsum%>)" size="1">
							<%}%>
								<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
								<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
								<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
								<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
							</select>
						</div>
						<div id="div9_<%=rowsum%>" <%if(fieldhtmltype.equals("9")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
							<select class='InputStyle' style="width:90px!important;" notBeauty=true name='locationType_<%=rowsum%>' <%if(isFieldCannotChange){%>disabled<%}%> onChange='onChangType(<%=rowsum%>);setChange(<%=rowsum%>)'>
								<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%></option>
							</select>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=type%>" name="locationType_<%=rowsum%>"><%}%>
						</div>
						<%-- 
						<div id="div9_1_<%=rowsum%>" <%if((fieldhtmltype.equals("9")&&type.equals("1"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%> <!-- 定位方式 -->
							<%if(isFieldCannotChange){%>
							<select id="locateTypehidden_<%=rowsum%>" notBeauty=true name="locateTypehidden_<%=rowsum%>" size="1" disabled>
							<%}else{%>
							<select id="locateType_<%=rowsum%>" notBeauty=true name="locateType_<%=rowsum%>" onchange="setChange(<%=rowsum%>)" size="1">
							<%}%>
								<option value="1" <%if(locateType.equals("1")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage())%></option>
								<option value="2" <%if(locateType.equals("2")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option>
							</select>
						</div>
						--%>
						<div id="div2_<%=rowsum%>" <%if(fieldhtmltype.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
							<input class='InputStyle' type='text' size=4 maxlength=2 value='<%=textheight%>' id='textheight_<%=rowsum%>' name='textheight_<%=rowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChange(<%=rowsum%>)' onblur='checkPlusnumber1(this);checkcount1(textheight_<%=rowsum%>)' style='text-align:right;padding-right:1px;'>
							<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
							<input type='checkbox' notBeauty=true <%if(type.equals("2")){%> checked <%}%> <%if(isFieldCannotChange){%>disabled<%}%>>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=type%>" name="htmledit_<%=rowsum%>"><%}%>
						</div>
						<div id="div3_<%=rowsum%>" <%if(fieldhtmltype.equals("3")){%>style="display:inline;float:left"<%}else{%>style="display:none;float:left"<%}%>>
							<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
							<%
								//当下面的select为disabled时，需要使用此隐藏域负责传值，否则将取不到此值，导致错误
								if(isFieldCannotChange){
							%>	
								<input type="hidden" name='broswerType_<%=rowsum%>' value="<%=type%>"/> 	
							<%
								}
							%>
							<select notBeauty=true style="width: 105px!important;" notBeauty=true class='InputStyle <%if(isFromMode!=1 && canChange){%>autoSelect<%}else{if(!isFieldCannotChange){%>autoSelect<%}}%>' name='broswerType_<%=rowsum%>' <%if(isFieldCannotChange){%>disabled<%}%> onChange="onChangBroswerType(<%=rowsum%>);setChange(<%=rowsum%>)">
							<option></option>
							<%while(browserComInfo.next()){
							if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
								continue;
							}
							
							if (browserComInfo.notCanSelect()) continue;
							%>
								<option match="<%=browserComInfo.getBrowserPY(user.getLanguage())%>" value="<%=browserComInfo.getBrowserid()%>" <%if(type.equals(""+browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
							<%}%>
							</select>
							<span id='selecthtmltypespan' style='display:none;'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
						</div>
						<div id="div3_0_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225")||type.equals("226")||type.equals("227")||type.equals("256")||type.equals("257"))&&fielddbtype.equals("")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
						</div>
					 
						<div id="div3_1_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
							<brow:browser width="105px" viewType="0" name='<%="definebroswerType_" + rowsum%>'
								browserValue='<%=(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))) ? fielddbtype : ""%>'
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
								browserDialogWidth="550px"
								browserDialogHeight="650px"
								_callback="setChange0"
								_callbackParams='<%="" + rowsum%>'
								browserSpanValue='<%=(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))) ? UserDefinedBrowserTypeComInfo.getName(fielddbtype) : ""%>'></brow:browser>
						</div>
					
						<div id="div3_4_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
							<select class='InputStyle' name='sapbrowser_<%=rowsum%>' notBeauty=true <%if(isFieldCannotChange){%>disabled<%}%> onChange="div3_4_show(<%=rowsum%>);setChange(<%=rowsum%>)">
							<%
							List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
							for(int j=0;j<AllBrowserId.size();j++){
							%>
								<option value='<%=AllBrowserId.get(j)%>' <%if(fielddbtype.equals(""+AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
							<%}%>
							</select>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=fielddbtype%>" name="definebroswerType_<%=rowsum%>"><%}%>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=fielddbtype%>" name="sapbrowser_<%=rowsum%>"><%}%>
						</div>
					
						<!-- zzl--start -->
							
						<div id="div3_5_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
							<button type=button  class='Browser browser' name='newsapbrowser_<%=rowsum%>' id='newsapbrowser_<%=rowsum%>'  onclick='OnNewChangeSapBroswerType(<%=rowsum%>)'></button>
							<span id='showinner_<%=rowsum%>'><%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);}%></span>
							<span id='showimg_<%=rowsum%>'><%if(type.equals("226")||type.equals("227")){out.print("");}else{out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");}%></span>
							<input type="hidden" value="<%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);}%>" name="definebroswerType_<%=rowsum%>">
							<input type="hidden" value="<%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);}%>" name='showvalue_<%=rowsum%>' id='showvalue_<%=rowsum%>' >
						</div>
						
						<!-- zzl--end -->
						
						<div id="div3_7_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>><!-- 自定义树形单选 -->
						<%
						String treename = "";
						if(type.equals("256")||type.equals("257")){
							treeSql = "select a.id,a.treename from mode_customtree a where a.id="+fielddbtype;
							rs2.executeSql(treeSql);
							if(rs2.next()){
								treename = rs2.getString("treename");
							}
						}
						
						%>
						<brow:browser width="105px" viewType="0" name='<%="defineTreeBroswerType_" + rowsum%>'
								browserValue='<%=(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))) ? fielddbtype : ""%>'
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
								browserDialogWidth="550px"
								browserDialogHeight="650px"
								_callback="setChange0"
								_callbackParams='<%="" + rowsum%>'
								browserSpanValue='<%=(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))) ? treename : ""%>'></brow:browser>
					</div>
					
					<%
				  		
			  		String th_2[] = textheight_2.split(",");
			  		String th_2_span = "";
			  		for(int k=0;k<th_2.length;k++){
			  			if(th_2[k].equals("0") || th_2[k].equals(""))continue;
			  			th_2_span += ","+th_2_map.get(th_2[k]);
			  		}
			  		if(!th_2_span.equals("")) th_2_span = th_2_span.substring(1);
			  		
			  	    %>
					
						<div id="div3_2_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("165")||type.equals("166")||type.equals("167")||type.equals("168"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
							<div style='float:left;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %></div>
						    <brow:browser width="105px" viewType="0" name='<%="decentralizationbroswerType_" + rowsum%>'
								browserValue='<%=textheight_2%>'
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
								browserDialogWidth="400px"
							    browserDialogHeight="290px"
								_callback="setChange0"
								_callbackParams='<%="" + rowsum%>'
								browserSpanValue='<%=th_2_span%>'></brow:browser>
						</div>  
						 
						<div id="div5_<%=rowsum%>" <%if(fieldhtmltype.equals("5")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
						
							<div style="float: left;">
							    <span style="float: left;vertical-align:middle;line-height:30px;"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
							    <select id="selectItemType<%=rowsum%>" name="selectItemType<%=rowsum%>" notBeauty=true class=inputstyle  <%if(!canChange){%>disabled<%}%> style="float: left;width: 100px !important;" onchange="selectItemTypeChange('selectItemType',<%=rowsum%>);setChange(<%=rowsum%>);">
				                    <option value="0" <%if(selectItemType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>
				                    <option value="1" <%if(selectItemType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>
				                    <%if(isShowPubChildOption){ %>
				                    <option value="2" <%if(selectItemType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>
				                    <%} %>
				                </select>
				                
				                <%if(!canChange){%>
				                	<input name="selectItemType<%=rowsum%>" type="hidden" value="<%=selectItemType %>"/>
				                <%}%>
							</div>
							
							<div id="pubchoiceIdDIV<%=rowsum%>" style="<%if(!selectItemType.equals("1")){ %>display:none;<%} %> float: left;margin-left:10px;">
			                	<brow:browser width="150px" viewType="0" name='<%="pubchoiceId"+rowsum%>'
							    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp"
							    completeUrl="/data.jsp?type=pubChoice"
								hasInput="true" isSingle="true"
								isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
								browserValue='<%=pubchoiceId+""%>'
								browserSpanValue='<%=pubchoicespan%>'
								browserDialogWidth="550px"
								browserDialogHeight="650px" 
								afterDelParams = '<%="{rowsum:" + rowsum+"}"%>'
								afterDelCallback="delpubchoiceIdCallback"
								_callbackParams='<%="" + rowsum%>'
								_callback="setPreviewPub"></brow:browser>
								
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="line-height:30px;">
									<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
								</span>
								
								<select id="previewPubchoiceId<%=rowsum%>" name="previewPubchoiceId<%=rowsum%>" notBeauty=true onfocus="setPreviewPub0('<%="" + rowsum%>')">
									<option value="" ></option>
									<%
									if(selectItemType.equals("1") && pubchoiceId>0){
										Map<String,String> pubchoiceMap = SelectItemManager.getPubChoiceMap(pubchoiceId+"");
										for(Map.Entry<String, String> entry: pubchoiceMap.entrySet()){
											out.println("<option value=\""+entry.getKey()+"\" > "+entry.getValue()+"</option>");
										}
									}
									 %>
								</select>
			                </div>
			                <%String cpurl = "javascript:getcompleteurl('0#"+fieldid+"#0#"+rowsum+"')";
			                String browparam = "'0#"+fieldid+"#0#"+rowsum+"'";%>
			                <div id="pubchilchoiceIdDIV<%=rowsum%>" style="<%if(!selectItemType.equals("2")){ %>display:none;<%} %> float: left;margin-left:10px;">
			                	<span style='float:left;line-height:30px;margin-right:10px;'><%=SystemEnv.getHtmlLabelName(124957 ,user.getLanguage()) %></span>
			                	<brow:browser width="150px" viewType="0" name='<%="pubchilchoiceId"+rowsum%>'
							    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&url=/workflow/selectItem/selectItemSupFieldBrowser.jsp"
							    completeUrl='<%=cpurl%>'
								hasInput="true" isSingle="true"
								isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
								browserValue='<%=pubchilchoiceId+""%>'
								browserSpanValue='<%=pubchilchoicespan%>'
								browserDialogWidth="550px"
								_callbackParams='<%="" + rowsum%>'
								_callback="setChange0"
								afterDelParams = '<%="{rowsum:" + rowsum+"}"%>'
								afterDelCallback="delPubchilchoiceIdCallback"
								browserDialogHeight="650px" 
								getBrowserUrlFnParams='<%=browparam%>'
								getBrowserUrlFn="onShowPubchilchoiceId"></brow:browser>
			                </div>
			                
							<div id="childfielddiv<%=rowsum%>" style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>float: left;">
								<span style="padding-left:10px;">
								<input class='e8_btn_submit' type='button' id='childfieldbtn<%=rowsum%>' name='childfieldbtn<%=rowsum%>' onclick='childfieldFun(<%=fieldid %>,<%=rowsum%>)' value='<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>'/>
								</span>
								
								<span id="childfieldoptionspan<%=rowsum%>">
								     &nbsp;&nbsp;&nbsp;&nbsp;
								     <span style="line-height:30px;">
								     	<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
								     </span>
									<select notBeauty=true id="childfieldoption<%=rowsum%>" name="childfieldoption<%=rowsum%>"  onfocus="childfieldoption('<%=fieldid+","+rowsum %>')">
										<option value="" ></option>
										<%
										if(Util.getIntValue(fieldid)>0){
											Map<String,String> selectItemOptionMap = SelectItemManager.getSelectItemOption(fieldid+"");
											for(Map.Entry<String, String> entry: selectItemOptionMap.entrySet()){
												out.println("<option title=\""+entry.getValue()+"\" value=\""+entry.getKey()+"\" > "+entry.getValue()+"</option>");
											}
										}
										%>
									</select>
								</span>
								
						  	</div>
						
						
						</div>
						
						<div id="div8_<%=rowsum%>" <%if(fieldhtmltype.equals("8")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<span style="padding: 5px;">
								<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
							</span>
								<%
									String selectitemname = "";
							 		rs.executeSql("select a.id,a.selectitemname from mode_selectitempage a where a.id="+selectitem);
									while(rs.next()){
										selectitemname = rs.getString("selectitemname");
									}
								%>
								<input type='text' class='InputStyle' style='width:120px !important;padding-left:5px;' readonly='readonly' <%if(canDeleteCheckBox.equals("false")){%>disabled="disabled"<%} %> id='selectType_<%=rowsum%>Span' name='selectType_<%=rowsum%>Span' value="<%=selectitemname %>" >
								<button type='button' class='Browser' <%if(canDeleteCheckBox.equals("false")){%>disabled="disabled"<%} %> style='margin-left:10px;' onClick=showModalDialogSelectItem(selectType_<%=rowsum%>,selectType_<%=rowsum%>Span,<%=rowsum%>) id='selectItemBtn_<%=rowsum%>' name='selectItemBtn_<%=rowsum%>'></BUTTON>
								<input type='hidden' id='selectType_<%=rowsum%>' name='selectType_<%=rowsum%>'  value="<%=selectitem %>">
						</div>
						<div id="div8_0_<%=rowsum%>" <%if(fieldhtmltype.equals("8")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<span style="padding: 5px;">
								<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>
							</span>
								<button type='button' class='Browser' onClick=onShowChildCommonSelectItem(childCommonItemSpan_<%=rowsum%>,childCommonItem_<%=rowsum%>,'_<%=rowsum%>') id='selectChildItem_detail_<%=rowsum%>' name='selectChildItem_detail_<%=rowsum%>'></BUTTON>
								<input type='hidden' id='childCommonItem_<%=rowsum%>' name='childCommonItem_<%=rowsum%>' value='<%=linkfield %>' >
								<span id='childCommonItemSpan_<%=rowsum%>' name='childCommonItemSpan_<%=rowsum%>'>
								<%
							 		rs.executeSql("select * from workflow_billfield where billid = '"+formid+"' and fieldhtmltype = 8");
									while(rs.next()){
										int linkfieldId = rs.getInt("id");
										int linkfieldname = rs.getInt("fieldlabel");
										if(linkfieldId == linkfield){
										%>
										<%=SystemEnv.getHtmlLabelName(linkfieldname,user.getLanguage()) %>
										<%
										}
									}
								%>
								</span>
						</div>
					    <div id="div6_<%=rowsum%>" <%if(fieldhtmltype.equals("6")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
							<select class='InputStyle' name='uploadtype_<%=rowsum%>' notBeauty=true <%if(isFieldCannotChange){%>disabled<%}%> onChange="onuploadtype(this, <%=rowsum%>);setChange(<%=rowsum%>)">
								<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
								<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
							</select>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=type%>" name="uploadtype_<%=rowsum%>"><%}%>
						</div>
						<div id="div6_1_<%=rowsum%>" <%if(fieldhtmltype.equals("6")&&type.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>
							<input  type=input class="InputStyle" size=6 maxlength=3 name="strlength_<%=rowsum%>" onchange='setChange(<%=rowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=textheight%>">
							<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
							<input  type=input class="InputStyle" size=6 maxlength=4 name="imgwidth_<%=rowsum%>"  onchange='setChange(<%=rowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=imgwidth%>">
							<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>
							<input  type=input class="InputStyle" size=6 maxlength=4 name="imgheight_<%=rowsum%>" onchange='setChange(<%=rowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=imgheight%>">
						</div>
					            
						<div id="div7_<%=rowsum%>" <%if(fieldhtmltype.equals("7")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
							<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
							<select class='InputStyle' name='specialfield_<%=rowsum%>' notBeauty=true <%if(isFieldCannotChange){%>disabled<%}%> onChange="specialtype(this, <%=rowsum%>);setChange(<%=rowsum%>)">
								<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
								<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
							</select>
							<%if(isFieldCannotChange){%><input type="hidden" value="<%=type%>" name="specialfield_<%=rowsum%>"><%}%>
						</div>
					    <%
						String displayname = "";
						String linkaddress = "";
						String descriptivetext = "";
						if(fieldhtmltype.equals("7")){
						   rs.executeSql("select * from workflow_specialfield where fieldid = " + fieldid + " and isbill = 1");
						   rs.next();
						   displayname = rs.getString("displayname");
						   linkaddress = rs.getString("linkaddress");
						   descriptivetext = rs.getString("descriptivetext");
						}
						%>
						<div id="div7_1_<%=rowsum%>" <%if(fieldhtmltype.equals("7")&&type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>><table width="100%"><tr><td width="100%"><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>　　<input class=inputstyle type=text name=displayname_<%=rowsum%> id=displayname_<%=rowsum%> size=25 value="<%=displayname%>" maxlength=1000 onchange='setChange(<%=rowsum%>)'>　</td></tr><tr><td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　<input class=inputstyle type=text size=25 name=linkaddress_<%=rowsum%> id=linkaddress_<%=rowsum%> value="<%=linkaddress%>" maxlength=1000 onchange='setChange(<%=rowsum%>)'><br><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%></td></tr></table></div>	
						<div id="div7_2_<%=rowsum%>" <%if(fieldhtmltype.equals("7")&&!type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>><table width="100%"><tr><td width="12%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td style="padding-top: 1px;padding-bottom: 1px;"><textarea class='inputstyle' style='resize:none;width:88%;height:100px' name=descriptivetext_<%=rowsum%> id=descriptivetext_<%=rowsum%> onchange='setChange(<%=rowsum%>)'><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea></td></tr></table></div>				  				  		    		
					</td>
					<td NOWRAP >
						<input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_<%=rowsum%>'  value = '<%=dsporder%>' onKeyPress='ItemNum_KeyPress("itemDspOrder_<%=rowsum%>")' onchange='checknumber("itemDspOrder_<%=rowsum%>");checkDigit("itemDspOrder_<%=rowsum%>",15,2);setChange(<%=rowsum%>)' style='text-align:right;width: 50px!important;'   >
					</td>
				</tr>
				<%	
				rowsum++;
				}
				%>
			</table>		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>' attributes="{'itemAreaDisplay':''}">
		<wea:item type="groupHead">
			<button type=button  class=addbtn onClick="addDetailTable()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18903,user.getLanguage())%>"></button>
		</wea:item>	
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<table class=ListStyle>
				<%
				boolean isShowDetailPubChildOption = false;
				int tempint = 0;
				RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
				while(RecordSet.next()){
					tempint++;
					String detailtablename = RecordSet.getString("tablename");
					String tableNumber = RecordSet.getString("orderid");
					String multiBrowsername="";
					RecordSet3.executeSql("select * from sap_multiBrowser where mxformname='"+detailtablename+"' and mxformid='"+formid+"' ");
					if(RecordSet3.next()){
							multiBrowsername=RecordSet3.getString("browsermark");
					}
					
					isShowDetailPubChildOption = SelectItemManager.hasPubChoice(formid,1,detailtablename);
				%>
				<tr>
					<td class=field style="padding-left: 0px;">
						<table id="detailTable_<%=tableNumber%>" class=ListStyle   border=0 cellspacing=1>
				 			<input type="hidden" value="" name="detaildelids_<%=tableNumber%>">
							<input type="hidden" value="" name="detailChangeRowIndexs_<%=tableNumber%>">
							<colgroup>
								<col width="5%">
								<col width="12%">
								<col width="10%">
								<col width="50%">
								<col width="9%">
							</colgroup>
							<tr>
								<td colspan=4 width="60%"><div style="display:block;float:left;"><b><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+tempint%></b>
										
										<span style='margin-left:30px;margin-right:5px;'><b><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%>:</b></span>
										<input type='hidden' id='detailtablename_db_<%=tableNumber%>' name='detailtablename_db_<%=tableNumber%>' value="<%=detailtablename %>"/>
										<span id='detailtablename<%=tableNumber%>_span'><%=detailtablename %></span>&nbsp;&nbsp;
										</div>
										
										<%
											String browsername = "newsapmultiBrowservalue_"+tableNumber;
											String browserclick = "OnsapMultiBrowser('this',"+tableNumber+")";
										%>
										<div style="display:block;float:left;">
											<%=SystemEnv.getHtmlLabelName(30313,user.getLanguage())%>&nbsp;&nbsp;
										</div>
										<div style="display:block;float:left;width:120px;">
										
										<BUTTON id='newsapmultiBrowser_<%=tableNumber%>' class=Browser type="button" onclick='OnsapMultiBrowser(this,<%=tableNumber%>)'  name='newsapmultiBrowser_<%=tableNumber%>'></BUTTON>
										<SPAN id='newsapmultiBrowserinner_<%=tableNumber%>'><%=multiBrowsername %></SPAN>
										<INPUT id='newsapmultiBrowservalue_<%=tableNumber%>'   name='newsapmultiBrowservalue_<%=tableNumber%>'  type=hidden  value='<%=multiBrowsername %>'>
										
										 <%--
										<brow:browser viewType="0" name='<%=browsername %>' browserValue='<%=multiBrowsername %>' 
									          browserSpanValue='<%=multiBrowsername %>' browserOnClick='<%=browserclick %>' 
									          hasInput="true" isSingle="true" hasBrowser = "true"  
									          isMustInput='1' completeUrl="" 
									          needHidden="true" ></brow:browser>
									          </div>
									       --%>
									</td>
									<td colspan=1 align='right'>
										<button type='button' class=addbtn onClick="addDetailRow(<%=tableNumber%>)"></button>
										<button type='button' class=delbtn onClick="deleteDetailRow(<%=tableNumber%>)"></button>
										<button type='button' class=copybtn onClick="copyDetailRow(<%=tableNumber%>)"></button>
									</td>
							</tr>
							
							<tr class=header>
								<td NOWRAP><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
								<td NOWRAP><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
								<td NOWRAP><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
								<td NOWRAP><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
								<td NOWRAP><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td> 
							</tr>
				 			<%
				 			String dbdetailfieldnamesForCompare = ",";
				 			String trDetailClass="DataLight";
				 			int detailrowsum=0;
				 			
							String detailfieldname = "";//数据库字段名称
					 		int detailfieldlabel = 0;//字段显示名标签id
					 		String detailfielddbtype = "";//字段数据库类型
					 		String detailfieldhtmltype = "";//字段页面类型
					 		String detailtype = "";//字段详细类型
					 		String detaildsporder = "";//显示顺序
					 		 String detailqfws="0";
					 		int detailselectitem = 0;
					 		int detaillinkfield = 0;
					 		String detailtextheight_2 = "";
					 		
					 		int detailtextheight = -1;
					 		String detailimgwidth = "";
					 		String detailimgheight = "";
					 		
					 		String detailselectItemType = "0";
							int detailpubchoiceId = 0;
							String detailpubchoicespan = "";
							int detailpubchilchoiceId = 0;
							String detailpubchilchoicespan = "";
							
				 			RecordSet1.executeSql("select * from workflow_billfield where billid="+formid+" and viewtype=1 and detailtable='"+detailtablename+"' order by dsporder,id");
				 			while(RecordSet1.next()){
				 				detailrowsum++;
								String detailfieldid = RecordSet1.getString("id");
								detailfieldname = RecordSet1.getString("fieldname");
								dbdetailfieldnamesForCompare += detailfieldname.toUpperCase()+",";
								detailfieldlabel = RecordSet1.getInt("fieldlabel");
								String detailfieldlabelname = SystemEnv.getHtmlLabelName(detailfieldlabel,user.getLanguage());
								detailfielddbtype = RecordSet1.getString("fielddbtype");
								String detailfieldlength = "";
								detailfieldhtmltype = RecordSet1.getString("fieldhtmltype");
								detailtype = RecordSet1.getString("type");
								if(detailfieldhtmltype.equals("1")&&detailtype.equals("1")){
									detailfieldlength = detailfielddbtype.substring(detailfielddbtype.indexOf("(")+1,detailfielddbtype.indexOf(")"));
								}
								detailtextheight_2 = Util.null2String(RecordSet1.getString("textheight_2"));
								detailtextheight = Util.getIntValue(Util.null2String(RecordSet1.getString("textheight")),0);
								detailimgwidth = ""+Util.getIntValue(Util.null2String(RecordSet1.getString("imgwidth")),0);
								detailimgheight = ""+Util.getIntValue(Util.null2String(RecordSet1.getString("imgheight")),0);
								
								detailqfws=RecordSet1.getString("qfws");
								detaildsporder = Util.null2String(RecordSet1.getString("dsporder"));
								int childfieldid_tmp = Util.getIntValue(RecordSet1.getString("childfieldid"));
								detailselectitem = Util.getIntValue(Util.null2String(RecordSet1.getString("selectitem")),0);
								detaillinkfield = Util.getIntValue(Util.null2String(RecordSet1.getString("linkfield")),0);
								
								
								detailselectItemType = Util.null2o(RecordSet1.getString("selectItemType"));
							    detailpubchoiceId = Util.getIntValue(Util.null2String(RecordSet1.getString("pubchoiceId")),0);
							    detailpubchilchoiceId = Util.getIntValue(Util.null2String(RecordSet1.getString("pubchilchoiceId")),0);
							    detailpubchoicespan = SelectItemManager.getPubchoiceName(detailpubchoiceId);
								detailpubchilchoicespan = SelectItemManager.getPubchilchoiceFieldName(detailpubchilchoiceId,user.getLanguage());
								if(!detailpubchoicespan.equals("")){
									detailpubchoicespan = "<a title='" + detailpubchoicespan + "' href='javaScript:eidtSelectItem("+detailpubchoiceId+")'>" + detailpubchoicespan + "</a>&nbsp";
								}
								
								
								String childfieldStr = "";
								Hashtable childItem_hs = new Hashtable();
								if(childfieldid_tmp > 0){
									rs_child.execute("select fieldlabel from workflow_billfield where id="+childfieldid_tmp);
									if(rs_child.next()){
										int childfieldlabel = rs_child.getInt("fieldlabel");
										childfieldStr = SystemEnv.getHtmlLabelName(childfieldlabel, user.getLanguage());
									}
									rs_child.execute("select * from workflow_SelectItem where isbill=1 and fieldid="+childfieldid_tmp);
									while(rs_child.next()){
										int selectvalue_tmp = Util.getIntValue(rs_child.getString("selectvalue"), -1);
										String selectname_tmp = Util.null2String(rs_child.getString("selectname"));
										childItem_hs.put("item_"+selectvalue_tmp, selectname_tmp);
									}
								}
								String para = detailfieldname+"+1+"+detailfieldhtmltype+"+"+detailtablename+"+"+formid+"+"+detailtype;
					            String canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox(para);
					            boolean isFieldCannotChange = false;
								if(isFromMode!=1){//流程表单
									isFieldCannotChange = !canChange;
								}else{//表单建模表单
									isFieldCannotChange = !isFormModeFieldCanChange(isFormmodeUse,isFieldNoValueCanEdit, detailtablename, detailfieldname,detailfieldhtmltype,detailtype,detailfielddbtype);
								}
				 			%>
				 			<tr class=<%=trDetailClass%>>
					 			<td  height="23" >
								    <input type='checkbox' notBeauty=true name='check_select_detail_<%=tableNumber%>' value="<%=detailfieldid%>_<%=detailrowsum%>" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%> >
								    <input type='hidden' name='modifyflag_<%=tableNumber%>_<%=detailrowsum%>' value="<%=detailfieldid%>">
							    </td>
								<td NOWRAP >
									<%if(isFieldCannotChange){%>
									<input class=Inputstyle type=hidden name="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>" style="width:95px!important;" value="<%=Util.toScreen(detailfieldname,user.getLanguage())%>" >
									<span id="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>_span"><%=Util.toScreen(detailfieldname,user.getLanguage())%></span>
									<%}else{%>
									<input class=Inputstyle type=text name="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>" style="width:95px!important;"  value="<%=Util.toScreen(detailfieldname,user.getLanguage())%>" onchange="checkKey(this);checkinput('itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>','itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>_span');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
									<span id="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>_span"></span>
									<%}%>
									<input type=hidden name="olditemDspName_detail<%=tableNumber%>_<%=detailrowsum%>" value="<%=Util.toScreen(detailfieldname,user.getLanguage())%>">
								</td>			
								<td NOWRAP >
									<input class=Inputstyle1 type=text name="itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>" style="width:80px"   value="<%=Util.toScreen(detailfieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>','itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>_span');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
									<span id="itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>_span"></span>
								</td>
								<td NOWRAP >
									<div style="display:block;float:left;">
									<select style="float: left;width:90px!important;" class='InputStyle' notBeauty=true name="itemFieldType_<%=tableNumber%>_<%=detailrowsum%>" <%if(isFieldCannotChange){%>disabled<%}%> onChange="onChangDetailItemFieldType(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
										<option value='1' <%if(detailfieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
										<option value='2' <%if(detailfieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
										<option value='3' <%if(detailfieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
										<option value='4' <%if(detailfieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
										<option value='5' <%if(detailfieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
										<option value='6' <%if(detailfieldhtmltype.equals("6")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
									</select>&nbsp;&nbsp;</div>
								    <%if(isFieldCannotChange){%><input type="hidden" value="<%=detailfieldhtmltype%>" name="itemFieldType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
									<div id="detail_div1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("1")){%>style='display:inline'<%}else{%>style='display:none'<%}%>><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()).trim()%><select class='InputStyle' style="width:90px!important;" notBeauty=true name="documentType_<%=tableNumber%>_<%=detailrowsum%>" <%if(isFieldCannotChange){%>disabled<%}%> onChange="onChangDetailType(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
											<option value='1' <%if(detailtype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
											<option value='2' <%if(detailtype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
											<option value='3' <%if(detailtype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
											<option value='4' <%if(detailtype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
											<option value='5' <%if(detailtype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
										</select>&nbsp;&nbsp;
										<%if(isFieldCannotChange){%><input type="hidden" value="<%=detailtype%>" name="documentType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
									</div>
									
									<div id="detail_div6_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("6")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
										<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
										<select class='InputStyle' name='uploadtype_<%=tableNumber%>_<%=detailrowsum%>' notBeauty=true <%if(isFieldCannotChange){%>disabled<%}%> onChange="onDetailuploadtype(this, <%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
											<option value='1' <%if(detailtype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
											<option value='2' <%if(detailtype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
										</select>
										<%if(isFieldCannotChange){%><input type="hidden" value="<%=detailtype%>" name="uploadtype_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
									</div>
									<div id="detail_div6_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("6")&&detailtype.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
										<!-- <%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%> -->
										<!-- <input  type=input class="InputStyle" size=6 maxlength=3 name="strlength_<%=tableNumber%>_<%=detailrowsum%>" onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=detailtextheight%>">-->
										<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
										<input  type=input class="InputStyle" size=6 maxlength=4 name="imgwidth_<%=tableNumber%>_<%=detailrowsum%>"  onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=detailimgwidth%>">
										<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>
										<input  type=input class="InputStyle" size=6 maxlength=4 name="imgheight_<%=tableNumber%>_<%=detailrowsum%>" onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=detailimgheight%>">
									</div>
									
									<%
									int maxlength = 0;
									if(isoracle){
										if(!detailfieldhtmltype.equals("3")&&!detailtype.equals("17")){
										    rs.executeSql("select max(lengthb("+detailfieldname+")) from "+detailtablename);
										    if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
										}
									}else{
									    rs.executeSql("select max(datalength("+detailfieldname+")) from "+detailtablename);
									    if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
									}
									//out.println("maxlength=="+maxlength);
									%>
									<div id="detail_div1_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("1")&&detailtype.equals("1")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  		<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>
									  	<input class='InputStyle' type='text' size=3 maxlength=3 value='<%=detailfieldlength%>' id='itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>' name='itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>' onKeyPress='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>);ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>,itemFieldScale1span_<%=tableNumber%>_<%=detailrowsum%>);checkcount1(itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>);checkmaxlength(<%=maxlength%>,itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>)' style='text-align:right;padding-right:1px;'><span id=itemFieldScale1span_<%=tableNumber%>_<%=detailrowsum%>><%if(detailfieldlength.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
									</div>
									<div id=detail_div8_<%=tableNumber%>_<%=detailrowsum%> <%if(detailfieldhtmltype.equals("8")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
											<%
												String detailSelectitemname = "";
										 		rs.executeSql("select a.id,a.selectitemname from mode_selectitempage a where a.id="+detailselectitem);
												while(rs.next()){
													 detailSelectitemname = rs.getString("selectItemname");
												}
											%>
										<input type='text' class='InputStyle' style='width:120px !important;padding-left:5px;' readonly='readonly' <%if(canDeleteCheckBox.equals("false")){%>disabled="disabled"<%} %> id='selectType_<%=tableNumber%>_<%=detailrowsum%>Span' name='selectType_<%=tableNumber%>_<%=detailrowsum%>Span' value="<%=detailSelectitemname %>" >
										<button type='button' class='Browser' <%if(canDeleteCheckBox.equals("false")){%>disabled="disabled"<%} %> style='margin-left:10px;' onClick=showModalDialogSelectItemDetail(selectType_<%=tableNumber%>_<%=detailrowsum%>,selectType_<%=tableNumber%>_<%=detailrowsum%>Span,<%=tableNumber%>,<%=detailrowsum%>) id='selectItemBtn_<%=tableNumber%>_<%=detailrowsum%>' name='selectItemBtn_<%=tableNumber%>_<%=detailrowsum%>'></BUTTON>
										<input type='hidden' id='selectType_<%=tableNumber%>_<%=detailrowsum%>' name='selectType_<%=tableNumber%>_<%=detailrowsum%>'  value="<%=detailselectitem %>">
									</div>
									<div id="detail_div8_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("8")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
										<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>
											<button type='button' class='Browser'  onClick=onShowChildCommonSelectItem(childCommonItemSpan_<%=tableNumber%>_<%=detailrowsum%>,childCommonItem_<%=tableNumber%>_<%=detailrowsum%>,'_detail<%=tableNumber%>_<%=detailrowsum%>') id='selectChildItem_detail_<%=tableNumber%>_<%=detailrowsum%>' name='selectChildItem_detail_<%=tableNumber%>_<%=detailrowsum%>'></BUTTON>
											<input type='hidden' id='childCommonItem_<%=tableNumber%>_<%=detailrowsum%>' name='childCommonItem_<%=tableNumber%>_<%=detailrowsum%>' value='<%=detaillinkfield %>' >
											<span id='childCommonItemSpan_<%=tableNumber%>_<%=detailrowsum%>' name='childCommonItemSpan_<%=tableNumber%>_<%=detailrowsum%>'>
											<%
										 		rs.executeSql("select * from workflow_billfield where billid = '"+formid+"' and fieldhtmltype = 8");
												while(rs.next()){
													int linkfieldId = rs.getInt("id");
													int detaillinkfieldname = rs.getInt("fieldlabel");
													if(linkfieldId == detaillinkfield){
													%>
													<%=SystemEnv.getHtmlLabelName(detaillinkfieldname,user.getLanguage()) %>
													<%
													}
												}
											%>
											</span>
									</div>
									<div id="detail_div1_3_<%=tableNumber%>_<%=detailrowsum%>" <%if((detailfieldhtmltype.equals("1")&&detailtype.equals("3"))||(detailfieldhtmltype.equals("1")&&detailtype.equals("5"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										<%
											int decimaldigits = 2;
											if(detailfieldhtmltype.equals("1")&&detailtype.equals("3")){
												int digitsIndex = detailfielddbtype.indexOf(",");
									        	if(digitsIndex > -1){
									        		decimaldigits = Util.getIntValue(detailfielddbtype.substring(digitsIndex+1, detailfielddbtype.length()-1), 2);
									        	}else{
									        		decimaldigits = 2;
									        	}
											}
											
											if(detailfieldhtmltype.equals("1")&&detailtype.equals("5")){
										  	  decimaldigits=Util.getIntValue(detailqfws, 2);
											}
										%>
								  		<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
										<%if(isFieldCannotChange){%>
										<input type="hidden" id="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" name="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" value="<%=decimaldigits%>">
										<select id="decimaldigitshidden_<%=tableNumber%>_<%=detailrowsum%>" notBeauty=true name="decimaldigitshidden_<%=tableNumber%>_<%=detailrowsum%>" size="1" disabled>
										<%}else{%>
										<select id="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" notBeauty=true name="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" onchange="setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)" size="1">
										<%}%>
											<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
											<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
											<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
											<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
										</select>
									</div>
									<div id="detail_div2_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("2")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
									  	<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
									  	<input class='InputStyle' type='text' size=4 maxlength=2 value='<%=RecordSet1.getString("textheight")%>' id='textheight_<%=tableNumber%>_<%=detailrowsum%>' name='textheight_<%=tableNumber%>_<%=detailrowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onblur='checkPlusnumber1(this);checkcount1(textheight_<%=tableNumber%>_<%=detailrowsum%>)' style='text-align:right;padding-right:1px;'>
									  	<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
									  	<input type='checkbox' notBeauty=true <%if(detailtype.equals("2")){%> checked <%}%> <%if(isFieldCannotChange){%>disabled<%}%>>
									  	<%if(isFieldCannotChange){%><input type="hidden" value="<%=detailtype%>" name="htmledit_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								    </div>
								  
								  	<div id="detail_div3_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")){%>style='display:inline;float: left;'<%}else{%>style='display:none;float: left;'<%}%>>
									  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
									  	<%
									  		//当下面的select为disabled时，需要使用此隐藏域负责传值，否则将取不到此值，导致错误
											if(isFieldCannotChange){
										%>
											<input type="hidden" name="broswerType_<%=tableNumber%>_<%=detailrowsum%>" value="<%=detailtype%>" />	
										<%		
											}
									  	%>
									  	<select notBeauty=true style="width: 105px!important;" notBeauty=true class='InputStyle class='InputStyle <%if(isFromMode!=1 && canChange){%>autoSelect<%}else{if(!isFieldCannotChange){%>autoSelect<%}}%>' name="broswerType_<%=tableNumber%>_<%=detailrowsum%>" <%if(isFieldCannotChange){%>disabled<%}%> onChange='onChangDetailBroswerType(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)'>
									  		<option></option>
									  		<%while(browserComInfo.next()){
									  				 if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
									  				 		continue;
									  				 }
									  				if (browserComInfo.notCanSelect()) continue;
									  			%>
									  			<option match="<%=browserComInfo.getBrowserPY(user.getLanguage())%>" value="<%=browserComInfo.getBrowserid()%>" <%if(detailtype.equals(""+browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
									  		<%}%>
									  	</select>
									  	<span id='selecthtmltypespan' style='display:none;'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
								  	</div>
								  
									<div id="detail_div3_0_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("224")||detailtype.equals("225")||detailtype.equals("226")||detailtype.equals("227"))&&detailfielddbtype.equals("")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										<span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
									</div>
								  
									<div id="detail_div3_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										<brow:browser width="105px" viewType="1" name='<%="definebroswerType_" + tableNumber + "_" + detailrowsum%>'
												browserValue='<%=(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))) ? detailfielddbtype : ""%>'
											    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
											    completeUrl="/data.jsp"
												hasInput="false" isSingle="true"
												isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
												browserDialogWidth="550px"
												browserDialogHeight="650px"
												_callback="setChangeDetail3"
												_callbackParams='<%=tableNumber + "," + detailrowsum%>'
												browserSpanValue='<%=(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))) ? UserDefinedBrowserTypeComInfo.getName(detailfielddbtype) : ""%>'></brow:browser>
									</div>
								  
									<div id="detail_div3_4_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("224")||detailtype.equals("225"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										<select class='InputStyle' notBeauty=true name='sapbrowser_<%=tableNumber%>_<%=detailrowsum%>' <%if(isFieldCannotChange){%>disabled<%}%> onchange="setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
										<%
										List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
										for(int j=0;j<AllBrowserId.size();j++){
										%>
											<option value='<%=AllBrowserId.get(j)%>' <%if(detailfielddbtype.equals(""+AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
										<%}%>
										</select>
										<%if(isFieldCannotChange){%><input type="hidden" value="<%=detailfielddbtype%>" name="sapbrowser_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
									</div>
								  <!-- zzl--start -->
									<div id="detail_div3_5_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("226")||detailtype.equals("227"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>> 
								  		<button type=button  class='Browser browser' name='newsapbrowser_<%=tableNumber%>_<%=detailrowsum%>' id='newsapbrowser_<%=tableNumber%>_<%=detailrowsum%>'  onclick="OnNewChangeSapBroswerTypeDetails('<%=tableNumber%>','<%=detailrowsum%>')"></button>
								  		 <span id='showinner_<%=tableNumber%>_<%=detailrowsum%>'><%if(detailtype.equals("226")||detailtype.equals("227")){out.print(detailfielddbtype);}%></span>
										<span id='showimg_<%=tableNumber%>_<%=detailrowsum%>'><%if(detailtype.equals("226")||detailtype.equals("227")){out.print("");}else{out.print("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");}%></span>
								  		<input type="hidden" value="<%if(detailtype.equals("226")||detailtype.equals("227")){out.print(detailfielddbtype);}%>" name='showvalue_<%=tableNumber%>_<%=detailrowsum%>' id='showvalue_<%=tableNumber%>_<%=detailrowsum%>' >
									</div>
								<!-- zzl--end -->
								
								<div id="detail_div3_7_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("256")||detailtype.equals("257"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>><!-- 自定义树形单选 -->
						
						<%
						String treename = "";
						if(detailtype.equals("256")||detailtype.equals("257")){
							treeSql = "select a.id,a.treename from mode_customtree a where a.id="+detailfielddbtype;
							rs2.executeSql(treeSql);
							if(rs2.next()){
								treename = rs2.getString("treename");
							}
						}
						
						%>
						<brow:browser width="105px" viewType="1" name='<%="defineTreeBroswerType_" + tableNumber + "_" + detailrowsum%>'
								browserValue='<%=(detailfieldhtmltype.equals("3")&&(detailtype.equals("256")||detailtype.equals("257"))) ? detailfielddbtype : ""%>'
							    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
							    completeUrl="/data.jsp"
								hasInput="false" isSingle="true"
								isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
								browserDialogWidth="550px"
								browserDialogHeight="650px"
								_callback="setChangeDetailtree"
								_callbackParams='<%=tableNumber + "," + detailrowsum%>'
								browserSpanValue='<%=(detailfieldhtmltype.equals("3")&&(detailtype.equals("256")||detailtype.equals("257"))) ? treename : ""%>'></brow:browser>
							
					</div>
					
					<%
				  		
			  		String th_2[] = detailtextheight_2.split(",");
			  		String th_2_span = "";
			  		for(int k=0;k<th_2.length;k++){
			  			if(th_2[k].equals("0") || th_2[k].equals(""))continue;
			  			th_2_span += ","+th_2_map.get(th_2[k]);
			  		}
			  		if(!th_2_span.equals("")) th_2_span = th_2_span.substring(1);
			  		
			  	    %>
									<div id="detail_div3_2_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("165")||detailtype.equals("166")||detailtype.equals("167")||detailtype.equals("168"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										<div style='float:left;line-height:30px;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %></div>
										<brow:browser width="105px" viewType="0" name='<%="decentralizationbroswerType_" + tableNumber+"_"+detailrowsum%>'
											browserValue='<%=detailtextheight_2%>'
										    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
										    completeUrl="/data.jsp"
											hasInput="false" isSingle="true"
											isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
											browserDialogWidth="400px"
											browserDialogHeight="290px"
											_callback="setChangeDetail0"
											_callbackParams='<%=tableNumber + "," + detailrowsum%>'
											browserSpanValue='<%=th_2_span%>'></brow:browser>
									
									</div>								  
								  
									<div id="detail_div5_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("5")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										
										<div style="float: left;">
										    <span style="float: left;vertical-align:middle;line-height:30px;"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
										    <select id="selectItemType<%=tableNumber%>_<%=detailrowsum%>" name="selectItemType<%=tableNumber%>_<%=detailrowsum%>" notBeauty=true class=inputstyle  <%if(!canChange){%>disabled<%}%> style="float: left;width: 100px !important;" onchange="selectItemTypeChange('selectItemType','<%=tableNumber%>_<%=detailrowsum%>');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>);">
							                    <option value="0" <%if(detailselectItemType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>
							                    <option value="1" <%if(detailselectItemType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>
							                    <%if(isShowDetailPubChildOption){ %>
							                    <option value="2" <%if(detailselectItemType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>
							                    <%} %>
							                </select>
							                
							                <%if(!canChange){%>
							                	<input name="selectItemType<%=tableNumber%>_<%=detailrowsum%>" type="hidden" value="<%=detailselectItemType %>"/>
							                <%}%>
										</div>
										
										<div id="pubchoiceIdDIV<%=tableNumber%>_<%=detailrowsum%>" style="<%if(!detailselectItemType.equals("1")){ %>display:none;<%} %> float: left;margin-left:10px;">
						                	<brow:browser width="150px" viewType="0" name='<%="pubchoiceId"+tableNumber+"_"+detailrowsum%>'
										    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp"
										    completeUrl="/data.jsp?type=pubChoice"
											hasInput="true" isSingle="true"
											isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
											browserValue='<%=detailpubchoiceId+""%>'
											browserSpanValue='<%=detailpubchoicespan%>'
											_callbackParams='<%=tableNumber+"_" + detailrowsum%>'
											_callback="setPreviewPub"
											
											afterDelParams = '<%="{tableNumber:" + tableNumber+",detailrowsum:"+detailrowsum+"}"%>'
											afterDelCallback="delDetailpubchoiceIdCallback"
											
											browserDialogWidth="550px"
											browserDialogHeight="650px" 
											></brow:browser>
											
											&nbsp;&nbsp;&nbsp;&nbsp;
											<span style="line-height:30px;">
												<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
											</span>
											
											<select id="previewPubchoiceId<%=tableNumber%>_<%=detailrowsum%>" name="previewPubchoiceId<%=tableNumber%>_<%=detailrowsum%>" notBeauty=true onfocus="setPreviewPub0('<%=tableNumber+"_" + detailrowsum%>')">
												<option value="" ></option>
												<%
												if(detailselectItemType.equals("1") && detailpubchoiceId>0){
													Map<String,String> pubchoiceMap = SelectItemManager.getPubChoiceMap(detailpubchoiceId+"");
													for(Map.Entry<String, String> entry: pubchoiceMap.entrySet()){
														out.println("<option value=\""+entry.getKey()+"\" > "+entry.getValue()+"</option>");
													}
												}
												 %>
											</select>
						                </div>
						                <%String cpurl2 = "javascript:getcompleteurl('1#"+detailfieldid+"#"+tableNumber+"#"+detailrowsum+"')"; 
						                String browparam2 = "'1#"+detailfieldid+"#"+tableNumber+"#"+detailrowsum+"'";%>
						                <div id="pubchilchoiceIdDIV<%=tableNumber%>_<%=detailrowsum%>" style="<%if(!detailselectItemType.equals("2")){ %>display:none;<%} %> float: left;margin-left:10px;">
						                    <span style='float:left;line-height:30px;margin-right:10px;'><%=SystemEnv.getHtmlLabelName(124957 ,user.getLanguage()) %></span>
						                	<brow:browser width="150px" viewType="0" name='<%="pubchilchoiceId"+tableNumber+"_"+detailrowsum%>'
										    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&url=/workflow/selectItem/selectItemSupFieldBrowser.jsp"
										    completeUrl='<%=cpurl2%>' 
											hasInput="true" isSingle="true"
											isMustInput='<%="" + ((isFromMode!=1 && canChange)||(isFromMode==1 && !isFieldCannotChange) ? 2 : 0)%>'
											browserValue='<%=detailpubchilchoiceId+""%>'
											browserSpanValue='<%=detailpubchilchoicespan%>'
											browserDialogWidth="550px"
											_callbackParams='<%=tableNumber+"," + detailrowsum%>'
											_callback="setChangeDetail2"
											
											afterDelParams = '<%="{tableNumber:" + tableNumber+",detailrowsum:"+detailrowsum+"}"%>'
											afterDelCallback="delDetailPubchilchoiceIdCallback"
											
											browserDialogHeight="650px" 
											getBrowserUrlFnParams='<%=browparam2%>'
											getBrowserUrlFn="onShowPubchilchoiceId"></brow:browser>
											
											&nbsp;&nbsp;&nbsp;&nbsp;
						                </div>
						                
										<div id="childfielddiv<%=tableNumber%>_<%=detailrowsum%>" style="<%if(!detailselectItemType.equals("0")){ %>display:none;<%} %>float: left;">
											<span style="padding-left:10px;">
											<input class='e8_btn_submit' type='button' id='childfieldbtn<%=tableNumber%>_<%=detailrowsum%>' onclick="childfieldFun(<%=detailfieldid %>,'<%=tableNumber%>_<%=detailrowsum%>')" value='<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>'/>
									  	    </span>
									  		<span id="childfieldoptionspan<%=tableNumber%>_<%=detailrowsum%>">
											     &nbsp;&nbsp;&nbsp;&nbsp;
											     <span style="line-height:30px;">
											     	<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
											     </span>
												
												<select notBeauty=true id="childfieldoption<%=tableNumber%>_<%=detailrowsum%>" name="childfieldoption<%=tableNumber%>_<%=detailrowsum%>" onfocus="childfieldoption('<%=detailfieldid+","+tableNumber+"_"+detailrowsum %>')">
													<option value="" ></option>
													<%
													if(Util.getIntValue(detailfieldid)>0){
														Map<String,String> selectItemOptionMap = SelectItemManager.getSelectItemOption(detailfieldid+"");
														for(Map.Entry<String, String> entry: selectItemOptionMap.entrySet()){
															out.println("<option value=\""+entry.getKey()+"\" > "+entry.getValue()+"</option>");
														}
													}
													%>
												</select>
											</span>
									  	</div>
										
										
									</div>
												  
						    	</td>
						    	<td NOWRAP >
				          			<input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>'  value = '<%=detaildsporder%>' onKeyPress='ItemNum_KeyPress("itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>")' onchange='checknumber("itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>");checkDigit("itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>",15,2);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' style='text-align:right;'   >
				    			</td>
				 			</TR>
				 			<%}%>
				 			<input type="hidden" value="<%=dbdetailfieldnamesForCompare%>" name="dbdetailfieldnamesForCompare_<%=tableNumber%>">
				 		</table>
					</td>
				</tr>
				 <%}%>
				<tr>
					<td class=field>
						<table id="addDetail" class=ListStyle cols=5  border=0 cellspacing=1>
						</table>
						<%
							String funStr = "";
							for(int i=0;i<notExitsList.size();i++){
								String str = (String)notExitsList.get(i);
								funStr += str;
							}
						%>
						<input type="hidden" name="notExistFun" id="notExistFun" value="<%=funStr %>">
					</td>
				</tr>
			</table> 		
		</wea:item>
	</wea:group>
</wea:layout>
