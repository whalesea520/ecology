<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*" %>
<%@ page import="weaver.file.*,net.sf.json.*,java.util.*,java.text.*,weaver.common.DataBook" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="enumUtil" class="weaver.common.EnumUtil" scope="page" />
<jsp:useBean id="detachCommonInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />