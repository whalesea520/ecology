<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ page import="java.util.Map.Entry" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

<%
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int isbill = Util.getIntValue(request.getParameter("isbill"),0);
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int operatelevel=UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,"FormManage:All",formid,isbill);
	if(!HrmUserVarify.checkUserRight("FormManage:All", user) || operatelevel < 0){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>

<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/templates/default/css/default_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
	String formname="";
	String formdes="";
	String createtype = Util.null2String(request.getParameter("createtype")) ;	
	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();
	formdes = Util.StringReplace(formdes,"\n","<br>");
	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");

    ArrayList<String> detailid = new ArrayList<String>();
    ArrayList<String> detaillable = new ArrayList<String>();
    ArrayList<String> groupIds= new ArrayList<String>();
    ArrayList<String> signid = new ArrayList<String>();
    signid.add("+");
    signid.add("-");
    signid.add("*");
    signid.add("/");
    signid.add("=");
    signid.add("(");
    signid.add(")");

    ArrayList<String> signlable = new ArrayList<String>();
    signlable.add("＋");
    signlable.add("－");
    signlable.add("×");
    signlable.add("÷");
    signlable.add("＝");
    signlable.add("(");
    signlable.add(")");

    String rowcalstr = "";
    String sql = "select * from workflow_formdetailinfo where formid ="+formid;
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        rowcalstr = RecordSet.getString("rowcalstr");
        rowcalstr = rowcalstr.replaceAll("\\+","_plus_");
    }

    sql = "select t1.fieldid,t3.fieldlable,t1.groupId " +
            "from workflow_formfield t1,workflow_formdictdetail t2,workflow_fieldlable t3 " +
            "where t1.isdetail='1' " +
            "and t1.fieldid=t2.id " +
            "and t1.fieldid=t3.fieldid " +
            "and t3.formid=t1.formid " +
            "and t3.isdefault=1 " +
            "and t2.fieldhtmltype=1 " +
            "and type in (2,3,4,5) " +
            "and t1.formid=" + formid + " "+
            "order by t1.groupId asc,t1.fieldid desc";
    RecordSet.executeSql(sql);
    Hashtable<String,String> map = new Hashtable<String,String>();
    List<String> listtable = new ArrayList<String>();
    while(RecordSet.next()){
    	if(null==map.get(RecordSet.getString("groupId"))){
    	    listtable.add(RecordSet.getString("groupId"));
    		map.put(RecordSet.getString("groupId"),"opList.options[i++] = new Option('','');\n");
    	}
        detailid.add(RecordSet.getString("fieldid"));
        detaillable.add(RecordSet.getString("fieldlable"));
        groupIds.add(RecordSet.getString("groupId"));
        String option = "opList.options[i++] = new Option('"+RecordSet.getString("fieldlable")+"','"+RecordSet.getString("fieldid")+"');";
        map.put(RecordSet.getString("groupId"),map.get(RecordSet.getString("groupId"))+option+"\n");
    }
    ArrayList<Entry<String,String>> optionlist = new ArrayList<Entry<String,String>>(map.entrySet());
    session.setAttribute("signid",signid);
    session.setAttribute("signlable",signlable);
    session.setAttribute("detailid",detailid);
    session.setAttribute("detaillable",detaillable);
%>
<%
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18368,user.getLanguage());
%>
<script type="text/javascript">  
   function jsChangeBackImg(obj,imgname){
	jQuery(obj).attr("src","/images/wfrowedit/"+imgname)
   }
   function ajaxinit(){
      var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
   }
   
   function showdetaildata(){
    var ajax=ajaxinit();
    ajax.open("POST","/workflow/form/addformrowcalList.jsp",true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("rowcalstr=<%=rowcalstr%>");
    ajax.onreadystatechange = function(){
      //如果执行状态成功，那么就把返回信息写到指定的层里
     if(ajax.readyState == 4 && ajax.status == 200){
        try{
                document.all("detaildata").innerHTML=ajax.responseText;
                registerDragEvent();
                jQuery("body").jNice();
            }catch(e){
                return false;
            }
     }
    }
   }
   
   function registerDragEvent(){
		 var fixHelper = function(e, ui) {
	        ui.children().each(function() {  
	            jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
	            jQuery(this).height("40");						//在CSS中定义为40px,目前不能动态获取
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
	             jQuery(".hoverDiv").css("display","none");
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
	  	var _fieldname = "";
	  	jQuery("#oTable tbody").find("tr[forsort=ON]").children("td:nth-child(2)").each(function(){
	  		if(typeof(jQuery(this).find("input[type=text][name^=itemDspName_]").val()) == "undefined")
	    			_fieldname += ","+jQuery(this).find("input[type=hidden][name^=itemDspName_]").val();
				else
					_fieldname += ","+jQuery(this).find("input[type=text][name^=itemDspName_]").val();
			
	  	});
	  	jQuery("input[type=hidden][name=sortname]").val(_fieldname);
	  }   
   
</script>
<script type="text/javascript">
var rows="";
</script>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveRole(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:rowsaveRole1(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
	if(!ajax.equals("1")){
		if(createtype.equals("2")) {
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",FormDesignMain.jsp?src=editform&formid="+formid+",_self}" ;
		}
		else {
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
		}
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="rowcalfrm" method="post" action="/workflow/form/formrole_operation.jsp" >
<input type="hidden" value="rowcalrole" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=createtype%>" name="createtype">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" name="curindex" id="curindex" value="0">
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel>0){%>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:rowsaveRole1()">
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>

<wea:layout type="2col">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item attributes="{'colspan':'2','isTableList':'true'}">
		     <span id="span_checks0" style="display:inline-block;margin:5px 30px;">
				<select id="detailtableid" name = "detailtableid" style="width:100px" onchange="doChangeFieldIds(this)">
				    <%
				     int index = 0;
				    if(listtable.size()>0){
                        for(int i =0;i<listtable.size();i++){
                            index++;
				     %>
				       <option value="<%=listtable.get(i)%>"><%=(SystemEnv.getHtmlLabelName(19325,user.getLanguage())+index)%></option>
				    <%}
				     }
				    %>
				</select>
				<select id="detailfieldid" name = "detailfieldid" style="width:180px" onchange="autowire(this)">
					<option></option>
				</select>
      		</span>
      </wea:item>
      <wea:item attributes="{'colspan':'2','isTableList':'true'}">
        <div style="word-break:break-all; word-wrap:break-all;margin-left: 30px;width:70%;height:200x;border:2px solid #A0BBF6;">
           <table style="margin:2px;" align="center" height="96%" width="99%">
              <colgroup>
                 <col width="70%">
                 <col width="30%">
              </colgroup>
              <tr>
                <td>
                   <div style="height:180px;width：100%;border:1px solid #11111;">
		    	     <span id="rowcalexp" style="width：100%;font-size: 15px; display:inline-block;word-wrap:break-word;"></span>
		           </div>
                </td>
                <td>
                   <table style="height:100%;width: 100%;">
                     <colgroup>
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                     </colgroup>
                     <tr>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="7" style="vertical-align: middle;" src="/images/wfrowedit/7normal_wev8.png" onmouseover="jsChangeBackImg(this,'7hot_wev8.png')" onmouseout="jsChangeBackImg(this,'7normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="8" style="vertical-align: middle;" src="/images/wfrowedit/8normal_wev8.png" onmouseover="jsChangeBackImg(this,'8hot_wev8.png')" onmouseout="jsChangeBackImg(this,'8normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="9" style="vertical-align: middle;" src="/images/wfrowedit/9normal_wev8.png" onmouseover="jsChangeBackImg(this,'9hot_wev8.png')" onmouseout="jsChangeBackImg(this,'9normal_wev8.png')" >
                       </td>
                       <td>
	                       <a href="#" accessKey="+" onclick="addexp(this)">
			      				<img alt="+" src="/images/wfrowedit/+normal_wev8.png" onmouseover="jsChangeBackImg(this,'+hot_wev8.png')" onmouseout="jsChangeBackImg(this,'+normal_wev8.png')"/>
			      		   </a>    
                       </td>
                       <td>
	                       <a href="#" accessKey="-" onclick="addexp(this)">
			      				<img alt="-" src="/images/wfrowedit/-normal_wev8.png" onmouseover="jsChangeBackImg(this,'-hot_wev8.png')" onmouseout="jsChangeBackImg(this,'-normal_wev8.png')"/>
			      		   </a> 
                       </td>
                     </tr>
                     <tr>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="4" style="vertical-align: middle;" src="/images/wfrowedit/4normal_wev8.png" onmouseover="jsChangeBackImg(this,'4hot_wev8.png')" onmouseout="jsChangeBackImg(this,'4normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="5" style="vertical-align: middle;" src="/images/wfrowedit/5normal_wev8.png" onmouseover="jsChangeBackImg(this,'5hot_wev8.png')" onmouseout="jsChangeBackImg(this,'5normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="6" style="vertical-align: middle;" src="/images/wfrowedit/6normal_wev8.png" onmouseover="jsChangeBackImg(this,'6hot_wev8.png')" onmouseout="jsChangeBackImg(this,'6normal_wev8.png')" >
                       </td>
                       <td>
	                       <a href="#" accessKey="*" onclick="addexp(this)">
		      					<img alt="*" src="/images/wfrowedit/xnormal_wev8.png" onmouseover="jsChangeBackImg(this,'xhot_wev8.png')" onmouseout="jsChangeBackImg(this,'xnormal_wev8.png')"/>
			  				</a>
                       </td>
                       <td>
	                       <a href="#" accessKey="/" onclick="addexp(this)">
			      				<img alt="%" src="/images/wfrowedit/chu_normal_wev8.png" onmouseover="jsChangeBackImg(this,'chu_hot_wev8.png')" onmouseout="jsChangeBackImg(this,'chu_normal_wev8.png')"/>
			      		   </a> 
                       </td>
                     </tr>     
                     <tr>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="1" style="vertical-align: middle;" src="/images/wfrowedit/1normal_wev8.png" onmouseover="jsChangeBackImg(this,'1hot_wev8.png')" onmouseout="jsChangeBackImg(this,'1normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="2" style="vertical-align: middle;" src="/images/wfrowedit/2normal_wev8.png" onmouseover="jsChangeBackImg(this,'2hot_wev8.png')" onmouseout="jsChangeBackImg(this,'2normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="3" style="vertical-align: middle;" src="/images/wfrowedit/3normal_wev8.png" onmouseover="jsChangeBackImg(this,'3hot_wev8.png')" onmouseout="jsChangeBackImg(this,'3normal_wev8.png')" >
                       </td>
                       <td>
	                       <a href="#" accessKey="(" onclick="addexp(this)">
			      				<img alt="(" src="/images/wfrowedit/(normal_wev8.png" onmouseover="jsChangeBackImg(this,'(hot_wev8.png')" onmouseout="jsChangeBackImg(this,'(normal_wev8.png')"/>
			      		   </a>    
                       </td>
                       <td>
	                       <a href="#" accessKey=")" onclick="addexp(this)">
			      				<img alt=")" src="/images/wfrowedit/)normal_wev8.png" onmouseover="jsChangeBackImg(this,')hot_wev8.png')" onmouseout="jsChangeBackImg(this,')normal_wev8.png')"/>
			      		   </a> 
                       </td>
                     </tr>     
                     <tr>
                      <td>
                       <img onclick="addcalnumber_1(this)" name="0" style="vertical-align: middle;" src="/images/wfrowedit/0normal_wev8.png" onmouseover="jsChangeBackImg(this,'0hot_wev8.png')" onmouseout="jsChangeBackImg(this,'0normal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="addcalnumber_1(this)" name="." style="vertical-align: middle;" src="/images/wfrowedit/dotnormal_wev8.png" onmouseover="jsChangeBackImg(this,'dothot_wev8.png')" onmouseout="jsChangeBackImg(this,'dotnormal_wev8.png')" >
                       </td>
                       <td>
                       <img onclick="removeexp()" alt="B-<%=SystemEnv.getHtmlLabelName(18744,user.getLanguage())%>" style="vertical-align: middle;" src="/images/wfrowedit/rightarrowpointnormal_wev8.png" onmouseover="jsChangeBackImg(this,'rightarrowpointhot_wev8.png')" onmouseout="jsChangeBackImg(this,'rightarrowpointnormal_wev8.png')">
                       </td>
                       <td colspan="2">
	                       <a href="#" accessKey="=" onclick="addexp(this)">
			      				<img alt="=" src="/images/wfrowedit/=normal_wev8.png" onmouseover="jsChangeBackImg(this,'=hot_wev8.png')" onmouseout="jsChangeBackImg(this,'=normal_wev8.png')"/>
			      		   </a>    
                       </td>
                     </tr>                 
                   </table>
                </td>
              </tr>
           </table>
        </div>
      </wea:item>
      <wea:item attributes="{'colspan':'2','isTableList':'true'}">
         <span style="margin:5px 30px;display: inline-block;"><%=SystemEnv.getHtmlLabelName(125033,user.getLanguage())%></span>
      </wea:item>
  </wea:group>
  <wea:group context='<%=SystemEnv.getHtmlLabelName(33312,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input Class=addbtn type=button accessKey=A onclick="addRowCal()" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
			<input Class=delbtn type=button accessKey=B onclick="deleteBatch()" title="B-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input> 
		</wea:item>
		<wea:item attributes="{'colspan':'4'}">
			  <div id="detaildata">
				<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
				<script type="text/javascript">showdetaildata();</script>
			   </div>
		</wea:item>   	
    </wea:group>    
  
</wea:layout>
</form>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function saveRole(){
    rowcalfrm.submit();
}

var fieldid = new Array();
var fieldlable = new Array();
var viewLines = new Array();
var curindex = 0;
var currowcalexp = "";
var groups="";
var deleteLines = 0;
var deleteLines_sq = 0;
function addexp(obj){	
    fieldid[curindex]=obj.accessKey;	
	fieldlable[rowcurindex]=obj.accessKey;
    curindex++;
    refreshcal();
}
function removeexp(){
    curindex --;
    if(curindex<0){
        curindex = 0;
    }
    refreshcal();
}

function refreshcal(){
    top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("354,345",user.getLanguage()) %>');
    currowcalexp = "";
    document.all("rowcalexp").innerHTML="";
    for(var i=0; i<curindex; i++){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15323, user.getLanguage())%>"+i+"<%=SystemEnv.getHtmlLabelName(27591, user.getLanguage())%>:"+fieldlable[i]);
        currowcalexp+=fieldid[i];
         if(fieldlable[i]=="+"){
             fieldlable[i] = "+";
        }else if(fieldlable[i]=="-"){
             fieldlable[i] = "-";
        }else if(fieldlable[i]=="*"){
             fieldlable[i] = "×";
        }else if(fieldlable[i]=="%"){
             fieldlable[i] = "÷";
        }else if(fieldlable[i]=="("){
             fieldlable[i] = "(";
        }else if(fieldlable[i]==")"){
             fieldlable[i] = ")";
        }else if(fieldlable[i]=="="){
             fieldlable[i] = "=";
        }
        document.all("rowcalexp").innerHTML+=fieldlable[i];
    }
}

function addRowCal(){
    if(currowcalexp==""){
        return;
    }
    
    var error_msg = "<%=SystemEnv.getHtmlLabelName(27783,user.getLanguage())%>"; 
    
    //------------------------------------------
    // 表达式check开始
    //------------------------------------------
    var equalsIndex = currowcalexp.indexOf("=");
    if (equalsIndex < 0) {
    	top.Dialog.alert(error_msg);
    	return;
    }
    //等于号之前的内容
    var calexpEqa_bef = currowcalexp.substring(0, equalsIndex);
    //等于号之后的内容
    var calexpEqa_aft = currowcalexp.substring(equalsIndex+1, currowcalexp.length);
	//赋值语句之前必须指定一个变量
	if (calexpEqa_bef.indexOf("detailfield_") == -1) {
		top.Dialog.alert(error_msg);
		return;
	}
    
    calexpEqa_bef = calexpEqa_bef.replace("detailfield_", "");
    //赋值语句之前指定了过多的变量
    if (calexpEqa_bef.indexOf("detailfield_") != -1) {
    	top.Dialog.alert(error_msg);
		return;
    }
    //第一个等号之前不能含有操作符
    var symbols = ["+", "-", "*", "/", "(", ")"];
    for (var i=0; i<symbols.length; i++) {
    	var symbol = symbols[i];
    	if (calexpEqa_bef.indexOf(symbol) != -1) {
    		top.Dialog.alert(error_msg);
			return;
    	}
    }
    
    calexpEqa_aft = calexpEqa_aft.replace(new RegExp("detailfield_" ,"gm"), "");
    try {
    	if (isNaN(eval("("+calexpEqa_aft+")"))) {
    		top.Dialog.alert(error_msg);
    		return;
    	}
    } catch (e) {
    	top.Dialog.alert(error_msg);
    	return;
    }
    //------------------------------------------
    // 表达式check结束
    //------------------------------------------
    
    oRow = allcalexp.insertRow(-1);
    oRow.style.background= "#efefef";

     oDiv = document.createElement("div");
     oCell = oRow.insertCell(-1);
     var sHtml = "<input type='checkbox' name='chkInTableTa' onclick='chkCheck(this)' >";                
     oDiv.innerHTML = sHtml;
     jQuery(oCell).append(oDiv);


    oCell = oRow.insertCell(-1);
    oCell.style.color="red";
    var oDiv = document.createElement("div");
    var sHtml = $GetEle("rowcalexp").innerHTML+"<input type='hidden' name='calstr' value='"+currowcalexp+"'>";
    sHtml += "<a href='#' onclick='deleteRowcal(this)' style='float:right;'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
    oDiv.innerHTML = sHtml;
    jQuery(oCell).append(oDiv);
    clearexp();
}

function clearexp(){
    currowcalexp = "";
    groups="";
    curindex=0;
	fieldid = new Array();
	fieldlable = new Array();	
    document.getElementById("rowcalexp").innerHTML="";	
	document.getElementById("curindex").value=curindex;	
}

function deleteRowcal(obj){
    //alert(obj.parentElement.parentElement.parentElement.rowIndex);
   	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>", function (){
   		allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
	}, function () {}, 320, 90,true);
    //if(confirm('<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>')){
    //    allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
    //}
}

function addcalnumber(){
    var calnumber = prompt('<%=SystemEnv.getHtmlLabelName(18689,user.getLanguage())%>',"1.0");
    if(calnumber!=null){
        fieldid[curindex]=calnumber;
        fieldlable[curindex]=calnumber;
        curindex++;
        refreshcal();
    }
}

function addcalnumber_1(obj){
    var calnumber =obj.name;
    if(calnumber != "."){
       if (isNaN(calnumber)){
    	   top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>");
		return;
	}
    }
    if(calnumber!=null){
        fieldid[rowcurindex]=calnumber;
        fieldlable[rowcurindex]=calnumber;
        rowcurindex++;

        refreshcal();
    }
}

function chkCheck(obj){
      deleteLines_sq = jQuery(obj).parent().parent().parent()[0].rowIndex;
	  if(jQuery("input:checkbox").eq(deleteLines_sq).attr("checked")== true){
	    viewLines[deleteLines] = deleteLines_sq;
	    deleteLines ++ ;
	  }else{
	    for(var i=0; i<deleteLines; i++){
	       if(viewLines[i] == deleteLines_sq){
	         viewLines[i] = " ";
	       }
	    }
	  }
}

function deleteBatch(){
      var deleteArray = new Array();
	  var deleterow = rows.split(",");
      for(var i=deleterow.length-1; i>=0;i--){
           if(deleterow[i] != ""){
           	  deleteArray.push(deleterow[i]);
           }
      }
      deleteArray.sort();
      var length = deleteArray.length;
      for(var i = 0;i<length;i++){
         allcalexp.deleteRow(deleteArray.pop());
      }
      rows="";
}	
</script>
<%}else{%>
<script type="text/javascript">
var fieldid = new Array();
var fieldlable = new Array();
var viewLines = new Array();
var rowcurindex = 0;
var currowcalexp = "";
var deleteLines = 0;
var deleteLines_sq = 0;

//行计算
function rowsaveRole(){
     rowcalfrm.submit();
}

function rowsaveRole1(){
	clearexp();
    rowsaveRole();
}

function clearexp(){
    currowcalexp = "";
    rowcurindex = 0;
    document.getElementById("rowcalexp").innerHTML="";
}

function addexp(obj){
    var tempval = obj.accessKey;
    fieldid[rowcurindex]=tempval;
    //if("+-*/()=".indexOf(obj.accessKey)==-1){
    //    fieldlable[rowcurindex]="<span style='color:#000000'>"+obj.innerHTML+"</span>";
    //}else{
    //    fieldlable[rowcurindex]=obj.innerHTML;
    //}
    if(tempval=="\/")
    	tempval = "÷";
    fieldlable[rowcurindex]=tempval;
    rowcurindex++;

    refreshcal();

}

function refreshcal(){
    currowcalexp = "";
    document.all("rowcalexp").innerHTML="";
    for(var i=0; i<rowcurindex; i++){
        currowcalexp+=fieldid[i];
        if(fieldlable[i]=="+"){
             fieldlable[i] = "+";
        }else if(fieldlable[i]=="-"){
             fieldlable[i] = "-";
        }else if(fieldlable[i]=="*"){
             fieldlable[i] = "×";
        }else if(fieldlable[i]=="%"){
             fieldlable[i] = "÷";
        }else if(fieldlable[i]=="("){
             fieldlable[i] = "(";
        }else if(fieldlable[i]==")"){
             fieldlable[i] = ")";
        }else if(fieldlable[i]=="="){
             fieldlable[i] = "=";
        }
        document.all("rowcalexp").innerHTML+=fieldlable[i];
    }
}

function addcalnumber_1(obj){
    var calnumber =obj.name;
    if(calnumber != "."){
       if (isNaN(calnumber)){
    	   top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>");
		return;
	}
    }
    if(calnumber!=null){
        fieldid[rowcurindex]=calnumber;
        fieldlable[rowcurindex]=calnumber;
        rowcurindex++;

        refreshcal();
    }
}
function addcalnumber(){
    var calnumber = prompt("<%=SystemEnv.getHtmlLabelName(18689, user.getLanguage())%>","1.0");
    if (isNaN(calnumber)){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>");
		return;
	}
    if(calnumber!=null){
        fieldid[rowcurindex]=calnumber;
        fieldlable[rowcurindex]=calnumber;
        rowcurindex++;

        refreshcal();
    }
}

function removeexp(){
    rowcurindex --;
    if(rowcurindex<0){
        rowcurindex = 0;
    }
    refreshcal();
}

function addRowCal(){
    if(currowcalexp==""){
        return;
    }
    var error_msg = "<%=SystemEnv.getHtmlLabelName(27783,user.getLanguage())%>"; 
    
    //------------------------------------------
    // 表达式check开始
    //------------------------------------------
    var equalsIndex = currowcalexp.indexOf("=");
    if (equalsIndex < 0) {
    	top.Dialog.alert(error_msg);
    	return;
    }
    //等于号之前的内容
    var calexpEqa_bef = currowcalexp.substring(0, equalsIndex);
    //等于号之后的内容
    var calexpEqa_aft = currowcalexp.substring(equalsIndex+1, currowcalexp.length);
	//赋值语句之前必须指定一个变量
	if (calexpEqa_bef.indexOf("detailfield_") == -1) {
		top.Dialog.alert(error_msg);
		return;
	}
    
    calexpEqa_bef = calexpEqa_bef.replace("detailfield_", "");
    //赋值语句之前指定了过多的变量
    if (calexpEqa_bef.indexOf("detailfield_") != -1) {
    	top.Dialog.alert(error_msg);
		return;
    }
    //第一个等号之前不能含有操作符
    var symbols = ["+", "-", "*", "/", "(", ")"];
    for (var i=0; i<symbols.length; i++) {
    	var symbol = symbols[i];
    	if (calexpEqa_bef.indexOf(symbol) != -1) {
    		top.Dialog.alert(error_msg);
			return;
    	}
    }
    
    calexpEqa_aft = calexpEqa_aft.replace(new RegExp("detailfield_" ,"gm"), "");
    try {
    	if (isNaN(eval("("+calexpEqa_aft+")"))) {
    		top.Dialog.alert(error_msg);
    		return;
    	}
    } catch (e) {
    	top.Dialog.alert(error_msg);
    	return;
    }
    //------------------------------------------
    // 表达式check结束
    //------------------------------------------
    oRow = jQuery("#allcalexp")[0].insertRow(-1);
    //oRow.style.background= "#efefef";

    oDiv = document.createElement("div");
    oCell = oRow.insertCell(-1);
    var sHtml = "<input type='checkbox' name='chkInTableTa' onclick='chkCheck(this)' >";
    oDiv.innerHTML = sHtml;
    jQuery(oCell).append(oDiv);
    jQuery(oRow).attr("class","DataLight"); 
    jQuery(oRow).attr("forsort","ON");
    jQuery('body').jNice();
    oCell = oRow.insertCell(-1);
    oCell.style.color="#000000";
    jQuery(oCell).attr("colspan","3");
    var oDiv = document.createElement("div");
    var sHtml = $GetEle("rowcalexp").innerHTML+"<input type='hidden' name='calstr' value='"+currowcalexp+"'>";
    sHtml += "<a href='#' onclick='deleteRowcal(this)' style='float:right;'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
    oDiv.innerHTML = sHtml;
    jQuery(oCell).append(oDiv);
    clearexp();
    registerDragEvent();
    // jQuery("body").jNice(); 
}

function assignment(obj1,obj2){
    fieldid[rowcurindex]="detailfield_"+obj1;
    fieldlable[rowcurindex]=obj2; 
    rowcurindex++;
    refreshcal();
  
}	


function deleteRowcal(obj){
    //alert(obj.parentElement.parentElement.parentElement.rowIndex);
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>", function (){
    	allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
	}, function () {}, 320, 90,true);
    //if(confirm('<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>')){
    //    allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
    //}
}
function chkCheck(obj){
       var rowindex = jQuery(obj).parent().parent().parent().parent()[0].rowIndex;
	   if(jQuery(obj).is(":checked")){
	      rows+=","+rowindex+",";
	   }else{
	      rows = rows.replace(","+rowindex+",",",");
	   }
}

function deleteBatch(){
      var deleteArray = new Array();
	  var deleterow = rows.split(",");
      for(var i=deleterow.length-1; i>=0;i--){
           if(deleterow[i] != ""){
           	  deleteArray.push(deleterow[i]);
           }
      }
      deleteArray.sort();
      var length = deleteArray.length;
      for(var i = 0;i<length;i++){
         allcalexp.deleteRow(deleteArray.pop());
      }
      rows="";
}	

 jQuery(document).ready(function(){
       var opList = window.document.forms[0].detailfieldid;
       <%
       if(optionlist.size()>0){
       	//Entry<String,String> entity2 = optionlist.get(optionlist.size()-1);
           String entityValue = "";
           for(int i=0;i<optionlist.size();i++){
               Entry<String,String> entitytemp = optionlist.get(i);
               if(entitytemp.getKey().equals(listtable.get(0))){
                   entityValue=  entitytemp.getValue();
                 break;
                 
               }
               
           }
	   %>
			    for(i = opList.length-1; i >= 0; i--) {
					if (opList.options[i] != null){
						opList.options[i] = null;
					}
			    }
			    i=0;
		       <%=entityValue%>
	    <%}	    
	    }%>
	    bindSelectDate(opList);
});
   
   function doChangeFieldIds(o){
   	   var opList = window.document.forms[0].detailfieldid;
	   var detailtablename = o.value;
	   <%
	     Set<String> nset=map.keySet();
	     Iterator nite = nset.iterator();
	     while(nite.hasNext()){
	    	String nkey =(String)nite.next();
	   %>
	        if(detailtablename == "<%=nkey%>"){
	           for(i = opList.length-1; i >= 0; i--) {
				if (opList.options[i] != null){
					opList.options[i] = null;
				}
			   }
			   i=0;
	           <%=(String)map.get(nkey)%>
	        }
	   <%
	     }
	   %>
		bindSelectDate(opList);
	}

   function autowire(o){
     var param1=o.value;
     var param2=o.options[o.selectedIndex].text;
     assignment(param1,param2);
   }
   
   function assignment(obj1,obj2){
    fieldid[rowcurindex]="detailfield_"+obj1;
    fieldlable[rowcurindex]=obj2; 
    rowcurindex++;
    refreshcal(); 
   }	
   function bindSelectDate(obj){
    jQuery(obj).selectbox("detach");
    jQuery(obj).selectbox();
   }
   
</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
</body>
</html>
