<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="saxon xhtml">

  <xsl:param name="ref"/>

  <xsl:output method="xhtml" encoding="utf-8" indent="no"/>

  <xsl:include href="rsc.globals.xsl"/>

  <xsl:param name="section"/>

  <xsl:template match="/">

    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>
          <xsl:choose>
            <xsl:when test=".//xhtml:head/xhtml:title/text()"> Radical Scatters | <xsl:value-of
                select=".//xhtml:head/xhtml:title/text()"/>
            </xsl:when>
            <xsl:otherwise> Radical Scatters </xsl:otherwise>
          </xsl:choose>

        </title>

        <base href="{$BASE_HREF}"/>


        <link rel="stylesheet" media="all" href="css/reset-min.css"/>
        <link rel="stylesheet" media="all" href="css/fonts-min.css"/>
        <link rel="stylesheet" media="all" href="css/rsc.main.css"/>
        <link rel="stylesheet" media="all" href="css/rsc.formatting.css"/>
        <!--<link rel="stylesheet" media="all" href="css/jquery.css"/>-->

        <script type="text/javascript" src="scripts/jquery.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript" src="scripts/custom.js"><xsl:text> </xsl:text></script>
        
      </head>

      <body>
        <div id="bodyContent2">
          <div id="bodyContent">
          <div id="header">
            <div class="extraMenu">
              <ul>
                <li>
                  <a href="acknowledgments.html">Acknowledgments</a>
                </li>
                <li>
                  <a href="abbreviations">Abbreviations</a>
                </li>
               <li>
                  <a href="bibliography.html">Bibliography</a>
                </li>
 
              </ul>
            </div>

            <h1>Radical Scatters</h1>

            <div class="mainMenu">
              <ul>
                <li>
                  <a href="index.html">Home</a>
                </li>
                <li>
                  <a href="introductions">Introductions</a>
                </li>
                <li>
                  <a href="indices">Archive Indices</a>
                </li>
                <li>
                  <a href="browse">Browse Documents</a>
                </li>
               <!-- <li>
                  <a href="search/main">Search</a>
                </li>-->
              </ul>
            </div>

            <div class="breadCrubs">
              <xsl:copy-of select="//xhtml:p[@class='breadCrumbs']"/>
            </div>

          </div>

          <div id="mainContent">

            <xsl:copy-of select=".//xhtml:body/*[not(@class='breadCrumbs')]"/>

            <div id="footer">

              <ul>
                <li>
                  <a href="contact.html">Contact</a>
                </li>


                <li>
                  <a href="about">About</a>
                </li>
              </ul>

              <p class="copyStmt"> &#169; The University of
                Nebraska&#8211;Lincoln, June 2007 - 2010<br/>  &#169; The University of
                Michigan, 1999 - May 2007</p>
              <br/>
              <br/>
              <br/>
              <br/>
              <br/>

            </div>
          </div>

        </div>
</div>
      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
