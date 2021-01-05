
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuConfig" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
String saved = Util.null2String(request.getParameter("saved"));

MainMenuHandler mainMenuHandler = new MainMenuHandler();
MainMenuInfo info = mainMenuHandler.getMenuInfo(id);

HashMap mainMenuMapping = mainMenuHandler.getMainMenuMapping(userid);

ArrayList firstLevelMainMenuInfos = (ArrayList)mainMenuMapping.get(new Integer(id));

String imagefilename = "/images/hdMaintenance_wev8.gif";
//自定义界面-主菜单
String titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17597,user.getLanguage())+" - " + info.getName(user.getLanguage());
String needfav ="1";
String needhelp ="";


String oldCheckedString = "";
String oldIdString = "";


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
  
  <body <%if(saved.equals("true")){%> onload="loadMainFrame()"<%}%>>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;//保存
  RCMenuHeight += RCMenuHeightStep ;
  
  if(HrmUserVarify.checkUserRight("MenuCustom:Maintenance", user)){
  
  RCMenu += "{"+SystemEnv.getHtmlLabelName(17607,user.getLanguage())+",javascript:customName(),_self} " ;//自定义名称
  RCMenuHeight += RCMenuHeightStep ;
  
  }
  
  RCMenu += "{"+SystemEnv.getHtmlLabelName(15084,user.getLanguage())+",javascript:up(),_self} " ;//上移
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(15085,user.getLanguage())+",javascript:down(),_self} " ;//下移
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",MainSystemMenuList.jsp,_self} " ;//返回
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<FORM id=weaver name=frmmain action="MainMenuOperation.jsp" method=post >
            <input type=hidden name=id value=<%=id%>>
        	<input type=hidden name=valueT1 value="--">
			<input type=hidden name=valueT2 value="--">
            <input type=hidden name=checkedString value="--">

            
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
		<table class=ViewForm>
            <%

            for(int i=0; i<firstLevelMainMenuInfos.size(); i++){
                MainMenuConfig firstConfig = (MainMenuConfig)firstLevelMainMenuInfos.get(i);
                MainMenuInfo firstLevelInfo = (MainMenuInfo)firstConfig.getMainMenuInfo();
                int firstLevelId = firstLevelInfo.getId();
                String firstLevelName = firstLevelInfo.getName(user.getLanguage());
                boolean firstLevelVisible = firstConfig.isVisible();

                oldCheckedString+=firstLevelVisible==true?"1,":"0,";
                oldIdString+= firstLevelId+",";
                ArrayList secondLevelMenuInfos = (ArrayList)mainMenuMapping.get(new Integer(firstLevelId));
                
                %>
            <tr class=field>
            
                <td>
                <table class=ListStyle>
                    <%if((i%2)==0){%>
                <tr class=DataDark>
                    <%}else{%>
                <tr class=DataLight>
                    <%}%>
                    <td colspan=1 align=left>
                        <%if(firstLevelVisible){%>
                        <input type="checkbox" name="m<%=firstLevelId%>" value="M<%=firstLevelId%>" onclick="checkMain('<%=firstLevelId%>')" checked>
                        <%}else{%>
                        <input type="checkbox" name="m<%=firstLevelId%>" value="M<%=firstLevelId%>" onclick="checkMain('<%=firstLevelId%>')">
                        <%}%>
                    </td>
                    <td colspan=3 width="100%" onclick="tableClick(this)">
                        <b><%=firstLevelName%></b>
                    </td>
                    <td><A style="display:none" HREF=#><%=firstLevelId%></A>
                    </td>
                </tr>
                </table>
                <%//二级菜单
                if(secondLevelMenuInfos!=null){%>
                <table class=ViewForm>

                    <%
                    
                    for(int j=0; j<secondLevelMenuInfos.size(); j++){
                        MainMenuConfig secondConfig = (MainMenuConfig)secondLevelMenuInfos.get(j);
                        MainMenuInfo secondLevelInfo = (MainMenuInfo)secondConfig.getMainMenuInfo();
                        int secondLevelId = secondLevelInfo.getId();
                        String secondLevelName = secondLevelInfo.getName(user.getLanguage());
                        boolean secondLevelVisible = secondConfig.isVisible();
                        oldCheckedString+= secondLevelVisible==true?"1,":"0,";
                        oldIdString+= secondLevelId+",";
                        ArrayList thirdLevelMenuInfos = (ArrayList)mainMenuMapping.get(new Integer(secondLevelId));
                        
                        %>
                    <tr class=field>
                        <td>
                        <table class=ListStyle cellspacing=1>
                    
                    <%if((j%2)==0){%>
                            <tr class=DataDark name="sTr<%=firstLevelId%>">
                    <%}else{%>
                            <tr class=DataLight name="sTr<%=firstLevelId%>">
                    <%}%>

                            <td width="5%"></td>
                            <td width="5%">
                    <%if(secondLevelVisible){%>
                                <input type="checkbox" name="s<%=firstLevelId%>" value="S<%=secondLevelId%>" onclick="checkSecond('<%=firstLevelId%>','<%=secondLevelId%>')" checked>  
                    <%}else{%>
                                <input type="checkbox" name="s<%=firstLevelId%>" value="S<%=secondLevelId%>" onclick="checkSecond('<%=firstLevelId%>','<%=secondLevelId%>')">  
                    <%}%>
                    
                            </td>
                            <td width="1%"><A style="display:none" HREF=#><%=secondLevelId%></A>
                            </td>
                            <td colspan=1 width="90%" onclick="tableClick(this)">
                        <%=secondLevelName%>
                            </td>
                            </tr>
                            
                        </table>
						<%//三级菜单
						if(thirdLevelMenuInfos!=null){%>
                        <table class=ViewForm>
                    <%for(int k=0; k<thirdLevelMenuInfos.size(); k++){
                        MainMenuConfig thirdConfig = (MainMenuConfig)thirdLevelMenuInfos.get(k);
                        MainMenuInfo thirdLevelInfo = (MainMenuInfo)thirdConfig.getMainMenuInfo();

                        int thirdLevelId = thirdLevelInfo.getId();
                        String thirdLevelName = thirdLevelInfo.getName(user.getLanguage());
                        boolean thirdLevelVisible = thirdConfig.isVisible();
                        oldCheckedString+= thirdLevelVisible==true?"1,":"0,";
                        oldIdString+= thirdLevelId+",";
                    %>
                        <tr class=field>
                        <td>
                        <table class=ListStyle cellspacing=1>

                    <%if((j%2)==0){%>
                            <tr class=DataDark name="sTr<%=firstLevelId%>">
                    <%}else{%>
                            <tr class=DataLight name="sTr<%=firstLevelId%>">
                    <%}%>
                            <td width="10%"></td>
                            <td width="5%">
                    <%if(thirdLevelVisible){%>
                                <input type="checkbox" name="t<%=firstLevelId%>:s<%=secondLevelId%>" value="T<%=thirdLevelId%>" onclick="checkThird('<%=firstLevelId%>','<%=secondLevelId%>')" checked>  
                    <%}else{%>
                                <input type="checkbox" name="t<%=firstLevelId%>:s<%=secondLevelId%>" value="T<%=thirdLevelId%>" onclick="checkThird('<%=firstLevelId%>','<%=secondLevelId%>')">  
                    <%}%>
                    
                            </td>
                            <td width="1%"><A style="display:none" HREF=#><%=thirdLevelId%></A>
                            </td>
                            <td colspan=1 width="90%" onclick="tableClick(this)">
                        <%=thirdLevelName%>
                            </td>

                            </tr>
                        </table>
                        </td>
                        </tr>
                    <%}%>
        
                        </table>
                        <%//三级菜单结束
                        }
                        %>
                        </td>
                    </tr>
                    
                    <%}%>
                
 	        </table>
			<%//二级菜单结束
			}
			%>
			
			</td>
		</tr>
			
        <%}%>
		</table>

			
			</td>
			</tr>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
    <input type=hidden name=oldCheckedString value=<%=oldCheckedString%>>
    <input type=hidden name=oldIdString value=<%=oldIdString%>>
		</FORM>
    
<script LANGUAGE="JavaScript">

var selectedObj;
var oldSelectedObj;
var oldClassName;

function checkMain(id) {
  var len = document.frmmain.elements.length;
  var mainchecked=document.all("m"+id).checked ;
  var i=0;
  for( i=0; i<len; i++) {
	var index = document.frmmain.elements[i].name.indexOf(":s");
	var tString;
	if(index!=-1){
	  tString = document.frmmain.elements[i].name.substring(0,index);
      if (tString=='t'+id) {
        document.frmmain.elements[i].checked= mainchecked ;
      }
	}
    if (document.frmmain.elements[i].name=='s'+id) {
      document.frmmain.elements[i].checked= mainchecked ;
    }
  }
}

function checkSecond(fLevelId,sLevelId) {
  var len = document.frmmain.elements.length;
  var i=0;

  var schecked;
  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].value=='S'+sLevelId) {
		schecked = document.frmmain.elements[i].checked ;
		break;
	}
  }
	
  for( i=0; i<len; i++) {
	if (document.frmmain.elements[i].name=="t"+fLevelId+":s"+sLevelId){
		document.frmmain.elements[i].checked= schecked ;
	}
  }
  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='s'+fLevelId) {
	  if(document.frmmain.elements[i].checked){
		document.all("m"+fLevelId).checked=true;
		return;
	  }
	}
  }
  document.all("m"+fLevelId).checked=false;
}

function checkThird(mId,sId) {
  len = document.frmmain.elements.length;
  var i=0;
  var sElement;

  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].value=='S'+sId) {
		sElement = document.frmmain.elements[i];
		break;
	}
  }

  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='t'+mId+':s'+sId) {
	  if(document.frmmain.elements[i].checked){
		sElement.checked=true;
		return;
	  }
	}
  }
  sElement.checked=false;
  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='s'+mId) {
        if(document.frmmain.elements[i].checked){
            document.all("m"+mId).checked=true;
            return;
        }
    }
  }
  document.all("m"+mId).checked = false;
}

function up(){
    if(selectedObj==null)
		return;
   	var mainTR;
	var beforeMainTR;
	var mainTable;
	var parentCellLength = selectedObj.parentElement.cells.length;

	mainTR = selectedObj.parentElement.parentElement.parentElement.parentElement.parentElement;
	mainTable = mainTR.parentElement;
	if(mainTR.rowIndex==0){
		return;
	}
	beforeMainTR = mainTable.rows(mainTR.rowIndex-1);
	var rowobj = mainTable.insertRow(mainTR.rowIndex+1);

	for(var i=0; i<beforeMainTR.cells.length; i++){
		var cellobj = rowobj.insertCell()
		cellobj.innerHTML = beforeMainTR.cells[i].innerHTML;
	}

	mainTable.deleteRow(mainTR.rowIndex-1);

}

function down(){
	

	if(selectedObj==null)
		return;
	var mainTR;
	var afterTR;
	var mainTable;
	var parentCellLength = selectedObj.parentElement.cells.length;

    mainTR = selectedObj.parentElement.parentElement.parentElement.parentElement.parentElement;
	mainTable = mainTR.parentElement;
	if(mainTR.rowIndex==mainTable.rows.length-1){
		return;
	}
	afterMainTR = mainTable.rows(mainTR.rowIndex+1);
	var rowobj = mainTable.insertRow(mainTR.rowIndex);
	
	for(var i=0; i<afterMainTR.cells.length; i++){
		var cellobj = rowobj.insertCell();
		cellobj.innerHTML = afterMainTR.cells[i].innerHTML;
	}

	mainTable.deleteRow(mainTR.rowIndex+1);

}

function tableClick(obj){
    selectedObj = obj;
	if(oldSelectedObj==null){
	}
	else{

		if(oldSelectedObj.parentElement==null){
		}
		else{
			oldSelectedObj.parentElement.className = oldClassName;
		}
		oldClassName = selectedObj.parentElement.className;	
    }
	oldSelectedObj = obj;
    selectedObj.parentElement.className="Selected";		
}

function onSave(){
    len = document.frmmain.elements.length;
    var i=0;
    var nameString="";
    var valueString="";
    var checkedString="";

    for( i=0; i<len; i++) {
        var eName = document.frmmain.elements[i].name;
        var eValue = document.frmmain.elements[i].value;

        if (eName.indexOf("m")!=-1||eName.indexOf("s")!=-1) {
            nameString+=eName+",";
            valueString+=eValue+",";
            
            var eChecked = document.frmmain.elements[i].checked;
            if(eChecked==true)
                checkedString+=1+",";
            else
                checkedString+=0+",";
        }
    }

    document.frmmain.valueT1.value=nameString;
    document.frmmain.valueT2.value=valueString;
    document.frmmain.checkedString.value=checkedString;
    
    frmmain.submit();
}

function customName(){
	if(selectedObj==null){
		return;
	}
    var id = selectedObj.parentElement.cells(2).innerText;
//	if(window.confirm("是否改变菜单自定义的设置？")){
//		document.frmmain.ret.value="false";
//		onSave();
//	}
	location = 'CustomMainMenuName.jsp?systemId='+document.frmmain.id.value+'&id='+id;
}

function loadMainFrame(){
	var strUrl = "";
	var o = top.document.getElementsByTagName("IFRAME");
	try{
	for(var i=0;i<o.length;i++){
		if(o[i].name=="apXPDropDown"){
			strUrl = o[i].src;
			o[i].src = strUrl;
			break;
		}
	}}catch(e){}
}

</script>

  </body>
</html>
