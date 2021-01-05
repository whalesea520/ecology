<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="GBK"/>
	<xsl:template match="/">
		<HTML>
			<HEAD>
				<link href="/css/Weaver.css" type="text/css" rel="styleSheet"/>
			</HEAD>
			<body onload="initRow()">
				<!--
				<br/>
				-->
				<TABLE id="tbl" class="ViewForm" style="width:100%" cellspacing="0" cellpadding="0">
					<COLGROUP>
						<COL width="60%"/>
						<COL width="15%"/>
						<COL width="25%"/>
					</COLGROUP>
					<!--
					<TR>
						<TD colspan="3"><xsl:value-of select="/ROOT/@replyCount"/></TD>
					</TR>
					<TR>
						<TD CLASS="line1" colspan="3"/>
					</TR>
					-->
					<xsl:call-template name="maindoc"/>
				</TABLE>
			</body>
		</HTML>
	</xsl:template>
	<xsl:template match="/ROOT/DOC" name="maindoc">
		<!--以下是第一行表示正文-->
		<xsl:param name="mainDocid" select="/ROOT/DOC/@id"/>
		<TR id="TR_{$mainDocid}">
			<TD>
				<TABLE class="ViewForm" cellspacing="0" cellpadding="0">
					<TR>
						<TD align="right" width="{/ROOT/DOC/@imgWidth}"/>
						<TD width="97%">
							<img src="\images\replyDoc\openfld.gif"/>
							<a href="\docs\docs\DocDsp.jsp?id={$mainDocid}">
								<font color="#FF0000">
								<xsl:value-of select="/ROOT/DOC/@subject"/>
								</font>
							</a>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<img src="\images\replyDoc\userinfo.gif" border="0"/>
				<a href="javaScript:openFullWindowForXtable('{/ROOT/DOC/@userLinkUrl}')">
					<xsl:value-of select="/ROOT/DOC/@creater"/>
				</a>
			</TD>
			<TD>
				<xsl:value-of select="/ROOT/DOC/@date"/>
			</TD>
		</TR>
		<TR>
			<TD CLASS="line" colspan="3"/>
		</TR>
		<!--循环着显示着下面的每一个节点-->
		<xsl:for-each select="descendant::DOC[position()!=1]">
			<TR id="tr_outer_{@id}">
				<td colspan="3">
					<TABLE width="100%" class="ViewForm" cellspacing="0" cellpadding="0">
						<TR id="tr_inner_{@id}" hrefStatus="close">
							<TD width="{@imgWidth}">	
									</TD>
							<TD>
								<img src="\images\replyDoc\{@docImg}"/>
								<xsl:choose>
									<xsl:when test="@canRead='yes'">
										
										<xsl:choose>
										<xsl:when test="@docId=@id">
										<B><a href="javaScript:clickLink(tr_inner_{@id},tr_outer_{@id},{@id})"><xsl:value-of select="@subject"/></a></B>
										</xsl:when>
										<xsl:otherwise>
										<a href="javaScript:clickLink(tr_inner_{@id},tr_outer_{@id},{@id})"><xsl:value-of select="@subject"/></a>
										</xsl:otherwise>
										</xsl:choose>
										
									</xsl:when>
									<xsl:otherwise>
									
										<xsl:choose>
										<xsl:when test="@docId=@id">
										<B><xsl:value-of select="@subject"/></B>
										</xsl:when>
										<xsl:otherwise>
										<xsl:value-of select="@subject"/>
										</xsl:otherwise>
										</xsl:choose>
                                        
                              		</xsl:otherwise>
							</xsl:choose>
							</TD>
							<TD width="15%">
								<img src="\images\replyDoc\{@userImg}" border="0"/>
								<a href="javaScript:openFullWindowForXtable('{@userLinkUrl}')">
									<xsl:value-of select="@creater"/>
								</a>
							</TD>
							<TD width="25%">
								<xsl:value-of select="@date"/>
							</TD>
						</TR>
					</TABLE>
				</td>
			</TR>
			<TR>
				<TD CLASS="line" colspan="3"/>
			</TR>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
