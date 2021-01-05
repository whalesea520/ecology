
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@page import="weaver.matrix.MatrixUtil"%>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
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
<%
if(!HrmUserVarify.checkUserRight("SubCompanyDefineInfo1:SubMaintain1", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
int scopeId = 4;
String message =Util.null2String(request.getParameter("message"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
}

var dialog = null;
var isSaved = false;
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
  oCell.innerHTML = "<input type=checkbox name=chkisuse checked><input type=hidden name=isuse >" ;
	
	oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<input type=checkbox name=chkismand><input type=hidden name=ismand >";
  
    oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<input type=checkbox name=chkisfixed><input type=hidden name=isfixed >";
    							
  oCell = oRow.insertCell(-1);
  var rowIdx = jQuery("#tabfield tr").length;
	oCell.innerHTML = "<input class=InputStyle  name=\"filedorder\"  type=\"text\" value=\""+rowIdx+"\" style=\"width: 40px\">";
	oCell.style.display='none';
	
	jQuery("body").jNice();
	jQuery("#tabfield").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#tabfield").find("select").selectbox();
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
     jQuery(".ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
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
		if(index==0)return;
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

function onSave(obj)
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
	if(checkform()&& !isSaved){
		isSaved = true;
		jQuery(obj).css({"background-color":"#03a996","color":"#ffffff"});
		jQuery(obj).attr("disabled","disabled");
		jQuery("#method").val("edit");
		frmMain.submit();
  }
}

function checkform()
{
	if(!check_form(document.frmMain,"fieldname,fieldlabel"))return false;
	var fieldnames = document.getElementsByName("fieldname");
	
	var fieldhtmltypes = document.getElementsByName("fieldhtmltype");
	for(var i=0;fieldhtmltypes!=null&&i<fieldhtmltypes.length;i++){
		var trObj =jQuery(fieldhtmltypes[i]).parent().parent();
		if(fieldhtmltypes[i].value=="5"){
			var selectObjvalue = trObj.find("select[name=selectOption]").val();
			if(selectObjvalue==""){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83869,82455",user.getLanguage())%>");
				return false;
			}
		}
	}
	
	var array = new Array();
	var idx = 0;
	for(var i=0;fieldnames!=null&&i<fieldnames.length;i++){
		if(fieldnames[i].value!="")array[idx++]=fieldnames[i].value;
	}
	
	var array=array.sort();
	for(var i=0;i<array.length;i++){
	 if (array[i]==array[i+1]){
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83470,user.getLanguage())%>!<br><%=SystemEnv.getHtmlLabelName(24647,user.getLanguage())%>："+array[i]);
	  return false;
	 }
	}

	var fieldlabels = document.getElementsByName("fieldlabel");
	var array = new Array();
	var idx = 0;
	for(var i=0;fieldlabels!=null&&i<fieldlabels.length;i++){
		if(fieldlabels[i].value!="")array[idx++]=fieldlabels[i].value;
	}
	
	var array=array.sort();
	for(var i=0;i<array.length;i++){
	 if (array[i]==array[i+1]){
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83381,user.getLanguage())%>!<br><%=SystemEnv.getHtmlLabelName(24647,user.getLanguage())%>："+array[i]);
	  return false;
	 }
	}
	
	return true;
}


jQuery(function(){
	$("#tabfield").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	jQuery("#accounttype").bind('click',function(){
		if(jQuery(this).attr("checked")){
			changeCheckboxStatus(jQuery("#belongto"),true);
		}else{
			changeCheckboxStatus(jQuery("#belongto"),false);
		}
	})
	jQuery("#belongto").bind('click',function(){
		if(jQuery(this).attr("checked")){
			changeCheckboxStatus(jQuery("#accounttype"),true);
		}else{
			changeCheckboxStatus(jQuery("#accounttype"),false);
		}
	})
});

var trObj = "";
function addItemDialog(obj,item_id,select_name){
	trObj=jQuery(obj).parent().parent();
	var selectObj = trObj.find("select[name=selectOption] option");
	var alloption = "";
	jQuery(selectObj).each(function(){
		var val = jQuery(this).val();
		var txt = jQuery(this).text();
		var node = val+","+txt;
		alloption += "|"+node;
	});
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=EditHrmCustomFieldSelect&id=<%=scopeId%>&item_id="+item_id+"&alloption="+alloption+"&select_name"+select_name;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height = 500;
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
		var selectitemvalue = resultData.selectitemvalue;
		var selectitemid = resultData.selectitemid;
		jQuery(selectObj).append("<option value='"+selectitemid+"'>"+selectitemvalue+"</option>"); 
		jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemid' type=hidden value='"+selectitemid+"'>");
		jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemvalue' type=hidden value='"+selectitemvalue+"'>");
	}
	jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemid' type=hidden value='--'>");
	jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemvalue' type=hidden value=''>");
	jQuery(tdobj).find("div[id=selectItems]").append(" <input name=flength type=hidden  value=100><input name=definebroswerType type=hidden  value=emptyVal>");

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
			jQuery(this).parent().parent().parent().remove();
		});
		//jQuery("#delfieldids").val(delfields);
		//改成ajax删除
		if(delfields!=""){
	   	jQuery.ajax({
				url:"subcompanyFieldOperation.jsp",
				type:"POST",
				async:true,
				data:{
					method:"delete",
					scopeId:"4",
					delfieldids:delfields
				},
				success:function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
				}
			});
		}
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
		//jQuery(trObj).find("td:first").next().empty().html("<input class=InputStyle name='fieldname' type='text' style='width: 100px' onchange='hrmCheckinput(this);'><SPAN><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' name='fieldid' value=''>");
		//jQuery(trObj).find("td:first").next().next().empty().html("<input  class=InputStyle name='fieldlabel' style='width: 100px' onchange='hrmCheckinput(this);'><SPAN><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>");
		jQuery(jQuery(trObj).find("td").get(7)).empty().html("<input type=checkbox name=chkisuse checked><input type=hidden name=isuse >");
		jQuery(jQuery(trObj).find("td").get(8)).empty().html("<input type=checkbox name=chkismand><input type=hidden name=ismand >");
        jQuery(jQuery(trObj).find("td").get(9)).empty().html("<input type=checkbox name=chkisfixed><input type=hidden name=isfixed >");
		jQuery("#tabfield").append($(trObj));
		jQuery("body").jNice();
		jQuery("#tabfield").find("select").each(function(){
			beautySelect(this);
		});
		
	});
}

function jsChkAll(obj){
	$("input[name='fieldChk']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	}); 
}

function formUseCheckAll(checked) {
  jQuery("#frmMain").find("input[name=chkffuse]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
  jQuery("#frmMain").find("input[name=chkisuse]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
}

function formMandCheckAll(checked) {
  jQuery("#frmMain").find("input[name=chkismand]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
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
function checkinput_char_num_self(obj)
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

function changeFieldLabel(obj){
	jQuery(obj).parent().find("input[name=fieldlabelid]").val("");
}

function BrowserTypeChange(obj){
	//alert("BrowserTypeChange==obj.selectedIndex===" + obj.selectedIndex); 66 67 
	if(obj.selectedIndex == 66 || obj.selectedIndex == 67 ){
		jQuery(obj).parents("tr")[0].cells[5].innerHTML=jQuery("#ftype7").html();
	}
	
	jQuery("#tabfield").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#tabfield").find("select").selectbox();
}
</script>
</head>
<%
int formid = Util.getIntValue(request.getParameter("formid"),0);
String qname = Util.null2String(request.getParameter("flowTitle"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141, user.getLanguage())+SystemEnv.getHtmlLabelName(17088, user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(60, user.getLanguage());
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
		<input class=InputStyle name="fieldname" type="text" style="width: 100px" onchange='checkKey(this);checkinput_char_num_self(this);hrmCheckinput(this);'>
		<SPAN><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		<input type="hidden" name="fieldid" value="">
	</div>
	<div style="DISPLAY: none" id="flable">
		<input  class=InputStyle name="fieldlabel" style="width: 100px" onchange='hrmCheckinput(this);'>
		<input type="hidden" name="fieldlabelid" value="">
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
		   	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())||("256".equals(BrowserComInfo.getBrowserid()))||("257".equals(BrowserComInfo.getBrowserid()))){
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
	</div>
	
	<div style="DISPLAY: none" id="ftype5">
	  <%=SystemEnv.getHtmlLabelName(608,user.getLanguage()) %>:
		<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:80px" >
		<input name=definebroswerType type=hidden  value="emptyVal">
	</div>
	
	<div style="DISPLAY: none" id="ftype6">
		<select size=1 name=type style="width:80px" notBeauty=true>
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
			<!-- 
			<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>		
			 -->
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
	</div>
	
	<div style="DISPLAY: none" id="fgroupid">
	  <select name="groupid" notBeauty=true>
			<%  
			HrmDeptFieldManager hfm = new HrmDeptFieldManager(scopeId);
			 List lsGroup = hfm.getLsGroup();
	   	 for(int tmp=0;lsGroup!=null&&tmp<lsGroup.size();tmp++){
	   		String tmpgroupid = (String)lsGroup.get(tmp);
	     	int grouplabel = Integer.parseInt(HrmGroupComInfo.getLabel(tmpgroupid));
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
	<input type=button value=<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %> class=e8_btn_top onclick="addItemDialog(this,'','')" style="width: 80px">
</div>

<div style="DISPLAY: none" id="fselectoptionview">
	<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>:
	<select class='InputStyle' style='width:70px' name='selectOption' notBeauty=true>
		<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
	</select>
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
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id="frmMain" name="frmMain" action="subcompanyFieldOperation.jsp" method="post" >
	<input type="hidden" id="method" name="method" value="edit">
	<input type="hidden" id="delfieldids" name="delfieldids" value=>
	<input type="hidden" id="scopeId" name="scopeId" value="<%=scopeId %>">
	<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="position:fixed;z-index:99!important;">
		<colgroup>   
	  	<col width="7%">
	  	<col width="13%">
	  	<col width="13%">
	  	<col width="10%">
	  	<col width="10%">
	  	<col width="14%">
	  	<col width="13%">
	  	<col width="7%">
	  	<col width="7%">
        <col width=6%">
  	</colgroup>
	  <TR class="header">                                
	  	<td><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></td>
	  	<td><%=SystemEnv.getHtmlLabelNames("15024,685",user.getLanguage())%></td>
	  	<td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
	  	<td><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
	  	<td></td>
	  	<td></td>
	  	<td><%=SystemEnv.getHtmlLabelName(30127,user.getLanguage())%></td>
	  	<td><input type="checkbox" name="checkalluse" onClick="formUseCheckAll(checkalluse.checked)" value="ON">
	  		<%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%>
	  	</td>
	  	<td><input type="checkbox" name="checkallmand" onClick="formMandCheckAll(checkallmand.checked)" value="ON">
	  		<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>
	  	</td>
        <td>现有字段</td>
 		</tr>
	</TABLE>
	<TABLE id="tabfield" CLASS="ListStyle" valign="top" cellspacing=1 style="table-layout: fixed;z-index:1!important;">
	  <colgroup>
	  	<col width="7%">
	  	<col width="13%">
	  	<col width="13%">
	  	<col width="10%">
	  	<col width="10%">
	  	<col width="14%">
	  	<col width="13%">
	  	<col width="7%">
	  	<col width="7%">
        <col width="6%">
	  </colgroup>
	    	<tr><td colspan="10"></td></tr>
  <%
		lsGroup = hfm.getLsGroup();
    int idx = 0;
    boolean canDel = false;
    for(int i=0;lsGroup!=null&&i<lsGroup.size();i++){
    	String groupid = (String)lsGroup.get(i);
    	List lsField = hfm.getLsField(groupid);
    	if(lsField.size()==0)continue;
    	for(int j=0;lsField!=null&&j<lsField.size();j++){
    		String fieldid = (String)lsField.get(j);
	    	String issystem = HrmFieldComInfo.getIssystem(fieldid);
	    	String fieldname = HrmFieldComInfo.getFieldname(fieldid);
	    	boolean isUsed = false;
	    	if(issystem.equals("1")){
	    		isUsed = true;
	    	}else{
	    		isUsed = hfm.getIsUsed(fieldid,fieldname);
	    	}
	    	String fieldlabel = HrmFieldComInfo.getLabel(fieldid);
	    	String fieldfdbtype = HrmFieldComInfo.getFielddbtype(fieldid);
	    	String fieldhtmltype = HrmFieldComInfo.getFieldhtmltype(fieldid);
	    	String fieldtype = HrmFieldComInfo.getFieldType(fieldid);
	    	String fielddmlurl = HrmFieldComInfo.getFieldDmlurl(fieldid);
	    	String fieldstrlength = hfm.getStrLength(fieldfdbtype,fieldhtmltype,fieldtype);
	    	String allowhide = HrmFieldComInfo.getAllowhide(fieldid);
	    	String isUse = HrmFieldComInfo.getIsused(fieldid);
	    	String isMand = HrmFieldComInfo.getIsmand(fieldid);
	    	String dsporder = HrmFieldComInfo.getDsporder(fieldid);
	    	//判断人力资源类型 字段是否通过矩阵被流程引用
	    	boolean isUsed_ = false;
			if(fieldtype.equals("1") || fieldtype.equals("17")){
	    		isUsed_ = MatrixUtil.isUsed(fieldname,"1");
	    		if(isUsed_)isUsed = isUsed_;
	    	}
    %>
    <tr class="DataLight">
  	<td>
  		<%if(isUsed||issystem.equals("1")){%>
  			<input name="fieldChk" type="checkbox" value="<%=idx++%>" disabled="disabled">
  		<%}else{ %><input name="fieldChk" type="checkbox" value="<%=idx++%>"><%} %>
  		<img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />
  	</td>
  	<td><%=fieldname%>
  		<input type="hidden" name="fieldname" value="<%=fieldname%>" >
  	</td>
    <td>
    	<%if(issystem.equals("1")) {%>
    	<%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%>
    	<input type="hidden" name="fieldlabel" value="<%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%>">
    	<input type="hidden" name="fieldlabelid" value="<%=Integer.parseInt(fieldlabel)%>">
    	<%}else{ %>
    	<input  class=InputStyle name="fieldlabel" value="<%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%>" onchange='hrmCheckinput(this);changeFieldLabel(this);' style="width: 100px">
			<input type="hidden" name="fieldlabelid" value="<%=Integer.parseInt(fieldlabel)%>">
			<SPAN>
			<%if(fieldlabel.equals("")) {%>
			    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			<%}%>
		  </SPAN>
		  <%} %>
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
    </td>
    <%}else if(fieldhtmltype.equals("3")){%>
    	<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(fieldtype),0),user.getLanguage())%>
      <input name=type type="hidden" value="<%=fieldtype%>">
    </td>
    <td>
     <%if("emptyVal".equals(fielddmlurl) || "".equals(fielddmlurl)){%>
				<input name=definebroswerType type=hidden  value="emptyVal">
        <%}else{
        out.println(getName(fielddmlurl));
		     %>
	            <input name=definebroswerType type=hidden value="<%=fielddmlurl%>">
        <%}%>
        <input name=flength type=hidden  value="100">&nbsp;
    </td>
    <%}else if(fieldhtmltype.equals("6")){%>
			<%=fieldtype.equals("1")?SystemEnv.getHtmlLabelName(20798,user.getLanguage()):SystemEnv.getHtmlLabelName(20001,user.getLanguage()) %>
    <input name=type type="hidden" value="<%=fieldtype%>">
		</td>
		<td>
		    <input name=flength type=hidden  value="100">
		    <input name=definebroswerType type=hidden  value="emptyVal">
		    &nbsp;
		</td>
		<%}else if(fieldhtmltype.equals("5")){%>
        <input name=type type=hidden  value="0">
		<%if(!issystem.equals("1") ){
			String sql = "select DISTINCT  p.selectitemname selectitemname from hrm_selectitem h,mode_selectitempage p  where h.detailid=p.id and h.fieldid = "+fieldid;
			RecordSet.executeSql(sql);
			String selectName ="";
			if(RecordSet.next()){
				selectName=RecordSet.getString("selectitemname");
			}
		%>
        <input type=button value=<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %> class=e8_btn_top onclick="addItemDialog(this,'<%=fieldid %>','<%=selectName %>')" style="width: 95px">

		<%}%>
        </td>
        <td >
      <%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>:
      <select class='InputStyle' style='width:70px' name='selectOption' >
     <%
		  	hfm.getSelectItem(fieldid); 
        while(hfm.nextSelect()){
     %>
 					<option value="<%=hfm.getSelectValue()%>"><%=hfm.getSelectName()%></option>
     <%}%>
     	</select>
     		<div id="selectItems">
     		  <%
     		 		hfm.toFirstSelect();
     		 		hfm.getSelectItem(fieldid); 
     		  	while(hfm.nextSelect()){
		     %>
     			<input name='selectitemid' type=hidden value='<%=hfm.getSelectValue()%>'>
					<input name='selectitemvalue' type=hidden value='<%=hfm.getSelectName()%>'>
					<%} %>
					  <input name=selectitemid type=hidden value="--">
            <input name=selectitemvalue type=hidden >
            <input name=flength type=hidden  value="100">
            <input name=definebroswerType type=hidden  value="emptyVal">
     		</div>
        </td>
    <%}else{%>
            <input name=type type=hidden  value="0">
        </td>
        <td>
            <input name=flength type=hidden  value="100">
            <input name=definebroswerType type=hidden  value="emptyVal">
            &nbsp;
        </td>
    <%}%>
    <td>
    	<select name="groupid">
    	<%
    	 for(int tmp=0;lsGroup!=null&&tmp<lsGroup.size();tmp++){
    		String tmpgroupid = (String)lsGroup.get(tmp);
      	int grouplabel = Integer.parseInt(HrmGroupComInfo.getLabel(tmpgroupid));
    	%>
    	<option value="<%=tmpgroupid %>" <%=groupid==tmpgroupid?"selected":""%>><%=SystemEnv.getHtmlLabelName(grouplabel ,user.getLanguage()) %></option>
    	<%} %>
    	</select>
    </td>
        <td>
            <input type=checkbox name=chkisuse <%=allowhide.equals("1") && !isUsed_?"":"disabled" %> <%=isUse.equals("1")?"checked":""%> >
            <input type=hidden name=isuse  value="<%=isUse %>" >
        </td>
        <td>
        		<input type=checkbox name=chkismand  <%=allowhide.equals("1")?"":"disabled" %> <%=isMand.equals("1")?"checked":""%> >
            <input type=hidden name=ismand  value="<%=isMand %>" >
        </td>
        <td>
            <input type=checkbox name=chkisfixed disabled>
            <input type=hidden name=isfixed  value="0" >
        </td>
        
        <td style="display: none">
  				<input class="InputStyle" name="filedorder" type="text" value="<%=dsporder%>" style="width: 40px" >
        </td>
    </tr>
    <%}}%>
    </table>
</form>
</BODY></HTML>