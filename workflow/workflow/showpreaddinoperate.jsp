<!DOCTYPE html>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="bci" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.formmode.tree.CustomTreeUtil" %>
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.workflow.action.WSActionManager" scope="page" />
<jsp:useBean id="sapActionManager" class="weaver.workflow.action.SapActionManager" scope="page" />
<jsp:useBean id="baseAction" class="weaver.workflow.action.BaseAction" scope="page" />
<jsp:useBean id="workflowActionManager" class="weaver.workflow.action.WorkflowActionManager" scope="page" />
<SCRIPT language="javascript" src="/integration/js/hashmap_wev8.js"></script>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<STYLE TYPE="text/css">
.btn_actionList
{
	BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HEAD>
<SCRIPT LANGUAGE="JavaScript">
	var fieldurl;
	var fieldtempurl = "";
	//zzl
	var saphashmap = new HashMap();
</SCRIPT>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
int linkid = Util.getIntValue(request.getParameter("linkid"),0);
int formid=Util.getIntValue(request.getParameter("formid"),0);
String isbill =""+Util.getIntValue(request.getParameter("isbill"),0);
int istemplate = Util.getIntValue(request.getParameter("istemplate"),0);
boolean hascon = false;

//读配置文件，获得用户可以选择的Action列表
boolean isDmlAction = GCONST.isDMLAction();
boolean isWsAction = GCONST.isWsAction();
boolean isSapAction = GCONST.isSapAction();

String drawBackFlg = Util.null2String(request.getParameter("drawBackFlg"));

String sql="";
if(formid==0){
	sql = " select * from workflow_base where id = "+wfid;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		formid = RecordSet.getInt("formid");
		isbill = RecordSet.getString("isbill");
		istemplate = RecordSet.getInt("istemplate");
	}
}
ArrayList fieldids = new ArrayList();
fieldids.clear();
ArrayList fieldnames = new ArrayList();
fieldnames.clear();
ArrayList fieldlabels = new ArrayList();
fieldlabels.clear();
ArrayList fieldhtmltypes = new ArrayList();
fieldhtmltypes.clear();
ArrayList fieldtypes = new ArrayList();
fieldtypes.clear();
ArrayList fielddbtypes = new ArrayList();
fielddbtypes.clear();

String allOptions = "";
String op1Options = "";
String op2Options = "";
String objOptions = "";
String operOptions = "";

op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15618,user.getLanguage()) +"','0');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15619,user.getLanguage()) +"','0');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15620,user.getLanguage()) +"','0');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(104,user.getLanguage()) +"','0');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15621,user.getLanguage()) +"(+)','1');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15622,user.getLanguage())+"(-)','2');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15623,user.getLanguage())+"(*)','3');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15624,user.getLanguage())+"(/)','4');";

if(isbill.equals("0")){
	sql = "select workflow_formdict.fielddbtype as fielddbtype,workflow_formfield.isdetail,workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.fieldhtmltype<>7 and workflow_formfield.formid="+formid;
	//明细字段也可以做节点前附加操作 modify by myq 2007.12.28 start
	sql += " union select workflow_formdictdetail.fielddbtype as fielddbtype,workflow_formfield.isdetail,workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdictdetail.fieldhtmltype as htmltype,workflow_formdictdetail.type as type from workflow_formfield,workflow_formdictdetail,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdictdetail.id = workflow_formfield.fieldid and workflow_formfield.isdetail='1' and workflow_formfield.formid="+formid;
	//明细字段也可以做节点前附加操作 modify by myq 2007.12.28 end
	String dbType = RecordSet.getDBType();
	if(dbType.equals("oracle")) sql += " order by isdetail desc";
	else sql += " order by isdetail asc";
}else if(isbill.equals("1"))
	sql = "select fielddbtype as fielddbtype,viewtype as isdetail, id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type from workflow_billfield where fieldhtmltype<>7 and billid = "+formid + " order by viewtype,detailtable,dsporder ";
//SQL修改，增加“viewtype as isdetail,”，使明细字段在列表中会表明“明细”

//褚俊 2008.05.06
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tmphtmltype = Util.null2String(RecordSet.getString("htmltype"));
	if(!tmphtmltype.equals("9")){    
	
		String tmptype = Util.null2String(RecordSet.getString("type"));
		String tmpid = Util.null2String(RecordSet.getString("id"));
		String tmplabel ="";
	
		int fieldlen=-1;
		String tmpfielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
		if ((tmpfielddbtype.toLowerCase()).indexOf("varchar")>-1){
			fieldlen = Util.getIntValue(tmpfielddbtype.substring(tmpfielddbtype.indexOf("(")+1,tmpfielddbtype.length()-1));
		}
	    //注释过虑操作，增加浏览框的处理功能
	
	
		fieldids.add(tmpid);
		fieldnames.add(Util.null2String(RecordSet.getString("name")));
		//褚俊 2008.05.06 使明细字段在列表中会表明“明细” Start
		String isdetail = Util.null2String(RecordSet.getString("isdetail"));
		//System.out.println("isdetail = " + isdetail);
		if(isbill.equals("1")){
			tmplabel = ""+SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("label")),user.getLanguage());
			if("1".equals(isdetail)){
				tmplabel = tmplabel + "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
			}
			//System.out.println("tmplabel = " + tmplabel);
			fieldlabels.add(tmplabel);
		}else{
			tmplabel = Util.null2String(RecordSet.getString("label"));
			if("1".equals(isdetail)){
				tmplabel = tmplabel + "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
			}
			//System.out.println("tmplabel = " + tmplabel);
			
			fieldlabels.add(tmplabel);
		}
		//褚俊 2008.05.06 使明细字段在列表中会表明“明细” End
		fieldhtmltypes.add(tmphtmltype);
		fieldtypes.add(tmptype);
		fielddbtypes.add(tmpfielddbtype);
	
		allOptions +="<option value='"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"'>"+tmplabel+"</option>";
		op1Options += "op1List.options[i++] = new Option('"+tmplabel+"','"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"');";
		op2Options += "op2List.options[i++] = new Option('"+tmplabel+"','"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"');";
		objOptions += "objList.options[i++] = new Option('"+tmplabel+"','"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"_"+fieldlen+"');";
		%>
		<SCRIPT LANGUAGE="JavaScript">
			fieldtempurl = fieldtempurl + "<%="_"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype%>" + ":" + "'" + "<%=tmpfielddbtype%>" + "',";
			saphashmap.put("<%=tmpid%>","?type=<%=tmpfielddbtype%>|<%=tmpid%>");
		</SCRIPT>
		<%
	}
}

op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15625,user.getLanguage()) +"','0_-1_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15626,user.getLanguage()) +"','0_-2_3_19');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage()) +"1','0_-10_3_19');";
op1Options += "op1List.options[i++] = new Option('"+SystemEnv.getHtmlLabelName(15627,user.getLanguage()) +"2','0_-11_3_19');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3','0_-12_3_19');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1','0_-13_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2','0_-14_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3','0_-15_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1','0_-16_1_1');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2','0_-17_1_1');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3','0_-18_1_1');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1','0_-19_1_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2','0_-20_1_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3','0_-21_1_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1','0_-22_1_3')";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2','0_-23_1_3');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3','0_-24_1_3');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15632,user.getLanguage()) +"','customervalue');";

op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1','0_-10_3_19');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2','0_-11_3_19');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3','0_-12_3_19');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1','0_-13_3_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2','0_-14_3_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3','0_-15_3_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1','0_-16_1_1');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2','0_-17_1_1');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3','0_-18_1_1');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1','0_-19_1_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2','0_-20_1_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3','0_-21_1_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1','0_-22_1_3');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2','0_-23_1_3');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3','0_-24_1_3');";

objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1','0_-10_3_19_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2','0_-11_3_19_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3','0_-12_3_19_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1','0_-13_3_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2','0_-14_3_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3','0_-15_3_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1','0_-16_1_1_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2','0_-17_1_1_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3','0_-18_1_1_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1','0_-19_1_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2','0_-20_1_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3','0_-21_1_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1','0_-22_1_3_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2','0_-23_1_3_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3','0_-24_1_3_-1');";


String tmpfieldop1id = Util.null2String(request.getParameter("fieldop1id"));
String fieldid = Util.null2String(request.getParameter("fieldid"));

String htmltype1="";
String fieldop2id = Util.null2String(request.getParameter("fieldop2id"));

String fieldop1id = "0";
if(!tmpfieldop1id.equals("customervalue") && !tmpfieldop1id.equals("otherproperty") && !tmpfieldop1id.equals("0") && !tmpfieldop1id.equals("")){
	//fieldop1id = tmpfieldop1id.substring(0,tmpfieldop1id.indexOf("_"));
    tmpfieldop1id = tmpfieldop1id.substring(tmpfieldop1id.indexOf("_")+1);
    fieldop1id = tmpfieldop1id.substring(0,tmpfieldop1id.indexOf("_"));
}
char flag =2;

if(!fieldid.equals("0") && !fieldid.equals("")){
    fieldid = fieldid.substring(fieldid.indexOf("_")+1);
  htmltype1=fieldid.substring(fieldid.indexOf("_")+1,fieldid.lastIndexOf("_"));
	fieldid = fieldid.substring(0,fieldid.indexOf("_"));
}
if(!fieldop2id.equals("0") && !fieldop2id.equals(""))
	fieldop2id = fieldop2id.substring(0,fieldop2id.indexOf("_"));

String customervalue = Util.null2String(request.getParameter("fieldop1idvalue"));
String operation = Util.null2String(request.getParameter("operation"));
String skipweekend = Util.null2String(request.getParameter("skipweekend"));
String skippubholiday = Util.null2String(request.getParameter("skippubholiday"));
String src = Util.null2String(request.getParameter("src"));

int rules =0;
if(skipweekend.equals("1")){
	rules = rules | 1;
}
if(skippubholiday.equals("1")){
	rules = rules | 2;
}

//只有'附件上传'具有其他属性设置，'附件上传'的其他设置只有'文档类型设置'，故通过htmltype直接判断出addin类型
if(htmltype1.equals("6")){
  //addin类型为1，表明是附件上传的文档类型设置

  htmltype1="1";
  customervalue = Util.null2String(request.getParameter("otherProperty6"));
}else{
  //addin类型为0，表明是普通的附加操作设置
  htmltype1="0";
}

//存入数据库

//处理dml接口数据
/*
if(src.equals("deletedmlaction")&&istemplate!=1&&(isDmlAction || isWsAction || isSapAction))
{
	String[] checkdmlids = request.getParameterValues("dmlid");
	
	String[] dmlidnewsaps = request.getParameterValues("dmlidnewsap");
	
	if(null!=dmlidnewsaps)
	{
		for(int j=0;j<dmlidnewsaps.length;j++)
		{
			RecordSet.executeSql("delete int_BrowserbaseInfo where id='"+dmlidnewsaps[j]+"'");
		}
		//重新检查一次

		hascon = baseAction.checkActionOnNodeOrLink(wfid,nodeid,linkid,1,1);
		//RecordSet.executeSql("delete int_BrowserbaseInfo where id in()");
	}
		
	if(null!=checkdmlids)
	{
		for(int i = 0;i<checkdmlids.length;i++)
		{
			int dmlid = Util.getIntValue(checkdmlids[i],0);
			if(dmlid>0)
			{
				//DMLActionBase.deleteDmlActionFieldMapByActionid(dmlid);
				//DMLActionBase.deleteDmlActionSqlSetByActionid(dmlid);
				//DMLActionBase.deleteDmlActionSetByid(dmlid);
				
				int actiontype_t = Util.getIntValue(request.getParameter("actiontype"+dmlid), -1);
				if(actiontype_t == 0){
					DMLActionBase.deleteDmlActionFieldMapByActionid(dmlid);
					DMLActionBase.deleteDmlActionSqlSetByActionid(dmlid);
					DMLActionBase.deleteDmlActionSetByid(dmlid);
				}else if(actiontype_t == 1){
					wsActionManager.setActionid(dmlid);
					wsActionManager.doDeleteWsAction();
				}else if(actiontype_t == 2){
					sapActionManager.setActionid(dmlid);
					sapActionManager.doDeleteSapAction();
				}
			}
		}
		//hascon = DMLActionBase.checkDMLActionOnNodeOrLink(wfid,nodeid,linkid,1);
		hascon = baseAction.checkActionOnNodeOrLink(wfid,nodeid,linkid,1,0);
	}
}
//检查是否存在DMLaction配置
if(!hascon&&istemplate!=1&&(isDmlAction || isWsAction || isSapAction))
{
	hascon = DMLActionBase.checkAddinoperateOnNodeOrLink(wfid,nodeid,linkid,1);
}
*/
if(src.equals("delete")){
	String[] checkids = request.getParameterValues("check_node");
	if(checkids!=null){
		for(int i=0;i<checkids.length;i++){
			RecordSet.executeProc("workflow_addinoperate_Delete",""+checkids[i]);
		}

	}
}
if(src.equals("add")){
	if(nodeid!=0)
        RecordSet.executeProc("workflow_addinoperate_Insert",""+nodeid+flag+"1"+flag+wfid+flag+fieldid+flag+fieldop1id+flag+fieldop2id+flag+operation+flag+customervalue+flag+rules+flag+"0"+flag+"1");
	else if(linkid!=0)
		RecordSet.executeProc("workflow_addinoperate_Insert",""+linkid+flag+"0"+flag+wfid+flag+fieldid+flag+fieldop1id+flag+fieldop2id+flag+operation+flag+customervalue+flag+rules+flag+htmltype1+flag+"1");
}
if(src.equals("addaction")){
	workflowActionManager.saveAction(request);
}
/*    String customeraction="";
    if(src.equals("addInterface")){
	    customeraction = Util.null2String(request.getParameter("interface"));
        if(nodeid!=0){
			RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=1 and type=2 and ispreadd=1");
            RecordSet.executeSql("insert into workflow_addinoperate (objid,workflowid,isnode,type,ispreadd,customervalue) values ("+nodeid+","+wfid+",1,2,1,'"+customeraction+"')");
            hascon = true; //解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374
		}
        else if(linkid!=0){
			RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=0 and type=2 and ispreadd=1");
            RecordSet.executeSql("insert into workflow_addinoperate (objid,workflowid,isnode,type,ispreadd,customervalue) values ("+nodeid+","+wfid+",0,2,1,'"+customeraction+"')");
            hascon = true; //解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374
		}

    }
     if(src.equals("delInterface")){
        if(nodeid!=0)
            RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=1 and type=2 and ispreadd=1");
        else if(linkid!=0)
            RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=0 and type=2 and ispreadd=1");

    }
*/
if(src.equals("DrawBackFlg")){
	RecordSet.executeSql("update workflow_flownode set drawbackflag="+drawBackFlg+" where workflowid="+wfid+" and nodeid="+nodeid);
}
String onDrawBackFlg = "0";
RecordSet.executeSql("select drawbackflag from workflow_flownode where workflowid="+wfid+" and nodeid="+nodeid);
if(RecordSet.next()){
	onDrawBackFlg = Util.null2String(RecordSet.getString("drawbackflag"));
}

	//解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374 start
	String objidsql="";
	if(nodeid!=0)
	    objidsql = "select id from workflow_addinoperate where objid="+nodeid+" and workflowid="+wfid+" and isnode=1 and type=2 and ispreadd=1";
	else if(linkid!=0)
	    objidsql = "select id from workflow_addinoperate where objid="+nodeid+" and workflowid="+wfid+" and isnode=0 and type=2 and ispreadd=1";
	
	if(!"".equals(objidsql)){
	    RecordSet2.executeSql(objidsql);
		if(RecordSet2.next()) {
		   hascon = true; 
		}
	}
	//解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374 end
	
	//zzl
	if(src.equals("refush")){
		//什么都不做,用其他的办法好像刷新会自动关闭页面

	}
	
%>
<body  id="preAddInOperateBody" onbeforeunload="closeWindow(1)">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(81603,user.getLanguage())+",javascript:addAction(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closeWindow(1),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showpreaddinoperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=linkid%>" name="linkid">
<input type="hidden" value="<%=isbill%>" name="isbill">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="1" name="ispreoperator">

<input type="hidden" value="<%=istemplate%>" name="istemplate">
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onSave();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:submitClear();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(81603, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:addAction();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<%
	String idHideOldSapNode=IntegratedSapUtil.getIsHideOldSapNode();
 %>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33512,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table width=100% class="ListStyle">
				<colgroup>
				   <col width="15%">
				   <col width="4%">
				   <col width="15%">
				   <col width="23%">
				   <col width="37%">
				</<colgroup>
				<tr>
					<td class=field>
						<select class=inputstyle name=fieldid id=fieldid title="<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%>" onchange="changefieldid(this.value);changeTitle('fieldid', this.value);">
							<option value=0 ><%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%></option>
						</select>
					</td>
					<td align=center class=field><img src="/images/ArrowEqual_wev8.gif" border=0></td>
					<td class=field>
						<select class=inputstyle   name=fieldop1id id=fieldop1id  onchange="changefieldop1id();">
							<option value=customervalue><%=SystemEnv.getHtmlLabelName(15632,user.getLanguage())%></option>
						</select>
					</td>
					<td id="fieldBrowser" class=field style="display:none">
						<span id="unitSelect"><brow:browser name="unit" viewType="0" hasBrowser="true" hasAdd="false" browserOnClick="showPreDBrowser(urls[curIndex],curIndex)" onPropertyChange="changeproperty()" 
						                  isMustInput="1" isSingle="false" hasInput="true" needHidden="false" completeUrl="javascript:getajaxurl(curIndex)"  width="150px" browserValue="" browserSpanValue="" />
						</span>
                        <span id="singleSelect"><brow:browser name="single" viewType="0" hasBrowser="true" hasAdd="false" browserOnClick="showPreDBrowser(urls[curIndex],curIndex)" onPropertyChange="changepropertySingle()" 
                                          isMustInput="1" isSingle="true" hasInput="true" needHidden="false" completeUrl="javascript:getajaxurl(curIndex)"  width="150px" browserValue="" browserSpanValue="" />
                        </span>
						<input class=Inputstyle type=text name=unit id = unit size=8 style="display:none">
					</td>
					<td class=field>
						<select class=inputstyle  name=operation id=operation  onchange="changeoperation(this.value)">
							<option value="0"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></option>
						</select>
						<input class=Inputstyle type=text name=fieldop1idvalue id = fieldop1idvalue size=8 style="display:none">
						<span name=otherPropertyName id=otherPropertyName style="display:none"><%=SystemEnv.getHtmlLabelName(19544,user.getLanguage())%></span>
					</td>
					<td class=field>
						<select class=inputstyle  name=fieldop2id id=fieldop2id  onchange="changefieldop2id(this.value)">
							<option value=0><%=SystemEnv.getHtmlLabelName(15619,user.getLanguage())%></option>
						</select>
						<span name=otherProperty6Value id=otherProperty6Value style="display:none">
						<select class="inputstyle" name="otherProperty6" id="otherProperty6">
							<option value=0><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
							<option value=2><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
							<option value=3><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></option>
							<option value=4><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
							<option value=5><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
						</select>
						</span>
					</td>
				</tr>
				<tr id=oHeightTenTr  style="display:none"><td height="10" colspan="5"></td></tr>
				<tr class="Title"  id=oDescriptionTr style="display:none">
					<th colSpan=5><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></th>
				</tr>
				<tr class="Spacing"  id=oLine1Tr style="display:none;height: 1px;"><td class="Line1" colspan=5 style="padding: 0px;"></td></tr>
				<tr id = oDateRuleTr style="display:none">
					<td colspan=3>
						<input type=checkbox name="skipweekend" value=1><%=SystemEnv.getHtmlLabelName(15633,user.getLanguage())%>
					</td>
					<td colspan=2>
						<input type=checkbox name="skippubholiday" value=1><%=SystemEnv.getHtmlLabelName(15634,user.getLanguage())%>
					</td>
				</tr>
			</table>						
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21987,user.getLanguage())%>'>
		<wea:item> </wea:item>
		<wea:item> 
			<input type=radio id="drawBackFlg" name="drawBackFlg" value=1 <%if(onDrawBackFlg.equals("1")){%>checked<%}%> onclick="onDrawBackFlg()"><%=SystemEnv.getHtmlLabelName(21988,user.getLanguage())%>
			<input type=radio id="drawBackFlg" name="drawBackFlg" value=0 <%if(!onDrawBackFlg.equals("1")){%>checked<%}%> onclick="onDrawBackFlg()"><%=SystemEnv.getHtmlLabelName(21989,user.getLanguage())%>		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15635,user.getLanguage())%>'>
		<wea:item attributes="{\"id\":\"test\",\"colspan\":\"2\"}">
			<table width=100% class=ListStyle cellspacing=0  >
				<colgroup>
					<col width="5%">
					<col width="65%">
					<col width="30%">
				</colgroup>
				<tr class=header>
					<td>&nbsp;</td>
					<td><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></td>
				</tr>
			<%
			String operateSel="";
			if(isbill.equals("0")){
			    operateSel = "select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.fielddbtype,b.type,c.tablename,c.columname,c.keycolumname from workflow_addinoperate a ,workflow_formdict b,workflow_browserurl c where a.fieldid=b.id and b.type=c.id and b.fieldhtmltype=3 and a.ispreadd='1' and a.workflowid="+wfid;//xwj for td3130 20051122
			    if(nodeid!=0)
						operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
					else if(linkid!=0)
						operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";
			    operateSel = operateSel + " union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.fielddbtype,b.type,c.tablename,c.columname,c.keycolumname from workflow_addinoperate a ,workflow_formdictdetail b,workflow_browserurl c where a.fieldid=b.id and b.type=c.id and b.fieldhtmltype=3 and a.ispreadd='1' and a.workflowid="+wfid;
			}else if(isbill.equals("1")){
			    operateSel = "select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.fielddbtype,b.type,c.tablename,c.columname,c.keycolumname from workflow_addinoperate a ,workflow_billfield b,workflow_browserurl c where a.fieldid=b.id and b.type=c.id and b.fieldhtmltype=3 and a.ispreadd='1'";//xwj for td3130 20051122
			}
			
			if(nodeid!=0)
				operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
			else if(linkid!=0)
				operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";
			
			//add by xhheng @20050311 for TD 1708,组合查询，保证workflow_formdict fieldhtmltype<>3时，数据返回正常
			if(isbill.equals("0")){
			    operateSel = operateSel+" union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.fielddbtype,b.type,'','','' from workflow_addinoperate a ,workflow_formdict b where a.fieldid=b.id and b.fieldhtmltype<>3  and a.ispreadd='1' and a.workflowid="+wfid;//xwj for td3130 20051122
			    if(nodeid!=0)
						operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
					else if(linkid!=0)
						operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";
			    operateSel = operateSel+" union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.fielddbtype,b.type,'','','' from workflow_addinoperate a ,workflow_formdictdetail b where a.fieldid=b.id and b.fieldhtmltype<>3  and a.ispreadd='1' and a.workflowid="+wfid;
			}else if(isbill.equals("1")){
			    operateSel = operateSel+"union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.fielddbtype,b.type,'','','' from workflow_addinoperate a ,workflow_billfield b where a.fieldid=b.id and b.fieldhtmltype<>3 and a.ispreadd='1'";//xwj for td3130 20051122
			}
			
			if(nodeid!=0)
				operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
			else if(linkid!=0)
				operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";
			
			//add by xhheng @20050206 for TD 1535,将附加条件查询改为union查询，添加临时变量部分查询

			if(isbill.equals("0")){
			    operateSel = operateSel + " union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,'0','',0,'','','' from workflow_addinoperate a ";
			}else if(isbill.equals("1")){
			    operateSel = operateSel + " union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,'0','',0,'','','' from workflow_addinoperate a ";
			}
			
			if(nodeid!=0)
				RecordSet.executeSql(operateSel+" where a.objid="+nodeid+" and a.fieldid<0 and isnode =1 and a.ispreadd='1'");//xwj for td3130 20051122
			else if(linkid!=0)
				RecordSet.executeSql(operateSel+" where a.objid="+linkid+" and a.fieldid<0 and isnode =0 and a.ispreadd='1'");//xwj for td3130 20051122
			
			//System.out.println("@@@@@"+operateSel+" where a.objid="+linkid+" and a.fieldid<0 and isnode =0 and a.ispreadd='1'");
			int linecolor=0;
			while(RecordSet.next()){
			    hascon = true;
				int tmpid = RecordSet.getInt("id");
				int tmpfieldid = RecordSet.getInt("fieldid");
				int tmpfield1id = RecordSet.getInt("fieldop1id");
				int tmpfield2id = RecordSet.getInt("fieldop2id");
				int tmpoperation = RecordSet.getInt("operation");
				String tmpcustomervalue = RecordSet.getString("customervalue");
				String fielddbtype = RecordSet.getString("fielddbtype");
			    //System.out.println("tmpcustomervalue:"+tmpcustomervalue);
			    int tmprules = RecordSet.getInt("rules");
			  	int addintype= RecordSet.getInt("addintype");
			
			    int htmltype = RecordSet.getInt("fieldhtmltype");
			    int type = RecordSet.getInt("type");
			
			    String tablename = RecordSet.getString("tablename");
			    String columname = RecordSet.getString("columname");
			    String keycolumname = RecordSet.getString("keycolumname");
			    
				String expression="";
				String addrules = "";
			
				//把数据库中的数据转换成表达式
				if(!tmpcustomervalue.equals("")){
			    //普通的节点、出口附加操作

			    if(addintype==0){
			        if(htmltype==3&&type!=19 && type!=2&&type!=162&&type!=161&&type!=141&& type!=256&& type!=257){
			        	String[] tempArray = Util.TokenizerString2(tmpcustomervalue,",");
			        	 if("hrmdepartment".equals(tablename.toLowerCase())){
						    	tablename = "HrmDepartmentAllView";
						 }
			        	 if("hrmsubcompany".equals(tablename.toLowerCase())){
						    	tablename = "HrmSubCompanyAllView";
						 }
			        	for(int i=0;i<tempArray.length;i++){
			        		//zzl
			        	 if(htmltype==3&&(type==224||type==225||type==226||type==227)){
			            		expression=tempArray[i];
			            		continue;
						}
			        		
			            String bsql = "select "+columname+" from "+tablename+" where "+keycolumname+" = '"+tempArray[i]+"'";
			            //System.out.println("bsql = " + bsql);
			            RecordSet2.executeSql(bsql);
			            while(RecordSet2.next()){
			                //expression += ","+RecordSet2.getString(columname);
			                expression += ","+RecordSet2.getString(1);//update by fanggsh 20060804 for  浏览框类型为部门时出错

			            }
			          }
			          	//zzl
			            if(!expression.equals("")&&type!=224&&type!=225&&type!=226&&type!=227){
			                expression = expression.substring(1);
			            }
			                }else if(htmltype==3&&type==161){
			        	String tempdbtype = (String)fielddbtypes.get(fieldids.indexOf(""+tmpfieldid));
						try{
				            Browser browser=(Browser)StaticObj.getServiceByFullname(tempdbtype, Browser.class);
				            BrowserBean bb=browser.searchById(tmpcustomervalue);
							String desc=Util.null2String(bb.getDescription());
							String name=Util.null2String(bb.getName());
							expression=name;
						}catch(Exception e){
						}			
					}else if(htmltype==3&&type==162){
			        	String tempdbtype = (String)fielddbtypes.get(fieldids.indexOf(""+tmpfieldid));
			        	try{
				            Browser browser=(Browser)StaticObj.getServiceByFullname(tempdbtype, Browser.class);
							List l=Util.TokenizerString(tmpcustomervalue,",");
				            for(int j=0;j<l.size();j++){
							    String curid=(String)l.get(j);
					            BrowserBean bb=browser.searchById(curid);
								String desc=Util.null2String(bb.getDescription());
								String name=Util.null2String(bb.getName());
							    expression+=","+name;
							}
						}catch(Exception e){
						}        		
						if(!"".equals(expression)) expression = expression.substring(1);
			        }else if(htmltype==3&&type==141){
			            expression =  ResourceConditionManager.getFormShowName(tmpcustomervalue,user.getLanguage());
			        }else if(htmltype==3 && (type==256 || type==257)){
			        	CustomTreeUtil customTreeUtil = new CustomTreeUtil();
			        	expression = customTreeUtil.getTreeFieldShowName(tmpcustomervalue,fielddbtype);
			        }else{
			            expression =  tmpcustomervalue ;
			        }
			    }
			    //附件上传，文档属性

			    if(addintype==1){
			      expression = SystemEnv.getHtmlLabelName(129501, user.getLanguage()) +"：" + SystemEnv.getHtmlLabelName(19544, user.getLanguage());
			      if(tmpcustomervalue.equals("0"))
			        expression += " ("+SystemEnv.getHtmlLabelName(220,user.getLanguage())+")";
			      if(tmpcustomervalue.equals("2"))
			        expression += " ("+SystemEnv.getHtmlLabelName(225,user.getLanguage())+")";
			      if(tmpcustomervalue.equals("3"))
			        expression += " ("+SystemEnv.getHtmlLabelName(360,user.getLanguage())+")";
			      if(tmpcustomervalue.equals("4"))
			        expression += " ("+SystemEnv.getHtmlLabelName(236,user.getLanguage())+")";
			      if(tmpcustomervalue.equals("5"))
			        expression += " ("+SystemEnv.getHtmlLabelName(251,user.getLanguage())+")";
			    }
			  }
				else {
			    //公式 第一操作值

					if(tmpfield1id == -1){
						expression = SystemEnv.getHtmlLabelName(15625,user.getLanguage()) ;
					}else if(tmpfield1id == -2){
						expression =  SystemEnv.getHtmlLabelName(15626,user.getLanguage()) ;
					}else if(tmpfield1id == -3){
						expression =  SystemEnv.getHtmlLabelName(15080,user.getLanguage()) ;
					}else if(tmpfield1id == -4){
						expression =  SystemEnv.getHtmlLabelName(15576,user.getLanguage()) ;
					}else if(tmpfield1id == -5){
						expression =  SystemEnv.getHtmlLabelName(22665,user.getLanguage()) ;
					}else if(tmpfield1id == -6){
						expression =  SystemEnv.getHtmlLabelName(15081,user.getLanguage()) ;
					}else if(tmpfield1id == -7){
						expression =  SystemEnv.getHtmlLabelName(22666,user.getLanguage()) ;
					}else if(tmpfield1id == -8){
						expression =  SystemEnv.getHtmlLabelName(22667,user.getLanguage()) ;
					}else if(tmpfield1id == -9){
						expression =  SystemEnv.getHtmlLabelName(22668,user.getLanguage()) ;
					}else if(tmpfield1id == -10){
						expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1" ;
					}else if(tmpfield1id == -11){
						expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2" ;
					}else if(tmpfield1id == -12){
						expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3" ;
					}else if(tmpfield1id == -13){
						expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1" ;
					}else if(tmpfield1id == -14){
						expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2" ;
					}else if(tmpfield1id == -15){
						expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3" ;
					}else if(tmpfield1id == -16){
						expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1" ;
					}else if(tmpfield1id == -17){
						expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2" ;
					}else if(tmpfield1id == -18){
						expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3" ;
					}else if(tmpfield1id == -19){
						expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1" ;
					}else if(tmpfield1id == -20){
						expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2" ;
					}else if(tmpfield1id == -21){
						expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3" ;
					}else if(tmpfield1id == -22){
						expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1" ;
					}else if(tmpfield1id == -23){
						expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2" ;
					}else if(tmpfield1id == -24){
						expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3" ;
					}else if(tmpfield1id == -25){
						expression =  SystemEnv.getHtmlLabelName(22692,user.getLanguage())+"" ;
					}else{
					  if(tmpfield1id == 0){//xwj for td3308 on 20051212
						expression = "" ;
					  }
					  else{
					  expression = ""+fieldlabels.get(fieldids.indexOf(""+tmpfield1id));
					  }
					}
			    //公式 操作符

					if(tmpoperation!=0){
						if(tmpoperation==1){
							expression += " + ";
						}else if(tmpoperation==2){
							expression += " - ";
						}else if(tmpoperation==3){
							expression += " * ";
						}else if(tmpoperation==4){
							expression += " / ";
						}
			      //公式 第二操作符

						if(tmpfield2id == -10){
							expression +=  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1" ;
						}else if(tmpfield2id == -11){
							expression +=  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2" ;
						}else if(tmpfield2id == -12){
							expression +=  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3" ;
						}else if(tmpfield2id == -13){
							expression +=  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1" ;
						}else if(tmpfield2id == -14){
							expression +=  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2" ;
						}else if(tmpfield2id == -15){
							expression +=  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3" ;
						}else if(tmpfield2id == -16){
							expression +=  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1" ;
						}else if(tmpfield2id == -17){
							expression +=  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2" ;
						}else if(tmpfield2id == -18){
							expression +=  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3" ;
						}else if(tmpfield2id == -19){
							expression +=  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1" ;
						}else if(tmpfield2id == -20){
							expression +=  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2" ;
						}else if(tmpfield2id == -21){
							expression +=  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3" ;
						}else if(tmpfield2id == -22){
							expression +=  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1" ;
						}else if(tmpfield2id == -23){
							expression +=  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2" ;
						}else if(tmpfield2id == -24){
							expression +=  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3" ;
						}else{
							expression += ""+fieldlabels.get(fieldids.indexOf(""+tmpfield2id));
						}
					}
				}
			  //公式 目标值

				if(!expression.equals("") || (expression.equals("") && tmpfield1id == 0)){//xwj for td3308 on 20051212
					if(tmpfieldid == -10){
						expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1 = "+expression;
					}else if(tmpfieldid == -11){
						expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2 = "+expression;
					}else if(tmpfieldid == -12){
						expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3 = "+expression;
					}else if(tmpfieldid == -13){
						expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1 = "+expression;
					}else if(tmpfieldid == -14){
						expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2 = "+expression;
					}else if(tmpfieldid == -15){
						expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3 = "+expression;
					}else if(tmpfieldid == -16){
						expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1 = "+expression;
					}else if(tmpfieldid == -17){
						expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2 = "+expression;
					}else if(tmpfieldid == -18){
						expression = SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3 = "+expression;
					}else if(tmpfieldid == -19){
						expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1 = "+expression;
					}else if(tmpfieldid == -20){
						expression = SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2 = "+expression;
					}else if(tmpfieldid == -21){
						expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3 = "+expression;
					}else if(tmpfieldid == -22){
						expression = SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1 = "+expression;
					}else if(tmpfieldid == -23){
						expression = SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2 = "+expression;
					}else if(tmpfieldid == -24){
						expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3 = "+expression;
					}else{
						if(fieldids.indexOf(""+tmpfieldid)!=-1)
						  expression =""+fieldlabels.get(fieldids.indexOf(""+tmpfieldid))+" = "+expression;
					}
				}
			
				if((tmprules & 1) ==1)
					addrules += SystemEnv.getHtmlLabelName(15638,user.getLanguage()) ;
				if((tmprules & 2) ==2)
					addrules += SystemEnv.getHtmlLabelName(15639,user.getLanguage()) ;		
				
			%>
				<tr>
					<td><input type='checkbox' name='check_node' value="<%=tmpid%>" ></td>
					<td><%=expression%></td>
					<td>
					<%=addrules%>
					</td>
				</tr>
			<%
			if(linecolor==0) linecolor=1;
			          else linecolor=0;
			}%>
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>	
<%if(istemplate!=1&&(isDmlAction || isWsAction || isSapAction)){%>	
<jsp:include page="/workflow/action/WorkflowActionEditSetSimple.jsp">
	<jsp:param name="workflowid" value="<%=wfid%>" />
	<jsp:param name="nodeid" value="<%=nodeid%>" />
	<jsp:param name="ispreoperator" value="1" />
	<jsp:param name="nodelinkid" value="<%=linkid %>" />
	<jsp:param name="fromintegration" value="1" />
</jsp:include>
<%} %>
</form>
</div>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);
	$(document).ready(function(){
  		resizeDialog(document);
	});
</script>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWindow(1);">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<script language=javascript>
var urls = new Array();
var isCustomer = false;
var isOtherProperty = false;
var curIndex = 0;
var curfieldid=0;
var curisdetail=0;
<%
    String browserSql = "select * from workflow_browserurl order by id desc";
    String idStr = "";
    String urlStr = "";
    RecordSet.executeSql(browserSql);
    while(RecordSet.next()){
%>
        //urls[<%=Util.getIntValue(RecordSet.getString("id"),0)%>] = "<%=RecordSet.getString("browserurl")%>";
		//获取url需要从BrowserComInfo中来获取，不能直接查询，被安全拦截
		urls[<%=Util.getIntValue(RecordSet.getString("id"),0)%>] = "<%=bci.getBrowserurl(RecordSet.getString("id"))%>";
<%
    }
%>






operList = window.document.forms[0].operation;
op2List = window.document.forms[0].fieldop2id;
op1List = window.document.forms[0].fieldop1id;
objList = window.document.forms[0].fieldid;
var tempbrowsertype = "";

function changefieldid(objvalue){
	
	var _objvalue = objvalue.substring(0,objvalue.lastIndexOf("_"));
	try{
		tempbrowsertype = eval("urlvalue._"+_objvalue);
	}catch(e){
		tempbrowsertype = "";
	}

    curisdetail=objvalue.substring(0,objvalue.indexOf("_"));
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    curfieldid=objvalue.substring(0,objvalue.indexOf("_"));
    document.all("fieldop1idvalue").value=""
    document.all("unitspan").innerHTML="";
    //单选框
    $GetEle("singlespan").innerHTML="";

	if(document.all("fieldop1id").value==0){
		alert("<%=SystemEnv.getHtmlLabelName(15640,user.getLanguage())%>!");
		document.all("fieldid").value=0;
	}


    if(isCustomer){
        operList.style.display='none';
		    op2List.style.display='none';
        if((objvalue!="0") && objvalue.indexOf("_3_")!=-1 && (objvalue.indexOf("_3_19")==-1 || objvalue.indexOf("_3_194")!=-1) && objvalue.indexOf("_1_3")==-1){
            //alert(objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length));
            temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
            curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
            document.all("fieldBrowser").style.display='';
            document.all("fieldop1idvalue").style.display='none';
            //document.all("fieldop1id").style.width='100%';

        }else{
            //operList.style.display='';
            //op2List.style.display='';
            document.all("fieldBrowser").style.display='none';
            document.all("fieldop1idvalue").style.display='';
            //document.all("fieldop1id").style.width='50%';
        }
    }

  objvalue = document.all("fieldid").value;
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    //htmltype = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
	//type = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);
    indexFirst=objvalue.indexOf("_");
    indexSecond=objvalue.indexOf("_",indexFirst+1);
	indexThird=objvalue.indexOf("_",indexSecond+1);
    
	htmltype=objvalue.substring(indexFirst+1,indexSecond);
	type=objvalue.substring(indexSecond+1,indexThird);
  if(isOtherProperty && htmltype=="6") {
    document.all("otherPropertyName").style.display='';
    document.all("otherProperty6Value").style.display='';
  }

	for(i = op1List.length-1; i >= 0; i--) {
		if (op1List.options[i] != null){
			op1List.options[i] = null;
		}
	}
	//增加必有的自定义值选项（15632）

	op1List.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(15632,user.getLanguage())%>','customervalue');
	if(htmltype==3){
	    //只显示多选浏览框
	    $("#unitSelect").css("display","block");
        $("#singleSelect").css("display","none");
		if(type==17||type==166){//多人力资源、分权多人力资源--创建人经理、创建人下属、操作人经理、操作人下属
			op1List.options[1] = new Option("<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>",'0_-3_3_1');
			op1List.options[2] = new Option("<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>",'0_-4_3_17');
			op1List.options[3] = new Option("<%=SystemEnv.getHtmlLabelName(22665,user.getLanguage())%>",'0_-5_3_1');
			op1List.options[4] = new Option("<%=SystemEnv.getHtmlLabelName(22692,user.getLanguage())%>",'0_-25_3_1');
		}else if(type==1||type==165){//人力资源、分权单人力资源--创建人经理、操作人经理
			op1List.options[1] = new Option("<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>",'0_-3_3_1');
			op1List.options[2] = new Option("<%=SystemEnv.getHtmlLabelName(22665,user.getLanguage())%>",'0_-5_3_1');
			//只显示单选浏览框
	        $("#unitSelect").css("display","none");
	        $("#singleSelect").css("display","block");
		}else if(type==4||type==167){//部门、分权单部门--创建人（操作人）本部门、上级部门

			op1List.options[1] = new Option("<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>",'0_-6_3_1');
			op1List.options[2] = new Option("<%=SystemEnv.getHtmlLabelName(22666,user.getLanguage())%>",'0_-7_3_1');
			op1List.options[3] = new Option("<%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%>",'0_-8_3_1');
			op1List.options[4] = new Option("<%=SystemEnv.getHtmlLabelName(22668,user.getLanguage())%>",'0_-9_3_1');
		}else if(type==24){
			$("#unitSelect").css("display","none");
	        $("#singleSelect").css("display","block");
		}
	}
	jQuery("#fieldop1id").selectbox("detach")
	__jNiceNamespace__.beautySelect("#fieldop1id")
}

function changefieldop1id(){
	
	objvalue = document.all("fieldid").value;
    curisdetail=objvalue.substring(0,objvalue.indexOf("_"));
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    curfieldid=objvalue.substring(0,objvalue.indexOf("_"));


	fieldop1id = document.all("fieldop1id").value;
	if(fieldop1id=="customervalue"){
        if(isCustomer){
            operList.style.display='none';
		    op2List.style.display='none';
            if((objvalue!="0") && objvalue.indexOf("_3_")!=-1 && objvalue.indexOf("_3_19")==-1 && objvalue.indexOf("_1_3")==-1){
                temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
                curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
                document.all("fieldBrowser").style.display='';
                document.all("fieldop1idvalue").style.display='none';
            }else{
                document.all("fieldBrowser").style.display='none';
                document.all("fieldop1idvalue").style.display='';
            }
        }
	}else{
		document.all("fieldBrowser").style.display='none';
		document.all("fieldop1idvalue").style.display='none';
	}


}

var objvalue="customervalue";
    document.all("fieldop1idvalue").value=""
	document.all("fieldop1idvalue").style.display='none';
	document.all("fieldBrowser").style.display='none';
	/*document.all("fieldop1id").style.width='100%';*/
	oDateRuleTr.style.display='none';

  var i=0;
	for(i = operList.length-1; i >= 0; i--) {
		if (operList.options[i] != null){
			operList.options[i] = null;
		}
	}

	for(i = op2List.length-1; i >= 0; i--) {
		if (op2List.options[i] != null){
			op2List.options[i] = null;
		}
	}

	for(i = objList.length-1; i >= 0; i--) {
		if (objList.options[i] != null){
			objList.options[i] = null;
		}
	}
	i=0;
	<%=objOptions%>


        isCustomer = true;
        isOtherProperty=false;
        operList.style.display='none';
		    op2List.style.display='none';
        document.all("otherPropertyName").style.display='none';
        document.all("otherProperty6Value").style.display='none';
		    document.all("fieldop1idvalue").style.display='';
		    operList.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%>','0');
		    op2List.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(15619,user.getLanguage())%>','0');



	id = objvalue.substring(0,objvalue.indexOf("_"));
	htmltype = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
	type = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);



	i=0;
	<%=operOptions%>

	i=0;
	<%=op2Options%>


	if((htmltype=="1" && type=="1") || htmltype=="2"){
	//	alert("文本");
		for(var i = operList.length-1; i >= 0; i--) {
			if (operList.options[i] != null){
				tmpvalue = operList.options[i].value;
				if((tmpvalue!="1")&& (tmpvalue!="0")){
					operList.options[i] = null;
				}
			}
		}
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_1")==-1 && tmpvalue.indexOf("_2_0")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_1")==-1 && tmpvalue.indexOf("_2_0")==-1){
					objList.options[i] = null;
				}
			}
		}

	}else if((htmltype=="1" && type=="2") || (htmltype=="1" && type=="3") ){
	//	alert("整数");
	//	alert("浮点数");
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_1_3")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_1_3")==-1){
					objList.options[i] = null;
				}
			}
		}

	}else if(htmltype=="3" && type=="2"){
	//	alert("日期");
		oDateRuleTr.style.display='';
		for(var i = operList.length-1; i >= 0; i--) {
			if (operList.options[i] != null){
				tmpvalue = operList.options[i].value;
				if((tmpvalue!="1")&& (tmpvalue!="0")&& (tmpvalue!="2")){
					operList.options[i] = null;
				}
			}
		}
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_3_2")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_3_2")==-1){
					objList.options[i] = null;
				}
			}
		}

	}else if(htmltype=="3" && type=="19"){
	//	alert("时间");
		for(var i = operList.length-1; i >= 0; i--) {
			if (operList.options[i] != null){
				tmpvalue = operList.options[i].value;
				if((tmpvalue!="1")&& (tmpvalue!="0")&& (tmpvalue!="2")){
					operList.options[i] = null;
				}
			}
		}
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_3")==-1 && tmpvalue.indexOf("_3_19")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_3")==-1 && tmpvalue.indexOf("_3_19")==-1){
					objList.options[i] = null;
				}
			}
		}
	}else if(htmltype=="6" ){
    alert("<%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%>：========== objvalue ==== "+objvalue);
  }



function addAction()
{
	var cl = jQuery("#oTable1").find("tbody").children().length;
	if(cl>1){
        setPreSpanInner('<%=nodeid %>','1','ischeck');
    }else{
        setPreSpanInner('<%=nodeid %>','0','ischeck');
    }
	var needcheck = "actionname,workflowid,interfaceid,actionorder";
    if(check_form(SearchForm,needcheck)){
        document.all("src").value="addaction";
		document.SearchForm.submit();
    }
}
function onSave(){
	if(objList.value=="0"){
    alert("<%=SystemEnv.getHtmlLabelName(15642,user.getLanguage())%>!");
    return;
	}else if(isCustomer&&document.all("fieldop1idvalue").value==""){
    //alert("自定义值不能为空"); //xwj for td3308 on 20051212
    //return;
  }

  //排除'文档上传'外的其他字段保存'其他属性'
  objvalue = document.all("fieldid").value;
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    htmltype = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
	type = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);
  if(isOtherProperty && htmltype!="6"){
    alert("<%=SystemEnv.getHtmlLabelName(19562,user.getLanguage())%>")
    return;
  }

	if(op1List.value=="customervalue"){
		tmpvalue = document.all("fieldop1idvalue").value;

		objvalue = objList.value.substring(objvalue.indexOf("_")+1);
		id = objvalue.substring(0,objvalue.indexOf("_"));
		temp = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
		htmltype = temp.substring(0,temp.indexOf("_"));
		type = temp.substring(temp.lastIndexOf("_")+1,temp.length);
		
		lens = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);

		if(htmltype ==1 && type==1 && lens != -1){
			len1 = realLength(tmpvalue);
			if(lens<len1){
				alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>"+lens+"(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
				return;
			}
		}else if((htmltype ==1 && type==2)){
			if(checkInt(tmpvalue)){
				alert("<%=SystemEnv.getHtmlLabelName(15643,user.getLanguage())%>!");
				return;
			}
		}else if((htmltype ==1 && type==3)){
			if(checkFloat(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15644,user.getLanguage())%>!");
				return;
			}
		}else if((htmltype ==1 && type==5)){
			if(checkFloat(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15644,user.getLanguage())%>!");
				return;
			}
			changeToThousands("fieldop1idvalue");
		}else if((htmltype ==3 && type==2)){
			if(checkDate(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15645,user.getLanguage())%>!");
				return;
			}
		}else if((htmltype ==3 && type==19)){
			if(checkTime(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15646,user.getLanguage())%>!");
				return;
			}
		}
	}
    document.all("src").value="add";
	document.SearchForm.submit();
}
function checkInt(objval)
{
    if(objval.indexOf("-") == 0 && objval.length >= 2){
        objval = objval.substring(1);
    }
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	return isnumber;
}
function checkFloat(objval)
{
    if(objval.indexOf("-") == 0 && objval.length >= 2){
        objval = objval.substring(1);
    }
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	return isnumber;
}
function checkTime(objval)
{
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	return isnumber;
}
function checkDate(objval)
{
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!="-") isnumber = true ;}
	return isnumber;
}
function onDelete(){
	document.all("src").value="delete";
	document.SearchForm.submit();
}

function closeWindow(from){
	var rowid = <%=linkid%>;
    var cl = jQuery("#oTable2").find("tbody").children().length;
    if(0 == rowid){
        rowid = <%=nodeid%>
        cl = jQuery("#oTable1").find("tbody").children().length;
    }
    var hascon = '<%=hascon?"1":"0" %>';
    
	if($G("src").value!=""){
		return;
	}
	var design="<%=design %>";
	if(design=='1'){	//图形化工具打开
		parentWin.design_callback('showpreaddinoperate_<%if(linkid>0) {out.print("link");}else{out.print("node");}%>','<%=hascon%>');
	}else{
	    <%if(linkid>0){%>
	        if(cl>1||hascon==1){
		        setPreSpanInner(rowid,'1','ischeckpre');
		    }else{
		        setPreSpanInner(rowid,'0','ischeckpre');
		    }
	    <%}else{%>
	    	if(cl>1||hascon==1){
		        setPreSpanInner(rowid,'1','ischeckpre');
		    }else{
		        setPreSpanInner(rowid,'0','ischeckpre');
		    }
	    <%}%>
	}
	if(from==1)
		dialog.close();
}

function editAction(actionid, actiontype_)
{
	var addurl = "";
	if(actiontype_ == 0){
		addurl = "/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+"&workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1";
	}else if(actiontype_ == 1){
		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/WsActionEditSet.jsp?actionid="+actionid+"&operate=editws&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	}else if(actiontype_ == 2){
		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/SapActionEditSet.jsp?actionid="+actionid+"&operate=editsap&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	}
	var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
}

//zzl
function addRowEcology7()
{
	var args="?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1&workflowid=<%=wfid%>&w_type=1";
	var addurl="/integration/browse/integrationBrowerMain.jsp"+args;
	var id_t = window.showModalDialog(addurl,"","dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
	//如何刷新页面
	//if(id_t)
	//{
		$G("src").value="refush";
		document.SearchForm.submit();//新建的时候刷新节点后保存界面
	//}
}
function seeRowEcology7(mark)
{
	
	var args="?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1&workflowid=<%=wfid%>&w_type=1&mark="+mark+"";
	var addurl="/integration/browse/integrationBrowerMain.jsp"+args;
	var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
}
function checkecology7(obj)
{
	$("#ecology70 tr td [type=checkbox][name=baseInfobox]").each(function(){
			var flag=obj.checked;
			$(this).attr('checked',flag);
	});
	
}

function addRow()
{
	var addurl = "";
	var actionlist_t = document.getElementById("actionlist").value;
	if(actionlist_t == 1){
		addurl = "/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/DMLActionSettingAdd.jsp?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1";
	}else if(actionlist_t == 2){
		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/WsActionEditSet.jsp?operate=addws&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	}else if(actionlist_t == 3){
	
	    <%
	    	if(idHideOldSapNode.equals("0")){
	    		//老版本的sap功能
	    %>
	    		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/SapActionEditSet.jsp?operate=adsap&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	    <%
	    		
	    	}else{
	    		//新版本的sap功能
	    %>
	    		//zzl
				var args="?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1&workflowid=<%=wfid%>&w_type=1";
			    addurl="/integration/browse/integrationBrowerMain.jsp"+args;
	    <%
	    	}
	    %>
		
	}
	
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = addurl;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>";
	dialog.Width = 1000 ;
	dialog.Height = 800 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
	
	//var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
}
function delRow()
{
	var hasselected = false;
	var dmlids = document.getElementsByName("dmlid");
	
	//zzl
	var dmlidnewsaps = document.getElementsByName("dmlidnewsap");
	
	if(dmlids&&dmlids.length>0)
	{
		for(var i = 0;i<dmlids.length;i++)
		{
			var dmlid = dmlids[i];
			if(dmlid.checked)
			{
				hasselected = true;
				break;
			}
		}
	}
	
	//zzl
	if(dmlidnewsaps&&dmlidnewsaps.length>0)
	{
		for(var i = 0;i<dmlidnewsaps.length;i++)
		{
			var dmlidnewsap = dmlidnewsaps[i];
			if(dmlidnewsap.checked)
			{
				hasselected = true;
				break;
			}
		}
	}
	
	if(!hasselected)
	{
		//请先选择需要删除的数据
		alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>!");
		return;
	}
	if (isdel())
	{
		$G("src").value="deletedmlaction";
	    document.SearchForm.submit();
	}
}
function reloadDMLAtion()
{
	//alert("ddddd");
	$G("src").value = "savebaseaction";
	//alert(document.SearchForm.action)
	document.SearchForm.submit();
}
</script>

<script language="javascript">
function submitData()
{
	if (confirmdel())
		form2.submit();
}

function submitClear()
{
	//TD24113:修正设置节点附加前操作时未选择数据点击删除时提示信息错误的问题 ADD BY QB START
	var isChecked = false;
	for(var i=0;i<document.getElementsByName("check_node").length;i++){
		if (document.getElementsByName("check_node")[i].checked) {
			isChecked = true;
			break;
		}
	}

	if (isChecked) {
		if (isdel()){
			onDelete();
		}
	} else {
			alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		}
	
	
	//if (isdel()){
	//		onDelete();
	//	}
	//TD24113:修正设置节点附加前操作时未选择数据点击删除时提示信息错误的问题 ADD BY QB END
}
function setPreSpanInner(row,hascon,pre)
	{
		if(hascon=="1"){
    		jQuery("div[_id='"+row+"']").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
   		}else{
    		jQuery("div[_id='"+row+"']").innerHTML="";
		}
	}

function checkInterface(){
	if(document.all("enableInterface").checked){
     document.all("src").value="addInterface";
	  document.SearchForm.submit();
	}else{
     document.all("src").value="delInterface";
	  document.SearchForm.submit();
	}

}
function onSelectInterface(){

    if(document.all("interface").value=="none"){
     document.all("enableInterface").style.display="none";

	}else{

     document.all("enableInterface").style.display="";
	}

}

function changeproperty(){
	jQuery("#fieldop1idvalue").val(jQuery("input[name=unit]").val());
}
function changepropertySingle(){
    jQuery("input[name=unit]").val(jQuery("#singleSelect").find(".e8_delClass").attr("id"));
    jQuery("#fieldop1idvalue").val(jQuery("input[name=unit]").val());
}

function showPreDBrowser(url,objtype){
	if(objtype == 2 || objtype == 19){
    WdatePicker({el:'unitspan',onpicked:function(dp){
			$dp.$('fieldop1idvalue').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('fieldop1idvalue').value = ''}});
   }else{
     if(objtype=="161"||objtype=="162")
		url = url + "?type="+tempbrowsertype+"%26isreport=1" + "%26selectedids="+$G("fieldop1idvalue").value;//QC287119 [80][90]数据展现集成-流程节点前附加操作中字段赋值为列表多选，选择数据后再次打开已选的数据未被选中
		
	if(objtype=="224"||objtype=="225"){
		var  sapfieldid=$("#fieldid").val();
		url+=saphashmap.get(sapfieldid.split("_")[1])+"&fromNode=1&fromNodeFormid=<%=formid%>&fromNodeWfid=<%=wfid%>&fromReportisbill=<%=isbill%>";
	}else if(objtype=="226"||objtype=="227"){
		var  sapfieldid=$("#fieldid").val();
		url+=saphashmap.get(sapfieldid.split("_")[1])+"&fromNode=1";
	}else if(objtype=="256"||objtype=="257"){
		var  sapfieldid=$("#fieldid").val();
		var treefield = saphashmap.get(sapfieldid.split("_")[1]);
		url = url + treefield.split("|")[0]+"_"+objtype;
	}
	 if(objtype=="141"){
	 	onShowResourceConditionBrowser();
	 }else{
     	onShowBrowser(url,objtype);
	 }
   }
}
function uescape(url){
    return escape(url);
}
function onShowBrowser(url,objtype){
	// 270为系统表单--会议审批单
    if (objtype!="161" && objtype!="162"&& objtype!="224"&& objtype!="225"&&objtype!="226"&& objtype!="227"&& objtype!="34" && objtype!="256" && objtype!="257" && objtype!="270") {
		url = url+"?selectedids="+$G("fieldop1idvalue").value;
	}
	if (objtype==165 || objtype==166 || objtype==167 || objtype==168) {
		temp=uescape("&fieldid="+curfieldid+"&isdetail="+curisdetail);
		url = url+temp;
	}
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, datas) {
		if (!!datas) {
            $G("fieldop1idvalue").value = datas.id;
          //单选浏览按钮时
		  if(objtype==1||objtype==165||objtype==24){
            $GetEle("singlespan").innerHTML = "<a href='#1' >"+datas.name+"</a>";
		  }else{
            unitspan.innerHTML ="<a href='#1' >"+datas.name+"</a>";
		  }
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 600 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){
  		dialog.Width=648;
  	}
	if(url.indexOf("/MultiRequestBrowser.jsp")!=-1||url.indexOf("/MultiRequestedBrowser.jsp")!=-1){
		if(jQuery.browser.msie){
			dialog.Height = 570;
		}else{
			dialog.Height = 570;
		}
	}else if(url.indexOf("/MutiCustomerBrowser.jsp")!=-1){
		if(jQuery.browser.msie){
			dialog.Height = 640;
		}else{
			dialog.Height = 630;
		}
	}

	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
    /*
	if (objtype!="161" && objtype!="162"&& objtype!="224"&& objtype!="225"&&objtype!="226"&& objtype!="227") {
		url= url+"?selectedids="+$G("fieldop1idvalue").value;
	}
    if (objtype==165 || objtype==166 || objtype==167 || objtype==168) {
        temp=uescape("&fieldid="+curfieldid+"&isdetail="+curisdetail);
        myid = window.showModalDialog(url+temp);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != ""){
                unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,1).substr(0,1)==",") {
                    $G("fieldop1idvalue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML ="<a href='#1' >"+wuiUtil.getJsonValueByIndex(myid,1).substr(1)+"</a>";
                }else{
                    $G("fieldop1idvalue").value =wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML ="<a href='#1' >"+ wuiUtil.getJsonValueByIndex(myid,1)+"</a>";
                }
            }else{
                unitspan.innerHTML = ""
                $G("fieldop1idvalue").value = ""
            }
        }
    }else{
        myid = window.showModalDialog(url);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
                unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
                    $G("fieldop1idvalue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML ="<a href='#1' >"+wuiUtil.getJsonValueByIndex(myid,1).substr(1)+"</a>";
                }else{
                    $G("fieldop1idvalue").value = wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML ="<a href='#1' >"+wuiUtil.getJsonValueByIndex(myid,1)+"</a>";
                }
            }else{
                unitspan.innerHTML = ""
                $G("fieldop1idvalue").value = ""
            }
        }
    }
    */
}



</script>

<script language="vbscript">
sub onShowBrowser1(url,objtype)
	if objtype<>"161" and objtype<>"162"  and objtype<>"226" and objtype<>"227"  then
		url= url&"?selectedids="&document.all("fieldop1idvalue").value
	end if
    if objtype=165 or objtype=166 or objtype=167 or objtype=168 then
        temp=uescape("&fieldid="&curfieldid&"&isdetail="&curisdetail)
        myid = window.showModalDialog(url&temp)
        if (Not IsEmpty(myid)) then
            if myid(0)<> "" then
                unitspan.innerHtml = myid(1)
                'msgbox Left(myid(0),1)=","
                if Left(myid(0),1)="," then
                    document.all("fieldop1idvalue").value = Mid(myid(0),2,len(myid(0)))
                    unitspan.innerHtml = Mid(myid(1),2,len(myid(1)))
                else
                    document.all("fieldop1idvalue").value = myid(0)
                    unitspan.innerHtml = myid(1)
                end if
            else
                unitspan.innerHtml = ""
                document.all("fieldop1idvalue").value = ""
            end if
        end if
    else
        myid = window.showModalDialog(url)
        if (Not IsEmpty(myid)) then
            if myid(0)<> "" then
                unitspan.innerHtml = myid(1)
                'msgbox Left(myid(0),1)=","
                if Left(myid(0),1)="," then
                    document.all("fieldop1idvalue").value = Mid(myid(0),2,len(myid(0)))
                    unitspan.innerHtml = Mid(myid(1),2,len(myid(1)))
                else
                    document.all("fieldop1idvalue").value = myid(0)
                    unitspan.innerHtml = myid(1)
                end if
            else
                unitspan.innerHtml = ""
                document.all("fieldop1idvalue").value = ""
            end if
        end if
    end if
end sub

</script>

<script type="text/javascript">
function onShowResourceConditionBrowser() {
	//var dialogId = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp");

	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp";
	dialog.URL = url;

	dialog.callbackfun = function (paramobj, dialogId) {
	if (dialogId) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			shareTypeValues = shareTypeValues.substr(1);
			shareTypeTexts = shareTypeTexts.substr(1);
			relatedShareIdses = relatedShareIdses.substr(1);
			relatedShareNameses = relatedShareNameses.substr(1);
			rolelevelValues = rolelevelValues.substr(1);
			rolelevelTexts = rolelevelTexts.substr(1);
			secLevelValues = secLevelValues.substr(1);
			secLevelTexts = secLevelTexts.substr(1);

			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];

				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;

				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("fieldop1idvalue").value = fileIdValue;
			$GetEle("unitspan").innerHTML = sHtml;
		}
	} else {
		$GetEle("unitspan").innerHtml = "";
		$GetEle("fieldop1idvalue").value = "";
	}
	};
	dialog.show();
}
</script>

<!--
TD8698
褚俊	2008.05.09
流程节点及出口信息附加操作设置页面建议区分主字段和明细字段

实现在select以层显示被选中的option
-->
<script Language="JavaScript">
//***********默认设置定义.*********************
var tPopWait=50;//停留tWait豪秒后显示提示。

var tPopShow=5000;//显示tShow豪秒后关闭提示

var showPopStep=20;
var popOpacity=99;
//***************内部变量定义*****************
var sPop=null;
var curShow=null;
var tFadeOut=null;
var tFadeIn=null;
var tFadeWaiting=null;
document.write("<style   type='text/css'id='defaultPopStyle'>");
document.write(".cPopText   { background-color: #F8F8F5;color:#000000; border:1px #000000 solid;font-color: font-size:12px;   padding-right:   4px;   padding-left:   4px;   height:   20px;   padding-top:   2px;   padding-bottom:   2px;   filter:   Alpha(Opacity=0)}");
document.write("</style>");
document.write("<div   id='dypopLayer' style='position:absolute;z-index:1000;display:none' class='cPopText'></div>");

function showPopupText(){
	var o=event.srcElement;

	MouseX=event.x;
	MouseY=event.y;
	if(o.alt!=null && o.alt!=""){
		o.dypop=o.alt;
		o.alt="";
	}
	if(o.title!=null && o.title!=""){
		o.dypop=o.title;
		o.title="";
	}
	if(o.dypop!=sPop){
		sPop=o.dypop;
		clearTimeout(curShow);
		clearTimeout(tFadeOut);
		clearTimeout(tFadeIn);
		clearTimeout(tFadeWaiting);
		if(sPop==null || sPop==""){
			dypopLayer.innerHTML="";
			dypopLayer.style.filter="Alpha()";
            //dypopLayer.filter.Alpha.opacity=0;
			dypopLayer.filters.Alpha.opacity=0;
		}else{
			if(o.dyclass!=null){
				popStyle=o.dyclass;
			}else{
				popStyle="cPopText";
			}
			curShow=setTimeout("showIt()",tPopWait);
		}
	}
}

function showIt(){
	dypopLayer.className=popStyle;
	dypopLayer.innerHTML=sPop;
	popWidth=dypopLayer.clientWidth;
	popHeight=dypopLayer.clientHeight;
	if(MouseX+12+popWidth>document.body.clientWidth){
		popLeftAdjust=-popWidth-24;
	}else{
		popLeftAdjust=0;
	}
	if(MouseY+12+popHeight>document.body.clientHeight){
		popTopAdjust=-popHeight-24;
	}else{
		popTopAdjust=0;
	}
	dypopLayer.style.left=MouseX+12+document.body.scrollLeft+popLeftAdjust;
	dypopLayer.style.top=MouseY+12+document.body.scrollTop+popTopAdjust;
	dypopLayer.style.filter="Alpha(Opacity=0)";
	fadeOut();
}

function fadeOut(){
	if(dypopLayer.filters.Alpha.opacity<popOpacity){
	dypopLayer.filters.Alpha.opacity+=showPopStep;
	tFadeOut=setTimeout("fadeOut()",1);
	}else{
		dypopLayer.filters.Alpha.opacity=popOpacity;
		tFadeWaiting=setTimeout("fadeIn()",tPopShow);
	}
}

function fadeIn(){
	if(dypopLayer.filters.Alpha.opacity>0){
		dypopLayer.filters.Alpha.opacity-=1;
		tFadeIn=setTimeout("fadeIn()",1);
	}
}
//document.onmouseover=showPopupText;
function changeTitle(id, title){
	var s = document.getElementById(id);
	//alert(title);
	var isStr = s.options[s.selectedIndex].innerText;
//	for(var i=0;i<s.options.length;i++){
//		if(title == s.options[i].value){
//			isStr = s.options[i].innerText;
//		}
//	}
	s.title = isStr;
	//alert(s.title);
}

function onDrawBackFlg(){
	document.all("src").value="DrawBackFlg";
	document.SearchForm.submit();
}

if(fieldtempurl.length>0) fieldtempurl = fieldtempurl.substring(0,fieldtempurl.length-1);
fieldurl = " var urlvalue = {"+fieldtempurl+"}";
eval(fieldurl);


function getajaxurl(typeId){
	var url = "";
	if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
	   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59 || typeId==24 || typeId==278){
		url = "/data.jsp?type=" + typeId;			
	}else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
		url = "/data.jsp";
	}else if(typeId==161 || typeId==162 ){
		url = "/data.jsp?isreport=1&type=" + typeId + '&fielddbtype=' + tempbrowsertype;
	}
      	return url;
}
</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
</body>
<style type="text/css">
#test{
padding-left:0px!important;
}
</style>
</html>
