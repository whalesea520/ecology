
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="weaver.conn.ConnectionPool" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="java.io.Writer" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML>
	<HEAD>

		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
	     window.UEDITOR_HOME_URL = "/mobilemode/js/ueditor/";
	    </script>
		<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
        <script type="text/javascript" charset="utf-8" src="/ueditor/ueditor.config_wev8.js"></script>
        <script type="text/javascript" charset="utf-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
        <script type="text/javascript" charset="utf-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
	</head>
	<% 
		if (!HrmUserVarify.checkUserRight("eAssistant:faq", user)) {
	        response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
	    int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	    int answerFlg = Util.getIntValue(request.getParameter("answerFlg"), 0);
        // 最后修改人ID
        int lastUserId = user.getUID();
		// 高级搜索框中的问题
		String question = Util.fromScreen(request.getParameter("question"),
				user.getLanguage());
		// 高级搜索框中的标签
		String label = Util.fromScreen(request.getParameter("label"), user
				.getLanguage());
		// 高级搜索框中的修改时间[开始]
        String doclastmoddatefrom = Util.toScreenToEdit(request.getParameter("doclastmoddatefrom"),user.getLanguage());
        // 高级搜索框中的修改时间[结束]
        String doclastmoddateto = Util.toScreenToEdit(request.getParameter("doclastmoddateto"),user.getLanguage());
        //高级搜索框中的创建人 
        String creater = Util.null2String(request.getParameter("creater"));
		// 操作的标识FLG
		String faqOperType = Util.null2String(request
				.getParameter("faqOperType"));
		// 编辑或新增页面修改过后的问题
        String changeQ = Util.null2String(request
                .getParameter("changeQ"));
        changeQ = Util.convertInput2DB(changeQ);
		// 编辑或新增页面修改过后的标签
		String changeLabel = Util.null2String(request
				.getParameter("changeLabel"));
		changeLabel = Util.convertInput2DB(changeLabel);
		// 编辑或新增页面修改过后的问题
        String changeA = Util.null2String(request
                .getParameter("changeA"));
		// 编辑页面:编辑过的FAQID
		String faqId = Util.null2String(request.getParameter("faqId"));
		//本页面要删除的问题ID
		String faqLibIDs = Util.null2String(request
				.getParameter("faqLibIDs"));
		// 正常搜索框中搜索条件
		String f_name = Util.null2String(request.getParameter("f_name"));
		// 是否其他表更新数据(只能更新标签)
        String labelOnlyFlg = Util.null2String(request.getParameter("labelOnlyFlg"));
		//高级搜索框中数据同步到普通搜索框中
		String searchQuestion = Util.null2String(request.getParameter("searchQuestion"));
		f_name = searchQuestion;
		if(!"".equals(question) && "".equals(f_name)){
			f_name = question;
		}
		//获得当前的日期和时间
        Date newdate = new Date() ;
        long datetime = newdate.getTime() ;
        Timestamp timestamp = new Timestamp(datetime) ;
        String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
        String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
        
        // 批量删除时,取sourceID以便对表indexupdatelog进行一条一条插入
        String[] faqIDForDelArr = faqLibIDs.split(","); 
        
        RecordSet rs = new RecordSet();
        RecordSet rsUpdLog = new RecordSet();
        
        // 问题状态设置0:已回答 1:未回答
        int faqStatus = 0;
        if(changeA !=null && !changeA.trim().equals("")){
        	faqStatus = 0;
        }else{
        	faqStatus = 1;
        }
        boolean isoracle = (new RecordSet().getDBType()).equals("oracle");
		if ("edit".equals(Util.null2String(faqOperType))) {
			String ChangeSql = "";
			if("true".equals(labelOnlyFlg)){
				String changeLabelSql = "update FULLSEARCH_FAQDETAIL set FAQLABEL = '"+ changeLabel+"' , FAQLASTMODDATE = '"+CurrentDate+"',FAQLASTMODTIME='"+CurrentTime+"'  WHERE ID = " + faqId;
				rs.execute(changeLabelSql);
				// FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
				String updLogSql = "";
				if(isoracle){
					updLogSql = "INSERT INTO  INDEXUPDATELOG (ID,DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES (indexupdatelog_Id.nextval,"+faqId+",'FAQ','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
				}else{
				    updLogSql = "INSERT INTO  INDEXUPDATELOG (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES ("+faqId+",'FAQ','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
				}
                rsUpdLog.executeSql(updLogSql);
				
			}else{
				// 对单一文档标签进行更新
				if(isoracle){
					Connection conn=null;
		            PreparedStatement stat=null;
		            ResultSet resultSet=null;
		            try {
		            	ChangeSql = "UPDATE FULLSEARCH_FAQDETAIL SET FAQLABEL = '"
		                    + changeLabel
		                    + "',FAQANSWER=empty_clob() ,FAQDESC='"+changeQ+"',FAQSTATUS="+faqStatus+" , FAQLASTMODDATE = '"+CurrentDate+"',FAQLASTMODTIME='"+CurrentTime+"',FAQLASTEDITID = "+lastUserId+" WHERE ID = "
		                    + faqId;
		                new RecordSet().executeSql(ChangeSql);
	
		                conn= ConnectionPool.getInstance().getConnection();
		                conn.setAutoCommit(false);
	
		                // 3.需要使用for update方法来进行更新，
		                // 但是，特别需要注意，如果原来CLOB字段有值，需要使用empty_clob()将其清空。
		                // 如果原来是null，也不能更新，必须是empty_clob()返回的结果。
		                stat = conn.prepareStatement("select FAQANSWER from FULLSEARCH_FAQDETAIL where id="+ faqId+" for update");
		                resultSet = stat.executeQuery();
		                if (resultSet.next()) {
		                    oracle.sql.CLOB clob = (oracle.sql.CLOB) resultSet.getClob("FAQANSWER");
		                    Writer outStream = clob.getCharacterOutputStream();
		                    char[] c = changeA.toCharArray();
		                    outStream.write(c, 0, c.length);
		                    outStream.flush();
		                    outStream.close();
		                }
		                conn.commit();
	
		            } catch (Exception e) {
		                new BaseBean().writeLog(e.getMessage());
		            } finally {
		                if (resultSet!=null) {
		                    try {
		                        resultSet.close();
		                    } catch (SQLException e) {
		                        e.printStackTrace();
		                    }
		                }
		                if (stat!=null) {
		                    try {
		                        stat.close();
		                    } catch (SQLException e) {
		                        e.printStackTrace();
		                    }
		                }
		                if (conn!=null) {
		                    try {
		                        conn.close();
		                    } catch (SQLException e) {
		                        e.printStackTrace();
		                    }
		                }
		                 // FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
	                    String updLogSql = "INSERT INTO  INDEXUPDATELOG (ID,DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES (indexupdatelog_Id.nextval,"+faqId+",'FAQ','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
	                    rsUpdLog.executeSql(updLogSql);
		            }
				
				}else{
					ChangeSql = "UPDATE FULLSEARCH_FAQDETAIL SET FAQLABEL = '"
							+ changeLabel
							+ "',FAQANSWER='"+changeA+"',FAQDESC='"+changeQ+"',FAQSTATUS="+faqStatus+" , FAQLASTMODDATE = '"+CurrentDate+"',FAQLASTMODTIME='"+CurrentTime+"',FAQLASTEDITID = "+lastUserId+" WHERE ID = "
							+ faqId;
					// FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
		            if(rs.executeSql(ChangeSql)){
		                String updLogSql = "INSERT INTO  INDEXUPDATELOG (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES ("+faqId+",'FAQ','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
		                rsUpdLog.executeSql(updLogSql);
		            }
				}
			}

		} else if ("del".equals(Util.null2String(faqOperType))) {
			// 对单一或者批量标签进行删除
			String delSql = "DELETE FROM FULLSEARCH_FAQDETAIL where id in("
					+ faqLibIDs + ")";

			// FullSearch_CusLabel删除成功后,对表indexupdatelog进行插入操作
            if(rs.executeSql(delSql)){
                String updLogSql = "";
                for(int i = 0; i<faqIDForDelArr.length; i++){
                	if(isoracle){
                		updLogSql = "INSERT INTO  INDEXUPDATELOG (ID,DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES (indexupdatelog_Id.nextval,"+faqIDForDelArr[i]+",'FAQ','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                	}else{
                		updLogSql = "INSERT INTO  INDEXUPDATELOG (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES ("+faqIDForDelArr[i]+",'FAQ','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                	}
                    rsUpdLog.executeSql(updLogSql);
                }
            }

		} else if ("add".equals(Util.null2String(faqOperType))) {
			String insertFaqSql  = "";
			String maxid = "";
            // 对单一文档标签进行更新
            if(isoracle){
                Connection conn=null;
                PreparedStatement stat=null;
                ResultSet resultSet=null;
                try {
                	insertFaqSql = "INSERT INTO FULLSEARCH_FAQDETAIL (FAQLABEL,FAQDESC,FAQLASTMODDATE,FAQLASTMODTIME,FAQANSWER,FAQSTATUS,FAQCREATEDATE,FAQCREATETIME,FAQCREATEID,FAQLASTEDITID) VALUES('"+changeLabel+"','"+changeQ+"','"+CurrentDate+"','"+CurrentTime+"',empty_clob(),"+faqStatus+",'"+CurrentDate+"','"+CurrentTime+"',"+lastUserId+","+lastUserId+")";
                	
                    new RecordSet().executeSql(insertFaqSql);

                    conn= ConnectionPool.getInstance().getConnection();
                    conn.setAutoCommit(false);

                    // 3.需要使用for update方法来进行更新，
                    // 但是，特别需要注意，如果原来CLOB字段有值，需要使用empty_clob()将其清空。
                    // 如果原来是null，也不能更新，必须是empty_clob()返回的结果。
                    String getMaxIdSql = "select max(id) maxid from FULLSEARCH_FAQDETAIL";
                    RecordSet rs3 = new RecordSet();
                    rs3.executeSql(getMaxIdSql);
                    rs3.next();
                    maxid = rs3.getString("maxid");
                    stat = conn.prepareStatement("select FAQANSWER from FULLSEARCH_FAQDETAIL where id="+ maxid+" for update");
                    resultSet = stat.executeQuery();
                    if (resultSet.next()) {
                        oracle.sql.CLOB clob = (oracle.sql.CLOB) resultSet.getClob("FAQANSWER");
                        Writer outStream = clob.getCharacterOutputStream();
                        char[] c = changeA.toCharArray();
                        outStream.write(c, 0, c.length);
                        outStream.flush();
                        outStream.close();
                    }
                    conn.commit();

                } catch (Exception e) {
                    new BaseBean().writeLog(e.getMessage());
                } finally {
                    if (resultSet!=null) {
                        try {
                            resultSet.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    if (stat!=null) {
                        try {
                            stat.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    if (conn!=null) {
                        try {
                            conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                     // FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
                    String updLogSql = "insert into  indexupdatelog (ID,DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values (indexupdatelog_Id.nextval,"+maxid+",'FAQ','INSERT','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
                
            }else{
				insertFaqSql = "INSERT INTO FULLSEARCH_FAQDETAIL (FAQLABEL,FAQDESC,FAQLASTMODDATE,FAQLASTMODTIME,FAQANSWER,FAQSTATUS,FAQCREATEDATE,FAQCREATETIME,FAQCREATEID,FAQLASTEDITID) VALUES('"+changeLabel+"','"+changeQ+"','"+CurrentDate+"','"+CurrentTime+"','"+changeA+"',"+faqStatus+",'"+CurrentDate+"','"+CurrentTime+"',"+lastUserId+","+lastUserId+")";
				RecordSet rs2 = new RecordSet();
				// FullSearch_CusLabel插入成功后,对表indexupdatelog进行插入操作
                if(rs2.execute(insertFaqSql)){
                	String getMaxIdSql = "select max(id) maxid from FULLSEARCH_FAQDETAIL";
                	RecordSet rs3 = new RecordSet();
                	rs3.executeSql(getMaxIdSql);
                	rs3.next();
                	maxid = rs3.getString("maxid");
                    String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+maxid+",'FAQ','INSERT','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
            }
			
            String fromFaqId = Util.null2String(request.getParameter("fromFaqId"));
          	//直接标记 已录入问题库
          	if(!"".equals(fromFaqId)){
	    		rs.execute("update Fullsearch_E_Faq set targetFlag=1 where id="+fromFaqId);
          	}
          
		}

		StringBuffer sqlwhere = new StringBuffer();
		if(answerFlg == 0){
			sqlwhere.append(" where faqStatus = 0 ");
		}else if(answerFlg == 1){
			sqlwhere.append(" where faqStatus = 1 ");
		}

		// 对普通搜索框中的问题进行SQL拼接
		if (!"".equals(f_name)) {
			sqlwhere.append(" and faqDesc like '%" + f_name + "%'");
		}

		// 对高级搜索框中的问题进行SQL拼接
		if (!"".equals(question)) {
			sqlwhere.append(" and faqDesc like '%" + question + "%'");
		}

		// 对高级搜索框中的标签进行SQL拼接
		if (!"".equals(label)) {
			String[] labelArr = label.split(" ");
			if (labelArr.length > 0) {
				for (int i = 0; i < labelArr.length; i++) {
					sqlwhere.append(" and faqlabel like '%" + labelArr[i]
							+ "%'");
				}
			} else {
				sqlwhere.append(" and faqlabel like '%" + label + "%'");
			}

		}

		// 对高级搜索框中的修改时间进行SQL拼接
		if (!"".equals(doclastmoddatefrom) && !"".equals(doclastmoddateto)) {
			sqlwhere.append("and faqlastmoddate >= '"+doclastmoddatefrom+"' and  faqlastmoddate <= '"+doclastmoddateto+"'");
		}
		
		//对高级搜索框中的创建人进行SQL拼接
        if (!"".equals(creater) && !"".equals(creater)) {
            sqlwhere.append("and faqcreateId in ("+creater+")");
        }
		
		String sqlOrderBy = "faqlastmoddate desc,faqlastmodtime";
		
		int unAnswerCount = 0;
		String unAnswerCountSql = "select count(1) count from FULLSEARCH_FAQDETAIL where faqStatus = 1";
		rs.execute(unAnswerCountSql);
		if(rs.next()){
			unAnswerCount = rs.getInt("count");
		}

		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename =SystemEnv.getHtmlLabelName(128696,user.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(83476, user.getLanguage())
					+ ",javascript:doAdd(),_self} ";
			RCMenu += "{"
                   + SystemEnv.getHtmlLabelName(18577, user.getLanguage())
                   + ",javascript:doExcel(),_self} ";
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(32136, user.getLanguage())
					+ ",javascript:delFaq(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="weaverA" name="weaverA" method="post"
                action="ViewFaqLib.jsp">
        <input type="hidden" id="searchQuestion" name="searchQuestion" value="">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(83476, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="doAdd()" />
					<input type="button"
                        value="<%=SystemEnv.getHtmlLabelName(18577, user.getLanguage())%>"
                        class="e8_btn_top middle" onclick="doExcel()" />
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="delFaq()" />
					<input type="text" class="searchInput" id="f_name" name="f_name" value="<%=f_name%>" />
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
            <span id="hoverBtnSpan" class="hoverBtnSpan">
                <span id="ALL" val="0" onclick="clickTab(this)" class="tabClass <%=(timeSag == 0 || timeSag < 0)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>
                <span id="TODAY" val="1" onclick="clickTab(this)" class="tabClass <%=(timeSag == 1)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></span>
                <span id="WEEK" val="2" onclick="clickTab(this)" class="tabClass <%=(timeSag == 2)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></span>
                <span id="MOUTH" val="3" onclick="clickTab(this)" class="tabClass <%=(timeSag == 3)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></span>
                <span id="SEASON" val="4" onclick="clickTab(this)" class="tabClass <%=(timeSag == 4)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></span>
                <span id="YEAR" val="5" onclick="clickTab(this)" class="tabClass <%=(timeSag == 5)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></span>
                
            </span>
         </div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			
				<input type="hidden" name="faqOperType" id="faqOperType">
	            <input type="hidden" name="faqLibIDs">
	            <input type="hidden" name="answerFlg" id="answerFlg" value="<%=answerFlg %>">
				<wea:layout type="4col">
					<wea:group
						context='<%=SystemEnv.getHtmlLabelName(20331, user
									.getLanguage())%>'>
                        <!-- 问题 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(24419, user
										.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" id="question" name="question"
								value="<%=question%>" class="InputStyle" onchange="setKeyword('question','searchQuestion')">
						</wea:item>

                        <!-- 标签 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(176, user
										.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" id="label" name="label" value="<%=label%>"
								class="InputStyle">
							</span>
						</wea:item>
						<!-- 修改时间 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(26805, user
										.getLanguage())%></wea:item>
						<wea:item>
		                    <span class="wuiDateSpan" selectId="doclastmoddateselect">
		                        <input class=wuiDateSel type="hidden" name="doclastmoddatefrom" value="<%=doclastmoddatefrom%>">
		                        <input class=wuiDateSel  type="hidden" name="doclastmoddateto" value="<%=doclastmoddateto%>">
		                    </span>
		                </wea:item>
                        
                        <wea:item><%=SystemEnv.getHtmlLabelName(126493,user.getLanguage())%></wea:item>
                        <wea:item>
		                    <brow:browser viewType="0" name="creater" browserValue='<%=creater%>' 
		                    browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
		                    hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
		                    completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
		                    browserSpanValue='<%= Util.toScreen(ResourceComInfo.getMulResourcename(creater),user.getLanguage()) %>'></brow:browser>
	                    </wea:item>
                        
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" onclick="doSubmit();" class="e8_btn_submit"
								value="<%=SystemEnv.getHtmlLabelName(197, user
										.getLanguage())%>" />
							<input type="button"
								value="<%=SystemEnv.getHtmlLabelName(2022, user
										.getLanguage())%>"
								class="e8_btn_cancel" onclick="resetCondtion();jQuery('#f_name').val('');jQuery('#f_name',parent.document).val('')" />
							<input type="button"
								value="<%=SystemEnv.getHtmlLabelName(201, user
										.getLanguage())%>"
								class="e8_btn_cancel" id="cancel" />
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
		</div>
		<%
			String tableString = "";
			int perpage = 10;
			String backfields = " ID, FAQDESC, FAQLABEL, FAQLASTMODDATE, FAQLASTMODTIME,FAQCREATEDATE,FAQCREATETIME,FAQCREATEID";
			String fromSql = " FULLSEARCH_FAQDETAIL";
			tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
					+ PageIdConst.getPageSize(PageIdConst.FAQ_ViewMessage, user
							.getUID())
					+ "\" >"
					+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:sourceid\" showmethod=\"weaver.fullsearch.EAssistantViewMethod.getCheckbox\"  />"
					+ "       <sql backfields=\""
					+ backfields
					+ "\" sqlform=\""
					+ fromSql
					+ "\"  sqlwhere=\""
					+ Util.toHtmlForSplitPage(sqlwhere.toString())
					+ "\"  sqlorderby=\""
					+ sqlOrderBy
					+ "\" sqlprimarykey=\"ID\" sqlsortway=\"DESC\" />"

					+ "       <head>"
                    //问题
					+ "           <col width=\"35%\"  text=\""
					+ SystemEnv.getHtmlLabelName(24419, user.getLanguage())
					+ "\" column=\"FAQDESC\" orderkey=\"FAQDESC\" otherpara=\"column:id\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.changeLabelInfo\"/>"
                    //其他文法
					+ "           <col width=\"25%\"  text=\""
					+ SystemEnv.getHtmlLabelName(129059, user.getLanguage())
					+ "\" column=\"FAQLABEL\" orderkey=\"FAQLABEL\"/>"
					//创建人
                    + "           <col width=\"10%\"  text=\""
                    + SystemEnv.getHtmlLabelName(126493, user.getLanguage())
                    + "\" column=\"FAQCREATEID\" orderkey=\"FAQCREATEID\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getDocCreaterResource\" />"
                    //创建时间
					+ "           <col width=\"15%\"  text=\""
                    + SystemEnv.getHtmlLabelName(30436, user.getLanguage())
                    + "\" column=\"FAQCREATEDATE\" otherpara=\"column:FAQCREATETIME\" orderkey=\"FAQCREATEDATE,FAQCREATETIME\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getFullDate\" />"
					//修改时间
					+ "           <col width=\"15%\"  text=\""
                    + SystemEnv.getHtmlLabelName(26805, user.getLanguage())
                    + "\" column=\"FAQLASTMODDATE\" otherpara=\"column:FAQLASTMODTIME\" orderkey=\"FAQLASTMODDATE,FAQLASTMODTIME\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getFullDate\" />"

					+ "</head>";

			tableString += "<operates>"
					+ "		<popedom column=\"id\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getLabelId\"></popedom> "
					+ "		<operate href=\"javascript:changeLabel();\" text=\""
					+ SystemEnv.getHtmlLabelName(126036, user.getLanguage())
					+ "\" target=\"_self\" index=\"1\"/>"
					+ "		<operate href=\"javascript:delFaq();\" text=\""
					+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
					+ "\" target=\"_self\" index=\"2\"/>" + "</operates>";
			tableString += "</table>";
		%>
		<input type="hidden" name="pageId" id="pageId"
			value="<%=PageIdConst.FAQ_ViewMessage%>" />
		<wea:SplitPageTag tableString='<%=tableString%>' mode="info" />
	</body>
	<script language="javascript">
	
var dialog;
function changeLabel(id){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditFaqLibrary.jsp?faqOperType=edit&faqId="+id;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(126036,user.getLanguage())%>";
    dialog.Width = 1000;
    dialog.Height = 620;
    dialog.maxiumnable = true;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function doAdd(){
    //jQuery("input[name=faqOperType]").val("add");
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditFaqLibrary.jsp?faqOperType=add";
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(126105,user.getLanguage())%>";
    dialog.Width = 1000;
    dialog.Height = 620;
    dialog.Drag = true;
    dialog.maxiumnable = true;
    dialog.URL = url;
    dialog.show();
}

function delFaq(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))
			ids = ids +$(this).attr("checkboxId")+",";
	});
	}else {
        ids = id;
    }
    if(ids.match(/,$/)){
        ids = ids.substring(0,ids.length-1);
    }
	if(ids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
		return;
	}else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
			
	        jQuery("input[name=faqOperType]").val("del");
	        jQuery("input[name=faqLibIDs]").val(ids);
	        document.forms[0].submit();
	    });
	}
}

function doSubmit()
{
	document.forms[0].submit();
}
function resetCondtion(){
	resetCondtionBrw("advancedSearchDiv");
}

function doExcel(){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "";
    dialog.Width = 800;
    dialog.Height = 500;
    url = "/fullsearch/faqImport.jsp?importtype=faq";
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(128713, user.getLanguage())%>";
    dialog.Width = 800;
    dialog.Height = 600;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

</script>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer"
		src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<script language="javascript">

function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
    $(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
    $("#tabDiv").remove();
    $("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='f_name']",parent.document).val();
	$("#question").val(name);
	$("#searchQuestion").val(name);
	doSubmit();
}

function closeDialog(){
    _table. reLoad();
    getNumCount();
    dialog.close();
}
function getNumCount(){
    $.ajax({
        type: "POST",
        url: "/fullsearch/unAnswerCount.jsp",
        data: {},
        success:function(data){
            if(!!data)
            {
                var __data = jQuery.trim(data)
                if(__data != "")
                {
                    var _dataJson = JSON.parse(__data);
                    parent.document.getElementById("unAnswer").innerHTML="("+_dataJson.count+")";
                }
            }
        }
    });
}

function setKeyword(source,target){
    var targetVal =document.getElementById(source).value; 
    document.getElementById(target).value=targetVal;
}

</script>
<script type="text/javascript">
        jQuery(document).ready(function(){
            parent.document.getElementById("unAnswer").innerHTML="("+<%=unAnswerCount%>+")";
        });
    </script>