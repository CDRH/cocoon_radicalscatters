<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="hi">
		<xsl:choose>
			<xsl:when test="./@rend='small caps'">
				<span class="smallcaps">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="./@rend='underlined'">
				<em class="underline">
					<xsl:apply-templates/>
				</em>
			</xsl:when>
			<xsl:when test="./@rend='italics'">
				<em class="italic">
					<xsl:apply-templates/>
				</em>
			</xsl:when>
			<!-- askbrian what underlined2x means -->
			<xsl:when test="./@rend='underlined 2x'">
				<em class="doubleUnderline">
					<xsl:apply-templates/>
				</em>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="lb">
		<br/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="title">
		<em class="title">
			<xsl:choose>
				<xsl:when test="descendant::ptr">
					<xsl:variable name="link">
						<!-- Call template in rsc.linking.xsl -->
						<xsl:call-template name="findLink">
							<xsl:with-param name="id" select=".//ptr[1]/@target"/>
						</xsl:call-template>
					</xsl:variable>
					<a href="{$link/a/@href}">
						<xsl:apply-templates select="./text() | ./*[not(name()='ptr')]"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</em>
	</xsl:template>

	<xsl:template match="note[@type='footnote']">
		
			<a>
				<xsl:attribute name="href">
					<xsl:text>javascript:void(0)</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="class">footnote</xsl:attribute>
				&#10013;</a><xsl:text> </xsl:text>
		
		<span>
			<xsl:attribute name="class">note-nojavascript</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="head">
		<xsl:choose>
			<xsl:when test="parent::div1">
				<h1>
					<xsl:apply-templates/>
				</h1>
			</xsl:when>
			<xsl:when test="parent::div2">
				<h2>
					<xsl:apply-templates/>
				</h2>
			</xsl:when>
			<xsl:when test="parent::div3">
				<h3>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="parent::div4">
				<h4>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="parent::list">
				<h3 class="listHead">
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:otherwise>
				<em class="undefined">
					<xsl:apply-templates/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="list">
		<xsl:if test="child::head">
			<xsl:apply-templates select="child::head"/>
		</xsl:if>
		<ul>
			<xsl:if test="descendant::label">
				<xsl:attribute name="class">definitionList</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="./item | ./label"/>
		</ul>
	</xsl:template>

	<xsl:template match="item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="item/label">
		<strong class="label">
			<xsl:apply-templates/>
		</strong>
	</xsl:template>


	<xsl:template match="epigraph">
		<blockquote class="epigraph">
			<xsl:choose>
				<xsl:when test="descendant::p">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<xsl:apply-templates/>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</blockquote>
	</xsl:template>

	<xsl:template match="q[@type='block']">
		<blockquote>
			<xsl:choose>
				<xsl:when test="descendant::p">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<xsl:apply-templates/>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</blockquote>
	</xsl:template>

	<xsl:template match="figure">
		<div class="imageBox">
			<img src="images/figures/500px/{./graphic/@url}"/>
			<p class="caption">
				<xsl:apply-templates select="./figDesc"/>
			</p>
		</div>
	</xsl:template>

	<!-- ADDITIONS, DELETIONS, AND EDITORIAL REMARKS -->

	<xsl:template match="del">
		<span class="stiked">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!-- Finish for different rends -->
	<xsl:template match="add">
		<span class="addition">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="pb[@rend]">
		<br/>
		<span class="editorial">&lt;<xsl:value-of select="./@rend"/>&gt;</span>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>



	<xsl:template match="ed[@type]">
		<br/>
		<span class="editorial">&lt;<xsl:value-of select="./@type"/>&gt;</span>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="delspan"> [<xsl:apply-templates/>] </xsl:template>

	<xsl:template match="gap[@reason]">
		<br/>
		<span class="editorial">&lt;<xsl:value-of select="./@reason"/>&gt;</span>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="unclear"> ~<xsl:apply-templates/>~ </xsl:template>

	<xsl:template match="abbr">
		<abbr title="{./@expan}">
			<xsl:apply-templates/>
		</abbr>
	</xsl:template>



	<xsl:template match="milestone[@unit='stars']">
		<div class="stars">*******</div>
	</xsl:template>

</xsl:stylesheet>
