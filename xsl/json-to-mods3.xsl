<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:usfs="http://usfsreserach"
    exclude-result-prefixes="f fn math saxon xd xs xsi usfs">

    <xsl:output indent="yes" method="json" encoding="UTF-8" name="archive"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8" saxon:next-in-chain="fix_characters.xsl"/>

    <xsl:include href="commons/common.xsl"/>
    <xsl:include href="commons/functions.xsl"/>
    <xsl:include href="commons/params.xsl"/>

    <xsl:strip-space elements="*"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="/">
        <xsl:for-each select="data">
        <xsl:result-document method="json" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"
            href="file:///{($workingDir)}A-{replace($originalFilename,'(.*/)(.*)(\.json)', '$2')}_{position()}.json"
            format="archive">
            <data>
                <xsl:copy-of select="."/>
            </data>
        </xsl:result-document>
       <!-- <xsl:result-document method="xml" indent="yes" encoding="UTF-8"
            href="file:///{($workingDir)}N-{replace($originalFilename,'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml"
            format="original">-->
            <mods>
                <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation" select="normalize-space('http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd')"/>
                <xsl:attribute  name="version" select="3.7"/>
                    
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        <!--</xsl:result-document>-->
        </xsl:for-each>
    </xsl:template>


    <xd:doc>
        <xd:desc> template for the first tag </xd:desc>
    </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates
            select="./array[@key = 'pub_authors'] | ./array[@key = 'primary_station']"/>

        <!--default values-->
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>
    </xsl:template>


    <xd:doc>
        <xd:desc> template to output a string value </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <title>
            <titleInfo>
                <xsl:value-of select="."/>
            </titleInfo>
        </title>
    </xsl:template>

    <xd:doc scope="component" id="contrib">
        <xd:desc>If the contributor is a collaborator rather than an individual, format output
            accordingly. If processing the first author in the group, assign an attribute of
                <xd:b>usage</xd:b> with a value of "primary."</xd:desc>
    </xd:doc>
    <xsl:template match="map/array[@key = 'pub_authors'] | map/array[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/string[@key = 'primary_station']">
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="map/string[@key = 'primary_station']"/>
                    </namePart>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="name-info"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
        <xd:param name="acronym"/>
        <xd:param name="unitNum"/>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
        xmlns:usfs="http://usfsreseaerch">
        <xsl:param name="acronym" select="./string[@key = 'station_id']"/>
        <xsl:param name="unitNum" select="./string[@key = 'unit_id']"/>
        <xsl:for-each select="map[position()]">
            <name type="personal">
                <xsl:if
                    test="position() = 1 and count(map/preceding-sibling::string[@key = 'name']) = 0">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:if test="./string[@key = 'name']">
                        <namePart type="given">
                            <xsl:value-of
                                select="substring-after(normalize-space(./string[@key = 'name']), ', ')"
                            />
                        </namePart>
                        <namePart type="family">
                            <xsl:value-of
                                select="substring-before(normalize-space(./string[@key = 'name']), ', ')"
                            />
                        </namePart>
                        <displayName>
                            <xsl:value-of select="./string[@key = 'name']"/>
                        </displayName>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when
                            test="(./string[@key = 'station_id'] != '') and (./string[@key = 'unit_id'] != '')">
                            <affiliation>
                                <xsl:text>United States Department of Agriculture,</xsl:text>
                                <xsl:text>Forest Service,</xsl:text>
                                <xsl:value-of select="f:acronymToName($acronym)"/>
                                <xsl:text>,</xsl:text>
                                <xsl:value-of select="f:unitNumToName($unitNum)"/>
                                <xsl:text>,</xsl:text>
                                <xsl:value-of select="f:acronymToAddress($acronym)"/>
                            </affiliation>
                        </xsl:when>
                        <xsl:when
                            test="(./string[@key = 'station_id'] != '') and (./string[@key = 'unit_id'] = '')">
                            <affiliation>
                                <xsl:text>United States Department of Agriculture,</xsl:text>
                                <xsl:text>Forest Service,</xsl:text>
                                <xsl:value-of
                                    select="f:acronymToName(./string[@key = 'station_id'])"/>
                                <xsl:text>,</xsl:text>
                                <xsl:value-of
                                    select="f:acronymToAddress(./string[@key = 'station_id'])"/>
                            </affiliation>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if
                                test="(././string[@key = 'station_id'] = '') and (././string[@key = 'unit_id'] = '')"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                    <role>
                        <roleTerm type="text">author</roleTerm>
                    </role>
                </xsl:if>
            </name>
        </xsl:for-each>
    </xsl:template>

    <!-- Get author's ORCID -->


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'primary_station']">
        <name type="corporate">
            <namePart>United States</namePart>
            <namePart>Forest Service</namePart>
            <namePart>
                <xsl:value-of select="f:acronymToName(.)"/>
            </namePart>
        </name>
    </xsl:template>



</xsl:stylesheet>
