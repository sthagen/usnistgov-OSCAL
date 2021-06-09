<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
                xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                xmlns:j="http://www.w3.org/2005/xpath-functions"
                xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                version="3.0"
                exclude-result-prefixes="#all">
<!-- JSON to XML conversion: pipeline -->
   <xsl:output indent="true"/>
   <!-- Processing architecture -->
   <!-- $file should be a URI, absolute or relative to the XSLT transformation-->
   <xsl:param name="file" as="xs:anyURI?"/>
   <!-- Pass in $produce=supermodel to produce OSCAL M4 supermodel intermediate format -->
   <xsl:param name="produce" as="xs:string">xml</xsl:param>
   <xsl:template name="from-json">
      <xsl:if test="not(unparsed-text-available($file))" expand-text="true">
         <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema">No file found at { $file }</nm:ERROR>
      </xsl:if>
      <xsl:call-template name="from-xdm-json-xml">
         <xsl:with-param name="source">
            <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors"
                     select="unparsed-text($file) ! json-to-xml(.)">
               <xsl:catch expand-text="true">
                  <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema" code="{ $err:code }">{{ $err:description }}</nm:ERROR>
               </xsl:catch>
            </xsl:try>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:mode name="cast-md" on-no-match="shallow-copy"/>
   <xsl:template match="/" name="from-xdm-json-xml" expand-text="true">
      <xsl:param name="source">
         <xsl:choose><!-- evaluate { $file } as URI (absolute or relative to stylesheet)-->
            <xsl:when test="exists($file)">
               <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors" select="document($file)">
                  <xsl:catch expand-text="true">
                     <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema" code="{ $err:code }">{ $err:description }</nm:ERROR>
                  </xsl:catch>
               </xsl:try>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="/"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:if test="empty($source/j:map)" expand-text="true">
         <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema">No XPath (XML) JSON found at { $file } - using syntax of http://www.w3.org/2005/xpath-functions</nm:ERROR>
      </xsl:if>
      <xsl:variable name="near-supermodel">
         <xsl:apply-templates select="$source/*"/>
      </xsl:variable>
      <xsl:variable name="supermodel">
         <xsl:apply-templates select="$near-supermodel/*" mode="cast-md"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$produce = 'supermodel'">
            <xsl:sequence select="$supermodel"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="$supermodel" mode="write-xml"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/j:map[empty(@key)]" priority="10">
      <xsl:apply-templates/>
   </xsl:template>
   <!-- JSON to XML conversion: object filters -->
   <xsl:strip-space elements="j:map j:array"/>
   <!-- METASCHEMA conversion stylesheet supports JSON -> METASCHEMA/SUPERMODEL conversion -->
   <!-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ -->
   <!-- METASCHEMA:  in namespace "http://csrc.nist.gov/ns/oscal/1.0"-->
   <xsl:template match="j:map[@key='profile']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/profile"
                _metaschema-json-id="/assembly/oscal-profile/profile"
                name="profile"
                key="profile"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:profile"
                _using-root-name="profile"
                gi="profile">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">profile</xsl:attribute>
         </xsl:if>
         <xsl:if test=".. is /j:map">
            <xsl:attribute name="namespace">http://csrc.nist.gov/ns/oscal/1.0</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='uuid']"/>
         <xsl:apply-templates select="*[@key='metadata']"/>
         <xsl:apply-templates select="*[@key='imports']"/>
         <xsl:apply-templates select="*[@key='merge']"/>
         <xsl:apply-templates select="*[@key='modify']"/>
         <xsl:apply-templates select="*[@key='back-matter']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='metadata']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="metadata" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/profile/metadata"
                _metaschema-json-id="/assembly/oscal-profile/profile/metadata"
                name="metadata"
                key="metadata"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:metadata"
                _step="metadata"
                _key="metadata"
                _key-ref="oscal-metadata:metadata"
                _using-name="metadata"
                _in-xml-name="metadata"
                _in-json-name="metadata"
                gi="metadata">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">metadata</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='published']"/>
         <xsl:apply-templates select="*[@key='last-modified']"/>
         <xsl:apply-templates select="*[@key='version']"/>
         <xsl:apply-templates select="*[@key='oscal-version']"/>
         <xsl:apply-templates select="*[@key='revisions']"/>
         <xsl:apply-templates select="*[@key='document-ids']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='roles']"/>
         <xsl:apply-templates select="*[@key='locations']"/>
         <xsl:apply-templates select="*[@key='parties']"/>
         <xsl:apply-templates select="*[@key='responsible-parties']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='props']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="prop" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/revision/prop"
                _metaschema-json-id="/assembly/oscal-metadata/revision/props"
                name="property"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:property"
                _step="prop"
                _key="props"
                _key-ref="oscal-metadata:property"
                _using-name="prop"
                _in-xml-name="prop"
                _in-json-name="props"
                gi="prop">
         <xsl:apply-templates select="*[@key='name']"/>
         <xsl:apply-templates select="*[@key='uuid']"/>
         <xsl:apply-templates select="*[@key='ns']"/>
         <xsl:apply-templates select="*[@key='value']"/>
         <xsl:apply-templates select="*[@key='class']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='links']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="link" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/revision/link"
                _metaschema-json-id="/assembly/oscal-metadata/revision/links"
                name="link"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:link"
                _step="link"
                _key="links"
                _key-ref="oscal-metadata:link"
                _using-name="link"
                _in-xml-name="link"
                _in-json-name="links"
                gi="link">
         <xsl:apply-templates select="*[@key='href']"/>
         <xsl:apply-templates select="*[@key='rel']"/>
         <xsl:apply-templates select="*[@key='media-type']"/>
         <xsl:apply-templates select="*[@key='text']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='roles']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="role" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/metadata/role"
                _metaschema-json-id="/assembly/oscal-metadata/metadata/roles"
                name="role"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:role"
                _step="role"
                _key="roles"
                _key-ref="oscal-metadata:role"
                _using-name="role"
                _in-xml-name="role"
                _in-json-name="roles"
                gi="role">
         <xsl:apply-templates select="*[@key='id']"/>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='short-name']"/>
         <xsl:apply-templates select="*[@key='description']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='locations']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="location" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/metadata/location"
                _metaschema-json-id="/assembly/oscal-metadata/metadata/locations"
                name="location"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:location"
                _step="location"
                _key="locations"
                _key-ref="oscal-metadata:location"
                _using-name="location"
                _in-xml-name="location"
                _in-json-name="locations"
                gi="location">
         <xsl:apply-templates select="*[@key='uuid']"/>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='address']"/>
         <xsl:apply-templates select="*[@key='email-addresses']"/>
         <xsl:apply-templates select="*[@key='telephone-numbers']"/>
         <xsl:apply-templates select="*[@key='urls']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='parties']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="party" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/metadata/party"
                _metaschema-json-id="/assembly/oscal-metadata/metadata/parties"
                name="party"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:party"
                _step="party"
                _key="parties"
                _key-ref="oscal-metadata:party"
                _using-name="party"
                _in-xml-name="party"
                _in-json-name="parties"
                gi="party">
         <xsl:apply-templates select="*[@key='uuid']"/>
         <xsl:apply-templates select="*[@key='type']"/>
         <xsl:apply-templates select="*[@key='name']"/>
         <xsl:apply-templates select="*[@key='short-name']"/>
         <xsl:apply-templates select="*[@key='external-ids']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='email-addresses']"/>
         <xsl:apply-templates select="*[@key='telephone-numbers']"/>
         <xsl:apply-templates select="*[@key='addresses']"/>
         <xsl:apply-templates select="*[@key='location-uuids']"/>
         <xsl:apply-templates select="*[@key='member-of-organizations']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='responsible-parties']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="responsible-party" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/metadata/responsible-party"
                _metaschema-json-id="/assembly/oscal-metadata/metadata/responsible-parties"
                name="responsible-party"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:responsible-party"
                _step="responsible-party"
                _key="responsible-parties"
                _key-ref="oscal-metadata:responsible-party"
                _using-name="responsible-party"
                _in-xml-name="responsible-party"
                _in-json-name="responsible-parties"
                gi="responsible-party">
         <xsl:apply-templates select="*[@key='role-id']"/>
         <xsl:apply-templates select="*[@key='party-uuids']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='imports']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="import" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/profile/import"
                _metaschema-json-id="/assembly/oscal-profile/profile/imports"
                name="import"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:import"
                _step="import"
                _key="imports"
                _key-ref="oscal-profile:import"
                _using-name="import"
                _in-xml-name="import"
                _in-json-name="imports"
                gi="import">
         <xsl:apply-templates select="*[@key='href']"/>
         <xsl:apply-templates select="*[@key='include-all']"/>
         <xsl:apply-templates select="*[@key='include-controls']"/>
         <xsl:apply-templates select="*[@key='exclude-controls']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='include-all']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="include-all" -->
      <assembly as-type="empty"
                _metaschema-xml-id="/assembly/oscal-profile/import/include-all"
                _metaschema-json-id="/assembly/oscal-profile/import/include-all"
                name="include-all"
                key="include-all"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:include-all"
                _step="include-all"
                _key="include-all"
                _key-ref="oscal-profile:include-all"
                _using-name="include-all"
                _in-xml-name="include-all"
                _in-json-name="include-all"
                gi="include-all">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">include-all</xsl:attribute>
         </xsl:if>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='merge']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="merge" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/profile/merge"
                _metaschema-json-id="/assembly/oscal-profile/profile/merge"
                name="merge"
                key="merge"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:merge"
                _step="merge"
                _key="merge"
                _key-ref="oscal-profile:merge"
                _using-name="merge"
                _in-xml-name="merge"
                _in-json-name="merge"
                gi="merge">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">merge</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='combine']"/>
         <xsl:apply-templates select="*[@key='as-is']"/>
         <xsl:apply-templates select="*[@key='custom']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='combine']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="combine" -->
      <assembly as-type="empty"
                _metaschema-xml-id="/assembly/oscal-profile/merge/combine"
                _metaschema-json-id="/assembly/oscal-profile/merge/combine"
                name="combine"
                key="combine"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:combine"
                _step="combine"
                _key="combine"
                _key-ref="oscal-profile:combine"
                _using-name="combine"
                _in-xml-name="combine"
                _in-json-name="combine"
                gi="combine">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">combine</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='method']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='custom']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="custom" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/merge/custom"
                _metaschema-json-id="/assembly/oscal-profile/merge/custom"
                name="custom"
                key="custom"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:custom"
                _step="custom"
                _key="custom"
                _key-ref="oscal-profile:custom"
                _using-name="custom"
                _in-xml-name="custom"
                _in-json-name="custom"
                gi="custom">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">custom</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='groups']"/>
         <xsl:apply-templates select="*[@key='insert-controls']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='groups']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="group" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/custom/group"
                _metaschema-json-id="/assembly/oscal-profile/custom/groups"
                name="group"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:group"
                _step="group"
                _key="groups"
                _key-ref="oscal-profile:group"
                _using-name="group"
                _in-xml-name="group"
                _in-json-name="groups"
                gi="group">
         <xsl:apply-templates select="*[@key='id']"/>
         <xsl:apply-templates select="*[@key='class']"/>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='params']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='parts']"/>
         <xsl:apply-templates select="*[@key='groups']"/>
         <xsl:apply-templates select="*[@key='insert-controls']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='params']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="param" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/group/param"
                _metaschema-json-id="/assembly/oscal-profile/group/params"
                name="parameter"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
                _key-name="oscal-catalog-common:parameter"
                _step="param"
                _key="params"
                _key-ref="oscal-catalog-common:parameter"
                _using-name="param"
                _in-xml-name="param"
                _in-json-name="params"
                gi="param">
         <xsl:apply-templates select="*[@key='id']"/>
         <xsl:apply-templates select="*[@key='class']"/>
         <xsl:apply-templates select="*[@key='depends-on']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='label']"/>
         <xsl:apply-templates select="*[@key='usage']"/>
         <xsl:apply-templates select="*[@key='constraints']"/>
         <xsl:apply-templates select="*[@key='guidelines']"/>
         <xsl:apply-templates select="*[@key='values']"/>
         <xsl:apply-templates select="*[@key='select']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='constraints']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="constraint" -->
      <assembly _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/constraint"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter/constraints"
                name="parameter-constraint"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
                _key-name="oscal-catalog-common:parameter-constraint"
                _step="constraint"
                _key="constraints"
                _key-ref="oscal-catalog-common:parameter-constraint"
                _using-name="constraint"
                _in-xml-name="constraint"
                _in-json-name="constraints"
                gi="constraint">
         <xsl:apply-templates select="*[@key='description']"/>
         <xsl:apply-templates select="*[@key='tests']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='guidelines']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="guideline" -->
      <assembly _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/guideline"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter/guidelines"
                name="parameter-guideline"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
                _key-name="oscal-catalog-common:parameter-guideline"
                _step="guideline"
                _key="guidelines"
                _key-ref="oscal-catalog-common:parameter-guideline"
                _using-name="guideline"
                _in-xml-name="guideline"
                _in-json-name="guidelines"
                gi="guideline">
         <xsl:apply-templates select="*[@key='prose']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='select']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="select" -->
      <assembly _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/select"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter/select"
                name="parameter-selection"
                key="select"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
                _key-name="oscal-catalog-common:parameter-selection"
                _step="select"
                _key="select"
                _key-ref="oscal-catalog-common:parameter-selection"
                _using-name="select"
                _in-xml-name="select"
                _in-json-name="select"
                gi="select">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">select</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='how-many']"/>
         <xsl:apply-templates select="*[@key='choice']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="part" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/group/part"
                _metaschema-json-id="/assembly/oscal-profile/group/parts"
                name="part"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
                _key-name="oscal-catalog-common:part"
                _step="part"
                _key="parts"
                _key-ref="oscal-catalog-common:part"
                _using-name="part"
                _in-xml-name="part"
                _in-json-name="parts"
                gi="part">
         <xsl:apply-templates select="*[@key='id']"/>
         <xsl:apply-templates select="*[@key='name']"/>
         <xsl:apply-templates select="*[@key='ns']"/>
         <xsl:apply-templates select="*[@key='class']"/>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='prose']"/>
         <xsl:apply-templates select="*[@key='parts']"/>
         <xsl:apply-templates select="*[@key='links']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='insert-controls']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="insert-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/group/insert-controls"
                _metaschema-json-id="/assembly/oscal-profile/group/insert-controls"
                name="insert-controls"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:insert-controls"
                _step="insert-controls"
                _key="insert-controls"
                _key-ref="oscal-profile:insert-controls"
                _using-name="insert-controls"
                _in-xml-name="insert-controls"
                _in-json-name="insert-controls"
                gi="insert-controls">
         <xsl:apply-templates select="*[@key='order']"/>
         <xsl:apply-templates select="*[@key='include-all']"/>
         <xsl:apply-templates select="*[@key='include-controls']"/>
         <xsl:apply-templates select="*[@key='exclude-controls']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='modify']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="modify" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/profile/modify"
                _metaschema-json-id="/assembly/oscal-profile/profile/modify"
                name="modify"
                key="modify"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:modify"
                _step="modify"
                _key="modify"
                _key-ref="oscal-profile:modify"
                _using-name="modify"
                _in-xml-name="modify"
                _in-json-name="modify"
                gi="modify">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">modify</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='set-parameters']"/>
         <xsl:apply-templates select="*[@key='alters']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='alters']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="alter" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/modify/alter"
                _metaschema-json-id="/assembly/oscal-profile/modify/alters"
                name="alter"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:alter"
                _step="alter"
                _key="alters"
                _key-ref="oscal-profile:alter"
                _using-name="alter"
                _in-xml-name="alter"
                _in-json-name="alters"
                gi="alter">
         <xsl:apply-templates select="*[@key='control-id']"/>
         <xsl:apply-templates select="*[@key='removes']"/>
         <xsl:apply-templates select="*[@key='adds']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="remove" -->
      <assembly as-type="empty"
                _metaschema-xml-id="/assembly/oscal-profile/alter/remove"
                _metaschema-json-id="/assembly/oscal-profile/alter/removes"
                name="remove"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:remove"
                _step="remove"
                _key="removes"
                _key-ref="oscal-profile:remove"
                _using-name="remove"
                _in-xml-name="remove"
                _in-json-name="removes"
                gi="remove">
         <xsl:apply-templates select="*[@key='by-name']"/>
         <xsl:apply-templates select="*[@key='by-class']"/>
         <xsl:apply-templates select="*[@key='by-id']"/>
         <xsl:apply-templates select="*[@key='by-item-name']"/>
         <xsl:apply-templates select="*[@key='by-ns']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:array[@key='adds']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="add" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/alter/add"
                _metaschema-json-id="/assembly/oscal-profile/alter/adds"
                name="add"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:add"
                _step="add"
                _key="adds"
                _key-ref="oscal-profile:add"
                _using-name="add"
                _in-xml-name="add"
                _in-json-name="adds"
                gi="add">
         <xsl:apply-templates select="*[@key='position']"/>
         <xsl:apply-templates select="*[@key='by-id']"/>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='params']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='parts']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='back-matter']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="back-matter" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/profile/back-matter"
                _metaschema-json-id="/assembly/oscal-profile/profile/back-matter"
                name="back-matter"
                key="back-matter"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:back-matter"
                _step="back-matter"
                _key="back-matter"
                _key-ref="oscal-metadata:back-matter"
                _using-name="back-matter"
                _in-xml-name="back-matter"
                _in-json-name="back-matter"
                gi="back-matter">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">back-matter</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='resources']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:string[@key='remarks']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="remarks" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/property/remarks"
             _metaschema-json-id="/assembly/oscal-metadata/property/remarks"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="remarks"
             key="remarks"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:remarks"
             _step="remarks"
             _key="remarks"
             _key-ref="oscal-metadata:remarks"
             _using-name="remarks"
             _in-xml-name="remarks"
             _in-json-name="remarks"
             gi="remarks"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">remarks</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:string[@key='remarks']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:array[@key='location-uuids']/j:string">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="location-uuid" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/party/location-uuid"
             _metaschema-json-id="/assembly/oscal-metadata/party/location-uuids"
             collapsible="no"
             as-type="uuid"
             name="location-uuid"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:location-uuid"
             _step="location-uuid"
             _key="location-uuids"
             _key-ref="oscal-metadata:location-uuid"
             _using-name="location-uuid"
             _in-xml-name="location-uuid"
             _in-json-name="location-uuids"
             gi="location-uuid"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:array[@key='location-uuids']/j:string"
                 mode="get-value-property"
                 priority="8">
      <value as-type="uuid" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:array[@key='party-uuids']/j:string">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="party-uuid" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/responsible-party/party-uuid"
             _metaschema-json-id="/assembly/oscal-metadata/responsible-party/party-uuids"
             collapsible="no"
             as-type="uuid"
             name="party-uuid"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:party-uuid"
             _step="party-uuid"
             _key="party-uuids"
             _key-ref="oscal-metadata:party-uuid"
             _using-name="party-uuid"
             _in-xml-name="party-uuid"
             _in-json-name="party-uuids"
             gi="party-uuid"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:array[@key='party-uuids']/j:string"
                 mode="get-value-property"
                 priority="7">
      <value as-type="uuid" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:boolean[@key='as-is']">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="as-is" -->
      <field _metaschema-xml-id="/assembly/oscal-profile/merge/as-is"
             _metaschema-json-id="/assembly/oscal-profile/merge/as-is"
             collapsible="no"
             as-type="boolean"
             name="as-is"
             key="as-is"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
             _key-name="oscal-profile:as-is"
             _step="as-is"
             _key="as-is"
             _key-ref="oscal-profile:as-is"
             _using-name="as-is"
             _in-xml-name="as-is"
             _in-json-name="as-is"
             gi="as-is"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">as-is</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:boolean[@key='as-is']"
                 mode="get-value-property"
                 priority="5">
      <value as-type="boolean" in-json="boolean">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="(j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:array[@key='values']/j:string | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:array[@key='values']/j:string | j:string[@key='value'] | j:array[@key='values']/j:string | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'])">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="value" -->
      <field _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/value"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter/values"
             collapsible="no"
             as-type="string"
             name="parameter-value"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
             _key-name="oscal-catalog-common:parameter-value"
             _step="value"
             _key="values"
             _key-ref="oscal-catalog-common:parameter-value"
             _using-name="value"
             _in-xml-name="value"
             _in-json-name="values"
             gi="value"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="(j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:array[@key='values']/j:string | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:array[@key='values']/j:string | j:string[@key='value'] | j:array[@key='values']/j:string | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'] | j:string[@key='value'])"
                 mode="get-value-property"
                 priority="12">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:array[@key='hashes']/j:map">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="hash" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/rlink/hash"
             _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/rlinks/hashes"
             collapsible="no"
             as-type="string"
             name="hash"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:hash"
             _step="hash"
             _key="hashes"
             _key-ref="oscal-metadata:hash"
             _using-name="hash"
             _in-xml-name="hash"
             _in-json-name="hashes"
             gi="hash">
         <xsl:apply-templates select="*[@key='algorithm']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching hash-->
   <xsl:template match="j:array[@key='hashes']/j:map" mode="get-value-property">
      <value as-type="string" key="value" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:string[@key='uuid']"><!-- XML match="profile/@uuid" -->
      <flag in-json="string"
            as-type="uuid"
            _step="uuid"
            _key="uuid"
            _metaschema-xml-id="/assembly/oscal-profile/profile/uuid"
            _metaschema-json-id="/assembly/oscal-profile/profile/uuid"
            name="uuid"
            key="uuid"
            _using-name="uuid"
            _in-xml-name="uuid"
            _in-json-name="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:string[@key='uuid']"
                 mode="keep-value-property"
                 priority="3"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='name']"><!-- XML match="prop/@name" -->
      <flag in-json="string"
            as-type="token"
            _step="name"
            _key="name"
            _metaschema-xml-id="/assembly/oscal-metadata/property/name"
            _metaschema-json-id="/assembly/oscal-metadata/property/name"
            name="name"
            key="name"
            _using-name="name"
            _in-xml-name="name"
            _in-json-name="name"
            gi="name">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='name']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='uuid']"><!-- XML match="prop/@uuid" -->
      <flag in-json="string"
            as-type="uuid"
            _step="uuid"
            _key="uuid"
            _metaschema-xml-id="/assembly/oscal-metadata/property/uuid"
            _metaschema-json-id="/assembly/oscal-metadata/property/uuid"
            name="uuid"
            key="uuid"
            _using-name="uuid"
            _in-xml-name="uuid"
            _in-json-name="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='uuid']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='ns']"><!-- XML match="prop/@ns" -->
      <flag in-json="string"
            as-type="uri"
            _step="ns"
            _key="ns"
            _metaschema-xml-id="/assembly/oscal-metadata/property/ns"
            _metaschema-json-id="/assembly/oscal-metadata/property/ns"
            name="ns"
            key="ns"
            _using-name="ns"
            _in-xml-name="ns"
            _in-json-name="ns"
            gi="ns">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='ns']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='value']"><!-- XML match="prop/@value" -->
      <flag in-json="string"
            as-type="string"
            _step="value"
            _key="value"
            _metaschema-xml-id="/assembly/oscal-metadata/property/value"
            _metaschema-json-id="/assembly/oscal-metadata/property/value"
            name="value"
            key="value"
            _using-name="value"
            _in-xml-name="value"
            _in-json-name="value"
            gi="value">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='value']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='class']"><!-- XML match="prop/@class" -->
      <flag in-json="string"
            as-type="token"
            _step="class"
            _key="class"
            _metaschema-xml-id="/assembly/oscal-metadata/property/class"
            _metaschema-json-id="/assembly/oscal-metadata/property/class"
            name="class"
            key="class"
            _using-name="class"
            _in-xml-name="class"
            _in-json-name="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='props']/j:map/j:string[@key='class']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='links']/j:map/j:string[@key='href']"><!-- XML match="link/@href" -->
      <flag in-json="string"
            as-type="uri-reference"
            _step="href"
            _key="href"
            _metaschema-xml-id="/assembly/oscal-metadata/link/href"
            _metaschema-json-id="/assembly/oscal-metadata/link/href"
            name="href"
            key="href"
            _using-name="href"
            _in-xml-name="href"
            _in-json-name="href"
            gi="href">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='links']/j:map/j:string[@key='href']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='links']/j:map/j:string[@key='rel']"><!-- XML match="link/@rel" -->
      <flag in-json="string"
            as-type="token"
            _step="rel"
            _key="rel"
            _metaschema-xml-id="/assembly/oscal-metadata/link/rel"
            _metaschema-json-id="/assembly/oscal-metadata/link/rel"
            name="rel"
            key="rel"
            _using-name="rel"
            _in-xml-name="rel"
            _in-json-name="rel"
            gi="rel">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='links']/j:map/j:string[@key='rel']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='links']/j:map/j:string[@key='media-type']"><!-- XML match="link/@media-type" -->
      <flag in-json="string"
            as-type="string"
            _metaschema-xml-id="/assembly/oscal-metadata/link/media-type"
            _metaschema-json-id="/assembly/oscal-metadata/link/media-type"
            name="media-type"
            key="media-type"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
            _key-name="oscal-metadata:media-type"
            _step="media-type"
            _key="media-type"
            _key-ref="oscal-metadata:media-type"
            _using-name="media-type"
            _in-xml-name="media-type"
            _in-json-name="media-type"
            gi="media-type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='links']/j:map/j:string[@key='media-type']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='document-ids']/j:map/j:string[@key='scheme'] | j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='document-ids']/j:map/j:string[@key='scheme']"
                 priority="6"><!-- XML match="profile/metadata/document-id/@scheme | profile/back-matter/resource/document-id/@scheme" -->
      <flag in-json="string"
            as-type="uri"
            _step="scheme"
            _key="scheme"
            _metaschema-xml-id="/field/oscal-metadata/document-id/scheme"
            _metaschema-json-id="/field/oscal-metadata/document-id/scheme"
            name="scheme"
            key="scheme"
            _using-name="scheme"
            _in-xml-name="scheme"
            _in-json-name="scheme"
            gi="scheme">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='document-ids']/j:map/j:string[@key='scheme'] | j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='document-ids']/j:map/j:string[@key='scheme']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='roles']/j:map/j:string[@key='id']"><!-- XML match="role/@id" -->
      <flag in-json="string"
            as-type="token"
            _step="id"
            _key="id"
            _metaschema-xml-id="/assembly/oscal-metadata/role/id"
            _metaschema-json-id="/assembly/oscal-metadata/role/id"
            name="id"
            key="id"
            _using-name="id"
            _in-xml-name="id"
            _in-json-name="id"
            gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='roles']/j:map/j:string[@key='id']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='locations']/j:map/j:string[@key='uuid']"><!-- XML match="location/@uuid" -->
      <flag in-json="string"
            as-type="uuid"
            _step="uuid"
            _key="uuid"
            _metaschema-xml-id="/assembly/oscal-metadata/location/uuid"
            _metaschema-json-id="/assembly/oscal-metadata/location/uuid"
            name="uuid"
            key="uuid"
            _using-name="uuid"
            _in-xml-name="uuid"
            _in-json-name="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='locations']/j:map/j:string[@key='uuid']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='type'] | j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='type']"><!-- XML match="profile/metadata/location/address/@type | profile/metadata/party/address/@type" -->
      <flag in-json="string"
            as-type="token"
            _metaschema-xml-id="/assembly/oscal-metadata/address/type"
            _metaschema-json-id="/assembly/oscal-metadata/address/type"
            name="location-type"
            key="type"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
            _key-name="oscal-metadata:location-type"
            _step="type"
            _key="type"
            _key-ref="oscal-metadata:location-type"
            _using-name="type"
            _in-xml-name="type"
            _in-json-name="type"
            gi="type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='type'] | j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='type']"
                 mode="keep-value-property"
                 priority="7"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='telephone-numbers']/j:map/j:string[@key='type'] | j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='telephone-numbers']/j:map/j:string[@key='type']"
                 priority="8"><!-- XML match="profile/metadata/location/telephone-number/@type | profile/metadata/party/telephone-number/@type" -->
      <flag in-json="string"
            as-type="string"
            _step="type"
            _key="type"
            _metaschema-xml-id="/field/oscal-metadata/telephone-number/type"
            _metaschema-json-id="/field/oscal-metadata/telephone-number/type"
            name="type"
            key="type"
            _using-name="type"
            _in-xml-name="type"
            _in-json-name="type"
            gi="type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='telephone-numbers']/j:map/j:string[@key='type'] | j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='telephone-numbers']/j:map/j:string[@key='type']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='parties']/j:map/j:string[@key='uuid']"><!-- XML match="party/@uuid" -->
      <flag in-json="string"
            as-type="uuid"
            _step="uuid"
            _key="uuid"
            _metaschema-xml-id="/assembly/oscal-metadata/party/uuid"
            _metaschema-json-id="/assembly/oscal-metadata/party/uuid"
            name="uuid"
            key="uuid"
            _using-name="uuid"
            _in-xml-name="uuid"
            _in-json-name="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='parties']/j:map/j:string[@key='uuid']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='parties']/j:map/j:string[@key='type']"><!-- XML match="party/@type" -->
      <flag in-json="string"
            as-type="string"
            _step="type"
            _key="type"
            _metaschema-xml-id="/assembly/oscal-metadata/party/type"
            _metaschema-json-id="/assembly/oscal-metadata/party/type"
            name="type"
            key="type"
            _using-name="type"
            _in-xml-name="type"
            _in-json-name="type"
            gi="type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='parties']/j:map/j:string[@key='type']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='external-ids']/j:map/j:string[@key='scheme']"
                 priority="8"><!-- XML match="profile/metadata/party/external-id/@scheme" -->
      <flag in-json="string"
            as-type="uri"
            _step="scheme"
            _key="scheme"
            _metaschema-xml-id="/assembly/oscal-metadata/party/external-id/scheme"
            _metaschema-json-id="/assembly/oscal-metadata/party/external-ids/scheme"
            name="scheme"
            key="scheme"
            _using-name="scheme"
            _in-xml-name="scheme"
            _in-json-name="scheme"
            gi="scheme">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='external-ids']/j:map/j:string[@key='scheme']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='responsible-parties']/j:map/j:string[@key='role-id']"><!-- XML match="responsible-party/@role-id" -->
      <flag in-json="string"
            as-type="token"
            _step="role-id"
            _key="role-id"
            _metaschema-xml-id="/assembly/oscal-metadata/responsible-party/role-id"
            _metaschema-json-id="/assembly/oscal-metadata/responsible-party/role-id"
            name="role-id"
            key="role-id"
            _using-name="role-id"
            _in-xml-name="role-id"
            _in-json-name="role-id"
            gi="role-id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='responsible-parties']/j:map/j:string[@key='role-id']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='imports']/j:map/j:string[@key='href']"><!-- XML match="import/@href" -->
      <flag in-json="string"
            as-type="uri-reference"
            _step="href"
            _key="href"
            _metaschema-xml-id="/assembly/oscal-profile/import/href"
            _metaschema-json-id="/assembly/oscal-profile/import/href"
            name="href"
            key="href"
            _using-name="href"
            _in-xml-name="href"
            _in-json-name="href"
            gi="href">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='imports']/j:map/j:string[@key='href']"
                 mode="keep-value-property"
                 priority="5"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:string[@key='with-child-controls']"><!-- XML match="profile/import/include-controls/@with-child-controls | profile/import/exclude-controls/@with-child-controls | profile/merge/custom//group/insert-controls/include-controls/@with-child-controls | profile/merge/custom//group/insert-controls/exclude-controls/@with-child-controls | profile/merge/custom/insert-controls/include-controls/@with-child-controls | profile/merge/custom/insert-controls/exclude-controls/@with-child-controls" -->
      <flag in-json="string"
            as-type="token"
            _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-child-controls"
            _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-child-controls"
            name="with-child-controls"
            key="with-child-controls"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
            _key-name="oscal-profile:with-child-controls"
            _step="with-child-controls"
            _key="with-child-controls"
            _key-ref="oscal-profile:with-child-controls"
            _using-name="with-child-controls"
            _in-xml-name="with-child-controls"
            _in-json-name="with-child-controls"
            gi="with-child-controls">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:string[@key='with-child-controls'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:string[@key='with-child-controls']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern']"><!-- XML match="profile/import/include-controls/matching/@pattern | profile/import/exclude-controls/matching/@pattern | profile/merge/custom//group/insert-controls/include-controls/matching/@pattern | profile/merge/custom//group/insert-controls/exclude-controls/matching/@pattern | profile/merge/custom/insert-controls/include-controls/matching/@pattern | profile/merge/custom/insert-controls/exclude-controls/matching/@pattern" -->
      <flag in-json="string"
            as-type="string"
            _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching/pattern"
            _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching/pattern"
            name="pattern"
            key="pattern"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
            _key-name="oscal-profile:pattern"
            _step="pattern"
            _key="pattern"
            _key-ref="oscal-profile:pattern"
            _using-name="pattern"
            _in-xml-name="pattern"
            _in-json-name="pattern"
            gi="pattern">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern'] | j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map/j:string[@key='pattern']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='combine']/j:string[@key='method']"><!-- XML match="combine/@method" -->
      <flag in-json="string"
            as-type="string"
            _metaschema-xml-id="/assembly/oscal-profile/combine/method"
            _metaschema-json-id="/assembly/oscal-profile/combine/method"
            name="method"
            key="method"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
            _key-name="oscal-profile:method"
            _step="method"
            _key="method"
            _key-ref="oscal-profile:method"
            _using-name="method"
            _in-xml-name="method"
            _in-json-name="method"
            gi="method">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='combine']/j:string[@key='method']"
                 mode="keep-value-property"
                 priority="5"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='groups']/j:map/j:string[@key='id']"><!-- XML match="group/@id" -->
      <flag in-json="string"
            as-type="token"
            _step="id"
            _key="id"
            _metaschema-xml-id="/assembly/oscal-profile/group/id"
            _metaschema-json-id="/assembly/oscal-profile/group/id"
            name="id"
            key="id"
            _using-name="id"
            _in-xml-name="id"
            _in-json-name="id"
            gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='groups']/j:map/j:string[@key='id']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='groups']/j:map/j:string[@key='class']"><!-- XML match="group/@class" -->
      <flag in-json="string"
            as-type="token"
            _step="class"
            _key="class"
            _metaschema-xml-id="/assembly/oscal-profile/group/class"
            _metaschema-json-id="/assembly/oscal-profile/group/class"
            name="class"
            key="class"
            _using-name="class"
            _in-xml-name="class"
            _in-json-name="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='groups']/j:map/j:string[@key='class']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='params']/j:map/j:string[@key='id']"><!-- XML match="param/@id" -->
      <flag in-json="string"
            as-type="token"
            _step="id"
            _key="id"
            _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/id"
            _metaschema-json-id="/assembly/oscal-catalog-common/parameter/id"
            name="id"
            key="id"
            _using-name="id"
            _in-xml-name="id"
            _in-json-name="id"
            gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='params']/j:map/j:string[@key='id']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='params']/j:map/j:string[@key='class']"><!-- XML match="param/@class" -->
      <flag in-json="string"
            as-type="token"
            _step="class"
            _key="class"
            _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/class"
            _metaschema-json-id="/assembly/oscal-catalog-common/parameter/class"
            name="class"
            key="class"
            _using-name="class"
            _in-xml-name="class"
            _in-json-name="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='params']/j:map/j:string[@key='class']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='params']/j:map/j:string[@key='depends-on']"><!-- XML match="param/@depends-on" -->
      <flag in-json="string"
            as-type="token"
            _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/depends-on"
            _metaschema-json-id="/assembly/oscal-catalog-common/parameter/depends-on"
            name="depends-on"
            key="depends-on"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
            _key-name="oscal-catalog-common:depends-on"
            _step="depends-on"
            _key="depends-on"
            _key-ref="oscal-catalog-common:depends-on"
            _using-name="depends-on"
            _in-xml-name="depends-on"
            _in-json-name="depends-on"
            gi="depends-on">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='params']/j:map/j:string[@key='depends-on']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='select']/j:string[@key='how-many']"><!-- XML match="select/@how-many" -->
      <flag in-json="string"
            as-type="token"
            _step="how-many"
            _key="how-many"
            _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-selection/how-many"
            _metaschema-json-id="/assembly/oscal-catalog-common/parameter-selection/how-many"
            name="how-many"
            key="how-many"
            _using-name="how-many"
            _in-xml-name="how-many"
            _in-json-name="how-many"
            gi="how-many">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='select']/j:string[@key='how-many']"
                 mode="keep-value-property"
                 priority="12"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='id']"><!-- XML match="part/@id" -->
      <flag in-json="string"
            as-type="token"
            _step="id"
            _key="id"
            _metaschema-xml-id="/assembly/oscal-catalog-common/part/id"
            _metaschema-json-id="/assembly/oscal-catalog-common/part/id"
            name="id"
            key="id"
            _using-name="id"
            _in-xml-name="id"
            _in-json-name="id"
            gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='id']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='name']"><!-- XML match="part/@name" -->
      <flag in-json="string"
            as-type="token"
            _step="name"
            _key="name"
            _metaschema-xml-id="/assembly/oscal-catalog-common/part/name"
            _metaschema-json-id="/assembly/oscal-catalog-common/part/name"
            name="name"
            key="name"
            _using-name="name"
            _in-xml-name="name"
            _in-json-name="name"
            gi="name">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='name']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='ns']"><!-- XML match="part/@ns" -->
      <flag in-json="string"
            as-type="uri"
            _step="ns"
            _key="ns"
            _metaschema-xml-id="/assembly/oscal-catalog-common/part/ns"
            _metaschema-json-id="/assembly/oscal-catalog-common/part/ns"
            name="ns"
            key="ns"
            _using-name="ns"
            _in-xml-name="ns"
            _in-json-name="ns"
            gi="ns">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='ns']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='class']"><!-- XML match="part/@class" -->
      <flag in-json="string"
            as-type="token"
            _step="class"
            _key="class"
            _metaschema-xml-id="/assembly/oscal-catalog-common/part/class"
            _metaschema-json-id="/assembly/oscal-catalog-common/part/class"
            name="class"
            key="class"
            _using-name="class"
            _in-xml-name="class"
            _in-json-name="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='parts']/j:map/j:string[@key='class']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='insert-controls']/j:map/j:string[@key='order']"><!-- XML match="insert-controls/@order" -->
      <flag in-json="string"
            as-type="token"
            _step="order"
            _key="order"
            _metaschema-xml-id="/assembly/oscal-profile/insert-controls/order"
            _metaschema-json-id="/assembly/oscal-profile/insert-controls/order"
            name="order"
            key="order"
            _using-name="order"
            _in-xml-name="order"
            _in-json-name="order"
            gi="order">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='insert-controls']/j:map/j:string[@key='order']"
                 mode="keep-value-property"
                 priority="11"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='param-id']"
                 priority="6"><!-- XML match="profile/modify/set-parameter/@param-id" -->
      <flag in-json="string"
            as-type="token"
            _step="param-id"
            _key="param-id"
            _metaschema-xml-id="/assembly/oscal-profile/modify/set-parameter/param-id"
            _metaschema-json-id="/assembly/oscal-profile/modify/set-parameters/param-id"
            name="param-id"
            key="param-id"
            _using-name="param-id"
            _in-xml-name="param-id"
            _in-json-name="param-id"
            gi="param-id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='param-id']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='class']"
                 priority="6"><!-- XML match="profile/modify/set-parameter/@class" -->
      <flag in-json="string"
            as-type="token"
            _step="class"
            _key="class"
            _metaschema-xml-id="/assembly/oscal-profile/modify/set-parameter/class"
            _metaschema-json-id="/assembly/oscal-profile/modify/set-parameters/class"
            name="class"
            key="class"
            _using-name="class"
            _in-xml-name="class"
            _in-json-name="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='class']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='depends-on']"><!-- XML match="profile/modify/set-parameter/@depends-on" -->
      <flag in-json="string"
            as-type="token"
            _metaschema-xml-id="/assembly/oscal-profile/modify/set-parameter/depends-on"
            _metaschema-json-id="/assembly/oscal-profile/modify/set-parameters/depends-on"
            name="depends-on"
            key="depends-on"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
            _key-name="oscal-catalog-common:depends-on"
            _step="depends-on"
            _key="depends-on"
            _key-ref="oscal-catalog-common:depends-on"
            _using-name="depends-on"
            _in-xml-name="depends-on"
            _in-json-name="depends-on"
            gi="depends-on">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='depends-on']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='alters']/j:map/j:string[@key='control-id']"><!-- XML match="alter/@control-id" -->
      <flag in-json="string"
            as-type="token"
            _metaschema-xml-id="/assembly/oscal-profile/alter/control-id"
            _metaschema-json-id="/assembly/oscal-profile/alter/control-id"
            name="control-id"
            key="control-id"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_control-common_metaschema.xml"
            _key-name="oscal-catalog-common:control-id"
            _step="control-id"
            _key="control-id"
            _key-ref="oscal-catalog-common:control-id"
            _using-name="control-id"
            _in-xml-name="control-id"
            _in-json-name="control-id"
            gi="control-id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='alters']/j:map/j:string[@key='control-id']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-name']"><!-- XML match="remove/@by-name" -->
      <flag in-json="string"
            as-type="token"
            _step="by-name"
            _key="by-name"
            _metaschema-xml-id="/assembly/oscal-profile/remove/by-name"
            _metaschema-json-id="/assembly/oscal-profile/remove/by-name"
            name="by-name"
            key="by-name"
            _using-name="by-name"
            _in-xml-name="by-name"
            _in-json-name="by-name"
            gi="by-name">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-name']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-class']"><!-- XML match="remove/@by-class" -->
      <flag in-json="string"
            as-type="token"
            _step="by-class"
            _key="by-class"
            _metaschema-xml-id="/assembly/oscal-profile/remove/by-class"
            _metaschema-json-id="/assembly/oscal-profile/remove/by-class"
            name="by-class"
            key="by-class"
            _using-name="by-class"
            _in-xml-name="by-class"
            _in-json-name="by-class"
            gi="by-class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-class']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-id']"><!-- XML match="remove/@by-id" -->
      <flag in-json="string"
            as-type="token"
            _step="by-id"
            _key="by-id"
            _metaschema-xml-id="/assembly/oscal-profile/remove/by-id"
            _metaschema-json-id="/assembly/oscal-profile/remove/by-id"
            name="by-id"
            key="by-id"
            _using-name="by-id"
            _in-xml-name="by-id"
            _in-json-name="by-id"
            gi="by-id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-id']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-item-name']"><!-- XML match="remove/@by-item-name" -->
      <flag in-json="string"
            as-type="token"
            _step="by-item-name"
            _key="by-item-name"
            _metaschema-xml-id="/assembly/oscal-profile/remove/by-item-name"
            _metaschema-json-id="/assembly/oscal-profile/remove/by-item-name"
            name="by-item-name"
            key="by-item-name"
            _using-name="by-item-name"
            _in-xml-name="by-item-name"
            _in-json-name="by-item-name"
            gi="by-item-name">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-item-name']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-ns']"><!-- XML match="remove/@by-ns" -->
      <flag in-json="string"
            as-type="token"
            _step="by-ns"
            _key="by-ns"
            _metaschema-xml-id="/assembly/oscal-profile/remove/by-ns"
            _metaschema-json-id="/assembly/oscal-profile/remove/by-ns"
            name="by-ns"
            key="by-ns"
            _using-name="by-ns"
            _in-xml-name="by-ns"
            _in-json-name="by-ns"
            gi="by-ns">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='removes']/j:map/j:string[@key='by-ns']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='adds']/j:map/j:string[@key='position']"><!-- XML match="add/@position" -->
      <flag in-json="string"
            as-type="token"
            _step="position"
            _key="position"
            _metaschema-xml-id="/assembly/oscal-profile/add/position"
            _metaschema-json-id="/assembly/oscal-profile/add/position"
            name="position"
            key="position"
            _using-name="position"
            _in-xml-name="position"
            _in-json-name="position"
            gi="position">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='adds']/j:map/j:string[@key='position']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='adds']/j:map/j:string[@key='by-id']"><!-- XML match="add/@by-id" -->
      <flag in-json="string"
            as-type="token"
            _step="by-id"
            _key="by-id"
            _metaschema-xml-id="/assembly/oscal-profile/add/by-id"
            _metaschema-json-id="/assembly/oscal-profile/add/by-id"
            name="by-id"
            key="by-id"
            _using-name="by-id"
            _in-xml-name="by-id"
            _in-json-name="by-id"
            gi="by-id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='adds']/j:map/j:string[@key='by-id']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:string[@key='uuid']"
                 priority="6"><!-- XML match="profile/back-matter/resource/@uuid" -->
      <flag in-json="string"
            as-type="uuid"
            _step="uuid"
            _key="uuid"
            _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/uuid"
            _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/uuid"
            name="uuid"
            key="uuid"
            _using-name="uuid"
            _in-xml-name="uuid"
            _in-json-name="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:string[@key='uuid']"
                 mode="keep-value-property"
                 priority="6"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='rlinks']/j:map/j:string[@key='href']"
                 priority="8"><!-- XML match="profile/back-matter/resource/rlink/@href" -->
      <flag in-json="string"
            as-type="uri-reference"
            _step="href"
            _key="href"
            _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/rlink/href"
            _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/rlinks/href"
            name="href"
            key="href"
            _using-name="href"
            _in-xml-name="href"
            _in-json-name="href"
            gi="href">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='rlinks']/j:map/j:string[@key='href']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='rlinks']/j:map/j:string[@key='media-type']"><!-- XML match="profile/back-matter/resource/rlink/@media-type" -->
      <flag in-json="string"
            as-type="string"
            _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/rlink/media-type"
            _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/rlinks/media-type"
            name="media-type"
            key="media-type"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
            _key-name="oscal-metadata:media-type"
            _step="media-type"
            _key="media-type"
            _key-ref="oscal-metadata:media-type"
            _using-name="media-type"
            _in-xml-name="media-type"
            _in-json-name="media-type"
            gi="media-type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='rlinks']/j:map/j:string[@key='media-type']"
                 mode="keep-value-property"
                 priority="8"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:array[@key='hashes']/j:map/j:string[@key='algorithm']"><!-- XML match="hash/@algorithm" -->
      <flag in-json="string"
            as-type="string"
            _step="algorithm"
            _key="algorithm"
            _metaschema-xml-id="/field/oscal-metadata/hash/algorithm"
            _metaschema-json-id="/field/oscal-metadata/hash/algorithm"
            name="algorithm"
            key="algorithm"
            _using-name="algorithm"
            _in-xml-name="algorithm"
            _in-json-name="algorithm"
            gi="algorithm">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:array[@key='hashes']/j:map/j:string[@key='algorithm']"
                 mode="keep-value-property"
                 priority="10"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='base64']/j:string[@key='filename']"
                 priority="7"><!-- XML match="profile/back-matter/resource/base64/@filename" -->
      <flag in-json="string"
            as-type="uri-reference"
            _step="filename"
            _key="filename"
            _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/base64/filename"
            _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/base64/filename"
            name="filename"
            key="filename"
            _using-name="filename"
            _in-xml-name="filename"
            _in-json-name="filename"
            gi="filename">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='base64']/j:string[@key='filename']"
                 mode="keep-value-property"
                 priority="7"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='base64']/j:string[@key='media-type']"><!-- XML match="profile/back-matter/resource/base64/@media-type" -->
      <flag in-json="string"
            as-type="string"
            _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/base64/media-type"
            _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/base64/media-type"
            name="media-type"
            key="media-type"
            _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
            _key-name="oscal-metadata:media-type"
            _step="media-type"
            _key="media-type"
            _key-ref="oscal-metadata:media-type"
            _using-name="media-type"
            _in-xml-name="media-type"
            _in-json-name="media-type"
            gi="media-type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='base64']/j:string[@key='media-type']"
                 mode="keep-value-property"
                 priority="7"><!-- Not keeping the flag here. --></xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='title']"
                 priority="4">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-metadata/metadata/title"
             _metaschema-json-id="/assembly/oscal-metadata/metadata/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='title']"
                 mode="get-value-property"
                 priority="4">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='published']"
                 priority="4">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/published" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/metadata/published"
             _metaschema-json-id="/assembly/oscal-metadata/metadata/published"
             collapsible="no"
             as-type="dateTime-with-timezone"
             name="published"
             key="published"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:published"
             _step="published"
             _key="published"
             _key-ref="oscal-metadata:published"
             _using-name="published"
             _in-xml-name="published"
             _in-json-name="published"
             gi="published"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">published</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='published']"
                 mode="get-value-property"
                 priority="4">
      <value as-type="dateTime-with-timezone" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='last-modified']"
                 priority="4">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/last-modified" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/metadata/last-modified"
             _metaschema-json-id="/assembly/oscal-metadata/metadata/last-modified"
             collapsible="no"
             as-type="dateTime-with-timezone"
             name="last-modified"
             key="last-modified"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:last-modified"
             _step="last-modified"
             _key="last-modified"
             _key-ref="oscal-metadata:last-modified"
             _using-name="last-modified"
             _in-xml-name="last-modified"
             _in-json-name="last-modified"
             gi="last-modified"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">last-modified</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='last-modified']"
                 mode="get-value-property"
                 priority="4">
      <value as-type="dateTime-with-timezone" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='version']"
                 priority="4">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/version" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/metadata/version"
             _metaschema-json-id="/assembly/oscal-metadata/metadata/version"
             collapsible="no"
             as-type="string"
             name="version"
             key="version"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:version"
             _step="version"
             _key="version"
             _key-ref="oscal-metadata:version"
             _using-name="version"
             _in-xml-name="version"
             _in-json-name="version"
             gi="version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">version</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='version']"
                 mode="get-value-property"
                 priority="4">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='oscal-version']"
                 priority="4">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/oscal-version" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/metadata/oscal-version"
             _metaschema-json-id="/assembly/oscal-metadata/metadata/oscal-version"
             collapsible="no"
             as-type="string"
             name="oscal-version"
             key="oscal-version"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:oscal-version"
             _step="oscal-version"
             _key="oscal-version"
             _key-ref="oscal-metadata:oscal-version"
             _using-name="oscal-version"
             _in-xml-name="oscal-version"
             _in-json-name="oscal-version"
             gi="oscal-version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">oscal-version</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:string[@key='oscal-version']"
                 mode="get-value-property"
                 priority="4">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map"
                 priority="5">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/metadata/revisions/revision"
                _metaschema-json-id="/assembly/oscal-metadata/metadata/revisions"
                name="revision"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:revision"
                _step="revisions/revision"
                _key="revisions"
                _key-ref="oscal-metadata:revision"
                _using-name="revision"
                _in-xml-name="revision"
                _in-json-name="revisions"
                gi="revision">
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='published']"/>
         <xsl:apply-templates select="*[@key='last-modified']"/>
         <xsl:apply-templates select="*[@key='version']"/>
         <xsl:apply-templates select="*[@key='oscal-version']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']"
                 priority="4">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions" -->
      <group in-xml="SHOWN"
             gi="revisions"
             group-json="ARRAY"
             name="revision"
             key="revisions"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:revision"
             _key-ref="oscal-metadata:revision">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">revisions</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*"/>
      </group>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='title']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-metadata/revision/title"
             _metaschema-json-id="/assembly/oscal-metadata/revision/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='published']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision/published" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/revision/published"
             _metaschema-json-id="/assembly/oscal-metadata/revision/published"
             collapsible="no"
             as-type="dateTime-with-timezone"
             name="published"
             key="published"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:published"
             _step="published"
             _key="published"
             _key-ref="oscal-metadata:published"
             _using-name="published"
             _in-xml-name="published"
             _in-json-name="published"
             gi="published"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">published</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='published']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="dateTime-with-timezone" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='last-modified']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision/last-modified" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/revision/last-modified"
             _metaschema-json-id="/assembly/oscal-metadata/revision/last-modified"
             collapsible="no"
             as-type="dateTime-with-timezone"
             name="last-modified"
             key="last-modified"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:last-modified"
             _step="last-modified"
             _key="last-modified"
             _key-ref="oscal-metadata:last-modified"
             _using-name="last-modified"
             _in-xml-name="last-modified"
             _in-json-name="last-modified"
             gi="last-modified"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">last-modified</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='last-modified']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="dateTime-with-timezone" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='version']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision/version" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/revision/version"
             _metaschema-json-id="/assembly/oscal-metadata/revision/version"
             collapsible="no"
             as-type="string"
             name="version"
             key="version"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:version"
             _step="version"
             _key="version"
             _key-ref="oscal-metadata:version"
             _using-name="version"
             _in-xml-name="version"
             _in-json-name="version"
             gi="version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">version</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='version']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='oscal-version']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision/oscal-version" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/revision/oscal-version"
             _metaschema-json-id="/assembly/oscal-metadata/revision/oscal-version"
             collapsible="no"
             as-type="string"
             name="oscal-version"
             key="oscal-version"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:oscal-version"
             _step="oscal-version"
             _key="oscal-version"
             _key-ref="oscal-metadata:oscal-version"
             _using-name="oscal-version"
             _in-xml-name="oscal-version"
             _in-json-name="oscal-version"
             gi="oscal-version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">oscal-version</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:string[@key='oscal-version']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/revisions/revision/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='revisions']/j:array[@key='revisions']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='document-ids']/j:map"
                 priority="5">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/document-id" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/metadata/document-id"
             _metaschema-json-id="/assembly/oscal-metadata/metadata/document-ids"
             collapsible="no"
             as-type="string"
             name="document-id"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:document-id"
             _step="document-id"
             _key="document-ids"
             _key-ref="oscal-metadata:document-id"
             _using-name="document-id"
             _in-xml-name="document-id"
             _in-json-name="document-ids"
             gi="document-id">
         <xsl:apply-templates select="*[@key='scheme']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching profile/metadata/document-id-->
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='document-ids']/j:map"
                 mode="get-value-property">
      <value as-type="string" key="identifier" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:string[@key='title']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/role/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-metadata/role/title"
             _metaschema-json-id="/assembly/oscal-metadata/role/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:string[@key='short-name']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/role/short-name" -->
      <field _step="short-name"
             _key="short-name"
             _metaschema-xml-id="/assembly/oscal-metadata/role/short-name"
             _metaschema-json-id="/assembly/oscal-metadata/role/short-name"
             collapsible="no"
             as-type="string"
             name="short-name"
             key="short-name"
             _using-name="short-name"
             _in-xml-name="short-name"
             _in-json-name="short-name"
             gi="short-name"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">short-name</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:string[@key='short-name']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:string[@key='description']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/role/description" -->
      <field _step="description"
             _key="description"
             _metaschema-xml-id="/assembly/oscal-metadata/role/description"
             _metaschema-json-id="/assembly/oscal-metadata/role/description"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             _using-name="description"
             _in-xml-name="description"
             _in-json-name="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:string[@key='description']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/role/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='roles']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:string[@key='title']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-metadata/location/title"
             _metaschema-json-id="/assembly/oscal-metadata/location/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/address" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/location/address"
                _metaschema-json-id="/assembly/oscal-metadata/location/address"
                name="address"
                key="address"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:address"
                _step="address"
                _key="address"
                _key-ref="oscal-metadata:address"
                _using-name="address"
                _in-xml-name="address"
                _in-json-name="address"
                gi="address">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">address</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='type']"/>
         <xsl:apply-templates select="*[@key='addr-lines']"/>
         <xsl:apply-templates select="*[@key='city']"/>
         <xsl:apply-templates select="*[@key='state']"/>
         <xsl:apply-templates select="*[@key='postal-code']"/>
         <xsl:apply-templates select="*[@key='country']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:array[@key='addr-lines']/j:string"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/address/addr-line" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/address/addr-line"
             _metaschema-json-id="/assembly/oscal-metadata/address/addr-lines"
             collapsible="no"
             as-type="string"
             name="addr-line"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:addr-line"
             _step="addr-line"
             _key="addr-lines"
             _key-ref="oscal-metadata:addr-line"
             _using-name="addr-line"
             _in-xml-name="addr-line"
             _in-json-name="addr-lines"
             gi="addr-line"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:array[@key='addr-lines']/j:string"
                 mode="get-value-property"
                 priority="8">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='city']"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/address/city" -->
      <field _step="city"
             _key="city"
             _metaschema-xml-id="/assembly/oscal-metadata/address/city"
             _metaschema-json-id="/assembly/oscal-metadata/address/city"
             collapsible="no"
             as-type="string"
             name="city"
             key="city"
             _using-name="city"
             _in-xml-name="city"
             _in-json-name="city"
             gi="city"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">city</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='city']"
                 mode="get-value-property"
                 priority="7">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='state']"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/address/state" -->
      <field _step="state"
             _key="state"
             _metaschema-xml-id="/assembly/oscal-metadata/address/state"
             _metaschema-json-id="/assembly/oscal-metadata/address/state"
             collapsible="no"
             as-type="string"
             name="state"
             key="state"
             _using-name="state"
             _in-xml-name="state"
             _in-json-name="state"
             gi="state"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">state</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='state']"
                 mode="get-value-property"
                 priority="7">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='postal-code']"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/address/postal-code" -->
      <field _step="postal-code"
             _key="postal-code"
             _metaschema-xml-id="/assembly/oscal-metadata/address/postal-code"
             _metaschema-json-id="/assembly/oscal-metadata/address/postal-code"
             collapsible="no"
             as-type="string"
             name="postal-code"
             key="postal-code"
             _using-name="postal-code"
             _in-xml-name="postal-code"
             _in-json-name="postal-code"
             gi="postal-code"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">postal-code</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='postal-code']"
                 mode="get-value-property"
                 priority="7">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='country']"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/address/country" -->
      <field _step="country"
             _key="country"
             _metaschema-xml-id="/assembly/oscal-metadata/address/country"
             _metaschema-json-id="/assembly/oscal-metadata/address/country"
             collapsible="no"
             as-type="string"
             name="country"
             key="country"
             _using-name="country"
             _in-xml-name="country"
             _in-json-name="country"
             gi="country"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">country</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:map[@key='address']/j:string[@key='country']"
                 mode="get-value-property"
                 priority="7">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='email-addresses']/j:string"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/email-address" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/location/email-address"
             _metaschema-json-id="/assembly/oscal-metadata/location/email-addresses"
             collapsible="no"
             as-type="email"
             name="email-address"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:email-address"
             _step="email-address"
             _key="email-addresses"
             _key-ref="oscal-metadata:email-address"
             _using-name="email-address"
             _in-xml-name="email-address"
             _in-json-name="email-addresses"
             gi="email-address"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='email-addresses']/j:string"
                 mode="get-value-property"
                 priority="7">
      <value as-type="email" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='telephone-numbers']/j:map"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/telephone-number" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/location/telephone-number"
             _metaschema-json-id="/assembly/oscal-metadata/location/telephone-numbers"
             collapsible="no"
             as-type="string"
             name="telephone-number"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:telephone-number"
             _step="telephone-number"
             _key="telephone-numbers"
             _key-ref="oscal-metadata:telephone-number"
             _using-name="telephone-number"
             _in-xml-name="telephone-number"
             _in-json-name="telephone-numbers"
             gi="telephone-number">
         <xsl:apply-templates select="*[@key='type']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching profile/metadata/location/telephone-number-->
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='telephone-numbers']/j:map"
                 mode="get-value-property">
      <value as-type="string" key="number" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='urls']/j:string"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/url" -->
      <field _step="url"
             _key="urls"
             _metaschema-xml-id="/assembly/oscal-metadata/location/url"
             _metaschema-json-id="/assembly/oscal-metadata/location/urls"
             collapsible="no"
             as-type="uri"
             name="url"
             _using-name="url"
             _in-xml-name="url"
             _in-json-name="urls"
             gi="url"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='urls']/j:string"
                 mode="get-value-property"
                 priority="7">
      <value as-type="uri" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/location/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='locations']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:string[@key='name']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/name" -->
      <field _step="name"
             _key="name"
             _metaschema-xml-id="/assembly/oscal-metadata/party/name"
             _metaschema-json-id="/assembly/oscal-metadata/party/name"
             collapsible="no"
             as-type="string"
             name="name"
             key="name"
             _using-name="name"
             _in-xml-name="name"
             _in-json-name="name"
             gi="name"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">name</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:string[@key='name']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:string[@key='short-name']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/short-name" -->
      <field _step="short-name"
             _key="short-name"
             _metaschema-xml-id="/assembly/oscal-metadata/party/short-name"
             _metaschema-json-id="/assembly/oscal-metadata/party/short-name"
             collapsible="no"
             as-type="string"
             name="short-name"
             key="short-name"
             _using-name="short-name"
             _in-xml-name="short-name"
             _in-json-name="short-name"
             gi="short-name"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">short-name</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:string[@key='short-name']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='external-ids']/j:map"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/external-id" -->
      <field _step="external-id"
             _key="external-ids"
             _metaschema-xml-id="/assembly/oscal-metadata/party/external-id"
             _metaschema-json-id="/assembly/oscal-metadata/party/external-ids"
             collapsible="no"
             as-type="string"
             name="external-id"
             _using-name="external-id"
             _in-xml-name="external-id"
             _in-json-name="external-ids"
             gi="external-id">
         <xsl:apply-templates select="*[@key='scheme']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching profile/metadata/party/external-id-->
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='external-ids']/j:map"
                 mode="get-value-property">
      <value as-type="string" key="id" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='email-addresses']/j:string"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/email-address" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/party/email-address"
             _metaschema-json-id="/assembly/oscal-metadata/party/email-addresses"
             collapsible="no"
             as-type="email"
             name="email-address"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:email-address"
             _step="email-address"
             _key="email-addresses"
             _key-ref="oscal-metadata:email-address"
             _using-name="email-address"
             _in-xml-name="email-address"
             _in-json-name="email-addresses"
             gi="email-address"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='email-addresses']/j:string"
                 mode="get-value-property"
                 priority="7">
      <value as-type="email" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='telephone-numbers']/j:map"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/telephone-number" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/party/telephone-number"
             _metaschema-json-id="/assembly/oscal-metadata/party/telephone-numbers"
             collapsible="no"
             as-type="string"
             name="telephone-number"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:telephone-number"
             _step="telephone-number"
             _key="telephone-numbers"
             _key-ref="oscal-metadata:telephone-number"
             _using-name="telephone-number"
             _in-xml-name="telephone-number"
             _in-json-name="telephone-numbers"
             gi="telephone-number">
         <xsl:apply-templates select="*[@key='type']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching profile/metadata/party/telephone-number-->
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='telephone-numbers']/j:map"
                 mode="get-value-property">
      <value as-type="string" key="number" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/address" -->
      <assembly _metaschema-xml-id="/assembly/oscal-metadata/party/address"
                _metaschema-json-id="/assembly/oscal-metadata/party/addresses"
                name="address"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
                _key-name="oscal-metadata:address"
                _step="address"
                _key="addresses"
                _key-ref="oscal-metadata:address"
                _using-name="address"
                _in-xml-name="address"
                _in-json-name="addresses"
                gi="address">
         <xsl:apply-templates select="*[@key='type']"/>
         <xsl:apply-templates select="*[@key='addr-lines']"/>
         <xsl:apply-templates select="*[@key='city']"/>
         <xsl:apply-templates select="*[@key='state']"/>
         <xsl:apply-templates select="*[@key='postal-code']"/>
         <xsl:apply-templates select="*[@key='country']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:array[@key='addr-lines']/j:string"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/address/addr-line" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/address/addr-line"
             _metaschema-json-id="/assembly/oscal-metadata/address/addr-lines"
             collapsible="no"
             as-type="string"
             name="addr-line"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:addr-line"
             _step="addr-line"
             _key="addr-lines"
             _key-ref="oscal-metadata:addr-line"
             _using-name="addr-line"
             _in-xml-name="addr-line"
             _in-json-name="addr-lines"
             gi="addr-line"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:array[@key='addr-lines']/j:string"
                 mode="get-value-property"
                 priority="10">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='city']"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/address/city" -->
      <field _step="city"
             _key="city"
             _metaschema-xml-id="/assembly/oscal-metadata/address/city"
             _metaschema-json-id="/assembly/oscal-metadata/address/city"
             collapsible="no"
             as-type="string"
             name="city"
             key="city"
             _using-name="city"
             _in-xml-name="city"
             _in-json-name="city"
             gi="city"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">city</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='city']"
                 mode="get-value-property"
                 priority="9">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='state']"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/address/state" -->
      <field _step="state"
             _key="state"
             _metaschema-xml-id="/assembly/oscal-metadata/address/state"
             _metaschema-json-id="/assembly/oscal-metadata/address/state"
             collapsible="no"
             as-type="string"
             name="state"
             key="state"
             _using-name="state"
             _in-xml-name="state"
             _in-json-name="state"
             gi="state"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">state</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='state']"
                 mode="get-value-property"
                 priority="9">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='postal-code']"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/address/postal-code" -->
      <field _step="postal-code"
             _key="postal-code"
             _metaschema-xml-id="/assembly/oscal-metadata/address/postal-code"
             _metaschema-json-id="/assembly/oscal-metadata/address/postal-code"
             collapsible="no"
             as-type="string"
             name="postal-code"
             key="postal-code"
             _using-name="postal-code"
             _in-xml-name="postal-code"
             _in-json-name="postal-code"
             gi="postal-code"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">postal-code</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='postal-code']"
                 mode="get-value-property"
                 priority="9">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='country']"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/address/country" -->
      <field _step="country"
             _key="country"
             _metaschema-xml-id="/assembly/oscal-metadata/address/country"
             _metaschema-json-id="/assembly/oscal-metadata/address/country"
             collapsible="no"
             as-type="string"
             name="country"
             key="country"
             _using-name="country"
             _in-xml-name="country"
             _in-json-name="country"
             gi="country"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">country</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='addresses']/j:map/j:string[@key='country']"
                 mode="get-value-property"
                 priority="9">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='member-of-organizations']/j:string"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/party/member-of-organization" -->
      <field _step="member-of-organization"
             _key="member-of-organizations"
             _metaschema-xml-id="/assembly/oscal-metadata/party/member-of-organization"
             _metaschema-json-id="/assembly/oscal-metadata/party/member-of-organizations"
             collapsible="no"
             as-type="uuid"
             name="member-of-organization"
             _using-name="member-of-organization"
             _in-xml-name="member-of-organization"
             _in-json-name="member-of-organizations"
             gi="member-of-organization"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='parties']/j:map/j:array[@key='member-of-organizations']/j:string"
                 mode="get-value-property"
                 priority="7">
      <value as-type="uuid" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='responsible-parties']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/metadata/responsible-party/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='metadata']/j:array[@key='responsible-parties']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/import/include-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/import/include-controls"
                _metaschema-json-id="/assembly/oscal-profile/import/include-controls"
                name="select-control-by-id"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:select-control-by-id"
                _step="include-controls"
                _key="include-controls"
                _key-ref="oscal-profile:select-control-by-id"
                _using-name="include-controls"
                _in-xml-name="include-controls"
                _in-json-name="include-controls"
                gi="include-controls">
         <xsl:apply-templates select="*[@key='with-child-controls']"/>
         <xsl:apply-templates select="*[@key='with-ids']"/>
         <xsl:apply-templates select="*[@key='matching']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='with-ids']/j:string"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/import/include-controls/with-id" -->
      <field _step="with-id"
             _key="with-ids"
             _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-id"
             _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-ids"
             collapsible="no"
             as-type="token"
             name="with-id"
             _using-name="with-id"
             _in-xml-name="with-id"
             _in-json-name="with-ids"
             gi="with-id"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='with-ids']/j:string"
                 mode="get-value-property"
                 priority="9">
      <value as-type="token" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/import/include-controls/matching" -->
      <assembly as-type="empty"
                _step="matching"
                _key="matching"
                _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching"
                _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching"
                name="matching"
                _using-name="matching"
                _in-xml-name="matching"
                _in-json-name="matching"
                gi="matching">
         <xsl:apply-templates select="*[@key='pattern']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/import/exclude-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/import/exclude-controls"
                _metaschema-json-id="/assembly/oscal-profile/import/exclude-controls"
                name="select-control-by-id"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:select-control-by-id"
                _step="exclude-controls"
                _key="exclude-controls"
                _key-ref="oscal-profile:select-control-by-id"
                _using-name="exclude-controls"
                _in-xml-name="exclude-controls"
                _in-json-name="exclude-controls"
                gi="exclude-controls">
         <xsl:apply-templates select="*[@key='with-child-controls']"/>
         <xsl:apply-templates select="*[@key='with-ids']"/>
         <xsl:apply-templates select="*[@key='matching']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='with-ids']/j:string"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/import/exclude-controls/with-id" -->
      <field _step="with-id"
             _key="with-ids"
             _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-id"
             _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-ids"
             collapsible="no"
             as-type="token"
             name="with-id"
             _using-name="with-id"
             _in-xml-name="with-id"
             _in-json-name="with-ids"
             gi="with-id"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='with-ids']/j:string"
                 mode="get-value-property"
                 priority="8">
      <value as-type="token" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:array[@key='imports']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/import/exclude-controls/matching" -->
      <assembly as-type="empty"
                _step="matching"
                _key="matching"
                _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching"
                _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching"
                name="matching"
                _using-name="matching"
                _in-xml-name="matching"
                _in-json-name="matching"
                gi="matching">
         <xsl:apply-templates select="*[@key='pattern']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:string[@key='title']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-profile/group/title"
             _metaschema-json-id="/assembly/oscal-profile/group/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="12">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:string[@key='label']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/label" -->
      <field _step="label"
             _key="label"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/label"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter/label"
             collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             _using-name="label"
             _in-xml-name="label"
             _in-json-name="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:string[@key='label']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:string[@key='usage']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/usage" -->
      <field _step="usage"
             _key="usage"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/usage"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter/usage"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             _using-name="usage"
             _in-xml-name="usage"
             _in-json-name="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:string[@key='usage']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:string[@key='description']"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/constraint/description" -->
      <field _step="description"
             _key="description"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/description"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/description"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             _using-name="description"
             _in-xml-name="description"
             _in-json-name="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:string[@key='description']"
                 mode="get-value-property"
                 priority="12">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map"
                 priority="13">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/constraint/test" -->
      <assembly _step="test"
                _key="tests"
                _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/test"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/tests"
                name="test"
                _using-name="test"
                _in-xml-name="test"
                _in-json-name="tests"
                gi="test">
         <xsl:apply-templates select="*[@key='expression']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map/j:string[@key='expression']"
                 priority="14">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/constraint/test/expression" -->
      <field _step="expression"
             _key="expression"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/test/expression"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/tests/expression"
             collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             _using-name="expression"
             _in-xml-name="expression"
             _in-json-name="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map/j:string[@key='expression']"
                 mode="get-value-property"
                 priority="14">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <!-- matching markup-multiline value for profile/merge/custom//group/param/guideline-->
   <xsl:template priority="6"
                 match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:array[@key='guidelines']/j:map/j:string[@key='prose']">
      <field scope="local"
             _step="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _key="prose"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/p ul ol pre table h1 h2 h3 h4 h5 h6"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose"
             in-xml="UNWRAPPED"
             collapsible="no"
             as-type="markup-multiline"
             name="prose"
             key="prose"
             _using-name="prose"
             _in-xml-name="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _in-json-name="prose">
         <value as-type="markup-multiline"
                _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/p ul ol pre table h1 h2 h3 h4 h5 h6/PROSE"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose/PROSE"
                in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:map[@key='select']/j:array[@key='choice']/j:string"
                 priority="13">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/param/select/choice" -->
      <field _step="choice"
             _key="choice"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-selection/choice"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-selection/choice"
             collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             _using-name="choice"
             _in-xml-name="choice"
             _in-json-name="choice"
             gi="choice"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='params']/j:map/j:map[@key='select']/j:array[@key='choice']/j:string"
                 mode="get-value-property"
                 priority="13">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map//j:array[@key='parts']/j:map/j:string[@key='title']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group//part/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-catalog-common/part/title"
             _metaschema-json-id="/assembly/oscal-catalog-common/part/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map//j:array[@key='parts']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <!-- matching markup-multiline value for profile/merge/custom//group//part-->
   <xsl:template priority="5"
                 match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map//j:array[@key='parts']/j:map/j:string[@key='prose']">
      <field scope="local"
             _step="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _key="prose"
             _metaschema-xml-id="/assembly/oscal-catalog-common/part/p ul ol pre table h1 h2 h3 h4 h5 h6"
             _metaschema-json-id="/assembly/oscal-catalog-common/part/prose"
             in-xml="UNWRAPPED"
             collapsible="no"
             as-type="markup-multiline"
             name="prose"
             key="prose"
             _using-name="prose"
             _in-xml-name="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _in-json-name="prose">
         <value as-type="markup-multiline"
                _metaschema-xml-id="/assembly/oscal-catalog-common/part/p ul ol pre table h1 h2 h3 h4 h5 h6/PROSE"
                _metaschema-json-id="/assembly/oscal-catalog-common/part/prose/PROSE"
                in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map//j:array[@key='parts']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group//part/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map//j:array[@key='parts']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="12">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map"
                 priority="13">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/insert-controls/include-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/insert-controls/include-controls"
                _metaschema-json-id="/assembly/oscal-profile/insert-controls/include-controls"
                name="select-control-by-id"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:select-control-by-id"
                _step="include-controls"
                _key="include-controls"
                _key-ref="oscal-profile:select-control-by-id"
                _using-name="include-controls"
                _in-xml-name="include-controls"
                _in-json-name="include-controls"
                gi="include-controls">
         <xsl:apply-templates select="*[@key='with-child-controls']"/>
         <xsl:apply-templates select="*[@key='with-ids']"/>
         <xsl:apply-templates select="*[@key='matching']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='with-ids']/j:string"
                 priority="15">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/insert-controls/include-controls/with-id" -->
      <field _step="with-id"
             _key="with-ids"
             _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-id"
             _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-ids"
             collapsible="no"
             as-type="token"
             name="with-id"
             _using-name="with-id"
             _in-xml-name="with-id"
             _in-json-name="with-ids"
             gi="with-id"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='with-ids']/j:string"
                 mode="get-value-property"
                 priority="15">
      <value as-type="token" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map"
                 priority="15">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/insert-controls/include-controls/matching" -->
      <assembly as-type="empty"
                _step="matching"
                _key="matching"
                _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching"
                _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching"
                name="matching"
                _using-name="matching"
                _in-xml-name="matching"
                _in-json-name="matching"
                gi="matching">
         <xsl:apply-templates select="*[@key='pattern']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/insert-controls/exclude-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/insert-controls/exclude-controls"
                _metaschema-json-id="/assembly/oscal-profile/insert-controls/exclude-controls"
                name="select-control-by-id"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:select-control-by-id"
                _step="exclude-controls"
                _key="exclude-controls"
                _key-ref="oscal-profile:select-control-by-id"
                _using-name="exclude-controls"
                _in-xml-name="exclude-controls"
                _in-json-name="exclude-controls"
                gi="exclude-controls">
         <xsl:apply-templates select="*[@key='with-child-controls']"/>
         <xsl:apply-templates select="*[@key='with-ids']"/>
         <xsl:apply-templates select="*[@key='matching']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='with-ids']/j:string"
                 priority="14">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/insert-controls/exclude-controls/with-id" -->
      <field _step="with-id"
             _key="with-ids"
             _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-id"
             _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-ids"
             collapsible="no"
             as-type="token"
             name="with-id"
             _using-name="with-id"
             _in-xml-name="with-id"
             _in-json-name="with-ids"
             gi="with-id"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='with-ids']/j:string"
                 mode="get-value-property"
                 priority="14">
      <value as-type="token" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']//j:array[@key='groups']/j:map/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map"
                 priority="14">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom//group/insert-controls/exclude-controls/matching" -->
      <assembly as-type="empty"
                _step="matching"
                _key="matching"
                _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching"
                _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching"
                name="matching"
                _using-name="matching"
                _in-xml-name="matching"
                _in-json-name="matching"
                gi="matching">
         <xsl:apply-templates select="*[@key='pattern']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom/insert-controls/include-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/insert-controls/include-controls"
                _metaschema-json-id="/assembly/oscal-profile/insert-controls/include-controls"
                name="select-control-by-id"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:select-control-by-id"
                _step="include-controls"
                _key="include-controls"
                _key-ref="oscal-profile:select-control-by-id"
                _using-name="include-controls"
                _in-xml-name="include-controls"
                _in-json-name="include-controls"
                gi="include-controls">
         <xsl:apply-templates select="*[@key='with-child-controls']"/>
         <xsl:apply-templates select="*[@key='with-ids']"/>
         <xsl:apply-templates select="*[@key='matching']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='with-ids']/j:string"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom/insert-controls/include-controls/with-id" -->
      <field _step="with-id"
             _key="with-ids"
             _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-id"
             _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-ids"
             collapsible="no"
             as-type="token"
             name="with-id"
             _using-name="with-id"
             _in-xml-name="with-id"
             _in-json-name="with-ids"
             gi="with-id"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='with-ids']/j:string"
                 mode="get-value-property"
                 priority="12">
      <value as-type="token" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='include-controls']/j:map/j:array[@key='matching']/j:map"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom/insert-controls/include-controls/matching" -->
      <assembly as-type="empty"
                _step="matching"
                _key="matching"
                _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching"
                _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching"
                name="matching"
                _using-name="matching"
                _in-xml-name="matching"
                _in-json-name="matching"
                gi="matching">
         <xsl:apply-templates select="*[@key='pattern']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom/insert-controls/exclude-controls" -->
      <assembly _metaschema-xml-id="/assembly/oscal-profile/insert-controls/exclude-controls"
                _metaschema-json-id="/assembly/oscal-profile/insert-controls/exclude-controls"
                name="select-control-by-id"
                _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_profile_metaschema.xml"
                _key-name="oscal-profile:select-control-by-id"
                _step="exclude-controls"
                _key="exclude-controls"
                _key-ref="oscal-profile:select-control-by-id"
                _using-name="exclude-controls"
                _in-xml-name="exclude-controls"
                _in-json-name="exclude-controls"
                gi="exclude-controls">
         <xsl:apply-templates select="*[@key='with-child-controls']"/>
         <xsl:apply-templates select="*[@key='with-ids']"/>
         <xsl:apply-templates select="*[@key='matching']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='with-ids']/j:string"
                 priority="11">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom/insert-controls/exclude-controls/with-id" -->
      <field _step="with-id"
             _key="with-ids"
             _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/with-id"
             _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/with-ids"
             collapsible="no"
             as-type="token"
             name="with-id"
             _using-name="with-id"
             _in-xml-name="with-id"
             _in-json-name="with-ids"
             gi="with-id"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='with-ids']/j:string"
                 mode="get-value-property"
                 priority="11">
      <value as-type="token" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='merge']/j:map[@key='custom']/j:array[@key='insert-controls']/j:map/j:array[@key='exclude-controls']/j:map/j:array[@key='matching']/j:map"
                 priority="11">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/merge/custom/insert-controls/exclude-controls/matching" -->
      <assembly as-type="empty"
                _step="matching"
                _key="matching"
                _metaschema-xml-id="/assembly/oscal-profile/select-control-by-id/matching"
                _metaschema-json-id="/assembly/oscal-profile/select-control-by-id/matching"
                name="matching"
                _using-name="matching"
                _in-xml-name="matching"
                _in-json-name="matching"
                gi="matching">
         <xsl:apply-templates select="*[@key='pattern']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map"
                 priority="5">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter" -->
      <assembly _step="set-parameter"
                _key="set-parameters"
                _metaschema-xml-id="/assembly/oscal-profile/modify/set-parameter"
                _metaschema-json-id="/assembly/oscal-profile/modify/set-parameters"
                name="set-parameter"
                _using-name="set-parameter"
                _in-xml-name="set-parameter"
                _in-json-name="set-parameters"
                gi="set-parameter">
         <xsl:apply-templates select="*[@key='param-id']"/>
         <xsl:apply-templates select="*[@key='class']"/>
         <xsl:apply-templates select="*[@key='depends-on']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
         <xsl:apply-templates select="*[@key='label']"/>
         <xsl:apply-templates select="*[@key='usage']"/>
         <xsl:apply-templates select="*[@key='constraints']"/>
         <xsl:apply-templates select="*[@key='guidelines']"/>
         <xsl:apply-templates select="*[@key='values']"/>
         <xsl:apply-templates select="*[@key='select']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='label']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/label" -->
      <field _step="label"
             _key="label"
             _metaschema-xml-id="/assembly/oscal-profile/modify/set-parameter/label"
             _metaschema-json-id="/assembly/oscal-profile/modify/set-parameters/label"
             collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             _using-name="label"
             _in-xml-name="label"
             _in-json-name="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='label']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='usage']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/usage" -->
      <field _step="usage"
             _key="usage"
             _metaschema-xml-id="/assembly/oscal-profile/modify/set-parameter/usage"
             _metaschema-json-id="/assembly/oscal-profile/modify/set-parameters/usage"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             _using-name="usage"
             _in-xml-name="usage"
             _in-json-name="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:string[@key='usage']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='constraints']/j:map/j:string[@key='description']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/constraint/description" -->
      <field _step="description"
             _key="description"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/description"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/description"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             _using-name="description"
             _in-xml-name="description"
             _in-json-name="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='constraints']/j:map/j:string[@key='description']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/constraint/test" -->
      <assembly _step="test"
                _key="tests"
                _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/test"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/tests"
                name="test"
                _using-name="test"
                _in-xml-name="test"
                _in-json-name="tests"
                gi="test">
         <xsl:apply-templates select="*[@key='expression']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map/j:string[@key='expression']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/constraint/test/expression" -->
      <field _step="expression"
             _key="expression"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/test/expression"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/tests/expression"
             collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             _using-name="expression"
             _in-xml-name="expression"
             _in-json-name="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map/j:string[@key='expression']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <!-- matching markup-multiline value for profile/modify/set-parameter/guideline-->
   <xsl:template priority="4"
                 match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:array[@key='guidelines']/j:map/j:string[@key='prose']">
      <field scope="local"
             _step="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _key="prose"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/p ul ol pre table h1 h2 h3 h4 h5 h6"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose"
             in-xml="UNWRAPPED"
             collapsible="no"
             as-type="markup-multiline"
             name="prose"
             key="prose"
             _using-name="prose"
             _in-xml-name="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _in-json-name="prose">
         <value as-type="markup-multiline"
                _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/p ul ol pre table h1 h2 h3 h4 h5 h6/PROSE"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose/PROSE"
                in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:map[@key='select']/j:array[@key='choice']/j:string"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/set-parameter/select/choice" -->
      <field _step="choice"
             _key="choice"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-selection/choice"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-selection/choice"
             collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             _using-name="choice"
             _in-xml-name="choice"
             _in-json-name="choice"
             gi="choice"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='set-parameters']/j:map/j:map[@key='select']/j:array[@key='choice']/j:string"
                 mode="get-value-property"
                 priority="9">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:string[@key='title']"
                 priority="8">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-profile/add/title"
             _metaschema-json-id="/assembly/oscal-profile/add/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="8">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="12">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:string[@key='label']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/label" -->
      <field _step="label"
             _key="label"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/label"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter/label"
             collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             _using-name="label"
             _in-xml-name="label"
             _in-json-name="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:string[@key='label']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:string[@key='usage']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/usage" -->
      <field _step="usage"
             _key="usage"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter/usage"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter/usage"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             _using-name="usage"
             _in-xml-name="usage"
             _in-json-name="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:string[@key='usage']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:string[@key='description']"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/constraint/description" -->
      <field _step="description"
             _key="description"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/description"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/description"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             _using-name="description"
             _in-xml-name="description"
             _in-json-name="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:string[@key='description']"
                 mode="get-value-property"
                 priority="12">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map"
                 priority="13">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/constraint/test" -->
      <assembly _step="test"
                _key="tests"
                _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/test"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/tests"
                name="test"
                _using-name="test"
                _in-xml-name="test"
                _in-json-name="tests"
                gi="test">
         <xsl:apply-templates select="*[@key='expression']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map/j:string[@key='expression']"
                 priority="14">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/constraint/test/expression" -->
      <field _step="expression"
             _key="expression"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-constraint/test/expression"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-constraint/tests/expression"
             collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             _using-name="expression"
             _in-xml-name="expression"
             _in-json-name="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='constraints']/j:map/j:array[@key='tests']/j:map/j:string[@key='expression']"
                 mode="get-value-property"
                 priority="14">
      <value as-type="string" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <!-- matching markup-multiline value for profile/modify/alter/add/param/guideline-->
   <xsl:template priority="6"
                 match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:array[@key='guidelines']/j:map/j:string[@key='prose']">
      <field scope="local"
             _step="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _key="prose"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/p ul ol pre table h1 h2 h3 h4 h5 h6"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose"
             in-xml="UNWRAPPED"
             collapsible="no"
             as-type="markup-multiline"
             name="prose"
             key="prose"
             _using-name="prose"
             _in-xml-name="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _in-json-name="prose">
         <value as-type="markup-multiline"
                _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/p ul ol pre table h1 h2 h3 h4 h5 h6/PROSE"
                _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose/PROSE"
                in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:map[@key='select']/j:array[@key='choice']/j:string"
                 priority="13">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/param/select/choice" -->
      <field _step="choice"
             _key="choice"
             _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-selection/choice"
             _metaschema-json-id="/assembly/oscal-catalog-common/parameter-selection/choice"
             collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             _using-name="choice"
             _in-xml-name="choice"
             _in-json-name="choice"
             gi="choice"
             in-json="SCALAR">
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='params']/j:map/j:map[@key='select']/j:array[@key='choice']/j:string"
                 mode="get-value-property"
                 priority="13">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map//j:array[@key='parts']/j:map/j:string[@key='title']"
                 priority="10">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add//part/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-catalog-common/part/title"
             _metaschema-json-id="/assembly/oscal-catalog-common/part/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map//j:array[@key='parts']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="10">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <!-- matching markup-multiline value for profile/modify/alter/add//part-->
   <xsl:template priority="5"
                 match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map//j:array[@key='parts']/j:map/j:string[@key='prose']">
      <field scope="local"
             _step="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _key="prose"
             _metaschema-xml-id="/assembly/oscal-catalog-common/part/p ul ol pre table h1 h2 h3 h4 h5 h6"
             _metaschema-json-id="/assembly/oscal-catalog-common/part/prose"
             in-xml="UNWRAPPED"
             collapsible="no"
             as-type="markup-multiline"
             name="prose"
             key="prose"
             _using-name="prose"
             _in-xml-name="p ul ol pre table h1 h2 h3 h4 h5 h6"
             _in-json-name="prose">
         <value as-type="markup-multiline"
                _metaschema-xml-id="/assembly/oscal-catalog-common/part/p ul ol pre table h1 h2 h3 h4 h5 h6/PROSE"
                _metaschema-json-id="/assembly/oscal-catalog-common/part/prose/PROSE"
                in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map//j:array[@key='parts']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="12">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/modify/alter/add//part/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='modify']/j:array[@key='alters']/j:map/j:array[@key='adds']/j:map//j:array[@key='parts']/j:map/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="12">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map"
                 priority="5">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource" -->
      <assembly _step="resource"
                _key="resources"
                _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource"
                _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources"
                name="resource"
                _using-name="resource"
                _in-xml-name="resource"
                _in-json-name="resources"
                gi="resource">
         <xsl:apply-templates select="*[@key='uuid']"/>
         <xsl:apply-templates select="*[@key='title']"/>
         <xsl:apply-templates select="*[@key='description']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='document-ids']"/>
         <xsl:apply-templates select="*[@key='citation']"/>
         <xsl:apply-templates select="*[@key='rlinks']"/>
         <xsl:apply-templates select="*[@key='base64']"/>
         <xsl:apply-templates select="*[@key='remarks']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:string[@key='title']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/title" -->
      <field _step="title"
             _key="title"
             _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/title"
             _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/title"
             collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             _using-name="title"
             _in-xml-name="title"
             _in-json-name="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:string[@key='title']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:string[@key='description']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/description" -->
      <field _step="description"
             _key="description"
             _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/description"
             _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/description"
             in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             _using-name="description"
             _in-xml-name="description"
             _in-json-name="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:string[@key='description']"
                 mode="get-value-property"
                 priority="6">
      <value as-type="markup-multiline" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='document-ids']/j:map"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/document-id" -->
      <field _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/document-id"
             _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/document-ids"
             collapsible="no"
             as-type="string"
             name="document-id"
             _base-uri="file:/mnt/c/Users/davidwal/git/github/david-waltermire-nist/OSCAL/src/metaschema/oscal_metadata_metaschema.xml"
             _key-name="oscal-metadata:document-id"
             _step="document-id"
             _key="document-ids"
             _key-ref="oscal-metadata:document-id"
             _using-name="document-id"
             _in-xml-name="document-id"
             _in-json-name="document-ids"
             gi="document-id">
         <xsl:apply-templates select="*[@key='scheme']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching profile/back-matter/resource/document-id-->
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='document-ids']/j:map"
                 mode="get-value-property">
      <value as-type="string" key="identifier" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='citation']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/citation" -->
      <assembly _step="citation"
                _key="citation"
                _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/citation"
                _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/citation"
                name="citation"
                key="citation"
                _using-name="citation"
                _in-xml-name="citation"
                _in-json-name="citation"
                gi="citation">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">citation</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='text']"/>
         <xsl:apply-templates select="*[@key='props']"/>
         <xsl:apply-templates select="*[@key='links']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='citation']/j:string[@key='text']"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/citation/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/citation/text"
             _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/citation/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='citation']/j:string[@key='text']"
                 mode="get-value-property"
                 priority="7">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='citation']/j:array[@key='links']/j:map/j:string[@key='text']"
                 priority="9">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/citation/link/text" -->
      <field _step="text"
             _key="text"
             _metaschema-xml-id="/assembly/oscal-metadata/link/text"
             _metaschema-json-id="/assembly/oscal-metadata/link/text"
             collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             _using-name="text"
             _in-xml-name="text"
             _in-json-name="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='citation']/j:array[@key='links']/j:map/j:string[@key='text']"
                 mode="get-value-property"
                 priority="9">
      <value as-type="markup-line" in-json="string">
         <xsl:value-of select="."/>
      </value>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:array[@key='rlinks']/j:map"
                 priority="7">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/rlink" -->
      <assembly _step="rlink"
                _key="rlinks"
                _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/rlink"
                _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/rlinks"
                name="rlink"
                _using-name="rlink"
                _in-xml-name="rlink"
                _in-json-name="rlinks"
                gi="rlink">
         <xsl:apply-templates select="*[@key='href']"/>
         <xsl:apply-templates select="*[@key='media-type']"/>
         <xsl:apply-templates select="*[@key='hashes']"/>
      </assembly>
   </xsl:template>
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='base64']"
                 priority="6">
      <xsl:param name="with-key" select="true()"/>
      <!-- XML match="profile/back-matter/resource/base64" -->
      <field _step="base64"
             _key="base64"
             _metaschema-xml-id="/assembly/oscal-metadata/back-matter/resource/base64"
             _metaschema-json-id="/assembly/oscal-metadata/back-matter/resources/base64"
             collapsible="no"
             as-type="base64Binary"
             name="base64"
             key="base64"
             _using-name="base64"
             _in-xml-name="base64"
             _in-json-name="base64"
             gi="base64">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">base64</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="*[@key='filename']"/>
         <xsl:apply-templates select="*[@key='media-type']"/>
         <xsl:apply-templates select="." mode="get-value-property"/>
      </field>
   </xsl:template>
   <!-- matching profile/back-matter/resource/base64-->
   <xsl:template match="j:map[@key='profile']/j:map[@key='back-matter']/j:array[@key='resources']/j:map/j:map[@key='base64']"
                 mode="get-value-property">
      <value as-type="base64Binary" key="value" in-json="string">
         <xsl:apply-templates mode="keep-value-property"/>
      </value>
   </xsl:template>
   <!-- by default, fields traverse their properties to find a value -->
   <xsl:template match="*" mode="get-value-property">
      <xsl:apply-templates mode="keep-value-property"/>
   </xsl:template>
   <xsl:template match="*" mode="keep-value-property">
      <xsl:value-of select="."/>
   </xsl:template>
   <!-- JSON to XML conversion: Markdown to markup inferencing -->
   <xsl:template mode="cast-md"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 match="value[@as-type=('markup-line')]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <!-- if this is valid only a single p comes back but who can tell? -->
         <xsl:call-template name="parse-markdown-line">
            <xsl:with-param name="markdown-str" select="string(.)"/>
         </xsl:call-template>
      </xsl:copy>
   </xsl:template>
   <xsl:template mode="cast-md"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 match="value[@as-type=('markup-multiline')]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="parse-markdown">
            <xsl:with-param name="markdown-str" select="string(.)"/>
         </xsl:call-template>
      </xsl:copy>
   </xsl:template>
   <xsl:template name="parse-markdown-line">
      <xsl:param name="markdown-str" as="xs:string" required="yes"/>
      <xsl:variable name="str-as-textnode">
         <xsl:value-of select="string($markdown-str) =&gt; replace('\\n','&#xA;')"/>
      </xsl:variable>
      <xsl:apply-templates select="$str-as-textnode" mode="infer-inlines"/>
   </xsl:template>
   <xsl:template name="parse-markdown">
        
<!-- First, group according to ``` delimiters btw codeblocks and not
        within codeblock, escape & and < (only)
        within not-codeblock split lines at \n\s*\n
        
        -->
        <!-- $str may be passed in, or we can process the current node -->
      <xsl:param name="markdown-str" as="xs:string" required="yes"/>
      <xsl:variable name="str" select="string($markdown-str) =&gt; replace('\\n','&#xA;')"/>
      <xsl:variable name="starts-with-code" select="matches($str,'^```')"/>
      <!-- Blocks is split between code blocks and everything else -->
      <xsl:variable name="blocks">
         <xsl:for-each-group select="tokenize($str, '\n')"
                             group-starting-with=".[matches(., '^```')]">
                <!-- odd groups are code if the first one has code, otherwise evens -->
            <xsl:variable name="this-is-code"
                          select="not((position() mod 2) + number($starts-with-code))"/>
            <p><!-- Adding an attribute flag when this is a code block, code='code' -->
               <xsl:if test="$this-is-code">
                  <xsl:variable name="language"
                                expand-text="true"
                                select="(replace(.,'^```','') ! normalize-space(.))[matches(.,'\S')]"/>
                  <xsl:attribute name="code" select="if ($language) then $language else 'code'"/>
               </xsl:if>
               <xsl:value-of select="string-join(current-group()[not(matches(., '^```'))],'&#xA;')"/>
            </p>
         </xsl:for-each-group>
      </xsl:variable>
      <xsl:variable name="rough-blocks">
         <xsl:apply-templates select="$blocks" mode="parse-block"/>
      </xsl:variable>
      <!-- for debugging <xsl:copy-of select="$rough-blocks"/> -->
      <xsl:variable name="flat-structures">
         <xsl:apply-templates select="$rough-blocks" mode="mark-structures"/>
      </xsl:variable>
      <!-- for debugging <xsl:copy-of select="$flat-structures"/>-->
      <xsl:variable name="nested-structures">
         <xsl:apply-templates select="$flat-structures" mode="build-structures"/>
      </xsl:variable>
      <!-- for debugging <xsl:copy-of select="$nested-structures"/>-->
      <xsl:variable name="fully-marked">
         <xsl:apply-templates select="$nested-structures" mode="infer-inlines"/>
      </xsl:variable>
      <xsl:sequence select="$fully-marked"/>
   </xsl:template>
   <xsl:template match="*" mode="copy mark-structures build-structures infer-inlines">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template mode="parse-block"
                 priority="1"
                 match="p[exists(@code)]"
                 expand-text="true">
      <pre>
         <xsl:for-each select="@code[not(.='code')]">
            <xsl:attribute name="class">language-{.}</xsl:attribute>
         </xsl:for-each>
         <xsl:value-of select="string(.)"/>
      </pre>
   </xsl:template>
   <xsl:template mode="parse-block" match="p" expand-text="true">
      <xsl:for-each select="tokenize(string(.),'\n\s*\n')[normalize-space(.)]">
         <p>
                <!-- trimming leading and trailing whitespace here -->
            <xsl:value-of select="replace(.,'(^\s*\n|\s+$)','')"/>
         </p>
      </xsl:for-each>
   </xsl:template>
   <xsl:function name="m:is-table-row-demarcator" as="xs:boolean">
      <xsl:param name="line" as="xs:string"/>
      <xsl:sequence select="matches($line,'^[\|\-:\s]+$')"/>
   </xsl:function>
   <xsl:function name="m:is-table" as="xs:boolean">
      <xsl:param name="line" as="element(p)"/>
      <xsl:variable name="lines" select="tokenize($line,'\s*\n')[matches(.,'\S')]"/>
      <xsl:sequence select="(every $l in $lines satisfies matches($l,'^\|')) and (some $l in $lines satisfies m:is-table-row-demarcator($l))"/>
   </xsl:function>
   <xsl:template mode="mark-structures" priority="5" match="p[m:is-table(.)]">
      <xsl:variable name="rows">
         <xsl:for-each select="tokenize(string(.),'\s*\n')">
            <tr>
               <xsl:value-of select="."/>
            </tr>
         </xsl:for-each>
      </xsl:variable>
      <table>
         <xsl:apply-templates select="$rows/tr" mode="make-row"/>
      </table>
   </xsl:template>
   <xsl:template match="tr[m:is-table-row-demarcator(string(.))]"
                 priority="5"
                 mode="make-row"/>
   <xsl:template match="tr" mode="make-row">
      <tr>
         <xsl:for-each select="tokenize(string(.), '\s*\|\s*')[not(position() = (1,last())) ]">
            <td>
               <xsl:value-of select="."/>
            </td>
         </xsl:for-each>
      </tr>
   </xsl:template>
   <xsl:template match="tr[some $f in (following-sibling::tr) satisfies m:is-table-row-demarcator(string($f))]"
                 mode="make-row">
      <tr>
         <xsl:for-each select="tokenize(string(.), '\s*\|\s*')[not(position() = (1,last())) ]">
            <th>
               <xsl:value-of select="."/>
            </th>
         </xsl:for-each>
      </tr>
   </xsl:template>
   <xsl:template mode="mark-structures" match="p[matches(.,'^#')]">
        <!-- 's' flag is dot-matches-all, so \n does not impede -->
      <p header-level="{ replace(.,'[^#].*$','','s') ! string-length(.) }">
         <xsl:value-of select="replace(.,'^#+\s*','') ! replace(.,'\s+$','')"/>
      </p>
   </xsl:template>
   <xsl:variable name="li-regex" as="xs:string">^\s*(\*|\d+\.)\s</xsl:variable>
   <xsl:template mode="mark-structures" match="p[matches(.,$li-regex)]">
      <list>
         <xsl:for-each-group group-starting-with=".[matches(.,$li-regex)]"
                             select="tokenize(., '\n')">
            <li level="{ replace(.,'\S.*$','') ! floor(string-length(.) div 2)}"
                type="{ if (matches(.,'\s*\d')) then 'ol' else 'ul' }">
               <xsl:for-each select="current-group()[normalize-space(.)]">
                  <xsl:if test="not(position() eq 1)">
                     <br/>
                  </xsl:if>
                  <xsl:value-of select="replace(., $li-regex, '')"/>
               </xsl:for-each>
            </li>
         </xsl:for-each-group>
      </list>
   </xsl:template>
   <xsl:template mode="build-structures" match="p[@header-level]">
      <xsl:variable name="level" select="(@header-level[6 &gt;= .],6)[1]"/>
      <xsl:element name="h{$level}"
                   namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
         <xsl:value-of select="."/>
      </xsl:element>
   </xsl:template>
   <xsl:template mode="build-structures" match="list" name="nest-lists">
        <!-- Starting at level 0 and grouping  -->
        <!--        -->
      <xsl:param name="level" select="0"/>
      <xsl:param name="group" select="li"/>
      <xsl:variable name="this-type" select="$group[1]/@type"/>
      <!--first, splitting ul from ol groups -->
      <!--<xsl:for-each-group select="$group" group-starting-with="*[@level = $level and not(@type = preceding-sibling::*[1]/@type)]">-->
      <!--<xsl:for-each-group select="$group" group-starting-with="*[@level = $level]">-->
      <xsl:element name="{ $group[1]/@type }"
                   namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
         <xsl:for-each-group select="$group"
                             group-starting-with="li[(@level = $level) or not(@type = preceding-sibling::*[1]/@type)]">
            <xsl:choose>
               <xsl:when test="@level = $level (: checking first item in group :)">
                  <li>
                            <!--<xsl:copy-of select="@level"/>-->
                     <xsl:apply-templates mode="copy"/>
                     <xsl:if test="current-group()/@level &gt; $level (: go deeper? :)">
                        <xsl:call-template name="nest-lists">
                           <xsl:with-param name="level" select="$level + 1"/>
                           <xsl:with-param name="group" select="current-group()[@level &gt; $level]"/>
                        </xsl:call-template>
                     </xsl:if>
                  </li>
               </xsl:when>
               <xsl:otherwise>
                        <!-- fallback for skipping levels -->
                  <li>
                                <!-- level="{$level}"-->
                     <xsl:call-template name="nest-lists">
                        <xsl:with-param name="level" select="$level + 1"/>
                        <xsl:with-param name="group" select="current-group()"/>
                     </xsl:call-template>
                  </li>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each-group>
      </xsl:element>
      <!--</xsl:for-each-group>-->
   </xsl:template>
   <xsl:template match="pre//text()" mode="infer-inlines">
      <xsl:copy-of select="."/>
   </xsl:template>
   <xsl:template match="text()" mode="infer-inlines">
      <xsl:variable name="markup">
         <xsl:apply-templates select="$tag-replacements/rules" mode="replacements">
            <xsl:with-param name="original" tunnel="yes" as="text()" select="."/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:try select="parse-xml-fragment($markup)">
         <xsl:catch select="."/>
      </xsl:try>
   </xsl:template>
   <xsl:template match="rules" as="xs:string" mode="replacements">

        <!-- Original is only provided for processing text nodes -->
      <xsl:param name="original" as="text()?" tunnel="yes"/>
      <xsl:param name="starting" as="xs:string" select="string($original)"/>
      <xsl:iterate select="*">
         <xsl:param name="original" select="$original" as="text()?"/>
         <xsl:param name="str" select="$starting" as="xs:string"/>
         <xsl:on-completion select="$str"/>
         <xsl:next-iteration>
            <xsl:with-param name="str">
               <xsl:apply-templates select="." mode="replacements">
                  <xsl:with-param name="str" select="$str"/>
               </xsl:apply-templates>
            </xsl:with-param>
         </xsl:next-iteration>
      </xsl:iterate>
   </xsl:template>
   <xsl:template match="replace" expand-text="true" mode="replacements">
      <xsl:param name="str" as="xs:string"/>
      <!--<xsl:value-of>replace({$str},{@match},{string(.)})</xsl:value-of>-->
      <!-- 's' sets dot-matches-all       -->
      <xsl:sequence select="replace($str, @match, string(.),'s')"/>
      <!--<xsl:copy-of select="."/>-->
   </xsl:template>
   <xsl:variable name="tag-replacements">
      <rules>
            <!-- first, literal replacements -->
         <replace match="&amp;">&amp;amp;</replace>
         <replace match="&lt;">&amp;lt;</replace>
         <!-- next, explicit escape sequences -->
         <replace match="\\&#34;">&amp;quot;</replace>
         <!--<replace match="\\&#39;">&amp;apos;</replace>-->
         <replace match="\\\*">&amp;#x2A;</replace>
         <replace match="\\`">&amp;#x60;</replace>
         <replace match="\\~">&amp;#x7E;</replace>
         <replace match="\\^">&amp;#x5E;</replace>
         <!-- then, replacements based on $tag-specification -->
         <xsl:for-each select="$tag-specification/*">
            <xsl:variable name="match-expr">
               <xsl:apply-templates select="." mode="write-match"/>
            </xsl:variable>
            <xsl:variable name="repl-expr">
               <xsl:apply-templates select="." mode="write-replace"/>
            </xsl:variable>
            <replace match="{$match-expr}">
               <xsl:sequence select="$repl-expr"/>
            </replace>
         </xsl:for-each>
      </rules>
   </xsl:variable>
   <xsl:variable name="tag-specification" as="element()">
      <tag-spec>
            <!-- The XML notation represents the substitution by showing both delimiters and tags  -->
            <!-- Note that text contents are regex notation for matching so * must be \* -->
         <q>"<text/>"</q>
         <img alt="!\[{{$noclosebracket}}\]" src="\({{$nocloseparen}}\)"/>
         <insert>\{\{\s*insert: <type/>,\s*<id-ref/>\s*\}\}</insert>
         <a href="\[{{$noclosebracket}}\]">\(<text not="\)"/>\)</a>
         <code>`<text/>`</code>
         <strong>
            <em>\*\*\*<text/>\*\*\*</em>
         </strong>
         <strong>\*\*<text/>\*\*</strong>
         <em>\*<text/>\*</em>
         <sub>~<text/>~</sub>
         <sup>\^<text/>\^</sup>
      </tag-spec>
   </xsl:variable>
   <xsl:template match="*" mode="write-match">
      <xsl:apply-templates select="@*, node()" mode="write-match"/>
   </xsl:template>
   <xsl:template match="@*[matches(., '\{\$text\}')]" mode="write-match">
      <xsl:value-of select="replace(., '\{\$text\}', '(.*)?')"/>
   </xsl:template>
   <xsl:template match="@*[matches(., '\{\$nocloseparen\}')]" mode="write-match">
      <xsl:value-of select="replace(., '\{\$nocloseparen\}', '([^\\(]*)?')"/>
   </xsl:template>
   <xsl:template match="@*[matches(., '\{\$noclosebracket\}')]" mode="write-match">
      <xsl:value-of select="replace(., '\{\$noclosebracket\}', '([^\\[]*)?')"/>
   </xsl:template>
   <xsl:template match="text" mode="write-match">
      <xsl:text>(.*?)</xsl:text>
   </xsl:template>
   <xsl:template match="insert/type | insert/id-ref" mode="write-match">
      <xsl:text>(\i\c*?)</xsl:text>
   </xsl:template>
   <xsl:template match="text[@not]" mode="write-match">
      <xsl:text expand-text="true">([^{ @not }]*?)</xsl:text>
   </xsl:template>
   <xsl:template match="*" mode="write-replace">
        <!-- we can write an open/close pair even for an empty element b/c
             it will be parsed and serialized -->
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="local-name()"/>
      <!-- forcing the namespace! -->
      <xsl:text> xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"</xsl:text>
      <!-- coercing the order to ensure correct formation of regegex       -->
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates mode="#current" select="*"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="local-name()"/>
      <xsl:text>&gt;</xsl:text>
   </xsl:template>
   <xsl:template match="text" mode="write-replace">
      <xsl:text>$1</xsl:text>
   </xsl:template>
   <xsl:template match="insert" mode="write-replace">
        <!-- we can write an open/close pair even for an empty element b/c
             it will be parsed and serialized -->
      <xsl:text>&lt;insert xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"</xsl:text>
      <!-- coercing the order to ensure correct formation of regegex       -->
      <xsl:apply-templates mode="#current" select="*"/>
      <xsl:text>/&gt;</xsl:text>
   </xsl:template>
   <xsl:template match="insert/type" mode="write-replace">
      <xsl:text> type='$1'</xsl:text>
   </xsl:template>
   <xsl:template match="insert/id-ref" mode="write-replace">
      <xsl:text> id-ref='$2'</xsl:text>
   </xsl:template>
   <xsl:template match="a/@href" mode="write-replace">
      <xsl:text> href='$2'</xsl:text>
      <!--<xsl:value-of select="replace(.,'\{\$insert\}','\$2')"/>-->
   </xsl:template>
   <xsl:template match="img/@alt" mode="write-replace">
      <xsl:text> alt='$1'</xsl:text>
      <!--<xsl:value-of select="replace(.,'\{\$insert\}','\$2')"/>-->
   </xsl:template>
   <xsl:template match="img/@src" mode="write-replace">
      <xsl:text> src='$2'</xsl:text>
      <!--<xsl:value-of select="replace(.,'\{\$insert\}','\$2')"/>-->
   </xsl:template>
   <xsl:variable name="line-example" xml:space="preserve"> { insertion } </xsl:variable>
   <!-- JSON to XML conversion: Supermodel serialization as XML -->
   <xsl:strip-space xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                    elements="s:*"/>
   <xsl:preserve-space xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                       elements="s:flag s:value"/>
   <xsl:mode xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
             name="write-xml"/>
   <xsl:template xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 match="s:*[exists(@gi)]"
                 mode="write-xml">
      <xsl:element name="{@gi}" namespace="http://csrc.nist.gov/ns/oscal/1.0">
            <!-- putting flags first in case of disarranged inputs -->
         <xsl:apply-templates select="s:flag, (* except s:flag)" mode="write-xml"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 match="s:value[@as-type=('markup-line','markup-multiline')]"
                 mode="write-xml">
      <xsl:apply-templates mode="cast-prose"/>
   </xsl:template>
   <xsl:template xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 match="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates select="." mode="cast-prose"/>
   </xsl:template>
   <xsl:template xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 priority="2"
                 match="s:flag"
                 mode="write-xml">
      <xsl:attribute name="{@gi}">
         <xsl:value-of select="."/>
      </xsl:attribute>
   </xsl:template>
   <xsl:template xmlns:s="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 match="*"
                 mode="cast-prose">
      <xsl:element name="{local-name()}" namespace="http://csrc.nist.gov/ns/oscal/1.0">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>