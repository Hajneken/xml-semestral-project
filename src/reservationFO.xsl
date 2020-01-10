<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="urn:x-zemanec:schemas:reservation:1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <fo:root>
            <!-- Definice layoutu stránky -->
            <fo:layout-master-set>
                <!-- Rozměry stránky a její okraje -->
                <fo:simple-page-master master-name="page" page-width="210mm" margin="1in">
                    <!-- Tiskové zrcadlo - oblast pro samotný obsah stránky -->
                    <fo:region-body margin-bottom="15mm" margin-top="15mm"/>
                    <!-- Oblast pro patu stránky -->
                    <fo:region-before extent="20mm"/>
                    <fo:region-after extent="10mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <!-- Definice obsahu stránky -->
            <fo:page-sequence master-reference="page">
                <!-- Společný obsah všech stránek v patě stránky -->
                <fo:static-content flow-name="xsl-region-before" color="grey" font-size="10pt">
                    <fo:block text-align-last="right" text-decoration="underline">
                        <fo:basic-link internal-destination="start">Evidence
                            rezervací</fo:basic-link>
                    </fo:block>
                </fo:static-content>

                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center" color="grey" font-size="9pt">
                        <xsl:text>Strana </xsl:text>
                        <fo:page-number/>
                    </fo:block>
                </fo:static-content>
                <!-- Samotný text dokumentu -->
                <fo:flow flow-name="xsl-region-body">
                    <!-- Zpracování všech elementů zdrojového dokumentu -->
                    <xsl:apply-templates mode="list"/>
                    <xsl:apply-templates mode="reservation"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="reservation-list" mode="list">
        <fo:block id="start" text-align="center" font-size="10mm" font-weight="bold"
            margin-bottom="15mm">Přehled rezervací v jednotlivých dnech</fo:block>
        <fo:table border="solid" margin-bottom="1cm">
            <fo:table-header>
                <fo:table-row border-bottom="solid">
                    <fo:table-cell>
                        <fo:block text-align="center" font-weight="bold" padding="3mm"
                            >Den</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block text-align="center" font-weight="bold" padding="3mm"
                            >Datum</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block text-align="center" font-weight="bold" padding="3mm">Počet
                            rezervací</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each-group select="reservation" group-by="appointment/day">
                    <xsl:sort select="appointment/day"/>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block padding="3mm" text-align="center" text-decoration="underline">
                                <fo:basic-link internal-destination="{generate-id(appointment/day)}">
                                    <xsl:if test=".[@day = 'mon']">
                                        <xsl:text>pondělí </xsl:text>
                                    </xsl:if>
                                    <xsl:if test=".[@day = 'tue']">
                                        <xsl:text>úterý </xsl:text>
                                    </xsl:if>
                                    <xsl:if test=".[@day = 'wed']">
                                        <xsl:text>středa </xsl:text>
                                    </xsl:if>
                                    <xsl:if test=".[@day = 'thu']">
                                        <xsl:text>čtvrtek </xsl:text>
                                    </xsl:if>
                                    <xsl:if test=".[@day = 'fri']">
                                        <xsl:text>pátek </xsl:text>
                                    </xsl:if>
                                </fo:basic-link>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block padding="3mm" text-align="center">
                                <xsl:value-of
                                    select="format-date(current-grouping-key(), '[D]. [MNn] [Y]', 'cs', 'AD', 'GE')"
                                />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block padding="3mm" text-align="center">
                                <xsl:value-of select="count(current-group())"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each-group>
            </fo:table-body>
        </fo:table>

        <fo:block text-align="center">
            <fo:external-graphic src="url(/Users/Hynek/Desktop/XMLSemestralka/src/img/logo.jpg)"
                content-width="5cm" width="40%" text-align="center" display-align="center"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="reservation-list" mode="reservation">
        <xsl:for-each-group select="reservation" group-by="appointment/day">
            <xsl:sort select="appointment/day" order="ascending"/>
            <fo:block id="{generate-id(appointment/day)}" break-before="page" font-size="11pt">

                <!--<xsl:for-each-group select="reservation" group-by="appointment/day">-->
                <fo:block font-size="16pt" font-weight="bold" text-align="center">
                    <xsl:text>Rezervace na </xsl:text>
                    <xsl:if test=".[@day = 'mon']">
                        <xsl:text>pondělí </xsl:text>
                    </xsl:if>
                    <xsl:if test=".[@day = 'tue']">
                        <xsl:text>úterý </xsl:text>
                    </xsl:if>
                    <xsl:if test=".[@day = 'wed']">
                        <xsl:text>středa </xsl:text>
                    </xsl:if>
                    <xsl:if test=".[@day = 'thu']">
                        <xsl:text>čtvrtek </xsl:text>
                    </xsl:if>
                    <xsl:if test=".[@day = 'fri']">
                        <xsl:text>pátek </xsl:text>
                    </xsl:if>

                    <xsl:text> - </xsl:text>
                    <xsl:value-of
                        select="format-date(current-grouping-key(), '[D]. [MNn] [Y]', 'cs', 'AD', 'GE')"
                    />
                </fo:block>

                <fo:block text-align="center" font-size="10pt" margin-bottom="5mm">
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="count(current-group())"/>
                    <xsl:text> rezervace)</xsl:text>
                </fo:block>

                <!-- sorting starting with the earliest appointmennt -->
                <xsl:apply-templates select="current-group()" mode="reservation">
                    <xsl:sort select="appointment/time" order="ascending"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:for-each-group>

    </xsl:template>

    <xsl:template match="reservation" mode="reservation">

        <fo:block padding-left="3mm" padding-right="3mm" padding-top="3mm" border-left="solid"
            border-top="solid" border-right="solid">
            <fo:table>
                <fo:table-column column-width="45%"/>
                <fo:table-column column-width="15%"/>
                <fo:table-column column-width="15%"/>
                <fo:table-column column-width="25%"/>
                <xsl:apply-templates select="appointment" mode="reservation"/>
            </fo:table>
        </fo:block>
        <!--<fo:block margin-bottom="3mm"/>-->

        <xsl:apply-templates select="animal" mode="reservation"/>
        <fo:block margin-bottom="3mm"/>
        <xsl:apply-templates select="owner" mode="reservation"/>
        <fo:block margin-top="5mm" margin-bottom="5mm" border-bottom="dotted"/>
    </xsl:template>

    <xsl:template match="appointment" mode="reservation">
        <fo:table-header>
            <fo:table-row>
                <fo:table-cell>
                    <fo:block font-weight="bold">Předmět</fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block font-weight="bold">Čas</fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block font-weight="bold">Délka</fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block font-weight="bold">Priorita</fo:block>
                </fo:table-cell>
            </fo:table-row>
        </fo:table-header>
        <fo:table-body>
            <fo:table-row>
                <fo:table-cell>
                    <fo:block padding="3mm">
                        <xsl:if test="examination"> Prohlídka </xsl:if>
                        <xsl:if test="disease"> Nemoc </xsl:if>
                        <xsl:if test="injury"> Úraz </xsl:if>
                        <xsl:if test="surgery"> Chirurgický zákrok </xsl:if>
                        <xsl:if test="other"> Ostatní služby </xsl:if>
                        <fo:inline>: <fo:inline font-size="10pt"><xsl:value-of select="./*[1]"
                                /></fo:inline></fo:inline>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block padding="3mm">
                        <xsl:value-of select="format-time(time, '[H]:[m]')"/>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block padding="3mm">
                        <xsl:value-of select="duration"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="duration/@unit"/>
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <xsl:if test="@priority = 'vysoká'">
                        <fo:block padding="3mm" background-color="FireBrick" color="white">
                            <xsl:value-of select="@priority"/>
                        </fo:block>
                    </xsl:if>
                    <xsl:if test="@priority = 'střední'">
                        <fo:block padding="3mm" background-color="Gold">
                            <xsl:value-of select="@priority"/>
                        </fo:block>
                    </xsl:if>
                    <xsl:if test="@priority = 'normální'">
                        <fo:block padding="3mm" background-color="black" color="white">
                            <xsl:value-of select="@priority"/>
                        </fo:block>
                    </xsl:if>
                </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
                <fo:table-cell number-columns-spanned="4">
                    <fo:block padding="3mm" border-left="solid" border-right="solid"
                        background-color="Gainsboro" border-color="Gainsboro">
                        <xsl:value-of select="../animal/medical/notes/*"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </fo:table-body>
    </xsl:template>

    <xsl:template match="animal" mode="reservation">

        <fo:block padding="3mm" border-style="solid" border-color="Gainsboro">
            <fo:table>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block>
                                <fo:inline color="grey">Zvíře: </fo:inline>
                                <fo:inline text-transform="capitalize">
                                    <xsl:value-of select="species"/>
                                    <xsl:text> </xsl:text>
                                </fo:inline>
                                <fo:inline text-transform="capitalize">(<xsl:value-of select="breed"
                                    />)</fo:inline>
                                <fo:inline> - <xsl:value-of select="name"/></fo:inline>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="right"> čip: <xsl:if test="identifier != ''">
                                    <fo:inline font-style="italic"><xsl:value-of select="identifier"
                                        /></fo:inline>
                                </xsl:if>
                                <xsl:if test="identifier = ''">
                                    <fo:inline font-style="italic">Bez čipu</fo:inline>
                                </xsl:if>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>


            <fo:block margin-bottom="3mm"/>
            <fo:table>
                <fo:table-column column-width="20%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="50%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-header>


                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold" text-align="center">Pohlaví</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block font-weight="bold" text-align="center">Váha</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block font-weight="bold" text-align="center">Věk</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block font-weight="bold" text-align="center">Léky</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block font-weight="bold" text-align="center">Dávka</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block text-align="center">
                                <xsl:value-of select="sex"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="center">
                                <xsl:value-of select="medical/weight"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="medical/weight/@unit"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="center">
                                <xsl:value-of select="age"/>
                                <xsl:choose>
                                    <xsl:when test="age = 1">
                                        <xsl:text> rok</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="age &gt; 1 and age &lt; 5">
                                                <xsl:text> roky</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text> let</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="center">
                                <xsl:choose>
                                    <xsl:when test="medical/medication/active-ingredient">
                                        <xsl:for-each select="medical/medication/active-ingredient">
                                            <fo:block>
                                                <xsl:value-of select="."/>
                                            </fo:block>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text> - </xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="center">
                                <xsl:choose>
                                    <xsl:when test="medical/medication/dose">
                                        <xsl:for-each select="medical/medication/dose">
                                            <fo:block>
                                                <xsl:value-of select="."/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="./@unit"/>
                                            </fo:block>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text> - </xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>

    </xsl:template>

    <xsl:decimal-format name="zip" decimal-separator="," grouping-separator=" "/>

    <xsl:template match="owner" mode="reservation">
        <xsl:variable name="phone" select="tel"/>
        <xsl:variable name="email" select="email"/>
        <fo:block margin-bottom="2mm">
            <fo:inline border="solid" padding="1mm">Majitel</fo:inline>
        </fo:block>

        <fo:table>
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-weight="bold" text-align="center">Jméno</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-weight="bold" text-align="center">Email</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-weight="bold" text-align="center">Telefon</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-weight="bold">Bydliště</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-size="9pt" text-align="center">
                            <xsl:value-of select="name"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-size="9pt" text-align="center">
                            <xsl:value-of select="$email"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-size="9pt" text-align="center">
                            <xsl:value-of select="$phone"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <fo:block font-size="9pt">
                                <xsl:value-of select="address/street"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="address/streetNum"/>
                            </fo:block>
                            <fo:block font-size="9pt">
                                <xsl:value-of select="address/city"/>
                            </fo:block>
                            <fo:block font-size="9pt">
                                <xsl:value-of select="format-number(address/zip, '### ##', 'zip')"/>
                            </fo:block>
                            <fo:block font-size="9pt">
                                <xsl:value-of select="address/country"/>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

    </xsl:template>

</xsl:stylesheet>
