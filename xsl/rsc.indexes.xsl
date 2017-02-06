<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xhtml" encoding="utf-8" indent="no"/>

    <!-- Converted to p5 -KD -->

    <!-- @id of category, or @n of Taxonomy for index of documents or just categories in a given tax. -->
    <xsl:param name="id"/>
    <xsl:param name="ref"/>

    <xsl:include href="rsc.globals.xsl"/>
    <xsl:include href="rsc.formatting.xsl"/>
    <xsl:include href="rsc.linking.xsl"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <title>Browse</title>
                <base href="{$BASE_HREF}"/>
                <link rel="stylesheet" media="all" href="css/formatting.css"/>
            </head>
            <body>

                <xsl:variable name="taxonomy">
                    <xsl:choose>
                        <xsl:when
                            test="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy[lower-case(@n)=$id]">
                            <xsl:value-of
                                select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy[lower-case(@n)=$id]/@n"
                            />
                        </xsl:when>
                        <xsl:when
                            test="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy/category[lower-case(@xml:id)=$id]">
                            <xsl:value-of
                                select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy[./category/@xml:id=lower-case($id)]/@n"
                            />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="category">
                    <xsl:choose>
                        <xsl:when
                            test="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy/category[lower-case(@xml:id)=$id]">
                            <xsl:value-of
                                select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy/category[lower-case(@xml:id)=$id]/@xml:id"
                            />
                        </xsl:when>
                        <xsl:otherwise> </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <h1>
                    <!-- Calling template in rsc.globals.xsl -->
                    <xsl:call-template name="uc_first">
                        <xsl:with-param name="string" select="$taxonomy"/>
                    </xsl:call-template>
                    
                </h1>

                <!-- Call template in rsc.globals.xsl -->
                <p class="breadCrumbs">
                    <xsl:call-template name="generateBreadcrumbs">
                        <xsl:with-param name="docType" select="'index'"/>
                        <xsl:with-param name="refFrom" select="$ref"/>
                        <xsl:with-param name="currId" select="$id"/>
                    </xsl:call-template>
                </p>

                <!-- List of all categories in taxonomy -->
                <ul class="categories">
                    <xsl:for-each
                        select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy[@n=$taxonomy]/category">
                        <li>
                            <xsl:if test="./@xml:id=$category">
                                <xsl:attribute name="class">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:variable name="thisID" select="./@xml:id"/>
                            <a href="index/{lower-case($taxonomy)}/{lower-case($thisID)}">
                                <xsl:call-template name="uc_first">
                                    <xsl:with-param name="doNotLower">true</xsl:with-param>
                                    <xsl:with-param name="string" select="./catDesc/@n"/>
                                </xsl:call-template>
                            </a>
                            <small class="count"> (<xsl:value-of
                                    select="count(//TEI[.//textClass/catRef/@target=$thisID])"
                                />)</small>
                        </li>
                    </xsl:for-each>
                </ul>

                <div class="recordSet">

                    <h2>
                        <xsl:call-template name="uc_first">
                            <xsl:with-param name="doNotLower">true</xsl:with-param>
                            <xsl:with-param name="string"
                                select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy/category[@xml:id=$category]/catDesc/@n"
                            />
                        </xsl:call-template>
                    </h2>

                    <ul class="documentRecords">

                        <xsl:for-each select="//TEI[.//textClass/catRef/@target=$category]">
                            <li>
                                <!-- Calling template from rsc.globals.xsl -->
                                <xsl:call-template name="printDocumentRecord">
                                    <xsl:with-param name="id" select="./@xml:id"/>
                                    <xsl:with-param name="ref" select="$id" />
                                </xsl:call-template>
                            </li>
                        </xsl:for-each>

                    </ul>
                </div>
            </body>
        </html>

    </xsl:template>

</xsl:stylesheet>
