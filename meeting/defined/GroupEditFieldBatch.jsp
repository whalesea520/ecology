<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.*"%>
<%@page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page" />
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("Meeting:fieldDefined", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
int scopeId = Util.getIntValue(request.getParameter("scopeId"),1);
String message = Util.null2String(request.getParameter("message"));

String fieldnames=",";
RecordSet.executeQuery("select * from meeting_formfield where grouptype=?",scopeId);
while(RecordSet.next()){
	fieldnames+=RecordSet.getString("fieldname")+",";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function addRow(){
	var oRow;
	var oCell;
	oRow = jQuery("#tabfield")[0].insertRow(-1);
	oRow.className="DataLight";
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = "<input name=fieldChk type=checkbox value=''>&nbsp;<img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />" ;

	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#fname").html();
		
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#flable").html();
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#fhtmltype").html();
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#ftype1").html() ;
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#ftype5").html() ;
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#fgroupid").html() ;
		
	oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<input type=checkbox name=chkisuse checked onclick='changeIsmand(this)'><input type=hidden name=isuse >" ;
	
	oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<input type=checkbox name=chkismand onclick='changeIsuse(this)'><input type=hidden name=ismand >";
  
  oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<input type=checkbox name=chkisfixed ><input type=hidden name=isfixed >";
    							
  oCell = oRow.insertCell(-1);
  var rowIdx = jQuery("#tabfield tr").length;
	oCell.innerHTML = "<input class=InputStyle  name=\"filedorder\"  type=\"hidden\" value=\""+rowIdx+"\" style=\"width: 40px\">";
	//oCell.style.display='none';
	
	jQuery("body").jNice();
	jQuery("#tabfield").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#tabfield").find("select").selectbox();
	sortOrderTitle();
	document.getElementById('footer').scrollIntoView();
}
function htmltypeChange(obj){
	var celltype = jQuery(obj).parents("tr")[0].cells[4];
	var celllenth = jQuery(obj).parents("tr")[0].cells[5];
	if(obj.selectedIndex == 0){
		celltype.innerHTML=jQuery("#ftype1").html() ;
		celllenth.innerHTML=jQuery("#ftype5").html() ;
	}else if(obj.selectedIndex == 2){
		celltype.innerHTML=jQuery("#ftype2").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html() ;
	}else if(obj.selectedIndex == 4){
		celltype.innerHTML=jQuery("#fselectaction").html() ;
		celllenth.innerHTML=jQuery("#fselectoptionview").html() ;
	}else if(obj.selectedIndex == 5){
		celltype.innerHTML=jQuery("#ftype6").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html();
	}else{
		celltype.innerHTML=jQuery("#ftype3").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html();
	}
	jQuery("#tabfield").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#tabfield").find("select").selectbox();
}

jQuery(document).ready(function(){
 registerDragEvent();
 <%if(message.equals("1")){%>
 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
<%}else if(message.equals("-1")){%>
window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>");
<%}else if(message.equals("-2")){%>
 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>现有字段不存在！");
 <%}else if(message.equals("-3")){%>
window.top.Dialog.alert("保存现有字段出错，字段类型不一致！");
<%}%>
})
function registerDragEvent(){
	 var fixHelper = function(e, ui) {
	    ui.children().each(function() {  
	      jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
	      jQuery(this).height("30px");						//在CSS中定义为30px,目前不能动态获取
	    });  
	    return ui;  
    }; 
     jQuery("#tabfield tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
         helper: fixHelper,                  //调用fixHelper  
         axis:"y",  
         start:function(e, ui){
         	 ui.helper.addClass("moveMousePoint");
           ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
           if(ui.item.hasClass("notMove")){
           	e.stopPropagation();
           }
           $(".hoverDiv").css("display","none");
           return ui;  
         },  
         stop:function(e, ui){
             //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
             jQuery(ui.item).hover(function(){
            	jQuery(this).addClass("e8_hover_tr");
            },function(){
            	jQuery(this).removeClass("e8_hover_tr");
            	
            });
            jQuery(ui.item).removeClass("moveMousePoint");
            sortOrderTitle();
            return ui;  
         }  
     });  
}

function sortOrderTitle()
{
	jQuery("#tabfield tbody tr").each(function(index){
		//if(index==0)return;
		jQuery(this).find("input[name=filedorder]").val(index);
	})
}

function typeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parents("tr")[0].cells[5].innerHTML=jQuery("#ftype5").html();
	}else{
		jQuery(obj).parents("tr")[0].cells[5].innerHTML=jQuery("#ftype4").html();
	}
	
	jQuery("#tabfield").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#tabfield").find("select").selectbox();
}

function clearTempObj(){
  jQuery("#rowSource").html("");
}

function showSelectRow(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp");
	if (data!=null){
        return data.id;
	}else{
        return "";
	}
}

function onSave()
{
	var chkisuses = document.getElementsByName("chkisuse");
	var chkismands = document.getElementsByName("chkismand");
    var chkisfixeds = document.getElementsByName("chkisfixed");
	var chkffuses = document.getElementsByName("chkffuse");
	var isuses = document.getElementsByName("isuse");
	var ismands = document.getElementsByName("ismand");
    var isfixeds = document.getElementsByName("isfixed");
	var ffuses = document.getElementsByName("ffuse");

	for(var i=0;i< chkisuses.length;i++)
	{	
		if(chkisuses[i].checked)
			isuses[i].value=1;
		else
			isuses[i].value=0;
		
		if(chkismands[i].checked)
			ismands[i].value=1;
		else
			ismands[i].value=0;

        if(chkisfixeds[i].checked){
            isfixeds[i].value=1;
        }
        else{
            isfixeds[i].value=0;
        }
	}
	
	for(var i=0;i< chkffuses.length;i++)
	{
		if(chkffuses[i].checked)
			ffuses[i].value=1;
		else
			ffuses[i].value=0;
	}
	if(checkform()){
		jQuery("#method").val("edit");
		frmMain.submit();
  }
}

function checkform()
{
    //判断浏览按钮模式下的自定义浏览按钮
	if(!check_form(document.frmMain,"fieldname,fieldlabel,definebroswerType,treebroswerType"))return false;
	var fieldlabels = document.getElementsByName("fieldlabel");
	var array = new Array();
	var idx = 0;
	for(var i=0;fieldlabels!=null&&i<fieldlabels.length;i++){
		if(fieldlabels[i].value!="")array[idx++]=fieldlabels[i].value;
	}
	
	var array=array.sort();
	for(var i=0;i<array.length;i++){
		var count=0;
		 for(var j=0;j<array.length;j++)
            {
                if (array[i] == array[j]) {
                    count++;//计算与当前这个元素相同的个数
                    if(count>1){
                    	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83381,user.getLanguage())%>");
	 					 return false;
                    }
                }
            }
	}
	//检测新添加字段是否已存在于数据库中
	var dbFieldNames="<%=fieldnames%>";
	var fieldnames = document.getElementsByName("fieldname");
	//判断和原有字段是否重复
	for(var i=0;fieldnames!=null&&i<fieldnames.length;i++){
		if(dbFieldNames.indexOf(","+fieldnames[i].value+",")>-1&&fieldnames[i].className=='InputStyle'){
			fieldnames[i].value="";
			jQuery(fieldnames[i]).siblings("span").html("<IMG src=/images/BacoError_wev8.gif align=absMiddle>");
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83470,user.getLanguage())%>");
	 		return false;
		}
		//判断和新加字段是否有重复
		var count=0;
		for(var j=0;j<fieldnames.length;j++)
            {
                if (fieldnames[i].value == fieldnames[j].value) {
                    count++;//计算与当前这个元素相同的个数
                    if(count>1){
		                 fieldnames[j].value="";
		                 jQuery(fieldnames[j]).siblings("span").html("<IMG src=/images/BacoError_wev8.gif align=absMiddle>");
                    	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83470,user.getLanguage())%>");
	 					 return false;
                    }
                }
            }
	}
	return true;
}


jQuery(function(){
	$("#tabfield").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
});

var trObj = "";
function addItemDialog(obj,item_id){
	trObj=jQuery(obj).parent().parent();
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/meeting/defined/commonTab.jsp?_fromURL=InfoFieldSelect&item_id="+item_id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height = 400;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function setSelectOption(resultDatas){
	var selectObj = trObj.find("select[name=selectOption]");
	var tdobj = trObj.find("td").get(5);
	jQuery(selectObj).empty();
	jQuery(selectObj).selectbox("detach");
	jQuery(tdobj).find("div[id=selectItems]").empty();
		
	for(var i=0;i<resultDatas.length;i++){
		var resultData = resultDatas[i];
		var selectitemvalue = resultData[0].selectitemvalue;
		var selectitemid = resultData[1].selectitemid;
		jQuery(selectObj).append("<option value='"+selectitemid+"'>"+selectitemvalue+"</option>"); 
		jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemid' type=hidden value='"+selectitemid+"'>");
		jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemvalue' type=hidden value='"+selectitemvalue+"'>");
	}
	jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemid' type=hidden value='--'>");
	jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemvalue' type=hidden value=''>");
	jQuery(tdobj).find("div[id=selectItems]").append(" <input name=flength type=hidden  value=100>");
	jQuery(tdobj).find("div[id=selectItems]").append(" <input name=definebroswerType type=hidden  value='emptyVal'>");
	jQuery(tdobj).find("div[id=selectItems]").append(" <input name=treebroswerType type=hidden  value='emptyVal'>");

	jQuery(selectObj).selectbox();
}

function doDel(){
	var chkobj = $("input:checked[name='fieldChk']");
	if(chkobj.length<=0)
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
  	return false;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		var delfields = ""
		$("input:checked[name='fieldChk']").each(function(){
			var delfieldid = jQuery(this).parent().parent().parent().find("input[name=fieldid]").val();
			if(delfields.length>0)delfields+=",";
			delfields+=delfieldid;
		});
		jQuery("#delfieldids").val(delfields);
		jQuery("#method").val("delete");
  	frmMain.submit();
	});
}

function copyRow()
{
	if($("input:checked[name='fieldChk']").length<=0)
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31433,user.getLanguage())%>");
  	return false;
	}
	var chkObj = jQuery("input:checked[name='fieldChk']");
	chkObj.each(function(){
		var fromTrObj = jQuery(this).parent().parent().parent();
		jQuery(fromTrObj).find("select").each(function(){
			jQuery(this).selectbox("detach");
		});
		var trObj = fromTrObj.clone();
		jQuery(trObj).find("td:first").empty().html("<input name=fieldChk type=checkbox value=''>&nbsp;<img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />");
		jQuery(trObj).find("td:first").next().empty().html("<input class=InputStyle name='fieldname' type='text' style='width: 100px' onchange='hrmCheckinput(this);'><SPAN><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' name='fieldid' value=''>");
		jQuery(trObj).find("td:first").next().next().empty().html("<input  class=InputStyle name='fieldlabel' style='width: 100px' onchange='hrmCheckinput(this);'><SPAN><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>");
		jQuery(jQuery(trObj).find("td").get(7)).empty().html("<input type=checkbox name=chkisuse checked onclick='changeIsmand(this)'><input type=hidden name=isuse >");
		jQuery(jQuery(trObj).find("td").get(8)).empty().html("<input type=checkbox name=chkismand onclick='changeIsuse(this)'><input type=hidden name=ismand >");
        jQuery(jQuery(trObj).find("td").get(9)).empty().html("<input type=checkbox name=chkisfixed ><input type=hidden name=isfixed >");
		jQuery("#tabfield").append($(trObj));
		jQuery("body").jNice();
		jQuery("#tabfield").find("select").each(function(){
			beautySelect(this);
		});
		
	});
}

function jsChkAll(obj){
	$("input[name='fieldChk']").each(function(){
		changeCheckboxStatus123(this,obj.checked);
	}); 
}

function formUseCheckAll(checked) {
  jQuery("#frmMain").find("input[name=chkffuse]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
  jQuery("#frmMain").find("input[name=chkisuse]").each(function(){
  	changeCheckboxStatus123(this,checked);
  });
  jQuery("#frmMain").find("input[name=chkisuse]").each(function(){
  	changeIsmand(this);
  });
  if(!checked){
  	$("#checkallmand").attr("checked",false).next().removeClass("jNiceChecked");
  }
  
}

function formMandCheckAll(checked) {
  jQuery("#frmMain").find("input[name=chkismand]").each(function(){
  	changeCheckboxStatus123(this,checked);
  });
   jQuery("#frmMain").find("input[name=chkismand]").each(function(){
  	changeIsuse(this);
  });
  if(checked){
  	$("#checkalluse").attr("checked",true).next().addClass("jNiceChecked");
  }
}

function changeCheckboxStatus123(obj,checked){
	if(!$(obj).attr("disabled")){
		changeCheckboxStatus(obj,checked);
	}
}
	function checkKey(obj){
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
		var fname=obj.value;
		if (fname!=""){
			fname=","+fname.toUpperCase()+",";
			if (keys.indexOf(fname)>0){
				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
				obj.value="";
				return false;
			}
		}
		return true;
	}
	
// 判断input框中是否输入的是英文字母和数字，并且以字母开头
function checkinput_char_num_new(obj)
{
	valuechar = obj.value.split("") ;
	if(valuechar.length==0){
	    return ;
	}
	notcharnum = false ;
	notchar = false ;
	notnum = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		notchar = false ;
		notnum = false ;
		charnumber = parseInt(valuechar[i]) ; if(isNaN(charnumber)) notnum = true ;
		if((valuechar[i].toLowerCase()<'a' || valuechar[i].toLowerCase()>'z')&&valuechar[i]!='_') notchar = true ;
		if(notnum && notchar) notcharnum = true ;
	}
	if(valuechar[0].toLowerCase()<'a' || valuechar[0].toLowerCase()>'z') notcharnum = true ;
	if(notcharnum) obj.value = "" ;
}

function BrowserTypeChange(obj){
	var selectVal=jQuery(obj).val();
	if(selectVal == 161 || selectVal == 162 ){
		jQuery(obj).parents("tr")[0].cells[5].innerHTML=jQuery("#ftype7").html();
	}else if(selectVal == 256 || selectVal == 257 ){
		jQuery(obj).parents("tr")[0].cells[5].innerHTML=jQuery("#ftype8").html();
	}else{
		jQuery(obj).parents("tr")[0].cells[5].innerHTML=jQuery("#ftype4").html(); 
	}
	
	jQuery("#tabfield").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#tabfield").find("select").selectbox();
}

function changeIsmand(obj){
	
    var ckbox = $(obj);
    var flag = ckbox.attr("checked");
    if(flag){
        return;
    }else{
    	if(ckbox.closest("tr").find(":checkbox").eq(0).attr("name") == "fieldChk"){
    		ckbox.closest("tr").find(":checkbox").eq(2).attr("checked",false).next().removeClass("jNiceChecked");
    	}else{
    		ckbox.closest("tr").find(":checkbox").eq(1).attr("checked",false).next().removeClass("jNiceChecked");
    	}
    }
}

function changeIsuse(obj){
    var ckbox = $(obj);
    var flag = ckbox.attr("checked");
    if(flag){
    	if(ckbox.closest("tr").find(":checkbox").eq(0).attr("name") == "fieldChk"){
    		ckbox.closest("tr").find(":checkbox").eq(1).attr("checked",true).next().addClass("jNiceChecked");
    	}else{
    		ckbox.closest("tr").find(":checkbox").eq(0).attr("checked",true).next().addClass("jNiceChecked");
    	}
    	
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15449, user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel();,_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:copyRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="rowSource">
	<div style="DISPLAY: none" id="flchk"><input name="fieldChk" type="checkbox" value=""></div>
	<div style="DISPLAY: none" id="fname">
		<input class=InputStyle name="fieldname" type="text" style="width: 100px" onchange='checkKey(this);checkinput_char_num_new(this);hrmCheckinput(this);'>
		<SPAN><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		<input type="hidden" name="fieldid" value="">
	</div>
	<div style="DISPLAY: none" id="flable">
		<input  class=InputStyle name="fieldlabel" style="width: 100px" onchange='hrmCheckinput(this);'>
		<SPAN><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
	</div>
	<div style="DISPLAY: none" id="fhtmltype">
		<select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)" style="width: 95px" notBeauty=true>
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
			<option value="2" ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
			<option value="3" ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
			<option value="4" ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
			<option value="5" ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
			<option value="6" ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
	  </select>
	</div>
	
	<div style="DISPLAY: none" id="ftype1">
		<select size=1 name=type onChange = "typeChange(this)" style="width: 80px" notBeauty=true>
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
		</select>
	</div>
	
	<div style="DISPLAY: none" id="ftype2">
		<select size=1 name=type style="width: 95px" notBeauty=true onChange = "BrowserTypeChange(this)" >
	    <%while(BrowserComInfo.next()){
		   	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
		        	 //屏蔽集成浏览按钮-zzl
				continue;
				}
	    %>
			<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
	    <%}%>
		</select>
	</div>
	
	<div style="DISPLAY: none" id="ftype3">
		<input name=type type=hidden value="0">&nbsp;
	</div>
	
	<div style="DISPLAY: none" id="ftype4">
		<input name=flength type=hidden  value="100">&nbsp;
		<input name=definebroswerType type=hidden  value="emptyVal">
		<input name=treebroswerType type=hidden  value="emptyVal">
	</div>
	
	<div style="DISPLAY: none" id="ftype5">
	  <%=SystemEnv.getHtmlLabelName(608,user.getLanguage()) %>:
		<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:80px" >
		<input name=definebroswerType type=hidden  value="emptyVal">
		<input name=treebroswerType type=hidden  value="emptyVal">
	</div>
	
	
	<div style="DISPLAY: none" id="ftype6">
		<select size=1 name=type style="width:80px" notBeauty=true>
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
		</select>
	</div>
	
	
	<div style="DISPLAY: none" id="ftype7">
		<brow:browser width="150px" viewType="0" name="definebroswerType"
			    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
			    completeUrl="/data.jsp"
				hasInput="false" isSingle="true"
				isMustInput="2"
				browserDialogWidth="550px"
				browserDialogHeight="650px"></brow:browser>
		<input name=flength type=hidden  value="100">
		<input name=treebroswerType type=hidden  value="emptyVal">
	</div>	
	<div style="DISPLAY: none" id="ftype8">
		<brow:browser width="150px" viewType="1" name="treebroswerType"
			    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
			    completeUrl="/data.jsp"
				hasInput="false" isSingle="true"
				isMustInput="2"
				hasBrowser="true" 
				browserDialogWidth="550px"
				browserDialogHeight="650px"></brow:browser>
		<input name=flength type=hidden  value="100">
		<input name=definebroswerType type=hidden  value="emptyVal">
	</div>
	
	<div style="DISPLAY: none" id="fgroupid">
	  <select name="groupid" notBeauty=true>
			<%  
			MeetingFieldManager mfm = new MeetingFieldManager(scopeId);
			 List lsGroup = mfm.getLsGroup();
	   	 for(int tmp=0;lsGroup!=null&&tmp<lsGroup.size();tmp++){
	   		String tmpgroupid = (String)lsGroup.get(tmp);
	     	int grouplabel = Integer.parseInt(MeetingFieldGroupComInfo.getLabel(tmpgroupid));
	  	%>
	  	<option value="<%=tmpgroupid %>"><%=SystemEnv.getHtmlLabelName(grouplabel ,user.getLanguage()) %></option>
	  	<%} %>
	  </select>
</div>

<div style="DISPLAY: none" id="fisuse">
 	<input type=checkbox name=chkisuse checked="checked">
  <input type=hidden name=isuse >
</div>

<div style="DISPLAY: none" id="fismand">
	<input type=checkbox name=chkismand >
  <input type=hidden name=ismand >
</div>

<div style="DISPLAY: none" id="fisfixed">
    <input type=checkbox name=chkisfixed >
  <input type=hidden name=isfixed >
</div>

<div style="DISPLAY: none" id="fselectaction">
	<input name=type type=hidden  value="0">
	<input type=button value=<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %> class=e8_btn_top onclick="addItemDialog(this,'')" style="width: 80px">
</div>

<div style="DISPLAY: none" id="fselectoptionview">
	<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>:
	<select class='InputStyle' style='width:70px' name='selectOption' notBeauty=true>
		<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
	</select>
	<input name=flength type=hidden  value="100">
	<input name=definebroswerType type=hidden  value="emptyVal">
	<input name=treebroswerType type=hidden  value="emptyVal">
	<div id="selectItems">
	</div>
</div>
<div style="DISPLAY: none" id="action">
  <input class=InputStyle  name="filedorder"  type="text" value="" style="width: 40px">
</div>
</div>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="addRow();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="copyRow();" value="<%=SystemEnv.getHtmlLabelName(77, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id="frmMain" name="frmMain" action="GroupFieldOperation.jsp" method="post" >
	<input type="hidden" id="method" name="method" value="edit">
	<input type="hidden" id="delfieldids" name="delfieldids" value=>
	<input type="hidden" id="scopeId" name="scopeId" value="<%=scopeId %>">
	<div class="table-head" style="height:34px;">
	<table class="ListStyle ListStyleMove" valign="top" border=0 style="position:fixed;z-index:99!important;padding: 0px !important;width:100%">
		  <colgroup>
		  	<col width="7%">
		  	<col width="12%">
		  	<col width="13%">
		  	<col width="10%">
		  	<col width="10%">
		  	<col width="10%">
		  	<col width="15%">
		  	<col width="7%">
		  	<col width="7%">
            <col width="6%">
		  	<col width="1%">
		  </colgroup>
		<thead>
		<TR class=header valign="top">
	  	<th><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></th>
	  	<th><%=SystemEnv.getHtmlLabelNames("15024,685",user.getLanguage())%></th>
	  	<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></th>
	  	<th ><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></th>
	  	<th >&nbsp;</th>
	  	<th >&nbsp;</th>
	  	<th><%=SystemEnv.getHtmlLabelName(30127,user.getLanguage())%></th>
	  	<th><input type="checkbox" id="checkalluse" name="checkalluse" onClick="formUseCheckAll(checkalluse.checked)" value="ON">
	  		<%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%>
	  	</th>
	  	<th ><input type="checkbox" id="checkallmand" name="checkallmand" onClick="formMandCheckAll(checkallmand.checked)" value="ON">
	  		<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>
	  	</th>
        <th>现有字段</th>
	  	<th >&nbsp;</th>
	  	</TR>
	  	</thead>
	</table>
	</div>
	<div class="table-body">
	<table id="tabfield" class="ListStyle ListStyleMove"  border=0>
	  <colgroup>
	  	<col width="7%">
	  	<col width="12%">
	  	<col width="13%">
	  	<col width="10%">
	  	<col width="10%">
	  	<col width="10%">
	  	<col width="15%">
		<col width="7%">
		<col width="7%">
		<col width="6%">
	  	<col width="1%">
	  </colgroup>

  <%
		lsGroup = mfm.getLsGroup();
    int idx = 0;
    boolean canDel = false;
    for(int i=0;lsGroup!=null&&i<lsGroup.size();i++){
    	String groupid = (String)lsGroup.get(i);
    	List lsField = mfm.getLsField(groupid);
    	if(lsField.size()==0)continue;
    	for(int j=0;lsField!=null&&j<lsField.size();j++){
    		String fieldid = (String)lsField.get(j);
	    	String issystem = MeetingFieldComInfo.getIssystem(fieldid);
	    	String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
	    	boolean isUsed = false;
	    	if(issystem.equals("1")||issystem.equals("0")){
	    		isUsed = true;
	    	}else{
	    		isUsed = mfm.getIsUsed(fieldname);
	    	}
	    	String fieldlabel = MeetingFieldComInfo.getLabel(fieldid);
	    	String sysfieldlabel = MeetingFieldComInfo.getSysLabel(fieldid);
	    	String fieldfdbtype = MeetingFieldComInfo.getFielddbtype(fieldid);
	    	String fieldhtmltype = MeetingFieldComInfo.getFieldhtmltype(fieldid);
	    	String fieldtype = MeetingFieldComInfo.getFieldType(fieldid);
	    	String fieldstrlength = mfm.getStrLength(fieldfdbtype,fieldhtmltype,fieldtype);
	    	String allowhide = MeetingFieldComInfo.getAllowhide(fieldid);
	    	String isUse = MeetingFieldComInfo.getIsused(fieldid);
	    	String isMand = MeetingFieldComInfo.getIsmand(fieldid);
	    	String dsporder = MeetingFieldComInfo.getDsporder(fieldid);
    %>
    <tr class="DataLight">
  	<td>
  		<%if(isUsed||issystem.equals("1")||issystem.equals("0")){
  			if(issystem.equals("1")||issystem.equals("0")){
  				idx++;
  			}else{
  		%>
  			<input name="fieldChk" type="checkbox" value="<%=idx++%>" disabled="disabled">
  		<%}
  		}else{ %><input name="fieldChk" type="checkbox" value="<%=idx++%>"><%} %>
  		<img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />
  	</td>
  	<td>
  		<%=fieldname%>
  		<input type="hidden" name="fieldname" value="<%=fieldname%>" >
  	</td>
    <td>
    	<%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%>
    	<input type="hidden" name="fieldlabel" value="<%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%>">
    	<input  type="hidden" name="fieldid" value="<%=fieldid%>" >
    </td>
    <td>
    	<%=fieldhtmltype.equals("1")?""+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"":"" %>
    	<%=fieldhtmltype.equals("2")?""+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"":"" %>
    	<%=fieldhtmltype.equals("3")?""+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"":"" %>
    	<%=fieldhtmltype.equals("4")?""+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"":"" %>
    	<%=fieldhtmltype.equals("5")?""+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"":"" %>
    	<%=fieldhtmltype.equals("6")?""+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"":""%>
    	<input name="fieldhtmltype" type="hidden" value="<%=fieldhtmltype%>" >
    </td>
    <td>
	    <%if(fieldhtmltype.equals("1")){%>
	   		<%=fieldtype.equals("1")?""+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"":""%>
	   		<%=fieldtype.equals("2")?""+SystemEnv.getHtmlLabelName(696,user.getLanguage())+"":""%>
	   		<%=fieldtype.equals("3")?""+SystemEnv.getHtmlLabelName(697,user.getLanguage())+"":""%>
	    <input name=type type="hidden" value="<%=fieldtype%>">
    </td>
    <td>
        <%if(fieldtype.equals("1")){%>
        	<%=SystemEnv.getHtmlLabelName(608,user.getLanguage()) %>:<%=fieldstrlength%>
          <input  name=flength type=hidden value="<%=fieldstrlength%>">
        <%}else{%>
            <input name=flength type=hidden  value="100">
        <%}%>
        <input name=definebroswerType type=hidden  value="emptyVal">
        <input name=treebroswerType type=hidden  value="emptyVal">
    </td>
    <%}else if(fieldhtmltype.equals("3")){%>
    	<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(fieldtype),0),user.getLanguage())%>
      <input name=type type="hidden" value="<%=fieldtype%>">
    </td>
    <td>
    <%	
    String fieldshowname="";
    if(fieldhtmltype.equals("3")&&(fieldtype.equals("256")||fieldtype.equals("257"))){
    	rs.execute("select treename from mode_customtree where id="+fieldfdbtype);
    	if(rs.next()){
    		fieldshowname=rs.getString("treename");
    	}
    }else if(fieldhtmltype.equals("3")&&(fieldtype.equals("161")||fieldtype.equals("162"))){
    	//rs.execute("select treename from mode_custombrowser where id="+fieldfdbtype);
    	try{
	    	Browser browser=(Browser) StaticObj.getServiceByFullname(fieldfdbtype, Browser.class);
	    	fieldshowname=browser.getName();
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	
    	if(fieldshowname.equals("")){
    		fieldshowname=fieldfdbtype.split("\\.")[1];
    	}
    }
    %>
    	<%=(fieldtype.equals("162")||fieldtype.equals("161"))?""+fieldshowname+"":""%>
    	<%=(fieldtype.equals("256")||fieldtype.equals("257"))?""+fieldshowname+"":""%>
        <input name=flength type=hidden  value="100">&nbsp;
        <input name=definebroswerType type=hidden  value="<%=(fieldtype.equals("162")||fieldtype.equals("161"))?""+fieldfdbtype+"":"emptyVal"%>">
        <input name=treebroswerType type=hidden  value="<%=(fieldtype.equals("256")||fieldtype.equals("257"))?""+fieldfdbtype+"":"emptyVal"%>">
    </td>
    <%}else if(fieldhtmltype.equals("6")){%>
			<%=fieldtype.equals("1")?SystemEnv.getHtmlLabelName(20798,user.getLanguage()):SystemEnv.getHtmlLabelName(20001,user.getLanguage()) %>
    <input name=type type="hidden" value="<%=fieldtype%>">
		</td>
		<td>
		    <input name=flength type=hidden  value="100">&nbsp;
		    <input name=definebroswerType type=hidden  value="emptyVal">
		    <input name=treebroswerType type=hidden  value="emptyVal">
		</td>
		<%}else if(fieldhtmltype.equals("5")){%>
        <input name=type type=hidden  value="0">
		<%if(!"1".equals(issystem)&&!"0".equals(issystem)){%>
        <input type=button value=<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %> class=e8_btn_top onclick="addItemDialog(this,'<%=fieldid %>')" style="width: 95px">
		<%}%>
        </td>
        <td >
      <%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>:
      <select class='InputStyle' style='width:70px' name='selectOption' >
     <% 
     	rs.executeSql("select * from meeting_selectitem where isdel=0 and fieldid=" + fieldid + " order by listorder");
     	
        while(rs.next()){
     %>
 					<option value="<%=rs.getString("selectvalue")%>"><%="".equals(rs.getString("selectlabel"))?rs.getString("selectname"):SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("selectlabel")),user.getLanguage())%></option>
     <%}%>
     	</select>
     		<div id="selectItems">
     		  <%
     		 rs.executeSql("select * from meeting_selectitem where isdel=0 and fieldid=" + fieldid + " order by listorder");
     		  	while(rs.next()){
		     %>
     			<input name='selectitemid' type=hidden value='<%=rs.getString("selectvalue")%>'>
					<input name='selectitemvalue' type=hidden value='<%="".equals(rs.getString("selectlabel"))?rs.getString("selectname"):SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("selectlabel")),user.getLanguage())%>'>
					<%} %>
					  <input name=selectitemid type=hidden value="--">
            <input name=selectitemvalue type=hidden >
            <input name=flength type=hidden  value="100">
            <input name=definebroswerType type=hidden  value="emptyVal">
            <input name=treebroswerType type=hidden  value="emptyVal">
     		</div>
        </td>
    <%}else{%>
            <input name=type type=hidden  value="0">
        </td>
        <td>
            <input name=flength type=hidden  value="100">&nbsp;
            <input name=definebroswerType type=hidden  value="emptyVal">
            <input name=treebroswerType type=hidden  value="emptyVal">
        </td>
    <%}%>
    <td>
    	<select name="groupid" <%=issystem.equals("1")?"disabled":"" %>>
    	<%
    	 for(int tmp=0;lsGroup!=null&&tmp<lsGroup.size();tmp++){
    		String tmpgroupid = (String)lsGroup.get(tmp);
      	int grouplabel = Integer.parseInt(MeetingFieldGroupComInfo.getLabel(tmpgroupid));
    	%>
    	<option value="<%=tmpgroupid %>" <%=groupid==tmpgroupid?"selected":""%>><%=SystemEnv.getHtmlLabelName(grouplabel ,user.getLanguage()) %></option>
    	<%} %>
    	</select>
    	<%if(issystem.equals("1")){
    	%>
    	<input type=hidden name="groupid"  value="<%=groupid %>" >	
    	<%}%>
    	
    </td>
        <td>
            <input type=checkbox name=chkisuse <%=allowhide.equals("1")?"":"disabled" %> <%=isUse.equals("1")?"checked":""%> onclick="changeIsmand(this)">
            <input type=hidden name=isuse  value="<%=isUse %>" >
        </td>
        <td>
        		<input type=checkbox name=chkismand  <%=allowhide.equals("1")?"":"disabled" %> <%=isMand.equals("1")?"checked":""%> onclick="changeIsuse(this)">
            <input type=hidden name=ismand  value="<%=isMand %>" >
        </td>
        <td>
            <input type=checkbox name=chkisfixed disabled>
            <input type=hidden name=isfixed  value="0" >
        </td>
        
        <td>
  				<input class="InputStyle" name="filedorder" type="hidden" value="<%=dsporder%>" style="width: 40px" >
        </td>
    </tr>
    <%}}%>
    </table>
    <a id="footer" name="footer">&nbsp;</a>
    </div>
</form>
</BODY></HTML>