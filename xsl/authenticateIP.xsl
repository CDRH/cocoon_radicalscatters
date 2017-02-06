<?xml version="1.0"?>


<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <!-- Get the name from the request paramter -->
  <xsl:param name="requestIp"/>
  <xsl:param name="uname"/>
  <xsl:param name="upsswd"/>

  <xsl:variable name="requestIpTokenized" select="tokenize($requestIp, '\.')"/>

  <xsl:template match="authentication">
    <authentication xmlns="">

      <xsl:variable name="ids">
        <xsl:apply-templates select="//users"/>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$ids//ID">
          <xsl:copy-of select="($ids//ID)[1]"/>
        </xsl:when>
        <xsl:when test="//user[@name=$uname and @password=$upsswd]">
          <ID>
            <xsl:value-of select="$requestIp"/>
            <xsl:value-of select="$uname"/>
            <xsl:value-of select="generate-id()"/>
          </ID>
        </xsl:when>
      </xsl:choose>


    </authentication>

  </xsl:template>


  <xsl:template match="users">
    <xsl:apply-templates select=".//user"/>
  </xsl:template>


  <xsl:template match="user">
    <xsl:for-each select="./ip">


      <xsl:variable name="matchem">
        <xsl:call-template name="compareIPs">
          <xsl:with-param name="patternIP">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$matchem = '1111'">
        <ID>
          <xsl:value-of select="replace($requestIp, '\.', '')"/>
          <xsl:value-of select="generate-id()"/>
        </ID>
      </xsl:if>

    </xsl:for-each>

  </xsl:template>

  <xsl:template name="compareIPs">
    <xsl:param name="patternIP"/>


      <xsl:for-each select="tokenize($patternIP, '\.')">

      <xsl:variable name="position" select="position()"/>
      <xsl:variable name="matchAgainst" select="$requestIpTokenized[$position]"/>

      <xsl:choose>
        <xsl:when test="matches(.,'[0-9]+\-[0-9]+')">
          <xsl:if
            test="(number($matchAgainst) ge number(substring-before(.,'-'))) and (number($matchAgainst) le number(substring-after(.,'-')))"
            >1</xsl:if>
        </xsl:when>
        <xsl:when test="matches(.,'^[0-9]+$')">
          <xsl:if test=".=$matchAgainst">1</xsl:if>
        </xsl:when>
        <xsl:when test="matches(.,'^\*$')">1</xsl:when>
        <xsl:otherwise/>
      </xsl:choose>

    </xsl:for-each>
      
  </xsl:template>


</xsl:stylesheet>
