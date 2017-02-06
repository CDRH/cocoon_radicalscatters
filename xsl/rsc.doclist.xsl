<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xhtml" encoding="utf-8" indent="no"/>

<xsl:param name="doc" />

<xsl:include href="rsc.globals.xsl" />
<xsl:include href="rsc.formatting.xsl" />
<xsl:include href="rsc.linking.xsl" />


<!-- Converted to P5 -KD -->


<xsl:template match="/">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>Radical Scatters</title>
<base href="{$BASE_HREF}" />
<link rel="stylesheet" media="all" href="css/formatting.css" />

</head>

<body>

<h1>Document List</h1>
<ul>

<xsl:for-each select="//TEI">

<li><a href="mss/{./@xml:id}.facs.html"><xsl:value-of select="./@xml:id" /></a></li>
</xsl:for-each>
</ul>
</body>
</html>

</xsl:template>


</xsl:stylesheet>