<DIV>
<BUTTON class=btn accessKey=R onClick="location.href='WorkflowMonitor.jsp?start=<%=start%>'"><U>R</U>-返回</BUTTON>
</div>

<BR>
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->

<BR>
<TABLE class=form cellpadding="0" cellspacing="0" border="1">
  <COLGROUP> 
  <COL width="20%"> 
  <COL width="80%"> 

  <!--新建的第一行，包括说明和重要性 -->
  <TR class=separator> 
    <TD class=Sep1 colSpan=2></TD>
  </TR>
  <TR> 
    <TD>说明</TD>
    <TD class=field><%=Util.toScreen(requestname,user.getLanguage())%> 
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%>正常
      <%} else if(requestlevel.equals("1")){%>重要
      <%} else if(requestlevel.equals("2")){%>紧急 <%}%>
    </TD>
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
    RecordSet.executeProc("workflow_FieldID_Select",formid+"");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString(1)));
        fieldorders.add(Util.null2String(RecordSet.getString(2)));
    }

    RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
    while(RecordSet.next()){
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("languageid")));
    }
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


// 确定字段是否显示
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(RecordSet.getString("isview"));
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
    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) isview=(String)isviews.get(isfieldidindex);    //字段是否显示
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

    String fieldvalue=(String)fieldvalues.get(tmpindex);

    // 下面开始逐行显示字段
%>
    <tr> 
      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%> </td> 
      <td class=field> 
      <%
        if(fieldhtmltype.equals("1") || fieldhtmltype.equals("2") ){  // 单行,多行文本框
      %>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
      <%
	    }                                                           // 单行,多行文本框条件结束
	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            if(fieldtype.equals("2") || fieldtype.equals("19")){    // 日期和时间
      %>
		<%=fieldvalue%>
      <%
            } else if(!fieldvalue.equals("")) {
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                String showname = "";                                                   // 值显示的名称
                String showid = "";                                                     // 值
                
                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }
                
                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid= Util.null2String(RecordSet.getString(1)) ;
                    showname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals("")){
                        showname = "<a href='"+linkurl+showid+"'>"+showname+"</a> " ;
                    }
	  %>
		<%=showname%>
      <%
                }    // end of while
            }
	    }                                                       // 浏览按钮条件结束                       
	    else if(fieldhtmltype.equals("4")) {                    // check框   
	   %>
        <input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
       <%
        }                                                       // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select
	   %>
        <select name="field<%=fieldid%>" DISABLED >
	   <%
            // 查询选择框的所有可以选择的值
            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);  
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
	   %>
	    <option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
	   <%
            }
       %>
	    </select>
       <%   
        }                                          // 选择框条件结束 所有条件判定结束
       %>
      </td>
    </tr>
<%
    }       // 循环结束
%>
    
</TABLE>
<br>
<br>

<input type=hidden name="requestid" value="<%=requestid%>">           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->    
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">           <!--当前节点类型-->
<input type=hidden name="src" value="active">                       <!--操作类型 save和submit,reject,delete,active-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->


<script language="javascript">
function deleteWorkflow(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.weaver.submit();
	}
}
</script>