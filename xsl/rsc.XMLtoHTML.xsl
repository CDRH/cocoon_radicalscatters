<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:param name="doc"/>

    <xsl:template match="/">

      
            <xsl:apply-templates
                select="//TEI[@xml:id=$doc]/text/body/div1[@type='electronictranscription']"/>
  

    </xsl:template>
    
    

    <xsl:template match="*">
        
    <xsl:variable name="testing"><xsl:copy-of select="."></xsl:copy-of></xsl:variable>


        <xsl:copy-of select="."></xsl:copy-of>
 
        <!--<span class="element_start_tag">
            <span class="punctuation">&lt;</span>
            <span class="element_name">
                <xsl:value-of select="name()"/>
            </span>
            <xsl:for-each select="@*">
                <xsl:call-template name="attribute"/>
            </xsl:for-each>
            <span class="punctuation">&gt;</span><br/>
        </span>
        <xsl:for-each select="*|comment()|processing-instruction()|text()">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        <span class="punctuation">&lt;/</span>
        <span class="element_name">
            <xsl:value-of select="name()"/>
        </span>
        <span class="punctuation">&gt;</span>
    </xsl:template>

    <xsl:template name="attribute">
        <span class="attribute_name">
            <xsl:value-of select="name()"/>
        </span>
        <span class="punctuation">="</span>
        <span class="data">
            <xsl:value-of select="."/>
        </span>
        <span class="punctuation">"</span>
    </xsl:template>
    <xsl:template match="text()">
        <span class="data">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="comment()">
        <span class="comment">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="processing-instruction()">
        <span class="processing_instruction">&lt;?<xsl:value-of select="name()"/><xsl:value-of
                select="."/>?&gt;</span>-->
    </xsl:template>

</xsl:stylesheet>
