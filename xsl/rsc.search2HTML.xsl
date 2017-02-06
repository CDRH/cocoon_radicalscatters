<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:search="http://apache.org/cocoon/search/1.0" version="2.0">

    <xsl:output method="xml" encoding="utf-8"/>
    
    <xsl:param name="doc"/>
    <xsl:param name="view"/>
    <xsl:param name="ref"/>

    <xsl:param name="queryString"/>
    
    <xsl:include href="rsc.globals.xsl"/>
    <xsl:include href="rsc.formatting.xsl"/>
    <xsl:include href="rsc.linking.xsl"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <title>Radical Scatters</title>
                <base href="{$BASE_HREF}"/>
                <link rel="stylesheet" media="all" href="css/formatting.css"/>
            </head>
            <body> 
            
            <!-- Call template in rsc.globals.xsl -->
            <p class="breadCrumbs">
            <xsl:call-template name="generateBreadcrumbs">
              <xsl:with-param name="docType" select="'search'"/>
              <xsl:with-param name="refFrom" select="$ref"/>
              <xsl:with-param name="currId" select="$queryString"/>
            </xsl:call-template>
            </p>
            
                <xsl:apply-templates select="//search:results"/>
            </body>
        </html>
        
    </xsl:template>
    
<xsl:template match="search:results">

<h1>Search</h1>

<form method="get" action="search/main">
<label for="fulltext">Commentary and Document: </label>
<input id="fulltext" type="text" size="30" name="fulltext"/><br/>
<label for="transcription">Transcription only: </label>
<input id="transcription" type="text" size="30" name="transcription"/>
<input type="submit" value="Search"/>
</form>

<h2>
<xsl:value-of select="number(/search:results/@start-index) + 1"/>&#8211;<xsl:value-of select="min(((number(/search:results/@start-index) + number(/search:results/@page-length)), number(.//search:hits/@total-count)))"/> of 
<xsl:value-of select=".//search:hits/@total-count"/> entries
</h2>

<ul>
<xsl:for-each select="//search:hit">

<li>
<a href="mss/{./search:field[@name='id']}.html?ref=search&amp;qstring={encode-for-uri($queryString)}"><xsl:value-of select="./search:field[@name='id']"/></a>
</li>

</xsl:for-each>
</ul>

</xsl:template>

</xsl:stylesheet>
