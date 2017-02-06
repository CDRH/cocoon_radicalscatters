<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xhtml" indent="no" encoding="utf-8"/>
    
    <xsl:strip-space elements="*"/>

    <xsl:param name="requestDoc"/>
    <xsl:param name="ref"/>
    <xsl:param name="qstring"/>

    <xsl:variable name="validViews" select="'read', 'facs', 'tran', 'sgml'"/>
    <xsl:variable name="doc">
        <xsl:choose>
            <xsl:when
                test="substring($requestDoc, (string-length($requestDoc) - 3), 4) = $validViews">
                <xsl:value-of select="substring($requestDoc, 0, (string-length($requestDoc) - 4))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$requestDoc"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="view">
        <xsl:choose>
            <xsl:when test="$doc=$requestDoc">read</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring($requestDoc, (string-length($requestDoc) - 3), 4)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


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
                        <xsl:with-param name="docType" select="'tei'"/>
                        <xsl:with-param name="refFrom" select="$ref"/>
                        <xsl:with-param name="currId" select="$doc"/>
                        <xsl:with-param name="qstring" select="$qstring"/>
                    </xsl:call-template>
                </p>

                <xsl:apply-templates select="//TEI[@xml:id=$doc]"/>
            </body>
        </html>

    </xsl:template>

    <xsl:template match="TEI">

        <h1>
            <xsl:apply-templates select="./teiHeader/fileDesc/titleStmt/title"/>
        </h1>


        <div class="metadata">
            <xsl:call-template name="generateMetadata">
                <xsl:with-param name="wholeDoc" select="."/>
            </xsl:call-template>
        </div>

        <div class="mainContent">
            <!-- Decide which content view to show -->
            <xsl:variable name="params">
                <xsl:if test="$ref">?ref=<xsl:value-of select="encode-for-uri($ref)"/></xsl:if>
            </xsl:variable>
            <div class="viewMenu">
                <ul>
                    <li>
                        <a href="mss/{$doc}.read.html{$params}">
                            <xsl:if test="$view='read'">
                                <xsl:attribute name="class">selected</xsl:attribute>
                            </xsl:if> Reading View</a>
                    </li>
                    <li>
                        <a href="mss/{$doc}.facs.html{$params}">
                            <xsl:if test="$view='facs'">
                                <xsl:attribute name="class">selected</xsl:attribute>
                            </xsl:if> Facsimile</a>
                    </li>
                    <li>
                        <a href="mss/{$doc}.tran.html{$params}">
                            <xsl:if test="$view='tran'">
                                <xsl:attribute name="class">selected</xsl:attribute>
                            </xsl:if> Transcription</a>
                    </li>
                    <li>
                        <a href="mss/{$doc}.sgml.html{$params}">
                            <xsl:if test="$view='sgml'">
                                <xsl:attribute name="class">selected</xsl:attribute>
                            </xsl:if> Encoding</a>
                    </li>
                </ul>
            </div>
            <div class="mainTextDiv">

                <xsl:choose>
                    <xsl:when test="$view='facs'">
                        <xsl:call-template name="imageViewer">
                            <xsl:with-param name="images"
                                select="./text/body/div1[@type='manuscriptfacsimile']"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$view='tran'">
                        <xsl:call-template name="imageViewer">
                            <xsl:with-param name="images"
                                select="./text/body/div1[@type='diplomatictranscription']"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$view='sgml'">
                        <xsl:variable name="textRepresentation"><xsl:value-of select="$BASE_HREF"
                        />mss/txt/<xsl:value-of select="$doc"/>.xml</xsl:variable>
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="$textRepresentation"/></xsl:attribute></a>
                        
                        <a
                            href="{$textRepresentation}"
                            onclick="window.open(this.href);return false;">View in New Window</a><br/>Right click and choose "save link as..." or "save target as..." to download XML
                        <!--<xsl:copy-of select="document($textRepresentation)/txt/*"/>-->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select="./text/body/div1[@type='electronictranscription']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="generateMetadata">
        <xsl:param name="wholeDoc"/>


        <ul id="menu">
            <li>
                <a href="#" class="expanded">Physical Description</a>
                <ul class="physicalDesc">
                    <xsl:for-each select="$wholeDoc/teiHeader//physDesc/p">
                        <li>
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>

            <li>
                <a href="#" class="collapsed">Collection</a>
                <ul class="collection">
                    <xsl:for-each select="$wholeDoc/teiHeader/fileDesc/sourceDesc/bibl">
                        <li>
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>

            <xsl:if test="$wholeDoc/text/back/div[@type='Transmission_History']">
                <li>
                    <a href="#" class="collapsed">Transmission History</a>
                    <ul class="history1">
                        <li>
                            <xsl:apply-templates
                                select="$wholeDoc/text/back/div[@type='Transmission_History']"/>

                        </li>
                    </ul>
                </li>
            </xsl:if>

            <xsl:if test="$wholeDoc/text/back/div[@type='Transmission_History']">
                <li>
                    <a href="#" class="collapsed">Publication History</a>
                    <ul class="history2">
                        <li>
                            <xsl:apply-templates
                                select="$wholeDoc/text/back/div[@type='Publication_History']"/>
                        </li>
                    </ul>
                </li>
            </xsl:if>

            <li>
                <a href="#" class="collapsed">Commentary</a>
                <ul class="commentary">
                    <li>
                        <xsl:apply-templates
                            select="$wholeDoc/text/back/div[@type='Critical_Commentary']"/>
                    </li>
                </ul>
            </li>


            <li>
                <a href="#" class="collapsed">Tags</a>
                <ul class="codes">
                    <li>
                        <xsl:apply-templates select="$wholeDoc/teiHeader/profileDesc"/>
                    </li>
                </ul>
            </li>
        </ul>

    </xsl:template>

<!--    <xsl:template match="physDesc">
        <ul>
            <xsl:for-each select="./note">
                <li>-->
                    <!-- Doesn't work because of nested tags <strong><xsl:value-of select="substring-before(./text(), ':')" />: </strong>
                    <xsl:value-of select="substring-after(./text(), ':')"></xsl:value-of>-->
<!--                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>-->

    <xsl:template match="profileDesc">
        <ul>
            <xsl:for-each select="./textClass/catRef">
                <xsl:variable name="target" select="./@target"/>
                <li>
                    <!--<xsl:value-of select="/TEICORPUS.2/teiHeader/ENCODINGDESC/CLASSDECL/TAXONOMY/CATEGORY[@id=$target]/CATDESC/@N" />-->
                    <xsl:apply-templates select="."/>
                    <!-- This linking is handled in rsc.linking.xsl -->
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>


    <xsl:template match="div1[@type='electronictranscription']/div2">
        <span class="editorial">&lt; <xsl:value-of select="./@xml:id"/>
            <xsl:if test="./@type">; <xsl:value-of select="./@type"/></xsl:if>
            <xsl:if test="./milestone/@rend">; <xsl:value-of select="./milestone/@rend"/></xsl:if>
            <xsl:if test="./@ink">; <xsl:value-of select="./@ink"/></xsl:if> &gt;</span>
        <br/>
        <xsl:apply-templates/>
    </xsl:template>



    <xsl:template name="imageViewer">
        <xsl:param name="images"/>
        <div class="imageView">
            <xsl:for-each select="$images/figure">
                <p>
                    <img
                        src="images/figures/500px/{graphic/@url}"
                        alt="{@id}"/>
                    <br/>
                    <a
                        href="images/figures/500px/{graphic/@url}"
                        onclick="window.open(this.href,'{graphic/@url}500','height=520,width=520,toolbar=no,directories=no,status=no,menubar=no,scrollbars=no');return false;">View in New Window</a>
                    <xsl:if test="not(ends-with(graphic/@url, 't.jpg'))"><br/><a
                        href="images/figures/1000px/{graphic/@url}"
                        onclick="window.open(this.href,'{graphic/@url}1000');return false;">View larger in New Window</a></xsl:if>
    
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    

</xsl:stylesheet>
