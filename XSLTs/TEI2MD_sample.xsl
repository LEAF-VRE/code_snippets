<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <!-- This XSLT has been adapted from work done over time by members of the TEI-C council and community.
    Most recently it was developed specifically to transform the XML output from the Transkribus platform
    to TEI-All by members of the Leaf Editorial Academic Framework (LEAF) team for use with the LEAF-Writer text-encoding enfironment.
    The LEAF-Writer project is licensed under the GNU Affero General Public License v3.0 (https://choosealicense.com/licenses/agpl-3.0/)
    For more information about LEAF-Writer, the larger LEAF platform, go to: https://gitlab.com/calincs/cwrc/leaf-writer/leaf-writer-->
    
    <xsl:output method="text"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="return2">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- == BASIC TEXT STRUCTURE == -->   
    <xsl:template match="tei:head">
        # <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- div or p elements are treated as div or p elements in HTML -->
    <xsl:template match="tei:div | tei:p">
        <!-- Assuming we want to treat div elements as plain paragraphs -->
        <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- lb elements are treated as br elements in HTML -->     
    <xsl:template match="tei:lb">
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- lg (line group) elements are treated as p elements in HTML  -->
    <xsl:template match="tei:lg">
        <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- l (line) elements are treated as br elements in HTML-->
    <xsl:template match="tei:l">
        <xsl:value-of select="normalize-space()"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- quote elements are treated as blockquote elements in HTML -->
    <xsl:template match="tei:quote">
        &gt; <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <!-- pb elements are displayed with 'Page' and value of @n -->
    <xsl:template match="tei:pb">
        Page: <xsl:value-of select="@n"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates/>
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
    
    <!-- == TRANSCRIPTION MARKS == -->
    <!-- del elements are treated as s elements in HTML -->
    <xsl:template match="tei:del">
        <xsl:text>~~</xsl:text><xsl:apply-templates/><xsl:text>~~</xsl:text>
    </xsl:template>
    
    <!-- text that is rendered as superscript is treated as sup element in HTML -->
    <xsl:template match="tei:hi[@rend='superscript']">
        <xsl:text>^</xsl:text><xsl:apply-templates/><xsl:text>^</xsl:text>
    </xsl:template>
    
    <!-- text that is rendered as underlined is treated as u element in HTML -->
    <xsl:template match="tei:hi[@rend='underline']">
        <xsl:text>_</xsl:text><xsl:apply-templates/><xsl:text>_</xsl:text>
    </xsl:template>
    
    <!-- text that is rendered as italicized in encoded source is treated as emph element in HTML -->
    <xsl:template match="tei:emph">
        <xsl:text>*</xsl:text><xsl:apply-templates/><xsl:text>*</xsl:text>
    </xsl:template>
    
    <!-- text in a MS that is added above the line is treated as sup element in HTML -->
    <xsl:template match="tei:add[@place='above']">
        <xsl:text>^</xsl:text><xsl:apply-templates/><xsl:text>^</xsl:text>
    </xsl:template>
    
    <!-- text in a MS that is added below the line is treated as sub element in HTML -->
    <xsl:template match="tei:add[@place='below']">
        <xsl:text>~</xsl:text><xsl:apply-templates/><xsl:text>~</xsl:text>
    </xsl:template>
    
    
    <!-- == NOTES AND GLOSSES == -->
    <!-- notes (regardless of type) are treated as span elements in HTML. Different types of notes can be styled differently in CSS -->
    <xsl:template match="tei:note">
        <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
        
    <!-- == PEOPLE, PLACES, THINGS == -->
    <!-- persName, orgName, placeName are treated as linked text, with external authority URI   -->
    <xsl:template match="tei:persName | tei:orgName | tei:placeName | tei:title">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
