USE [POCKBIT_v2]
GO
/****** Object:  Table [dbo].[laboratorio]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[laboratorio](
	[id_laboratorio] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_laboratorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[medicamento]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[medicamento](
	[id_medicamento] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [text] NULL,
	[costo] [float] NULL,
	[precio_maximo_publico] [float] NULL,
	[precio_venta] [float] NULL,
	[codigo_de_barras] [varchar](50) NOT NULL,
	[id_laboratorio] [int] NULL,
	[fecha_de_registro] [date] NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_medicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lote]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lote](
	[id_lote] [int] IDENTITY(1,1) NOT NULL,
	[numero_de_lote] [varchar](50) NOT NULL,
	[fecha_caducidad] [date] NULL,
	[id_medicamento] [int] NULL,
	[cantidad] [int] NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[compra]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[compra](
	[id_compra] [int] IDENTITY(1,1) NOT NULL,
	[id_lote] [int] NULL,
	[cantidad] [int] NULL,
	[costo_total] [float] NULL,
	[fecha_de_entrada] [date] NULL,
	[id_proveedor] [int] NULL,
	[realizado_por] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewCompra]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewCompra] AS
SELECT 
    c.id_compra,
    m.codigo_de_barras,
    l.numero_de_lote,
    m.nombre,
    lab.nombre AS laboratorio,
    c.cantidad,
    m.costo,
    c.costo_total,
    l.fecha_caducidad,
    c.fecha_de_entrada,
    c.realizado_por
FROM compra c
INNER JOIN lote l ON c.id_lote = l.id_lote
INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
INNER JOIN laboratorio lab ON m.id_laboratorio = lab.id_laboratorio;
GO
/****** Object:  Table [dbo].[venta]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[venta](
	[id_venta] [int] IDENTITY(1,1) NOT NULL,
	[id_lote] [int] NULL,
	[cantidad] [int] NULL,
	[precio_venta_total] [float] NULL,
	[costo_venta] [float] NULL,
	[ganancia_total] [float] NULL,
	[fecha_de_salida] [date] NULL,
	[realizado_por] [varchar](100) NOT NULL,
	[id_cliente] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_venta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewVenta]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVenta] AS
SELECT 
    v.id_venta,
    m.codigo_de_barras,
    l.numero_de_lote,
    m.nombre,
    v.cantidad,
    v.precio_venta_total,
    v.costo_venta,
    v.ganancia_total,
    v.fecha_de_salida,
    v.realizado_por
FROM venta v
INNER JOIN lote l ON v.id_lote = l.id_lote
INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
INNER JOIN laboratorio lab ON m.id_laboratorio = lab.id_laboratorio;
GO
/****** Object:  View [dbo].[ViewInventarioActual]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewInventarioActual]
AS
SELECT 
    ISNULL(SUM(m.costo * l.cantidad), 0) AS Inventario_Actual
FROM
    lote l
INNER JOIN
    medicamento m ON l.id_medicamento = m.id_medicamento
WHERE
    l.activo = 1 AND m.activo = 1;
GO
/****** Object:  View [dbo].[ViewBalance]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewBalance]
AS
SELECT 
    (SELECT ISNULL(SUM(v.precio_venta_total), 0) FROM venta v
     INNER JOIN lote l ON v.id_lote = l.id_lote
     INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
     WHERE YEAR(v.fecha_de_salida) = YEAR(GETDATE()) AND m.activo = 1 AND l.activo = 1) -
    (SELECT ISNULL(SUM(c.costo_total), 0) FROM compra c
     INNER JOIN lote l ON c.id_lote = l.id_lote
     INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
     WHERE YEAR(c.fecha_de_entrada) = YEAR(GETDATE()) AND m.activo = 1 AND l.activo = 1) AS Balance_Actual;
GO
/****** Object:  View [dbo].[ViewVentaReporte]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVentaReporte] AS
SELECT 
    v.id_venta,
    m.codigo_de_barras,  -- Código de barras del medicamento
    l.numero_de_lote,    -- Número de lote
    m.nombre,            -- Nombre del medicamento
    v.cantidad,
    v.precio_venta_total,
    v.costo_venta,
    v.ganancia_total,
    v.fecha_de_salida,
    v.realizado_por,
    m.id_medicamento,    -- Aquí se agrega el id_medicamento
    m.id_laboratorio     -- Aquí se agrega el id_laboratorio
FROM 
    venta v
JOIN 
    lote l ON v.id_lote = l.id_lote  -- Relación entre venta y lote
JOIN 
    medicamento m ON l.id_medicamento = m.id_medicamento;  -- Relación con medicamento
GO
/****** Object:  View [dbo].[ViewCompraReporte]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewCompraReporte] AS
SELECT 
    c.id_compra,
    m.codigo_de_barras,
    l.numero_de_lote,
    m.nombre,
    lab.nombre AS laboratorio,
    c.cantidad,
    m.costo,
    c.costo_total,
    l.fecha_caducidad,
    c.fecha_de_entrada,
    c.realizado_por,
    m.id_medicamento,  -- Se agregó id_medicamento
    m.id_laboratorio   -- Aquí agregamos id_laboratorio
FROM compra c
INNER JOIN lote l ON c.id_lote = l.id_lote
INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
INNER JOIN laboratorio lab ON m.id_laboratorio = lab.id_laboratorio;
GO
/****** Object:  View [dbo].[ViewMedicamento]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[ViewMedicamento] AS
SELECT 
    m.id_medicamento, 
    m.codigo_de_barras, 
    m.nombre, 
    CAST(m.descripcion AS VARCHAR(MAX)) AS descripcion, 
    lab.nombre AS nombre_laboratorio, 
    m.costo, 
    m.precio_venta, 
    m.precio_maximo_publico, 
    ISNULL(SUM(CASE WHEN lo.activo = 1 THEN lo.cantidad ELSE 0 END), 0) AS cantidad_total,
    m.fecha_de_registro, 
    m.activo
FROM medicamento m
LEFT JOIN laboratorio lab ON m.id_laboratorio = lab.id_laboratorio
LEFT JOIN lote lo ON m.id_medicamento = lo.id_medicamento
GROUP BY 
    m.id_medicamento, m.codigo_de_barras, m.nombre, 
    CAST(m.descripcion AS VARCHAR(MAX)), -- conversión necesaria
    lab.nombre, m.costo, m.precio_venta, 
    m.precio_maximo_publico, m.fecha_de_registro, m.activo;
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[GoogleAuthenticatorSecret] [nvarchar](128) NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cliente]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cliente](
	[id_cliente] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[direccion] [varchar](255) NULL,
	[telefono] [varchar](20) NULL,
	[email] [varchar](100) NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[proveedor]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[proveedor](
	[id_proveedor] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[contacto] [varchar](100) NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_proveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[compra]  WITH CHECK ADD FOREIGN KEY([id_lote])
REFERENCES [dbo].[lote] ([id_lote])
GO
ALTER TABLE [dbo].[compra]  WITH CHECK ADD FOREIGN KEY([id_proveedor])
REFERENCES [dbo].[proveedor] ([id_proveedor])
GO
ALTER TABLE [dbo].[lote]  WITH CHECK ADD FOREIGN KEY([id_medicamento])
REFERENCES [dbo].[medicamento] ([id_medicamento])
GO
ALTER TABLE [dbo].[medicamento]  WITH CHECK ADD FOREIGN KEY([id_laboratorio])
REFERENCES [dbo].[laboratorio] ([id_laboratorio])
GO
ALTER TABLE [dbo].[venta]  WITH CHECK ADD FOREIGN KEY([id_cliente])
REFERENCES [dbo].[cliente] ([id_cliente])
GO
ALTER TABLE [dbo].[venta]  WITH CHECK ADD FOREIGN KEY([id_lote])
REFERENCES [dbo].[lote] ([id_lote])
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarCompra]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para actualizar una compra existente
CREATE PROCEDURE [dbo].[sp_ActualizarCompra]
    @id_compra INT,
    @id_lote INT,
    @cantidad INT,
    @realizado_por NVARCHAR(100),
    @fecha_de_entrada DATETIME
AS
BEGIN
    --SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @cantidadAnterior INT;
        SELECT @cantidadAnterior = cantidad FROM compra WHERE id_compra = @id_compra;

        DECLARE @diferencia INT;
        SET @diferencia = @cantidad - @cantidadAnterior;

        UPDATE lote
        SET cantidad = cantidad + @diferencia
        WHERE id_lote = @id_lote;

        DECLARE @costo FLOAT;
        SELECT @costo = m.costo
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;

        DECLARE @costo_total FLOAT;
        SET @costo_total = @cantidad * @costo;

        UPDATE compra
        SET cantidad = @cantidad, fecha_de_entrada = @fecha_de_entrada, realizado_por = @realizado_por, costo_total = @costo_total
        WHERE id_compra = @id_compra;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarLaboratorio]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para actualizar un laboratorio
CREATE PROCEDURE [dbo].[sp_ActualizarLaboratorio]
    @id INT,
    @nombre VARCHAR(100),
    @activo BIT
AS
BEGIN
    --SET NOCOUNT ON;
    UPDATE laboratorio SET nombre = @nombre, activo = @activo WHERE id_laboratorio = @id;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarLote]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para actualizar un lote existente
CREATE PROCEDURE [dbo].[sp_ActualizarLote]
    @id_lote INT,
    @numero_de_lote VARCHAR(50),
    @fecha_caducidad DATE,
    @id_medicamento INT,
    @activo BIT
AS
BEGIN
    --SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM lote WHERE numero_de_lote = @numero_de_lote AND id_medicamento = @id_medicamento AND id_lote != @id_lote)
    BEGIN
        RAISERROR('Ya existe otro lote con el mismo número para este medicamento.', 16, 1);
        RETURN;
    END
    UPDATE lote
    SET numero_de_lote = @numero_de_lote, fecha_caducidad = @fecha_caducidad, id_medicamento = @id_medicamento, activo = @activo
    WHERE id_lote = @id_lote;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarMedicamento]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarMedicamento]
    @id_medicamento INT,
    @nombre VARCHAR(100),
    @descripcion TEXT,
    @costo FLOAT,
    @precio_maximo_publico FLOAT,
    @precio_venta FLOAT,
    @codigo_de_barras VARCHAR(50),
    @id_laboratorio INT,
    @activo BIT
AS
BEGIN
    --SET NOCOUNT OFF;

    IF EXISTS (
        SELECT 1 FROM medicamento 
        WHERE codigo_de_barras = @codigo_de_barras AND id_medicamento != @id_medicamento
    )
    BEGIN
        RAISERROR (50000, 16, 1, N'Ya existe otro medicamento con el mismo código de barras.')
        RETURN
    END

    UPDATE medicamento
    SET nombre = @nombre,
        descripcion = @descripcion,
        costo = @costo,
        precio_maximo_publico = @precio_maximo_publico,
        precio_venta = @precio_venta,
        codigo_de_barras = @codigo_de_barras,
        id_laboratorio = @id_laboratorio,
        activo = @activo
    WHERE id_medicamento = @id_medicamento;

    SELECT @@ROWCOUNT AS filas_afectadas;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarVenta]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para modificar una venta existente
CREATE PROCEDURE [dbo].[sp_ActualizarVenta]
    @id_venta INT,
    @id_lote INT,
    @cantidad INT,
    @realizado_por NVARCHAR(100),
    @fecha_de_salida DATETIME
AS
BEGIN
    --SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @id_lote_anterior INT, @cantidadAnterior INT;
        SELECT @cantidadAnterior = v.cantidad, @id_lote_anterior = v.id_lote
        FROM venta v
        WHERE v.id_venta = @id_venta;

        DECLARE @diferencia INT = @cantidad - @cantidadAnterior;

        IF @cantidad > (SELECT cantidad FROM lote WHERE id_lote = @id_lote)
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50001, 'No hay suficiente cantidad en el inventario.', 1;
        END

        IF @id_lote = @id_lote_anterior
        BEGIN
            UPDATE lote
            SET cantidad = cantidad - @diferencia
            WHERE id_lote = @id_lote;
        END
        ELSE
        BEGIN
            UPDATE lote
            SET cantidad = cantidad + @cantidadAnterior
            WHERE id_lote = @id_lote_anterior;

            UPDATE lote
            SET cantidad = cantidad - @cantidad
            WHERE id_lote = @id_lote;
        END

        DECLARE @costo FLOAT, @precio_venta FLOAT;
        SELECT @costo = m.costo, @precio_venta = m.precio_venta
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;

        DECLARE @costo_venta FLOAT = @cantidad * @costo;
        DECLARE @precio_venta_total FLOAT = @cantidad * @precio_venta;
        DECLARE @ganancia_total FLOAT = @precio_venta_total - @costo_venta;

        UPDATE venta
        SET cantidad = @cantidad, fecha_de_salida = @fecha_de_salida, realizado_por = @realizado_por,
            precio_venta_total = @precio_venta_total, costo_venta = @costo_venta, ganancia_total = @ganancia_total, id_lote = @id_lote
        WHERE id_venta = @id_venta;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarCompra]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para eliminar una compra
CREATE PROCEDURE [dbo].[sp_EliminarCompra]
    @id_compra INT
AS
BEGIN
    --SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @id_lote INT, @cantidad INT;
        SELECT @id_lote = id_lote, @cantidad = cantidad FROM compra WHERE id_compra = @id_compra;

        DELETE FROM compra WHERE id_compra = @id_compra;

        UPDATE lote
        SET cantidad = cantidad - @cantidad
        WHERE id_lote = @id_lote;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarLaboratorio]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para marcar un laboratorio como inactivo
CREATE PROCEDURE [dbo].[sp_EliminarLaboratorio]
    @id INT
AS
BEGIN
    --SET NOCOUNT ON;
    UPDATE laboratorio SET activo = 0 WHERE id_laboratorio = @id;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarLote]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para desactivar un lote
CREATE PROCEDURE [dbo].[sp_EliminarLote]
    @id_lote INT
AS
BEGIN
    --SET NOCOUNT ON;
    UPDATE lote
    SET activo = 0
    WHERE id_lote = @id_lote;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarMedicamento]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para marcar un medicamento como inactivo
CREATE PROCEDURE [dbo].[sp_EliminarMedicamento]
    @id_medicamento INT
AS
BEGIN
    --SET NOCOUNT ON;
    UPDATE medicamento
    SET activo = 0
    WHERE id_medicamento = @id_medicamento;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarVenta]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para eliminar una venta
CREATE PROCEDURE [dbo].[sp_EliminarVenta]
    @id_venta INT,
    @id_lote INT,
    @cantidad INT
AS
BEGIN
    --SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DELETE FROM venta
        WHERE id_venta = @id_venta;

        UPDATE lote
        SET cantidad = cantidad + @cantidad
        WHERE id_lote = @id_lote;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarCompra]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarCompra]
    @id_lote INT,
    @cantidad INT,
    @realizado_por NVARCHAR(100),
    @fecha_de_entrada DATETIME
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @costo FLOAT;

        -- Obtener costo antes de actualizar
        SELECT @costo = m.costo
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;

        -- Validar que el costo exista
        IF @costo IS NULL
        BEGIN
            THROW 50001, 'No se encontró el medicamento para el lote especificado.', 1;
        END

        -- Actualizar la cantidad después de validar
        UPDATE lote
        SET cantidad = ISNULL(cantidad, 0) + @cantidad
        WHERE id_lote = @id_lote;

        DECLARE @costo_total FLOAT = @cantidad * @costo;

        INSERT INTO compra (id_lote, cantidad, costo_total, fecha_de_entrada, realizado_por)
        VALUES (@id_lote, @cantidad, @costo_total, @fecha_de_entrada, @realizado_por);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarLaboratorio]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para insertar un nuevo laboratorio
CREATE PROCEDURE [dbo].[sp_InsertarLaboratorio]
    @nombre VARCHAR(100),
    @activo BIT
AS
BEGIN
    --SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM laboratorio WHERE nombre = @nombre)
    BEGIN
        RAISERROR ('El laboratorio ya existe.', 16, 1);
        RETURN;
    END
    INSERT INTO laboratorio (nombre, activo) VALUES (@nombre, @activo);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarLote]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para insertar un nuevo lote
CREATE PROCEDURE [dbo].[sp_InsertarLote]
    @numero_de_lote VARCHAR(50),
    @fecha_caducidad DATE,
    @id_medicamento INT,
    @activo BIT
AS
BEGIN
    --SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM lote WHERE numero_de_lote = @numero_de_lote AND id_medicamento = @id_medicamento)
    BEGIN
        RAISERROR('Ya existe un lote con el mismo número para este medicamento.', 16, 1);
        RETURN;
    END
    INSERT INTO lote (numero_de_lote, fecha_caducidad, id_medicamento, activo)
    VALUES (@numero_de_lote, @fecha_caducidad, @id_medicamento, @activo);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarMedicamento]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para insertar un nuevo medicamento
CREATE PROCEDURE [dbo].[sp_InsertarMedicamento]
    @nombre VARCHAR(100),
    @descripcion TEXT,
    @costo FLOAT,
    @precio_maximo_publico FLOAT,
    @precio_venta FLOAT,
    @codigo_de_barras VARCHAR(50),
    @id_laboratorio INT,
    @fecha_de_registro DATE,
    @activo BIT
AS
BEGIN
    --SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM medicamento WHERE codigo_de_barras = @codigo_de_barras)
    BEGIN
        RAISERROR (50000, 16, 1, N'Ya existe un medicamento con el mismo código de barras.');
        RETURN;
    END
    INSERT INTO medicamento 
    (nombre, descripcion, costo, precio_maximo_publico, precio_venta, codigo_de_barras, id_laboratorio, fecha_de_registro, activo)
    VALUES 
    (@nombre, @descripcion, @costo, @precio_maximo_publico, @precio_venta, @codigo_de_barras, @id_laboratorio, @fecha_de_registro, @activo);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarVenta]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para insertar una nueva venta
CREATE PROCEDURE [dbo].[sp_InsertarVenta]
    @id_lote INT,
    @cantidad INT,
    @realizado_por NVARCHAR(100),
    @fecha_de_salida DATETIME
AS
BEGIN
    --SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @cantidadDisponible INT;
        SELECT @cantidadDisponible = cantidad FROM lote WHERE id_lote = @id_lote;

        IF @cantidad > @cantidadDisponible
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50001, 'No hay suficiente cantidad en el inventario.', 1;
        END

        DECLARE @costo FLOAT, @precio_venta FLOAT;
        SELECT @costo = m.costo, @precio_venta = m.precio_venta
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;

        DECLARE @costo_venta FLOAT = @cantidad * @costo;
        DECLARE @precio_venta_total FLOAT = @cantidad * @precio_venta;
        DECLARE @ganancia_total FLOAT = @precio_venta_total - @costo_venta;

        INSERT INTO venta (id_lote, cantidad, precio_venta_total, costo_venta, ganancia_total, fecha_de_salida, realizado_por)
        VALUES (@id_lote, @cantidad, @precio_venta_total, @costo_venta, @ganancia_total, @fecha_de_salida, @realizado_por);

        UPDATE lote
        SET cantidad = cantidad - @cantidad
        WHERE id_lote = @id_lote;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerBalanceAnterior]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener el balance del año anterior
CREATE PROCEDURE [dbo].[sp_ObtenerBalanceAnterior]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(precio_venta_total - costo_venta), 0) AS balanceAnterior
    FROM venta
    WHERE YEAR(fecha_de_salida) = YEAR(DATEADD(YEAR, -1, GETDATE()));
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerCompras]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener compras de un mes específico
CREATE PROCEDURE [dbo].[sp_ObtenerCompras]
    @Mes INT,
    @Año INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(costo_total), 0) AS compras
    FROM compra
    WHERE MONTH(fecha_de_entrada) = @Mes AND YEAR(fecha_de_entrada) = @Año;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasEntreFechas]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerComprasEntreFechas]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(c.costo_total), 0) AS compras_entre_fechas
    FROM compra c
    INNER JOIN lote l ON c.id_lote = l.id_lote
    INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
    WHERE c.fecha_de_entrada BETWEEN @FechaInicio AND @FechaFin
    AND m.activo = 1 AND l.activo = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasMes]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerComprasMes]
    @Mes INT,
    @Año INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(c.costo_total), 0) AS compras_mes
    FROM compra c
    INNER JOIN lote l ON c.id_lote = l.id_lote
    INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
    WHERE MONTH(c.fecha_de_entrada) = @Mes AND YEAR(c.fecha_de_entrada) = @Año
    AND m.activo = 1 AND l.activo = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasMesActual]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener compras del mes actual
CREATE PROCEDURE [dbo].[sp_ObtenerComprasMesActual]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Mes INT = MONTH(GETDATE());
    DECLARE @Año INT = YEAR(GETDATE());

    EXEC sp_ObtenerCompras @Mes, @Año;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasMesAnterior]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener compras del mes anterior
CREATE PROCEDURE [dbo].[sp_ObtenerComprasMesAnterior]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FechaAnterior DATE = DATEADD(MONTH, -1, GETDATE());
    DECLARE @Mes INT = MONTH(@FechaAnterior);
    DECLARE @Año INT = YEAR(@FechaAnterior);

    EXEC sp_ObtenerCompras @Mes, @Año;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerInventarioActual]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener el valor del inventario actual
CREATE PROCEDURE [dbo].[sp_ObtenerInventarioActual]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(m.costo * l.cantidad), 0) AS inventarioActual
    FROM lote l
    INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
    WHERE l.activo = 1 AND m.activo = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentas]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener ventas de un mes específico
CREATE PROCEDURE [dbo].[sp_ObtenerVentas]
    @Mes INT,
    @Año INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(precio_venta_total), 0) AS ventas
    FROM venta
    WHERE MONTH(fecha_de_salida) = @Mes AND YEAR(fecha_de_salida) = @Año;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasEntreFechas]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerVentasEntreFechas]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(v.precio_venta_total), 0) AS ventas_entre_fechas
    FROM venta v
    INNER JOIN lote l ON v.id_lote = l.id_lote
    INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
    WHERE v.fecha_de_salida BETWEEN @FechaInicio AND @FechaFin
    AND m.activo = 1 AND l.activo = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasMes]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerVentasMes]
    @Mes INT,
    @Año INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(SUM(v.precio_venta_total), 0) AS ventas_mes
    FROM venta v
    INNER JOIN lote l ON v.id_lote = l.id_lote
    INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
    WHERE MONTH(v.fecha_de_salida) = @Mes AND YEAR(v.fecha_de_salida) = @Año
    AND m.activo = 1 AND l.activo = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasMesActual]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener ventas del mes actual
CREATE PROCEDURE [dbo].[sp_ObtenerVentasMesActual]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Mes INT = MONTH(GETDATE());
    DECLARE @Año INT = YEAR(GETDATE());

    EXEC sp_ObtenerVentas @Mes, @Año;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasMesAnterior]    Script Date: 6/23/2025 3:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para obtener ventas del mes anterior
CREATE PROCEDURE [dbo].[sp_ObtenerVentasMesAnterior]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FechaAnterior DATE = DATEADD(MONTH, -1, GETDATE());
    DECLARE @Mes INT = MONTH(@FechaAnterior);
    DECLARE @Año INT = YEAR(@FechaAnterior);

    EXEC sp_ObtenerVentas @Mes, @Año;
END;
GO
