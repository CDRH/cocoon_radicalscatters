<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml" version="2.0" xmlns:saxon="http://saxon.sf.net/"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="saxon xhtml">

  <xsl:include href="rsc.global-settings.xsl"/>
  <!--<xsl:variable name="BASE_HREF">http://libr.unl.edu:8080/cocoon/cdrh/radicalscatters/</xsl:variable>
  <xsl:variable name="BASE_HREF">http://localhost:8080/cocoon/radicalscatters_co/</xsl:variable>-->
  <xsl:param name="file"/>
  <!--
      Note about collation:
      This collation sets the default settings for comparisons in XPATH expressions to ignore case.
      When upgrading to Saxon 8.8 and up, the "default" attribute will not work and needs to be 
      replaced by a "default-collation" attribute on xsl: elements within the stylesheet.-->

  <!-- karintodo askbrian Not sure about what the previous statement means. Not sure how to check what version of saxon I am using. -->

  <!--  <saxon:collation name="english" lang="en-US" strength="primary" default="yes" />-->

  <!-- Print information about and a link to a document with the given @ID -->
  <xsl:template name="printDocumentRecord">
    <xsl:param name="id"/>
    <xsl:param name="ref"/>

    <xsl:for-each select="//TEI[@xml:id=$id]">
      <div class="docRecord">
        <xsl:variable name="url">mss/<xsl:value-of select="./@xml:id"/>.html</xsl:variable>
        <span class="preview">
          <xsl:if test=".//div1[@type='manuscriptfacsimile']/figure">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$url"/>
                <xsl:if test="$ref">?ref=<xsl:value-of select="$ref"/></xsl:if>
              </xsl:attribute>
              <!-- Call template in rsc.globals.xsl -->

              <xsl:call-template name="getThumnNail">
                <xsl:with-param name="id"
                  select=".//div1[@type='manuscriptfacsimile']/figure[1]/graphic/@url"/>
              </xsl:call-template>
            </a>
          </xsl:if>
        </span>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$url"/>
            <xsl:if test="$ref">?ref=<xsl:value-of select="$ref"/></xsl:if>
          </xsl:attribute>
          <xsl:value-of select="./@xml:id"/>
        </a>
      </div>

    </xsl:for-each>

  </xsl:template>

  <!-- Print an <img> for the thumnail of the given figure id -->
  <xsl:template name="getThumnNail">
    <xsl:param name="id"/>
    <img src="images/figures/95px/{$id}"/>
  </xsl:template>

  <!-- Print a string with the first character capitalized and the others lower case -->
  <xsl:template name="uc_first">
    <xsl:param name="string"/>
    <xsl:param name="doNotLower"/>

    <xsl:choose>
      <xsl:when test="$doNotLower = 'true'">
        <xsl:value-of select="upper-case(substring($string, 1, 1))"/>
        <xsl:value-of select="substring($string, 2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="upper-case(substring($string, 1, 1))"/>
        <xsl:value-of select="lower-case(substring($string, 2))"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!--
        This template will generate a list of links back to the home page, based on the
        current type of document, the referring page to the document if any, and the
        id of the given document.
    -->

  <xsl:template name="generateBreadcrumbs">
    <xsl:param name="docType"/>
    <xsl:param name="refFrom"/>
    <xsl:param name="currId"/>
    <xsl:param name="qstring"/>

    <xsl:variable name="sep"> > </xsl:variable>
    <a href="index.html">Home</a>
    <xsl:choose>

      <!-- TEI documents -->
      <xsl:when test=" $docType = 'tei' ">
        <xsl:copy-of select="$sep"/>
        <xsl:choose>
          <!-- Linked from library of search paths -->
          <xsl:when test="//category[@xml:id=$refFrom]">
            <a href="browse">Browse</a>
            <xsl:copy-of select="$sep"/>

            <a
              href="index/{encode-for-uri(lower-case(//taxonomy[.//category/@xml:id=$refFrom]/@n))}">
              <xsl:call-template name="uc_first">
                <xsl:with-param name="string" select="//taxonomy[.//category/@xml:id=$refFrom]/@n"/>
              </xsl:call-template>
            </a>
            <xsl:copy-of select="$sep"/>
            <a
              href="index/{encode-for-uri(lower-case(//taxonomy[.//category/@xml:id=$refFrom]/@n))}/{encode-for-uri(lower-case(//taxonomy//category[@xml:id=$refFrom]/@xml:id))}">
              <xsl:call-template name="uc_first">
                <xsl:with-param name="string"
                  select="//taxonomy//category[@xml:id=$refFrom]/catDesc/@n"/>
                <xsl:with-param name="doNotLower" select="'true'"/>
              </xsl:call-template>
            </a>
          </xsl:when>
          <!-- Linked from a main index -->
          <xsl:when test="starts-with($refFrom, 'i')">
            <a href="indices">Indices</a>
            <xsl:copy-of select="$sep"/>
            <a href="{$refFrom}.html">

              <xsl:value-of select="//div1[@xml:id=$refFrom]/head[1]"/>
            </a>
          </xsl:when>
          <!-- Linked from a search page -->
          <xsl:when test=" $refFrom = 'search' ">
            <a href="search/main">Search</a>
            <xsl:copy-of select="$sep"/>
            <a href="search/exact?qstring={encode-for-uri($qstring)}">Search Results</a>
          </xsl:when>
        </xsl:choose>
        <!-- Finally, print the name of the current TEI document -->
        <xsl:copy-of select="$sep"/>
        <xsl:call-template name="getName">
          <xsl:with-param name="id" select="$currId"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Supplementary, editorial -->
      <xsl:when test=" $docType = 'supplemental' or $docType = 'editorial' ">
        <xsl:choose>
          <xsl:when test="$refFrom = 'introductions'">
            <xsl:copy-of select="$sep"/>
            <xsl:choose>
              <xsl:when test="$currId=$refFrom"> Introductions </xsl:when>
              <xsl:otherwise>
                <a href="introductions">Introductions</a>
                <xsl:copy-of select="$sep"/>

                <xsl:value-of select="//div1[@xml:id=$currId]/head[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$refFrom = 'indices'">
            <xsl:copy-of select="$sep"/>
            <xsl:choose>
              <xsl:when test=" $refFrom = $currId "> Indices </xsl:when>
              <xsl:otherwise>
                <a href="indices">Indices</a>
                <xsl:copy-of select="$sep"/>

                <xsl:value-of select="//div1[@xml:id=$currId]/head[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$refFrom = 'browse'">
            <xsl:copy-of select="$sep"/>
            <xsl:choose>
              <xsl:when test=" $refFrom = $currId "> Browse </xsl:when>
              <xsl:otherwise>
                <a href="browse">Browse</a>
                <xsl:copy-of select="$sep"/>
                <xsl:value-of select="//div1[@xml:id=$currId]/head[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <!-- Abbreviations -->
          <xsl:when test="$refFrom = 'abbreviations'">
            <xsl:copy-of select="$sep"/>
            <xsl:choose>
              <xsl:when test=" $refFrom = $currId "> Abbreviations </xsl:when>
              <xsl:otherwise>
                <a href="abbreviations">Abbreviations</a>
                <xsl:copy-of select="$sep"/>
                <xsl:value-of select="//div1[@xml:id=$currId]/head[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <!-- User Guide -->
          <xsl:when test=" $currId = 'usg001' ">
            <xsl:copy-of select="$sep"/> User's Guide </xsl:when>
          <!-- Appendices -->
          <xsl:when test=" $currId = 'appendices' ">
            <xsl:copy-of select="$sep"/> Appendices </xsl:when>
          <!-- Bibl -->
          <xsl:when test=" $currId = 'bibliography' ">
            <xsl:copy-of select="$sep"/> Bibliography </xsl:when>
          <!-- Bibl -->
          <xsl:when test=" $currId = 'acknowledgments' ">
            <xsl:copy-of select="$sep"/> Acknowledgments </xsl:when>
          <xsl:otherwise> doctype: <xsl:value-of select="$docType"/>, ref: <xsl:value-of
              select="$refFrom"/>, id: <xsl:value-of select="$currId"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- Indices (not indices index ) -->
      <xsl:when test=" $docType = 'index'">
        <xsl:copy-of select="$sep"/>
        <a href="browse">Browse</a>
        <xsl:copy-of select="$sep"/>
        <xsl:choose>
          <xsl:when test="//taxonomy/@n = $currId">
            <xsl:call-template name="uc_first">
              <xsl:with-param name="string" select="//taxonomy[@n=$currId]/@n"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <a href="index/{encode-for-uri(lower-case(//taxonomy[.//category/@xml:id=$currId]/@n))}">
              <xsl:call-template name="uc_first">
                <xsl:with-param name="string" select="//taxonomy[.//category/@xml:id=$currId]/@n"/>
              </xsl:call-template>
            </a>
            <xsl:copy-of select="$sep"/>
            <xsl:call-template name="uc_first">
              <xsl:with-param name="string"
                select="//taxonomy//category[@xml:id=$currId]/catDesc/@n"/>
              <xsl:with-param name="doNotLower" select="'true'"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- Search pages -->
      <xsl:when test=" $docType = 'search'">
        <xsl:copy-of select="$sep"/> Search </xsl:when>

      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Given an id, return the relative url -->
  <xsl:template name="findLink">
    <xsl:param name="id"/>
    <xsl:param name="linktext"/>

    <xsl:choose>

      <!-- Link to a front section-->
      <xsl:when test="$id='lsp002'">
        <a href="browse">
          <!-- <xsl:if test="not(.//text())">
            <xsl:apply-templates
            select="/teiCorpus/TEI[@xml:id=$id]/teiHeader/fileDesc/titleStmt/title"/>aaa
            </xsl:if>-->
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      
      <xsl:when test="$id='lsp001.html#document_features'">
        <a href="{$id}">
          <!-- <xsl:if test="not(.//text())">
            <xsl:apply-templates
            select="/teiCorpus/TEI[@xml:id=$id]/teiHeader/fileDesc/titleStmt/title"/>aaa
            </xsl:if>-->
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      
      <xsl:when test="//div1[@type='introduction']/@xml:id=$id">
        <a href="{$id}.html">
          <!-- <xsl:if test="not(.//text())">
            <xsl:apply-templates
            select="/teiCorpus/TEI[@xml:id=$id]/teiHeader/fileDesc/titleStmt/title"/>aaa
            </xsl:if>-->
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      
      <xsl:when test="//div1[@type='introduction']/@xml:id=$id">
        <a href="{$id}.html">
          <!-- <xsl:if test="not(.//text())">
            <xsl:apply-templates
              select="/teiCorpus/TEI[@xml:id=$id]/teiHeader/fileDesc/titleStmt/title"/>aaa
          </xsl:if>-->
          <xsl:apply-templates/>
        </a>
      </xsl:when>

      <xsl:when test="/teiCorpus/TEI/@xml:id[starts-with(.,'rs.front')]=$id">
        <a href="{$id}.html">
          <!--<xsl:if test="not(.//text())">

            <xsl:apply-templates
              select="/teiCorpus/TEI[@xml:id=$id]/teiHeader/fileDesc/titleStmt/title"/>aaa
          </xsl:if>-->
          <xsl:apply-templates/>
        </a>
      </xsl:when>

      <!-- Link to a back section -->
      <xsl:when test="/teiCorpus/TEI[@xml:id='rs.back.001']/text/body/div1/@xml:id=$id">
        <xsl:variable name="this_type" select="/teiCorpus/TEI/text/body/div1[@xml:id=$id]/@type"/>
        <xsl:choose>
          <xsl:when test="starts-with($this_type, 'Index')">
            <a href="{$id}.html">
              <xsl:if test="not(.//text())">
                <xsl:apply-templates
                  select="/teiCorpus[@xml:id='rs.back.001']/teiHeader/fileDesc/titleStmt/title"/>
              </xsl:if>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$id}.html">
              <xsl:if test="not(.//text())">

                <xsl:apply-templates
                  select="/teiCorpus[@xml:id='rs.back.001']/teiHeader/fileDesc/titleStmt/title"/>
              </xsl:if>
              <xsl:apply-templates/>
            </a>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:when>

      <!-- Link to categorical listing -->
      <xsl:when test="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy/category/@xml:id=$id">
        <xsl:variable name="taxonomy"
          select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy[./category/@xml:id=$id]/@n"/>
        <a href="index/{encode-for-uri(lower-case($taxonomy))}/{encode-for-uri(lower-case($id))}"
          title="Category Index">
          <xsl:call-template name="uc_first">
            <xsl:with-param name="doNotLower">true</xsl:with-param>
            <xsl:with-param name="string"
              select="/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy/category[./@xml:id=$id]/catDesc/@n"
            />
          </xsl:call-template>
        </a>

      </xsl:when>

      <!-- Links to TEI documents -->
      <xsl:when test="$file = 'ind006'">
        <a href="mss/{$id}.facs.html?ref={ancestor::div1/@xml:id}" title="View Document">
          <xsl:value-of select="."/>
          <xsl:text>Facsimile</xsl:text>
        </a>
        <xsl:text> | </xsl:text>
        <a href="mss/{$id}.tran.html?ref={ancestor::div1/@xml:id}" title="View Document">
          <xsl:text>Diplomatic Transcription</xsl:text>
        </a>
        <xsl:text> | </xsl:text>
        <a href="mss/{$id}.sgml.html?ref={ancestor::div1/@xml:id}" title="View Document">
          <xsl:text>Encoding</xsl:text>
        </a>
      </xsl:when>

      <xsl:when test="$file = 'ind0010'">
        <ul class="documentRecords">
          <li>
            <div class="docRecord">
              <span class="preview">
                <a>
                  <xsl:attribute name="href">mss/<xsl:value-of select="@target"
                  />.facs.html?ref=<xsl:value-of select="ancestor::div1/@xml:id"/></xsl:attribute>
                  <img src="images/figures/95px/{@n}.jpg"/>
                </a>
              </span>
              <a>
                <xsl:attribute name="href">mss/<xsl:value-of select="@target"
                />.facs.html?ref=<xsl:value-of select="ancestor::div1/@xml:id"/></xsl:attribute>
                <xsl:value-of select="."/>
              </a>
            </div>
          </li>
        </ul>
      </xsl:when>

      <xsl:when test="/teiCorpus/TEI/@xml:id=$id">
        <a href="mss/{$id}.html?ref={ancestor::div1/@xml:id}" title="View Document">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>

      <xsl:when test="/teiCorpus/TEI//div2/@xml:id=$id">
        <xsl:variable name="this_doc_id" select="/teiCorpus/TEI[.//div2/@xml:id=$id]/@xml:id"/>
        <a href="mss/{$this_doc_id}.html?ref={ancestor::div1/@xml:id}" title="View Document">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>

      <xsl:when test="/teiCorpus/TEI//figure/@xml:id=$id">
        <xsl:variable name="this_doc_id" select="/teiCorpus/TEI[.//figure/@xml:id=$id]/@xml:id"/>
        <a href="mss/{$this_doc_id}.html?ref={ancestor::div2/@xml:id}" title="View Document">
          <xsl:value-of select="$this_doc_id"/>
        </a>
      </xsl:when>



      <!-- Link to the -->
      <xsl:otherwise>
        <a href="fakelink.com">Just for testing and finding bad links</a>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>

  <xsl:template name="getName">
    <xsl:param name="id"/>
    <xsl:value-of select="/teiCorpus/TEI[@xml:id=$id]/teiHeader/fileDesc/titleStmt/title"/>
  </xsl:template>
  
  <xsl:template match="anchor">
    <a>
      <xsl:attribute name="name"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:text> </xsl:text></a>
  </xsl:template>

</xsl:stylesheet>
