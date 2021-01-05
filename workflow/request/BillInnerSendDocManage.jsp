

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>

<form name="frmmain" method="post" action="BillInnerSendDocOperation.jsp">




<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->

<BR>
<TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

  <!--新建的第一行，包括说明和重要性 -->
  <TR class="Spacing">
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=field>
      <%=Util.toScreen(requestname,user.getLanguage())%>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
    </TD>
  </TR>  	   	<TR >
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <!--第一行结束 -->

<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

    ArrayList fieldids=new ArrayList();             //字段队列
    ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
    ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
    ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
    ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
    ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
    ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
    ArrayList fieldvalues=new ArrayList();          //字段的值
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

// 查询每一个字段的值
    if( !isbill.equals("1")) {
        RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");       // 从workflow_form表中查
        RecordSet.next();
        for(int i=0;i<fieldids.size();i++){
            String fieldname=FieldComInfo.getFieldname((String)fieldids.get(i));
            fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
        }
    }
    else {
        RecordSet.executeSql("select tablename from workflow_bill where id = " + formid) ; // 查询工作流单据表的信息
        RecordSet.next();
        String tablename = RecordSet.getString("tablename") ;
        RecordSet.executeSql("select * from " + tablename + " where id = " + billid) ; // 对于默认的单据表,必须以id作为自增长的Primary key, billid的值就是id. 如果不是,则需要改写这个部分. 另外,默认的单据表必须有 requestid 的字段

        RecordSet.next();
        for(int i=0;i<fieldids.size();i++){
            String fieldname=(String)fieldnames.get(i);
            fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
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

        String fieldvalue=(String)fieldvalues.get(tmpindex);

        if(fieldname.equals("manager")) {
            String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>"
<%
            continue;
        }

        if(fieldname.equals("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
        if(fieldname.equals("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较
        if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
        if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;

        if(ismand.equals("1"))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段

        if(isview.equals("1")){         // 字段需要显示
%>
    <tr>
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class=field style="TEXT-VALIGN: center">
      <%
            if(fieldhtmltype.equals("1")){                          // 单行文本框
                if(fieldtype.equals("1")){                          // 单行文本框中的文本
                    if(isedit.equals("1") && isremark==0 ){
                        if(ismand.equals("1")) {
      %>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=50 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%

                        }else{%>
        <input  type=text class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=50>
      <%            }
                    }
                    else {
      %>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
      <%
                    }
                }
                else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                    if(isedit.equals("1") && isremark==0 ){
                        if(ismand.equals("1")) {
      %>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%

                        }else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
       <%           }
                    }
                    else {
      %>
        <%=fieldvalue%><input type=hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
      <%
                    }
                }
                else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                    if(isedit.equals("1") && isremark==0 ){
                        if(ismand.equals("1")) {
       %>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
                        }else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
       <%           }
                    }
                    else {
      %>
        <%=fieldvalue%><input type=hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
      <%
                    }
                }
            }                                                       // 单行文本框条件结束
            else if(fieldhtmltype.equals("2")){                     // 多行文本框
                if(isedit.equals("1") && isremark==0 ){
                    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle name="field<%=fieldid%>"  onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		rows="4" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%
                    }else{
       %>
        <textarea class=Inputstyle name="field<%=fieldid%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
       <%       }
                }
                else {
      %>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
      <%
                }
            }                                                           // 多行文本框条件结束
            else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
                String showname = "";                                                   // 值显示的名称
                String showid = "";                                                     // 值

                // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
                if( fieldtype.equals("37") && fieldid.equals(docfileid) && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue; // 日期时间
                else if(!fieldvalue.equals("")) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    RecordSet.executeSql(sql);
                    while(RecordSet.next()){
                        showid = Util.null2String(RecordSet.getString(1)) ;
                        String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals(""))
                            if(fieldtype.equals("9")|| fieldtype.equals("37"))
                                {
                    				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                	{
                                		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + tempshowname + "</a>&nbsp";
                                	}
                    				else
                    					showname += "<a href='"+linkurl+showid+"&requestid="+requestid+"'>"+tempshowname+"</a> " ;
                    			}
                            else
                                showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        else
                            showname += tempshowname ;
                    }
                }
                if(isedit.equals("1") && isremark==0 ){
                    if( !fieldtype.equals("37") ) {    //  多文档特殊处理
	   %>
        <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button class=AddDoc onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp;<button class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
                }
       %>
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
                if( ismand.equals("1") && fieldvalue.equals("") ){
       %>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
                }
       %>
        </span> <input type=hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <%
            }                                                       // 浏览按钮条件结束
            else if(fieldhtmltype.equals("4")) {                    // check框
	   %>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%>  <%if(fieldvalue.equals("1")){%> checked <%}%> >
       <%
                if( isedit.equals("0") || isremark==1 ){
       %>
        <input type= hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <%
                }
            }                                                       // check框条件结束
            else if(fieldhtmltype.equals("5")){                     // 选择框   select
	   %>
        <select class=inputstyle  name="field<%=fieldid%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> >
	   <%
                // 查询选择框的所有可以选择的值
                rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
                while(rs.next()){
                    String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                    String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
	   %>
	    <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
	   <%
                }
       %>
	    </select>
       <%
                if( isedit.equals("0") || isremark==1 ) {
       %>
        <input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
       <%
                }
            }                                          // 选择框条件结束 所有条件判定结束
       %>
      </td>
    </tr><TR><TD class=Line2 colSpan=2></TD></TR>

<%
        }else {                              // 不显示的作为 hidden 保存信息
%>
    <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
        }%>

	<%
    }       // 循环结束
%>

</table>
<input type=hidden name="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->
<input type=hidden name=isremark>
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" value="<%=topage%>">				<!--返回的页面-->

<script language="javascript">

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    document.frmmain.src.value='save';
    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
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


	<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>