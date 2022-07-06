USE GD1C2022
GO

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TIEMPO')
CREATE TABLE LOCRO.BI_TIEMPO(
TIEMPO_ID INT IDENTITY PRIMARY KEY,
TIEMPO_ANIO INT not null,
TIEMPO_CUATRIMESTRE INT null,
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_ESCUDERIA')
CREATE TABLE LOCRO.BI_ESCUDERIA(
ESCUDERIA_ID INT PRIMARY KEY,
ESCUDERIA_NOMBRE VARCHAR(255)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_CIRCUITO')
CREATE TABLE LOCRO.BI_CIRCUITO(
CIRCUITO_ID INT PRIMARY KEY,
CIRCUITO_NOMBRE VARCHAR(255)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_CARRERA')
CREATE TABLE LOCRO.BI_CARRERA(
CARRERA_ID INT PRIMARY KEY,
CARRERA_CIRCUITO INT FOREIGN KEY REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID),
CARRERA_FECHA DATE
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_PILOTO')
CREATE TABLE LOCRO.BI_PILOTO(
PILOTO_ID INT PRIMARY KEY,
PILOTO_NOMBRE varchar(255),
PILOTO_APELLIDO varchar(255)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_AUTO')
CREATE TABLE LOCRO.BI_AUTO(
AUTO_ID INT PRIMARY KEY,
AUTO_ESCUDERIA INT FOREIGN KEY REFERENCES LOCRO.BI_ESCUDERIA(ESCUDERIA_ID),
AUTO_PILOTO INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_PILOTO(PILOTO_ID)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_PARADA_BOX')
CREATE TABLE LOCRO.BI_PARADA_BOX(
PARADA_ID INT PRIMARY KEY,
PARADA_AUTO INT FOREIGN KEY REFERENCES LOCRO.BI_AUTO(AUTO_ID),
PARADA_CARRERA INT FOREIGN KEY REFERENCES LOCRO.BI_CARRERA(CARRERA_ID),
PARADA_TIEMPO decimal(18,2)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TIPO_SECTOR')
CREATE TABLE LOCRO.BI_TIPO_SECTOR(
TIPO_SECTOR_ID INT PRIMARY KEY,
TIPO_SECTOR_DETALLE varchar(255)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_SECTOR')
CREATE TABLE LOCRO.BI_SECTOR(
SECTOR_ID INT PRIMARY KEY,
SECTOR_TIPO INT FOREIGN KEY REFERENCES LOCRO.BI_TIPO_SECTOR(TIPO_SECTOR_ID)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TIPO_INCIDENTE')
CREATE TABLE LOCRO.BI_TIPO_INCIDENTE(
TIPO_INCIDENTE_ID INT PRIMARY KEY,
TIPO_INCIDENTE_DETALLE varchar(255)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_INCIDENTE')
CREATE TABLE LOCRO.BI_INCIDENTE(
INCIDENTE_ID INT PRIMARY KEY,
INCIDENTE_TIPO INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_TIPO_INCIDENTE(TIPO_INCIDENTE_ID),
INCIDENTE_CARRERA INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_CARRERA(CARRERA_ID),
INCIDENTE_SECTOR INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_SECTOR(SECTOR_ID)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_INCIDENTE_AUTO')
CREATE TABLE LOCRO.BI_INCIDENTE_AUTO(
INCIDENTE_ID INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_INCIDENTE(INCIDENTE_ID),
AUTO_ID INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_AUTO(AUTO_ID)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_HECHOS_INCIDENTES')
CREATE TABLE LOCRO.BI_HECHOS_INCIDENTES(
ESCUDERIA_ID INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_ESCUDERIA(ESCUDERIA_ID),
CIRCUITO_ID INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID),
TIPO_SECTOR_ID INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_TIPO_SECTOR(TIPO_SECTOR_ID),
TIPO_INCIDENTE_ID INT NOT NULL FOREIGN KEY REFERENCES LOCRO.BI_TIPO_INCIDENTE(TIPO_INCIDENTE_ID),
ANIO INT NOT NULL,
CANT_INCIDENTES INT NOT NULL,
PRIMARY KEY(ESCUDERIA_ID, CIRCUITO_ID, TIPO_SECTOR_ID, TIPO_INCIDENTE_ID, ANIO)
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_VUELTA')
CREATE TABLE LOCRO.BI_VUELTA(
VUELTA_ID INT IDENTITY PRIMARY KEY,
VUELTA_NRO nvarchar(255) NOT NULL,
VUELTA_CARRERA INT NOT NULL REFERENCES LOCRO.BI_CARRERA(CARRERA_ID) 
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TELE_AUTO')
CREATE TABLE LOCRO.BI_TELE_AUTO(
TELE_AUTO_ID int PRIMARY KEY,
TELE_AUTO_VUELTA INT NOT NULL REFERENCES LOCRO.BI_VUELTA(VUELTA_ID),
TELE_AUTO_DISTANCIA_VUELTA decimal(18,2) null,
TELE_AUTO_TIEMPO_VUELTA decimal(18,2) null,
TELE_AUTO_VELOCIDAD decimal(18,2) null,
TELE_AUTO_COMBUSTIBLE decimal(18,2) null,
TELE_AUTO_AUTO int not null REFERENCES LOCRO.BI_AUTO(AUTO_ID),
TELE_AUTO_SECTOR INT NOT NULL REFERENCES LOCRO.BI_SECTOR(SECTOR_ID),
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TIPO_NEUMATICO')
DROP TABLE LOCRO.BI_TIPO_NEUMATICO
GO
CREATE TABLE LOCRO.BI_TIPO_NEUMATICO(
TIPO_NEUMATICO_ID int PRIMARY KEY,
TIPO_NEUMATICO_DESCRIPCION NVARCHAR(255) null
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_NEUMATICO')
DROP TABLE LOCRO.BI_NEUMATICO
GO
CREATE TABLE LOCRO.BI_NEUMATICO(
NEUMATICO_ID int PRIMARY KEY,
NEUMATICO_NRO_SERIE NVARCHAR(255) not null,
NEUMATICO_TIPO INT not null REFERENCES LOCRO.BI_TIPO_NEUMATICO(TIPO_NEUMATICO_ID)
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TELE_NEUMATICO')
DROP TABLE LOCRO.BI_TELE_NEUMATICO
GO
CREATE TABLE LOCRO.BI_TELE_NEUMATICO(
TELE_NEUMATICO_ID int PRIMARY KEY,
TELE_NEUMATICO_VUELTA int not null REFERENCES LOCRO.BI_VUELTA(VUELTA_ID),
TELE_NEUMATICO_NEUMATICO INT not null REFERENCES LOCRO.BI_NEUMATICO(NEUMATICO_ID),
TELE_NEUMATICO_TELE_AUTO INT not null REFERENCES LOCRO.BI_TELE_AUTO(TELE_AUTO_ID),
TELE_NEUMATICO_PROFUNDIDAD decimal(18,2) not null,
TELE_NEUMATICO_CIRCUITO int not null REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID)
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_CAJA')
DROP TABLE LOCRO.BI_CAJA
GO
CREATE TABLE LOCRO.BI_CAJA(
CAJA_ID int PRIMARY KEY,
CAJA_NRO_SERIE NVARCHAR(255) null,
CAJA_MODELO NVARCHAR(255) null
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TELE_CAJA')
DROP TABLE LOCRO.BI_TELE_CAJA
GO
CREATE TABLE LOCRO.BI_TELE_CAJA(
TELE_CAJA_ID int PRIMARY KEY,
TELE_CAJA_CAJA int not null REFERENCES LOCRO.BI_CAJA(CAJA_ID),
TELE_CAJA_DESGASTE decimal(18,2),
TELE_CAJA_TELE_AUTO INT not null REFERENCES LOCRO.BI_TELE_AUTO(TELE_AUTO_ID),
TELE_CAJA_VUELTA int not null REFERENCES LOCRO.BI_VUELTA(VUELTA_ID),
TELE_CAJA_CIRCUITO int not null REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID)
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_FRENO')
DROP TABLE LOCRO.BI_FRENO
GO
CREATE TABLE LOCRO.BI_FRENO(
FRENO_ID int PRIMARY KEY,
FRENO_NRO_SERIE NVARCHAR(255) null
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TELE_FRENO')
DROP TABLE LOCRO.BI_TELE_FRENO
GO
CREATE TABLE LOCRO.BI_TELE_FRENO(
TELE_FRENO_ID int PRIMARY KEY,
TELE_FRENO_TELE_AUTO INT not null REFERENCES LOCRO.BI_TELE_AUTO(TELE_AUTO_ID),
TELE_FRENO_FRENO INT not null REFERENCES LOCRO.BI_FRENO(FRENO_ID),
TELE_FRENO_GROSOR decimal(18,2),
TELE_FRENO_VUELTA int not null REFERENCES LOCRO.BI_VUELTA(VUELTA_ID),
TELE_FRENO_CIRCUITO int not null REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID)
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_MOTOR')
DROP TABLE LOCRO.BI_MOTOR
GO
CREATE TABLE LOCRO.BI_MOTOR(
MOTOR_ID int PRIMARY KEY,
MOTOR_NRO_SERIE NVARCHAR(255) null
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TELE_MOTOR')
DROP TABLE LOCRO.BI_TELE_MOTOR
GO
CREATE TABLE LOCRO.BI_TELE_MOTOR(
TELE_MOTOR_ID int PRIMARY KEY,
TELE_MOTOR_TELE_AUTO INT not null REFERENCES LOCRO.BI_TELE_AUTO(TELE_AUTO_ID),
TELE_MOTOR_MOTOR int not null REFERENCES LOCRO.BI_MOTOR(MOTOR_ID),
TELE_MOTOR_POTENCIA decimal(18,2) not null,
TELE_MOTOR_VUELTA int not null REFERENCES LOCRO.BI_VUELTA(VUELTA_ID),
TELE_MOTOR_CIRCUITO int not null REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID)
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_HECHOS_TELEMETRIAS')
DROP TABLE LOCRO.BI_HECHOS_TELEMETRIAS
GO
CREATE TABLE LOCRO.BI_HECHOS_TELEMETRIAS(
AUTO_ID INT NOT NULL REFERENCES LOCRO.BI_AUTO,
ESCUDERIA_ID INT NOT NULL REFERENCES LOCRO.BI_ESCUDERIA,
CARRERA_ID INT NOT NULL REFERENCES LOCRO.BI_CARRERA,
CIRCUITO_ID INT NOT NULL REFERENCES LOCRO.BI_CIRCUITO,
VUELTA_ID INT NOT NULL REFERENCES LOCRO.BI_VUELTA,
TIPO_SECTOR_ID INT NOT NULL REFERENCES LOCRO.BI_TIPO_SECTOR,
TIEMPO_ID INT NOT NULL REFERENCES LOCRO.BI_TIEMPO,
VELOCIDAD_MAXIMA decimal(12,2) NOT NULL,
CONSUMO decimal(12,2) NOT NULL,
TIEMPO decimal(12,2) NOT NULL,
DESGASTE_NEUMATICOS decimal(12,2) NOT NULL,
DESGASTE_FRENOS decimal(12,2) NOT NULL,
DESGASTE_MOTOR decimal(12,2) NOT NULL,
DESGASTE_CAJA decimal(12,2) NOT NULL
PRIMARY KEY (AUTO_ID, CARRERA_ID, VUELTA_ID, TIPO_SECTOR_ID)
);

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_HECHOS_TELEMETRIAS')
DROP TABLE LOCRO.BI_HECHOS_TELEMETRIAS
GO
CREATE TABLE LOCRO.BI_HECHOS_PARADAS(
AUTO_ID INT NOT NULL REFERENCES LOCRO.BI_AUTO(AUTO_ID),
CARRERA_ID INT NOT NULL REFERENCES LOCRO.BI_CARRERA(CARRERA_ID),
TIEMPO_ID INT NOT NULL REFERENCES LOCRO.BI_TIEMPO(TIEMPO_ID),
PILOTO_ID INT NOT NULL REFERENCES LOCRO.BI_PILOTO(PILOTO_ID),
ESCUDERIA_ID INT NOT NULL REFERENCES LOCRO.BI_ESCUDERIA(ESCUDERIA_ID),
CIRCUITO_ID INT NOT NULL REFERENCES LOCRO.BI_CIRCUITO(CIRCUITO_ID),
TIEMPO_TOTAL decimal(12,2) NOT NULL,
CANTIDAD INT NOT NULL,
PRIMARY KEY (AUTO_ID, CARRERA_ID)
);

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TIEMPO')
DROP PROCEDURE LOCRO.BI_MIGRAR_TIEMPO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TIEMPO
AS
BEGIN
	PRINT('MIGRANDO TIEMPOS...')
	INSERT INTO LOCRO.BI_TIEMPO
	SELECT DISTINCT YEAR(CARRERA_FECHA), CEILING(CAST(MONTH(CARRERA_FECHA) AS decimal(12,2)) / 4)
	FROM LOCRO.CARRERA
	PRINT('TIEMPOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_ESCUDERIA')
DROP PROCEDURE LOCRO.BI_MIGRAR_ESCUDERIA
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_ESCUDERIA
AS
BEGIN
	PRINT('MIGRANDO ESCUDERIAS...')
	INSERT INTO LOCRO.BI_ESCUDERIA
	SELECT ESCUDERIA_ID, ESCUDERIA_NOMBRE
	FROM LOCRO.ESCUDERIA
	PRINT('ESCUDERIAS MIGRADAS!!')

END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_CIRCUITO')
DROP PROCEDURE LOCRO.BI_MIGRAR_CIRCUITO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_CIRCUITO
AS
BEGIN
	PRINT('MIGRANDO CIRCUITO...')
	INSERT INTO LOCRO.BI_CIRCUITO
	SELECT CIRCUITO_CODIGO, CIRCUITO_NOMBRE
	FROM LOCRO.CIRCUITO
	PRINT('CIRCUITOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_CARRERA')
DROP PROCEDURE LOCRO.BI_MIGRAR_CARRERA
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_CARRERA
AS
BEGIN
	PRINT('MIGRANDO CARRERA...')
	INSERT INTO LOCRO.BI_CARRERA
	SELECT CARRERA_CODIGO, CARRERA_CIRCUITO, CARRERA_FECHA
	FROM LOCRO.CARRERA
	PRINT('CARRERAS MIGRADAS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_PILOTO')
DROP PROCEDURE LOCRO.BI_MIGRAR_PILOTO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_PILOTO
AS
BEGIN
	PRINT('MIGRANDO PILOTOS...')
	INSERT INTO LOCRO.BI_PILOTO
	SELECT PILOTO_ID, PILOTO_NOMBRE, PILOTO_APELLIDO
	FROM LOCRO.PILOTO
	PRINT('PILOTOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_AUTO')
DROP PROCEDURE LOCRO.BI_MIGRAR_AUTO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_AUTO
AS
BEGIN
	PRINT('MIGRANDO AUTOS...')
	INSERT INTO LOCRO.BI_AUTO
	SELECT AUTO_ID, AUTO_ESCUDERIA, AUTO_PILOTO
	FROM LOCRO.AUTO
	PRINT('AUTOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_PARADA_BOX')
DROP PROCEDURE LOCRO.BI_MIGRAR_PARADA_BOX
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_PARADA_BOX
AS
BEGIN
	PRINT('MIGRANDO PARADAS...')
	INSERT INTO LOCRO.BI_PARADA_BOX
	SELECT PARADA_ID, PARADA_AUTO, PARADA_CARRERA, PARADA_TIEMPO
	FROM LOCRO.PARADA_BOX
	PRINT('PARADAS MIGRADAS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TIPO_SECTOR')
DROP PROCEDURE LOCRO.BI_MIGRAR_TIPO_SECTOR
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TIPO_SECTOR
AS
BEGIN
	PRINT('MIGRANDO TIPOS DE SECTORES...')
	INSERT INTO LOCRO.BI_TIPO_SECTOR
	SELECT TIPO_SECTOR_NUMERO, TIPO_SECTOR_DETALLE
	FROM LOCRO.TIPO_SECTOR
	PRINT('TIPOS DE SECTORES MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_SECTOR')
DROP PROCEDURE LOCRO.BI_MIGRAR_SECTOR
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_SECTOR
AS
BEGIN
	PRINT('MIGRANDO SECTORES...')
	INSERT INTO LOCRO.BI_SECTOR
	SELECT SECTOR_CODIGO, SECTOR_TIPO
	FROM LOCRO.SECTOR
	PRINT('SECTORES MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TIPO_INCIDENTE')
DROP PROCEDURE LOCRO.BI_MIGRAR_TIPO_INCIDENTE
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TIPO_INCIDENTE
AS
BEGIN
	PRINT('MIGRANDO TIPOS DE INCIDENTES...')
	INSERT INTO LOCRO.BI_TIPO_INCIDENTE
	SELECT *
	FROM LOCRO.TIPO_INCIDENTE
	PRINT('TIPOS DE INCIDENTES MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_INCIDENTE')
DROP PROCEDURE LOCRO.BI_MIGRAR_INCIDENTE
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_INCIDENTE
AS
BEGIN
	PRINT('MIGRANDO INCIDENTES...')
	INSERT INTO LOCRO.BI_INCIDENTE
	SELECT INCIDENTE_ID, INCIDENTE_TIPO, INCIDENTE_CARRERA, INCIDENTE_SECTOR
	FROM LOCRO.INCIDENTE
	PRINT('INCIDENTES MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_INCIDENTE_AUTO')
DROP PROCEDURE LOCRO.BI_MIGRAR_INCIDENTE_AUTO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_INCIDENTE_AUTO
AS
BEGIN
	PRINT('MIGRANDO INCIDENTES X AUTO...')
	INSERT INTO LOCRO.BI_INCIDENTE_AUTO
	SELECT INCIDENTE_ID, AUTO_ID
	FROM LOCRO.INCIDENTE_AUTO
	PRINT('INCIDENTES X AUTO MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_HECHOS_INCIDENTES')
DROP PROCEDURE LOCRO.BI_MIGRAR_HECHOS_INCIDENTES
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_HECHOS_INCIDENTES
AS
BEGIN
	PRINT('MIGRANDO HECHOS INCIDENTES...')
	INSERT INTO LOCRO.BI_HECHOS_INCIDENTES
	SELECT
	AUTO_ESCUDERIA,
	CARRERA_CIRCUITO,
	SECTOR_TIPO,
	INCIDENTE_TIPO,
	TIEMPO_ANIO,
	COUNT(*)
	FROM LOCRO.BI_INCIDENTE i
	JOIN LOCRO.BI_INCIDENTE_AUTO ia
		ON i.INCIDENTE_ID = ia.INCIDENTE_ID
	JOIN LOCRO.BI_AUTO a
		ON ia.AUTO_ID = a.AUTO_ID
	JOIN LOCRO.BI_CARRERA
		ON i.INCIDENTE_CARRERA = CARRERA_ID
	JOIN LOCRO.BI_SECTOR
		ON i.INCIDENTE_SECTOR = SECTOR_ID
	JOIN LOCRO.BI_TIEMPO
		ON YEAR(CARRERA_FECHA) = TIEMPO_ANIO AND CEILING(CAST(MONTH(CARRERA_FECHA) AS decimal(12,2)) / 4) = TIEMPO_CUATRIMESTRE
	GROUP BY AUTO_ESCUDERIA, CARRERA_CIRCUITO, SECTOR_TIPO, INCIDENTE_TIPO, TIEMPO_ANIO
	PRINT('HECHOS INCIDENTES MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_HECHOS_PARADAS')
DROP PROCEDURE LOCRO.BI_MIGRAR_HECHOS_PARADAS
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_HECHOS_PARADAS
AS
BEGIN
	PRINT('MIGRANDO HECHOS PARADAS...')
	INSERT INTO LOCRO.BI_HECHOS_PARADAS
	SELECT
	AUTO_ID,
	CARRERA_ID,
	TIEMPO_ID,
	AUTO_PILOTO,
	AUTO_ESCUDERIA,
	CARRERA_CIRCUITO,
	SUM(PARADA_TIEMPO),
	COUNT(*)
	FROM LOCRO.BI_PARADA_BOX
	JOIN LOCRO.BI_AUTO ON PARADA_AUTO = AUTO_ID
	JOIN LOCRO.BI_CARRERA ON PARADA_CARRERA = CARRERA_ID
	JOIN LOCRO.BI_TIEMPO
		ON YEAR(CARRERA_FECHA) = TIEMPO_ANIO AND CEILING(CAST(MONTH(CARRERA_FECHA) AS decimal(12,2)) / 4) = TIEMPO_CUATRIMESTRE
	GROUP BY AUTO_ID, CARRERA_ID, TIEMPO_ID, AUTO_PILOTO, AUTO_ESCUDERIA, CARRERA_CIRCUITO
	PRINT('HECHOS PARADAS MIGRADA!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_VUELTA')
DROP PROCEDURE LOCRO.BI_MIGRAR_VUELTA
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_VUELTA
AS
BEGIN
	PRINT('MIGRANDO VUELTAS...')
	INSERT INTO LOCRO.BI_VUELTA
	SELECT DISTINCT TELE_AUTO_NRO_VUELTA, TELE_AUTO_CARRERA
	FROM LOCRO.TELE_AUTO
	PRINT('VUELTAS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TELE_AUTO')
DROP PROCEDURE LOCRO.BI_MIGRAR_TELE_AUTO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TELE_AUTO
AS
BEGIN
	PRINT('MIGRANDO TELEMETRIAS DE AUTO...')
	INSERT INTO LOCRO.BI_TELE_AUTO
	SELECT
	TELE_AUTO_CODIGO,
	VUELTA_ID,
	TELE_AUTO_DISTANCIA_VUELTA,
	TELE_AUTO_TIEMPO_VUELTA,
	TELE_AUTO_VELOCIDAD,
	TELE_AUTO_COMBUSTIBLE,
	TELE_AUTO_AUTO,
	TELE_AUTO_SECTOR
	FROM LOCRO.TELE_AUTO
	JOIN LOCRO.BI_VUELTA ON VUELTA_NRO = TELE_AUTO_NRO_VUELTA AND VUELTA_CARRERA = TELE_AUTO_CARRERA
	PRINT('TELEMETRIAS DE AUTO MIGRADAS!!')
END
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name='BI_CONSUMO_COMBUSTIBLE' AND type in ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION LOCRO.BI_CONSUMO_COMBUSTIBLE
GO
CREATE FUNCTION LOCRO.BI_CONSUMO_COMBUSTIBLE (@auto INT, @carrera INT) RETURNS decimal(18,2)
AS
BEGIN
	DECLARE @consumo decimal(18,2)
	SELECT @consumo = MAX(TELE_AUTO_COMBUSTIBLE) - MIN(TELE_AUTO_COMBUSTIBLE)
	FROM LOCRO.BI_TELE_AUTO t
	JOIN LOCRO.BI_VUELTA v ON v.VUELTA_ID = t.TELE_AUTO_VUELTA
	WHERE TELE_AUTO_AUTO = @auto AND VUELTA_CARRERA = @carrera
	RETURN @consumo
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TIPO_NEUMATICO')
DROP PROCEDURE LOCRO.BI_MIGRAR_TIPO_NEUMATICO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TIPO_NEUMATICO
AS
BEGIN
	PRINT('MIGRANDO TIPO_NEUMATICO...')
	INSERT INTO LOCRO.BI_TIPO_NEUMATICO
	SELECT TIPO_NEUMATICO_ID, TIPO_NEUMATICO_DESCRIPCION
	FROM LOCRO.TIPO_NEUMATICO
	PRINT('TIPOS DE NEUMATICOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_NEUMATICO')
DROP PROCEDURE LOCRO.BI_MIGRAR_NEUMATICO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_NEUMATICO
AS
BEGIN
	PRINT('MIGRANDO NEUMATICO...')
	INSERT INTO LOCRO.BI_NEUMATICO
	SELECT NEUMATICO_ID, NEUMATICO_NRO_SERIE, NEUMATICO_TIPO
	FROM LOCRO.NEUMATICO
	PRINT('NEUMATICOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TELE_NEUMATICO')
DROP PROCEDURE LOCRO.BI_MIGRAR_TELE_NEUMATICO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TELE_NEUMATICO
AS
BEGIN
	PRINT('MIGRANDO TELE_NEUMATICO...')
	INSERT INTO LOCRO.BI_TELE_NEUMATICO
	SELECT TELE_NEUMATICO_NUMERO, TELE_AUTO_VUELTA, TELE_NEUMATICO_NEUMATICO, TELE_AUTO_ID, TELE_NEUMATICO_PROFUNDIDAD, CARRERA_CIRCUITO
	FROM LOCRO.TELE_NEUMATICO
	JOIN LOCRO.BI_TELE_AUTO ON TELE_AUTO_ID = TELE_NEUMATICO_TELE_AUTO
	JOIN LOCRO.BI_VUELTA ON VUELTA_ID = TELE_AUTO_VUELTA
	JOIN LOCRO.BI_CARRERA ON VUELTA_CARRERA = CARRERA_ID
	PRINT('TELE_NEUMATICO MIGRADO!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_CAJA')
DROP PROCEDURE LOCRO.BI_MIGRAR_CAJA
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_CAJA
AS
BEGIN
	PRINT('MIGRANDO CAJA...')
	INSERT INTO LOCRO.BI_CAJA
	SELECT CAJA_ID, CAJA_NRO_SERIE, CAJA_MODELO
	FROM LOCRO.CAJA
	PRINT('CAJAS MIGRADAS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TELE_CAJA')
DROP PROCEDURE LOCRO.BI_MIGRAR_TELE_CAJA
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TELE_CAJA
AS
BEGIN
	PRINT('MIGRANDO TELE_CAJA...')
	INSERT INTO LOCRO.BI_TELE_CAJA
	SELECT TELE_CAJA_NUMERO, TELE_CAJA_CAJA, TELE_CAJA_DESGASTE, TELE_CAJA_TELE_AUTO, VUELTA_ID, SECTOR_CIRCUITO
	FROM LOCRO.TELE_CAJA
	JOIN LOCRO.TELE_AUTO ON TELE_AUTO_CODIGO = TELE_CAJA_TELE_AUTO
	JOIN LOCRO.SECTOR ON TELE_AUTO_SECTOR = SECTOR_CODIGO
	JOIN LOCRO.BI_VUELTA ON VUELTA_NRO = TELE_AUTO_NRO_VUELTA AND VUELTA_CARRERA = TELE_AUTO_CARRERA
	PRINT('TELE_CAJA MIGRADA!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_FRENO')
DROP PROCEDURE LOCRO.BI_MIGRAR_FRENO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_FRENO
AS
BEGIN
	PRINT('MIGRANDO FRENOS...')
	INSERT INTO LOCRO.BI_FRENO
	SELECT FRENO_ID, FRENO_NRO_SERIE
	FROM LOCRO.FRENO
	PRINT('FRENOS MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TELE_FRENO')
DROP PROCEDURE LOCRO.BI_MIGRAR_TELE_FRENO
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TELE_FRENO
AS
BEGIN
	PRINT('MIGRANDO TELE_FRENO...')
	INSERT INTO LOCRO.BI_TELE_FRENO
	SELECT TELE_FRENO_NUMERO, TELE_FRENO_TELE_AUTO, TELE_FRENO_FRENO, TELE_FRENO_GROSOR, VUELTA_ID, SECTOR_CIRCUITO
	FROM LOCRO.TELE_FRENO
	JOIN LOCRO.TELE_AUTO ON TELE_AUTO_CODIGO = TELE_FRENO_TELE_AUTO
	JOIN LOCRO.SECTOR ON TELE_AUTO_SECTOR = SECTOR_CODIGO
	JOIN LOCRO.BI_VUELTA ON VUELTA_NRO = TELE_AUTO_NRO_VUELTA AND VUELTA_CARRERA = TELE_AUTO_CARRERA
	PRINT('TELE_FRENO MIGRADA!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_MOTOR')
DROP PROCEDURE LOCRO.BI_MIGRAR_MOTOR
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_MOTOR
AS
BEGIN
	PRINT('MIGRANDO MOTOR...')
	INSERT INTO LOCRO.BI_MOTOR
	SELECT MOTOR_ID, MOTOR_NRO_SERIE
	FROM LOCRO.MOTOR
	PRINT('MOTORES MIGRADOS!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_TELE_MOTOR')
DROP PROCEDURE LOCRO.BI_MIGRAR_TELE_MOTOR
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_TELE_MOTOR
AS
BEGIN
	PRINT('MIGRANDO TELE_MOTOR...')
	INSERT INTO LOCRO.BI_TELE_MOTOR
	SELECT TELE_MOTOR_NUMERO, TELE_MOTOR_TELE_AUTO, TELE_MOTOR_MOTOR, TELE_MOTOR_POTENCIA, VUELTA_ID, SECTOR_CIRCUITO
	FROM LOCRO.TELE_MOTOR
	JOIN LOCRO.TELE_AUTO ON TELE_AUTO_CODIGO = TELE_MOTOR_TELE_AUTO
	JOIN LOCRO.SECTOR ON TELE_AUTO_SECTOR = SECTOR_CODIGO
	JOIN LOCRO.BI_VUELTA ON VUELTA_NRO = TELE_AUTO_NRO_VUELTA AND VUELTA_CARRERA = TELE_AUTO_CARRERA
	PRINT('TELE_MOTOR MIGRADA!!')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_MIGRAR_HECHOS_TELEMETRIAS')
DROP PROCEDURE LOCRO.BI_MIGRAR_HECHOS_TELEMETRIAS
GO
CREATE PROCEDURE LOCRO.BI_MIGRAR_HECHOS_TELEMETRIAS
AS
BEGIN
	PRINT('MIGRANDO HECHOS TELEMETRIAS...')
	INSERT INTO LOCRO.BI_HECHOS_TELEMETRIAS
	SELECT
	TELE_AUTO_AUTO,
	AUTO_ESCUDERIA,
	VUELTA_CARRERA,
	CARRERA_CIRCUITO,
	TELE_AUTO_VUELTA,
	SECTOR_TIPO,
	TIEMPO_ID,
	MAX(TELE_AUTO_VELOCIDAD),
	MAX(TELE_AUTO_COMBUSTIBLE) - MIN(TELE_AUTO_COMBUSTIBLE),
	MAX(TELE_AUTO_TIEMPO_VUELTA) - MIN(TELE_AUTO_TIEMPO_VUELTA),
	(	SELECT MAX(TELE_NEUMATICO_PROFUNDIDAD) - MIN(TELE_NEUMATICO_PROFUNDIDAD)
		FROM LOCRO.BI_TELE_NEUMATICO
		JOIN LOCRO.BI_TELE_AUTO t2
			ON TELE_NEUMATICO_TELE_AUTO = t2.TELE_AUTO_ID
		JOIN LOCRO.BI_SECTOR s2
			ON t2.TELE_AUTO_SECTOR = s2.SECTOR_ID
		WHERE t1.TELE_AUTO_AUTO = t2.TELE_AUTO_AUTO AND t1.TELE_AUTO_VUELTA = t2.TELE_AUTO_VUELTA AND s1.SECTOR_TIPO = s2.SECTOR_TIPO),
	(	SELECT MAX(TELE_FRENO_GROSOR) - MIN(TELE_FRENO_GROSOR)
		FROM LOCRO.BI_TELE_FRENO
		JOIN LOCRO.BI_TELE_AUTO t2
			ON TELE_FRENO_TELE_AUTO = t2.TELE_AUTO_ID
		JOIN LOCRO.BI_SECTOR s2
			ON t2.TELE_AUTO_SECTOR = SECTOR_ID
		WHERE t1.TELE_AUTO_AUTO = t2.TELE_AUTO_AUTO AND t1.TELE_AUTO_VUELTA = t2.TELE_AUTO_VUELTA AND s1.SECTOR_TIPO = s2.SECTOR_TIPO),
	(	SELECT MAX(TELE_MOTOR_POTENCIA) - MIN(TELE_MOTOR_POTENCIA)
		FROM LOCRO.BI_TELE_MOTOR
		JOIN LOCRO.BI_TELE_AUTO t2
			ON TELE_MOTOR_TELE_AUTO = t2.TELE_AUTO_ID
		JOIN LOCRO.BI_SECTOR s2
			ON t2.TELE_AUTO_SECTOR = SECTOR_ID
		WHERE t1.TELE_AUTO_AUTO = t2.TELE_AUTO_AUTO AND t1.TELE_AUTO_VUELTA = t2.TELE_AUTO_VUELTA AND s1.SECTOR_TIPO = s2.SECTOR_TIPO),
	(	SELECT MAX(TELE_CAJA_DESGASTE)
		FROM LOCRO.BI_TELE_CAJA
		JOIN LOCRO.BI_TELE_AUTO t2
			ON TELE_CAJA_TELE_AUTO = TELE_AUTO_ID
				JOIN LOCRO.BI_SECTOR s2
			ON t2.TELE_AUTO_SECTOR = SECTOR_ID
		WHERE t1.TELE_AUTO_AUTO = t2.TELE_AUTO_AUTO AND t1.TELE_AUTO_VUELTA = t2.TELE_AUTO_VUELTA AND s1.SECTOR_TIPO = s2.SECTOR_TIPO)
	FROM LOCRO.BI_TELE_AUTO t1
	JOIN LOCRO.BI_VUELTA
		ON VUELTA_ID = TELE_AUTO_VUELTA
	JOIN LOCRO.BI_CARRERA
		ON CARRERA_ID = VUELTA_CARRERA
	JOIN LOCRO.BI_SECTOR s1
		ON SECTOR_ID = TELE_AUTO_SECTOR
	JOIN LOCRO.BI_AUTO
		ON AUTO_ID = TELE_AUTO_AUTO
	JOIN LOCRO.BI_TIEMPO
		ON YEAR(CARRERA_FECHA) = TIEMPO_ANIO AND CEILING(CAST(MONTH(CARRERA_FECHA) AS decimal(12,2)) / 4) = TIEMPO_CUATRIMESTRE
	GROUP BY TELE_AUTO_AUTO, AUTO_ESCUDERIA, VUELTA_CARRERA, CARRERA_CIRCUITO, TELE_AUTO_VUELTA, SECTOR_TIPO, TIEMPO_ID
	PRINT('HECHOS TELEMETRIAS MIGRADAS!!')
END
GO

/*
IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'LOCRO.BI_CIRCUITOS_MAYOR_CONSUMO')
DROP VIEW LOCRO.BI_CIRCUITOS_MAYOR_CONSUMO
GO
CREATE VIEW LOCRO.BI_CIRCUITOS_MAYOR_CONSUMO
AS
SELECT
CIRCUITO_ID AS 'CODIGO',
CIRCUITO_NOMBRE AS 'NOMBRE'
FROM LOCRO.BI_CIRCUITO
GROUP BY CIRCUITO_ID, CIRCUITO_NOMBRE
HAVING CIRCUITO_ID IN (	SELECT TOP 3 c.CIRCUITO_ID
						FROM LOCRO.BI_CIRCUITO c
						JOIN LOCRO.BI_HECHOS_TELEMETRIAS t
							ON c.CIRCUITO_ID = t.CIRCUITO_ID
						GROUP BY c.CIRCUITO_ID
						ORDER BY AVG(t.CONSUMO) DESC)
GO*/

------------------------------------- VIEWS ---------------------------------------

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_CIRCUITOS_MAS_PELIGROSOS')
DROP VIEW LOCRO.BI_CIRCUITOS_MAS_PELIGROSOS
GO
CREATE VIEW LOCRO.BI_CIRCUITOS_MAS_PELIGROSOS
AS
	SELECT
	h.CIRCUITO_ID AS 'CODIGO',
	c.CIRCUITO_NOMBRE AS 'DETALLE',
	ANIO AS 'ANIO'
	FROM LOCRO.BI_HECHOS_INCIDENTES h
	JOIN LOCRO.BI_CIRCUITO c ON c.CIRCUITO_ID = h.CIRCUITO_ID
	WHERE h.CIRCUITO_ID IN (	SELECT TOP 3 CIRCUITO_ID
							FROM LOCRO.BI_HECHOS_INCIDENTES
							WHERE ANIO = h.ANIO
							GROUP BY CIRCUITO_ID
							ORDER BY SUM(CANT_INCIDENTES) DESC)
	GROUP BY h.CIRCUITO_ID, c.CIRCUITO_NOMBRE, ANIO
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_PROMEDIO_INCIDENTES')
DROP VIEW LOCRO.BI_PROMEDIO_INCIDENTES
GO
CREATE VIEW LOCRO.BI_PROMEDIO_INCIDENTES
AS
	SELECT
	h.ESCUDERIA_ID AS 'ESCUDERIA CODIGO',
	e.ESCUDERIA_NOMBRE AS 'ESCUDERIA NOMBRE',
	h.TIPO_SECTOR_ID AS 'TIPO SECTOR CODIGO',
	s.TIPO_SECTOR_DETALLE AS 'TIPO SECTOR DETALLE',
	(SELECT SUM(CANT_INCIDENTES)
	FROM LOCRO.BI_HECHOS_INCIDENTES h2
	WHERE h2.ESCUDERIA_ID = h.ESCUDERIA_ID AND h2.TIPO_SECTOR_ID = h.TIPO_SECTOR_ID) /
	(SELECT COUNT(DISTINCT h2.ANIO)
	FROM LOCRO.BI_HECHOS_INCIDENTES h2
	WHERE h2.ESCUDERIA_ID = h.ESCUDERIA_ID AND h2.TIPO_SECTOR_ID = h.TIPO_SECTOR_ID) AS 'PROMEDIO'
	FROM LOCRO.BI_HECHOS_INCIDENTES h
	JOIN LOCRO.BI_ESCUDERIA e ON e.ESCUDERIA_ID = h.ESCUDERIA_ID
	JOIN LOCRO.BI_TIPO_SECTOR s ON s.TIPO_SECTOR_ID = h.TIPO_SECTOR_ID
	GROUP BY h.ESCUDERIA_ID, e.ESCUDERIA_NOMBRE, h.TIPO_SECTOR_ID, s.TIPO_SECTOR_DETALLE
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_CANTIDAD_PARADAS')
DROP VIEW LOCRO.BI_CANTIDAD_PARADAS
GO
CREATE VIEW LOCRO.BI_CANTIDAD_PARADAS
AS
	SELECT
	h.CIRCUITO_ID AS 'CODIGO CIRCUITO',
	c.CIRCUITO_NOMBRE AS 'NOMBRE CIRCUITO',
	h.ESCUDERIA_ID AS 'CODIGO ESCUDERIA',
	e.ESCUDERIA_NOMBRE AS 'ESCUDERIA NOMBRE',
	t.TIEMPO_ANIO AS 'ANIO',
	SUM(CANTIDAD) AS 'CANTIDAD'
	FROM LOCRO.BI_HECHOS_PARADAS h
	JOIN LOCRO.BI_TIEMPO t ON t.TIEMPO_ID = h.TIEMPO_ID
	JOIN LOCRO.BI_ESCUDERIA e ON e.ESCUDERIA_ID = h.ESCUDERIA_ID
	JOIN LOCRO.BI_CIRCUITO c ON c.CIRCUITO_ID = h.CIRCUITO_ID
	GROUP BY h.CIRCUITO_ID, c.CIRCUITO_NOMBRE, h.ESCUDERIA_ID, e.ESCUDERIA_NOMBRE, t.TIEMPO_ANIO
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_CIRCUITOS_MAYOR_TIEMPO_EN_BOX')
DROP VIEW LOCRO.BI_CIRCUITOS_MAYOR_TIEMPO_EN_BOX
GO
CREATE VIEW LOCRO.BI_CIRCUITOS_MAYOR_TIEMPO_EN_BOX
AS
	SELECT
	h.CIRCUITO_ID AS 'CODIGO CIRCUITO',
	c.CIRCUITO_NOMBRE AS 'NOMBRE CIRCUITO',
	SUM(TIEMPO_TOTAL) AS 'CANTIDAD'
	FROM LOCRO.BI_HECHOS_PARADAS h
	JOIN LOCRO.BI_CIRCUITO c ON c.CIRCUITO_ID = h.CIRCUITO_ID
	WHERE h.CIRCUITO_ID IN (	SELECT TOP 3 CIRCUITO_ID
							FROM LOCRO.BI_HECHOS_PARADAS
							GROUP BY CIRCUITO_ID
							ORDER BY SUM(TIEMPO_TOTAL) DESC)
	GROUP BY h.CIRCUITO_ID, c.CIRCUITO_NOMBRE
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_TIEMPO_PROMEDIO')
DROP VIEW LOCRO.BI_TIEMPO_PROMEDIO
GO
CREATE VIEW LOCRO.BI_TIEMPO_PROMEDIO
AS
	SELECT
	h.ESCUDERIA_ID AS 'CODIGO ESCUDERIA',
	e.ESCUDERIA_NOMBRE AS 'NOMBRE ESCUDERIA',
	t.TIEMPO_ANIO AS 'ANIO',
	t.TIEMPO_CUATRIMESTRE AS 'CUATRIMESTRE',
	(SELECT SUM(TIEMPO_TOTAL) FROM LOCRO.BI_HECHOS_PARADAS h1 WHERE h1.ESCUDERIA_ID = h.ESCUDERIA_ID AND h1.TIEMPO_ID = h.TIEMPO_ID) / 
	(SELECT SUM(CANTIDAD) FROM LOCRO.BI_HECHOS_PARADAS h1 WHERE h1.ESCUDERIA_ID = h.ESCUDERIA_ID AND h1.TIEMPO_ID = h.TIEMPO_ID) AS 'PROMEDIO'
	FROM LOCRO.BI_HECHOS_PARADAS h
	JOIN LOCRO.BI_ESCUDERIA e ON e.ESCUDERIA_ID = h.ESCUDERIA_ID
	JOIN LOCRO.BI_TIEMPO t ON t.TIEMPO_ID = h.TIEMPO_ID
	GROUP BY h.ESCUDERIA_ID, e.ESCUDERIA_NOMBRE, t.TIEMPO_ANIO, t.TIEMPO_CUATRIMESTRE, h.TIEMPO_ID
GO

---------------------------------- EXECUTES DE MIGRACION ----------------------------------

EXEC LOCRO.BI_MIGRAR_TIEMPO
EXEC LOCRO.BI_MIGRAR_ESCUDERIA
EXEC LOCRO.BI_MIGRAR_CIRCUITO
EXEC LOCRO.BI_MIGRAR_CARRERA
EXEC LOCRO.BI_MIGRAR_PILOTO
EXEC LOCRO.BI_MIGRAR_AUTO
EXEC LOCRO.BI_MIGRAR_PARADA_BOX
EXEC LOCRO.BI_MIGRAR_HECHOS_PARADAS
EXEC LOCRO.BI_MIGRAR_TIPO_SECTOR
EXEC LOCRO.BI_MIGRAR_SECTOR
EXEC LOCRO.BI_MIGRAR_TIPO_INCIDENTE
EXEC LOCRO.BI_MIGRAR_INCIDENTE
EXEC LOCRO.BI_MIGRAR_INCIDENTE_AUTO
EXEC LOCRO.BI_MIGRAR_HECHOS_INCIDENTES
EXEC LOCRO.BI_MIGRAR_VUELTA
EXEC LOCRO.BI_MIGRAR_TELE_AUTO
EXEC LOCRO.BI_MIGRAR_TIPO_NEUMATICO
EXEC LOCRO.BI_MIGRAR_NEUMATICO
EXEC LOCRO.BI_MIGRAR_TELE_NEUMATICO
EXEC LOCRO.BI_MIGRAR_CAJA
EXEC LOCRO.BI_MIGRAR_TELE_CAJA
EXEC LOCRO.BI_MIGRAR_FRENO
EXEC LOCRO.BI_MIGRAR_TELE_FRENO
EXEC LOCRO.BI_MIGRAR_MOTOR
EXEC LOCRO.BI_MIGRAR_TELE_MOTOR

-- EXEC LOCRO.MIGRAR_HECHOS_TELEMETRIAS

/*
----------------- SELECT VIEWS -----------------

SELECT * FROM LOCRO.BI_PROMEDIO_INCIDENTES
SELECT * FROM LOCRO.BI_CIRCUITOS_MAS_PELIGROSOS
SELECT * FROM LOCRO.BI_CANTIDAD_PARADAS
SELECT * FROM LOCRO.BI_CIRCUITOS_MAYOR_TIEMPO_EN_BOX
SELECT * FROM LOCRO.BI_TIEMPO_PROMEDIO

---------------- DROPEAR TABLAS ------------------

DROP TABLE LOCRO.BI_HECHOS_TELEMETRIAS
DROP TABLE LOCRO.BI_HECHOS_INCIDENTES
DROP TABLE LOCRO.BI_HECHOS_PARADAS
DROP TABLE LOCRO.BI_TELE_NEUMATICO
DROP TABLE LOCRO.BI_NEUMATICO
DROP TABLE LOCRO.BI_TIPO_NEUMATICO
DROP TABLE LOCRO.BI_TELE_FRENO
DROP TABLE LOCRO.BI_FRENO
DROP TABLE LOCRO.BI_TELE_CAJA
DROP TABLE LOCRO.BI_CAJA
DROP TABLE LOCRO.BI_TELE_MOTOR
DROP TABLE LOCRO.BI_MOTOR
DROP TABLE LOCRO.BI_TELE_AUTO
DROP TABLE LOCRO.BI_VUELTA
DROP TABLE LOCRO.BI_PARADA_BOX
DROP TABLE LOCRO.BI_INCIDENTE_AUTO
DROP TABLE LOCRO.BI_INCIDENTE
DROP TABLE LOCRO.BI_TIPO_INCIDENTE
DROP TABLE LOCRO.BI_CARRERA
DROP TABLE LOCRO.BI_AUTO
DROP TABLE LOCRO.BI_PILOTO
DROP TABLE LOCRO.BI_ESCUDERIA
DROP TABLE LOCRO.BI_CIRCUITO
DROP TABLE LOCRO.BI_TIEMPO
DROP TABLE LOCRO.BI_SECTOR
DROP TABLE LOCRO.BI_TIPO_SECTOR
*/