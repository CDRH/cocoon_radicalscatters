<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xhtml" encoding="utf-8" indent="no"/>

  <!--<xsl:param name="file"/>-->
  <xsl:param name="ref"/>
  <!--
<xsl:variable name="div_type" select="replace($file, '_', ' ')" />
-->
  <xsl:include href="rsc.globals.xsl"/>
  <xsl:include href="rsc.formatting.xsl"/>
  <xsl:include href="rsc.linking.xsl"/>

  <xsl:template match="/">

    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Radical Scatters</title>

        <link rel="stylesheet" media="all" href="css/formatting.css"/>

      </head>

      <body>

        <!-- Call template in rsc.globals.xsl -->
        <p class="breadCrumbs">
          <xsl:call-template name="generateBreadcrumbs">
            <xsl:with-param name="docType" select="'editorial'"/>
            <xsl:with-param name="refFrom" select="$ref"/>
            <xsl:with-param name="currId" select="$file"/>
          </xsl:call-template>
        </p>

        <xsl:apply-templates select="//div1[@xml:id=$file]"/>


        <!--
<xsl:apply-templates select="//div1[@type=$div_type]" />
-->

      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
