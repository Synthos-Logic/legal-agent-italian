<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://www.w3.org/HTML/1998/html4">
	<xsl:output method="html"/>
	<xsl:template match="//GA/Provvedimento">
		<html>
			<xsl:choose>
				<xsl:when test="(meta/descrittori/bilingue='S') ">
					<table width="100%" cellpadding="10">
						<tr>
							<td width="50%" valign="top">
								<head>
									<xsl:choose>
										<xsl:when test="meta/@versionePDF='1' and meta/dataPubblicazione!=''">
									Pubblicato il <xsl:value-of select="meta/dataPubblicazione"/>
										</xsl:when>
										<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
											<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.RIC.A.P.</title>
										</xsl:when>
										<xsl:otherwise>
											<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.RIC.</title>
										</xsl:otherwise>
									</xsl:choose>
									<link rel="stylesheet" type="text/css" href="Provvedimento.css"/>
								</head>
							</td>
							<td width="50%" valign="top">
								<head>
									<xsl:choose>
										<xsl:when test="meta/@versionePDF='1' and meta/dataPubblicazione!=''">
									Pubblicato il <xsl:value-of select="meta/dataPubblicazione"/>
										</xsl:when>
										<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
											<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.RIC.A.P.</title>
										</xsl:when>
										<xsl:otherwise>
											<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REK.</title>
										</xsl:otherwise>
									</xsl:choose>
									<link rel="stylesheet" type="text/css" href="Provvedimento.css"/>
								</head>
							</td>
						</tr>
					</table>
					<body class="corpo">
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<p class="registri">N. <xsl:value-of select="meta/descrittori/fascicolo/@n"/>/<xsl:value-of select="meta/descrittori/fascicolo/@anno"/>
										<!--****dal 2011 cambiano i registri e quindi anche le relative etichette -->
										<xsl:choose>
											<xsl:when test="substring((substring-after((substring-after(meta/@modifica,'/')),'/')),0,5) &lt; '2011'">
												<xsl:if test="epigrafe/adunanza/h:div[4]='SENTENZA'"> REG.SEN.</xsl:if>
												<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">REG.DISP.</xsl:if>
												<xsl:if test="epigrafe/adunanza/h:div[4]='DECISIONE'">REG.SEN.</xsl:if>
												<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">REG.DISP.</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="epigrafe/adunanza/h:div[4]='SENTENZA'"> REG.PROV.COLL.</xsl:if>
												<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">REG.PROV.COLL.</xsl:if>
												<xsl:if test="epigrafe/adunanza/h:div[4]='DECISIONE'">REG.PROV.COLL.</xsl:if>
												<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">REG.PROV.COLL.</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</p>
								</td>
								<td width="50%" valign="top">
									<p class="registri">N. <xsl:value-of select="meta/descrittori/fascicolo/@n"/>/<xsl:value-of select="meta/descrittori/fascicolo/@anno"/>
										<!--****dal 2011 cambiano i registri e quindi anche le relative etichette -->
										<xsl:choose>
											<xsl:when test="substring((substring-after((substring-after(meta/@modifica,'/')),'/')),0,5) &lt; '2011'">
												<xsl:if test="epigrafe/adunanzaTed/h:div[4]='URTEIL'"> REG.SEN.</xsl:if>
												<xsl:if test="epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCH'">REG.DISP.</xsl:if>
												<xsl:if test="epigrafe/adunanzaTed/h:div[4]='DECISIONE'">REG.SEN.</xsl:if>
												<xsl:if test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE'">REG.DISP.</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="epigrafe/adunanzaTed/h:div[4]='URTEIL'"> REG.KOLL.BESCHL</xsl:if>
												<xsl:if test="epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">REG.URT.VERF.</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</p>
								</td>
							</tr>
						</table>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:choose>
										<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
											<xsl:for-each select="meta/descrittori/registro">
												<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.RIC.A.P.</p>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="meta/descrittori/registro">
												<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.RIC.</p>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td width="50%" valign="top">
									<xsl:choose>
										<xsl:when test="epigrafe/adunanzaTed/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
											<xsl:for-each select="meta/descrittori/registro">
												<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.RIC.A.P.</p>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="meta/descrittori/registro">
												<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.REK.</p>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<p class="repubblica">
										<img border="0" src="stemma.jpg"/>
									</p>
									<p class="repubblica">REPUBBLICA ITALIANA</p>
									<!-- inizio nuovo processo daniela  -->
								</td>
								<td width="50%" valign="top">
									<p class="repubblica">
										<img border="0" src="stemma.jpg"/>
									</p>
									<p class="repubblica">REPUBLIK ITALIEN</p>
									<!-- inizio nuovo processo daniela  -->
								</td>
							</tr>
							<tr>
								<td width="50%" valign="top">
									<p class="innome">IN NOME DEL POPOLO ITALIANO</p>
								</td>
								<td width="50%" valign="top">
									<p class="innome">IM NAMEN DES ITALIENISCHEN VOLKES</p>
								</td>
							</tr>
							<tr>
								<td width="50%" valign="top">
									<p class="sezione">
										<xsl:value-of select="epigrafe/adunanza/h:div[1]"/>
									</p>
								</td>
								<td width="50%" valign="top">
									<p class="sezione">
										<xsl:value-of select="epigrafe/adunanzaTed/h:div[1]"/>
									</p>
								</td>
							</tr>
							<tr>
								<td width="50%" valign="top">
									<p class="sezione">
										<xsl:value-of select="epigrafe/adunanza/h:div[2]"/>
									</p>
								</td>
								<td width="50%" valign="top">
									<p class="sezione">
										<xsl:value-of select="epigrafe/adunanzaTed/h:div[2]"/>
									</p>
								</td>
							</tr>
							<tr>
								<td width="50%" valign="top">
									<p class="tabula">
										<xsl:value-of select="epigrafe/adunanza/h:div[3]"/>
									</p>
								</td>
								<td width="50%" valign="top">
									<p class="tabula">
										<xsl:value-of select="epigrafe/adunanzaTed/h:div[3]"/>
									</p>
								</td>
							</tr>
						</table>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:choose>
										<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
											<xsl:choose>
												<xsl:when test="epigrafe/adunanza/h:div[4]='DECISIONE' or epigrafe/adunanza/h:div[4]='SENTENZA'">
													<xsl:choose>
														<xsl:when test="(meta/descrittori/idTipoProvSDM='1' and meta/descrittori/idSpecificaSDM='9') or(meta/descrittori/idTipoProvSDM='2' and meta/descrittori/idSpecificaSDM='8') ">
															<p class="sezione">SENTENZA NON DEFINITIVA</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="sezione">SENTENZA</p>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">
													<p class="sezione">DISPOSITIVO DI SENTENZA</p>
												</xsl:when>
												<xsl:otherwise>
													<p class="sezione">
														<xsl:value-of select="epigrafe/adunanza/h:div[4]"/>
													</p>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<p class="sezione">
												<xsl:value-of select="epigrafe/adunanza/h:div[4]"/>
											</p>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td width="50%" valign="top">
									<xsl:choose>
										<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
											<xsl:choose>
												<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEIL'">
													<xsl:choose>
														<xsl:when test="(meta/descrittori/idTipoProvSDM='1' and meta/descrittori/idSpecificaSDM='9') or(meta/descrittori/idTipoProvSDM='2' and meta/descrittori/idSpecificaSDM='8') ">
															<p class="sezione">NICHT ENDGÜLTIGES URTEIL </p>
														</xsl:when>
														<xsl:otherwise>
															<p class="sezione">URTEIL</p>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:when test="epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCH'">
													<p class="sezione">URTEILSSPRUCH</p>
												</xsl:when>
												<xsl:otherwise>
													<p class="sezione">
														<xsl:value-of select="epigrafe/adunanzaTed/h:div[4]"/>
													</p>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<p class="sezione">
												<xsl:value-of select="epigrafe/adunanzaTed/h:div[4]"/>
											</p>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<p class="popolo">
										<xsl:for-each select="epigrafe/ricorrenti/h:div">
											<xsl:apply-templates select="."/>
											<br/>
										</xsl:for-each>
									</p>
								</td>
								<td width="50%" valign="top">
									<p class="popolo">
										<xsl:for-each select="epigrafe/ricorrentiTed/h:div">
											<xsl:apply-templates select="."/>
											<br/>
										</xsl:for-each>
									</p>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:for-each select="epigrafe/ricorrenti/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<tr>
									<td width="49%" valign="top">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
									</td>
									<td width="2%"/>
									<td width="49%" valign="top">
										<p class="popolo">
											<xsl:apply-templates select="../.././ricorrentiTed/h:div[$divpos]"/>
										</p>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:if test="epigrafe/resistenti/h:div!=''">
										<p class="contro">contro</p>
										<p class="popolo">
											<xsl:for-each select="epigrafe/resistenti/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
								<td width="50%" valign="top">
									<xsl:if test="epigrafe/resistentiTed/h:div!=''">
										<p class="contro">gegen</p>
										<p class="popolo">
											<xsl:for-each select="epigrafe/resistentiTed/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:if test="epigrafe/resistenti/h:div!=''">
								<xsl:for-each select="epigrafe/resistenti/h:div">
									<xsl:variable name="divpos" select="position()"/>
									<tr>
										<td width="49%" valign="top">
											<xsl:if test="$divpos=1">
												<p class="contro">contro</p>
											</xsl:if>
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
											<br/>
										</td>
										<td width="2%"/>
										<td width="49%" valign="top">
											<xsl:if test="$divpos=1">
												<p class="contro">gegen</p>
											</xsl:if>
											<p class="popolo">
												<xsl:apply-templates select="../.././resistentiTed/h:div[$divpos]"/>
											</p>
											<br/>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:if>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:if test="epigrafe/altro/controinteressati/h:div!=''">
										<p class="contro">nei confronti</p>
										<p class="popolo">
											<xsl:for-each select="epigrafe/altro/controinteressati/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
								<td width="50%" valign="top">
									<xsl:if test="epigrafe/altro/controinteressatiTed/h:div!=''">
										<p class="contro">und gegen</p>
										<p class="popolo">
											<xsl:for-each select="epigrafe/altro/controinteressatiTed/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:if test="epigrafe/altro/controinteressati/h:div!=''">
								<xsl:for-each select="epigrafe/altro/controinteressati/h:div">
									<xsl:variable name="divpos" select="position()"/>
									<tr>
										<td width="49%" valign="top">
											<xsl:if test="$divpos=1">
												<p class="contro">nei confronti</p>
											</xsl:if>
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
											<br/>
										</td>
										<td width="2%"/>
										<td width="49%" valign="top">
											<xsl:if test="$divpos=1">
												<p class="contro">und gegen</p>
											</xsl:if>
											<p class="popolo">
												<xsl:apply-templates select="../.././controinteressatiTed/h:div[$divpos]"/>
											</p>
											<br/>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:if>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:if test="epigrafe/altro/intervenienti/h:div!=''">
										<p class="contro">e con l'intervento di</p>
										<p class="popolo">
											<xsl:for-each select="epigrafe/altro/intervenienti/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
								<td width="50%" valign="top">
									<xsl:if test="epigrafe/altro/intervenientiTed/h:div!=''">
										<p class="contro">und mit dem</p>
										<p class="popolo">
											<xsl:for-each select="epigrafe/altro/intervenientiTed/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:if test="epigrafe/altro/intervenienti/h:div!=''">
								<xsl:for-each select="epigrafe/altro/intervenienti/h:div">
									<xsl:variable name="divpos" select="position()"/>
									<tr>
										<td width="49%" valign="top">
											<xsl:if test="$divpos=1">
												<p class="contro">e con l'intervento di</p>
											</xsl:if>
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
											<br/>
										</td>
										<td width="2%"/>
										<td width="49%" valign="top">
											<xsl:if test="$divpos=1">
												<p class="contro">und mit dem</p>
											</xsl:if>
											<p class="popolo">
												<xsl:apply-templates select="../.././intervenientiTed/h:div[$divpos]"/>
											</p>
											<br/>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:if>
						</table>
						<xsl:for-each select="epigrafe/riuniti">
							<br/>
							<br/>
							<!--table width="100%" cellpadding="10">
								<tr>
									<td width="50%" valign="top">
										<p class="popolo">
											<xsl:for-each select="ricorrenti/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</td>
									<td width="50%" valign="top">
										<p class="popolo">
											<xsl:for-each select="ricorrentiTed/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</td>
								</tr>
							</table-->
							<table width="100%">
								<xsl:for-each select="ricorrenti/h:div">
									<xsl:variable name="divpos" select="position()"/>
									<tr>
										<td width="49%" valign="top">
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
										</td>
										<td width="2%"/>
										<td width="49%" valign="top">
											<p class="popolo">
												<xsl:apply-templates select="../.././ricorrentiTed/h:div[$divpos]"/>
											</p>
										</td>
									</tr>
								</xsl:for-each>
							</table>
							<!--table width="100%" cellpadding="10">
								<tr>
									<td width="50%" valign="top">
										<xsl:if test="resistenti/h:div!=''">
											<p class="contro">contro</p>
											<p class="popolo">
												<xsl:for-each select="resistenti/h:div">
													<xsl:apply-templates select="."/>
													<br/>
												</xsl:for-each>
											</p>
										</xsl:if>
									</td>
									<td width="50%" valign="top">
										<xsl:if test="resistentiTed/h:div!=''">
											<p class="contro">gegen</p>
											<p class="popolo">
												<xsl:for-each select="resistentiTed/h:div">
													<xsl:apply-templates select="."/>
													<br/>
												</xsl:for-each>
											</p>
										</xsl:if>
									</td>
								</tr>
							</table-->
							<table width="100%">
								<xsl:if test="resistenti/h:div!=''">
									<xsl:for-each select="resistenti/h:div">
										<xsl:variable name="divpos" select="position()"/>
										<tr>
											<td width="49%" valign="top">
												<xsl:if test="$divpos=1">
													<p class="contro">contro</p>
												</xsl:if>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<br/>
											</td>
											<td width="2%"/>
											<td width="49%" valign="top">
												<xsl:if test="$divpos=1">
													<p class="contro">gegen</p>
												</xsl:if>
												<p class="popolo">
													<xsl:apply-templates select="../.././resistentiTed/h:div[$divpos]"/>
												</p>
												<br/>
											</td>
										</tr>
									</xsl:for-each>
								</xsl:if>
							</table>
							<!--table width="100%" cellpadding="10">
								<tr>
									<td width="50%" valign="top">
										<xsl:if test="altro/controinteressati/h:div!=''">
											<p class="contro">nei confronti</p>
											<p class="popolo">
												<xsl:for-each select="altro/controinteressati/h:div">
													<xsl:apply-templates select="."/>
													<br/>
												</xsl:for-each>
											</p>
										</xsl:if>
									</td>
									<td width="50%" valign="top">
										<xsl:if test="altro/controinteressatiTed/h:div!=''">
											<p class="contro">und gegen</p>
											<p class="popolo">
												<xsl:for-each select="altro/controinteressatiTed/h:div">
													<xsl:apply-templates select="."/>
													<br/>
												</xsl:for-each>
											</p>
										</xsl:if>
									</td>
								</tr>
							</table-->
							<table width="100%">
								<xsl:if test="altro/controinteressati/h:div!=''">
									<xsl:for-each select="altro/controinteressati/h:div">
										<xsl:variable name="divpos" select="position()"/>
										<tr>
											<td width="49%" valign="top">
												<xsl:if test="$divpos=1">
													<p class="contro">nei confronti</p>
												</xsl:if>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<br/>
											</td>
											<td width="2%"/>
											<td width="49%" valign="top">
												<xsl:if test="$divpos=1">
													<p class="contro">und gegen</p>
												</xsl:if>
												<p class="popolo">
													<xsl:apply-templates select="../.././controinteressatiTed/h:div[$divpos]"/>
												</p>
												<br/>
											</td>
										</tr>
									</xsl:for-each>
								</xsl:if>
							</table>
							<!--table width="100%" cellpadding="10">
								<tr>
									<td width="50%" valign="top">
										<xsl:if test="altro/intervenienti/h:div!=''">
											<p class="contro">e con l'intervento di</p>
											<p class="popolo">
												<xsl:for-each select="altro/intervenienti/h:div">
													<xsl:apply-templates select="."/>
													<br/>
												</xsl:for-each>
											</p>
										</xsl:if>
									</td>
									<td width="50%" valign="top">
										<xsl:if test="altro/intervenientiTed/h:div!=''">
											<p class="contro">und mit dem</p>
											<p class="popolo">
												<xsl:for-each select="altro/intervenientiTed/h:div">
													<xsl:apply-templates select="."/>
													<br/>
												</xsl:for-each>
											</p>
										</xsl:if>
									</td>
								</tr>
							</table-->
							<table width="100%">
								<xsl:if test="altro/intervenienti/h:div!=''">
									<xsl:for-each select="altro/intervenienti/h:div">
										<xsl:variable name="divpos" select="position()"/>
										<tr>
											<td width="49%" valign="top">
												<xsl:if test="$divpos=1">
													<p class="contro">e con l'intervento di</p>
												</xsl:if>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<br/>
											</td>
											<td width="2%"/>
											<td width="49%" valign="top">
												<xsl:if test="$divpos=1">
													<p class="contro">und mit dem</p>
												</xsl:if>
												<p class="popolo">
													<xsl:apply-templates select="../.././intervenientiTed/h:div[$divpos]"/>
												</p>
												<br/>
											</td>
										</tr>
									</xsl:for-each>
								</xsl:if>
							</table>
						</xsl:for-each>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="49%" valign="top">
									<p class="contro">
										<xsl:value-of select="epigrafe/oggetto/h:div[1]"/>
									</p>
								</td>
								<td width="2%"/>
								<td width="49%" valign="top">
									<p class="contro">
										<xsl:value-of select="epigrafe/oggettoTed/h:div[1]"/>
									</p>
								</td>
							</tr>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:for-each select="epigrafe/oggetto/h:div">
										<xsl:if test="position() > 1">
											<xsl:choose>
												<xsl:when test="substring(.,1,6) = 'previa'">
													<p class="previa">
														<xsl:apply-templates select="."/>
													</p>
												</xsl:when>
												<xsl:otherwise>
													<p class="popolo">
														<xsl:apply-templates select="."/>
													</p>
													<xsl:if test=".=''">
														<br/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td width="50%" valign="top">
									<xsl:for-each select="epigrafe/oggettoTed/h:div">
										<xsl:if test="position() > 1">
											<xsl:choose>
												<xsl:when test="substring(.,1,15) = 'nach Aussetzung'">
													<p class="previa">
														<xsl:apply-templates select="."/>
													</p>
												</xsl:when>
												<xsl:otherwise>
													<p class="popolo">
														<xsl:apply-templates select="."/>
													</p>
													<xsl:if test=".=''">
														<br/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:for-each select="epigrafe/oggetto/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<xsl:if test="position() > 1">
									<tr>
										<td width="49%" valign="top">
											<xsl:choose>
												<xsl:when test="substring(.,1,6) = 'previa'">
													<p class="previa">
														<xsl:apply-templates select="."/>
													</p>
												</xsl:when>
												<xsl:otherwise>
													<p class="popolo">
														<xsl:apply-templates select="."/>
													</p>
													<xsl:if test=".=''">
														<br/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td width="2%"/>
										<td width="49%" valign="top">
											<xsl:choose>
												<xsl:when test="substring(../.././oggettoTed/h:div[$divpos],1,15) = 'nach Aussetzung'">
													<p class="previa">
														<xsl:apply-templates select="../.././oggettoTed/h:div[$divpos]"/>
													</p>
												</xsl:when>
												<xsl:otherwise>
													<p class="popolo">
														<xsl:apply-templates select="../.././oggettoTed/h:div[$divpos]"/>
													</p>
													<xsl:if test="../.././oggettoTed/h:div[$divpos]=''">
														<br/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:for-each select="epigrafe/esaminato/h:div">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td width="50%" valign="top">
									<xsl:for-each select="epigrafe/esaminatoTed/h:div">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:for-each select="epigrafe/esaminato/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<tr>
									<td width="49%" valign="top">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</td>
									<td width="2%"/>
									<td width="49%" valign="top">
										<p class="popolo">
											<xsl:apply-templates select="../.././esaminatoTed/h:div[$divpos]"/>
										</p>
										<xsl:if test="../.././esaminatoTed/h:div[$divpos]=''">
											<br/>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:for-each select="epigrafe/visto/h:div">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td width="50%" valign="top">
									<xsl:for-each select="epigrafe/vistoTed/h:div">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:for-each select="epigrafe/visto/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<tr>
									<td width="49%" valign="top">
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</td>
									<td width="2%"/>
									<td width="49%" valign="top">
										<p class="popolo">
											<xsl:apply-templates select="../.././vistoTed/h:div[$divpos]"/>
										</p>
										<xsl:if test="../.././vistoTed/h:div[$divpos]=''">
											<br/>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<!--table width="100%"   cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:for-each select="premessa/h:div">
										<xsl:choose>
											<xsl:when test="substring(.,1,5) = 'FATTO'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:when test="substring(.,1,7) = 'DIRITTO'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>
								<td width="50%" valign="top">
									<xsl:for-each select="premessaTed/h:div">
										<xsl:choose>
											<xsl:when test="substring(.,1,4) = 'SACH'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:when test="substring(.,1,16) = 'RECHTSERWÄGUNGEN'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>
							</tr>
						</table-->
						<!--table width="100%"   cellpadding="10" border="2">
<tr >
<td width="50%" valign="top">
						<table border="1">
							<tr>
								<td valign="top">
									<xsl:for-each select="premessa/h:div">
										<xsl:choose>
											<xsl:when test="substring(.,1,5) = 'FATTO'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:when test="substring(.,1,7) = 'DIRITTO'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>

							</tr>
						</table>
		</td>
		<td width="50%" valign="top">
				<table border="2">
									<tr>

								<td valign="top">
									<xsl:for-each select="premessaTed/h:div">
										<xsl:choose>
											<xsl:when test="substring(.,1,4) = 'SACH'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:when test="substring(.,1,16) = 'RECHTSERWÄGUNGEN'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>
							</tr>
						</table>
		</td>
		</tr>
		</table-->
						<table width="100%">
							<!--xsl:variable name="max" select="count(premessa/h:div)"/>
							<xsl:value-of select="$max"/-->
							<xsl:for-each select="premessa/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<tr>
									<td width="49%" valign="top">
										<xsl:choose>
											<xsl:when test="substring(.,1,5) = 'FATTO'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:when test="substring(.,1,7) = 'DIRITTO'">
												<p class="fatto">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td width="2%"/>
									<td width="49%" valign="top">
										<xsl:choose>
											<xsl:when test="substring(../.././premessaTed/h:div[$divpos],1,4) = 'SACH'">
												<p class="fatto">
													<xsl:apply-templates select="../.././premessaTed/h:div[$divpos]"/>
												</p>
											</xsl:when>
											<xsl:when test="substring(../.././premessaTed/h:div[$divpos],1,16) = 'RECHTSERWÄGUNGEN'">
												<p class="fatto">
													<xsl:apply-templates select="../.././premessaTed/h:div[$divpos]"/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="popolo">
													<xsl:apply-templates select="../.././premessaTed/h:div[$divpos]"/>
												</p>
												<xsl:if test="../.././premessaTed/h:div[$divpos]=''">
													<br/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:for-each select="motivazione/h:div">
										<xsl:if test="position() > 0">
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
											<xsl:if test=".=''">
												<br/>
											</xsl:if>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td width="50%" valign="top">
									<xsl:for-each select="motivazioneTed/h:div">
										<xsl:if test="position() > 0">
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
											<xsl:if test=".=''">
												<br/>
											</xsl:if>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:for-each select="motivazione/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<tr>
									<td width="49%" valign="top">
										<xsl:if test="position() > 0">
											<p class="popolo">
												<xsl:apply-templates select="."/>
											</p>
											<xsl:if test=".=''">
												<br/>
											</xsl:if>
										</xsl:if>
									</td>
									<td width="2%"/>
									<td width="49%" valign="top">
										<xsl:if test="position() > 0">
											<p class="popolo">
												<xsl:apply-templates select="../.././motivazioneTed/h:div[$divpos]"/>
											</p>
											<xsl:if test="../.././premessaTed/h:div[$divpos]=''">
												<br/>
											</xsl:if>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<!--****inizio pqm + dicitura su chi ha emesso daniela -->
						<table width="100%" cellpadding="10">
							<tr>
								<td width="49%">
									<xsl:choose>
										<xsl:when test="(meta/descrittori/processoAmministrativo ='2') and (meta/descrittori/idTipoProvSDM='3' or meta/descrittori/idTipoProvSDM='4' or meta/descrittori/idTipoProvSDM='33' or meta/descrittori/idTipoProvSDM='34')">
											<xsl:for-each select="dispositivo/h:div">
												<xsl:choose>
													<xsl:when test="substring(.,1,6) = 'P.Q.M.'">
														<p class="fatto">PER LE RAGIONI CHE SARANNO ESPOSTE IN
										MOTIVAZIONE</p>
													</xsl:when>
												</xsl:choose>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="dispositivo/h:div">
												<xsl:choose>
													<xsl:when test="substring(.,1,6) = 'P.Q.M.'">
														<p class="fatto">
															<xsl:apply-templates select="."/>
														</p>
													</xsl:when>
												</xsl:choose>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td width="2%"/>
								<td width="49%" valign="top">
									<xsl:choose>
										<xsl:when test="(meta/descrittori/processoAmministrativo ='2') and (meta/descrittori/idTipoProvSDM='3' or meta/descrittori/idTipoProvSDM='4' or meta/descrittori/idTipoProvSDM='33' or meta/descrittori/idTipoProvSDM='34')">
											<xsl:for-each select="dispositivoTed/h:div">
												<xsl:choose>
													<xsl:when test="substring(.,1,6) = 'A.D.G.'">
														<p class="fatto">AUS DEN IN DER BEGRÜNDUNG ANGEFÜHRTEN GRÜNDEN</p>
													</xsl:when>
												</xsl:choose>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="dispositivoTed/h:div">
												<xsl:choose>
													<xsl:when test="substring(.,1,6) = 'A.D.G.'">
														<p class="fatto">
															<xsl:apply-templates select="."/>
														</p>
													</xsl:when>
												</xsl:choose>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
						<!--table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:for-each select="dispositivo/h:div">
										<xsl:choose>
											<xsl:when test="substring(.,1,6) != 'P.Q.M.'">
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</td>
								<td width="50%" valign="top">
									<xsl:for-each select="dispositivoTed/h:div">
										<xsl:choose>
											<xsl:when test="substring(.,1,6) != 'A.D.G.'">
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</td>
							</tr>
						</table-->
						<table width="100%">
							<xsl:for-each select="dispositivo/h:div">
								<xsl:variable name="divpos" select="position()"/>
								<tr>
									<td width="49%" valign="top">
										<xsl:choose>
											<xsl:when test="substring(.,1,6) != 'P.Q.M.'">
												<p class="popolo">
													<xsl:apply-templates select="."/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</td>
									<td width="2%"/>
									<td width="49%" valign="top">
										<xsl:choose>
											<xsl:when test="substring(../.././dispositivoTed/h:div[$divpos],1,6) != 'A.D.G.'">
												<p class="popolo">
													<xsl:apply-templates select="../.././dispositivoTed/h:div[$divpos]"/>
												</p>
												<xsl:if test=".=''">
													<br/>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<!--****fine pqm + dicitura su chi ha emesso daniela -->
						<!--xsl:for-each select="meta/esito/testo">
         	<p class="popolo"><xsl:apply-templates select="."/></p>
         </xsl:for-each-->
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<p class="popolo">
										<xsl:value-of select="sottoscrizioni/dataeluogo/h:i[1]"/>
									</p>
									<p class="popolo">
										<xsl:for-each select="epigrafe/adunanza/h:div">
											<xsl:if test="position() > 4">
												<p class="tabula">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:if>
										</xsl:for-each>
									</p>
								</td>
								<td width="50%" valign="top">
									<p class="popolo">
										<xsl:value-of select="sottoscrizioni/dataeluogo/h:i[1]"/>
									</p>
									<p class="popolo">
										<xsl:for-each select="epigrafe/adunanzaTed/h:div">
											<xsl:if test="position() > 4">
												<p class="tabula">
													<xsl:apply-templates select="."/>
												</p>
											</xsl:if>
										</xsl:for-each>
									</p>
								</td>
							</tr>
						</table>
						<p/>
						<p/>
						<p/>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:choose>
										<!--*****************************da qui gestisco timbro nuovo processo-->
										<xsl:when test="meta/descrittori/processoAmministrativo ='2' and epigrafe/adunanza/h:div[2]!='in sede giurisdizionale (Adunanza Plenaria)'">
											<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
													</td>
													<td/>
												</tr>
												<xsl:if test="meta/@versionePDF='1'">
													<tr>
														<td>
															<xsl:for-each select="epigrafe/adunanza/h:div">
																<xsl:if test="contains(.,'Estensore')  or contains(.,'Verfasser')">
																	<xsl:value-of select="substring-before(.,',')"/>
																</xsl:if>
															</xsl:for-each>
														</td>
														<td/>
													</tr>
												</xsl:if>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
													</td>
												</tr>
												<xsl:if test="meta/@versionePDF='1'">
													<tr>
														<td>
															<xsl:for-each select="epigrafe/adunanza/h:div">
																<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																	<xsl:value-of select="substring-before(.,',')"/>
																</xsl:if>
															</xsl:for-each>
														</td>
													</tr>
												</xsl:if>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
											</table>
											<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
							<p class="fatto">Il Segretario</p>
							<p class="fatto">(ai sensi dell'art. 89, co. 3, cod. proc. amm.)</p>
							<br/>
							<p class="fatto">______________________</p>
							<br/>
							<p class="fatto">IL DIRIGENTE</p>
							<br/>
							<br/>
						</xsl:if-->
											<xsl:choose>
												<xsl:when test="meta/@versionePDF='1'">
													<p class="fatto">IL SEGRETARIO</p>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
															<p class="fatto">DEPOSITATO IN SEGRETERIA</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="fatto">DEPOSITATA IN SEGRETERIA</p>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="meta/dataPubblicazione!=''">
															<p class="fatto">
									Il <xsl:value-of select="meta/dataPubblicazione"/>
															</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="fatto"> Il ___________________</p>
														</xsl:otherwise>
													</xsl:choose>
													<!-- inizio modifica articoli del timbro firma daniela-->
													<xsl:choose>
														<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
															<xsl:choose>
																<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																	<xsl:choose>
																		<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																			<p class="fatto">(Art. 119, co. 5, cod. proc.
												amm.)</p>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:choose>
																		<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																			<p class="fatto">(Art. 120, co. 9, cod. proc.
												amm.)</p>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:choose>
																		<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																			<p class="fatto">(art. 130, co. 7, cod. proc. amm.)</p>
																		</xsl:when>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																	<p class="fatto">(Art. 23 bis, comma 6, L. 6/12/1971, n.
											1034)</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
													<!-- fine modifica articoli del timbro firma daniela-->
													<xsl:choose>
														<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
															<p class="fatto">IL SEGRETARIO</p>
															<p class="fatto">(Art. 89, co. 3, cod. proc. amm.)</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="fatto">IL SEGRETARIO</p>
															<p class="fatto">(Art. 89, co. 3, cod. proc. amm.)</p>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<!-- *************************fine timbro nuovo processo-->
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
													<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td colspan="3">
																<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
															</td>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="contains(.,'Estensore') or contains(.,'Verfasser')">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>
																<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
															</td>
															<td/>
															<td>IL SEGRETARIO</td>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
																<td>
		</td>
																<td/>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
													</table>
													<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
									<p class="fatto">Il Segretario</p><br/>
									</xsl:if-->
													<xsl:choose>
														<xsl:when test="meta/@versionePDF='1' and epigrafe/adunanza/h:div[2]!='in sede giurisdizionale (Adunanza Plenaria)'">
															<p class="fatto">IL SEGRETARIO</p>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																	<p class="fatto">DEPOSITATO IN SEGRETERIA</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">DEPOSITATA IN SEGRETERIA</p>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:choose>
																<xsl:when test="meta/dataPubblicazione!=''">
																	<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">Il ___________________</p>
																</xsl:otherwise>
															</xsl:choose>
															<!-- inizio modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3') ">
																					<p class="fatto">(Art. 119, co. 5, cod. proc.	amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																					<p class="fatto">(Art. 120, co. 9, cod. proc.	amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																					<p class="fatto">(art. 130, co. 7, cod. proc. amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:when>
																		<xsl:otherwise>
																			<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																			<xsl:choose>
																				<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
																					<p class="fatto">(Art. 89, co. 3, cod. proc. amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																			<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
																		</xsl:when>
																		<xsl:otherwise>
																			<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
															</xsl:choose>
															<!-- fine modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
																	<p class="fatto">Il Dirigente della Sezione</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">IL SEGRETARIO</p>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>
																<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
															</td>
															<td/>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="contains(.,'Estensore') or contains(.,'Verfasser')">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
																<td/>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>
																<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
															</td>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
													</table>
													<xsl:choose>
														<xsl:when test="meta/@versionePDF='1'">
															<p class="fatto">IL SEGRETARIO</p>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
																<p class="fatto">Il Segretario</p>
																<br/>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																	<p class="fatto">DEPOSITATO IN SEGRETERIA</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">DEPOSITATA IN SEGRETERIA</p>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:choose>
																<xsl:when test="meta/dataPubblicazione!=''">
																	<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">Il ___________________</p>
																</xsl:otherwise>
															</xsl:choose>
															<!-- inizio modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																					<p class="fatto">(Art. 119, co. 5, cod. proc.
												amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																					<p class="fatto">(Art. 120, co. 9, cod. proc.
												amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																					<p class="fatto">(art. 130, co. 7, cod. proc. amm.)</p>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:when>
																		<xsl:otherwise>
																			<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																			<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
																		</xsl:when>
																		<xsl:otherwise>
																			<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
															</xsl:choose>
															<!-- fine modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
																	<p class="fatto">Il Dirigente della Sezione</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">IL SEGRETARIO</p>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td width="50%" valign="top">
									<xsl:choose>
										<!--*****************************da qui gestisco timbro nuovo processo-->
										<xsl:when test="meta/descrittori/processoAmministrativo ='2' and epigrafe/adunanza/h:div[2]!='in sede giurisdizionale (Adunanza Plenaria)'">
											<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="sottoscrizioniTed/sottoscrivente[2]/h:div[1]"/>
													</td>
													<td/>
												</tr>
												<xsl:if test="meta/@versionePDF='1'">
													<tr>
														<td>
															<xsl:for-each select="epigrafe/adunanza/h:div">
																<xsl:if test="(contains(.,'Estensore')  or contains(.,'Verfasser') )">
																	<xsl:value-of select="substring-before(.,',')"/>
																</xsl:if>
															</xsl:for-each>
														</td>
														<td/>
													</tr>
												</xsl:if>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="sottoscrizioniTed/sottoscrivente[1]/h:div[1]"/>
													</td>
												</tr>
												<xsl:if test="meta/@versionePDF='1'">
													<tr>
														<td>
															<xsl:for-each select="epigrafe/adunanza/h:div">
																<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																	<xsl:value-of select="substring-before(.,',')"/>
																</xsl:if>
															</xsl:for-each>
														</td>
													</tr>
												</xsl:if>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
												<tr>
													<td>&#160;</td>
													<td/>
													<td/>
												</tr>
											</table>
											<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
							<p class="fatto">Il Segretario</p>
							<p class="fatto">(ai sensi dell'art. 89, co. 3, cod. proc. amm.)</p>
							<br/>
							<p class="fatto">______________________</p>
							<br/>
							<p class="fatto">IL DIRIGENTE</p>
							<br/>
							<br/>
						</xsl:if-->
											<xsl:choose>
												<xsl:when test="meta/@versionePDF='1'">
													<p class="fatto">DER GENERALSEKRETÄR</p>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
															<p class="fatto">IM SEKRETARIAT</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="fatto">IM SEKRETARIAT</p>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="meta/dataPubblicazione!=''">
															<p class="fatto">
									Il <xsl:value-of select="meta/dataPubblicazione"/>
															</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="fatto"> Am___________________</p>
															<p class="fatto"> HINTERLEGT</p>
														</xsl:otherwise>
													</xsl:choose>
													<!-- inizio modifica articoli del timbro firma daniela-->
													<xsl:choose>
														<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
															<xsl:choose>
																<xsl:when test="epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCH' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																	<xsl:choose>
																		<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																			<p class="fatto">(Art. 119, Abs. 5, VwPO)</p>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:choose>
																		<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																			<p class="fatto">(Art. 120, Abs. 9, VwPO)</p>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:choose>
																		<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																			<p class="fatto">(Art. 130, Abs. 7, VwPO)</p>
																		</xsl:when>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																	<p class="fatto">(Art. 23 bis, comma 6, L. 6/12/1971, n.
											1034)</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
													<!-- fine modifica articoli del timbro firma daniela-->
													<xsl:choose>
														<xsl:when test="epigrafe/adunanzaTed/h:div[1]='Il Consiglio di Stato'">
															<p class="fatto">DER GENERALSEKRETÄR</p>
															<p class="fatto">(Art. 89, Abs. 3, VwPO)</p>
														</xsl:when>
														<xsl:otherwise>
															<p class="fatto">DER GENERALSEKRETÄR</p>
															<p class="fatto">(Art. 89, Abs. 3, VwPO)</p>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<!-- *************************fine timbro nuovo processo-->
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="epigrafe/adunanzaTed/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
													<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td colspan="3">
																<xsl:value-of select="sottoscrizioniTed/sottoscrivente[1]/h:div[1]"/>
															</td>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="(contains(.,'Estensore') or contains(.,'Verfasser') )">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>
																<xsl:value-of select="sottoscrizioniTed/sottoscrivente[2]/h:div[1]"/>
															</td>
															<td/>
															<td>DER GENERALSEKRETÄR</td>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
																<td/>
																<td/>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
													</table>
													<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
									<p class="fatto">Il Segretario</p><br/>
									</xsl:if-->
													<xsl:choose>
														<xsl:when test="meta/@versionePDF='1'">
															<p class="fatto">DER GENERALSEKRETÄR</p>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																	<p class="fatto">IM SEKRETARIAT</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">IM SEKRETARIAT</p>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:choose>
																<xsl:when test="meta/dataPubblicazione!=''">
																	<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">Am ___________________</p>
																	<p class="fatto">HINTERLEGT</p>
																</xsl:otherwise>
															</xsl:choose>
															<!-- inizio modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3') ">
																					<p class="fatto">(Art. 119, Abs. 5, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																					<p class="fatto">(Art. 120, Abs. 9, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																					<p class="fatto">(Art. 130, Abs. 7, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:when>
																		<xsl:otherwise>
																			<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																			<xsl:choose>
																				<xsl:when test="epigrafe/adunanzaTed/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
																					<p class="fatto">(Art. 89, Abs. 3, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																			<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
																		</xsl:when>
																		<xsl:otherwise>
																			<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
															</xsl:choose>
															<!-- fine modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="epigrafe/adunanzaTed/h:div[1]='Il Consiglio di Stato'">
																	<p class="fatto">DER GENERALSEKRETÄR</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">DER GENERALSEKRETÄR</p>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>
																<xsl:value-of select="sottoscrizioniTed/sottoscrivente[2]/h:div[1]"/>
															</td>
															<td/>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="(contains(.,'Estensore')  or contains(.,'Verfasser') )">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
																<td/>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>
																<xsl:value-of select="sottoscrizioniTed/sottoscrivente[1]/h:div[1]"/>
															</td>
														</tr>
														<xsl:if test="meta/@versionePDF='1'">
															<tr>
																<td>
																	<xsl:for-each select="epigrafe/adunanza/h:div">
																		<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																			<xsl:value-of select="substring-before(.,',')"/>
																		</xsl:if>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:if>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
														<tr>
															<td>&#160;</td>
															<td/>
															<td/>
														</tr>
													</table>
													<xsl:choose>
														<xsl:when test="meta/@versionePDF='1'">
															<p class="fatto">DER GENERALSEKRETÄR</p>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="epigrafe/adunanzaTed/h:div[1]='Il Consiglio di Stato'">
																<p class="fatto">DER GENERALSEKRETÄR</p>
																<br/>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
																	<p class="fatto">IM SEKRETARIAT</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">IM SEKRETARIAT</p>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:choose>
																<xsl:when test="meta/dataPubblicazione!=''">
																	<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">Am ___________________</p>
																	<p class="fatto">HINTERLEGT</p>
																</xsl:otherwise>
															</xsl:choose>
															<!-- inizio modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																					<p class="fatto">(Art. 119, Abs. 5, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																					<p class="fatto">(Art. 120, Abs. 9, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																			<xsl:choose>
																				<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																					<p class="fatto">(Art. 130, Abs. 7, VwPO)</p>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:when>
																		<xsl:otherwise>
																			<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="epigrafe/adunanzaTed/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanzaTed/h:div[4]='URTEILSSPRUCHS'">
																			<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
																		</xsl:when>
																		<xsl:otherwise>
																			<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
															</xsl:choose>
															<!-- fine modifica articoli del timbro firma daniela-->
															<xsl:choose>
																<xsl:when test="epigrafe/adunanzaTed/h:div[1]='Il Consiglio di Stato'">
																	<p class="fatto">DER GENERALSEKRETÄR</p>
																</xsl:when>
																<xsl:otherwise>
																	<p class="fatto">DER GENERALSEKRETÄR</p>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
						<!--*****************************fino a qui gestisco timbro nuovo processo-->
						<br/>
						<br/>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:if test="meta/redazionale/nota/h:div!=''">
										<p class="calce">
											<xsl:for-each select="meta/redazionale/nota/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
								<td width="50%" valign="top">
									<xsl:if test="meta/redazionaleTed/nota/h:div!=''">
										<p class="calce">
											<xsl:for-each select="meta/redazionaleTed/nota/h:div">
												<xsl:apply-templates select="."/>
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
								</td>
							</tr>
						</table>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:if test="sottoscrizioni/sottoscrivente[4]/h:div[1]!=''">
										<table align="center">
											<tr>
												<td colspan="2">
													<br/>
													<br/>
													<br/>
													<br/>
													<br/>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="fatto">
														<xsl:value-of select="sottoscrizioni/sottoscrivente[4]/h:div[1]"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="fatto">
														<xsl:value-of select="sottoscrizioni/sottoscrivente[5]/h:div[1]"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="popolo">
														<xsl:value-of select="sottoscrizioni/sottoscrivente[6]/h:div[1]"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="dirigente">
														<xsl:value-of select="sottoscrizioni/sottoscrivente[7]/h:div[1]"/>
													</p>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td width="50%" valign="top">
									<xsl:if test="sottoscrizioniTed/sottoscrivente[4]/h:div[1]!=''">
										<table align="center">
											<tr>
												<td colspan="2">
													<br/>
													<br/>
													<br/>
													<br/>
													<br/>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="fatto">
														<xsl:value-of select="sottoscrizioniTed/sottoscrivente[4]/h:div[1]"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="fatto">
														<xsl:value-of select="sottoscrizioniTed/sottoscrivente[5]/h:div[1]"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="popolo">
														<xsl:value-of select="sottoscrizioniTed/sottoscrivente[6]/h:div[1]"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<p class="dirigente">
														<xsl:value-of select="sottoscrizioniTed/sottoscrivente[7]/h:div[1]"/>
													</p>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</tr>
						</table>
						<table width="100%" cellpadding="10">
							<tr>
								<td width="50%" valign="top">
									<xsl:choose>
										<!-- ATTENZIONE: inserito processoAmministrativo ='3' per eliminarlo in previsione di doverlo rimettere a 2 :) -->
										<xsl:when test="meta/descrittori/processoAmministrativo ='3'">
											<table align="left">
												<tr>
													<td>
														<p class="fattopicc">Addi'_________________ copia conforme del
										presente provvedimento e' trasmessa a:</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="fatto">___________________________________________________________</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="fatto">___________________________________________________________</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="fatto">___________________________________________________________</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="dirigente">IL FUNZIONARIO </p>
													</td>
												</tr>
											</table>
										</xsl:when>
									</xsl:choose>
								</td>
								<td width="50%" valign="top">
									<xsl:choose>
										<!-- ATTENZIONE: inserito processoAmministrativo ='3' per eliminarlo in previsione di doverlo rimettere a 2 :) -->
										<xsl:when test="meta/descrittori/processoAmministrativo ='3'">
											<table align="left">
												<tr>
													<td>
														<p class="fattopicc">Addi'_________________ copia conforme del
										presente provvedimento e' trasmessa a:</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="fatto">___________________________________________________________</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="fatto">___________________________________________________________</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="fatto">___________________________________________________________</p>
													</td>
												</tr>
												<tr>
													<td>
														<p class="dirigente">IL FUNZIONARIO </p>
													</td>
												</tr>
											</table>
										</xsl:when>
									</xsl:choose>
								</td>
							</tr>
						</table>
					</body>
				</xsl:when>
				<xsl:when test="(meta/descrittori/lingua ='D' and meta/descrittori/bilingue='N') ">
					<head>
						<xsl:choose>
							<xsl:when test="meta/@versionePDF='1' and meta/dataPubblicazione!=''">
									Pubblicato il <xsl:value-of select="meta/dataPubblicazione"/>
							</xsl:when>
							<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
								<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.RIC.A.P.</title>
							</xsl:when>
							<xsl:otherwise>
								<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.REK.</title>
							</xsl:otherwise>
						</xsl:choose>
						<link rel="stylesheet" type="text/css" href="Provvedimento.css"/>
					</head>
					<body class="corpo">
						<p class="registri">N. <xsl:value-of select="meta/descrittori/fascicolo/@n"/>/<xsl:value-of select="meta/descrittori/fascicolo/@anno"/>
							<!--****dal 2011 cambiano i registri e quindi anche le relative etichette -->
							<xsl:choose>
								<xsl:when test="substring((substring-after((substring-after(meta/@modifica,'/')),'/')),0,5) &lt; '2011'">
									<xsl:if test="epigrafe/adunanza/h:div[4]='SENTENZA'"> REG.SEN.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='URTEILSSPRUCH'">REG.DISP.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DECISIONE'">REG.SEN.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='URTEILSSPRUCH'">REG.DISP.</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="epigrafe/adunanza/h:div[4]='SENTENZA'"> REG.KOLL.BESCHL</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='URTEILSSPRUCH'">REG.KOLL.BESCHL</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DECISIONE'">REG.KOLL.BESCHL</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='URTEILSSPRUCH'">REG.KOLL.BESCHL</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</p>
						<xsl:choose>
							<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
								<xsl:for-each select="meta/descrittori/registro">
									<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.RIC.A.P.</p>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="meta/descrittori/registro">
									<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.REK.</p>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						<p class="repubblica">
							<img border="0" src="stemma.jpg"/>
						</p>
						<p class="repubblica">REPUBLIK ITALIEN</p>
						<p class="innome">IM NAMEN DES ITALIENISCHEN VOLKES</p>
						<p class="sezione">
							<xsl:value-of select="epigrafe/adunanza/h:div[1]"/>
						</p>
						<p class="sezione">
							<xsl:value-of select="epigrafe/adunanza/h:div[2]"/>
						</p>
						<p class="tabula">
							<xsl:value-of select="epigrafe/adunanza/h:div[3]"/>
						</p>
						<!-- inizio nuovo processo daniela  -->
						<xsl:choose>
							<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
								<xsl:choose>
									<xsl:when test="epigrafe/adunanza/h:div[4]='DECISIONE' or epigrafe/adunanza/h:div[4]='URTEIL'">
										<xsl:choose>
											<xsl:when test="(meta/descrittori/idTipoProvSDM='1' and meta/descrittori/idSpecificaSDM='9') or(meta/descrittori/idTipoProvSDM='2' and meta/descrittori/idSpecificaSDM='8') ">
												<p class="sezione">NICHT ENDGÜLTIGES URTEIL </p>
											</xsl:when>
											<xsl:otherwise>
												<p class="sezione">URTEIL</p>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">
										<p class="sezione">URTEILSSPRUCHS</p>
									</xsl:when>
									<xsl:otherwise>
										<p class="sezione">
											<xsl:value-of select="epigrafe/adunanza/h:div[4]"/>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<p class="sezione">
									<xsl:value-of select="epigrafe/adunanza/h:div[4]"/>
								</p>
							</xsl:otherwise>
						</xsl:choose>
						<!--	fine nuovo processo daniela -->
						<p class="popolo">
							<xsl:for-each select="epigrafe/ricorrenti/h:div">
								<xsl:apply-templates select="."/>
								<br/>
							</xsl:for-each>
						</p>
						<xsl:if test="epigrafe/resistenti/h:div!=''">
							<p class="contro">gegen</p>
							<p class="popolo">
								<xsl:for-each select="epigrafe/resistenti/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:if test="epigrafe/altro/controinteressati/h:div!=''">
							<p class="contro">und gegen</p>
							<p class="popolo">
								<xsl:for-each select="epigrafe/altro/controinteressati/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:if test="epigrafe/altro/intervenienti/h:div!=''">
							<p class="contro">und mit dem</p>
							<p class="popolo">
								<xsl:for-each select="epigrafe/altro/intervenienti/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:for-each select="epigrafe/riuniti">
							<br/>
							<br/>
							<p class="popolo">
								<xsl:for-each select="ricorrenti/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
							<xsl:if test="resistenti/h:div!=''">
								<p class="contro">gegen</p>
								<p class="popolo">
									<xsl:for-each select="resistenti/h:div">
										<xsl:apply-templates select="."/>
										<br/>
									</xsl:for-each>
								</p>
							</xsl:if>
							<xsl:if test="altro/controinteressati/h:div!=''">
								<p class="contro">und gegen</p>
								<p class="popolo">
									<xsl:for-each select="altro/controinteressati/h:div">
										<xsl:apply-templates select="."/>
										<br/>
									</xsl:for-each>
								</p>
							</xsl:if>
							<xsl:if test="altro/intervenienti/h:div!=''">
								<p class="contro">und mit dem</p>
								<p class="popolo">
									<xsl:for-each select="altro/intervenienti/h:div">
										<xsl:apply-templates select="."/>
										<br/>
									</xsl:for-each>
								</p>
							</xsl:if>
						</xsl:for-each>
						<p class="contro">
							<xsl:value-of select="epigrafe/oggetto/h:div[1]"/>
						</p>
						<xsl:for-each select="epigrafe/oggetto/h:div">
							<xsl:if test="position() > 1">
								<xsl:choose>
									<xsl:when test="substring(.,1,15) = 'nach Aussetzung'">
										<p class="previa">
											<xsl:apply-templates select="."/>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="epigrafe/esaminato/h:div">
							<p class="popolo">
								<xsl:apply-templates select="."/>
							</p>
							<xsl:if test=".=''">
								<br/>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="epigrafe/visto/h:div">
							<p class="popolo">
								<xsl:apply-templates select="."/>
							</p>
							<xsl:if test=".=''">
								<br/>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="premessa/h:div">
							<xsl:choose>
								<xsl:when test="substring(.,1,4) = 'SACH'">
									<p class="fatto">
										<xsl:apply-templates select="."/>
									</p>
								</xsl:when>
								<xsl:when test="substring(.,1,16) = 'RECHTSERWÄGUNGEN'">
									<p class="fatto">
										<xsl:apply-templates select="."/>
									</p>
								</xsl:when>
								<xsl:otherwise>
									<p class="popolo">
										<xsl:apply-templates select="."/>
									</p>
									<xsl:if test=".=''">
										<br/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="motivazione/h:div">
							<xsl:if test="position() > 0">
								<p class="popolo">
									<xsl:apply-templates select="."/>
								</p>
								<xsl:if test=".=''">
									<br/>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<!--****inizio pqm + dicitura su chi ha emesso daniela -->
						<xsl:choose>
							<xsl:when test="(meta/descrittori/processoAmministrativo ='2') and (meta/descrittori/idTipoProvSDM='3' or meta/descrittori/idTipoProvSDM='4' or meta/descrittori/idTipoProvSDM='33' or meta/descrittori/idTipoProvSDM='34')">
								<xsl:for-each select="dispositivo/h:div">
									<xsl:choose>
										<xsl:when test="substring(.,1,6) = 'A.D.G.'">
											<p class="fatto">AUS DEN IN DER BEGRÜNDUNG ANGEFÜHRTEN GRÜNDEN</p>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="dispositivo/h:div">
									<xsl:choose>
										<xsl:when test="substring(.,1,6) = 'A.D.G.'">
											<p class="fatto">
												<xsl:apply-templates select="."/>
											</p>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="dispositivo/h:div">
							<xsl:choose>
								<xsl:when test="substring(.,1,6) != 'A.D.G.'">
									<p class="popolo">
										<xsl:apply-templates select="."/>
									</p>
									<xsl:if test=".=''">
										<br/>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<!--****fine pqm + dicitura su chi ha emesso daniela -->
						<!--xsl:for-each select="meta/esito/testo">
         	<p class="popolo"><xsl:apply-templates select="."/></p>
         </xsl:for-each-->
						<p class="popolo">
							<xsl:value-of select="sottoscrizioni/dataeluogo/h:i[1]"/>
						</p>
						<p class="popolo">
							<xsl:for-each select="epigrafe/adunanza/h:div">
								<xsl:if test="position() > 4">
									<p class="tabula">
										<xsl:apply-templates select="."/>
									</p>
								</xsl:if>
							</xsl:for-each>
						</p>
						<p/>
						<p/>
						<p/>
						<xsl:choose>
							<!--*****************************da qui gestisco timbro nuovo processo-->
							<xsl:when test="meta/descrittori/processoAmministrativo ='2' and epigrafe/adunanza/h:div[2]!='in sede giurisdizionale (Adunanza Plenaria)'">
								<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
										</td>
										<td/>
										<td>
											<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
										</td>
									</tr>
									<xsl:if test="meta/@versionePDF='1'">
										<tr>
											<td>
												<xsl:for-each select="epigrafe/adunanza/h:div">
													<xsl:if test="(contains(.,'Estensore') or contains(.,'Verfasser'))">
														<xsl:value-of select="substring-before(.,',')"/>
													</xsl:if>
												</xsl:for-each>
											</td>
											<td/>
											<td>
												<xsl:for-each select="epigrafe/adunanza/h:div">
													<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
														<xsl:value-of select="substring-before(.,',')"/>
													</xsl:if>
												</xsl:for-each>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
								</table>
								<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
							<p class="fatto">Il Segretario</p>
							<p class="fatto">(ai sensi dell'art. 89, co. 3, cod. proc. amm.)</p>
							<br/>
							<p class="fatto">______________________</p>
							<br/>
							<p class="fatto">IL DIRIGENTE</p>
							<br/>
							<br/>
						</xsl:if-->
								<xsl:choose>
									<xsl:when test="meta/@versionePDF='1'">
										<p class="fatto">DER GENERALSEKRETÄR</p>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
												<p class="fatto">IM SEKRETARIAT</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="fatto">IM SEKRETARIAT</p>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="meta/dataPubblicazione!=''">
												<p class="fatto">
									Il <xsl:value-of select="meta/dataPubblicazione"/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="fatto"> Am ___________________</p>
												<p class="fatto"> HINTERLEGT</p>
											</xsl:otherwise>
										</xsl:choose>
										<!-- inizio modifica articoli del timbro firma daniela-->
										<xsl:choose>
											<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
														<xsl:choose>
															<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																<p class="fatto">(AArt. 119, Abs. 5 VwPO)</p>
															</xsl:when>
														</xsl:choose>
														<xsl:choose>
															<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																<p class="fatto">(AArt. 120, Abs. 9 VwPO)</p>
															</xsl:when>
														</xsl:choose>
														<xsl:choose>
															<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																<p class="fatto">(Art. 130, Abs. 7 VwPO)</p>
															</xsl:when>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
														<p class="fatto">(Art. 23 bis, comma 6, L. 6/12/1971, n.
											1034)</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
										<!-- fine modifica articoli del timbro firma daniela-->
										<xsl:choose>
											<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
												<p class="fatto">DER GENERALSEKRETÄR</p>
												<p class="fatto">(Art. 89, Abs. 3 VwPO)</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="fatto">DER GENERALSEKRETÄR</p>
												<p class="fatto">(Art. 89, Abs. 3 VwPO)</p>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- *************************fine timbro nuovo processo-->
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
										<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td colspan="3">
													<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
												</td>
											</tr>
											<xsl:if test="meta/@versionePDF='1'">
												<tr>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="contains(.,'Estensore') or contains(.,'Verfasser')">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
												</td>
												<td/>
												<td>DER GENERALSEKRETÄR</td>
											</tr>
											<xsl:if test="meta/@versionePDF='1'">
												<tr>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
													<td/>
													<td/>
												</tr>
											</xsl:if>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
										</table>
										<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
									<p class="fatto">Il Segretario</p><br/>
									</xsl:if-->
										<xsl:choose>
											<xsl:when test="meta/@versionePDF='1'">
												<p class="fatto">DER GENERALSEKRETÄR</p>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
														<p class="fatto">IM SEKRETARIAT</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">IM SEKRETARIAT</p>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="meta/dataPubblicazione!=''">
														<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
														</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">Am ___________________</p>
														<p class="fatto">HINTERLEGT</p>
													</xsl:otherwise>
												</xsl:choose>
												<!-- inizio modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3') ">
																		<p class="fatto">(Art. 119, Abs. 5 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																		<p class="fatto">(Art. 120, Abs. 9 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																		<p class="fatto">(Art. 130, Abs. 7 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
															</xsl:when>
															<xsl:otherwise>
																<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																<xsl:choose>
																	<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
																		<p class="fatto">(Art. 89, Abs. 3 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
																<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
															</xsl:when>
															<xsl:otherwise>
																<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												<!-- fine modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
														<p class="fatto">DER GENERALSEKRETÄR</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">DER GENERALSEKRETÄR</p>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
												</td>
												<td/>
												<td>
													<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
												</td>
											</tr>
											<xsl:if test="meta/@versionePDF='1'">
												<tr>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="contains(.,'Estensore') or contains(.,'Verfasser')">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
													<td/>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
										</table>
										<xsl:choose>
											<xsl:when test="meta/@versionePDF='1'">
												<p class="fatto">DER GENERALSEKRETÄR</p>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
													<p class="fatto">DER GENERALSEKRETÄR</p>
													<br/>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
														<p class="fatto">IM SEKRETARIAT</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">IM SEKRETARIAT</p>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="meta/dataPubblicazione!=''">
														<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
														</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">Am ___________________</p>
														<p class="fatto">HINTERLEGT</p>
													</xsl:otherwise>
												</xsl:choose>
												<!-- inizio modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																		<p class="fatto">(Art. 119, Abs. 5 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																		<p class="fatto">(Art. 120, Abs. 9 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																		<p class="fatto">(Art. 130, Abs. 7 VwPO)</p>
																	</xsl:when>
																</xsl:choose>
															</xsl:when>
															<xsl:otherwise>
																<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='URTEILSSPRUCHS'">
																<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
															</xsl:when>
															<xsl:otherwise>
																<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												<!-- fine modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
														<p class="fatto">DER GENERALSEKRETÄR</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">DER GENERALSEKRETÄR</p>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						<!--*****************************fino a qui gestisco timbro nuovo processo-->
						<xsl:choose>
							<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)' and meta/descrittori/processoAmministrativo ='1'">
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">CONSIGLIO DI STATO</p>
								<p class="sezione">In Sede Giurisdizionale (Adunanza Plenaria)</p>
								<p class="fatto">Addi'............................copia conforme alla
							presente e' stata trasmessa</p>
								<p class="fatto">a
							............................................................................................................................</p>
								<p class="fatto">a norma dell'art. 87 del Regolamento di Procedura 17 agosto
							1907 n.642</p>
								<p class="fatto">Il Direttore della Segreteria</p>
							</xsl:when>
						</xsl:choose>
						<br/>
						<br/>
						<xsl:if test="meta/redazionale/nota/h:div!=''">
							<p class="calce">
								<xsl:for-each select="meta/redazionale/nota/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:if test="sottoscrizioni/sottoscrivente[4]/h:div[1]!=''">
							<table align="center">
								<tr>
									<td colspan="2">
										<br/>
										<br/>
										<br/>
										<br/>
										<br/>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="fatto">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[4]/h:div[1]"/>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="fatto">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[5]/h:div[1]"/>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="popolo">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[6]/h:div[1]"/>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="dirigente">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[7]/h:div[1]"/>
										</p>
									</td>
								</tr>
							</table>
						</xsl:if>
						<xsl:choose>
							<!-- ATTENZIONE: inserito processoAmministrativo ='3' per eliminarlo in previsione di doverlo rimettere a 2 :) -->
							<xsl:when test="meta/descrittori/processoAmministrativo ='3'">
								<table align="left">
									<tr>
										<td>
											<p class="fattopicc">Addi'_________________ copia conforme del
										presente provvedimento e' trasmessa a:</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="fatto">___________________________________________________________</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="fatto">___________________________________________________________</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="fatto">___________________________________________________________</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="dirigente">IL FUNZIONARIO </p>
										</td>
									</tr>
								</table>
							</xsl:when>
						</xsl:choose>
					</body>
				</xsl:when>
				<xsl:otherwise>
					<head>
						<xsl:choose>
							<xsl:when test="meta/@versionePDF='1' and meta/dataPubblicazione!=''">
									Pubblicato il <xsl:value-of select="meta/dataPubblicazione"/>
							</xsl:when>
							<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
								<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.RIC.A.P.</title>
							</xsl:when>
							<xsl:otherwise>
								<title>N. <xsl:value-of select="meta/descrittori/registro/@n"/>/<xsl:value-of select="meta/descrittori/registro/@anno"/>
							REG.RIC.</title>
							</xsl:otherwise>
						</xsl:choose>
						<link rel="stylesheet" type="text/css" href="Provvedimento.css"/>
					</head>
					<body class="corpo">
						<p class="registri">N. <xsl:value-of select="meta/descrittori/fascicolo/@n"/>/<xsl:value-of select="meta/descrittori/fascicolo/@anno"/>
							<!--****dal 2011 cambiano i registri e quindi anche le relative etichette -->
							<xsl:choose>
								<xsl:when test="substring((substring-after((substring-after(meta/@modifica,'/')),'/')),0,5) &lt; '2011'">
									<xsl:if test="epigrafe/adunanza/h:div[4]='SENTENZA'"> REG.SEN.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">REG.DISP.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DECISIONE'">REG.SEN.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">REG.DISP.</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="epigrafe/adunanza/h:div[4]='SENTENZA'"> REG.PROV.COLL.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">REG.PROV.COLL.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DECISIONE'">REG.PROV.COLL.</xsl:if>
									<xsl:if test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">REG.PROV.COLL.</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</p>
						<xsl:choose>
							<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
								<xsl:for-each select="meta/descrittori/registro">
									<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.RIC.A.P.</p>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="meta/descrittori/registro">
									<p class="registri">N. <xsl:value-of select="@n"/>/<xsl:value-of select="@anno"/> REG.RIC.</p>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						<p class="repubblica">
							<img border="0" src="stemma.jpg"/>
						</p>
						<p class="repubblica">REPUBBLICA ITALIANA</p>
						<p class="innome">IN NOME DEL POPOLO ITALIANO</p>
						<p class="sezione">
							<xsl:value-of select="epigrafe/adunanza/h:div[1]"/>
						</p>
						<p class="sezione">
							<xsl:value-of select="epigrafe/adunanza/h:div[2]"/>
						</p>
						<p class="tabula">
							<xsl:value-of select="epigrafe/adunanza/h:div[3]"/>
						</p>
						<!-- inizio nuovo processo daniela  -->
						<xsl:choose>
							<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
								<xsl:choose>
									<xsl:when test="epigrafe/adunanza/h:div[4]='DECISIONE' or epigrafe/adunanza/h:div[4]='SENTENZA'">
										<xsl:choose>
											<xsl:when test="(meta/descrittori/idTipoProvSDM='1' and meta/descrittori/idSpecificaSDM='9') or(meta/descrittori/idTipoProvSDM='2' and meta/descrittori/idSpecificaSDM='8') ">
												<p class="sezione">SENTENZA NON DEFINITIVA</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="sezione">SENTENZA</p>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE'">
										<p class="sezione">DISPOSITIVO DI SENTENZA</p>
									</xsl:when>
									<xsl:otherwise>
										<p class="sezione">
											<xsl:value-of select="epigrafe/adunanza/h:div[4]"/>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<p class="sezione">
									<xsl:value-of select="epigrafe/adunanza/h:div[4]"/>
								</p>
							</xsl:otherwise>
						</xsl:choose>
						<!--	fine nuovo processo daniela -->
						<p class="popolo">
							<xsl:for-each select="epigrafe/ricorrenti/h:div">
								<xsl:apply-templates select="."/>
								<br/>
							</xsl:for-each>
						</p>
						<xsl:if test="epigrafe/resistenti/h:div!=''">
							<p class="contro">contro</p>
							<p class="popolo">
								<xsl:for-each select="epigrafe/resistenti/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:if test="epigrafe/altro/controinteressati/h:div!=''">
							<p class="contro">nei confronti</p>
							<p class="popolo">
								<xsl:for-each select="epigrafe/altro/controinteressati/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:if test="epigrafe/altro/intervenienti/h:div!=''">
							<p class="contro">e con l'intervento di</p>
							<p class="popolo">
								<xsl:for-each select="epigrafe/altro/intervenienti/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:for-each select="epigrafe/riuniti">
							<br/>
							<br/>
							<p class="popolo">
								<xsl:for-each select="ricorrenti/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
							<xsl:if test="resistenti/h:div!=''">
								<p class="contro">contro</p>
								<p class="popolo">
									<xsl:for-each select="resistenti/h:div">
										<xsl:apply-templates select="."/>
										<br/>
									</xsl:for-each>
								</p>
							</xsl:if>
							<xsl:if test="altro/controinteressati/h:div!=''">
								<p class="contro">nei confronti</p>
								<p class="popolo">
									<xsl:for-each select="altro/controinteressati/h:div">
										<xsl:apply-templates select="."/>
										<br/>
									</xsl:for-each>
								</p>
							</xsl:if>
							<xsl:if test="altro/intervenienti/h:div!=''">
								<p class="contro">e con l'intervento di</p>
								<p class="popolo">
									<xsl:for-each select="altro/intervenienti/h:div">
										<xsl:apply-templates select="."/>
										<br/>
									</xsl:for-each>
								</p>
							</xsl:if>
						</xsl:for-each>
						<p class="contro">
							<xsl:value-of select="epigrafe/oggetto/h:div[1]"/>
						</p>
						<xsl:for-each select="epigrafe/oggetto/h:div">
							<xsl:if test="position() > 1">
								<xsl:choose>
									<xsl:when test="substring(.,1,6) = 'previa'">
										<p class="previa">
											<xsl:apply-templates select="."/>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p class="popolo">
											<xsl:apply-templates select="."/>
										</p>
										<xsl:if test=".=''">
											<br/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="epigrafe/esaminato/h:div">
							<p class="popolo">
								<xsl:apply-templates select="."/>
							</p>
							<xsl:if test=".=''">
								<br/>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="epigrafe/visto/h:div">
							<p class="popolo">
								<xsl:apply-templates select="."/>
							</p>
							<xsl:if test=".=''">
								<br/>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="premessa/h:div">
							<xsl:choose>
								<xsl:when test="substring(.,1,5) = 'FATTO'">
									<p class="fatto">
										<xsl:apply-templates select="."/>
									</p>
								</xsl:when>
								<xsl:when test="substring(.,1,7) = 'DIRITTO'">
									<p class="fatto">
										<xsl:apply-templates select="."/>
									</p>
								</xsl:when>
								<xsl:otherwise>
									<p class="popolo">
										<xsl:apply-templates select="."/>
									</p>
									<xsl:if test=".=''">
										<br/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="motivazione/h:div">
							<xsl:if test="position() > 0">
								<p class="popolo">
									<xsl:apply-templates select="."/>
								</p>
								<xsl:if test=".=''">
									<br/>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<!--****inizio pqm + dicitura su chi ha emesso daniela -->
						<xsl:choose>
							<xsl:when test="(meta/descrittori/processoAmministrativo ='2') and (meta/descrittori/idTipoProvSDM='3' or meta/descrittori/idTipoProvSDM='4' or meta/descrittori/idTipoProvSDM='33' or meta/descrittori/idTipoProvSDM='34')">
								<xsl:for-each select="dispositivo/h:div">
									<xsl:choose>
										<xsl:when test="substring(.,1,6) = 'P.Q.M.'">
											<p class="fatto">PER LE RAGIONI CHE SARANNO ESPOSTE IN
										MOTIVAZIONE</p>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="dispositivo/h:div">
									<xsl:choose>
										<xsl:when test="substring(.,1,6) = 'P.Q.M.'">
											<p class="fatto">
												<xsl:apply-templates select="."/>
											</p>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="dispositivo/h:div">
							<xsl:choose>
								<xsl:when test="substring(.,1,6) != 'P.Q.M.'">
									<p class="popolo">
										<xsl:apply-templates select="."/>
									</p>
									<xsl:if test=".=''">
										<br/>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<!--****fine pqm + dicitura su chi ha emesso daniela -->
						<!--xsl:for-each select="meta/esito/testo">
         	<p class="popolo"><xsl:apply-templates select="."/></p>
         </xsl:for-each-->
						<p class="popolo">
							<xsl:value-of select="sottoscrizioni/dataeluogo/h:i[1]"/>
						</p>
						<p class="popolo">
							<xsl:for-each select="epigrafe/adunanza/h:div">
								<xsl:if test="position() > 4">
									<p class="tabula">
										<xsl:apply-templates select="."/>
									</p>
								</xsl:if>
							</xsl:for-each>
						</p>
						<p/>
						<p/>
						<p/>
						<xsl:choose>
							<!--*****************************da qui gestisco timbro nuovo processo-->
							<xsl:when test="meta/descrittori/processoAmministrativo ='2' and epigrafe/adunanza/h:div[2]!='in sede giurisdizionale (Adunanza Plenaria)'">
								<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
										</td>
										<td/>
										<td>
											<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
										</td>
									</tr>
									<xsl:if test="meta/@versionePDF='1'">
										<tr>
											<td>
												<xsl:for-each select="epigrafe/adunanza/h:div">
													<xsl:if test="(contains(.,'Estensore') or contains(.,'Verfasser'))">
														<xsl:value-of select="substring-before(.,',')"/>
													</xsl:if>
												</xsl:for-each>
											</td>
											<td/>
											<td>
												<xsl:for-each select="epigrafe/adunanza/h:div">
													<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
														<xsl:value-of select="substring-before(.,',')"/>
													</xsl:if>
												</xsl:for-each>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>&#160;</td>
										<td/>
										<td/>
									</tr>
								</table>
								<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
							<p class="fatto">Il Segretario</p>
							<p class="fatto">(ai sensi dell'art. 89, co. 3, cod. proc. amm.)</p>
							<br/>
							<p class="fatto">______________________</p>
							<br/>
							<p class="fatto">IL DIRIGENTE</p>
							<br/>
							<br/>
						</xsl:if-->
								<xsl:choose>
									<xsl:when test="meta/@versionePDF='1'">
										<p class="fatto">IL SEGRETARIO</p>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
												<p class="fatto">DEPOSITATO IN SEGRETERIA</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="fatto">DEPOSITATA IN SEGRETERIA</p>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="meta/dataPubblicazione!=''">
												<p class="fatto">
									Il <xsl:value-of select="meta/dataPubblicazione"/>
												</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="fatto"> Il ___________________</p>
											</xsl:otherwise>
										</xsl:choose>
										<!-- inizio modifica articoli del timbro firma daniela-->
										<xsl:choose>
											<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
														<xsl:choose>
															<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																<p class="fatto">(Art. 119, co. 5, cod. proc.
												amm.)</p>
															</xsl:when>
														</xsl:choose>
														<xsl:choose>
															<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																<p class="fatto">(Art. 120, co. 9, cod. proc.
												amm.)</p>
															</xsl:when>
														</xsl:choose>
														<xsl:choose>
															<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																<p class="fatto">(art. 130, co. 7, cod. proc. amm.)</p>
															</xsl:when>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
														<p class="fatto">(Art. 23 bis, comma 6, L. 6/12/1971, n.
											1034)</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
										<!-- fine modifica articoli del timbro firma daniela-->
										<xsl:choose>
											<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
												<p class="fatto">IL SEGRETARIO</p>
												<p class="fatto">(Art. 89, co. 3, cod. proc. amm.)</p>
											</xsl:when>
											<xsl:otherwise>
												<p class="fatto">IL SEGRETARIO</p>
												<p class="fatto">(Art. 89, co. 3, cod. proc. amm.)</p>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- *************************fine timbro nuovo processo-->
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
										<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td colspan="3">
													<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
												</td>
											</tr>
											<xsl:if test="meta/@versionePDF='1'">
												<tr>
													<td/>
													<td>
														<xsl:value-of select="substring-before(epigrafe/adunanza/h:div[5],',')"/>
													</td>
													<td/>
												</tr>
											</xsl:if>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
												</td>
												<td/>
												<td>IL SEGRETARIO</td>
											</tr>
											<xsl:if test="meta/@versionePDF='1'">
												<tr>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="contains(.,'Estensore') or contains(.,'Verfasser')">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
										</table>
										<!--xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
									<p class="fatto">Il Segretario</p><br/>
									</xsl:if-->
										<xsl:choose>
											<xsl:when test="meta/@versionePDF='1'">
												<xsl:if test="epigrafe/adunanza/h:div[2]!='in sede giurisdizionale (Adunanza Plenaria)'">
													<p class="fatto">IL SEGRETARIO</p>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA' ">
														<p class="fatto">DEPOSITATO IN SEGRETERIA</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">DEPOSITATA IN SEGRETERIA</p>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="meta/dataPubblicazione!=''">
														<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
														</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">Il ___________________</p>
													</xsl:otherwise>
												</xsl:choose>
												<!-- inizio modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3') ">
																		<p class="fatto">(Art. 119, co. 5, cod. proc.	amm.)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																		<p class="fatto">(Art. 120, co. 9, cod. proc.	amm.)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																		<p class="fatto">(art. 130, co. 7, cod. proc. amm.)</p>
																	</xsl:when>
																</xsl:choose>
															</xsl:when>
															<xsl:otherwise>
																<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
																<xsl:choose>
																	<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)'">
																		<p class="fatto">(Art. 89, co. 3, cod. proc. amm.)</p>
																	</xsl:when>
																</xsl:choose>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
															</xsl:when>
															<xsl:otherwise>
																<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												<!-- fine modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
														<p class="fatto">Il Dirigente della Sezione</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">IL SEGRETARIO</p>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<table class="sottoscrizioni" border="0" cellspacing="1" style="border-collapse: collapse" width="100%">
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="sottoscrizioni/sottoscrivente[2]/h:div[1]"/>
												</td>
												<td/>
												<td>
													<xsl:value-of select="sottoscrizioni/sottoscrivente[1]/h:div[1]"/>
												</td>
											</tr>
											<xsl:if test="meta/@versionePDF='1'">
												<tr>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="contains(.,'Estensore') or contains(.,'Verfasser')">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
													<td/>
													<td>
														<xsl:for-each select="epigrafe/adunanza/h:div">
															<xsl:if test="(contains(.,'Presidente') and not(contains(.,'Estensore'))) or (contains(.,'Präsident') and not (contains(.,'Verfasser')))">
																<xsl:value-of select="substring-before(.,',')"/>
															</xsl:if>
														</xsl:for-each>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<!--tr>
										<td/>
										<td><xsl:value-of select="sottoscrizioni/sottoscrivente[3]/h:div[1]"/></td>
										<td/>
										</tr-->
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
											<tr>
												<td>&#160;</td>
												<td/>
												<td/>
											</tr>
										</table>
										<xsl:choose>
											<xsl:when test="meta/@versionePDF='1'">
												<p class="fatto">IL SEGRETARIO</p>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
													<p class="fatto">Il Segretario</p>
													<br/>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
														<p class="fatto">DEPOSITATO IN SEGRETERIA</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">DEPOSITATA IN SEGRETERIA</p>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="meta/dataPubblicazione!=''">
														<p class="fatto">Il <xsl:value-of select="meta/dataPubblicazione"/>
														</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">Il ___________________</p>
													</xsl:otherwise>
												</xsl:choose>
												<!-- inizio modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="meta/descrittori/processoAmministrativo ='2'">
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='0') or (meta/descrittori/idTipoProvSDM='3')">
																		<p class="fatto">(Art. 119, co. 5, cod. proc.
												amm.)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='1')">
																		<p class="fatto">(Art. 120, co. 9, cod. proc.
												amm.)</p>
																	</xsl:when>
																</xsl:choose>
																<xsl:choose>
																	<xsl:when test="(meta/descrittori/idTipoProvSDM='4'and meta/descrittori/idSpecificaSDM='2')">
																		<p class="fatto">(art. 130, co. 7, cod. proc. amm.)</p>
																	</xsl:when>
																</xsl:choose>
															</xsl:when>
															<xsl:otherwise>
																<!--p class="fatto">(Art. 89 cod. proc. amm.)</p-->
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="epigrafe/adunanza/h:div[4]='DISPOSITIVO DI DECISIONE' or epigrafe/adunanza/h:div[4]='DISPOSITIVO DI SENTENZA'">
																<p class="fatto">(Art. 23 bis, comma 6, L.
												6/12/1971, n. 1034)</p>
															</xsl:when>
															<xsl:otherwise>
																<p class="fatto">(Art. 55, L. 27/4/1982, n. 186)</p>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												<!-- fine modifica articoli del timbro firma daniela-->
												<xsl:choose>
													<xsl:when test="epigrafe/adunanza/h:div[1]='Il Consiglio di Stato'">
														<p class="fatto">Il Dirigente della Sezione</p>
													</xsl:when>
													<xsl:otherwise>
														<p class="fatto">IL SEGRETARIO</p>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						<!--*****************************fino a qui gestisco timbro nuovo processo-->
						<xsl:choose>
							<xsl:when test="epigrafe/adunanza/h:div[2]='in sede giurisdizionale (Adunanza Plenaria)' and meta/descrittori/processoAmministrativo ='1'">
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">
									<br/>
								</p>
								<p class="sezione">CONSIGLIO DI STATO</p>
								<p class="sezione">In Sede Giurisdizionale (Adunanza Plenaria)</p>
								<p class="fatto">Addi'............................copia conforme alla
							presente e' stata trasmessa</p>
								<p class="fatto">a
							............................................................................................................................</p>
								<p class="fatto">a norma dell'art. 87 del Regolamento di Procedura 17 agosto
							1907 n.642</p>
								<p class="fatto">Il Direttore della Segreteria</p>
							</xsl:when>
						</xsl:choose>
						<br/>
						<br/>
						<xsl:if test="meta/redazionale/nota/h:div!=''">
							<p class="calce">
								<xsl:for-each select="meta/redazionale/nota/h:div">
									<xsl:apply-templates select="."/>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:if>
						<xsl:if test="sottoscrizioni/sottoscrivente[4]/h:div[1]!=''">
							<table align="center">
								<tr>
									<td colspan="2">
										<br/>
										<br/>
										<br/>
										<br/>
										<br/>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="fatto">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[4]/h:div[1]"/>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="fatto">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[5]/h:div[1]"/>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="popolo">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[6]/h:div[1]"/>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<p class="dirigente">
											<xsl:value-of select="sottoscrizioni/sottoscrivente[7]/h:div[1]"/>
										</p>
									</td>
								</tr>
							</table>
						</xsl:if>
						<xsl:choose>
							<!-- ATTENZIONE: inserito processoAmministrativo ='3' per eliminarlo in previsione di doverlo rimettere a 2 :) -->
							<xsl:when test="meta/descrittori/processoAmministrativo ='3'">
								<table align="left">
									<tr>
										<td>
											<p class="fattopicc">Addi'_________________ copia conforme del
										presente provvedimento e' trasmessa a:</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="fatto">___________________________________________________________</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="fatto">___________________________________________________________</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="fatto">___________________________________________________________</p>
										</td>
									</tr>
									<tr>
										<td>
											<p class="dirigente">IL FUNZIONARIO </p>
										</td>
									</tr>
								</table>
							</xsl:when>
						</xsl:choose>
					</body>
				</xsl:otherwise>
			</xsl:choose>
		</html>
	</xsl:template>
	<xsl:template match="corsivo">
		<xsl:element name="i">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="grassetto">
		<xsl:element name="b">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
