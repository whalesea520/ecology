
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.*,weaver.general.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@page import="weaver.workflow.field.HtmlElement"%>
<%@page import="weaver.workflow.field.FileElement"%>

<%@page import="weaver.fna.general.FnaCommon"%><jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo2" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo2" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="deptVirComInfo2" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo2" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="subCompVirComInfo2" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DocComInfo2" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo2" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo2" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo2" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo2" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo2" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page"/>
<jsp:useBean id="docReceiveUnitComInfo_vdba" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
 
<!-- 明细样式 -->
<link href="/css/ecology8/workflowdetail_wev8.css" type="text/css" rel="stylesheet">
 
<%
    
      Hashtable otherPara_hs = new Hashtable();
    
      //当前登录用户所用语言id
      otherPara_hs.put("languageId", "" + user.getLanguage());
        
      String canDelAcc = "";
      String smsAlertsType = "";
      //微信提醒(QC:98106)
      String chatsAlertType = "";
      rs.executeSql("select candelacc,smsAlertsType,chatsAlertType from workflow_base where id=" + workflowid);
      if (rs.next()) {
        canDelAcc = Util.null2String(rs.getString("candelacc"));
        smsAlertsType = Util.null2String(rs.getString("smsAlertsType"));
        chatsAlertType = Util.null2String(rs.getString("chatsAlertType"));
      }
    
	  otherPara_hs.put("requestid", ""+requestid);
	  otherPara_hs.put("userid", ""+user.getUID());
	  otherPara_hs.put("workflowid", "" + workflowid);
      otherPara_hs.put("isremark", "2");
      otherPara_hs.put("nodeid", "" + nodeid);
      otherPara_hs.put("isbill", "" + isbill);
      otherPara_hs.put("nodetype", "" + nodetype);
      otherPara_hs.put("canDelAcc", canDelAcc);
    
      otherPara_hs.put("isprint", "0");
      otherPara_hs.put("wfmonitor", "" + wfmonitor);
      otherPara_hs.put("isurger", "" + isurger);
      
      ArrayList changefieldsadd = WfLinkageInfo.getChangeField(Util.getIntValue(workflowid+"",0), Util.getIntValue(nodeid+"",0), 0);
      otherPara_hs.put("changefieldsadd", changefieldsadd);
      
    ArrayList defieldids=new ArrayList();             //字段队列
    ArrayList defieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
    ArrayList delanguageids=new ArrayList();          //字段显示的语言(单据文件不需要)
    ArrayList defieldlabels=new ArrayList();          //单据的字段的label队列
    ArrayList defieldhtmltypes=new ArrayList();       //单据的字段的html type队列
    ArrayList defieldtypes=new ArrayList();           //单据的字段的type队列
    ArrayList defieldnames=new ArrayList();           //单据的字段的表字段名队列
    ArrayList defieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
    ArrayList deimgwidths=new ArrayList(); 
    ArrayList deimgheights=new ArrayList();
    // 确定字段是否显示，是否可以编辑，是否必须输入
    ArrayList isdefieldids=new ArrayList();              //字段队列
	ArrayList defieldqfws=new ArrayList(); 
    ArrayList isdeviews=new ArrayList();              //字段是否显示队列
	ArrayList colCalAry = new ArrayList();
	ArrayList defielddbtypes = new ArrayList();
	boolean defshowsum=false;
    
    String isdeview="0" ;    //字段是否显示
    String defieldid="";
    String defieldname = "" ;                         //字段数据库表中的字段名



    String defieldhtmltype = "" ;                     //字段的页面类型



    String defieldtype = "" ;                         //字段的类型



    String defieldlable = "" ;                        //字段显示名



    String defieldvalue="";
	String defielddbtype="";
	
	String deimgwidth = "50";
    String deimgheight = "50";
    
    int delanguageid = 0 ;
    int colcount1 = 0;
    int colwidth1 = 0;
    String rowCalItemStr1,colCalItemStr1,mainCalStr1;
	rowCalItemStr1 = new String("");
	colCalItemStr1 = new String("");
    mainCalStr1 = new String("");
    int detailno=0;
    int derecorderindex = 0 ;
//String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
//String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
userid=user.getUID();                   //当前用户id
    //对不同的模块来说,可以定义自己相关的内容，作为请求默认值，比如将 docid 赋值，作为该请求的默认文档
    //默认的值可以赋多个，中间用逗号格开

    String prjid = Util.null2String(request.getParameter("prjid"));
    String docid = Util.null2String(request.getParameter("docid"));
    String crmid = Util.null2String(request.getParameter("crmid"));
    String hrmid = Util.null2String(request.getParameter("hrmid"));
    if(hrmid.equals("") && logintype.equals("1")) hrmid = "" + userid ;
    if(crmid.equals("") && logintype.equals("2")) crmid = "" + userid ;
    RecordSet billrs=new RecordSet();
    if(isbill.equals("1")){       //单据        支持多明细



              RecordSet.execute("select * from workflow_formdetailinfo where formid="+formid);
				while(RecordSet.next()){
					rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
					colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
					mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
                    //System.out.println("colCalItemStr1 = " + colCalItemStr1);
				}
              StringTokenizer stk = new StringTokenizer(colCalItemStr1,";");
              while(stk.hasMoreTokens()){
                colCalAry.add(stk.nextToken());
              }
			  billrs.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
              //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
              int billgroupId = 0;
              while(billrs.next()){
                String tablename=billrs.getString("tablename");
                String tabletitle=billrs.getString("title");
                defieldids.clear() ;
                defieldlabels.clear() ;
                defieldhtmltypes.clear() ;
                defieldtypes.clear() ;
                defieldnames.clear() ;
                defieldviewtypes.clear() ;
				defielddbtypes.clear();
				defshowsum=false;
				colcount1 = 0;
				
				deimgwidths.clear();
                deimgheights.clear();

                rs.execute("select * from workflow_billfield where viewtype='1' and billid="+formid+" and detailtable='"+tablename+"' ORDER BY dsporder");
                //System.out.println("select * from workflow_billfield where viewtype='1' and billid="+formid+" and detailtable='"+tablename+"'");
                while(rs.next()){
                    //String theviewtype = Util.null2String(rs.getString("viewtype")) ;
                    //if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示



                    defieldids.add(Util.null2String(rs.getString("id")));
                    defieldlabels.add(SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("fieldlabel")),languageidfromrequest));
                    defieldhtmltypes.add(Util.null2String(rs.getString("fieldhtmltype")));
                    defieldtypes.add(Util.null2String(rs.getString("type")));
                    defieldnames.add(Util.null2String(rs.getString("fieldname")));
					defielddbtypes.add(Util.null2String(rs.getString("fielddbtype")));
					defieldqfws.add(Util.null2String(rs.getString("qfws")));
					deimgwidths.add(""+Util.getIntValue(rs.getString("imgwidth"), 50));
                    deimgheights.add(""+Util.getIntValue(rs.getString("imgheight"), 50));
                    //defieldviewtypes.add(theviewtype);
                }

                // 确定字段是否显示，是否可以编辑，是否必须输入
                isdefieldids.clear() ;              //字段队列
                isdeviews.clear() ;              //字段是否显示队列

                //RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
                rs.execute("SELECT DISTINCT a.*, b.dsporder FROM workflow_nodeform a ,workflow_billfield b where a.fieldid = b.id and b.viewtype='1' and b.billid ="+formid+" and a.nodeid="+nodeid+" and b.detailtable='"+tablename+"' ORDER BY b.dsporder");
                //System.out.println("SELECT DISTINCT a.*, b.dsporder FROM workflow_nodeform a ,workflow_billfield b where a.fieldid = b.id and b.viewtype='1' and b.billid ="+formid+" and a.nodeid="+nodeid+" and b.detailtable='"+tablename+"'");
                while(rs.next()){
                    String thedefieldid = Util.null2String(rs.getString("fieldid")) ;
                    //System.out.println("thedefieldid:"+thedefieldid);
                    int thefieldidindex = defieldids.indexOf( thedefieldid ) ;
                    if( thefieldidindex == -1 ) continue ;
                    String theisdeview = Util.null2String(rs.getString("isview")) ;
                    if( theisdeview.equals("1") ) {
						colcount1 ++ ;
						if(!defshowsum){
                        if(colCalAry.indexOf("detailfield_"+thedefieldid)>-1){
                            defshowsum=true;
                        }
                        }
					}
                    isdefieldids.add(thedefieldid);
                    isdeviews.add(theisdeview);
                }
                
                boolean ishide = false;
                if(isprint){
                    WFNodeDtlFieldManager.resetParameter();
                    WFNodeDtlFieldManager.setNodeid(nodeid);
                    WFNodeDtlFieldManager.setGroupid(billgroupId);
                    WFNodeDtlFieldManager.selectWfNodeDtlField();
                    String isprintnulldetail = WFNodeDtlFieldManager.getIshide();
                    String mainkey="mainid";
                    if(formid==18){mainkey="cptadjustid";}
                    if(!isprintnulldetail.equals("1")){
                        rs.executeSql(" select tablename from Workflow_bill where id="+formid);
                        if(rs.next()){
                            String tempmaintable=rs.getString("tablename");
                            if((tempmaintable.indexOf("formtable_main_")==0 || tempmaintable.indexOf("uf_")==0)
                            		&& (tablename.indexOf("formtable_main_")==0 || tablename.indexOf("uf_")==0)){//新表单



                                rs.executeSql("select b.* from "+tempmaintable+" a,"+tablename+" b where a.id=b."+mainkey+" and a.requestid ="+requestid+" order by b.id");
                            }else if(Util.getIntValue(""+formid)<0){     //数据中心模块创建的明细报表



                                rs.executeSql("select b.* from "+tempmaintable+" a,"+tablename+" b where a.id=b."+mainkey+" and a.requestid ="+requestid+" order by b.inputid");
                            }else{
                                rs.executeSql("select b.* from "+tempmaintable+" a,"+tablename+" b where a.id=b."+mainkey+" and a.requestid ="+requestid);
                            }
                            if(rs.getCounts()<=0) ishide = true;
                        }
                    }
                }
                
                if(colcount1>0&&!ishide){
                    colwidth1=97/colcount1;
%>
<!-- 
                <table class=form style="LEFT: 0px; WIDTH: 100%;WORD-WRAP: break-word" <%if(intervenorright==1){%>style="display:none"<%}%>>
                        
                        <tr><td height=15 colspan=2></td></tr>
                        <tr>
                            <td align="left"><font style="font-size:10pt;"><b><%=tabletitle%></b></font></td>
                            <td align="right">
                            &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2>
 -->
	<%if(isprint){ %>
		<div class="gen_printdetail">
	<%} %>
			<wea:layout>
		        <wea:group context='<%=SystemEnv.getHtmlLabelName(84496,user.getLanguage()) + (detailno + 1) %>'>
			        <wea:item type="groupHead">
			     	</wea:item>
					<wea:item attributes="{\"isTableList\":\"true\", 'id':'detailblockTD'}">
<div style="width:100%!important;height:100%;overflow-x:auto;overflow-y:hidden;">
                         <table Class="ListStyle ViewForm" id="oTable<%=detailno%>" >
                              <COLGROUP>
                              <TBODY>
                              <tr class=header>
                                <th width="4%" style="white-space:nowrap;"><%=SystemEnv.getHtmlLabelName(15486,languageidfromrequest)%></th>
                   <%
                       ArrayList viewfieldnames = new ArrayList();

                       // 得到每个字段的信息并在页面显示



					   int isfieldidindex = -1;
                       for (int i = 0; i < defieldids.size(); i++) {         // header循环开始




                           defieldid=(String)defieldids.get(i);  //字段id
                           
                           isfieldidindex = isdefieldids.indexOf(defieldid) ;
                           if( isfieldidindex != -1 ) {
                        	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                           }
                		   defieldlable =(String)defieldlabels.get(i);
                		   defieldname = (String)defieldnames.get(i);
                		  
                		   defieldhtmltype = (String) defieldhtmltypes.get(i);
                		  if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环




                           viewfieldnames.add(defieldname);
                   %>
                                <th width="<%=colwidth1%>%" style="white-space:nowrap;" align="center"><%=defieldlable%></th>
                           <%
                       }     //header 循环结束
                    %>
                              </tr>
                        <%
                        boolean isttLight = false;
                        String maintable="";
                        derecorderindex = 0 ;
                        rs.executeSql(" select tablename from Workflow_bill where id="+formid);
                        if(rs.next()){
                            maintable=rs.getString("tablename");
                            RecordSet rs3=new RecordSet();
                            String mainkey="mainid";
                            if(formid==18){mainkey="cptadjustid";}
                            //System.out.println("select b.* from "+maintable+" a,"+tablename+" b where a.id=b.mainid and a.requestid ="+requestid);
                            if((maintable.indexOf("formtable_main_")==0 || maintable.indexOf("uf_")==0)
                            		&& (tablename.indexOf("formtable_main_")==0 || tablename.indexOf("uf_")==0)){//新表单



                                rs3.executeSql("select b.* from "+maintable+" a,"+tablename+" b where a.id=b."+mainkey+" and a.requestid ="+requestid+" order by b.id");
                            }else{
                                rs3.executeSql("select b.* from "+maintable+" a,"+tablename+" b where a.id=b."+mainkey+" and a.requestid ="+requestid);
                            }
                            while(rs3.next()){
                                isttLight = !isttLight ;
                        %>
                        <TR class="wfdetailrowblock">
                        <td width="3%" style="">
                        <%=derecorderindex+1%>
                        </td>
                        <%
                                for(int i=0;i<defieldids.size();i++){         // 明细记录循环开始



                                    defieldid=(String)defieldids.get(i);  //字段id
                                    defieldname = (String)defieldnames.get(i);  //字段名



                                    //System.out.println("defieldname:"+defieldname);
                                    defieldtype = (String)defieldtypes.get(i);
                                    isfieldidindex = isdefieldids.indexOf(defieldid) ;
                                    if( isfieldidindex != -1 ) {
                                 	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                                    }
                                    qfws=Util.getIntValue((String)defieldqfws.get(i));
                                    defieldhtmltype = (String) defieldhtmltypes.get(i);
									defielddbtype = (String) defielddbtypes.get(i);
                                    if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环



                                    defieldvalue=Util.null2String(rs3.getString(defieldname)) ; 
                                    String toPvalue = "";
                                    
                                    deimgwidth = (String) deimgwidths.get(i);
                		             deimgheight = (String) deimgheights.get(i);
							   
                                    if(defieldtype.equals("5")){
                                    	  if(isbill.equals("0")){
                                    		  rs.executeSql("select * from workflow_formdict where id = " + defieldid);
												 if(rs.next()){
												   qfws = Util.getIntValue(rs.getString("qfws"),2);
												 }
											} 
									if(qfws==1){
										if(!"".equals(defieldvalue)){
											defieldvalue=defieldvalue.substring(0, (defieldvalue.indexOf(".")+qfws+1));
										}
									}
								if(defieldvalue.matches("-*\\d+\\.?\\d*")){
									   NumberFormat formatter = new DecimalFormat("###,###.##"); 
									//end 
									toPvalue = formatter.format(Double.parseDouble(defieldvalue))+""; 
								}else{
									toPvalue = defieldvalue;
									//add by liaodong for qc75759 in 2013年10月23日 start
									defieldvalue = Util.toDecimalDigits(defieldvalue,2);
									//end
								}
							 //add by liaodong for qc75759 in 2013年10月23日 start
								defieldvalue = Util.toDecimalDigits(defieldvalue,qfws);
							}else{
								int decimaldigits_t = 2;
								if(defieldtype.equals("3")){
									int digitsIndex = defielddbtype.indexOf(",");
									if(digitsIndex > -1){
										decimaldigits_t = Util.getIntValue(defielddbtype.substring(digitsIndex+1, defielddbtype.length()-1), 2);
									}else{
										decimaldigits_t = 2;
									}
									defieldvalue = Util.toDecimalDigits(defieldvalue,decimaldigits_t);
								}
							}
							//end
                        %>
                        <td  <%if(defieldhtmltype.equals("1") && (defieldtype.equals("2") || defieldtype.equals("3"))){%> align="right" <%}else{%>  style="LEFT: 0px; WIDTH: <%=colwidth1%>%; word-wrap:break-word;word-break:break-all;TEXT-VALIGN: center" <%}%>>
                        <%                                      
                                     if(defieldhtmltype.equals("1")){                          // 单行文本框



							          //add by liaodong for qc75759 in 2013年10月23日 start
                                      String datavaluetype = "";
                                      //end 
                                          if(defieldtype.equals("4")){
											  datavaluetype =" datalength='2'";
                                        %>
                                         <script language="javascript">
                                             window.document.write(numberChangeToChinese(<%=defieldvalue%>));
                                         </script>
                                        <% //add by liaodong for qc75759 in 2013年10月23日 start
                                           }else{
											 int decimaldigits_t = 2;
											if(defieldtype.equals("3")){
												int digitsIndex = defielddbtype.indexOf(",");
												if(digitsIndex > -1){
													decimaldigits_t = Util.getIntValue(defielddbtype.substring(digitsIndex+1, defielddbtype.length()-1), 2);
												}else{
													decimaldigits_t = 2;
												}
											}
                		    	
											if(defieldtype.equals("5")){
												datavaluetype += " datavaluetype='5'";
											}
											datavaluetype +=" datalength='"+decimaldigits_t+"'";
											//end  
										%>
                                            <%=Util.toScreen(defieldvalue,languageidfromrequest)%>
										<%}%>
										<!-- add by liaodong for qc75759 in 2013年10月23日 start  datavaluetype  -->
                                            <input type=hidden <%=datavaluetype%> id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.toScreen(defieldvalue,languageidfromrequest)%>">
                                          <%
                                    }                                                       // 单行文本框条件结束



                                    else if(defieldhtmltype.equals("2")){                     // 多行文本框



                                          %>
                                            <%=Util.toScreen(defieldvalue,languageidfromrequest)%>
                                          <%
                                    }                                                           // 多行文本框条件结束



                                    else if(defieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                                        String url=BrowserComInfo2.getBrowserurl(defieldtype);     // 浏览按钮弹出页面的url
                                        String linkurl =BrowserComInfo2.getLinkurl(defieldtype);   // 浏览值点击的时候链接的url
                                        String showname = "";                                   // 新建时候默认值显示的名称
                                        String showid = "";                                     // 新建时候默认值

                                		if("fieldIdOrgId_fieldId".equals(fnaWfSetMap.get(defieldid+"")) || "fieldIdOrgId2_fieldId".equals(fnaWfSetMap.get(defieldid+""))){				
                                            int detailRecordId = Util.getIntValue(rs3.getString("id"), 0) ; 
                                			HashMap<String, String> otherReturnVal = new HashMap<String, String>();
                                			defieldtype = FnaCommon.getOrgBtnTypeByFnaFieldType(Util.getIntValue(defieldid), Util.getIntValue(defieldtype), detailRecordId, requestid, 
                                				fnaWfSetMap, reqDataMap, 
                                				user.getLanguage(), 
                                				otherPara_hs1918, otherReturnVal)+"";
                                			if(otherReturnVal.containsKey("newOrgIdDefValue")){
                                				defieldvalue = Util.null2String(otherReturnVal.get("newOrgIdDefValue"));
                                			}
                                		}




                                        if(defieldtype.equals("2") ||defieldtype.equals("19")  )	showname=defieldvalue; // 日期时间
                                        else if(!defieldvalue.equals("")) {
                                            ArrayList tempshowidlist=Util.TokenizerString(defieldvalue,",");
                                            if(defieldtype.equals("8") || defieldtype.equals("135")){
                                                //项目，多项目
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    	showname+=ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("1") ||defieldtype.equals("17")){
                                                //人员，多人员
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                    	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                                      	{
                                                    		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                      	}
                                                    	else
                                                        	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("142")){
												//收发文单位



												for(int k=0;k<tempshowidlist.size();k++){
													if(!linkurl.equals("")){
														showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+docReceiveUnitComInfo_vdba.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
													}else{
													showname+=docReceiveUnitComInfo_vdba.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
													}
												}
                                            }else if(defieldtype.equals("7") || defieldtype.equals("18")){
                                                //客户，多客户
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("4") || defieldtype.equals("57")){
                                                //部门，多部门
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                	String showdeptname = "";
                               						String showdeptid = (String) tempshowidlist.get(k);
                               						if(!"".equals(showdeptid)){
                               							if(Integer.parseInt(showdeptid) < -1){
                               								showdeptname = deptVirComInfo2.getDepartmentname(showdeptid);
                               								
                               							}else{
                               								showdeptname = DepartmentComInfo2.getDepartmentname(showdeptid);
                               							}
                               						}
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+showdeptname+"</a>&nbsp";
                                                    }else{
                                                    	showname+=showdeptname+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("164")||defieldtype.equals("194")){
                                                //分部
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                	String showsubcompname = "";
                            						String showsubcompid = (String) tempshowidlist.get(k);
                            						if(!"".equals(showsubcompid)){
                            							if(Integer.parseInt(showsubcompid) < -1){
                            								showsubcompname = subCompVirComInfo2.getSubCompanyname(showsubcompid);
                            							}else{
                            								showsubcompname = SubCompanyComInfo2.getSubCompanyname(showsubcompid);
                            							}
                            						}
                                                
                                                    if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+showsubcompname+"</a>&nbsp";
                                                    }else{
                                                    	showname+=showsubcompname+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("9") || defieldtype.equals("37")){
                                                //文档，多文档
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"&desrequestid="+desrequestid+"' target='_blank'>"+DocComInfo2.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=DocComInfo2.getDocname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("23")){
                                                //资产
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("16") || defieldtype.equals("152") || defieldtype.equals("171")){
                                                //相关请求
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                                                        tempnum++;
                                                        session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                                                        session.setAttribute("slinkwfnum",""+tempnum);
                                                        session.setAttribute("haslinkworkflow","1");
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("161") || defieldtype.equals("162")){
                                                //自定义单选浏览框，自定义多选浏览框
												Browser browser=(Browser)StaticObj.getServiceByFullname(defielddbtype, Browser.class);
                                                for(int k=0;k<tempshowidlist.size();k++){
													try{
                                                        BrowserBean bb=browser.searchById(requestid+"^~^"+(String)tempshowidlist.get(k)+"^~^"+derecorderindex);
			                                            String desc=Util.null2String(bb.getDescription());
			                                            String name=Util.null2String(bb.getName());							
			                                            String href=Util.null2String(bb.getHref());
			                                            if(href.equals("")){
			                                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
			                                            }else{
			                                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
			                                            }
													}catch (Exception e){
													}
                                                }
                                            }else if(defieldtype.equals("256") ||defieldtype.equals("257")){//自定义树形单选



                                            	//RecordSet recordSet = new RecordSet();
                                            	CustomTreeUtil customTreeUtil = new CustomTreeUtil();
                            					showid = defieldvalue;
                            					showname = customTreeUtil.getTreeFieldShowName(defieldvalue,defielddbtype);
                            					
                            				}else if(defieldtype.equals("226") || defieldtype.equals("227")){
												//System.out.println("来到了修改页面的明细");
												//集成浏览按钮
												//zzl
												if("NULL".equals(defieldvalue)){
													defieldvalue="";
												}
												showname+="<a title='"+defieldvalue+"'>"+defieldvalue+"</a>&nbsp";
												
												//url+="?type="+fielddbtype+"|"+defieldid+"_"+derecorderindex;	
											}
											else{
                                                String tablename1=BrowserComInfo2.getBrowsertablename(defieldtype); //浏览框对应的表,比如人力资源表



                                                String columname=BrowserComInfo2.getBrowsercolumname(defieldtype); //浏览框对应的表名称字段



											 /*因为应聘库中(HrmCareerApply)的人员的firstname在新增时都为空，此处列名直接取上面查出来的(lastname+firstname)
											 会导致流程提交后应聘人不显示，所以此处做下特殊处理，只取应聘人的lastname	参考TD24866*/
												if(columname.equals("(lastname+firstname)"))
													columname = "lastname";
                                                String keycolumname=BrowserComInfo2.getBrowserkeycolumname(defieldtype);   //浏览框对应的表值字段




                                                if(defieldvalue.indexOf(",")!=-1){
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+" in( "+defieldvalue+")";
                                                }
                                                else {
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+"="+defieldvalue;
                                                }

                                                RecordSet.executeSql(sql);
                                                while(RecordSet.next()){
                                                    showid = Util.null2String(RecordSet.getString(1)) ;
                                                    String tempshowname= Util.toScreen(RecordSet.getString(2),languageidfromrequest) ;
												    if(defieldtype.equals("263")){
														 showname +=tempshowname+" ";
													}else{
														if(!linkurl.equals("") && !isprint){
															if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
															{
																showname+="<a href='javaScript:openhrm("+showid+");' onclick='pointerXY(event);'>"+tempshowname+"</a>&nbsp";
															}
															else
																showname += "<a href='"+linkurl+showid+"' target='_new'>"+tempshowname+"</a>&nbsp";
														}else{
															showname +=tempshowname+" ";
														}
													}
                                                }
                                            }
                                        }
                                        //add by dongping
                                        //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表



                                        if (defieldtype.equals("118")) {
                                            showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target='_blank'>"+SystemEnv.getHtmlLabelName(2193,languageidfromrequest)+"</a>" ;
                                            //showid = "<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>";
                                         }
                                   %>
                                    <%=showname%>
                                   <%
                                    }                                                        // 浏览按钮条件结束
                                    else if(defieldhtmltype.equals("4")) {                    // check框



                                           %>
                                           <input type=checkbox value=1 name="field<%=defieldid%>_<%=derecorderindex%>" DISABLED   <%if(defieldvalue.equals("1")){%> checked <%}%> >
                                           <%
                                    }                                                       // check框条件结束



                                    else if(defieldhtmltype.equals("5")){                     // 选择框   select
                                           %>
                                           <select notBeauty=true name="field<%=defieldid%>_<%=derecorderindex%>" DISABLED  >
                                           <option value=""></option>
                                           <%
                                        // 查询选择框的所有可以选择的值



                                        RecordSet selrs=new RecordSet();
                                        selrs.executeProc("workflow_SelectItemSelectByid",""+defieldid+flag+isbill);
                                        while(selrs.next()){
                                            String tmpselectvalue = Util.null2String(selrs.getString("selectvalue"));
                                            String tmpselectname = Util.toScreen(selrs.getString("selectname"),languageidfromrequest);
                                           %>
                                           <option value="<%=tmpselectvalue%>" <%if(defieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
                                           <%
                                        }
                                           %>
                                           </select>
                                           <%
                                    }                                          // 选择框条件结束 所有条件判定结束


                                    
                                    //*********************************************************************************begin
						           else if (defieldhtmltype.equals("6")) {
						           
										if(isdeview.equals("1")){
											//System.out.println("===============defieldid:"+defieldid+"  defieldname:"+defieldname+"  defieldtype:"+defieldtype+"  defieldlable:"+defieldlable+"  defieldvalue:"+defieldvalue+"  isdeedit:"+isdeedit+"  isdemand:"+isdemand);
											otherPara_hs.put("fieldimgwidth" + defieldid, "" + deimgwidth);
											otherPara_hs.put("fieldimgheight" + defieldid, "" + deimgheight);
											//otherPara_hs.put("derecorderindex", "\"+rowindex+\"");
											otherPara_hs.put("derecorderindex", ""+derecorderindex);
											otherPara_hs.put("desrequestid", ""+desrequestid);
			  
											
											int defieldlength = 0;
											int degroupid = 0;
											HtmlElement htmlelement = new FileElement();
											Hashtable ret_hs = htmlelement.getHtmlElementString(Util.getIntValue(defieldid,0), defieldname, Util.getIntValue(defieldtype,0), defieldlable, defieldlength, 1, degroupid, defieldvalue, 0, 1, 0, 0, user, otherPara_hs);
											String deinputStr= Util.null2String((String) ret_hs.get("inputStr"));
										  
											String dejsStr = Util.null2String((String) ret_hs.get("jsStr"));
											String deaddRowjsStr = Util.null2String((String) ret_hs.get("addRowjsStr"))+"\n";
										   
											//System.out.println(deinputStr);
											
											out.println(deinputStr);
											out.println(" <script> \n "+dejsStr+" \n </script>");
											out.println(" <script> \n "+deaddRowjsStr+" \n </script>");
										}
						           }
		
		                           //*********************************************************************************end




                        %>
                        </td>
                        <%

                                }   // 明细记录循环结束
                                derecorderindex++;
                        %>
                        </tr>
                        <%
                            }       //while明细记录结束
                        }       //if结束
                        %>
                              </TBODY>
							  <%if(defshowsum){%>
                              <TFOOT>
                              <TR class=header>
                                <TD ><%=SystemEnv.getHtmlLabelName(358,languageidfromrequest)%></TD>
                <%
                    for (int i = 0; i < defieldids.size(); i++) {
						isfieldidindex = isdefieldids.indexOf((String)defieldids.get(i)) ;
                        if ((isfieldidindex != -1 && !isdeviews.get(isfieldidindex).equals("1")) || isfieldidindex == -1) {
                %>
                                <td width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="display:none"></td>
                                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                            <%
                        } else {
                            %>
                                <td align="right" width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>"  style="color:red"></td>
                                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                                    <%
                        }
                    }
                                    %>
                              </TR>
                              </TFOOT>
							  <%} %>
                            </table>
                            </div>
</wea:item>
</wea:group>
</wea:layout>
<%if(isprint){ %>
</div>
<%} %>

                <input type='hidden' id="nodesnum<%=detailno%>" name="nodesnum<%=detailno%>" value="<%=derecorderindex%>">
                <input type='hidden' id="indexnum<%=detailno%>" name="indexnum<%=detailno%>" value="<%=derecorderindex%>">
<%
                  detailno++;
                }   //if end 
                  billgroupId++;
              }     //多明细循环结束



    }           //单据结束
    else{       //表单    暂时还不支持多明细



        //得到计算公式的字符串
				RecordSet.executeProc("Workflow_formdetailinfo_Sel",formid+"");
				while(RecordSet.next()){
					rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
					colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
					mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
                    //System.out.println("rowCalItemStr1 = " + rowCalItemStr1);
				}
				StringTokenizer stk = new StringTokenizer(colCalItemStr1,";");
				while(stk.hasMoreTokens()){
					colCalAry.add(stk.nextToken());
				}
                // 要进行制动获取的字段

                //autoGetIndex[0] = 1;
                //autoGetIndex[1] = 2;
                //autoGetIndex[2] = 3;
                //autoGetIndex[3] = 5;
				//Clone the ArrayList Objects
                int groupId=0;
                RecordSet formrs=new RecordSet();
				formrs.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
                //out.print("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1'");
                while (formrs.next())
                {
                defieldids.clear();
                defieldlabels.clear();
                defieldhtmltypes.clear();
                defieldtypes.clear();
                defieldnames.clear();
                defieldviewtypes.clear();
                deimgheights.clear();
                deimgwidths.clear();
                defshowsum=false;
				colcount1 = 0;

				  // 确定字段是否显示，是否可以编辑，是否必须输入
                isdefieldids.clear();              //字段队列
                isdeviews.clear();              //字段是否显示队列

				Integer language_id = new Integer(languageidfromrequest);
				//System.out.println(formid+Util.getSeparator()+nodeid);
				groupId=formrs.getInt(1);
                
       RecordSet.executeProc("Workflow_formdetailfield_Sel",""+formid+Util.getSeparator()+nodeid+Util.getSeparator()+groupId);
                while (RecordSet.next()) {


					 if(language_id.toString().equals(Util.null2String(RecordSet.getString("langurageid"))))
						{
                        String theisdeview = Util.null2String(RecordSet.getString("isview")) ;
                        if( theisdeview.equals("1") ) {
                        colcount1 ++ ;
						if(!defshowsum){
                        if(colCalAry.indexOf("detailfield_"+Util.null2String(RecordSet.getString("fieldid")))>-1){
                            defshowsum=true;
                        }
                        }
                        }
                        defieldids.add(Util.null2String(RecordSet.getString("fieldid")));
						defieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
						defieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
						defieldtypes.add(Util.null2String(RecordSet.getString("type")));
						isdeviews.add(theisdeview);
						defieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
						
						rs.executeSql("SELECT imgheight,imgwidth FROM Workflow_formdictdetail WHERE id ="+Util.null2String(RecordSet.getString("fieldid")));
						if(rs.next()){
							deimgwidths.add(""+Util.getIntValue(rs.getString("imgwidth"), 50));
                        	deimgheights.add(""+Util.getIntValue(rs.getString("imgheight"), 50));
						}
						
						
                        }
                }
         
         boolean ishide = false;
         if(isprint){
             WFNodeDtlFieldManager.resetParameter();
             WFNodeDtlFieldManager.setNodeid(nodeid);
             WFNodeDtlFieldManager.setGroupid(groupId);
             WFNodeDtlFieldManager.selectWfNodeDtlField();
             String isprintnulldetail = WFNodeDtlFieldManager.getIshide();
             if(!isprintnulldetail.equals("1")){
                 rs.executeSql(" select * from Workflow_formdetail where requestid ="+requestid+" and groupId="+groupId+"  order by id");
                 if(rs.getCounts()<=0) ishide = true;
             }
         }
         
         if(colcount1!=0&&!ishide){  //有明细才显示
            colwidth1=97/colcount1;
%>
	<%if(isprint){ %>
		<div class="gen_printdetail">
	<%} %>
			<wea:layout>
		        <wea:group context='<%=SystemEnv.getHtmlLabelName(84496,user.getLanguage()) + (detailno + 1) %>'>
			        <wea:item type="groupHead">
			     	</wea:item>
					
                <wea:item attributes="{\"isTableList\":\"true\", 'id':'detailblockTD'}">
<div style="width:100%!important;height:100%;overflow-x:auto;overflow-y:hidden;">
            <table Class=ListStyle id="oTable<%=detailno%>" >
              <COLGROUP>
              <TBODY>
              <tr class=header>
                <td width="3%" style="white-space:nowrap;"><%=SystemEnv.getHtmlLabelName(15486,languageidfromrequest)%></td>
   <%
       ArrayList viewfieldnames = new ArrayList();

       // 得到每个字段的信息并在页面显示




       for (int i = 0; i < defieldids.size(); i++) {         // 循环开始




           defieldid=(String)defieldids.get(i);  //字段id
		   isdeview=(String)isdeviews.get(i);     //字段是否显示
		   defieldlable =(String)defieldlabels.get(i);
		   defieldname = (String)defieldnames.get(i);
		   defieldhtmltype = (String) defieldhtmltypes.get(i);
		  if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环




           viewfieldnames.add(defieldname);
   %>
                <td width="<%=colwidth1%>%" style="white-space:nowrap;" align="center"><%=defieldlable%></td>
           <%
       }
    %>
              </tr>
        <%
                        boolean isttLight = false;
                        String maintable="";
                        derecorderindex = 0 ;
                        rs.executeSql(" select * from Workflow_formdetail where requestid ="+requestid+" and groupId="+groupId+"  order by id");
                        while(rs.next()){
                              isttLight = !isttLight ;
                        %>
                        <TR class="wfdetailrowblock">
                        <td width="3%">
                        <%=derecorderindex+1%>
                        </td>
                        <%
                                for(int i=0;i<defieldids.size();i++){         // 明细记录循环开始



                                    defieldid=(String)defieldids.get(i);  //字段id
                                    defieldname = (String)defieldnames.get(i);  //字段名



                                    defieldtype = (String)defieldtypes.get(i);
                                    isdeview=(String)isdeviews.get(i);     //字段是否显示
                                    defieldhtmltype = (String) defieldhtmltypes.get(i);
                                    if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环


                                    deimgwidth = (String) deimgwidths.get(i);
                		             deimgheight = (String) deimgheights.get(i);

                                    defieldvalue=Util.null2String(rs.getString(defieldname)) ; 
                        %>
                        <td  <%if(defieldhtmltype.equals("1") && (defieldtype.equals("2") || defieldtype.equals("3"))){%> align="right" <%}else{%> style="LEFT: 0px; WIDTH: <%=colwidth1%>%; word-wrap:break-word;word-break:break-all;TEXT-VALIGN: center"<%}%>>
                        <%                                      
                                     if(defieldhtmltype.equals("1")){                          // 单行文本框



                                        /*---------xwj for td3131 20051116 begin -------*/
										String datavaluetype ="";
                                         if(defieldtype.equals("2")){
                                       	  datavaluetype = " datatype='int' datetype='int' datalength='0' ";
                                         }else if(defieldtype.equals("3")||defieldtype.equals("4")){
                                       	  int datalength =2;
                                       	  if(defieldvalue.indexOf(".")>=0){
                                       		  datalength= defieldvalue.substring(defieldvalue.indexOf(".")+1,defieldvalue.length()).length();
                                       	  }
                                       	  datavaluetype = " datatype='float' datetype='float' datalength='"+datalength+"' ";
                                         }else if(defieldtype.equals("5")){
                                       	  int datalength =2;
                                       	  if(defieldvalue.indexOf(".")>=0){
                                       		  datalength= defieldvalue.substring(defieldvalue.indexOf(".")+1,defieldvalue.length()).length();
                                       	  }
                                       	  datavaluetype = "  datavaluetype='5' datatype='float' datetype='float' datalength='"+datalength+"' ";
                                         }
                                        if(defieldtype.equals("4")){
                                        %>
                                         <script language="javascript">
                                             window.document.write(numberChangeToChinese(<%=defieldvalue%>));
                                         </script>
                                        <%}
                                        else{%>
                                       <%=defieldvalue%>
                                       <%}%>
                                        <input type=hidden <%=datavaluetype %> id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.toScreen(defieldvalue,languageidfromrequest)%>">                                        
                                          <%
                                            /*---------xwj for td3131 20051116 end -------*/
                                    }                                                       // 单行文本框条件结束



                                    else if(defieldhtmltype.equals("2")){                     // 多行文本框



                                        %>
                                        <%=Util.toScreen(defieldvalue,languageidfromrequest)%>
                                          <%
                                    }                                                           // 多行文本框条件结束



                                    else if(defieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                                        String url=BrowserComInfo2.getBrowserurl(defieldtype);     // 浏览按钮弹出页面的url
                                        String linkurl =BrowserComInfo2.getLinkurl(defieldtype);   // 浏览值点击的时候链接的url
                                        String showname = "";                                   // 新建时候默认值显示的名称
                                        String showid = "";                                     // 新建时候默认值



                                        
                                        if(defieldtype.equals("2") ||defieldtype.equals("19")  )	showname=defieldvalue; // 日期时间
                                        else if(!defieldvalue.equals("")) {
                                            ArrayList tempshowidlist=Util.TokenizerString(defieldvalue,",");
                                            if(defieldtype.equals("8") || defieldtype.equals("135")){
                                                //项目，多项目
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("1") ||defieldtype.equals("17")){
                                                //人员，多人员
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                    	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                                      	{
                                                    		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                      	}
                                                    	else
                                                        	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("142")){
												//收发文单位



												for(int k=0;k<tempshowidlist.size();k++){
													if(!linkurl.equals("")){
														showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+docReceiveUnitComInfo_vdba.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
													}else{
													showname+=docReceiveUnitComInfo_vdba.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
													}
												}
                                            }else if(defieldtype.equals("7") || defieldtype.equals("18")){
                                                //客户，多客户
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("4") || defieldtype.equals("57")){
                                                //部门，多部门
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                	String showdeptname = "";
                               						String showdeptid = (String) tempshowidlist.get(k);
                               						if(!"".equals(showdeptid)){
                               							if(Integer.parseInt(showdeptid) < -1){
                               								showdeptname = deptVirComInfo2.getDepartmentname(showdeptid);
                               								
                               							}else{
                               								showdeptname = DepartmentComInfo2.getDepartmentname(showdeptid);
                               							}
                               						}
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+showdeptname+"</a>&nbsp";
                                                    }else{
                                                    	showname+=showdeptname+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("164")||defieldtype.equals("194")){
                                                //分部
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                	String showsubcompname = "";
                            						String showsubcompid = (String) tempshowidlist.get(k);
                            						if(!"".equals(showsubcompid)){
                            							if(Integer.parseInt(showsubcompid) < -1){
                            								showsubcompname = subCompVirComInfo2.getSubCompanyname(showsubcompid);
                            							}else{
                            								showsubcompname = SubCompanyComInfo2.getSubCompanyname(showsubcompid);
                            							}
                            						}
                                                
                                                    if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+showsubcompname+"</a>&nbsp";
                                                    }else{
                                                    	showname+=showsubcompname+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("161") || defieldtype.equals("162")){
                                                //自定义单选浏览框，自定义多选浏览框
												Browser browser=(Browser)StaticObj.getServiceByFullname(DetailFieldComInfo.getFielddbtype(defieldid), Browser.class);
                                                for(int k=0;k<tempshowidlist.size();k++){
													try{
                                                        BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
			                                            String desc=Util.null2String(bb.getDescription());
			                                            String name=Util.null2String(bb.getName());							
			                                            String href=Util.null2String(bb.getHref());
			                                            if(href.equals("")){
			                                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
			                                            }else{
			                                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
			                                            }
													}catch (Exception e){
													}
                                                }
                                            }
                                            else if(defieldtype.equals("226") || defieldtype.equals("227")){
                                             			//zzl 老表单明细字段已办事宜显示数据界面



														if("NULL".equals(defieldvalue)){
															defieldvalue="";
														}
														showname+="<a title='"+defieldvalue+"'>"+defieldvalue+"</a>&nbsp";
												
                                            }
											else if(defieldtype.equals("9") || defieldtype.equals("37")){
                                                //文档，多文档
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"&desrequestid="+desrequestid+"' target='_new'>"+DocComInfo2.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=DocComInfo2.getDocname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("23")){
                                                //资产
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("16") || defieldtype.equals("152") || defieldtype.equals("171")){
                                                //相关请求
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("") && !isprint){
                                                        int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                                                        tempnum++;
                                                        session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                                                        session.setAttribute("slinkwfnum",""+tempnum);
                                                        session.setAttribute("haslinkworkflow","1");
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else{
                                                String tablename1=BrowserComInfo2.getBrowsertablename(defieldtype); //浏览框对应的表,比如人力资源表



                                                String columname=BrowserComInfo2.getBrowsercolumname(defieldtype); //浏览框对应的表名称字段



                                                String keycolumname=BrowserComInfo2.getBrowserkeycolumname(defieldtype);   //浏览框对应的表值字段




                                                if(defieldvalue.indexOf(",")!=-1){
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+" in( "+defieldvalue+")";
                                                }
                                                else {
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+"="+defieldvalue;
                                                }
                                                RecordSet.executeSql(sql);
                                                while(RecordSet.next()){
                                                    showid = Util.null2String(RecordSet.getString(1)) ;
                                                    String tempshowname= Util.toScreen(RecordSet.getString(2),languageidfromrequest) ;
													if(defieldtype.equals("263")){
														 showname +=tempshowname+" ";
													}else{
														if(!linkurl.equals("") && !isprint){
															if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
															{
																showname+="<a href='javaScript:openhrm("+showid+");' onclick='pointerXY(event);'>"+tempshowname+"</a>&nbsp";
															}
															else   
															showname += "<a href='"+linkurl+showid+"' target='_new'>"+tempshowname+"</a>&nbsp";
														}else{
															showname +=tempshowname+" ";
														}
													}
                                                }
                                            }
                                        }
                                        //add by dongping
                                        //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表



                                        if (defieldtype.equals("118")) {
                                            showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target='_blank'>"+SystemEnv.getHtmlLabelName(2193,languageidfromrequest)+"</a>" ;
                                            //showid = "<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>";
                                         }
                                   %>
                                   <%=showname%>
                                   <%
                                    }                                                       // 浏览按钮条件结束
                                    else if(defieldhtmltype.equals("4")) {                    // check框



                                           %>
                                           <input type=checkbox value=1 name="field<%=defieldid%>_<%=derecorderindex%>"  DISABLED  <%if(defieldvalue.equals("1")){%> checked <%}%> >
                                           <%
                                    }                                                       // check框条件结束



                                    else if(defieldhtmltype.equals("5")){                     // 选择框   select
                                           %>
                                           <select notBeauty=true name="field<%=defieldid%>_<%=derecorderindex%>" DISABLED >
                                           <option value=""></option><!--added by xwj for td3297 20051130-->
                                           <%
                                        // 查询选择框的所有可以选择的值



                                        RecordSet selrs=new RecordSet();
                                        selrs.executeProc("workflow_SelectItemSelectByid",""+defieldid+flag+isbill);
                                        while(selrs.next()){
                                            String tmpselectvalue = Util.null2String(selrs.getString("selectvalue"));
                                            String tmpselectname = Util.toScreen(selrs.getString("selectname"),languageidfromrequest);
                                           %>
                                           <option value="<%=tmpselectvalue%>" <%if(defieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
                                           <%
                                        }
                                           %>
                                           </select>
                                           <%
                                    }                                          // 选择框条件结束 所有条件判定结束


                                    //*********************************************************************************begin
						           else if (defieldhtmltype.equals("6")) {
						           
										if(isdeview.equals("1")){
											//System.out.println("===============defieldid:"+defieldid+"  defieldname:"+defieldname+"  defieldtype:"+defieldtype+"  defieldlable:"+defieldlable+"  defieldvalue:"+defieldvalue+"  isdeedit:"+isdeedit+"  isdemand:"+isdemand);
											otherPara_hs.put("fieldimgwidth" + defieldid, "" + deimgwidth);
											otherPara_hs.put("fieldimgheight" + defieldid, "" + deimgheight);
											//otherPara_hs.put("derecorderindex", "\"+rowindex+\"");
											otherPara_hs.put("derecorderindex", ""+derecorderindex);
											otherPara_hs.put("desrequestid", ""+desrequestid);
			  
											
											int defieldlength = 0;
											int degroupid = 0;
											HtmlElement htmlelement = new FileElement();
											Hashtable ret_hs = htmlelement.getHtmlElementString(Util.getIntValue(defieldid,0), defieldname, Util.getIntValue(defieldtype,0), defieldlable, defieldlength, 1, degroupid, defieldvalue, 0, 1, 0, 0, user, otherPara_hs);
											String deinputStr= Util.null2String((String) ret_hs.get("inputStr"));
										  
											String dejsStr = Util.null2String((String) ret_hs.get("jsStr"));
											String deaddRowjsStr = Util.null2String((String) ret_hs.get("addRowjsStr"))+"\n";
										   
											//System.out.println(deinputStr);
											
											out.println(deinputStr);
											out.println(" <script> \n "+dejsStr+" \n </script>");
											out.println(" <script> \n "+deaddRowjsStr+" \n </script>");
										}
						           }
		
		                           //*********************************************************************************end




                        %>
                        </td>
                        <%

                                }   // 明细记录循环结束
                                derecorderindex++;
                        %>
                        </tr>
                        <%
                            }       //while明细记录结束
                        %>
              </TBODY>
			  <%if(defshowsum){%>
              <TFOOT>
              <TR class=header>
                <TD ><%=SystemEnv.getHtmlLabelName(358,languageidfromrequest)%></TD>
<%
    for (int i = 0; i < defieldids.size(); i++) {
        if (!isdeviews.get(i).equals("1")) {
%>
                <td width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="display:none"></td>
                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
            <%
        } else {
            %>
                <td align="right" width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="color:red"></td>
                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                    <%
        }
    }
                    %>
              </TR>
              </TFOOT>
			  <%}%>
            </table>
            </div>
            </wea:item>
            </wea:group>
            </wea:layout>
            <%if(isprint){ %>
			</div>
			<%} %>
<input type='hidden' id="nodesnum<%=detailno%>" name="nodesnum<%=detailno%>" value="<%=derecorderindex%>">
<input type='hidden' id="indexnum<%=detailno%>" name="indexnum<%=detailno%>" value="<%=derecorderindex%>">
<input type='hidden' name=colcalnames value="<%=colCalItemStr1%>">

<%
    detailno++;
         }  //有明细才显示，结束



    }
    }
%>

<%
    ArrayList rowCalAry = new ArrayList();
    ArrayList rowCalSignAry = new ArrayList();
	ArrayList mainCalAry = new ArrayList();
    ArrayList tmpAry = null;

	StringTokenizer stk2 = new StringTokenizer(rowCalItemStr1,";");
	//out.println(rowCalItemStr1);

	ArrayList newRowCalArray = new ArrayList();

	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		rowCalAry.add(stk2.nextToken(";"));
	}
	stk2 = new StringTokenizer(mainCalStr1,";");
	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		mainCalAry.add(stk2.nextToken(";"));
	}
	//out.println(mainCalStr1);

%>

<%--<iframe name=productInfo style="width:100%;height:300;display:none"></iframe>--%>
<script language="javascript">
rowindex = <%=derecorderindex%>;
curindex = <%=derecorderindex%> ;

<%--added by Charoes Huang FOR Bug 625--%>
function parse_Float(i){
	try{
	    i =parseFloat(i);
		if(i+""=="NaN")
			return 0;
		else
			return i;
	}catch(e){
		return 0;
	}
}

function calSum(obj){

    var rows=parseInt(document.getElementById('indexnum'+obj).value);
    if(rowindex<rows)
        rowindex=rows;
    var sum=0;
    var temStr;
	var datavaluetype = "";
<%
    for(int i=0; i<colCalAry.size(); i++){
		String str = colCalAry.get(i).toString();
		str = str.substring(str.indexOf("_")+1);
         if ("0".equals(isbill)) {
        	  rs.executeSql("select fielddbtype from workflow_formdict where id=" + str);
        } else {
        	  rs.executeSql("select fielddbtype from workflow_billfield where id=" + str);
        }
		int decimaldigits_t =2;
    	if("oracle".equals(rs.getDBType())){
    		 if(rs.next()){
    	        	String fielddbtypeStr=rs.getString("fielddbtype");
    	        	if(fielddbtypeStr.indexOf("number")>=0){
    	        		int digitsIndex = fielddbtypeStr.indexOf(",");
        				if(digitsIndex > -1){
        					decimaldigits_t = Util.getIntValue(fielddbtypeStr.substring(digitsIndex+1, fielddbtypeStr.length()-1), 2);
        				}else{
        					decimaldigits_t = 2;
        				}
    	        	}else{
    	        		if(fielddbtypeStr.equals("integer")){
    	        			decimaldigits_t = 0;
    	        		}
    	        	}
    	        }
    	}else{
    		 if(rs.next()){
 	        	String fielddbtypeStr=rs.getString("fielddbtype");
 	        	if(fielddbtypeStr.indexOf("decimal")>=0){
 	        		int digitsIndex = fielddbtypeStr.indexOf(",");
     				if(digitsIndex > -1){
     					decimaldigits_t = Util.getIntValue(fielddbtypeStr.substring(digitsIndex+1, fielddbtypeStr.length()-1), 2);
     				}else{
     					decimaldigits_t = 2;
     				}
 	        	}else{
 	        		if("int".equals(fielddbtypeStr)){
 	        			decimaldigits_t = 0;
 	        		}
 	        	}
 	        }
    	}
%>
            sum=0;
            datavaluetype = "";
            for(i=0; i<rowindex; i++){
                try{
                    temStr = document.getElementById("field<%=str%>_"+i).value;
                    temStr = temStr.replace(/,/g,"");
                    if(temStr+""!=""){
                        sum+=temStr*1;
                    }
					if(document.getElementById("field<%=str%>_"+i).getAttribute("datavaluetype")){
                         datavaluetype = document.getElementById("field<%=str%>_"+i).getAttribute("datavaluetype");
                    }
                }catch(e){;}
            }
                   
        var decimalNumber = <%=decimaldigits_t%>;

		var arrSum = toPrecision(sum,decimalNumber);
		if(document.getElementById("sum<%=str%>")){
			if(datavaluetype =='5'||datavaluetype==5){
			   jQuery("#sum<%=str%>").text(changeToThousandsVal(arrSum));
			}else{
			   jQuery("#sum<%=str%>").text(arrSum);
			}
		}
		if(document.getElementById("sumvalue<%=str%>")){
			 if(datavaluetype =='5'||datavaluetype==5){
		       document.getElementById("sumvalue<%=str%>").value = changeToThousandsVal(arrSum);
		   }else{
		       document.getElementById("sumvalue<%=str%>").value = arrSum; 
		   }
		}
<%
    }
%>
}

function changeToThousandsVal(sourcevalue){
	sourcevalue = sourcevalue +"";
	if(null != sourcevalue && 0 != sourcevalue){
     if(sourcevalue.indexOf(".")<0)
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    else
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
		return sourcevalue.replace(re,"$1,");
	}else{
		return sourcevalue;
	}
}

/**
return a number with a specified precision.
*/
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);
	//add  by liaodong for qc75759 in 2013年10月23日  start
	var returnVal = isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1;
	var valInt = (returnVal.toString().split(".")[1]+"").length;
	if(aNumber == 0){
		return  "";
	}
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数



		if(lengInt == 1){
			returnVal += "0";
		}else if(lengInt == 2){
			returnVal += "00";
		}else if(lengInt == 3){
			returnVal += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				returnVal += ".0";
			}else if(precision == 2){
				returnVal += ".00";
			}else if(precision == 3){
				returnVal += ".000";
			}else if(precision == 4){
				returnVal += ".0000";
			}		
		}		
	}
	//end 
	return  returnVal;
}
/**

从"field142_0" 得到，field142
*/

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}
<%
for(int i=0;i<detailno;i++){
%>
jQuery(document).ready(function(){
	jQuery("TD[name='detailblockTD']").closest("table").css("table-layout", "fixed"); 
	calSum(<%=i%>);
});
<%
}%>
</script>
