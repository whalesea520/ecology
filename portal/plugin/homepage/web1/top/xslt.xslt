<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="GBK"/>
	<xsl:param name="currpath">/portal/plugin/homepage/web1/top</xsl:param>	
	
	<xsl:template match="/">	
		<div id="divMainMenu">			
			
			
     		        <xsl:call-template name="TreeNode">   
			     <xsl:with-param name="Nodes" select="tree/*" />   
	                </xsl:call-template> 
		</div>
	</xsl:template>
	<xsl:template name="TreeNode">   
	 <!--将树集合的节点通过param传过来-->   
	 <xsl:param name="Nodes" />   
	 <!--循环所有子节点，即Item-->   
	 <xsl:for-each select="$Nodes">   
	  <!--计算子节点的数量-->   
	  	 
	  <xsl:variable name="Count" select="count(tree)" />   	  	
	  <xsl:variable name="linkAddress" select="@linkAddress" /> 
	  <xsl:variable name="icon" select="@icon" /> 
	  <xsl:variable name="openmode" select="@baseTarget" /> 
	  <xsl:variable name="id" select="@id" />  
	  <xsl:variable name="display" select="@display" /> 
	  

	  <!--如果有下级级点，则递归获取节点-->   
	  <xsl:if test="$Count>0">   
	  <xsl:choose>
		<xsl:when test="$display=1">
			  <ul id="ul_leftMenu_{$id}" style="display:block">
			   <xsl:call-template name="TreeNode">   
			     <xsl:with-param name="Nodes" select="*" />   
			    </xsl:call-template>
			   </ul>
		</xsl:when>
		  <xsl:otherwise>
			  <ul id="ul_leftMenu_{$id}" style="display:none">
			   <xsl:call-template name="TreeNode">   
			     <xsl:with-param name="Nodes" select="*" />   
			    </xsl:call-template>
			   </ul>
		</xsl:otherwise>
	 </xsl:choose>

	  
	   
	   

	  </xsl:if>   
	 </xsl:for-each>   
	</xsl:template>   
</xsl:stylesheet>
