
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>

<form name="frmmain" method="post" action="BillSendDocOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->

<TABLE class="ViewForm" >
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

  <!--新建的第一行，包括说明和重要性 -->

  <TR><TD class=Line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
    <TD class=field>
      <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=40 maxlength=100  <%if(!workflowid.equals("146")){%> value = "<%=Util.toScreenToEdit( workflowname+"-"+username+"-"+currentdate,user.getLanguage() )%>" <%}%> >
      <span id=requestnamespan><%if(workflowid.equals("146")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <input type=hidden value="0" name="requestlevel" >
    </TD>
  </TR>
<TR><TD class=Line colSpan=2></TD></TR>
  <!--第一行结束 -->

<%
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
    /*
    RecordSet.executeProc("workflow_FieldID_Select",formid+"");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString(1)));
        fieldorders.add(Util.null2String(RecordSet.getString(2)));
    }

    RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
    while(RecordSet.next()){
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("languageid")));
    }*/
}
else {

    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet.getString("type")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
    }
}

// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}


// 得到每个字段的信息并在页面显示

for(int i=0;i<fieldids.size();i++){         // 循环开始
	int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

	String fieldid=(String)fieldids.get(tmpindex);  //字段id

    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示
        if( viewtype.equals("1") ) continue ;
    }

    String isview="0" ;    //字段是否显示
	String isedit="0" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入

    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环

    String fieldname = "" ;                         //字段数据库表中的字段名
    String fieldhtmltype = "" ;                     //字段的页面类型
    String fieldtype = "" ;                         //字段的类型
    String fieldlable = "" ;                        //字段显示名
    int languageid = 0 ;

    if(isbill.equals("0")) {
        languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新
        fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
        fieldtype=FieldComInfo.getFieldType(fieldid);
        fieldlable=(String)fieldlabels.get(tmpindex);
        fieldname=FieldComInfo.getFieldname(fieldid);
    }
    else {
        languageid = user.getLanguage() ;
        fieldname=(String)fieldnames.get(tmpindex);
        fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldtype=(String)fieldtypes.get(tmpindex);
        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
    }

    if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>"
<%
	    continue;
	}

	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较

    if(ismand.equals("1"))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中

    // 下面开始逐行显示字段
%>
    <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%> </td>
      <td class=field>
      <%
        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
      %>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=50 onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
      <%

				    }else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" value="" size=50>
      <%            }
			    }
		    }
		    else if(fieldtype.equals("2")){                     // 单行文本框中的整型
			    if(isedit.equals("1")){
				    if(ismand.equals("1")) {
      %>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
       <%

				    }else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
       <%           }
			    }
		    }
		    else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
			    if(isedit.equals("1")){
				    if(ismand.equals("1")) {
       %>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
       <%
    				}else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
       <%           }
			    }
		    }
	    }                                                       // 单行文本框条件结束
	    else if(fieldhtmltype.equals("2")){                     // 多行文本框
		    if(isedit.equals("1")){
			    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		rows="4" cols="40" style="width:80%" class=Inputstyle></textarea>
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
       <%
			    }else{
       %>
        <textarea class=Inputstyle name="field<%=fieldid%>" rows="4" cols="40" style="width:80%"></textarea>
       <%       }
		    }
	    }                                                           // 多行文本框条件结束
	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值

            if(fieldtype.equals("8") && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值
                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldtype.equals("9") || fieldtype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值
                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldtype.equals("1") ||fieldtype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldtype.equals("7") || fieldtype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
                showid = "" + Util.getIntValue(crmid,0);
            }else if(fieldtype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldtype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldtype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }

            if(showid.equals("0")) showid = "" ;

            if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;

                RecordSet.executeSql(sql);
                if(RecordSet.next()) {
                    if(!linkurl.equals(""))
                    {
        				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                    	{
                    		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
                    	}
        				else
        					showname = "<a href='"+linkurl+showid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
        			}
                    else
                        showname =RecordSet.getString(1) ;
                }
            }

            if(fieldtype.equals("2")){                              // 浏览按钮为日期
                showname = currentdate;
                showid = currentdate;
            }

		    if(isedit.equals("1")){
                if( !fieldtype.equals("37") ) {    //  多文档特殊处理
	   %>
        <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button class=AddDoc onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
            }
       %>
        <input type=hidden name="field<%=fieldid%>" value="<%=showid%>">
        <span id="field<%=fieldid%>span"><%=Util.toScreen(showname,user.getLanguage())%>
       <%   if(ismand.equals("1") && showname.equals("")) {
       %>
           <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
       <%
	    }                                                       // 浏览按钮条件结束
	    else if(fieldhtmltype.equals("4")) {                    // check框
	   %>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
       <%
        }                                                       // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select
	   %>
        <select class=inputstyle  name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> class=Inputstyle>
	   <%
            // 查询选择框的所有可以选择的值
            char flag= Util.getSeparator() ;
            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
	   %>
	    <option value="<%=tmpselectvalue%>"><%=tmpselectname%></option>
	   <%
            }
       %>
	    </select>
       <%
        }                                          // 选择框条件结束 所有条件判定结束
       %>
      </td>
    </tr>
	 <TR><TD class=Line colSpan=2></TD></TR>
<%
    }       // 循环结束
%>

    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
        <textarea class=Inputstyle name=remark id=remark  rows=4 cols=40 style="width=80%" class=Inputstyle></textarea>
       </td>
    </tr>
	 <TR><TD class=Line colSpan=2></TD></TR>
    <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
  </table>


<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="0">                     <!--当前节点类型-->
<input type=hidden name="src">                                    <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="1">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">            <!--创建结束后返回的页面-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->

<script language=javascript>

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    if(check_form(document.frmmain,'requestname')){
        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    }
}

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else
                return true;
            }
            }
        else
        return true;
        }
}


    function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
        if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
        {
            YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
            MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
            DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
            YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
            MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
            DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
            }
        }
        return true;
    }

    function doSave(){              <!-- 点击保存按钮 -->
        if(check_form(document.frmmain,'<%=needcheck%>')){
            if(checktimeok()) {
                document.frmmain.src.value='save';
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }

    function doSubmit(){            <!-- 点击提交 -->
        if(check_form(document.frmmain,'<%=needcheck%>')){
            if(checktimeok()) {
                document.frmmain.src.value='submit';
                document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }
function showfieldpop(){
<%if(fieldids.size()<1){%>
alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
<%}%>
}
if (window.addEventListener)
window.addEventListener("load", showfieldpop, false);
else if (window.attachEvent)
window.attachEvent("onload", showfieldpop);
else
window.onload=showfieldpop; 
</script>
</form>