<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />

<%
String acceptlanguage = Util.null2String(request.getHeader("Accept-Language"));
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
//TD9892
BaseBean bb_manageom = new BaseBean();
int urm_manageom = 1;
try{
	urm_manageom = Util.getIntValue(bb_manageom.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;

int requestid = Util.getIntValue(request.getParameter("requestid"));
String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认

String reEdit=Util.null2String(request.getParameter("reEdit"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
int isform = Util.getIntValue(request.getParameter("isform"));
int modeid = Util.getIntValue(request.getParameter("modeid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
int isremark=Util.getIntValue(request.getParameter("isremark"));
int formid = Util.getIntValue(request.getParameter("formid"));
boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
boolean editmodeflag=false;
if((isremark==0||IsCanModify) && (!isaffirmance.equals("1") || !nodetype.equals("0") || reEdit.equals("1"))) editmodeflag=true;
boolean isFnabill=false;
String organizationtype="";
String organizationid="";
String subject="";
String budgetperiod="";
String hrmremain="";
String hrmremaintype="";
String deptremain="";
String deptremaintype="";
String subcomremain="";
String subcomremaintype="";
String loanbalance="";
String loanbalancetype="";
String oldamount="";
String oldamounttype="";
 int uploadType = 0;
 String selectedfieldid = "";
 
 FieldInfo.setUser(user);
 FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),user.getLanguage());
 FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),user.getLanguage());
 FieldInfo.GetWorkflowNode(workflowid);
 
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
     uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
     selectedfieldid = result.substring(0,result.indexOf(","));
 }    
if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    isFnabill=true;
    RecordSet.executeSql("select fieldname,id,type,fieldhtmltype from workflow_billfield where viewtype=1 and billid="+formid);
    while(RecordSet.next()){
        if("organizationtype".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationtype="field"+RecordSet.getString("id");
        if("organizationid".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationid="field"+RecordSet.getString("id");
        if("subject".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        subject="field"+RecordSet.getString("id");
        if("budgetperiod".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        budgetperiod="field"+RecordSet.getString("id");
        if("hrmremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            hrmremain="field"+RecordSet.getString("id");
            hrmremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("deptremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            deptremain="field"+RecordSet.getString("id");
            deptremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("subcomremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            subcomremain="field"+RecordSet.getString("id");
            subcomremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("loanbalance".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            loanbalance="field"+RecordSet.getString("id");
            loanbalancetype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("oldamount".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            oldamount="field"+RecordSet.getString("id");
            oldamounttype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
    }
}

int creater= Util.getIntValue(request.getParameter("creater"),0);
int creatertype=Util.getIntValue(request.getParameter("creatertype"),0);
String currentdate = Util.null2String(request.getParameter("currentdate"));
String currenttime = Util.null2String(request.getParameter("currenttime"));

CodeBuild cbuild = new CodeBuild(formid,isbill,workflowid,creater,creatertype);
CoderBean cb = cbuild.getFlowCBuild();
String isUse = cb.getUserUse();  //是否使用流程编号
String fieldCode=Util.null2String(cb.getCodeFieldId());
ArrayList memberList = cb.getMemberList();
boolean hasHistoryCode=cbuild.hasHistoryCode(RecordSet,workflowid);

//判断是否是E8新版保存
boolean isE8Save = false;
String E8sql = "select 1 from workflow_codeRegulate where concreteField  = '8' "+
	 " and ((formId="+formid+" and isBill='"+isbill+"') or workflowId="+workflowid+" ) ";
RecordSet.execute(E8sql);
if(RecordSet.next()){
  isE8Save = true;
}
//end

String fieldIdSelect = "";
String departmentFieldId = "";
String subCompanyFieldId = "";
String supSubCompanyFieldId = "";
String yearFieldId = "";
String yearFieldHtmlType = "";
String monthFieldId = "";
String dateFieldId = "";
if(!isE8Save){//E8前

	//int fieldIdSelect=-1;
	//int departmentFieldId=-1;
	//int subCompanyFieldId=-1;
	//int supSubCompanyFieldId=-1;
	//int yearFieldId=-1;
	//String yearFieldHtmlType="";
	//int monthFieldId=-1;
	//int dateFieldId=-1;
	
	for (int i=0;i<memberList.size();i++){
		String[] codeMembers = (String[])memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		if("22755".equals(codeMemberName)){
			fieldIdSelect=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}else if("22753".equals(codeMemberName)){
			supSubCompanyFieldId=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}else if("141".equals(codeMemberName)){
			subCompanyFieldId=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}else if("124".equals(codeMemberName)){
			departmentFieldId=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}else if("445".equals(codeMemberName)){
			yearFieldId=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}else if("6076".equals(codeMemberName)){
			monthFieldId=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}else if("390".equals(codeMemberName)||"16889".equals(codeMemberName)){
			dateFieldId=String.valueOf(Util.getIntValue(codeMemberValue,-1));
		}
	}
}else{//E8
	

	int strindex = 1;//字符串字段

	int selectindex = 1;//选择框字段

	int deptindex = 1;//部门字段
	int subindex = 1;//分部字段
	int supsubindex = 1;//上级分部字段
	int yindex = 1;//年字段

	int mindex = 1;//月字段

	int dindex = 1;//日字段

	for (int i=0;i<memberList.size();i++){
		String[] codeMembers = (String[])memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		String codeMemberType = codeMembers[2];

		String concreteField = "";
		String enablecode = "";
		//防止旧版流程导入时报错的问题
		if(codeMembers.length >= 5){
			concreteField = codeMembers[3];
			enablecode = codeMembers[4];
		}
		if(codeMemberType.equals("5") && concreteField.equals("0")){
			if("".equals(fieldIdSelect)){
				fieldIdSelect = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				fieldIdSelect += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
		}else if(codeMemberType.equals("5") && concreteField.equals("1")){
			if("".equals(departmentFieldId)){
				departmentFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				departmentFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
			//departmentFieldId = Util.getIntValue(codeMemberValue, -1);
		}else if(codeMemberType.equals("5") && concreteField.equals("2")){
			if("".equals(subCompanyFieldId)){
				subCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				subCompanyFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
			//subCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
		}else if(codeMemberType.equals("5") && concreteField.equals("3")){
			if("".equals(supSubCompanyFieldId)){
				supSubCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				supSubCompanyFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
			//supSubCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
		}else if(codeMemberType.equals("5") && concreteField.equals("4")){
			if("".equals(yearFieldId)){
				yearFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				yearFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
			//yearFieldId = Util.getIntValue(codeMemberValue, -1);
		}else if(codeMemberType.equals("5") && concreteField.equals("5")){
			if("".equals(monthFieldId)){
				monthFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				monthFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
			//monthFieldId = Util.getIntValue(codeMemberValue, -1);
		}else if(codeMemberType.equals("5") && concreteField.equals("6")){
			if("".equals(dateFieldId)){
				dateFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}else{
				dateFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
			//dateFieldId = Util.getIntValue(codeMemberValue, -1);
		}
	}
}

String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来

String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}
boolean ispopup=false;
RecordSet.executeSql("select isannexUpload from workflow_base where (isannexUpload='1' or isSignDoc='1' or isSignWorkflow='1') and id="+workflowid);
if(RecordSet.next()){
	ispopup=true;
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList seldefieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,1);
ArrayList changedefieldsmanage=WfLinkageInfo.getChangeField(workflowid,nodeid,1);    
//获得触发字段名

DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
ArrayList Linfieldname=ddi.GetInFieldName();
ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();

String selfieldsaddString = "";
for(int i=0;i<selfieldsadd.size();i++){
    selfieldsaddString += (String)selfieldsadd.get(i)+",";
}
%>
<input type=hidden name="oldaction" id="oldaction">
<script type="text/javascript">
var trrigerfields="<%=trrigerfield%>";
var trrigerdetailfields="<%=trrigerdetailfield%>";
var trrigerfieldary=trrigerfields.split(",");
var trrigerdetailfieldary="";
$G("oldaction").value=frmmain.action;
</script>
<div style="width: 0px;height: 0px!important;">
<iframe id="modeComboChange" id="modeComboChange" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="datainputform" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe ID="selframe" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="createCodeAgainIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
</div>
<script language=javascript src="/workflow/mode/loadmode_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script type="text/javascript">
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
var isInit = true;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var nowrow=frmmain.ChinaExcel.Row;
var nowcol=frmmain.ChinaExcel.Col;
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
<%
if(!editmodeflag){
%>
ismand=0;
<%
}
if(isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){%>
showPopup(uservalue,cellvalue,ismand,0);
<%}else{%>
var fieldname=uservalue;
if(fieldname!=null){
    var indx=fieldname.lastIndexOf("_");
        if(indx>0){
        var addordel=fieldname.substring(indx+1);
        fieldname=fieldname.substring(0,indx);
		indx=fieldname.lastIndexOf("_");
		var htmltype = 0;
        if(indx>0){
			htmltype = fieldname.substring(indx+1);
            fieldname=fieldname.substring(0,indx);
        }
        if(addordel=="sel"){
        		if(isHiddenPop(uservalue))return false;                
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                return false;
        }else if(addordel == "3" && htmltype == "34") {//added by wcd 2015-08-26
			frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
			return false;
		}else{
            if(addordel=="4" &&  ismand>0){
            	if(isHiddenPop(uservalue))return false;
            	frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                var checkvalue="0";
                if(GetCellCheckBoxValue(nowrow,nowcol)){
                    checkvalue="1";
                }
                document.all(fieldname).value=checkvalue;
                DataInputByBrowser(fieldname);
                return false;
            }
        }
    }
}
    showPopup(uservalue,cellvalue,ismand,1);
<%}%>
    return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick(Row, Col, UpDown)"	LANGUAGE="JavaScript" >
	<%if(urm_manageom==1){%>
    hideRightClickMenu();
    <%}%>
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    var fieldname=uservalue;
    var changefields="";
	var upDown = UpDown;
	if(upDown == 0){//only for mouse left up
    <%
    for(int j=0;j<changedefieldsmanage.size();j++){
    %>
    changefields+=",<%=changedefieldsmanage.get(j)%>";
    <%
    }
    %>
    
    //alert("uservalue:"+uservalue+"   row:"+frmmain.ChinaExcel.Row+"  col:"+frmmain.ChinaExcel.Col);
    if(uservalue!=null){
    	if(uservalue=="qianzi"&&ismand>0&&<%=IsBeForwardCanSubmitOpinion%>&&(<%=ispopup%>||"<%=isFormSignature%>"==1)){
    		var remark = $G("remark").value;
            var signdocids = $G("signdocids").value;
            var signworkflowids = $G("signworkflowids").value;
    		var workflowRequestLogId = $G("workflowRequestLogId").value;
        var fieldvalue=$G(uservalue).value;
		
        if(isHiddenPop(uservalue)){
        	ismand=0;
        	if(fieldvalue=="")return ;//无附件

        }
        var redirectUrl = "/workflow/request/WorkFlowSignUP.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&nodeid=<%=nodeid%>&fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&isFormSignature=<%=isFormSignature%>&formSignatureWidth=<%=formSignatureWidth%>&formSignatureHeight=<%=formSignatureHeight%>&remark="+remark+"&workflowRequestLogId="+workflowRequestLogId+"&signdocids="+signdocids+"&signworkflowids="+signworkflowids;
        var szFeatures = "top="+(screen.height-300)/2+"," ;
        szFeatures +="left="+(screen.width-750)/2+"," ;
        szFeatures +="width=860," ;
        szFeatures +="height=300," ; 
        szFeatures +="directories=no," ;
        szFeatures +="status=no," ;
        szFeatures +="menubar=no," ;
        szFeatures +="scrollbars=yes," ;
        szFeatures +="resizable=no" ; //channelmode
        window.open(redirectUrl,"fileup",szFeatures);                
        frmmain.ChinaExcel.GoToCell(1,1);
    	}else{
        var indx=uservalue.lastIndexOf("_");
        var uservalues =  uservalue.split("_");
        var isdetail = (uservalues.length>3)?1:0;
        if(indx>0){
            var addordel=uservalue.substring(indx+1);
            uservalue=uservalue.substring(0,indx);
            if(isdetail==1){
            	uservalue=uservalues[0]+"_"+uservalues[1]+"_"+uservalues[2];
            }
            <%if(editmodeflag){%>
            if(addordel=="add"){
            	//获取当前滚动条起始位置
            	var startCol = frmmain.ChinaExcel.GetStartCol();
            	isInit = true;
                rowIns(uservalue.substring(6),0,1,changefields);
                isInit = false;
                setheight();
                //将当前滚动条设置为添加前的位置

                frmmain.ChinaExcel.SetHScrollPos(startCol);
            }
            if(addordel=="del"){
                rowDel(uservalue.substring(6));
                setheight();
            }
            if(addordel=="showKeyword"){
                onShowKeyword();
            }
            <%}%>
            if(addordel=="6"){
                indx=uservalue.indexOf("_");
                if(indx>0){
                    uservalue=uservalue.substring(0,indx);
                }
                if(isdetail==1){
                	uservalue=uservalues[0]+"_"+uservalues[1];
                }
                var fieldvalue=$G(uservalue).value;
                var selectfieldvalue="";
                <%
                if(!selectedfieldid.equals("")){
                %>
                if($G("field<%=selectedfieldid%>")) selectfieldvalue=$G("field<%=selectedfieldid%>").value
                <%}%>
				<%if(editmodeflag){%>
                if(ismand>0 || fieldvalue.length>0){
                if(isHiddenPop(uservalue)){
		        	ismand=0;
		        	if(fieldvalue=="")return ;//无附件

		        }
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&requestid=<%=requestid%>&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=860," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures) ;
                frmmain.ChinaExcel.GoToCell(1,1);
                }
				<%}else if((isremark==1 || isremark==8 || isremark==9) && (!isaffirmance.equals("1") || !nodetype.equals("0") || reEdit.equals("1"))){//TD10998 被转发、抄送特殊处理，能查看、下载附件%>
                if(ismand>0 || fieldvalue.length>0){
                	if(isHiddenPop(uservalue)){
			        	ismand=0;
			        	if(fieldvalue=="")return ;//无附件

			        }
					var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit=0&requestid=<%=requestid%>&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
					var szFeatures = "top="+(screen.height-300)/2+",";
					szFeatures +="left="+(screen.width-750)/2+",";
					szFeatures +="width=750,";
					szFeatures +="height=300,";
					szFeatures +="directories=no,";
					szFeatures +="status=no,";
					szFeatures +="menubar=no,";
					szFeatures +="scrollbars=yes,";
					szFeatures +="resizable=no";
					window.open(redirectUrl,"fileup",szFeatures);
					frmmain.ChinaExcel.GoToCell(1,1);
                }
				<%}%>
            }
        }
      }
    }
	}else{
		//frmmain.ChinaExcel.GoToCell(1,1);
	}
	setheight();
    frmmain.ChinaExcel.RefreshViewSize();
    return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        hidePopup();
        var divBillScrollTop=$G("divWfBill", parent.document).scrollTop;
        <%if(urm_manageom==1){%>
        showRightClickMenuByHand((frmmain.ChinaExcel.offsetLeft+frmmain.ChinaExcel.GetMousePosX()),(frmmain.ChinaExcel.offsetTop+frmmain.ChinaExcel.GetMousePosY()-divBillScrollTop));
		try{
			event.stopPropagation();
		}catch(e){
			try{
				event.cancelBubble = true
				event.returnValue = false;
			}catch(e){}
		} 
		
		<%}%>
		return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="CellContentChanged(row, col)"	LANGUAGE="JavaScript" >
    imgshoworhide(row,col); 
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(row,col);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(row,col);
    cellvalue = Simplized(cellvalue);
    var ismand=frmmain.ChinaExcel.GetCellUserValue(row,col);
    changevalue(uservalue,cellvalue,ismand);
    changeKeyword(uservalue,cellvalue,ismand);
    var fieldname=uservalue;
    if(fieldname!=null){
        var indx=fieldname.lastIndexOf("_");
        if(indx>0){
        	var htmltype=fieldname.substring(fieldname.lastIndexOf("_")+1);
            var addordel=fieldname.substring(indx+1);
            fieldname=fieldname.substring(0,indx);
            indx=fieldname.lastIndexOf("_");
            
            if (htmltype == 5) return;
            
            if(indx>0){
				if(htmltype == 3 && fieldname.substring(indx+1) == 34) {//added by wcd 2015-08-26
					frmmain.ChinaExcel.DeleteCellImage(row,col,row,col);
					if(ismand==2){
						frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError_wev8.gif",row,col,true,true);
					}
					return false;
				}
                fieldname=fieldname.substring(0,indx);
                DataInputByBrowser(fieldname);
            }
        }
    }
    
     var fieldName2 = uservalue.substring(0,uservalue.indexOf("_"));
     if(fieldName2=="field<%=fieldCode%>"){ 
     	onChangeCode(ismand);
     }
    
    frmmain.ChinaExcel.RefreshViewSize();
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="RegionHaveChanged(StartRow, StartCol, EndRow, EndCol)"	LANGUAGE="JavaScript" >
try {
	if(!isInit) {
		if(StartRow <= EndRow && StartCol <= EndCol) {
			for(var i=parseInt(StartRow); i <= parseInt(EndRow); i++) {
				for(var j=StartCol; j <= EndCol; j++) {
					frmmain.ChinaExcel.FireCellContentChangedEvent(i,j);
				}
			}
		}
	}
}catch(e) {}
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="ComboSelEnd()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var selvalue=frmmain.ChinaExcel.GetCellComboSelectedActualValue(nrow,ncol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    var nindx=uservalue.lastIndexOf("_");
    var fieldid="-1";
    var rownum=-1;
    <%if(isFnabill){%>
    var tindx=uservalue.indexOf("_");
    if(tindx>0){
        var tfieldname=uservalue.substring(0,tindx);
        var tlastfield=uservalue.substring(tindx+1);
        if(tfieldname=="<%=organizationtype%>"){
            tindx=tlastfield.indexOf("_");
            if(tindx>0){
                var trow=tlastfield.substring(0,tindx);
                if($G("<%=organizationtype%>_"+trow)){
                    var oldtype=$G("<%=organizationtype%>_"+trow).value;
                    var tfieldid="<%=organizationid%>_"+trow;
                    if(oldtype==1){
                        tfieldid+="_164_3";
                    }else if(oldtype==2){
                        tfieldid+="_4_3";
                    }else{
                        tfieldid+="_1_3";
                    }
                    var orgidcol=frmmain.ChinaExcel.GetCellUserStringValueCol(tfieldid);
                    if(orgidcol>0){
                        tfieldid="<%=organizationid%>_"+trow;
                        var turl="";
                        var turllink="";
                        if(selvalue==1){
                            tfieldid+="_164_3";
                            turl='<%=urlcominfo.getBrowserurl("164")%>';
                            turllink='<%=urlcominfo.getLinkurl("164")%>';
                        }else if(selvalue==2){
                            tfieldid+="_4_3";
                            turl='<%=urlcominfo.getBrowserurl("4")%>';
                            turllink='<%=urlcominfo.getLinkurl("4")%>';
                        }else{
                            tfieldid+="_1_3";
                            turl='<%=urlcominfo.getBrowserurl("1")%>';
                            turllink='<%=urlcominfo.getLinkurl("1")%>';
                        }
                        frmmain.ChinaExcel.SetCellProtect(nrow,orgidcol,nrow,orgidcol,false);
                        frmmain.ChinaExcel.SetCellUserStringValue(nrow,orgidcol,nrow,orgidcol,tfieldid);
                        frmmain.ChinaExcel.SetCellVal(nrow,orgidcol,"");
                        imgshoworhide(nrow,orgidcol);
                        frmmain.ChinaExcel.SetCellProtect(nrow,orgidcol,nrow,orgidcol,true);
                        if($G("<%=organizationid%>_"+trow)){
                            $G("<%=organizationid%>_"+trow).value="";
                        }
                        if($G("<%=organizationid%>_"+trow+"_url")){
                            $G("<%=organizationid%>_"+trow+"_url").value=turl;
                        }
                        if($G("<%=organizationid%>_"+trow+"_urllink")){
                            $G("<%=organizationid%>_"+trow+"_urllink").value=turllink;
                        }
                        if($G("<%=hrmremain%>_"+trow)){
                            $G("<%=hrmremain%>_"+trow).value="";
                        }
                        if($G("<%=deptremain%>_"+trow)){
                            $G("<%=deptremain%>_"+trow).value="";
                        }
                        if($G("<%=subcomremain%>_"+trow)){
                            $G("<%=subcomremain%>_"+trow).value="";
                        }
                        if($G("<%=loanbalance%>_"+trow)){
                            $G("<%=loanbalance%>_"+trow).value="";
                        }
                        if($G("<%=oldamount%>_"+trow)){
                            $G("<%=oldamount%>_"+trow).value="";
                        }
                        var hrmremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_"+trow+"_<%=hrmremaintype%>");
                        if(hrmremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,hrmremaincol,nrow,hrmremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,hrmremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,hrmremaincol,nrow,hrmremaincol,true);
                        }
                        var deptremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_"+trow+"_<%=deptremaintype%>");
                        if(deptremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,deptremaincol,nrow,deptremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,deptremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,deptremaincol,nrow,deptremaincol,true);
                        }
                        var subcomremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_"+trow+"_<%=subcomremaintype%>");
                        if(subcomremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,subcomremaincol,nrow,subcomremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,subcomremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,subcomremaincol,nrow,subcomremaincol,true);
                        }
                        var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
                        if (loanbalancecol > 0) {
                            frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
                            frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, "");
                            frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
                        }
                        var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
                        if (oldamountcol > 0) {
                            frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
                            frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, "");
                            frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
                            frmmain.ChinaExcel.ReCalculate();
                        }
                    }
                }
            }
        }
    }
    <%}%>
    if(uservalue!="requestlevel"&&uservalue!="messageType"){
	    if(nindx>0){
	        uservalue=uservalue.substring(0,nindx);
	        nindx=uservalue.lastIndexOf("_");
	        if(nindx>0){
	            uservalue=uservalue.substring(0,nindx);
                nindx=uservalue.lastIndexOf("_");
                if(nindx>0){
                    fieldid=uservalue.substring(5,nindx);
                    rownum=uservalue.substring(nindx+1);
                }else{
                    fieldid=uservalue.substring(5);
                }
            }
	    }
	  }
    $G(uservalue).value=selvalue;
    //select字段-联动
    DataInputByBrowser(uservalue);
    <%
    for(int i=0;i<selfieldsadd.size();i++){
    %>
    if("<%=selfieldsadd.get(i)%>"==fieldid){
        changeshowattrBymode('<%=selfieldsadd.get(i)%>_0',selvalue,-1,<%=workflowid%>,<%=nodeid%>);
    }
    <%
    }
    for(int i=0;i<seldefieldsadd.size();i++){
    %>
    if("<%=seldefieldsadd.get(i)%>"==fieldid){
        changeshowattrBymode('<%=seldefieldsadd.get(i)%>_1',selvalue,rownum,<%=workflowid%>,<%=nodeid%>);
    }
    <%
    }
    %>
    var childfieldObj = $G("childFieldfield"+fieldid);
    if(childfieldObj!=null){
		var childfieldid = childfieldObj.value;
		if(childfieldid!=null && childfieldid!="" && childfieldid!="0" && (childfieldid.indexOf("0_")==-1 || childfieldid.indexOf("0_")>0)){
			var paraStr = "ismanager=1&fieldid="+fieldid+"&childfield="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum;
			//alert(paraStr);
		    $G("modeComboChange").src = "ComboChange.jsp?"+paraStr;
		}
    }
    return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="CalculateEnd()"	LANGUAGE="JavaScript" >
    MainCalculate();
    DetailCalculate();
	return false;
</script>
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj_wev8.js"></script>
<%} %>
<DIV id="ocontext" name="ocontext" style="LEFT: 0px;Top:0px;POSITION:ABSOLUTE ;display:none" >
<table id=otable cellpadding='0' cellspacing='0' width="200" border=1 style="WORD-WRAP:break-word">
</table>
</DIV>

<input type=hidden name="indexrow" id="indexrow" value=0>
<input type=hidden name="isform" id="isform" value="<%=isform%>">
<input type=hidden name="modeid" id="modeid" value="<%=modeid%>">
<input type=hidden name="modestr" id="modestr" value="">
<input type=hidden name="isShowPopupCreateCodeAgain" id="isShowPopupCreateCodeAgain" value="1">

<script language=javascript>
function doInitDetailchildSelectAdd(fieldid,selvalue,rownum){
	try{
		var childfieldObj = $G("childFieldfield"+fieldid);
		if(childfieldObj!=null){
			var childfieldid = childfieldObj.value;
			if(childfieldid!=null && childfieldid!="" && childfieldid!="0" && (childfieldid.indexOf("0_")==-1 || childfieldid.indexOf("0_")>0)){
				var paraStr = "fieldid="+fieldid+"&childfield="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+fieldid+"_"+childfieldid+"_"+rownum;
				frm.style.display = "none";
				frm.src = "ComboChange.jsp?"+paraStr;
				document.body.appendChild(frm);
			}
		}
	}catch(e){}
}

function readmode(){
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
    try{
	    var maxrow=frmmain.ChinaExcel.GetMaxRow();
	    var maxcol=frmmain.ChinaExcel.GetMaxCol();
	    var userstr="";
	    for(var i=1;i<=maxrow;i++){
	        for(var j=1;j<=maxcol;j++){
	            userstr=frmmain.ChinaExcel.GetCellUserStringValue(i,j);             
	<%if("1".equals(isbill) && formid==156) {%>
	            if(userstr == '<%=organizationid%>_0_1_3') {
	            	userstr = "<%=organizationid%>_0_4_3";
	            	isProtect=frmmain.ChinaExcel.IsCellProtect(i,j);
					if(isProtect){
						frmmain.ChinaExcel.SetCellProtect(i,j,i,j,false);
					}
					frmmain.ChinaExcel.SetCellUserStringValue(i,j,i,j,userstr);
					if(isProtect){
						frmmain.ChinaExcel.SetCellProtect(i,j,i,j,true);
					}
	            }
	<%}%>
			}
		}
	}catch(e){}
}
</script>
<script language=vbs>
sub init()
    frmmain.ChinaExcel.SetOnlyShowTipMessage true
    chinaexcelregedit()
	readmode()
    frmmain.ChinaExcel.DesignMode = false
    frmmain.ChinaExcel.SetShowPopupMenu false	
    frmmain.ChinaExcel.SetCanAutoSizeHideCols true 
    frmmain.ChinaExcel.SetProtectFormShowCursor true 
    frmmain.ChinaExcel.ShowGrid = false
    frmmain.ChinaExcel.SetShowScrollBar 1,false
    getRowGroup()
    setmantable()
    setdetailtable()
    setnodevalue()
	initRowData()
    doTriggerInit()
    doLinkAgeInit()
    frmmain.ChinaExcel.ReCalculate()
    <%if(isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){%>
        frmmain.ChinaExcel.FormProtect true
    <%}%>
    setheight()
    frmmain.ChinaExcel.SetPasteType 1
    frmmain.ChinaExcel.GoToCell 1,1
    RefreshViewSize()
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
	isInit = false
end sub
</script>
<script language=javascript>
	function initRowData()
	{
		var changefields="";
	<%
	    for(int j=0;j<changedefieldsmanage.size();j++){
	    %>
	    changefields+=",<%=changedefieldsmanage.get(j)%>";
	    <%
	    }
	    ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
	    for(int i=0; i<detailtablefieldids.size();i++)
	    {
	    	RecordSet.executeSql("select defaultrows from workflow_NodeFormGroup where nodeid="+nodeid+" and groupid="+i);
	    	RecordSet.next();
	    	int defaultrows = Util.getIntValue(RecordSet.getString("defaultrows"),0);
	    	//System.out.println("select defaultrows from workflow_NodeFormGroup where nodeid="+nodeid+" and groupid="+i);
	%>
		//确认是否添加控制
		var isneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_isneed");
		var isdefault=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_isdefault");
		var tempdetail = $G("tempdetail<%=i%>");
		var tempdetailvalue = 0;
		if(tempdetail)
		{
			tempdetailvalue = tempdetail.value;
		}
	    <%
		boolean isAddDefaultRows = (!isaffirmance.equals("1") || !nodetype.equals("0") || reEdit.equals("1"));
		%>
		isAddDefaultRows = <%=isAddDefaultRows%>
	    if(tempdetailvalue<1&&isdefault>0 && isAddDefaultRows)
	    {
	    	isCreateDIframe = true;
	    	isInit = true;
	    	rowIns("<%=i%>",1,1,changefields,"1");
	    	isInit = false;
	    	
	    	var defaultrows = "<%=defaultrows%>";
			for(var k=0;k<parseInt(parseInt(defaultrows)-1);k++){
				isInit = true;
				rowIns("<%=i%>",0,1,changefields);
				isInit = false;
			}
	    }
	    isCreateDIframe = false;
	    
	<%
	    }
	%>
	}
     function setheight(){
        var maxrow=frmmain.ChinaExcel.GetMaxRow();
        var totalheight=35;
        for(var i=1;i<=maxrow;i++){
            totalheight+=frmmain.ChinaExcel.GetRowSize(i,1);
        }
        frmmain.ChinaExcel.height=totalheight;
        frmmain.ChinaExcel.SetShowScrollBar(1,true);
    }
    function setwidth(){

        var totalwidth=0;
        var colnum = frmmain.ChinaExcel.GetMaxCol();		
		for(var i=0;i<colnum;i++){
			totalwidth += frmmain.ChinaExcel.GetColSize(i,1);
		}

        var temptotalwidth=parent.document.body.clientWidth-totalwidth;
        //var temptotalwidth = jQuery(parent.document.body).width() - totalwidth;
        if(temptotalwidth>0&&false){ 
        	totalwidth=totalwidth;
        	frmmain.ChinaExcel.width=totalwidth;
        	frmmain.ChinaExcel.SetShowScrollBar(0,false);
        }else{
        	frmmain.ChinaExcel.width=parent.document.body.clientWidth - 40;
        	//frmmain.ChinaExcel.width=jQuery(parent.document.body).width() - 40;

        	frmmain.ChinaExcel.SetShowScrollBar(0,true);
        }
    }

//function window.onresize(){
//    setheight();
//	setwidth();
//}
jQuery(window).resize(function (){
	setheight();
	setwidth();
}); 

function RefreshViewSize(){
	<%if(urm_manageom==1){%>
    //rightMenu.focus();
	    try {
		    rightMenu.focus();
	    }catch(e) {
	    }
    <%}%>
    for(r=0;r<rowgroup.length;r++){
        rhead=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+r+"_head");
        frmmain.ChinaExcel.SetRowHide(rhead,rhead+rowgroup[r],true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}

<%
//String isFormSignature=null;
//RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
//if(RecordSet.next()){
//	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
//}
%>

function createDoc(fieldbodyid,docValue,isedit){
	
	/* 
   for(i=0;i<=1;i++){ 
  		parent.document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";  	
  	*/
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	if("<%=isremark%>"==9||<%=!editmodeflag%>||"<%=isremark%>"==5||"<%=isremark%>"==8){
  		frmmain.action = "RequestDocView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&docValue="+docValue;
  	}else{
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	    frmmain.action = $G("oldaction").value+"?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&docView="+isedit+"&docValue="+docValue+"&isFromEditDocument=true";
  	}
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw"; 
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文    
        document.frmmain.src.value='save';
        document.frmmain.isremark.value='0';
        				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");                       //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();
    }
}

function openWindow(urlLink){

  	window.open(urlLink+"&requestid=<%=requestid%>");

}

function openWindowNoRequestid(urlLink){
    window.open(urlLink);
}

<%
int titleFieldId=-1;
int keywordFieldId=-1;
RecordSet.execute("select titleFieldId,keywordFieldId from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=RecordSet.getInt("titleFieldId");
	keywordFieldId=RecordSet.getInt("keywordFieldId");
}
%>
var hasinitfieldvalue=false;
	var initfieldvalue = -1;
	if($G("field<%=fieldCode%>")!=null){
		if(!hasinitfieldvalue) {
			initfieldvalue = $G("field<%=fieldCode%>").value;
			hasinitfieldvalue = true;
		}
	}    
//发文字号变更(TD20002)
function onChangeCode(ismand){
	if($G("field<%=fieldCode%>")!=null){
		initDataForWorkflowCode();
		if($G("field<%=fieldCode%>").value == "" || $G("field<%=fieldCode%>").value == initfieldvalue) {
			return;
		} else {
        	document.all("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=ChangeCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&returnCodeStr="+escape($G("field<%=fieldCode%>").value) +"&oldCodeStr="+initfieldvalue;
        }
	}
}
function changeKeyword(uservalue,cellvalue,ismand){
<%
	if(titleFieldId>0&&keywordFieldId>0){
%>
        fieldName=uservalue.substring(0,uservalue.indexOf("_"));
        if(fieldName=="field<%=titleFieldId%>"){
        	var keywordObj=$G("field<%=keywordFieldId%>");
		    $G("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&operation=UpdateKeywordData&docTitle="+cellvalue+"&docKeyword="+keywordObj.value;
	    }
<%
   }else if(titleFieldId==-3&&keywordFieldId>0){
%>
        fieldName=uservalue;
        if(fieldName=="requestname"){
        	var keywordObj=$G("field<%=keywordFieldId%>");
		    $G("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&operation=UpdateKeywordData&docTitle="+cellvalue+"&docKeyword="+keywordObj.value;
	    }
<%
   }
%>
}

function updateKeywordData(strWordkey){

	var nrow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=keywordFieldId%>_1_1");
	if(nrow>0){
		var ncol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=keywordFieldId%>_1_1");
		if(ncol>0){
			document.frmmain.ChinaExcel.SetCellVal(nrow,ncol,getChangeField(strWordkey));
			$G("field<%=keywordFieldId%>").value=strWordkey;
		    imgshoworhide(nrow,ncol);
            document.frmmain.ChinaExcel.RefreshViewSize();
		}
	}
}

function onShowKeyword(){

	var keywordRow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=keywordFieldId%>_1_1");
	if(keywordRow>0){
		var keywordCol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=keywordFieldId%>_1_1");
		if(keywordCol>0){

            strKeyword=$G("field<%=keywordFieldId%>").value;
            tempUrl=escape("/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&strKeyword="+strKeyword);
            id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&url="+tempUrl);
        
		    if(typeof(id1)!="undefined"){
			    document.frmmain.ChinaExcel.SetCellVal(keywordRow,keywordCol,getChangeField(id1));
			    $G("field<%=keywordFieldId%>").value=id1;
		        imgshoworhide(keywordRow,keywordCol);
                frmmain.ChinaExcel.RefreshViewSize();
			}

			frmmain.ChinaExcel.GoToCell(1,1);
		}
	}

}
function onShowFnaInfo(fieldid,nrow){
<%if(isFnabill){%>
    var tindx = fieldid.indexOf("_");
    if (tindx > 0) {
        var tfieldname = fieldid.substring(0, tindx);
        var tlastfield = fieldid.substring(tindx + 1);
        if (tfieldname == "<%=organizationid%>" || tfieldname == "<%=subject%>" || tfieldname == "<%=budgetperiod%>") {
            tindx = tlastfield.indexOf("_");
            var trow=0;
            if(tindx>0){
                trow = tlastfield.substring(0, tindx);
            }else{
                trow = tlastfield;
            }
            if (document.all("<%=organizationtype%>_" + trow) && document.all("<%=organizationid%>_" + trow) && document.all("<%=subject%>_" + trow) && document.all("<%=budgetperiod%>_" + trow)) {
                if (document.all("<%=organizationtype%>_" + trow).value != "" && document.all("<%=organizationid%>_" + trow).value != "" && document.all("<%=subject%>_" + trow).value != "" && document.all("<%=budgetperiod%>_" + trow).value != "") {
                    getBudgetKpi(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, document.all("<%=subject%>_" + trow).value, nrow);
                    getLoan(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, nrow);
                    getBudget(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, document.all("<%=subject%>_" + trow).value, nrow);
                    return;
                }
            }
            if (document.all("<%=hrmremain%>_" + trow)) {
                document.all("<%=hrmremain%>_" + trow).value = "";
            }
            if (document.all("<%=deptremain%>_" + trow)) {
                document.all("<%=deptremain%>_" + trow).value = "";
            }
            if (document.all("<%=subcomremain%>_" + trow)) {
                document.all("<%=subcomremain%>_" + trow).value = "";
            }
            if(document.all("<%=loanbalance%>_" + trow)!=null){
                document.all("<%=loanbalance%>_" + trow).value = "";
            }
            if(document.all("<%=oldamount%>_" + trow)!=null){
                document.all("<%=oldamount%>_" + trow).value = "";
            }
            var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + trow + "_<%=hrmremaintype%>");
            if (hrmremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, hrmremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, true);
            }
            var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + trow + "_<%=deptremaintype%>");
            if (deptremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, deptremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, true);
            }
            var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + trow + "_<%=subcomremaintype%>");
            if (subcomremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, subcomremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, true);
            }
            var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
            if (loanbalancecol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
            }
            var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
            if (oldamountcol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
                frmmain.ChinaExcel.ReCalculate();
            }
        }
    }
<%}%>
}
function callback(o, index,nrow) {
    val = o.split("|");
    //alert(o);
    if (val[0] != "") {
        v = val[0].split(",");
        hrmremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + index + "_<%=hrmremaintype%>");
        if (hrmremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, hrmremaincol, getChangeField(hrmremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, true);
        }
    }
    if (val[1] != "") {
        v = val[1].split(",");
        deptremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + index + "_<%=deptremaintype%>");
        //alert(nrow+"+"+deptremaincol+"|"+deptremainstr);
        if (deptremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, deptremaincol, getChangeField(deptremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, true);
        }
    }
    if (val[2] != "") {
        v = val[2].split(",");
        subcomremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + index + "_<%=subcomremaintype%>");
        //alert(nrow+"+"+subcomremaincol+"|"+subcomremainstr);
        if (subcomremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, subcomremaincol, getChangeField(subcomremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, true);
        }
    }
    frmmain.ChinaExcel.RefreshViewSize();
}


function getBudgetKpi(index, organizationtype, organizationid, subjid,nrow) {
	var budgetperiod = jQuery("#<%=budgetperiod%>_"+index).val();
	if(subjid!=""&&organizationtype!=""&&organizationid!=""&&budgetperiod!=""){
		var _data = "budgetfeetype="+subjid+"&orgtype="+organizationtype+"&orgid="+organizationid+"&applydate="+budgetperiod;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerGetBudgetKPI.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback(jQuery.trim(msg), index, nrow);
			}
		});	
	}else{
		callback("", index, nrow);
	}
}
function getBudget(index, organizationtype, organizationid, subjid,nrow) {
    var callbackProxy = function(o) {
        callback2(o, index,nrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getBudgetByDate(document.all("<%=budgetperiod%>_" + index).value, organizationtype, organizationid, subjid, callMetaData);
}
function callback1(o, index,nrow) {
    //alert(o);
    if(document.all("<%=loanbalance%>_" + index)!=null){
        document.all("<%=loanbalance%>_" + index).value = o;
    }
    var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>");
    if (loanbalancecol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
        frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, getChangeField(o));
        frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
		setExcelValue("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>",o);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function callback2(o, index,nrow) {
    //alert(o);
    if(document.all("<%=oldamount%>_" + index)!=null){
        document.all("<%=oldamount%>_" + index).value = o;
    }
    var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + index + "_<%=oldamounttype%>");
    if (oldamountcol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
        frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, getChangeField(o));
        frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
    }
    frmmain.ChinaExcel.ReCalculate();
    frmmain.ChinaExcel.RefreshViewSize();
}
function setExcelValue(labelexcel,value){
	var wcell=frmmain.ChinaExcel;
	var temprow1=wcell.GetCellUserStringValueRow(labelexcel);
	var tempcol1=wcell.GetCellUserStringValueCol(labelexcel);
	if(temprow1>0){
		wcell.SetCellVal(temprow1,tempcol1,value);
	    imgshoworhide(temprow1,tempcol1);
	}		
}
function getLoan(index, organizationtype, organizationid,nrow) {
    var callbackProxy = function(o) {
        callback1(o, index,nrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getLoanAmount(organizationtype, organizationid,callMetaData);
}

function doLinkAgeInit(){
    window.setTimeout("RealdoLinkAgeInit()",500);
}
function RealdoLinkAgeInit(){
    var tempS = "<%=selfieldsaddString%>";
    var tempA = "";
    var fields = "";
    var fieldvalues = "";
    if(tempS.length>0){
        tempA = tempS.split(",");
        for(var i=0;i<tempA.length;i++){
            if($G("field"+tempA[i])){
                var tempselvalue = $G("field"+tempA[i]).value;
                fields += ","+tempA[i]+"_0";
                fieldvalues += ","+tempselvalue;
            }
        }
    }
    changeshowattrBymode(fields,fieldvalues,-1,<%=workflowid%>,<%=nodeid%>);
}

function doTriggerInit(){
    trrigerdetailfieldary=trrigerdetailfields.split(",");
}
function datainput(parfield){                <!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; 
		if(src.value==''){
			return ;
		}
	}catch(e){}
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=0&trg="+parfield;
      var tempdata = "";
      var temprand = $G("rand").value ;
      <%
      if(!trrigerfield.trim().equals("")){

          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if($G("<%=temp.substring(temp.indexOf("|")+1)%>")!=null) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
         if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
      <%
          }
          }
      %>
      var tempParfieldArr = parfield.split(",");
      for(var i=0;i<tempParfieldArr.length;i++){
	  	var tempParfield = tempParfieldArr[i];
	  	tempdata += $G(tempParfield).value+"," ;
	  }

      StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
      if($G("datainput_"+parfield)){
		  	$G("datainput_"+parfield).src = "DataInputMode.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$G("datainput_"+parfield).src = "DataInputMode.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+StrData;
	  }
      //$G("datainputform").src="DataInputMode.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+StrData;
  }

var isCreateDIframe = false;

function datainputd(parfield){                <!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
	}catch(e){}  

      var tempParfieldArr = parfield.split(",");
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=1&trg="+parfield;
	  
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

      <%
      if(!trrigerdetailfield.trim().equals("")){
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          //if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
	  if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>_"+i+"="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          //if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
	  if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>_"+i+"="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
      <%
          }
          }
      %>
      }
      if(isCreateDIframe){
      	  var iframe_datainputd = document.createElement("iframe");
		  iframe_datainputd.src = "DataInputModeDetail.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+StrData;
		  iframe_datainputd.frameborder = "0";
		  iframe_datainputd.height = "0";
		  iframe_datainputd.scrolling = "no";
		  iframe_datainputd.style.display = "none";
		  document.appendChild(iframe_datainputd);
      }else{
      	  $G("datainputformdetail").src="DataInputModeDetail.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&"+StrData;
      }
  }

<%
ArrayList currentdateList=Util.TokenizerString(currentdate,"-") ;
int departmentId=Util.getIntValue(ResourceComInfo.getDepartmentID(""+creater),-1);
int subCompanyId=Util.getIntValue(DepartmentComInfo1.getSubcompanyid1(""+departmentId),-1);	
int supSubCompanyId=Util.getIntValue(SubCompanyComInfo1.getSupsubcomid(""+subCompanyId),-1);
if(supSubCompanyId<=0){
	supSubCompanyId=subCompanyId;//若上级分部为空，则认为上级分部为分部
}
%>

    var workflowId=<%=workflowid%>;
    var formId=<%=formid%>;
    var isBill=<%=isbill%>;
	var yearId=-1;
	var monthId=-1;
	var dateId=-1;
	var fieldId=-1;
	var fieldValue=-1;
	var supSubCompanyId=-1;
	var subCompanyId=-1;
	var departmentId=-1;
	var recordId=-1;

	var yearFieldValue=-1;
    var yearFieldHtmlType=-1;
	var monthFieldValue=-1;
	var dateFieldValue=-1;
	var createrdepartmentid=<%=departmentId%>;

function initDataForWorkflowCode(){
	yearId=-1;
	monthId=-1;
	dateId=-1;
	fieldId=-1;
	fieldValue=-1;
	supSubCompanyId=-1;
	subCompanyId=-1;
	departmentId=-1;
	recordId=-1;

	yearFieldValue=-1;
	yearFieldHtmlType="<%=yearFieldHtmlType%>";
	monthFieldValue=-1;
	dateFieldValue=-1;	

	<%
	if(yearFieldId.indexOf("~~wfcode~~")>-1){
		String [] yearlist = yearFieldId.split("~~wfcode~~");
		if(yearlist.length>0){
			for(int yidx=0;yidx < yearlist.length;yidx++){
%>		
				if( $GetEle("field<%=yearlist[yidx]%>")!=null){
					if(yearFieldHtmlType==5){//年份为下拉框
					  try{
						  var objYear= $GetEle("field<%=yearlist[yidx]%>");
						  var yvalue = "";
						  try{
						  	yvalue = objYear.options[objYear.selectedIndex].text;
						  }catch(e){
							yvalue = "-1";
						  }
						  
						  if(yearId==""){
						  	yearId = yvalue; 
						  }else{
						  	yearId += ","+yvalue; 
						  }
					  	
						}catch(e){}
					}else{
						try{
					    	yearFieldValue= $GetEle("field<%=yearlist[yidx]%>").value;
						}catch(e){
							yearFieldValue = "-1";
						}
					    if(yearFieldValue.indexOf("-")>0){
						    var yearFieldValueArray = yearFieldValue.split("-") ;
						    if(yearFieldValueArray.length>=1){
						    	if(yearId==""){
							    	yearId=yearFieldValueArray[0];
						    	}else{
						    		yearId+= ","+yearFieldValueArray[0];
						    	}
						    }
					    }else{
					    	if(yearId==""){
						    	yearId=yearFieldValue;
					    	}else{
					    		yearId+= ","+yearFieldValue;
					    	}
					    }
					}
				}else{
					<%if (currentdateList.size() >= 1) {%>
					if(yearId==""){
				    	yearId=<%=(String) currentdateList.get(0)%>;
			    	}else{
			    		yearId+= ","+<%=(String) currentdateList.get(0)%>;
			    	}
					<%}%>
				}
<%		
			}
		}
	}else{
%>
		if( $GetEle("field<%=yearFieldId%>")!=null){
			if(yearFieldHtmlType==5){//年份为下拉框
			  try{
				  objYear= $GetEle("field<%=yearFieldId%>");
				  yearId=objYear.options[objYear.selectedIndex].text; 
			  }catch(e){
			  }
			}else{
			    yearFieldValue= $GetEle("field<%=yearFieldId%>").value;
			    if(yearFieldValue.indexOf("-")>0){
				    var yearFieldValueArray = yearFieldValue.split("-") ;
				    if(yearFieldValueArray.length>=1){
					    yearId=yearFieldValueArray[0];
				    }
			    }else{
				    yearId=yearFieldValue;
			    }
			}
		}
	<%}%>

	
	<%
	if(monthFieldId.indexOf("~~wfcode~~")>-1){
		String [] monlist = monthFieldId.split("~~wfcode~~");
		if(monlist.length>0){
			for(int midx=0;midx < monlist.length;midx++){
	%>	
				if( $GetEle("field<%=monlist[midx]%>")!=null){
					monthFieldValue= $GetEle("field<%=monlist[midx]%>").value;
					if(monthFieldValue.indexOf("-")>0){
						var monthFieldValueArray = monthFieldValue.split("-") ;
						if(monthFieldValueArray.length>=2){
							//yearId=monthFieldValueArray[0];
							if(monthId==""){
								monthId=monthFieldValueArray[1];
					    	}else{
					    		monthId+= ","+monthFieldValueArray[1];
					    	}
						}
					}
				}else{
					<%if (currentdateList.size() >= 2) {%>
						if(monthId==""){
							monthId="<%=(String) currentdateList.get(1)%>";
				    	}else{
				    		monthId+= ","+"<%=(String) currentdateList.get(1)%>";
				    	}
					<%}%>
				}
	<%		
			}
		}
	}else{
	%>
		if( $GetEle("field<%=monthFieldId%>")!=null){
			monthFieldValue= $GetEle("field<%=monthFieldId%>").value;
			if(monthFieldValue.indexOf("-")>0){
				var monthFieldValueArray = monthFieldValue.split("-") ;
				if(monthFieldValueArray.length>=2){
					//yearId=monthFieldValueArray[0];
					monthId=monthFieldValueArray[1];
				}
			}
		}
	<%}%>

	
	<%
	if(dateFieldId.indexOf("~~wfcode~~")>-1){
		String [] dlist = dateFieldId.split("~~wfcode~~");
		if(dlist.length>0){
			for(int didx=0;didx < dlist.length;didx++){
	%>	
				if( $GetEle("field<%=dlist[didx]%>")!=null){
					dateFieldValue= $GetEle("field<%=dlist[didx]%>").value;
					if(dateFieldValue.indexOf("-")>0){
						var dateFieldValueArray = dateFieldValue.split("-") ;
						if(dateFieldValueArray.length>=3){
							//yearId=dateFieldValueArray[0];
							//monthId=dateFieldValueArray[1];
							//dateId=dateFieldValueArray[2];
							if(dateId==""){
								dateId=dateFieldValueArray[2];
					    	}else{
					    		dateId+= ","+dateFieldValueArray[2];
					    	}
						}
					}
				}else{
					<%if (currentdateList.size() >= 3) {%>
					if(dateId==""){
						dateId="<%=(String) currentdateList.get(2)%>";
			    	}else{
			    		dateId+= ","+"<%=(String) currentdateList.get(2)%>";
			    	}
					<%}%>
				}
	<%		
			}
		}
	}else{
	%>
		if( $GetEle("field<%=dateFieldId%>")!=null){
			dateFieldValue= $GetEle("field<%=dateFieldId%>").value;
			if(dateFieldValue.indexOf("-")>0){
				var dateFieldValueArray = dateFieldValue.split("-") ;
				if(dateFieldValueArray.length>=3){
					//yearId=dateFieldValueArray[0];
					//monthId=dateFieldValueArray[1];
					dateId=dateFieldValueArray[2];
				}
			}
		}
	<%}%>

<%
	if(currentdateList.size()>=1){
%>
	    if(yearId==""||yearId<=0){
	        yearId=<%=(String)currentdateList.get(0)%>;
        }
<%
	}
%>
<%
	if(currentdateList.size()>=2){
%>
	    if(monthId==""||monthId<=0){
	        monthId=<%=(String)currentdateList.get(1)%>;
        }
<%
	}
%>
<%
	if(currentdateList.size()>=3){
%>
	    if(dateId==""||dateId<=0){
	        dateId=<%=(String)currentdateList.get(2)%>;
        }
<%
	}
%>


<%
if(fieldIdSelect.indexOf("~~wfcode~~")>-1){
	String [] fieldlist = fieldIdSelect.split("~~wfcode~~");
	if(fieldlist.length>0){
		for(int fld=0;fld < fieldlist.length;fld++){
%>	
			if( $GetEle("field<%=fieldlist[fld]%>")!=null){
				if(fieldId == ""){
					fieldId=<%=fieldlist[fld]%>;
					var fval = $GetEle("field<%=fieldlist[fld]%>").value;
					if(fval == ""){
						fval = "-1";
					}
					fieldValue= fval;
					if(fieldId == ""){
						fieldId = "-1";
					}
				}else{
					<%if(fieldlist[fld].equals(""))
						fieldlist[fld] = "-1";
					%>
					fieldId+=","+<%=fieldlist[fld]%>;
					var fval = $GetEle("field<%=fieldlist[fld]%>").value;
					if(fval == ""){
						fval = "-1";
					}
					fieldValue+=","+fval;
				}
				
			}else{
				if(fieldId == ""){
					fieldId = "-1";
					fieldValue = "-1";
				}else{
					fieldId = ","+"-1";
					fieldValue = ","+"-1";
				}
			}
<%		
		}
	}
}else{
%>
	if( $GetEle("field<%=fieldIdSelect%>")!=null){
		<%if(fieldIdSelect.equals(""))
			fieldIdSelect = "-1";
		%>
		var fval = $GetEle("field<%=fieldIdSelect%>").value;
		if(fval == ""){
			fval = "-1";
		}
		fieldId=<%=fieldIdSelect%>;
		fieldValue= fval;
	}else{
		fieldId = "-1";
		fieldValue = "-1";
	}
<%}%>


<%
if(supSubCompanyFieldId.indexOf("~~wfcode~~")>-1){
	String [] supsublist = supSubCompanyFieldId.split("~~wfcode~~");
	if(supsublist.length>0){
		for(int supsubld=0;supsubld < supsublist.length;supsubld++){
%>	
			if( $GetEle("field<%=supsublist[supsubld]%>")!=null){
				if(supSubCompanyId == ""){
					supSubCompanyId= $GetEle("field<%=supsublist[supsubld]%>").value;
				}else{
					supSubCompanyId+=","+$GetEle("field<%=supsublist[supsubld]%>").value;
				}
			}else{
				if(supSubCompanyId == ""){
					supSubCompanyId="-1";
				}else{
					supSubCompanyId+=",-1";
				}
			}
<%		
		}
	}
}else{
%>
	if( $GetEle("field<%=supSubCompanyFieldId%>")!=null){
		supSubCompanyId= $GetEle("field<%=supSubCompanyFieldId%>").value;
	}
	if(supSubCompanyId==""||supSubCompanyId==0){
	    supSubCompanyId="-1";
	}
<%}%>
	


<%
if(subCompanyFieldId.indexOf("~~wfcode~~")>-1){
	String [] subcomlist = subCompanyFieldId.split("~~wfcode~~");
	if(subcomlist.length>0){
		for(int subcomld=0;subcomld < subcomlist.length;subcomld++){
%>
			if( $GetEle("field<%=subcomlist[subcomld]%>")!=null){
				if(subCompanyId == ""){
					subCompanyId= $GetEle("field<%=subcomlist[subcomld]%>").value;
				}else{
					subCompanyId+=","+$GetEle("field<%=subcomlist[subcomld]%>").value;
				}
			}else{
				if(subCompanyId == ""){
					subCompanyId="-1";
				}else{
					subCompanyId+=",-1";
				}
			}
<%		
		}
	}
}else{
%>
	if( $GetEle("field<%=subCompanyFieldId%>")!=null){
		subCompanyId= $GetEle("field<%=subCompanyFieldId%>").value;
	}
	if(subCompanyId==""||subCompanyId==0){
	    subCompanyId="-1";
	}
<%}%>


<%
if(departmentFieldId.indexOf("~~wfcode~~")>-1){
	String [] deptlist = departmentFieldId.split("~~wfcode~~");
	if(deptlist.length>0){
		for(int deptld=0;deptld < deptlist.length;deptld++){
%>
			if( $GetEle("field<%=deptlist[deptld]%>")!=null){
				if(departmentId == ""){
					departmentId= $GetEle("field<%=deptlist[deptld]%>").value;
				}else{
					departmentId+= ","+$GetEle("field<%=deptlist[deptld]%>").value;
				}
			}else{
				if(departmentId == ""){
					departmentId="-1";
				}else{
					departmentId+=",-1";
				}
			}
<%		
		}
	}
}else{
%>
	if( $GetEle("field<%=departmentFieldId%>")!=null){
		departmentId= $GetEle("field<%=departmentFieldId%>").value;
	}
	if(departmentId==""||departmentId==0){
	    departmentId="-1";
	}
<%}%>
}

function onCreateCodeAgain(){

	try{
		oPopup.hide();
	}catch(e){
	}

	var ismand=1;
	if($G("field<%=fieldCode%>")!=null){
        initDataForWorkflowCode();
        document.all("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&operation=CreateCodeAgain&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand;
	}
}
function onCreateCodeAgainReturn(newCode,ismand){

		if(typeof(newCode)!="undefined"&&newCode!=""){
			$G("field<%=fieldCode%>").value=newCode;

			if(parent.$G("requestmarkSpan")!=null){
				$G("requestmarkSpan", parent.document).innerText=newCode;
			}

	        var fieldCodeRow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=fieldCode%>_1_1");
	        if(fieldCodeRow>0){
		        var fieldCodeCol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=fieldCode%>_1_1");
		        if(fieldCodeCol>0){
					document.frmmain.ChinaExcel.SetCellVal(fieldCodeRow,fieldCodeCol,newCode);
					imgshoworhide(fieldCodeRow,fieldCodeCol);
					frmmain.ChinaExcel.RefreshViewSize();
		        }
	        }
		}
}

function onChooseReservedCode(){

	try{
		oPopup.hide();
	}catch(e){
	}

	var ismand=1;

	if($G("field<%=fieldCode%>")!=null){
        initDataForWorkflowCode();
        url=uescape("/workflow/workflow/showChooseReservedCodeOperate.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&createrdepartmentid="+createrdepartmentid);	

	    con = window.showModalDialog("/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&url="+url);

		if(typeof(con)!="undefined"&&con!=""){
			var idanname = con.id+"~~wfcodecon~~"+con.name;
			document.all("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&operation=chooseReservedCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&codeSeqReservedIdAndCode="+encodeURI(idanname)+"&ismand="+ismand+"&createrdepartmentid="+createrdepartmentid;	
		}	
	}

}

function onNewReservedCode(){

	try{
		oPopup.hide();
	}catch(e){
	}

    initDataForWorkflowCode();
    url=uescape("/workflow/workflow/showNewReservedCodeOperate.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&createrdepartmentid="+createrdepartmentid);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&url="+url);

}

function uescape(url){
    return escape(url);
}
window.setTimeout("requestimport()",1000);
	 
function requestimport() {
		var key =  "<%=userid%>"+"_"+"<%=requestid%>"+"requestimport"
		var requestimport = getCookie(key);
		var tempS = "<%=trrigerdetailfield%>";
	if(requestimport=="1") {
		<%
			if(trrigerdetailfield!=null && !trrigerdetailfield.trim().equals("")) {
       %>	
	   if(window.confirm('是否触发字段联动? ')) {
		    var allid="";
			jQuery('input[id^="'+tempS+'_"').each(function () {
				allid =allid+this.id+","
			});
			allid =allid.substring(0,allid.length-1)
			 datainputd(allid);
	   }
		<%
			}
       %>	
	}
	setCookie(key,"0",1);
}
   
	
function setCookie(cname,cvalue,exdays)
{
  var d = new Date();
  d.setTime(d.getTime()+(exdays*24*60*60*1000));
  var expires = "expires="+d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}
 
function getCookie(cname)
{
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) 
  {
    var c = ca[i].trim();
    if (c.indexOf(name)==0) return c.substring(name.length,c.length);
  }
  return "";
}	

function getSelectFieldid(fieldid_temp){
	var result = '';
	jQuery.ajax({
	    url: "/workflow/request/FieldFileUploadAjax.jsp?src=getSelectField&fieldid="+fieldid_temp+"&wfid=<%=workflowid%>&requestid=<%=requestid%>",
	    dataType: "text", 
		type:"post",
		async:false,
	    contentType : "charset=gbk", 
	    error:function(ajaxrequest){}, 
	    success:function(data){
	    	result = jQuery.trim(data);
	    }  
	}); 
	return result;
}
</script>