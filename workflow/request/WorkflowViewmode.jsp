
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
<script language=javascript>
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>
<%
//TD9892
String acceptlanguage = Util.null2String(request.getHeader("Accept-Language"));
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
BaseBean bb_workflowviewmode = new BaseBean();
int urm_workflowviewmode = 1;
try{
	urm_workflowviewmode = Util.getIntValue(bb_workflowviewmode.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

String requestid = Util.null2String(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String isbill = Util.null2String(request.getParameter("isbill"));
String formid = "";
RecordSet.executeSql("select formid from workflow_base where id="+workflowid);
if(RecordSet.next()) {
	formid = Util.null2String(RecordSet.getString("formid"));
}
String organizationid = "";
if("1".equals(isbill)&&"156".equals(formid)){
    RecordSet.executeSql("select fieldname,id,type,fieldhtmltype from workflow_billfield where viewtype=1 and billid="+formid);
    while(RecordSet.next()){
        if("organizationid".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            organizationid="field"+RecordSet.getString("id");
        }
    }
}
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String requestname = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"requestname"));
int isform = Util.getIntValue(request.getParameter("isform"));
int modeid = Util.getIntValue(request.getParameter("modeid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
int intervenorright=Util.getIntValue(request.getParameter("intervenorright"),0);
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
     uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
     selectedfieldid = result.substring(0,result.indexOf(","));
 }    
%>

<script language=javascript src="/workflow/mode/loadmode_wev8.js"></script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        hidePopup();
        <%
        if(urm_workflowviewmode==1){
        %>
        var divBillScrollTop=0;
        if($G("divWfBill", parent.document)!=null&& $G("divWfBill", parent.document)!=undefined){
          divBillScrollTop=$G("divWfBill", parent.document).scrollTop;
        }
       showRightClickMenuByHand((frmmain.ChinaExcel.offsetLeft+frmmain.ChinaExcel.GetMousePosX()),(frmmain.ChinaExcel.offsetTop+frmmain.ChinaExcel.GetMousePosY()-divBillScrollTop));
		   <%
		   }
		   %>		
		return false;
</SCRIPT>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script language=javascript >
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
var cellvalue=frmmain.ChinaExcel.GetCellValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
	showPopup(uservalue,cellvalue,ismand,0);   
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick()"	LANGUAGE="JavaScript" >
	<%if(urm_workflowviewmode==1){%>
	hideRightClickMenu();
	<%}%>
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    var fieldname=uservalue;
    if(uservalue!=null){
        var indx=uservalue.lastIndexOf("_");
        if(indx>0){
            var addordel=uservalue.substring(indx+1);
            uservalue=uservalue.substring(0,indx);
			var uservalues =  uservalue.split("_");
            var isdetail = (uservalues.length>2)?1:0;
            
            if(addordel=="6"){
                indx=uservalue.indexOf("_");
                if(indx>0){
                    uservalue=uservalue.substring(0,indx);
                }
				if(isdetail==1){
					uservalue=uservalues[0]+"_"+uservalues[1];
				}
				
                var fieldvalue=$G(uservalue).value;
                if(fieldvalue.length>0){
                var selectfieldvalue="";
                <%
                if(!selectedfieldid.equals("")){
                %>
                if($G("field<%=selectedfieldid%>")) selectfieldvalue=$G("field<%=selectedfieldid%>").value
                <%}%>    
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&requestid=<%=requestid%>&desrequestid="+($G("desrequestid").value)+"&fieldid="+uservalue+"&isedit=0&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=750," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures) ;
                frmmain.ChinaExcel.GoToCell(1,1);
                }
            }
        }
    }
	return false;
</SCRIPT>
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
<input type=hidden name ="needcheck" value="">
<input type=hidden name ="src" value="">
<script language=javascript>
function readmode(){
    <%if(intervenorright==1){%>frmmain.ChinaExcel.style.display='none';<%}%>
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
    try{
	    var maxrow=frmmain.ChinaExcel.GetMaxRow();
	    var maxcol=frmmain.ChinaExcel.GetMaxCol();
	    var userstr="";
	    for(var i=1;i<=maxrow;i++){
	        for(var j=1;j<=maxcol;j++){
	            userstr=frmmain.ChinaExcel.GetCellUserStringValue(i,j);             
	<%if("1".equals(isbill) && "156".equals(formid)) {%>
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
    frmmain.ChinaExcel.ReCalculate()
    frmmain.ChinaExcel.FormProtect true
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
    setheight()
    frmmain.ChinaExcel.SetPasteType 1
    frmmain.ChinaExcel.GoToCell 1,1
    RefreshViewSize()    
end sub
</script>
<script language=javascript>
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

        if(temptotalwidth>0&&false){ 
        	totalwidth=totalwidth;
        	frmmain.ChinaExcel.width=totalwidth;
        	frmmain.ChinaExcel.SetShowScrollBar(0,true);
        }else{
        	frmmain.ChinaExcel.width=parent.document.body.clientWidth - 40;
        	frmmain.ChinaExcel.SetShowScrollBar(0,true);
        }
    }

window.onresize = function (){
    setheight();
	setwidth();
}
function RefreshViewSize(){
	<%if(urm_workflowviewmode==1){%>
    //rightMenu.focus();
	    try {
		    rightMenu.focus();
	    }catch(e) {
	    }
    <%}%>
    frmmain.ChinaExcel.RefreshViewSize();
}
function createDoc(fieldbodyid,docVlaue,isedit){
	
	/*
   for(i=0;i<=1;i++){ 
  		parent.document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";  	
	*/
  	frmmain.action = "RequestDocView.jsp?docView="+isedit+"&docValue="+docVlaue+"&requestid="+<%=requestid%>+"&desrequestid="+($G("desrequestid").value);
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw"; 
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文    
        document.frmmain.src.value='save';
        document.frmmain.submit();
		parent.clicktext();//切换当前tab页到正文页面
		if($G("needoutprint")) $G("needoutprint").value = "";//标识点正文
    }
}

function openWindow(urlLink){

  	window.open(urlLink);

}
function openWindowNoRequestid(urlLink){

  	window.open(urlLink);

}
</script>