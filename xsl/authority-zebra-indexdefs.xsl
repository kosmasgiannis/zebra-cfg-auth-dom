<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:z="http://indexdata.com/zebra-2.0" xmlns:kohaidx="http://www.koha.org/schemas/index-defs" version="1.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:template match="text()"/>
  <xsl:template match="text()" mode="index_subfields"/>
  <xsl:template match="text()" mode="index_heading"/>
  <xsl:template match="/">
    <xsl:if test="marc:collection">
      <collection>
        <xsl:apply-templates select="marc:collection/marc:record"/>
      </collection>
    </xsl:if>
    <xsl:if test="marc:record">
      <xsl:apply-templates select="marc:record"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="marc:record">
    <xsl:variable name="controlField001" select="normalize-space(marc:controlfield[@tag='001'])"/>
    <z:record type="update">
      <xsl:attribute name="z:id">
        <xsl:value-of select="$controlField001"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:apply-templates mode="index_subfields"/>
      <xsl:apply-templates mode="index_heading"/>
    </z:record>
  </xsl:template>
  <xsl:template match="marc:leader">
    <z:index name="Record-status:w">
      <xsl:value-of select="substring(., 6, 1)"/>
    </z:index>
    <z:index name="Encoding-level:w">
      <xsl:value-of select="substring(., 18, 1)"/>
    </z:index>
  </xsl:template>
  <xsl:template match="marc:controlfield[@tag='001']">
    <z:index name="Local-Number:w">
      <xsl:value-of select="."/>
    </z:index>
  </xsl:template>
  <xsl:template match="marc:controlfield[@tag='008']">
    <z:index name="Kind-of-record:w">
      <xsl:value-of select="substring(., 10, 1)"/>
    </z:index>
    <z:index name="Descriptive-cataloging-rules:w">
      <xsl:value-of select="substring(., 11, 1)"/>
    </z:index>
    <z:index name="Heading-use-main-or-added-entry:w">
      <xsl:value-of select="substring(., 15, 1)"/>
    </z:index>
    <z:index name="Heading-use-subject-added-entry:w">
      <xsl:value-of select="substring(., 16, 1)"/>
    </z:index>
    <z:index name="Heading-use-series-added-entry:w">
      <xsl:value-of select="substring(., 17, 1)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='100']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('abcdefghjklmnopqrstvxyz', @code)">
        <z:index name="Personal-name-subfields:w Personal-name-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='110']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('abcdefghklmnoprstvxyz', @code)">
        <z:index name="Corporate-name-subfields:w Corporate-name-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='111']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('acdefghjklnpqstvxyz', @code)">
        <z:index name="Meeting-name-subfields:w Meeting-name-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='130']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('adfghklmnoprstvxyz', @code)">
        <z:index name="Title-uniform-subfields:w Title-uniform-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='148']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('avxyz', @code)">
        <z:index name="Chronological-term-subfields:w Chronological-term-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='150']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('abvxyz', @code)">
        <z:index name="Subject-topical-subfields:w Subject-topical-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='151']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('avxyz', @code)">
        <z:index name="Name-geographic-subfields:w Name-geographic-subfields:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_subfields" match="marc:datafield[@tag='155']">
    <xsl:for-each select="marc:subfield">
      <xsl:if test="contains('avxyz', @code)">
        <z:index name="Term-genre-form:w Term-genre-form:p">
          <xsl:value-of select="."/>
        </z:index>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='100']">
    <z:index name="Personal-name-heading:w Personal-name-heading:p Personal-name-heading:s Personal-name:w Personal-name:p Personal-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abcdefghjklmnopqrstvxyz', @code)" name="Personal-name-heading:w Personal-name-heading:p Personal-name-heading:s Personal-name:w Personal-name:p Personal-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='400']">
    <z:index name="Personal-name-see-from:w Personal-name-see-from:p Personal-name-see-from:s Personal-name:w Personal-name:p Personal-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abcdefghjklmnopqrstvxyz', @code)" name="Personal-name-see-from:w Personal-name-see-from:p Personal-name-see-from:s Personal-name:w Personal-name:p Personal-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='500']">
    <z:index name="Personal-name-see-also-from:w Personal-name-see-also-from:p Personal-name-see-also-from:s Personal-name:w Personal-name:p Personal-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abcdefghjklmnopqrstvxyz', @code)" name="Personal-name-see-also-from:w Personal-name-see-also-from:p Personal-name-see-also-from:s Personal-name:w Personal-name:p Personal-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='110']">
    <z:index name="Corporate-name-heading:w Corporate-name-heading:p Corporate-name-heading:s Corporate-name:w Corporate-name:p Corporate-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abcdefghklmnoprstvxyz', @code)" name="Corporate-name-heading:w Corporate-name-heading:p Corporate-name-heading:s Corporate-name:w Corporate-name:p Corporate-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='410']">
    <z:index name="Corporate-name-see-from:w Corporate-name-see-from:p Corporate-name-see-from:s Corporate-name:w Corporate-name:p Corporate-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abcdefghklmnoprstvxyz', @code)" name="Corporate-name-see-from:w Corporate-name-see-from:p Corporate-name-see-from:s Corporate-name:w Corporate-name:p Corporate-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='510']">
    <z:index name="Corporate-name-see-also-from:w Corporate-name-see-also-from:p Corporate-name-see-also-from:s Corporate-name:w Corporate-name:p Corporate-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abcdefghklmnoprstvxyz', @code)" name="Corporate-name-see-also-from:w Corporate-name-see-also-from:p Corporate-name-see-also-from:s Corporate-name:w Corporate-name:p Corporate-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='111']">
    <z:index name="Meeting-name-heading:w Meeting-name-heading:p Meeting-name-heading:s Meeting-name:w Meeting-name:p Meeting-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('acdefghjklnpqstvxyz', @code)" name="Meeting-name-heading:w Meeting-name-heading:p Meeting-name-heading:s Meeting-name:w Meeting-name:p Meeting-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='411']">
    <z:index name="Meeting-name-see-from:w Meeting-name-see-from:p Meeting-name-see-from:s Meeting-name:w Meeting-name:p Meeting-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('acdefghjklnpqstvxyz', @code)" name="Meeting-name-see-from:w Meeting-name-see-from:p Meeting-name-see-from:s Meeting-name:w Meeting-name:p Meeting-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='511']">
    <z:index name="Meeting-name-see-also-from:w Meeting-name-see-also-from:p Meeting-name-see-also-from:s Meeting-name:w Meeting-name:p Meeting-name:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('acdefghjklnpqstvxyz', @code)" name="Meeting-name-see-also-from:w Meeting-name-see-also-from:p Meeting-name-see-also-from:s Meeting-name:w Meeting-name:p Meeting-name:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='130']">
    <z:index name="Title-uniform-heading:w Title-uniform-heading:p Title-uniform-heading:s Title-uniform:w Title-uniform:p Title-uniform:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('adfghklmnoprstvxyz', @code)" name="Title-uniform-heading:w Title-uniform-heading:p Title-uniform-heading:s Title-uniform:w Title-uniform:p Title-uniform:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='430']">
    <z:index name="Title-uniform-see-from:w Title-uniform-see-from:p Title-uniform-see-from:s Title-uniform:w Title-uniform:p Title-uniform:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('adfghklmnoprstvxyz', @code)" name="Title-uniform-see-from:w Title-uniform-see-from:p Title-uniform-see-from:s Title-uniform:w Title-uniform:p Title-uniform:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='530']">
    <z:index name="Title-uniform-see-also-from:w Title-uniform-see-also-from:p Title-uniform-see-also-from:s Title-uniform:w Title-uniform:p Title-uniform:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('adfghklmnoprstvxyz', @code)" name="Title-uniform-see-also-from:w Title-uniform-see-also-from:p Title-uniform-see-also-from:s Title-uniform:w Title-uniform:p Title-uniform:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='148']">
    <z:index name="Chronological-term-heading:w Chronological-term-heading:p Chronological-term-heading:s Chronological-term:w Chronological-term:p Chronological-term:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Chronological-term-heading:w Chronological-term-heading:p Chronological-term-heading:s Chronological-term:w Chronological-term:p Chronological-term:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='448']">
    <z:index name="Chronological-term-see-from:w Chronological-term-see-from:p Chronological-term-see-from:s Chronological-term:w Chronological-term:p Chronological-term:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Chronological-term-see-from:w Chronological-term-see-from:p Chronological-term-see-from:s Chronological-term:w Chronological-term:p Chronological-term:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='548']">
    <z:index name="Chronological-term-see-also-from:w Chronological-term-see-also-from:p Chronological-term-see-also-from:s Chronological-term:w Chronological-term:p Chronological-term:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Chronological-term-see-also-from:w Chronological-term-see-also-from:p Chronological-term-see-also-from:s Chronological-term:w Chronological-term:p Chronological-term:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='150']">
    <z:index name="Subject-topical-heading:w Subject-topical-heading:p Subject-topical-heading:s Subject-topical:w Subject-topical:p Subject-topical:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abvxyz', @code)" name="Subject-topical-heading:w Subject-topical-heading:p Subject-topical-heading:s Subject-topical:w Subject-topical:p Subject-topical:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='450']">
    <z:index name="Subject-topical-see-from:w Subject-topical-see-from:p Subject-topical-see-from:s Subject-topical:w Subject-topical:p Subject-topical:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abvxyz', @code)" name="Subject-topical-see-from:w Subject-topical-see-from:p Subject-topical-see-from:s Subject-topical:w Subject-topical:p Subject-topical:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='550']">
    <z:index name="Subject-topical-see-also-from:w Subject-topical-see-also-from:p Subject-topical-see-also-from:s Subject-topical:w Subject-topical:p Subject-topical:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('abvxyz', @code)" name="Subject-topical-see-also-from:w Subject-topical-see-also-from:p Subject-topical-see-also-from:s Subject-topical:w Subject-topical:p Subject-topical:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='151']">
    <z:index name="Name-geographic-heading:w Name-geographic-heading:p Name-geographic-heading:s Name-geographic:w Name-geographic:p Name-geographic:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Name-geographic-heading:w Name-geographic-heading:p Name-geographic-heading:s Name-geographic:w Name-geographic:p Name-geographic:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='451']">
    <z:index name="Name-geographic-see-from:w Name-geographic-see-from:p Name-geographic-see-from:s Name-geographic:w Name-geographic:p Name-geographic:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Name-geographic-see-from:w Name-geographic-see-from:p Name-geographic-see-from:s Name-geographic:w Name-geographic:p Name-geographic:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='551']">
    <z:index name="Name-geographic-see-also-from:w Name-geographic-see-also-from:p Name-geographic-see-also-from:s Name-geographic:w Name-geographic:p Name-geographic:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Name-geographic-see-also-from:w Name-geographic-see-also-from:p Name-geographic-see-also-from:s Name-geographic:w Name-geographic:p Name-geographic:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='155']">
    <z:index name="Term-genre-form-heading:w Term-genre-form-heading:p Term-genre-form-heading:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Term-genre-form-heading:w Term-genre-form-heading:p Term-genre-form-heading:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='455']">
    <z:index name="Term-genre-form-see-from:w Term-genre-form-see-from:p Term-genre-form-see-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Term-genre-form-see-from:w Term-genre-form-see-from:p Term-genre-form-see-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='555']">
    <z:index name="Term-genre-form-see-also-from:w Term-genre-form-see-also-from:p Term-genre-form-see-also-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('avxyz', @code)" name="Term-genre-form-see-also-from:w Term-genre-form-see-also-from:p Term-genre-form-see-also-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='180']">
    <z:index name="General-subdivision:w General-subdivision:p General-subdivision:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="General-subdivision:w General-subdivision:p General-subdivision:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='480']">
    <z:index name="General-subdivision-see-from:w General-subdivision-see-from:p General-subdivision-see-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="General-subdivision-see-from:w General-subdivision-see-from:p General-subdivision-see-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='580']">
    <z:index name="General-subdivision-see-also-from:w General-subdivision-see-also-from:p General-subdivision-see-also-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="General-subdivision-see-also-from:w General-subdivision-see-also-from:p General-subdivision-see-also-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='181']">
    <z:index name="Geographic-subdivision:w Geographic-subdivision:p Geographic-subdivision:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Geographic-subdivision:w Geographic-subdivision:p Geographic-subdivision:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='481']">
    <z:index name="Geographic-subdivision-see-from:w Geographic-subdivision-see-from:p Geographic-subdivision-see-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Geographic-subdivision-see-from:w Geographic-subdivision-see-from:p Geographic-subdivision-see-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='581']">
    <z:index name="Geographic-subdivision-see-also-from:w Geographic-subdivision-see-also-from:p Geographic-subdivision-see-also-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Geographic-subdivision-see-also-from:w Geographic-subdivision-see-also-from:p Geographic-subdivision-see-also-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='182']">
    <z:index name="Chronological-subdivision:w Chronological-subdivision:p Chronological-subdivision:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Chronological-subdivision:w Chronological-subdivision:p Chronological-subdivision:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='482']">
    <z:index name="Chronological-subdivision-see-from:w Chronological-subdivision-see-from:p Chronological-subdivision-see-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Chronological-subdivision-see-from:w Chronological-subdivision-see-from:p Chronological-subdivision-see-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='582']">
    <z:index name="Chronological-subdivision-see-also-from:w Chronological-subdivision-see-also-from:p Chronological-subdivision-see-also-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Chronological-subdivision-see-also-from:w Chronological-subdivision-see-also-from:p Chronological-subdivision-see-also-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='185']">
    <z:index name="Form-subdivision:w Form-subdivision:p Form-subdivision:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Form-subdivision:w Form-subdivision:p Form-subdivision:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='485']">
    <z:index name="Form-subdivision-see-from:w Form-subdivision-see-from:p Form-subdivision-see-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Form-subdivision-see-from:w Form-subdivision-see-from:p Form-subdivision-see-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:template mode="index_heading" match="marc:datafield[@tag='585']">
    <z:index name="Form-subdivision-see-also-from:w Form-subdivision-see-also-from:p Form-subdivision-see-also-from:s">
      <xsl:variable name="raw_heading">
        <xsl:for-each select="marc:subfield">
          <xsl:if test="contains('vxyz', @code)" name="Form-subdivision-see-also-from:w Form-subdivision-see-also-from:p Form-subdivision-see-also-from:s">
            <xsl:if test="position() &gt; 1">
              <xsl:choose>
                <xsl:when test="contains('vxyz', @code)">
                  <xsl:text>--</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(' ', 1, 1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($raw_heading)"/>
    </z:index>
  </xsl:template>
  <xsl:variable name="form_subdivision_subfield">v</xsl:variable>
  <xsl:variable name="general_subdivision_subfield">x</xsl:variable>
  <xsl:variable name="chronological_subdivision_subfield">y</xsl:variable>
  <xsl:variable name="geographic_subdivision_subfield">z</xsl:variable>
</xsl:stylesheet>
