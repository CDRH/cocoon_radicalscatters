<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="ptr">
		
	<!-- call template from rsc.globals.xsl -->
		<xsl:call-template name="findLink">
			<xsl:with-param name="id" select="./@target" />
		</xsl:call-template>

	</xsl:template>

	<xsl:template match="ref | catRef">
		
		<!-- Taking out the choose structure because there is no @rens="bibl" anymore. Once the site is fully operational, clean this up karintodo
			
			<xsl:choose>
			
		  <xsl:when test="@rend='bibl'">
		    <xsl:variable name="target" select="./@target" />
		    <abbr title="{//item[@xml:id=$target]//text()}"><xsl:apply-templates /></abbr>
		  </xsl:when>
		  <xsl:otherwise>-->
		    <!-- call template from rsc.globals.xsl -->
        <xsl:call-template name="findLink">
          <xsl:with-param name="id" select="./@target" />
        </xsl:call-template>
      <!--  </xsl:otherwise>
      </xsl:choose>-->
        
	</xsl:template>
	
</xsl:stylesheet>