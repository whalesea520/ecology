<%@ page import="java.math.*,weaver.conn.*" %>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillHrmScheduleMainOperation.jsp">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>
    
    <table class=viewform>
        <TR class=Spacing><TD class=Line1></TD></TR>
        </TR>
        <tr>
            <td>
            <%
            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;
            

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }

            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
            }

            if( colcount != 0 ) colwidth = 100/colcount ;


    %>
            <table class=liststyle cellspacing=1 id="oTable">
              <COLGROUP> 
              <tr class=header> 
   <%
            ArrayList viewfieldnames = new ArrayList() ;
            
            // 得到每个字段的信息并在页面显示
            int detailfieldcount = -1 ;

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                
                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;                                                   
                
                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
<%          }
%>
              </tr>
<%          
            BigDecimal countexpense = new BigDecimal("0") ;
            BigDecimal countrealfeefum = new BigDecimal("0") ;
            int countaccessory = 0 ;
            boolean isttLight = false;

            RecordSet.executeSql(" select * from Bill_HrmScheduleDetail where scheduleid ="+billid );
            while(RecordSet.next()) {
                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'> 
<%
                for(int i=0;i<fieldids.size();i++){         // 循环开始

                    String fieldid=(String)fieldids.get(i);  //字段id
                    String isview="0" ;    //字段是否显示

                    int isfieldidindex = isfieldids.indexOf(fieldid) ;
                    if( isfieldidindex != -1 ) {
                        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    }

                    String fieldname = "" ;                         //字段数据库表中的字段名
                    String fieldhtmltype = "" ;                     //字段的页面类型
                    String fieldtype = "" ;                         //字段的类型
                    String fieldlable = "" ;                        //字段显示名
                    int languageid = 0 ;

                    languageid = user.getLanguage() ;
                    fieldname=(String)fieldnames.get(i);
                    fieldhtmltype=(String)fieldhtmltypes.get(i);
                    fieldtype=(String)fieldtypes.get(i);

                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;
                    
                    if( ! isview.equals("1") ) continue ;
                    else {
%>                  
                      <td class=field style="TEXT-VALIGN: center"> 
                      <%
                        if(fieldhtmltype.equals("1") || fieldhtmltype.equals("2")){                          // 单行文本框 , 多行文本框
                      %>
                      <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                      <%
                        }                                                   // 单行文本框多行文本框条件结束
                        else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
                            String showname = "";                                                   // 值显示的名称
                            String showid = "";                                                     // 值
                            
                            
                            if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue; // 日期时间
                            else if(!fieldvalue.equals("")) {
                                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                
                                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")) {    // 多人力资源,多客户,多会议，多文档
                                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                                }
                                else {
                                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                                }
                                
                                RecordSet rs3 = new RecordSet() ;
                                rs3.executeSql(sql);
                                while(rs3.next()){
                                    showid = Util.null2String(rs3.getString(1)) ;
                                    String tempshowname= Util.toScreen(rs3.getString(2),user.getLanguage()) ;
                                    if(!linkurl.equals(""))
                                    {
                        				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                    	{
                                    		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + tempshowname + "</a>&nbsp";
                                    	}
                        				else
                        					showname += "<a href='"+linkurl+showid+"&requestid="+requestid+"'>"+tempshowname+"</a> " ;
                        			} 
                                    else 
                                        showname += tempshowname ;
                                }
                            }
                       %>
                        <%=showname%>
                       <%
                        }                                                       // 浏览按钮条件结束                    
                        else if(fieldhtmltype.equals("4")) {                    // check框   
                       %>
                        <input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
                       <%   
                        }                                                       // check框条件结束
                        else if(fieldhtmltype.equals("5")){                     // 选择框   select
                       %>
                        <select name="field<%=fieldid%>"  DISABLED >
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
                        }                                          // 选择框条件结束 所有条件判定结束
                       %>
                      </td>
<%
                    }
                }
%>
              </tr>
<%          }   %>
            </table>
            </td>
        </tr>
    </table>
    <br>

    <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>

