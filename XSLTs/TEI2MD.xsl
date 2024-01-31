<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei md"
    version="1.0">
    
    <!-- This XSLT has been adapted from work done over time by members of the TEI-C council and community.
    Most recently it was developed specifically to transform the XML output from the Transkribus platform
    to TEI-All by members of the Leaf Editorial Academic Framework (LEAF) team for use with the LEAF-Writer text-encoding enfironment.
    The LEAF-Writer project is licensed under the GNU Affero General Public License v3.0 (https://choosealicense.com/licenses/agpl-3.0/)
    For more information about LEAF-Writer, the larger LEAF platform, go to: https://gitlab.com/calincs/cwrc/leaf-writer/leaf-writer-->
    
    <xsl:output 
        indent="no" 
        method="text"/>
    
    <xsl:template match="tei:teiHeader"/>
    
    <xsl:strip-space elements="*"/>
    
<!--    <xsl:template match="text()">
        <xsl:value-of select="translate(., ' ', '')"/>
    </xsl:template>-->

    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
 
 <!-- == NAMED TEMPLATES == -->
    <xsl:template name="return2">
        <xsl:text>&#13;</xsl:text>
    </xsl:template>
        
    <xsl:template name="return">
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <!-- == BASIC TEXT STRUCTURE ==    -->
    
    <!-- head element is rendered with a # for Heading 1 -->
    <xsl:template match="tei:head">
    <xsl:text>&#35; </xsl:text>
    <xsl:apply-templates/>
        <xsl:call-template name="return2"/>
    </xsl:template>
    
    <!-- p and lg elements have a double-space at their end. -->
    <xsl:template match="tei:div | tei:p">
        <xsl:call-template name="return2"/>
        <xsl:apply-templates/>
        <xsl:call-template name="return2"/> 
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:call-template name="return2"/>
        <xsl:call-template name="return2"/>
        <xsl:apply-templates/>
    </xsl:template>

    
    <!-- lb elements are treated as br elements in HTML -->     
    <xsl:template match="tei:lb">
        <xsl:call-template name="return"/>
        <xsl:apply-templates/> 
        <xsl:call-template name="return"/>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <xsl:call-template name="return"/>
        <xsl:apply-templates/> 
        <xsl:text>  </xsl:text>
    </xsl:template>
    
    <!-- hide page breaks -->
    <xsl:template match="tei:pb"/>
    
<xsl:template match="tei:byline">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>*</xsl:text>
    <xsl:call-template name="return2"/>
</xsl:template>

    <!-- == LISTS AND ITEMS == -->   
    <!-- List elements are treated as ul(unordered list) elements in HTML / can be changed to ol (ordered list) here  -->
    <xsl:template match="tei:list">
        <xsl:apply-templates select="tei:item"/>
    </xsl:template>
    
    <!-- Item elements are treated as li (list item) elements in HTML -->
    <xsl:template match="tei:div/tei:list/tei:item">
        - <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- text that is rendered as underlined is rendered as underlined -->
    <xsl:template match="tei:hi[@rend='underline']">
        <xsl:text>_</xsl:text><xsl:apply-templates/><xsl:text>_</xsl:text>
    </xsl:template>
    
    <!-- text that is rendered as italicized in encoded source is rendered in italics -->
    <xsl:template match="tei:emph">
        <xsl:text>*</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>*</xsl:text>
    </xsl:template>
        
    
    <!-- notes (regardless of type) have 'Note:' placed in front of them and are rendered in italics to distinguish them from surrounding text -->
    <xsl:template match="tei:note">
        <xsl:text> *Note: </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>* </xsl:text>
    </xsl:template>
        
    <!-- == PEOPLE, PLACES, THINGS == -->

   <!-- Trying to figure out how to create weblink in Markdown using the TEI structure --> 
   <xsl:template match="tei:persName['@ref'] | tei:placeName['@ref'] | tei:orgName['@ref'] | tei:title['@ref']">

        <xsl:choose>
            <xsl:when test="@ref">
                <xsl:text>[</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>]</xsl:text>
                <xsl:text>(</xsl:text>
                <xsl:apply-templates select="@ref"/>
                <xsl:text>) </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>



<!-- What does this do?
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template> -->
    
    <!--    <!-\- lg (line group) elements are treated as p elements in HTML  -\->
    <xsl:template match="tei:lg">
        <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-\- l (line) elements are treated as br elements in HTML-\->
    <xsl:template match="tei:l">
        <xsl:value-of select="normalize-space()"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>-->
    
    
</xsl:stylesheet>
