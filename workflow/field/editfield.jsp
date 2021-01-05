<!DOCTYPE html>
<%@page import="weaver.formmode.FormModeConfig"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.form.FormManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs_si" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<jsp:useBean id="UserDefinedBrowserTypeComInfo" class="weaver.workflow.field.UserDefinedBrowserTypeComInfo" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	select{
		width: 150px;
	}
	input{
		width:178px!important;
	}
    .childItemDiv .e8_outScroll,.childItemDiv .e8_innerShowMust{
        display:none;
    }
</style>
</head>
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
	    	 rsformmode.executeSql(sql);
	    	 if(rsformmode.next()){
	    		 return rsformmode.getInt(1)==0?true:false;
	    	 }
	     }
	     return false;
	}
%>
<%
	String formRightStr = "FormManage:All";
	int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
	if(isFromMode==1){
		formRightStr = "FORMMODEFORM:ALL";
	}
	
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
	int operateLevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,formRightStr,formid,isbill);
	String message = Util.null2String(request.getParameter("message"));

	int rownumber=0;
	DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式



	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
    String isclose = Util.null2String(request.getParameter("isclose"));
	int fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
	int isFormMode2 = isFromMode;
	String isfromformid=Util.null2String(request.getParameter("isfromformid"));
	String canDeleteCheckBox = "";
	String para = "";
	String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
	String fieldname = "";//数据库字段名称

    String openrownum = Util.null2String(request.getParameter("openrownum"));
	int fieldlabel = 0;//字段显示名标签id
	String fieldlabelname = "";//字段显示名


	String fielddbtype = "";//字段数据库类型


	String fieldhtmltype = "";//字段页面类型
	String type = "";//字段详细类型
	String dsporder = "";//显示顺序
	String viewtype = "0";//viewtype="0"表示主表字段,viewtype="1"表示明细表字段


	String detailtable = "";//明细表名
	int textheight = 0;//多行文本框的高度
	String textheight_2 = "";
    String imgwidth="";
    String imgheight="";
	int childfieldid = 0;
	String childfieldname = "";
	int isdetail = 0;
	int decimaldigits = 2;
	int qfws=0;
	Hashtable selectitem_sh = new Hashtable();
	rs.executeSql("select * from workflow_billfield where id="+fieldid);
	int selectitem = 0;
	int linkfield = 0;
	
	String selectItemType = "0";
	int pubchoiceId = 0;
	String pubchoicespan = "";
	int pubchilchoiceId = 0;
	String pubchilchoicespan = "";
	//String locateType = "";
	
	boolean isshowPubChildOption = false;
	
	if(rs.next()){
	    fieldname = Util.null2String(rs.getString("fieldname"));
	    fieldlabel = Util.getIntValue(Util.null2String(rs.getString("fieldlabel")),0);
	    fieldlabelname = Util.null2String(SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage()));
	    fielddbtype = Util.null2String(rs.getString("fielddbtype"));
	    fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
	    type = Util.null2String(rs.getString("type"));
	    dsporder = Util.null2String(rs.getString("dsporder"));
	    viewtype = Util.null2String(rs.getString("viewtype")); /* 字段类型:0-主字段,1-明细字段 */
		isdetail = Util.getIntValue(Util.null2String(rs.getString("viewtype")),0);
	    detailtable = Util.null2String(rs.getString("detailtable"));
	    textheight = Util.getIntValue(Util.null2String(rs.getString("textheight")),0);
	    textheight_2 = Util.null2String(rs.getString("textheight_2"));
        imgwidth = ""+Util.getIntValue(Util.null2String(rs.getString("imgwidth")),0);
        imgheight = ""+Util.getIntValue(Util.null2String(rs.getString("imgheight")),0);
		childfieldid = Util.getIntValue(Util.null2String(rs.getString("childfieldid")),0);
		selectitem = Util.getIntValue(Util.null2String(rs.getString("selectitem")),0);
		linkfield = Util.getIntValue(Util.null2String(rs.getString("linkfield")),0);
		qfws=Util.getIntValue(Util.null2String(rs.getString("qfws")),0);
		//locateType = Util.null2String(rs.getString("locatetype"));
		
		
		selectItemType = Util.null2String(rs.getString("selectItemType"));
		if(selectItemType.equals(""))selectItemType="0";
		
	    pubchoiceId = Util.getIntValue(Util.null2String(rs.getString("pubchoiceId")),0);
	    pubchilchoiceId = Util.getIntValue(Util.null2String(rs.getString("pubchilchoiceId")),0);
	    
	    if(pubchoiceId == 0 && pubchilchoiceId > 0){
	    	rs2.execute("select pubchoiceId from workflow_billfield where id = " + pubchilchoiceId);
	    	rs2.next();
	    	pubchoiceId = Util.getIntValue(Util.null2String(rs2.getString(1)),0);
	    }
	    pubchoicespan = SelectItemManager.getPubchoiceName(pubchoiceId);
		pubchilchoicespan = SelectItemManager.getPubchilchoiceFieldName(pubchilchoiceId,user.getLanguage());
		if(!pubchoicespan.equals("")){
			pubchoicespan = "<a title='" + pubchoicespan + "' href='javaScript:eidtSelectItem("+pubchoiceId+")'>" + pubchoicespan + "</a>&nbsp";
		}
		
		
		if(fieldhtmltype.equals("5")){
			isshowPubChildOption = SelectItemManager.hasPubChoice(formid,Util.getIntValue(viewtype,0),detailtable);
		}
		
	    if(viewtype.equals("0")) para = fieldname+"+"+viewtype+"+"+fieldhtmltype+"+ +"+formid+"+"+type;
	    if(viewtype.equals("1")) para = fieldname+"+"+viewtype+"+"+fieldhtmltype+"+"+detailtable+"+"+formid+"+"+type;
	    canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox(para);
	    
	    if(fieldhtmltype.equals("1") && "3".equals(type)){//浮点数字段，增加小数位数设置
        	int digitsIndex = fielddbtype.indexOf(",");
        	if(digitsIndex > -1){
        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
        	}else{
        		decimaldigits = 2;
        	}
        }
        //字段类型如果是千分位时，重新根据位数赋值！
        if(fieldhtmltype.equals("1") && "5".equals(type)){//浮点数字段，增加小数位数设置
        	 decimaldigits =Util.getIntValue(""+qfws,2);
        }        
	    
	}
	
	if(viewtype.equals("0")){
  	titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
   	titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
   }
	if(viewtype.equals("1")){
  	titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
   	titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
   }
	String fieldlength = "";
	if(fieldhtmltype.equals("1")&&type.equals("1")){
		fieldlength = fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"));
	}
	boolean canChange = false;
	rs.executeSql("select 1 from workflow_base where formid="+formid);
	if(rs.getCounts()<=0){//如果表单还没有被引用，字段可以修改。


	    canChange = true;
	}
	/*
	if(canChange){//未被工作流引用，再查看是否被表单建模引用
		rs.executeSql("select 1 from modeinfo where formid="+formid);
		if(rs.getCounts()<=0){//如果表单还没有被模块引用，字段可以修改。


		    canChange = true;
		}else{
		    canChange = false;
		}
	}
	*/
	
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
	
	if(fieldid!=0 && childfieldid!=0){
		rs_si.execute("select fieldlabel from workflow_billfield where id="+childfieldid);
		if(rs_si.next()){
			int fieldlabel_tmp = Util.getIntValue(rs_si.getString("fieldlabel"));
			childfieldname = SystemEnv.getHtmlLabelName(fieldlabel_tmp, user.getLanguage());
		}
		
		rs_si.execute("select id, selectvalue, selectname from workflow_SelectItem where isbill=1 and fieldid="+childfieldid);
		while(rs_si.next()){
			int selectvalue_tmp = Util.getIntValue(rs_si.getString("selectvalue"), 0);
			String selectname_tmp = Util.null2String(rs_si.getString("selectname"));
			selectitem_sh.put("si_"+selectvalue_tmp, selectname_tmp);
		}
	}

	String maintable = "";
	rs.executeSql("select tablename from workflow_bill where id="+formid);
	if(rs.next()) maintable = Util.null2String(rs.getString("tablename"));
	
	String oldtablename = "";
	if(viewtype.equals("0")){
	    oldtablename = maintable;
	}else if(viewtype.equals("1")){
	    oldtablename = detailtable;
	}
		
	String dbnamesForCompare_main = ",";
	
	rs.executeSql("select fieldname from workflow_billfield where id!="+fieldid+" and viewtype=0 and billid="+formid);
	while(rs.next()){
		dbnamesForCompare_main += rs.getString("fieldname").toUpperCase()+",";
	}
	ArrayList dbnamesForCompare_Detail_Arrays = new ArrayList();
	ArrayList detailname_Arrays = new ArrayList();
	rs.executeSql("select tablename from Workflow_billdetailtable where billid="+formid+" order by orderid");
	while(rs.next()){
		String dbnamesForCompare_Detail = ",";
		String detailTableName = Util.null2String(rs.getString("tablename"));
		detailname_Arrays.add(detailTableName);
		rs1.executeSql("select fieldname from workflow_billfield where id!="+fieldid +" and viewtype=1 and billid="+formid+" and detailtable='"+detailTableName+"'");
		while(rs1.next()){
			dbnamesForCompare_Detail += Util.null2String(rs1.getString("fieldname")).toUpperCase()+",";
		}
		dbnamesForCompare_Detail_Arrays.add(dbnamesForCompare_Detail);
		%>
		<input type="hidden" value="<%=dbnamesForCompare_Detail%>" name="<%=detailTableName%>" id="<%=detailTableName%>">
	<%}	

	String mainselect="FieldHtmlType.options[0]=new Option('"+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"',1);"+"\n"+
			          "FieldHtmlType.options[1]=new Option('"+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"',2);"+"\n"+
			          "FieldHtmlType.options[2]=new Option('"+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"',3);"+"\n"+
			          "FieldHtmlType.options[3]=new Option('"+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"',4);"+"\n"+
			          "FieldHtmlType.options[4]=new Option('"+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"',5);"+"\n"+
			          "FieldHtmlType.options[5]=new Option('"+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"',6);"+"\n"+
			          "FieldHtmlType.options[6]=new Option('"+SystemEnv.getHtmlLabelName(21691,user.getLanguage())+"',7);"+"\n";
			          
			          
	String detailselect="FieldHtmlType.options[0]=new Option('"+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"',1);"+"\n"+
			            "FieldHtmlType.options[1]=new Option('"+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"',2);"+"\n"+
			            "FieldHtmlType.options[2]=new Option('"+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"',3);"+"\n"+
			            "FieldHtmlType.options[3]=new Option('"+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"',4);"+"\n"+
			            "FieldHtmlType.options[4]=new Option('"+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"',5);"+"\n"+
			            "FieldHtmlType.options[5]=new Option('"+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"',6);"+"\n";
	Map th_2_map = FormManager.getRightAttr(user.getLanguage());
	
	int recordchoicerowindex = 0;		
	String tempTableName = "".equals(Util.null2String(detailtable))?maintable:Util.null2String(detailtable);
	boolean isFieldCannotChange = false;
	if(isFromMode!=1){//流程表单
	    mainselect += "FieldHtmlType.options[7]=new Option('"+SystemEnv.getHtmlLabelName(125583,user.getLanguage())+"',9);"+"\n";
	}else{//表单建模表单
		canChange = isFormModeFieldCanChange(isFormmodeUse,isFieldNoValueCanEdit, tempTableName, fieldname,fieldhtmltype,type,fielddbtype);
	}
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operateLevel > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	if(canDeleteCheckBox.equals("true")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteData(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<script>

if("<%=isclose%>"==1){
		var dialog = parent.getDialog(window);		
		var parentWin = parent.getParentWindow(window);
		//parentWin.location="/workflow/form/editformfield.jsp?formid="+<%=formid%>+"&ajax=0&isFromMode=<%=isFromMode%>";
		parentWin._table.reLoad();
		dialog.close();
		
}
</script>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form1" method="post" action="/workflow/form/form_operation.jsp" >
	<input type="hidden" value="" name="src">
	<input type="hidden" value="<%=openrownum%>" name="openrownum" id="openrownum" >
	<input type="hidden" value="<%=formid%>" name="formid">
	<input type="hidden" value="0" name="choiceRows_rows">
	<input type="hidden" value="<%=canChange%>" name="canChange">
	<input type="hidden" value="false" name="hasChanged">
	<input type="hidden" value="<%=fieldid%>" name="fieldid">
	<input type="hidden" value="<%=oldtablename%>" name="oldtablename">
	<input type="hidden" value="<%=maintable%>" name="maintable">
	<input type="hidden" value="<%=detailtable%>" name="detailtable">
	<input type="hidden" value="<%=viewtype%>" name="viewtype">
	<input type="hidden" value="<%=fielddbtype%>" name="fielddbtype">
	<input type="hidden" value="<%=isfromformid%>" name='isfromformid'>
	<input type="hidden" value="<%=isFormMode2%>" name="isFromMode">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<% if(operateLevel > 0){%>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
    			<%} %>
    			<!--<input type="button" value="取消" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">  -->						
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>  
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item>
			<% 
				String helpTitle = SystemEnv.getHtmlLabelName(15441,user.getLanguage())+","+SystemEnv.getHtmlLabelName(19881,user.getLanguage())+".id,requestId("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+"),id,mainid("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+")"+SystemEnv.getHtmlLabelName(21810,user.getLanguage());
			%>
			<input class=Inputstyle type="text" name="fieldname" size="40" maxlength="30" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>" onchange="setChange()" onBlur='checkinput_char_num("fieldname");checkinput("fieldname","fieldnamespan")' <%if(!canChange){%>disabled<%}%>>
			<span id=fieldnamespan></span>
			<span class=fontred>
				<a href='#'  title="<%=helpTitle %>"><IMG border="0" src="/wechat/images/remind_wev8.png" align=absMiddle ></a>
			</span>
			<%if(!canChange){%><input type="hidden" name="fieldname" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>"><%}%>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=Inputstyle type="text" name="fieldlabelname" size="40" maxlength="30" value="<%=Util.toScreenToEdit(fieldlabelname,user.getLanguage())%>" onchange="setChange()" onBlur='checkinput("fieldlabelname","fieldlabelnamespan")'>
    		<span id=fieldlabelnamespan></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17997	,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="updateTableName" name="updateTableName" onchange="OnChangeUpdateTableName(this);setChange()" <%if(!canChange){%>disabled<%}%>>
				<option value="<%=maintable%>" <%if(viewtype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<%
				for(int i=0;i<detailname_Arrays.size();i++){
				%>
				<option value="<%=detailname_Arrays.get(i)%>" <%if(detailtable.equals((String)detailname_Arrays.get(i))){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></option>
				<%}%>
			</select>
			<%if(!canChange){%><input type="hidden" name="updateTableName" <%if(viewtype.equals("0")){%>value="<%=maintable%>"><%}else{%>value="<%=detailtable%>"><%}}%>		
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<input class='InputStyle' type="text" size=10 maxlength=7 name="itemDspOrder" value="<%=dsporder%>" onKeyPress="ItemNum_KeyPress(this.name)" onchange="setChange()" onblur="checknumber('itemDspOrder');checkDigit('itemDspOrder',15,2)" style="text-align:right;">		
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
		<wea:item>
			<div style="display:block;float:left;height:auto;min-width:170px;">
				<select class='InputStyle' style="float:left;" id="FieldHtmlType" name="FieldHtmlType" onchange="OnChangeFieldHtmlType();setChange()" <%if(!canChange){%>disabled<%}%>>
					<option value='1' <%if(fieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
					<option value='2' <%if(fieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
					<option value='3' <%if(fieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
					<option value='4' <%if(fieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
					<option value='5' <%if(fieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>	
					<option value='6' <%if(fieldhtmltype.equals("6")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
					<%if(viewtype.equals("0")){ %>
					<option value='7' <%if(fieldhtmltype.equals("7")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
			        <%if(isFromMode!=1){ %>
			        <option value='9' <%if(fieldhtmltype.equals("9")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(125583,user.getLanguage())%></option> <%-- 移动交互 --%> 
			        <%}
			        }%>
			    </select>
			</div>
			<div style="width:5px!important;height:3px;float:left;"></div>
			
			<%if(!canChange){%><input type="hidden" name="FieldHtmlType" value="<%=fieldhtmltype%>"><%}%>	
			
			<div id="div1" <%if(fieldhtmltype.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select class='InputStyle' id="DocumentType" name="DocumentType" onchange="OnChangeDocumentType();setChange()" <%if(!canChange){%>disabled<%}%>>
					<option value='1' <%if(fieldhtmltype.equals("1")&&type.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
					<option value='2' <%if(fieldhtmltype.equals("1")&&type.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
					<option value='3' <%if(fieldhtmltype.equals("1")&&type.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
					<option value='4' <%if(fieldhtmltype.equals("1")&&type.equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
					<option value='5' <%if(fieldhtmltype.equals("1")&&type.equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
				</select>
				<%if(!canChange){%><input type="hidden" name="DocumentType" value="<%=type%>"><%}%>
			</div>	
			<div id="div1_1" <%if(fieldhtmltype.equals("1")&&type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%> <%-- 文本长度 --%>
				<input class='InputStyle' type='text' size=3 maxlength=3 value='<%=fieldlength%>' id='itemFieldScale1' name='itemFieldScale1' onKeyPress='setChange();ItemPlusCount_KeyPress()' onchange="checkmaxlength('<%=fieldlength%>','itemFieldScale1')" onblur="checkPlusnumber1(this);checklength('itemFieldScale1','itemFieldScale1span');checkcount1(itemFieldScale1)" style='text-align:right;'>
				<span id=itemFieldScale1span><%if("".equals(fieldlength)){out.print("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");}%></span>
			</div>	
			
			<div id="div1_3" <%if((fieldhtmltype.equals("1")&&type.equals("3"))||(fieldhtmltype.equals("1")&&type.equals("5"))){%>style="display:inline"<%}else{%>style="display:none"<%}%> <%if(!canChange){%>disabled<%}%>>
			
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<%if(!canChange){%>
				<input type="hidden" id="decimaldigits" name="decimaldigits" value="<%=decimaldigits%>">
				<select id="decimaldigitshidden" name="decimaldigitshidden" size="1" disabled>
				<%}else{%>
				<select id="decimaldigits" name="decimaldigits" onchange="setChange();">
				<%}%>
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</div>		
			
			<div id="div2" <%if(fieldhtmltype.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
				<input class='InputStyle' type='text' size=4 maxlength=2 value='<%=textheight%>' id='textheight' name='textheight' onKeyPress='ItemPlusCount_KeyPress()' onblur="checkPlusnumber1(this);checkcount1(textheight)" onchange='setChange()' style='text-align:right;'>
				<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
				<input type='checkbox' id="htmledit" name="htmledit" onclick="onfirmhtml()" onchange="setChange()" value="<%=type%>" <%if(type.equals("2")){%> checked <%}%> <%if(!canChange){%>disabled<%}%>>
				<%if(!canChange){%><input type="hidden" name="htmledit" value="<%=type%>"><%}%>
			</div>	
			
			<div id="div3" <%if(fieldhtmltype.equals("3")){%>style="display:inline;float:left;"<%}else{%>style="display:none;float:left;"<%}%>>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select <%if(canChange){%>notBeauty=true<%}%> class='InputStyle <%if(canChange){%>autoSelect<%}%>' id="browsertype" name="browsertype" onchange="OnChangeBrowserType();setChange()" <%if(!canChange){%>disabled<%}%>>
				<option></option>
				<%while(browserComInfo.next()){
					if(browserComInfo.getBrowserurl().equals("")){
						continue;
					}
					if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
						continue;
					}
					if (browserComInfo.notCanSelect()) continue;
				%>
					<option match="<%=browserComInfo.getBrowserPY(user.getLanguage())%>" value="<%=browserComInfo.getBrowserid()%>" <%if(fieldhtmltype.equals("3")&&type.equals(browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				<%}%>
				</select>
				<span id="selecthtmltypespan" style="display:none;">
					<img align="absMiddle" src="/images/BacoError_wev8.gif">
				</span>
				<%
	            if (HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){ 
	            %>
	            	<span onclick='setBTC()'> <img  style='cursor:pointer;vertical-align: middle;' src='/images/ecology8/workflow/setting_wev8.png'></span>
	    	    <%}%>
				<%if(!canChange){%><input type="hidden" name="browsertype" value="<%=type%>"><%}%>
			</div>	
			
			<div id="div3_1" style="display:none">
				<span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
			</div>
			
			<div id="div3_2" <%if(type.equals("161")||type.equals("162")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>				
				<brow:browser width="150px" viewType="0" name="definebroswerType" browserValue='<%= type.equals("161")||type.equals("162")?fielddbtype:"" %>'
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
					    completeUrl="/data.jsp"
						hasInput="false" isSingle="true"
						isMustInput='<%="" + (canChange ? 2 : 0)%>'
						browserDialogWidth="550px"
						browserDialogHeight="650px"
						_callback="setChange"
						browserSpanValue='<%=type.equals("161")||type.equals("162")?UserDefinedBrowserTypeComInfo.getName(fielddbtype):""%>'></brow:browser>
			</div>	
			<div id="div3_4" <%if(type.equals("224")||type.equals("225")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<select class='InputStyle' name='sapbrowser' id='sapbrowser' onchange="OnChangeSapBroswerType();setChange();"<%if(!canChange){%>disabled<%}%>>
				<%
				List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
				for(int j=0;j<AllBrowserId.size();j++){
				%>
					<option value="<%=AllBrowserId.get(j)%>" <%if(fielddbtype.equals((String)AllBrowserId.get(j))){%> selected <%}%>><%=AllBrowserId.get(j)%></option>
				<%}%>
				</select>
				<%if(!canChange){%><input type="hidden" name="sapbrowser" value="<%=fielddbtype%>"><%}%>
			</div>	
			<div id="div3_5" <%if(type.equals("226")||type.equals("227")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<button style="vertical-align: middle;" type="button" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
				<span id="showinner" name="showinner"><%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);} %></span>
				<span id="showimg" name="showimg"><%if(!type.equals("226")&&!type.equals("227")){out.print("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");} %></span>
				<input type="hidden" id="showvalue" name="showvalue" value="<%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);} %>">
			</div>	
			
			<div id="div3_7" <%if(type.equals("256")||type.equals("257")){%>style="display:inline"<%}else{%>style="display:none"<%}%> <%if(!canChange){%>disabled<%}%> ><!-- 自定义树形单选 -->
				<%
					String treename = "";
					if(type.equals("256")||type.equals("257")){
						String treeSql = "select a.id,a.treename from mode_customtree a where a.id="+fielddbtype;
						rs2.executeSql(treeSql);
						if(rs2.next()){
							treename = rs2.getString("treename");
						}
					}
				%>
				<brow:browser width="150px" viewType="0" name="defineTreeBroswerType" browserValue='<%= type.equals("256")||type.equals("257")?fielddbtype:"" %>'
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
					    completeUrl="/data.jsp"
						hasInput="false" isSingle="true"
						isMustInput='<%="" + (canChange ? 2 : 0)%>'
						browserDialogWidth="550px"
						browserDialogHeight="650px"
						_callback="setChange"
						browserSpanValue='<%=type.equals("256")||type.equals("257")?treename:""%>'></brow:browser>
			</div>
			
			<div id="div3_3" <%if(type.equals("165")||type.equals("166")||type.equals("167")||type.equals("168")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%
				String th_2[] = textheight_2.split(",");
				String th_2_span = "";
				for(int k=0;k<th_2.length;k++){
					if(th_2[k].equals("0") || th_2[k].equals(""))continue;
					th_2_span += ","+th_2_map.get(th_2[k]);
				}
				if(!th_2_span.equals("")) th_2_span = th_2_span.substring(1);
				
				%>
				<div style='float:left;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %></div>
			    <brow:browser width="105px" viewType="0" name="decentralizationbroswerType"
					browserValue='<%=textheight_2%>'
				    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
				    completeUrl="/data.jsp"
					hasInput="false" isSingle="true"
					isMustInput='<%="" + (canChange ? 2 : 0)%>'
					browserDialogWidth="400px"
					browserDialogHeight="290px"
					_callback="setChange"
					browserSpanValue='<%=th_2_span%>'></brow:browser>
				
				
			</div>	
			
			
		  	<div id="div5" <%if(fieldhtmltype.equals("5")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
		  	
		  	    <div style="float: left;min-width:150px;">
				    <span style="float: left;margin-top:5px"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
				    <select id="selectItemType" name="selectItemType" class=inputstyle  <%if(!canChange){%>disabled<%}%> style="width: 100px;" onchange="selectItemTypeChange('selectItemType');setChange();">
	                    <option value="0" <%if(selectItemType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>
	                    <option value="1" <%if(selectItemType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>
	                   
	                    <%if(isshowPubChildOption){ %>
	                    <option value="2" <%if(selectItemType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>
	                    <%} %>
	                </select>
	                
	                <%if(!canChange){ %>
	                	<input name="selectItemType" id="selectItemType" type="hidden" value="<%=selectItemType %>"/>
	                <%} %>
				</div>
				
				<div id="pubchoiceIdDIV" style="<%if(!selectItemType.equals("1")){ %>display:none;<%} %> float: left;margin-left:10px">
                	<brow:browser width="150px" viewType="0" name="pubchoiceId"
				    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp"
				    completeUrl="/data.jsp?type=pubChoice"
					hasInput="true" isSingle="true"
					isMustInput='<%="" + (canChange ? 2 : 0)%>'
					browserValue='<%=pubchoiceId+""%>'
					browserSpanValue='<%=pubchoicespan%>'
					browserDialogWidth="550px"
					browserDialogHeight="650px" _callback="setPreviewPub"></brow:browser>
					
					
					<div style="margin-left:10px;margin-top:5px;float:left;">
						<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
					</div>
					<select id="previewPubchoiceId" name="previewPubchoiceId" >
						<option value="" ></option>
					</select>
					
                </div>
                
                <div id="pubchilchoiceIdDIV" style="<%if(!selectItemType.equals("2")){ %>display:none;<%} %> float: left;margin-left:10px">
                    <span style='float:left;padding-top:5px'><%=SystemEnv.getHtmlLabelName(124957 ,user.getLanguage()) %></span>
                	<brow:browser width="150px" viewType="0" name="pubchilchoiceId"
				    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&url=/workflow/selectItem/selectItemSupFieldBrowser.jsp"
				    completeUrl='<%="javascript:getcompleteurl()"%>'
					hasInput="true" isSingle="true"
					isMustInput='<%="" + (canChange ? 2 : 0)%>'
					browserValue='<%=pubchilchoiceId+""%>'
					browserSpanValue='<%=pubchilchoicespan%>'
					browserDialogWidth="550px"
					_callback="setChange"
					browserDialogHeight="650px" getBrowserUrlFn="onShowPubchilchoiceId"></brow:browser>
                </div>
                
				<div id="childfielddiv" style="<%if(!selectItemType.equals("0")){ %>display:none;<%} %>float: left;margin-left:10px">
					<span id="childfieldNotesSpan" style="float: left;margin-top:5px"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%></span>
					<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
					        isMustInput="1" 
					        isSingle="true" 
					        hasInput="true"
					        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"   
					        width="150px" 
					        browserValue='<%=childfieldid+""%>' 
					        browserSpanValue='<%=childfieldname%>'   
					        _callback = "clearChildItem"
					        getBrowserUrlFn="onShowChildField_new"/>
			  	</div>
		  	</div>	
		  	
			<div id="div6" <%if(fieldhtmltype.equals("6")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select id=uploadtype name=uploadtype onchange="onuploadtype(this);setChange();" <%if(!canChange){%>disabled<%}%>>
					<option value="1" <%if(type.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></OPTION>
					<option value="2" <%if(type.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></OPTION>
				</select>
				<%if(!canChange){%><input type="hidden" name="uploadtype" value="<%=type%>"><%}%>
			</div>	
			
			<div id="div6_1" <%if(!(fieldhtmltype.equals("6")&&type.equals("2"))){%>style="display:none"<%}%>>
			    <%
			    if(viewtype.equals("0")){
			    %>
			     <%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>
				 <input type=input class="InputStyle" size=10 maxlength=3 name="strlength" onchange="setChange()" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=textheight%>">
			    <%}%>
			     
			     <%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
				<input type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onchange="setChange()" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=imgwidth%>">
				<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>
				<input type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onchange="setChange()" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=imgheight%>">
			</div>	
			
			<div id="div7" <%if(fieldhtmltype.equals("7")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select id=specialfield name=specialfield onchange="specialtype(this);setChange()" <%if(!canChange){%>disabled<%}%>>
					<option value="1" <%if(type.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
					<option value="2" <%if(type.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
				</select>
				<%if(!canChange){%><input type="hidden" name="specialfield" value="<%=type%>"><%}%>
			</div>				  
			<div id="div9" <%if(fieldhtmltype.equals("9")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>       <!-- 类型 -->
				<select class='InputStyle' style="width:120px;" id="locationType" name="locationType" onchange="OnChangelocationType()">
					<option value='1' ><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%></option>
				</select>
			</div>
			
			<%--
			<div id="div9_1" <%if(fieldhtmltype.equals("9")){%>style="display:inline"<%}else{%>style="display:none"<%}%> >
				<%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%>  <!-- 定位方式 -->
				<select id="locateType" style="width:120px;" name="locateType">
					<option value="1" <%if(locateType.equals("1")){%>selected <%} %>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option>
					<option value="2" <%if(locateType.equals("2")){%>selected <%} %>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage()) %></option>
				</select>
			</div>
			--%>
			<div id="div8" <%if(fieldhtmltype.equals("8")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<%
                   String selectSql = "select a.id,a.selectitemname from mode_selectitempage a where a.id="+selectitem+" ";
				rs.executeSql(selectSql);
				String selectitemname = "";
				while(rs.next()){
					selectitemname = rs.getString("selectitemname");
				}
				String linkfieldStr = "";
				if(linkfield>0){
					 selectSql = "select a.id,b.labelname from workflow_billfield a,HtmlLabelInfo b where a.id="+linkfield+" and a.fieldlabel=b.indexid and b.languageid="+user.getLanguage();
					 rs.executeSql(selectSql);
					 if(rs.next()){
						 linkfieldStr = rs.getString("labelname");
					 }
				}
	            %>
				<input type='text' class='InputStyle' style='width:120px !important;padding-left:5px;' <%if(!canChange){%>disabled="disabled"<%} %>  readonly='readonly' <%if(canDeleteCheckBox.equals("false")){%>disabled="disabled"<%} %> id='selectTypeSpan' name='selectTypeSpan' value="<%=selectitemname %>" >
				<button type='button' class='Browser' <%if(!canChange){%>disabled="disabled"<%} %> style='margin-left:10px;' onClick="showModalDialogSelectItem(selectType,selectTypeSpan);setChange();" id='selectItemBtn' name='selectItemBtn'></BUTTON>
				<input type='hidden' id='selectType' name='selectType'  value="<%=selectitem %>">
				
				<span><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
 		        <button <%if(!canChange){%>disabled<%}%> type='button' id='showChildFieldBotton' class=Browser onClick="onShowChildField('linkfieldSpan','linkfield')"></BUTTON>
 		        <span id='linkfieldSpan'><%=linkfieldStr %></span>
 		        <input type='hidden' value='' name='linkfield' id='linkfield' value="<%=linkfield %>">
	   		              
			</div>	
			<%
			String displayname = "";
			String linkaddress = "";
			String descriptivetext = "";
			String iscustomlink = "style=display:none";
			String isdescriptive = "style=display:none";
			
			if(fieldhtmltype.equals("7")){
				rs.executeSql("select * from workflow_specialfield where fieldid = " + fieldid + " and isbill = 1");
				rs.next();
				displayname = rs.getString("displayname");
				linkaddress = rs.getString("linkaddress");
				descriptivetext = rs.getString("descriptivetext");
				if(type.equals("1")) iscustomlink = "style=display:''";
				if(type.equals("2")) isdescriptive = "style=display:''";
			}
			%>	
			<div id="div7_1" <%out.println(iscustomlink);%>>
				<%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>　<input class=inputstyle type=text name=displayname size=20 value="<%=displayname%>" maxlength=1000 onchange="setChange()" >
				<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　<input class=inputstyle type=text size=50 name=linkaddress value="<%=linkaddress%>" maxlength=1000 onchange="setChange()" ><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>
			</div>	
			<div id="div7_2" <%out.println(isdescriptive);%>>
				<table width="100%">
					<tr>
						<td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td>
						<td><textarea class='inputstyle' style='width:60%;height:100px' name=descriptivetext onchange="setChange()" ><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea></td>
					</tr>
				</table>
			</div>
			<div style="clear:both;"></div> 	
			

																		  																											
		</wea:item>
		
	</wea:group>
</wea:layout>

<div id="choicediv" <%if(fieldhtmltype.equals("5") && selectItemType.equals("0")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(124984,user.getLanguage())%>' >
		    <wea:item type="groupHead">
		        <span style="float:right;">
				<input type="button" class="addbtn" style="width:21px !important;"  title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addoTableRow()"/>
				<input type="button" class="delbtn" style="width:21px !important;"  title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="submitClear()"/>
				</span>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<table class=ListStyle cellspacing=0   cols=6 id="choiceTable0">
					<colgroup>
					<col width="5%">
					<col width="15%">
					<col width="5%">
					<col width="20%">
					<col width="8%">
					<col width="7%">
					</colgroup>  
					
					 <tr class="header notMove">
					    <td><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></td>
		            	<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td><!-- 可选择项文字 -->
		            	<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td><!-- 默认值 -->
		            	<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td><!-- 关联文档目录 -->
		            	<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td><!-- 子选项 -->
		            	<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td><!-- 封存 -->
					</tr>
					
					<%
					
					if(selectItemType.equals("0")){  
						rs1.executeSql("select * from workflow_SelectItem where isbill=1 and fieldid="+fieldid+" order by listorder ");
				  		while(rs1.next()){
				  			recordchoicerowindex++;
				  			rownumber++;
							String childitemid_tmp = Util.null2String(rs1.getString("childitemid"));
							String childitemidStr = "";
	
							String docspath = "";
							String docscategory = rs1.getString("docCategory");
							String id_temp = rs1.getString("id");
							if(!"".equals(docscategory) && null != docscategory){//根据路径ID得到路径名称
	
							    List nameList = Util.TokenizerString(docscategory, ",");
								try{
								    String mainCategory = (String)nameList.get(0);
								    String subCategory = (String)nameList.get(1);
								    String secCategory = (String)nameList.get(2);
								    docspath = secCategoryComInfo.getAllParentName(secCategory,true);
								}catch(Exception e){
									docspath = secCategoryComInfo.getAllParentName(docscategory,true);
								}
							}
	
							int isAccordToSubCom_tmp = Util.getIntValue(rs1.getString("isaccordtosubcom"), 0);
							String isAccordToSubCom_Str = "";
							if(isAccordToSubCom_tmp == 1){
								isAccordToSubCom_Str = " checked ";
							}
							if(!"".equals(childitemid_tmp)){
								String[] itemid_sz = Util.TokenizerString2(childitemid_tmp, ",");
								for(int cx=0; cx<itemid_sz.length; cx++){
									String itemid_tmp = itemid_sz[cx];
									try{
										String[] checktmp_sz = Util.TokenizerString2(itemid_tmp, "a");
										String itemidStr_tmp = Util.null2String((String)selectitem_sh.get("si_"+checktmp_sz[0]));
										if(!"".equals(itemidStr_tmp)){
											childitemidStr += (itemidStr_tmp + ",");
										}
									}catch(Exception e){}
								}
								if(!"".equals(childitemidStr)){
									childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
								}
							}
	
	
				  		%>
				  		<tr class="DataDark">
					  		<td><input type="checkbox" name="chkField" id="chkField_<%=recordchoicerowindex%>" index="<%=recordchoicerowindex%>" value="0" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%>>
					  			&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />
					  			<input type="hidden" name="id_<%=recordchoicerowindex%>" value="<%=id_temp %>">
					  		</td>
					  		<td><input class="InputStyle" value='<%=rs1.getString("selectname")%>' type="text" style="width:150px!important;" id="field_name_<%=recordchoicerowindex%>" name="field_name_<%=recordchoicerowindex%>" onchange="checkinput('field_name_<%=recordchoicerowindex%>','field_span_<%=recordchoicerowindex%>');setChange()">
					  		<span id="field_span_<%=recordchoicerowindex%>"><%if(rs1.getString("selectname").equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
					  		<input class="InputStyle" type="hidden" style="width:40px!important;" value ='<%=rs1.getString("listorder")%>' name="field_count_name_<%=recordchoicerowindex%>" onKeyPress="ItemNum_KeyPress('field_count_name_<%=recordchoicerowindex%>')" onchange="setChange()">
					  		</td>
					  		<td><input type="checkbox" name="field_checked_name_<%=recordchoicerowindex%>"  onclick="setChange()" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(rs1.getString("isdefault").equals("y")){%>checked<%}%> value="1"></td>
					  			
					  		<td><input type="hidden" id="selectvalue<%=recordchoicerowindex%>" name="selectvalue<%=recordchoicerowindex%>" value='<%=rs1.getString("selectvalue")%>'>
								<input type='checkbox' id="isAccordToSubCom<%= recordchoicerowindex%>" name='isAccordToSubCom<%=recordchoicerowindex%>'  onclick="setChange()"  value='1' <%=isAccordToSubCom_Str%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;								
               <brow:browser viewType="0" name='<%="maincategory_"+recordchoicerowindex%>' browserValue='<%=rs1.getString("docCategory")%>'  
	            getBrowserUrlFn="onShowCatalog"   getBrowserUrlFnParams='<%=""+recordchoicerowindex%>'
	            idKey="id" nameKey="path"
				_callback="afterSelect"
				_callbackParams='<%=""+recordchoicerowindex%>'
	            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='1'
	            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="60%"
	            browserSpanValue="<%=docspath%>"></brow:browser>

								
							  <input type=hidden id="pathcategory_<%=recordchoicerowindex%>" name="pathcategory_<%=recordchoicerowindex%>" value="<%=docspath%>"></td>
							<td>
                                <%--<BUTTON type='button' class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=recordchoicerowindex%>', 'childItem<%=recordchoicerowindex%>')" id="selectChildItem<%=recordchoicerowindex%>" name="selectChildItem<%=recordchoicerowindex%>"></BUTTON>
								<input type="hidden" id="childItem<%=recordchoicerowindex%>" name="childItem<%=recordchoicerowindex%>" value="<%=childitemid_tmp%>" >
                                <span id="childItemSpan<%=recordchoicerowindex%>" name="childItemSpan<%=recordchoicerowindex%>"><%=childitemidStr%></span>--%>
                                <div style="float:left; display:inline;width:25px;" class="childItemDiv">
                                <%if(childitemid_tmp!= null &&childitemid_tmp.startsWith(","))childitemid_tmp = childitemid_tmp.substring(1); %>
                                  <brow:browser viewType="0" name='<%="childItem"+recordchoicerowindex%>' browserValue="<%=childitemid_tmp%>"
                                      getBrowserUrlFn="showChildSelectItem" getBrowserUrlFnParams='<%=""+recordchoicerowindex%>'
                                      _callback="selectChildSelectItem"
                                      _callbackParams='<%=""+recordchoicerowindex%>'
                                      hasInput="false" isSingle="false" hasBrowser = "true"  isMustInput='1' width="25px"
                                      browserSpanValue="<%=childitemidStr%>"></brow:browser>
                                </div>
                                <span id="childItemSpan<%=recordchoicerowindex%>" name="childItemSpan<%=recordchoicerowindex%>" class="childItemSpan" title='<%=childitemidStr%>'><%=childitemidStr%></span>
							</td>
		                    <td><input type="checkbox" name="cancel_<%=recordchoicerowindex%>_name" onchange='setChange()'  value='<%=rs1.getString("cancel")%>' onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(rs1.getString("cancel").equals("1")){%>checked<%}%>></td>   
				  		</tr>
				  		<%
				  		}
					}
					
			  		%>
					
					
				</table>
					
				<input type="hidden" id="needcheck" name="needcheck" value="">
				<input type="hidden" id="rowno" name="rowno" value="">
			</wea:item>
		</wea:group>
</wea:layout>
</div>
</form>

</body>
</html>
<script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
<script language="JavaScript">

jQuery(function () {
	<%
	if(message.equals("pubchilchoiceId")){
	%>	
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130446,user.getLanguage())%>");
	try{
	    var parentWin = parent.getParentWindow(window);
	    parentWin._table.reLoad();
	}catch(e){}
	<%}%>
	
});

<%
if(pubchoiceId>0){
%>
	setPreviewPub();
<%
}
%>

function setPreviewPub(event,datas,name){
	var pubchoiceId = jQuery("#pubchoiceId").val()
	
	setChange();
	
	jQuery("#previewPubchoiceId").empty();
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=pubchoiceback&id="+pubchoiceId,
		    dataType: "json",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        jQuery("#previewPubchoiceId").append("<option value=''></option>");
		        var _data = data;
		    	for(var i=0;i<_data.length;i++){
		    	    var tt = _data[i];
		    	    var _id = tt.id;
		    	    var _name = tt.name;
		    		jQuery("#previewPubchoiceId").append("<option value='"+_id+"'>"+_name+"</option>");
		    	}
		    	//beautySelect("#previewPubchoiceId");
		    	__jNiceNamespace__.reBeautySelect("#previewPubchoiceId");
		    } 
	}); 
	
	
}

function eidtSelectItem(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(124896,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit&src=edit&id="+id;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function selectItemTypeChange(obj){
	var value = jQuery("#"+obj).val();
	if(value != 0){
		jQuery("#choicediv").hide();
		jQuery("#childfielddiv").hide();
	}else{
		jQuery("#choicediv").show();
		jQuery("#childfielddiv").show();
	}
	
	if(value==1){
		jQuery("#pubchoiceIdDIV").show();
	}else{
		jQuery("#pubchoiceIdDIV").hide();
	}
	
	if(value==2){
		jQuery("#pubchilchoiceIdDIV").show();
	}else{
		jQuery("#pubchilchoiceIdDIV").hide();
	}
	
	
}
	
function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	var ckd = jQuery(obj).attr("checked");
	jQuery("input[id^='chkField_']").each(function(){
		if(ckd){
			jQuery(this).attr("checked",true);
			changeCheckboxStatus(this, true);
		}else{
			jQuery(this).attr("checked",false);
			changeCheckboxStatus(this, false);
		}
	});
}

function getDetailTableStr(){
	var updateTableName = $G("updateTableName").value;//得到主表或明细表的名字


	var detailTableStr = "";
	if(updateTableName.indexOf("_dt") > -1){
		detailTableStr = " &detailtable="+updateTableName+" ";
	}
	return detailTableStr;
}

function getIsDetail(){
	var updateTableName = $G("updateTableName").value;//得到主表或明细表的名字


	var isdetail = "0";
	if(updateTableName.indexOf("_dt") > -1){
		isdetail = "1"
	}
	return isdetail;
}


function setSelectItemType(){
	$("#selectItemType option[value='2']").remove(); 
	
	var updateTableName = document.getElementById("updateTableName").value;
	var detailtable = "";
	if(updateTableName.indexOf("_dt") > -1){
		detailtable = updateTableName;
	}
    var isdetail = getIsDetail();
    
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=hasPubChoice&isdetail="+isdetail+"&formid=<%=formid%>&detailtable="+detailtable,
		    dataType: "text",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        var _data = data.trim();
		        if(_data=="true"){
					jQuery("#selectItemType").append("<option value='2'><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>");		        
		        }
		    	__jNiceNamespace__.reBeautySelect("#selectItemType");
		    } 
	}); 
}


	
function onShowPubchilchoiceId() {
    isdetail = getIsDetail();
    var detailtable = getDetailTableStr();
    url = "/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&fieldhtmltype=5&billid=<%=formid%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1&fieldid=<%=fieldid%>";
    return url;
}

var childfield_oldvalue = "";
function onShowChildField_new() {
    childfield_oldvalue = jQuery("#childfieldid").val();
    isdetail = getIsDetail();
    detailTableSql = getDetailTableSql();
    url = "/systeminfo/BrowserMain.jsp?url= " + escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%> and id != <%=fieldid%>" + detailTableSql + "&isdetail=" + isdetail + "&isbill=1");
    return url;
}


function clearChildItem(){
    var childfield_value = jQuery("#childfieldid").val();
	if (childfield_oldvalue != childfield_value) {
        jQuery("input[name^='childItem']").each(function(){
        	jQuery(this).val("");
        });
        jQuery("span[name^='childItemSpan']").each(function(){
        	jQuery(this).html("");
        });
    }
    
    setChange();
}

function getcompleteurl(){
    isdetail = getIsDetail();
    var detailtable = getDetailTableStr();
    url = "/data.jsp?type=pubChoice&pubchild=1&fieldhtmltype=5&billid=<%=formid%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1&fieldid=<%=fieldid%>";
    return url;
}
	
jQuery(document).ready(function(){
	registerDragEvent();
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
});	
	
	
	
function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了



		    $(this).height($(this).height());
		});
		return ui;
	};

	var copyTR = null;
	var startIdx = 0;

	var idStr = "#choiceTable0";
	jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
        
    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方



                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
	       	  	/* if(ui.item.get(0).rowIndex > startIdx) {
	        	  	ui.item.before(copyTR.clone().show());
				}else {
	        	  	ui.item.after(copyTR.clone().show());
				} */
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}


	function checklength(elementname,spanid){
		tmpvalue = $G(elementname).value;
		while(tmpvalue.indexOf(" ") == 0)
			tmpvalue = tmpvalue.substring(1,tmpvalue.length);
		if(tmpvalue!=""&&tmpvalue!=0){
			 $G(spanid).innerHTML='';
		}
		else{
		 $G(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 $G(elementname).value = "";
		}
	}
	recordchoicerowindex = "<%=recordchoicerowindex%>";
	var choicerowindex = 1;
	var rrowindex  = recordchoicerowindex*1;//表格实际索引行


	
	
function addoTableRow(){
  	obj = document.getElementById("choiceTable0");
  	choicerowindex=recordchoicerowindex*1+1;
	rrowindex++;
	ncol=obj.rows[0].cells.length;
	oRow = obj.insertRow(-1);
	jQuery(oRow).addClass("DataDark");
	for(i=0; i<ncol; i++){
		oCell1 = oRow.insertCell(i);
		switch(i){
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' id='chkField_"+choicerowindex+"' name='chkField' index='"+choicerowindex+"' value='1'>"+
				             "<input class='Inputstyle' type='hidden' size='4' value = '0.00' id='field_count_name_"+choicerowindex+"' name='field_count_name_"+choicerowindex+"' > "+
				             "&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='Inputstyle' style='width: 150px !important;' type='text' id='field_name_"+choicerowindex+"' name='field_name_"+choicerowindex+"' "+
								" onchange=checkinput('field_name_"+choicerowindex+"','field_span_"+choicerowindex+"')>"+
							 " <span id='field_span_"+choicerowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;

			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_name_"+choicerowindex+"' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:

                 var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' id='isAccordToSubCom"+choicerowindex+"' name='isAccordToSubCom"+choicerowindex+"' value='1' onclick='setChange()' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<input type='hidden' id='selectvalue"+choicerowindex+"' name='selectvalu"+choicerowindex+"' value='' />"
							+ "<span  id='maincategory_"+choicerowindex+"' name='maincategory_"+choicerowindex+"' ></span>"
						    + "<input type=hidden id='pathcategory_"+choicerowindex+"' name='pathcategory_"+choicerowindex+"' value=''>";
						   

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				 jQuery("#maincategory_"+choicerowindex).e8Browser({
                 name:"maincategory_"+choicerowindex,
                 viewType:"0",
                 browserValue:"",
                 isMustInput:"1",
                 browserSpanValue:"",
                 hasInput:true,
                 linkUrl:"#",
                 isSingle:true,
                 completeUrl:"/data.jsp?type=categoryBrowser&onlySec=true",
				 getBrowserUrlFn:'onShowCatalog',
				 getBrowserUrlFnParams:''+choicerowindex,
				 _callback:"afterSelect",
				 _callbackParams:choicerowindex,
         
                 width:"60%",
                 hasAdd:false,
                 isSingle:true
                 });
				break;
			case 4:
                /*
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<BUTTON type='button' class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+choicerowindex+"', 'childItem"+choicerowindex+"')\" id=\"selectChildItem"+choicerowindex+"\" name=\"selectChildItem"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem"+choicerowindex+"\" name=\"childItem"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan"+choicerowindex+"\" name=\"childItemSpan"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
                */
                var oDiv = document.createElement("div");
                var sHtml = "<div style='float:left; display:inline;width:25px;' class='childItemDiv'>"
                            + "\r\n<span  id='childItem"+choicerowindex+"' name='childItem"+choicerowindex+"' ></span>"
                            + "\r\n</div><span id=\"childItemSpan"+choicerowindex+"\" class=\"childItemSpan\" name=\"childItemSpan"+choicerowindex+"\"></span>";
                oDiv.innerHTML = sHtml;
                oCell1.appendChild(oDiv);
                jQuery("#childItem"+choicerowindex).e8Browser({
                   name:"childItem"+choicerowindex,
                   viewType:"0",
                   browserValue:"",
                   isMustInput:"1",
                   browserSpanValue:"",
                   getBrowserUrlFn:"showChildSelectItem",
                   getBrowserUrlFnParams:''+choicerowindex,
                   _callback:"selectChildSelectItem",
                   _callbackParams:choicerowindex,
                   hasInput:false,
                   isSingle:false,
                   hasBrowser:true,
                   width:"25px",
                   hasAdd:false
                   });
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='cancel_"+choicerowindex+"_name' id='cancel_"+choicerowindex+"_name' value='1'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
	setChange();
	choicerowindex++;
	recordchoicerowindex++;
	jQuery("#choiceTable0").jNice();
}
	function submitClear(){
		//检查是否选中要删除的数据项


		var flag = false;
		var col = document.getElementsByName("chkField");
		for(var i = 0; i<col.length; i++){
			if(col[i] && col[i].checked){
				flag = true;
				break;
			}
		}
		if(flag){
			//if (isdel()){
			//	deleteRow1();
			//}
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				deleteRow1();
			}, function () {}, 320, 90,true);
		} else {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
			return false;
		}
	}
	function setBTC(){
            var url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/browsertypesetting.jsp?isFromMode=<%=isFromMode%>";
            var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(125117, user.getLanguage())%>";
			dlg.Width=550;//定义长度
			dlg.Height=600;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
    }
	
	function deleteRow1(){
		var objTbl = document.getElementById("choiceTable0");
		var objChecks=objTbl.getElementsByTagName("INPUT");	
		var objChecksLen = objChecks.length-1;

		if(rrowindex==0)rrowindex=1;
		for(var i=objChecksLen;i>=0;i--){
			if(objChecks[i]&& objChecks[i].name=="chkField" && objChecks[i].checked && !objChecks[i].disabled){ 
				//objTbl.deleteRow(objChecks[i].index);	
				jQuery(objChecks[i]).parents("tr:first").remove();
				rrowindex--;
			}
		}	 
		
		setChange();
		
		//重新排序
		var j =1;
		for(var i=0;i<objChecksLen;i++){
			if(objChecks[i]&&objChecks[i].name=="chkField" && j<=rrowindex){ 
				objChecks[i].index = j;
				j++;
			}
		}
	}
	
function onShowCatalog(choicerowindex){
    var url="";
	var isAccordToSubCom=0;	
	if(document.getElementById("isAccordToSubCom"+choicerowindex)!=null){
		if(document.getElementById("isAccordToSubCom"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		url=onShowCatalogSubCom(choicerowindex);
	}else{
		url=onShowCatalogHis(choicerowindex);
	}
	setChange();
	return url;
}
function afterSelect(e,rt,name,choicerowindex){
var docsec=rt.mainid+","+rt.subid+","+rt.id ;
 jQuery("input[name=maincategory_"+choicerowindex+"]").val(docsec);	
jQuery("input[name=pathcategory_"+choicerowindex+"]").val(jQuery("span[name=maincategory_"+choicerowindex+"span]").text() );  
setChange();
}
function onShowCatalogHis(choicerowindex) {	
	   
	 return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";   





}

function onShowCatalogSubCom(index) {





	var selectvalue=document.getElementById("selectvalue"+index).value;
    return "/systeminfo/BrowserMain.jsp?url=/docs/field/SubcompanyDocCategoryBrowser.jsp?fieldId=<%=fieldid%>&isBill=1&selectValue="+selectvalue;
	
}
	var dbnamesForCompare = "<%=dbnamesForCompare_main%>";
	function submitData(){
		if(check_form(form1,"fieldname,fieldlabelname")){
			fieldhtmltype = document.getElementById("FieldHtmlType").value;
			documentType = document.getElementById("DocumentType").value;
			//var browsertype=jQuery("input[name='browsertype']").val();//--zzl
			var browsertype= jQuery("#browsertype").val();
			if(fieldhtmltype==1&&documentType==1&&document.getElementById("itemFieldScale1").value==""){//单行文本框——文本时，文本长度必填。


				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			if(fieldhtmltype==3&&browsertype==''){
				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			if(fieldhtmltype==3&&(browsertype==161||browsertype==162)&&document.getElementById("definebroswerType").value==""){
				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			if(fieldhtmltype==3&&(browsertype==256||browsertype==257)&&document.getElementById("defineTreeBroswerType").value==""){
				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			if(fieldhtmltype==3&&(browsertype==226||browsertype==227)&&document.getElementById("showvalue").value==""){//集成浏览按钮必填
				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			
			if(fieldhtmltype==3){
			    if(browsertype==165||browsertype==166||browsertype==167||browsertype==168){
			    	if(document.getElementById("decentralizationbroswerType").value==""){
			    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
			    	}
				}
			}
						
			if(fieldhtmltype==5){
				var selectItemType = jQuery("#selectItemType").val();
			    if(selectItemType==0){
			    	var choiceRows = recordchoicerowindex;
					for(var tempchoiceRows=1;tempchoiceRows<=choiceRows;tempchoiceRows++){
						if(document.getElementById("field_name_"+tempchoiceRows)&&document.getElementById("field_name_"+tempchoiceRows).value==""){//选择框的可选项文字必填
							top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							return;
						}
					}
					$G("choiceRows_rows").value=recordchoicerowindex;
					
					if(document.getElementById("choiceTable0")){
						$G("choiceRows_rows").value=recordchoicerowindex;
						
						var disorder = 0;
						jQuery("input[name^=field_count_name_]").each(function(){
							jQuery(this).val(disorder);
							disorder++;
						});
					}
			    }else if(selectItemType==1){
			    	if(!check_form(form1,"pubchoiceId")){
			    		return;
			    	}
			    }else if(selectItemType==2){
			    	if(!check_form(form1,"pubchilchoiceId")){
			    		return;
			    	}
			    }
			}
			var fieldname = $G("fieldname").value;
			if (!checkKey())  return false;
			var updateTableName = document.getElementById("updateTableName").value;
			if(updateTableName.indexOf("_dt")>0){
				if(fieldname=="id"||fieldname=="mainid"){
					top.Dialog.alert(fieldname+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("fieldname").select();
					return;
				}
			}else{
				if(fieldname=="id"||fieldname=="requestId"){
					top.Dialog.alert(fieldname+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("fieldname").select();
					return;
				}
			}
			if(updateTableName.indexOf("_dt")<0 && dbnamesForCompare.indexOf(","+fieldname.toUpperCase()+",")>=0){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
				return;
			}else if(updateTableName.indexOf("_dt")>0){
				var dbnamesForCompareDetail = document.getElementById(updateTableName).value;
				if(dbnamesForCompareDetail.indexOf(","+fieldname.toUpperCase()+",")>=0){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
				return;
				}
			}
			
			//对选择框中的欧元符号进行特殊处理


			var selectItemType2 = jQuery("#selectItemType").val();
			if(fieldhtmltype==5 && selectItemType==0){
				for(var i=1; i<=recordchoicerowindex; i++){
					var myObj = document.getElementById("field_name_" + i);
					if(myObj){
						myObj.value = dealSpecial(myObj.value);
					}
				}
			}
			$G("src").value="editField";
			$G("form1").submit();
			enableAllmenu();
		}
	}

	//对特殊符号进行处理


	function dealSpecial(val){
		//本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码


		var euro = "\u20AC";
		//本字符串是欧元符号在HTML中的特别表现形式
		var symbol = "&euro;";
		var reg = new RegExp(euro);
		while(val.indexOf(euro) != -1){
			val = val.replace(reg, symbol);
		}  
		return val;
	}
	
	function checkKey()
	{
	var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
	//以下for oracle.update by cyril on 2008-12-08 td:9722
	keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
	keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
	keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
	keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
	keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
	keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
	keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
	keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
	keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
	keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
	keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
	keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
    var fname=$G("fieldname").value;
	if (fname!="")
		{fname=","+fname.toUpperCase()+",";
	if (keys.indexOf(fname)>0)
		{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
		$G("fieldname").focus();
        return false;
	    }
		}
	return true;
	}
	
	
	 function BTCOpen(){
			var btcspan = $("#browsertype_autoSelect");
			
            //清空已有BTC对象
            var btc = new BTC();

            var tempBtc;
            while(tempBtc = BTCArray.shift()){
              btcspan.find(".sbToggle").removeClass("sbToggle-btc-reverse")
              tempBtc.remove();
            }
       
    	    
    	   
    	    //浏览框类型选择框处理


            btcspan.find(".sbToggle").addClass("sbToggle-btc");
            btcspan.find(".sbToggle").unbind("click");
            btcspan.find(".sbSelector").unbind("focus");
            btcspan.find(".sbSelector").unbind("click"); 
            btcspan.find(".sbSelector").unbind("blur");  
            btcspan.find(".sbSelector").css("font-size","12px");  
            btcspan.find(".sbSelector").css("text-indent","0");     
            btcspan.find(".sbSelector").bind("focus",function(){
				    if(btcspan.find(".sbToggle").hasClass("sbToggle-btc-reverse")){
				       if(BTCArray.length>0){
				       	btcspan.find(".sbToggle").trigger("click");
				       }
				    };
			});
			
			btcspan.find(".sbToggle").bind("click",function(){
			
			   if(btcspan.find(".sbToggle").hasClass("sbToggle-btc-reverse")){
               	  btc.remove();
			   }else{
			   	  
			   	  btc.init({
					  renderTo:btcspan,
				      headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead",
					  contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&isFromMode=<%=isFromMode%>",
					  contentHandler:function(value){
						    $("#browsertype").val(value);
						    $("#browsertype").trigger("change");
						    btc.remove();
						    $(".sbToggle-btc-reverse").removeClass("sbToggle-btc-reverse");
					  }
			  	  });  
			  	  
			  	  try{
			   	  	 $("#e8_autocomplete_div").hide();			
		          }catch(e){}
			   }
			   btcspan.find(".sbToggle").toggleClass("sbToggle-btc-reverse");
			});
			
			
    }
	
	function deleteData(){
		//if (isdel()){
			//$G("src").value="deleteField";
			//form1.submit();
			//enableAllmenu();
		//}
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			$G("src").value="deleteField";
			form1.submit();
		}, function () {}, 320, 90,true);
		
	}
	function OnChangeFieldHtmlType(){
		var fieldHtmlType = $G("FieldHtmlType").value;
		var browsertype=$G("browsertype").value;
		
		if(fieldHtmlType==1){
			document.getElementById("div1").style.display="inline";
			$G("DocumentType").value = "1";
			jQuery("#DocumentType").selectbox("detach");
			jQuery("#DocumentType").selectbox("attach");
			document.getElementById("div1_1").style.display="inline";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		   //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==2){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="inline";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==3){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="inline";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			if(browsertype==226||browsertype==227){
				document.getElementById("div3_5").style.display="inline";
			}else{
				document.getElementById("div3_5").style.display="none";
			}
			if(browsertype==256||browsertype==257){
				document.getElementById("div3_7").style.display="inline";
			}else{
				document.getElementById("div3_7").style.display="none";
			}
			 jQuery('#browsertype').autoSelect();
				document.getElementById("div3_4").style.display="none";
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		    OnChangeBrowserType();
		    BTCOpen();
		}
		if(fieldHtmlType==4){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==5){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="inline";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		    
		    setSelectItemType();
		    selectItemTypeChange('selectItemType');
		}
		if(fieldHtmlType==6){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="inline";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
            document.getElementById("uploadtype").options[0].selected=true;
		}
		if(fieldHtmlType==7){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="inline";
		    document.getElementById("div7_1").style.display="";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
            document.getElementById("specialfield").options[0].selected=true;
		}
		if(fieldHtmlType==9){
			document.getElementById("div9").style.display="inline";
			//document.getElementById("div9_1").style.display="inline";
			document.getElementById('DocumentType').selectedIndex=0;
			jQuery("#DocumentType").selectbox("detach");
			jQuery("#DocumentType").selectbox("attach");
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		}
	}
	
	function OnChangelocationType(){
		/*var locationType = document.getElementById("locationType").value;
		if(locationType == 1){
			document.getElementById("div9_1").style.display = "inline";
		}*/
	}
	
    function onuploadtype(obj){
        if(obj.value==1){
            document.getElementById("div6_1").style.display="none";
        }else{
            document.getElementById("div6_1").style.display="";
        }
    }
    function specialtype(obj){
        if(obj.value==1){
            document.getElementById("div7_1").style.display="";
		    document.getElementById("div7_2").style.display="none";
        }else{
            document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="";
        }
    }
	function OnChangeDocumentType(){
		var documentType = $G("DocumentType").value;
		if(documentType==1){
			document.getElementById("div1_1").style.display="inline";
			document.getElementById("div1_3").style.display="none";
		}else if(documentType==3){
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="inline";
		}else if(documentType==5){
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="inline";
		}else{
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
		}
	}
	function OnChangeBrowserType(){
		var browserType = $G("browsertype").value;
		document.getElementById("div3_7").style.display="none";
		if(browserType==161||browserType==162){
			//document.getElementById("div3_1").style.display="inline"
			document.getElementById("div3_2").style.display="inline";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}else if(browserType==256||browserType==257){
		    document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="inline";
		}else if(browserType==224||browserType==225){
			document.getElementById("div3_4").style.display="inline"
				var sapbrowserOptionValue = document.getElementById("sapbrowser").value;
				if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
				    document.getElementById("div3_1").style.display="inline"
				}else{
				    document.getElementById("div3_1").style.display="none"
				}
				document.getElementById("div3_2").style.display="none";
				document.getElementById("div3_3").style.display="none";
				document.getElementById("div3_5").style.display="none";
		}else if(browserType==226||browserType==227){
			//zzl
			document.getElementById("div3_5").style.display="inline"
				var sapbrowserOptionValue = document.getElementById("showvalue").value;
				if(sapbrowserOptionValue==''){
				    document.getElementById("showimg").style.display="inline"
				}else{
				    document.getElementById("showimg").style.display="none"
				}
				document.getElementById("div3_2").style.display="none";
				document.getElementById("div3_3").style.display="none";
				document.getElementById("div3_4").style.display="none";
				document.getElementById("div3_1").style.display="none"
		}else if(browserType==165||browserType==166||browserType==167||browserType==168){
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="inline";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}else{
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}
		if (browserType == '') {
       		jQuery('#div3 #selecthtmltypespan').show();
       	} else {
       		jQuery('#div3 #selecthtmltypespan').hide();
       	}
	}
	function onfirmhtml(){
		if ($G("htmledit").checked==true){
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
			$G("htmledit").value=2;
		}
	}
	function OnChangeSapBroswerType(){
		if ($G("sapbrowser").value==""){
			document.getElementById("div3_1").style.display="inline"
		}else{
			document.getElementById("div3_1").style.display="none"
		}
	}
	function OnChangeDefineTreeBroswerType(id){
		if ($G(id).value==""){
			document.getElementById("div3_1").style.display="inline";
		}else{
			document.getElementById("div3_1").style.display="none";
		}
	}
	
	function OnNewChangeSapBroswerTypeCallback(temp){
		if(temp){
			$G("showinner").innerHTML=temp;
			$G("showvalue").value=temp;
			$G("showimg").innerHTML="";
		}
	}
	
	
	function OnNewChangeSapBroswerType(){
		
		var updateTableName=$G("updateTableName").value;//得到主表或明细表的名字


		var browsertype=$G("browsertype").value;
		var mark=$G("showinner").innerHTML;
		var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
	    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
	    var urls ="/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>&updateTableName="+updateTableName; 
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "SAP";
	    dialog.URL = urls;
		
		dialog.maxiumnable = true;
		dialog.DefaultMax=true;
		dialog.callbackfun=OnNewChangeSapBroswerTypeCallback;
		//dialog.callbackfunParam={obj:obj};
		dialog.textAlign = "center";
		dialog.show();
		
		
	}
		
	function OnChangeUpdateTableName(obj){
	
        FieldHtmlType = document.getElementById("FieldHtmlType");
        //主表
        if(obj.value=="<%=maintable%>"){
           for(var count = FieldHtmlType.options.length - 1; count >= 0; count--){
	           FieldHtmlType.options[count] = null;
           }
           <%=mainselect%>
           $("li a[title='<%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%>']").parent().show(); 
           $("li a[title='<%=SystemEnv.getHtmlLabelName(21691, user.getLanguage())%>']").parent().show(); 
           $G("FieldHtmlType").value = "1";
           $("#FieldHtmlType").val("1");
           $("#FieldHtmlType").selectbox("detach");
           $("#FieldHtmlType").selectbox("attach");
           OnChangeFieldHtmlType(); 
           $G("DocumentType").value = "1";
           jQuery("#DocumentType").selectbox("detach");
		   jQuery("#DocumentType").selectbox("attach");
           OnChangeDocumentType();
           //明细表中的多行文本框字段html格式可用
           $GetEle("htmledit").disabled = false;
        //明细表


        }else{
           for(var count = FieldHtmlType.options.length - 1; count >= 0; count--){
	           FieldHtmlType.options[count] = null;
           }
           <%=detailselect%>     
           $("li a[title='<%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%>']").parent().hide(); 
           $("li a[title='<%=SystemEnv.getHtmlLabelName(21691, user.getLanguage())%>']").parent().hide();     
           $G("FieldHtmlType").value = "1";
           $("#FieldHtmlType").val("1");
           $("#FieldHtmlType").selectbox("detach");
           $("#FieldHtmlType").selectbox("attach");
           OnChangeFieldHtmlType();
           $G("DocumentType").value = "1";
           jQuery("#DocumentType").selectbox("detach");
		   jQuery("#DocumentType").selectbox("attach");
           OnChangeDocumentType();
           //明细表中的多行文本框字段html格式不可用


           $GetEle("htmledit").disabled = true;
        }
                        
        var updateTableName = $G("updateTableName").value;
		dbnamesForCompare = $G(updateTableName).value;
	}
	/*
	p（精度）
	指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。


	
	s（小数位数）
	指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。


	*/
	function checkDigit(elementName,p,s){
		tmpvalue = document.getElementById(elementName).value;
	
	    var len = -1;
	    if(elementName){
			len = tmpvalue.length;
	    }
	
		var integerCount=0;
		var afterDotCount=0;
		var hasDot=false;
	
	    var newIntValue="";
		var newDecValue="";
	    for(i = 0; i < len; i++){
			if(tmpvalue.charAt(i) == "."){ 
				hasDot=true;
			}else{
				if(hasDot==false){
					integerCount++;
					if(integerCount<=p-s){
						newIntValue+=tmpvalue.charAt(i);
					}
				}else{
					afterDotCount++;
					if(afterDotCount<=s){
						newDecValue+=tmpvalue.charAt(i);
					}
				}
			}		
	    }
	
	    var newValue="";
		if(newDecValue==""){
			newValue=newIntValue;
		}else{
			newValue=newIntValue+"."+newDecValue;
		}
	    document.getElementById(elementName).value=newValue;
	}
	function getIsDetail(){
		var updateTableName = document.getElementById("updateTableName").value;
		var isdetail = "0";
		if(updateTableName.indexOf("_dt") > -1){
			isdetail = "1";
		}
		return isdetail;
	}
	function getDetailTableSql(){
		var updateTableName = document.getElementById("updateTableName").value;
		var detailTableSql = "";
		if(updateTableName.indexOf("_dt") > -1){
			detailTableSql = " and detailtable='"+updateTableName+"' ";
		}
		return detailTableSql;
	}
	function setChange(){		
		$G("hasChanged").value="true";		
	}
	function onChangeChildField(){
		var rownum = parseInt(recordchoicerowindex) + 1;
		for(var i=0; i<rownum; i++){
			var inputObj = $G("childItem"+i);
			var spanObj = $G("childItemSpan"+i);
			try{
				if(inputObj!=null && spanObj!=null){
					inputObj.value = "";
					spanObj.innerHTML = "";
				}
			}catch(e){}
		}
	}
	var x=<%=rownumber%>;
function clearchild(){
	for(i=1;i<=x;i++){
		document.getElementById("childItemSpan"+i).innerHTML="";
		document.getElementById("childItem"+i).value="";
	}

}
function checkmaxlength(maxlen,elementname){
	var mLength_t = document.getElementById(elementname).value;
	if((mLength_t*1) < (maxlen*1)){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23548,user.getLanguage())%>");
		document.getElementById(elementname).value = maxlen;
    }
}
</script>

<script type="text/javascript">
function onShowChildField(spanname, inputname) {
	var oldvalue = $G(inputname).value
	var isdetail = getIsDetail();
	var detailTableSql = getDetailTableSql();
	var url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%> and id<><%=fieldid%> " + detailTableSql + "&isdetail=" + isdetail + "&isbill=1");
	var id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G(inputname).value = rid;
			$G(spanname).innerHTML = rname;
		} else {
			clearchild();
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
	if (oldvalue != $G(inputname).value) {
		onChangeChildField();
		setChange();
	}
}

function onShowChildSelectItem(spanname, inputname) {
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	var isdetail = getIsDetail();
	var url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			var resourceids = rid.substr(1);
			var resourcenames = rname.substr(1);
			
			$G(inputname).value = resourceids;
			$G(spanname).innerHTML = resourcenames;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
		setChange();
	}
}
 //browsertype 下拉框选项按照字母顺序排序
function sortRule(a,b) {
	var x = a._text;
	var y = b._text;
	return x.localeCompare(y);
}
function op(){
	var _value;
	var _text;
}
 function sortOption(obj){
//	var obj = document.getElementById(objid);
	var tmp = new Array();
	for(var i=0;i<obj.options.length;i++){
		var ops = new op();
		ops._value = obj.options[i].value;
		ops._text = obj.options[i].text;
		tmp.push(ops);
	}
	tmp.sort(sortRule);
	for(var j=0;j<tmp.length;j++){
		obj.options[j].value = tmp[j]._value;
		obj.options[j].text = tmp[j]._text;
	}
}

jQuery(function ()  {
	var sltval = $G("browsertype").value;
	sortOption($G("browsertype"));
	jQuery("#browsertype option[value='" + sltval + "']").attr("selected", true);
	BTCOpen();

});
if("<%=openrownum%>">=0){
jQuery("#maincategory_<%=openrownum%>_browserbtn").click();  

}



setInterval(clearDetail,50);
function clearDetail(){
	var childfieldid = jQuery('#childfieldid').val();
	if(childfieldid == ''){
		jQuery("input[name^='childItem']").val('');
		jQuery("span[name^='childItemSpan']").html('');
	}
}
function showChildSelectItem(choicerowindex){
    
    var cfid = $G("childfieldid").value;
    var resourceids = jQuery("#childItem" + choicerowindex).val();
    var isdetail = getIsDetail();
    var url= "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
    
    return url;
}
function selectChildSelectItem(e,rt,name,choicerowindex){

    if (rt != null) {
        var rid = rt.id;
        var rname = rt.name;
        if (rid != "") {
            var resourceids = rid.substr(1);
            var resourcenames = rname.substr(1);
            jQuery("#childItem" + choicerowindex).val(resourceids);  
            jQuery("#childItemSpan" + choicerowindex).html(resourcenames);  
            jQuery("#childItemSpan" + choicerowindex).attr("title",resourcenames);
        } else {
            jQuery("#childItem" + choicerowindex).val("");  
            jQuery("#childItemSpan" + choicerowindex).html("");  
            jQuery("#childItemSpan" + choicerowindex).removeAttr("title");
        }
    }

}
</script>
<!-- 
<script language="VBScript">
sub onShowChildField(spanname, inputname)
	oldvalue = inputname.value
	isdetail = getIsDetail()
	detailTableSql = getDetailTableSql()
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%> and id<><%=fieldid%> "+detailTableSql+"&isdetail="+isdetail+"&isbill=1")
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			inputname.value = id(0)
			spanname.innerHtml = id(1)
		else
  			clearchild()
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if
	if oldvalue <> inputname.value then
		onChangeChildField
		setChange
	end if
end sub

sub onShowChildSelectItem(spanname, inputname)
	cfid = form1.childfieldid.value
	resourceids = inputname.value
	isdetail = getIsDetail()
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail="+isdetail+"&childfieldid="&cfid&"&resourceids="&resourceids)
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			resourceids = id(0)
			resourcenames = id(1)
			resourceids = Mid(resourceids, 2, len(resourceids))
			resourcenames = Mid(resourcenames, 2, len(resourcenames))
			inputname.value = resourceids
			spanname.innerHtml = resourcenames
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
		setChange
	end if

end sub
</script>
 --> 
