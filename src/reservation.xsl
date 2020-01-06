<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="urn:x-zemanec:schemas:reservation:1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="html" encoding="UTF-8"/>
    
    <xsl:variable name="nav">
        <nav>
            <a href="index.html">Zpět na přehled</a>
        </nav>
    </xsl:variable>
    
    <xsl:variable name="head">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="stylesheet" href="style.css"/>
    </xsl:variable>

    <xsl:template match="/">
        <!--        render list of days with reservation count -->
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <xsl:copy-of select="$head" />
                <title>List rezervací</title>
            </head>
            <body>
                <xsl:apply-templates mode="list"/>
            </body>
        </html>

        <!--        for each animal generate it's own profile in unique file -->
        <xsl:result-document method="html" encoding="UTF-8" href="{generate-id(.)}.html">

            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

            <html>
                <head>
                    <xsl:copy-of select="$head" />
                    <title>Zvíře</title>
                </head>
                <body>
                    <xsl:apply-templates mode="animal"/>
                    <xsl:copy-of select="$nav" />
                </body>
            </html>
        </xsl:result-document>

        <!--        for each owner generate it's own profile in unique file-->
        <xsl:result-document method="html" encoding="UTF-8" href="owner{generate-id(.)}.html">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                    <link rel="stylesheet" href="style.css"/>
                    <title>List rezervací</title>
                </head>
                <body>
                    <xsl:apply-templates mode="owner"/>
                    <xsl:copy-of select="$nav" />
                </body>
            </html>
        </xsl:result-document>
        
        <!--        for each day generate it's own overview of reservations in unique file-->
        <xsl:result-document method="html" encoding="UTF-8" href="overview{generate-id(.)}.html">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                    <link rel="stylesheet" href="style.css"/>
                    <title>Rezervace</title>
                </head>
                <body>
                    <xsl:apply-templates mode="overview"/>
                    <xsl:copy-of select="$nav" />
                </body>
            </html>
        </xsl:result-document>

    </xsl:template>

    <xsl:template match="reservation-list" mode="list">
        <h1>Přehled rezervací ve dnech</h1>
        <section class="box">
            <table>
                <tr>
                    <th>Den</th>
                    <th>Datum</th>
                    <th>Počet rezervací</th>
                </tr>
                <xsl:for-each-group select="reservation" group-by="appointment/day">
                    <tr>
                        <td>
                            <a class="name" href="overview{generate-id(.)}.html">
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
                            </a>
                        </td>
                        <td>
                            <xsl:value-of
                                select="format-date(current-grouping-key(), '[D]. [MNn] [Y]', 'cs', 'AD', 'GE')"
                            />
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group())"/>
                        </td>
                    </tr>
                </xsl:for-each-group>
                <!--                <xsl:apply-templates select="reservation" mode="list"> </xsl:apply-templates>-->
            </table>
        </section>
    </xsl:template>

    <xsl:template match="reservation" mode="list">
        <xsl:for-each-group select="." group-by="appointment/day">

            <tr>
                <td>
                    <a class="name" href="overview{generate-id(.)}">
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
                    </a>
                </td>
                <td>
                    <xsl:value-of
                        select="format-date(current-grouping-key(), '[D]. [MNn] [Y]', 'cs', 'AD', 'GE')"
                    />
                </td>
                <td>
                    <xsl:value-of select="count(current-group())"/>
                </td>
            </tr>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="animal" mode="animal">
        <h1>Informace o zvířeti</h1>
        <section class="box">
            <h2>Základní informace - <xsl:value-of select="name"/></h2>
            <table>
                <tr>
                    <th>Druh</th>
                    <th>Plemeno</th>
                    <th>Pohlaví</th>
                    <th>Věk</th>
                </tr>
                <tr>
                    <td>
                        <xsl:value-of select="species"/>
                    </td>
                    <td>
                        <xsl:value-of select="breed"/>
                    </td>
                    <td>
                        <xsl:value-of select="sex"/>
                    </td>
                    <td>
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
                    </td>
                </tr>
            </table>
            <h2>Zdravotní údaje</h2>
            <table>
                <tr>
                    <th>Váha</th>
                    <th>Zdravotní stav</th>
                    <th>Léky</th>
                    <th>Dávka</th>
                </tr>
                <tr>
                    <td>
                        <xsl:value-of select="medical/weight"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="medical/weight/@unit"/>
                    </td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="medical[@condition = 'true']">
                                <xsl:value-of select="medical/notes"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="sex = 'samec'">
                                        <xsl:text>Zdravý</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Zdravá</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <xsl:value-of select="medical/medication/active-ingredient"/>
                    </td>
                    <td>
                        <xsl:value-of select="medical/medication/dose"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="medical/medication/dose/@unit"/>
                    </td>
                </tr>
            </table>

            <p class="notes">
                <xsl:value-of select="medical/notes"/>
            </p>
        </section>
    </xsl:template>

    <!--zip format-->
    <xsl:decimal-format name="zip" decimal-separator="," grouping-separator=" "/>

    <xsl:template match="owner" mode="owner">
        <xsl:variable name="phone" select="tel"/>
        <xsl:variable name="email" select="email"/>

        <h1>Informace o majiteli</h1>
        <section class="box">
            <h2>
                <xsl:value-of select="name"/>
            </h2>
            <table>
                <tr>
                    <th>Ulice</th>
                    <td>
                        <xsl:value-of select="address/street"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="address/streetNum"/>
                    </td>
                </tr>
                <tr>
                    <th>Město</th>
                    <td>
                        <xsl:value-of select="address/city"/>
                    </td>
                </tr>
                <tr>
                    <th>PSČ</th>
                    <td>
                        <xsl:value-of select="format-number(address/zip, '### ##', 'zip')"/>
                    </td>
                </tr>
                <tr>
                    <th>Země</th>
                    <td>
                        <xsl:value-of select="address/country"/>
                    </td>
                </tr>
            </table>

            <h2>Kontakt</h2>
            <table>
                <tr>
                    <th>Telefon</th>
                    <th>Email</th>
                </tr>
                <tr>
                    <td>
                        <a class="name" href="tel:${phone}">
                            <xsl:value-of select="$phone"/>
                        </a>
                    </td>
                    <td>
                        <a class="name" href="mailto:${email}">
                            <xsl:value-of select="$email"/>
                        </a>
                    </td>
                </tr>
            </table>
        </section>
    </xsl:template>

    <xsl:template match="reservation-list" mode="overview">
        <main>
            <xsl:for-each-group select="reservation" group-by="appointment/day">
                <h1>
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
                    <br/>
                    <xsl:text>( </xsl:text>
                    <xsl:value-of
                        select="format-date(current-grouping-key(), '[D]. [MNn] [Y]', 'cs', 'AD', 'GE')"/>
                    <xsl:text> )</xsl:text>
                </h1>

                <p style="text-align:center; font-weight:bold">
                    <xsl:value-of select="count(current-group())"/>
                    <xsl:text> rezervace ⬇</xsl:text>
                </p>

                <!-- sorting starting with the earliest appointmennt -->
                <xsl:apply-templates select="current-group()" mode="overview">
                    <xsl:sort select="appointment/time" order="ascending"/>
                </xsl:apply-templates>

            </xsl:for-each-group>

        </main>
    </xsl:template>

    <xsl:template match="reservation" mode="overview">
        <section class="box">
            <h2>Návštěva</h2>
            <xsl:apply-templates select="appointment"/>
            <xsl:apply-templates select="animal" mode="overview"/>
            <xsl:apply-templates select="owner" mode="overview"/>
        </section>
    </xsl:template>

    <xsl:template match="animal" mode="overview">
        <h2>Informace o zvířeti</h2>
        <p class="animal">
            <xsl:value-of select="species"/>
            <xsl:text> ( </xsl:text>
            <xsl:value-of select="breed"/>
            <xsl:text> ) - </xsl:text>
            <!--            TODO generate-id() -->
            <a class="name" href="animal{generate-id(.)}">
                <xsl:value-of select="name"/>
            </a>
        </p>
        <table>
            <tr>
                <th>Pohlaví</th>
                <th>Váha</th>
                <th>Věk</th>
            </tr>
            <tr>
                <td>
                    <xsl:value-of select="sex"/>
                </td>
                <td>
                    <xsl:value-of select="medical/weight"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="medical/weight/@unit"/>
                </td>
                <td>
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
                </td>

            </tr>
        </table>

        <table>
            <tr>
                <th>Zdravotní stav</th>
            </tr>
            <tr>
                <td>

                    <xsl:choose>
                        <xsl:when test="medical[@condition = 'true']">
                            <xsl:value-of select="medical/notes"/>
                        </xsl:when>
                        <xsl:otherwise>

                            <xsl:choose>
                                <xsl:when test="sex = 'samec'">
                                    <xsl:text>Zdravý</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Zdravá</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>

                </td>
            </tr>
        </table>

        <xsl:if test="medical/medication[@active-use = 'true']">
            <p class="medication">
                <xsl:value-of select="medical/medication/active-ingredient"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="medical/medication/dose"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="medical/medication/dose/@unit"/>
            </p>
        </xsl:if>

    </xsl:template>

    <xsl:template match="owner" mode="overview">
        <xsl:variable name="phone" select="tel"/>
        <xsl:variable name="email" select="email"/>

        <h2>Majitel</h2>
        <p class="owner">
            <!--            TODO generate-id() -->
            <a class="name" href="owner{generate-id(.)}">
                <xsl:value-of select="name"/>
            </a>

            <a class="tel" href="tel:{$phone}">
                <xsl:value-of select="$phone"/>
            </a>
            <a class="mail" href="mailto:{$email}">
                <xsl:value-of select="$email"/>
            </a>
        </p>
    </xsl:template>

    <xsl:template match="appointment">
        <div class="priority">
            <xsl:if test="@priority = 'vysoká'">
                <xsl:attribute name="style">background:#ab0808</xsl:attribute>
            </xsl:if>
            <xsl:if test="@priority = 'střední'">
                <xsl:attribute name="style">background:#9a6d00c4</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@priority"/>
            <xsl:text> priorita</xsl:text>
        </div>

        <table>
            <tr>
                <th>Předmět</th>
                <th>Čas</th>
                <th>Délka</th>
            </tr>
            <tr>
                <td>
                    <xsl:if test="examination"> Prohlídka </xsl:if>
                    <xsl:if test="disease"> Nemoc </xsl:if>
                    <xsl:if test="injury"> Úraz </xsl:if>
                    <xsl:if test="surgery"> Chirurgický zákrok </xsl:if>
                    <xsl:if test="other"> Ostatní služby </xsl:if>
                </td>
                <td>
                    <xsl:value-of select="format-time(time, '[H]:[m]')"/>
                </td>
                <td>
                    <xsl:value-of select="duration"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="duration/@unit"/>
                </td>
            </tr>
            <tr class="notes">
                <td>
                    <!--  can be disease, injury, surgery etc ...-->
                    <xsl:value-of select="./*[1]"/>
                </td>
            </tr>
        </table>
    </xsl:template>


</xsl:stylesheet>
