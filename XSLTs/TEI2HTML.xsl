<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei xhtml"
    version="2.0">
    
    <!-- This XSLT has been adapted from work done over time by members of the TEI-C council and community.
    Most recently it was developed specifically to transform the XML output from the Transkribus platform
    to TEI-All by members of the Leaf Editorial Academic Framework (LEAF) team for use with the LEAF-Writer text-encoding enfironment.
    The LEAF-Writer project is licensed under the GNU Affero General Public License v3.0 (https://choosealicense.com/licenses/agpl-3.0/)
    For more information about LEAF-Writer, the larger LEAF platform, go to: https://gitlab.com/calincs/cwrc/leaf-writer/leaf-writer-->
    
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
        method="xhtml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="return2">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

<!-- This creates the HTML doctype, removes the teiHeader, and applies a CSS stylesheet 
        (adjust relative path to your directory structure and stylesheet name 
    Note that most style properties are managed in the CSS -->
    <xsl:template match="tei:TEI">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <xsl:comment>This document is generated from a TEI Master--do not edit!</xsl:comment>
                <title><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
                <link rel="stylesheet" type="text/css" href="https://github.com/LEAF-VRE/code_snippets/blob/main/CSS/web_style.css"/>
                <style type="text/css">
                    @import url("https://github.com/LEAF-VRE/code_snippets/blob/main/CSS/web_style.css");
                </style>
            </head>
            <body>                               
                <xsl:apply-templates select="tei:text/tei:front"/>
                <xsl:apply-templates select="tei:text/tei:body"/>
                <xsl:apply-templates select="tei:text/tei:back"/>
            </body>
        </html>
    </xsl:template>

<!-- == BASIC TEXT STRUCTURE == -->
<!-- A head element is treated as an H1 element in HTML -->    
    <xsl:template match="tei:head">
        <h1 xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
<!-- div or p elements are treated as div or p elements in HTML -->
    <xsl:template match="tei:div | tei:p">
        <p xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
 
<!-- lb elements are treated as br elements in HTML -->     
    <xsl:template match="tei:lb">
        <br xmlns="http://www.w3.org/1999/xhtml"/>
    </xsl:template>

<!-- lg (line group) elements are treated as p elements in HTML  -->
    <xsl:template match="tei:lg">
        <p xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
<!-- l (line) elements are treated as br elements in HTML-->
    <xsl:template match="tei:l">
        <br xmlns="http://www.w3.org/1999/xhtml"/>
        <xsl:apply-templates/>
    </xsl:template>
    
<!-- quote elements are treated as blockquote elements in HTML -->
    <xsl:template match="tei:quote">
        <blockquote xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>

<!-- pb elements are displayed with 'Page' and value of @n -->
<xsl:template match="tei:pb">
    <xsl:text>
        Page: 
    </xsl:text>
    <xsl:value-of select="@n"/>
    <xsl:apply-templates/>
</xsl:template>

<!-- == LISTS AND ITEMS == -->   
<!-- List elements are treated as ul(unordered list) elements in HTML / can be changed to ol (ordered list) here  -->
    <xsl:template match="tei:list">
     <ul xmlns="http://www.w3.org/1999/xhtml">
         <xsl:apply-templates/>
     </ul>
 </xsl:template>

<!-- Item elements are treated as li (list item) elements in HTML -->
    <xsl:template match="tei:div/tei:list/tei:item">
        <li xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </li>        
    </xsl:template> 

<!-- == TRANSCRIPTION MARKS == -->
    <!-- del elements are treated as s elements in HTML -->
    <xsl:template match="tei:del">
        <s xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </s>
    </xsl:template>
    
    <!-- text that is rendered as superscript is treated as sup element in HTML -->
    <xsl:template match="tei:hi[@rend='superscript']"> 
        <sup xmlns="http://www.w3.org/1999.xhtml">
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <!-- text that is rendered as underlined is treated as u element in HTML -->
    <xsl:template match="tei:hi[@rend='underline']">
        <u xmlns="http://www.w3.org/1999.xhtml">
            <xsl:apply-templates/>
        </u>
    </xsl:template>

<!-- text that is rendered as italicized in encoded source is treated as emph element in HTML -->
    <xsl:template match="tei:emph">
        <em xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </em>
    </xsl:template>

<!-- text in a MS that is added above the line is treated as sup element in HTML -->
    <xsl:template match="tei:add['@above']">
        <sup xmlns="http://www.w3.org/1999.xhtml">
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    
    <!-- text in a MS that is added below the line is treated as sub element in HTML -->
    <xsl:template match="tei:add['@below']">
        <sub xmlns="http://www.w3.org/1999.xhtml">
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    

<!-- == NOTES AND GLOSSES == -->
    <!-- notes (regardless of type) are treated as span elements in HTML. Different types of notes can be styled differently in CSS -->
    <xsl:template match="tei:note">
        <span xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </span>        
    </xsl:template>
    
    
<!-- == PEOPLE, PLACES, THINGS == -->
<!-- persName, orgName, placeName are treated as linked text, with external authority URI   -->
    <xsl:template match="tei:persName['@ref'] | tei:orgName['@ref'] | tei:placeName['@ref'] | tei:title['@ref']">
        <a xmlns="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="href">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

        
    <!-- persName without any link -->
    <xsl:template match="tei:persName">
        <font color="blue">
            <xsl:apply-templates/>
        </font>
    </xsl:template>
    
</xsl:stylesheet>

