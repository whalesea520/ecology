<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.cpt.util.CptFieldManager" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("cptdefinition:all", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
boolean init="1".equals( rs.getPropValue("cptsearchdef_init", "status"));
if(init){
    CptFieldManager.syncFields();
    FileWriter writer=null;
    try{
        //更新配置
        String ppath= GCONST.getPropertyPath();
        Properties pp=rs.LoadTemplateProp("cptsearchdef_init");
        pp.setProperty("status","0");
        writer=new FileWriter(new File(ppath+"cptsearchdef_init.properties"));
        pp.store(writer, "");
        writer.flush();
        writer.close();
    }catch (Exception e){

    }finally{
        try {
            if(writer!=null){
                writer.close();
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
}


String nameQuery = Util.null2String(request.getParameter("nameQuery"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
</head>
<%
int maxDisplayorder = 0;
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22366,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";



int rownum=1;
%>
<BODY style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:formreset(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmMain name=frmMain action="CptSearchDefinitionOperation.jsp" method=post>

<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="submitData()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>

<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">

<div id="detaildata" style="overflow:hidden">
			
<table class="thead ListStyle" style="position:fixed;z-index:99!important;">
    <COLGROUP>
		<col width="20%">
 	  	<col width="30%">
 	  	<col width="25%">
 	  	<col width="25%">
<thead>
<tr class=header style=""> 
  <td ><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
  <td >
    <input type="checkbox"   name="IsconditionstitleAll" id="IsconditionstitleAll" 
           onClick="" >
    <%=SystemEnv.getHtmlLabelName(22390,user.getLanguage())%>
  </td>
  <td >
    <input type="checkbox"    name="IsconditionsAll" id="IsconditionsAll"
           onClick="" >
    <%=SystemEnv.getHtmlLabelName(22392,user.getLanguage())%>
  </td>
  <td >
    <input type="checkbox"    name="IstitleAll" id="IstitleAll" 
           onClick="">
    <%=SystemEnv.getHtmlLabelName(84361,user.getLanguage())%>
  </td>
</tr>        
</thead>
</table>

<table class="tbody ListStyle" id="oTable"  style="z-index:1!important;margin-top:35px!important;">
      <colgroup>
 	  	<col width="20%">
 	  	<col width="30%">
 	  	<col width="25%">
 	  	<col width="25%">
 	  </colgroup>
        <tbody>


<%
HashMap fieldlabelmap=new HashMap<String,String>();
String sql1 = "select t1.fieldname,t2.fieldlabel from CptSearchDefinition t1 left outer join cptDefineField t2 on lower(t1.fieldname)=lower(t2.fieldname) where t1.mouldid = -1 and t2.isopen='1' ";
rs1.executeSql(sql1);
while(rs1.next()){
	fieldlabelmap.put(Util.null2String(rs1.getString("fieldname")), Util.null2String(rs1.getString("fieldlabel")));
}

String sql = "select * from CptSearchDefinition where mouldid = -1 order by displayorder ";
rs.executeSql(sql);


while(rs.next()){
	String fieldname = Util.null2String(rs.getString("fieldname"));
	String isconditionstitle = Util.null2String(rs.getString("isconditionstitle"));
	String istitle = Util.null2String(rs.getString("istitle"));
	String isconditions = Util.null2String(rs.getString("isconditions"));
	String isseniorconditions = Util.null2String(rs.getString("isseniorconditions"));
	String displayorder = Util.null2String(rs.getString("displayorder"));
	if("isdata".equals(fieldname)){
		continue;
	}else if("departmentid".equalsIgnoreCase(fieldname)){
		fieldlabelmap.put("departmentid", "21030");
	}
	int fieldlabel=Util.getIntValue((String)fieldlabelmap.get(fieldname),0);
	//if(fieldlabel<=0) continue;
	
	%>
	<TR class="<%=rownum%2==0?"DataLight":"DataDark" %>" >
      <TD>
      <img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelNames("82783",user.getLanguage())%>' />
      	 <%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="<%=fieldname %>">
      </TD>
      <td class=Field>
         <input type="checkbox"    name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox"    name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox"    name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
         <input type="hidden" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 name="displayorder_<%=rownum %>"  onblur="checknumber(this.name)" value="<%=rownum %>">
      </td>
    </TR>
	<%
	rownum++;
	
}


%>


          
        </tbody>
      </table>
      
      
</div>			
		</wea:item>
	</wea:group>
</wea:layout>



 <input name="rownum" value="<%=rownum %>" type=hidden>  
</form>
<script language="javascript">
function changecheck(rownum,flag,obj){
	
	if(flag==1){
		$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
		$GetEle("istitle_"+rownum).checked=false;
		$GetEle("isconditions_"+rownum).checked=false;
		$GetEle("displayorder_"+rownum).value="";
	}else if(flag==2){
		if(obj.checked==true){
			$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
			$GetEle("istitle_"+rownum).checked=obj.checked;
			var currentmax = parseInt(document.getElementById("currentmax").value)+1;
			document.getElementById("currentmax").value = currentmax;
			$GetEle("displayorder_"+rownum).value=currentmax;		
		}else{
			$GetEle("istitle_"+rownum).checked=obj.checked;
			$GetEle("displayorder_"+rownum).value="";
		}
	}else if(flag==3){
		if(obj.checked==true){
			$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
			$GetEle("isconditions_"+rownum).checked=obj.checked;			
		}else{
			$GetEle("isconditions_"+rownum).checked=false;
		}
	}else if(flag==4){
		if(obj.checked==true){
			$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
			$GetEle("isconditions_"+rownum).checked=obj.checked;
		}else{
		}
	}
	/****/
}


function choosetitle(rownum){
	$GetEle("isconditionstitle_"+rownum).checked=true;
	$GetEle("istitle_"+rownum).checked=true;	
}

function submitData(){
	refreshDisplayIndex();
	$GetEle('frmMain').submit();	
}
function refreshDisplayIndex(){
	$("#oTable").find("tr").each(function(i){
		$(this).find("input[name^=displayorder_]").val(i);
	});
}

function formreset() {
	document.getElementById('frmMain').reset();
}

$(function(){//checkbox的联动
	$("#IsconditionstitleAll").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'isconditionstitle_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'isconditionstitle_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
			$("[name ^= 'istitle_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
			$("[name ^= 'isconditions_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
		}
	});
	$("#IstitleAll").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'istitle_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
			$("[name ^= 'isconditionstitle_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'istitle_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
		}
	});
	$("#IsconditionsAll").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'isconditions_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
			$("[name ^= 'isconditionstitle_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'isconditions_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
		}
	});
	
	$("[name ^= 'isconditions_']:checkbox").bind("click",function(){
		var ename=$(this).attr("name");
		var idx=ename.substring(ename.indexOf("_")+1);
		if($(this).attr("checked")==true){
			$("[name = isconditionstitle_"+idx+"]:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}
	});
	$("[name ^= 'istitle_']:checkbox").bind("click",function(){
		var ename=$(this).attr("name");
		var idx=ename.substring(ename.indexOf("_")+1);
		if($(this).attr("checked")==true){
			$("[name = isconditionstitle_"+idx+"]:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}
	});
	
	//高亮搜索
	$("#topTitle").topMenuTitle({});
	/**
	$("table.ListStyle").delegate("input[type=text]","mouseover",function(){$(this).parent("td").addClass("e8Selected").parent("tr").addClass("Selected");})
	.delegate("input[type=text]","mouseout",function(){$(this).parent("td").removeClass("e8Selected").parent("tr").removeClass("Selected");});**/
});

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
          return ui;  
       }  
   });  
}


$(function(){
	$("#oTable").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	
	registerDragEvent();
});
</script>
</BODY></HTML>
