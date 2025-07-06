<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">
    
    <!-- This XSLT has been developed to transform Markdown file format
    to TEI-All by members of the Leaf Editorial Academic Framework (LEAF) team for use with the LEAF-Writer text-encoding enfironment.
    AI was used to test the XSLT (Claude.ai) in July 2025.
    The LEAF-Writer project is licensed under the GNU Affero General Public License v3.0 (https://choosealicense.com/licenses/agpl-3.0/)
    For more information about LEAF-Writer, the larger LEAF platform, go to: https://gitlab.com/calincs/cwrc/leaf-writer/leaf-writer-->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- Root template -->
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="https://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">href="https://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="https://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-stylesheet">type="text/css" href="https://raw.githubusercontent.com/LEAF-VRE/code_snippets/refs/heads/main/CSS/leaf.css"</xsl:processing-instruction>
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Converted from Markdown</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Converted using XSLT transformation</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>This XSLT will support transformation from a Markdown file to a TEI file with TEI-All schema and correct CSS stylesheet for LEAF-Writer </p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:call-template name="process-markdown">
                        <xsl:with-param name="text" select="//markdown"/>
                    </xsl:call-template>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <!-- Main markdown processing template -->
    <xsl:template name="process-markdown">
        <xsl:param name="text"/>
        
        <!-- Split by actual line breaks and filter empty lines -->
        <xsl:variable name="lines" select="tokenize($text, '\r?\n')[normalize-space(.) != '']"/>
        
        <!-- Process lines starting from position 1 -->
        <xsl:call-template name="process-lines">
            <xsl:with-param name="lines" select="$lines"/>
            <xsl:with-param name="pos" select="1"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Process lines sequentially -->
    <xsl:template name="process-lines">
        <xsl:param name="lines"/>
        <xsl:param name="pos"/>
        
        <xsl:if test="$pos &lt;= count($lines)">
            <xsl:variable name="line" select="normalize-space($lines[$pos])"/>
            
            <xsl:choose>
                <!-- Level 1 header -->
                <xsl:when test="starts-with($line, '# ') and not(starts-with($line, '## '))">
                    <!-- Find next level 1 header or end -->
                    <xsl:variable name="next-h1">
                        <xsl:call-template name="find-next-header">
                            <xsl:with-param name="lines" select="$lines"/>
                            <xsl:with-param name="start" select="$pos + 1"/>
                            <xsl:with-param name="pattern" select="'# '"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <div>
                        <head>
                            <xsl:call-template name="process-inline">
                                <xsl:with-param name="text" select="substring($line, 3)"/>
                            </xsl:call-template>
                        </head>
                        
                        <!-- Process content until next h1 -->
                        <xsl:if test="$pos + 1 &lt; number($next-h1)">
                            <xsl:call-template name="process-content-range">
                                <xsl:with-param name="lines" select="$lines"/>
                                <xsl:with-param name="start" select="$pos + 1"/>
                                <xsl:with-param name="end" select="number($next-h1) - 1"/>
                            </xsl:call-template>
                        </xsl:if>
                    </div>
                    
                    <!-- Continue from next h1 -->
                    <xsl:call-template name="process-lines">
                        <xsl:with-param name="lines" select="$lines"/>
                        <xsl:with-param name="pos" select="number($next-h1)"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- Other content (shouldn't happen at top level, but handle gracefully) -->
                <xsl:otherwise>
                    <xsl:call-template name="process-single-line">
                        <xsl:with-param name="line" select="$line"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="process-lines">
                        <xsl:with-param name="lines" select="$lines"/>
                        <xsl:with-param name="pos" select="$pos + 1"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Process content within a range (for content under headers) -->
    <xsl:template name="process-content-range">
        <xsl:param name="lines"/>
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        
        <xsl:call-template name="process-content-lines">
            <xsl:with-param name="lines" select="$lines"/>
            <xsl:with-param name="pos" select="$start"/>
            <xsl:with-param name="end" select="$end"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Process content lines, handling headers at any level -->
    <xsl:template name="process-content-lines">
        <xsl:param name="lines"/>
        <xsl:param name="pos"/>
        <xsl:param name="end"/>
        
        <xsl:if test="$pos &lt;= $end">
            <xsl:variable name="line" select="normalize-space($lines[$pos])"/>
            
            <xsl:choose>
                <!-- Level 2 header -->
                <xsl:when test="starts-with($line, '## ') and not(starts-with($line, '### '))">
                    <!-- Find next level 2+ header or end -->
                    <xsl:variable name="next-h2">
                        <xsl:call-template name="find-next-header-in-range">
                            <xsl:with-param name="lines" select="$lines"/>
                            <xsl:with-param name="start" select="$pos + 1"/>
                            <xsl:with-param name="end" select="$end"/>
                            <xsl:with-param name="pattern" select="'## '"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <div>
                        <head>
                            <xsl:call-template name="process-inline">
                                <xsl:with-param name="text" select="substring($line, 4)"/>
                            </xsl:call-template>
                        </head>
                        
                        <!-- Process content under this h2 -->
                        <xsl:if test="$pos + 1 &lt; number($next-h2)">
                            <xsl:call-template name="process-content-lines">
                                <xsl:with-param name="lines" select="$lines"/>
                                <xsl:with-param name="pos" select="$pos + 1"/>
                                <xsl:with-param name="end" select="min((number($next-h2) - 1, $end))"/>
                            </xsl:call-template>
                        </xsl:if>
                    </div>
                    
                    <!-- Continue from next h2 -->
                    <xsl:call-template name="process-content-lines">
                        <xsl:with-param name="lines" select="$lines"/>
                        <xsl:with-param name="pos" select="number($next-h2)"/>
                        <xsl:with-param name="end" select="$end"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- Level 3 header -->
                <xsl:when test="starts-with($line, '### ') and not(starts-with($line, '#### '))">
                    <!-- Find next level 3+ header or end -->
                    <xsl:variable name="next-h3">
                        <xsl:call-template name="find-next-header-in-range">
                            <xsl:with-param name="lines" select="$lines"/>
                            <xsl:with-param name="start" select="$pos + 1"/>
                            <xsl:with-param name="end" select="$end"/>
                            <xsl:with-param name="pattern" select="'### '"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <div>
                        <head>
                            <xsl:call-template name="process-inline">
                                <xsl:with-param name="text" select="substring($line, 5)"/>
                            </xsl:call-template>
                        </head>
                        
                        <!-- Process content under this h3 -->
                        <xsl:if test="$pos + 1 &lt; number($next-h3)">
                            <xsl:call-template name="process-content-lines">
                                <xsl:with-param name="lines" select="$lines"/>
                                <xsl:with-param name="pos" select="$pos + 1"/>
                                <xsl:with-param name="end" select="min((number($next-h3) - 1, $end))"/>
                            </xsl:call-template>
                        </xsl:if>
                    </div>
                    
                    <!-- Continue from next h3 -->
                    <xsl:call-template name="process-content-lines">
                        <xsl:with-param name="lines" select="$lines"/>
                        <xsl:with-param name="pos" select="number($next-h3)"/>
                        <xsl:with-param name="end" select="$end"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- Level 4+ headers - simple divs -->
                <xsl:when test="starts-with($line, '#### ')">
                    <div>
                        <head>
                            <xsl:call-template name="process-inline">
                                <xsl:with-param name="text" select="substring-after($line, '#### ')"/>
                            </xsl:call-template>
                        </head>
                    </div>
                    
                    <xsl:call-template name="process-content-lines">
                        <xsl:with-param name="lines" select="$lines"/>
                        <xsl:with-param name="pos" select="$pos + 1"/>
                        <xsl:with-param name="end" select="$end"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- Regular content -->
                <xsl:otherwise>
                    <xsl:call-template name="process-single-line">
                        <xsl:with-param name="line" select="$line"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="process-content-lines">
                        <xsl:with-param name="lines" select="$lines"/>
                        <xsl:with-param name="pos" select="$pos + 1"/>
                        <xsl:with-param name="end" select="$end"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Process a single line -->
    <xsl:template name="process-single-line">
        <xsl:param name="line"/>
        
        <xsl:choose>
            <xsl:when test="starts-with($line, '- ')">
                <list type="unordered">
                    <item>
                        <xsl:call-template name="process-inline">
                            <xsl:with-param name="text" select="substring($line, 3)"/>
                        </xsl:call-template>
                    </item>
                </list>
            </xsl:when>
            <xsl:when test="matches($line, '^\d+\. ')">
                <list type="ordered">
                    <item>
                        <xsl:call-template name="process-inline">
                            <xsl:with-param name="text" select="replace($line, '^\d+\. ', '')"/>
                        </xsl:call-template>
                    </item>
                </list>
            </xsl:when>
            <xsl:when test="starts-with($line, '&gt; ')">
                <quote>
                    <xsl:call-template name="process-inline">
                        <xsl:with-param name="text" select="substring($line, 3)"/>
                    </xsl:call-template>
                </quote>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:call-template name="process-inline">
                        <xsl:with-param name="text" select="$line"/>
                    </xsl:call-template>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Find next header -->
    <xsl:template name="find-next-header">
        <xsl:param name="lines"/>
        <xsl:param name="start"/>
        <xsl:param name="pattern"/>
        
        <xsl:choose>
            <xsl:when test="$start > count($lines)">
                <xsl:value-of select="count($lines) + 1"/>
            </xsl:when>
            <xsl:when test="starts-with(normalize-space($lines[$start]), $pattern) and not(starts-with(normalize-space($lines[$start]), concat($pattern, '#')))">
                <xsl:value-of select="$start"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="find-next-header">
                    <xsl:with-param name="lines" select="$lines"/>
                    <xsl:with-param name="start" select="$start + 1"/>
                    <xsl:with-param name="pattern" select="$pattern"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Find next header within a range -->
    <xsl:template name="find-next-header-in-range">
        <xsl:param name="lines"/>
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:param name="pattern"/>
        
        <xsl:choose>
            <xsl:when test="$start > $end">
                <xsl:value-of select="$end + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="current-line" select="normalize-space($lines[$start])"/>
                <xsl:choose>
                    <!-- Check for exact pattern match (like "## " but not "### ") -->
                    <xsl:when test="starts-with($current-line, $pattern) and not(starts-with($current-line, concat($pattern, '#')))">
                        <xsl:value-of select="$start"/>
                    </xsl:when>
                    <!-- Also stop at higher level headers (fewer #s) -->
                    <xsl:when test="$pattern = '## ' and starts-with($current-line, '# ') and not(starts-with($current-line, '## '))">
                        <xsl:value-of select="$start"/>
                    </xsl:when>
                    <xsl:when test="$pattern = '### ' and (
                        (starts-with($current-line, '# ') and not(starts-with($current-line, '## '))) or
                        (starts-with($current-line, '## ') and not(starts-with($current-line, '### ')))
                    )">
                        <xsl:value-of select="$start"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="find-next-header-in-range">
                            <xsl:with-param name="lines" select="$lines"/>
                            <xsl:with-param name="start" select="$start + 1"/>
                            <xsl:with-param name="end" select="$end"/>
                            <xsl:with-param name="pattern" select="$pattern"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Process inline formatting -->
    <xsl:template name="process-inline">
        <xsl:param name="text"/>
        <xsl:call-template name="process-links">
            <xsl:with-param name="text" select="$text"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Process links -->
    <xsl:template name="process-links">
        <xsl:param name="text"/>
        
        <xsl:choose>
            <!-- Handle [text](url) links -->
            <xsl:when test="contains($text, '[') and contains($text, '](') and contains(substring-after($text, ']('), ')')">
                <xsl:variable name="before-link" select="substring-before($text, '[')"/>
                <xsl:variable name="after-bracket" select="substring-after($text, '[')"/>
                
                <xsl:choose>
                    <xsl:when test="contains($after-bracket, '](')">
                        <xsl:variable name="link-text" select="substring-before($after-bracket, '](')"/>
                        <xsl:variable name="after-paren" select="substring-after($after-bracket, '](')"/>
                        
                        <xsl:choose>
                            <xsl:when test="contains($after-paren, ')')">
                                <xsl:variable name="link-url" select="substring-before($after-paren, ')')"/>
                                <xsl:variable name="after-link" select="substring-after($after-paren, ')')"/>
                                
                                <xsl:call-template name="process-bold-and-italic">
                                    <xsl:with-param name="text" select="$before-link"/>
                                </xsl:call-template>
                                
                                <ref target="{$link-url}">
                                    <xsl:call-template name="process-bold-and-italic">
                                        <xsl:with-param name="text" select="$link-text"/>
                                    </xsl:call-template>
                                </ref>
                                
                                <xsl:call-template name="process-links">
                                    <xsl:with-param name="text" select="$after-link"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="process-bold-and-italic">
                                    <xsl:with-param name="text" select="$text"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="process-bold-and-italic">
                            <xsl:with-param name="text" select="$text"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="process-bold-and-italic">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Process bold and italic formatting -->
    <xsl:template name="process-bold-and-italic">
        <xsl:param name="text"/>
        
        <xsl:choose>
            <!-- Handle **bold** -->
            <xsl:when test="contains($text, '**')">
                <xsl:variable name="before" select="substring-before($text, '**')"/>
                <xsl:variable name="after" select="substring-after($text, '**')"/>
                
                <xsl:choose>
                    <xsl:when test="contains($after, '**')">
                        <xsl:variable name="bold-content" select="substring-before($after, '**')"/>
                        <xsl:variable name="remaining" select="substring-after($after, '**')"/>
                        
                        <xsl:call-template name="process-italic">
                            <xsl:with-param name="text" select="$before"/>
                        </xsl:call-template>
                        <hi rend="bold">
                            <xsl:call-template name="process-italic">
                                <xsl:with-param name="text" select="$bold-content"/>
                            </xsl:call-template>
                        </hi>
                        <xsl:call-template name="process-bold-and-italic">
                            <xsl:with-param name="text" select="$remaining"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="process-italic">
                            <xsl:with-param name="text" select="$text"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="process-italic">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Process italic formatting -->
    <xsl:template name="process-italic">
        <xsl:param name="text"/>
        
        <xsl:choose>
            <!-- Handle *italic* (but not **bold**) -->
            <xsl:when test="contains($text, '*') and not(contains($text, '**'))">
                <xsl:variable name="before" select="substring-before($text, '*')"/>
                <xsl:variable name="after" select="substring-after($text, '*')"/>
                
                <xsl:choose>
                    <xsl:when test="contains($after, '*') and not(contains(substring-before($after, '*'), '*'))">
                        <xsl:variable name="italic-content" select="substring-before($after, '*')"/>
                        <xsl:variable name="remaining" select="substring-after($after, '*')"/>
                        
                        <xsl:value-of select="$before"/>
                        <hi rend="italic">
                            <xsl:value-of select="$italic-content"/>
                        </hi>
                        <xsl:call-template name="process-italic">
                            <xsl:with-param name="text" select="$remaining"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$text"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>