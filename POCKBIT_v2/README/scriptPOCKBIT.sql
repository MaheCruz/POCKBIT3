USE [POCKBIT_v2]
GO
/****** Object:  Table [dbo].[laboratorio]    Script Date: 7/10/2025 9:21:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[laboratorio](
	[id_laboratorio] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[activo] [bit] NULL,
	[realizado_por] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_laboratorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[medicamento]    Script Date: 7/10/2025 9:22:03 AM ******/
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
	[cantidad] [int] NULL,
	[realizado_por] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_medicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lote]    Script Date: 7/10/2025 9:22:03 AM ******/
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
	[realizado_por] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[compra]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  View [dbo].[ViewCompra]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[cliente]    Script Date: 7/10/2025 9:22:03 AM ******/
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
	[fecha_registro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[venta]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  View [dbo].[ViewVenta]    Script Date: 7/10/2025 9:22:03 AM ******/
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
    v.realizado_por,
    ISNULL(c.nombre, 'Público en general') AS nombre_cliente
FROM 
    dbo.venta AS v 
    INNER JOIN dbo.lote AS l ON v.id_lote = l.id_lote 
    INNER JOIN dbo.medicamento AS m ON l.id_medicamento = m.id_medicamento 
    LEFT OUTER JOIN dbo.cliente AS c ON v.id_cliente = c.id_cliente
GO
/****** Object:  View [dbo].[ViewInventarioActual]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  View [dbo].[ViewBalance]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  View [dbo].[ViewVentaReporte]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  View [dbo].[ViewCompraReporte]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  View [dbo].[ViewMedicamento]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewMedicamento] AS
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
    m.activo,
    m.realizado_por
FROM medicamento m
LEFT JOIN laboratorio lab ON m.id_laboratorio = lab.id_laboratorio
LEFT JOIN lote lo ON m.id_medicamento = lo.id_medicamento
GROUP BY 
    m.id_medicamento, m.codigo_de_barras, m.nombre, 
    CAST(m.descripcion AS VARCHAR(MAX)), -- conversión necesaria
    lab.nombre, m.costo, m.precio_venta, 
    m.precio_maximo_publico, m.fecha_de_registro, m.activo, m.realizado_por;
GO
/****** Object:  View [dbo].[ViewLote]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[ViewLote] AS SELECT l.id_lote AS ID, m.codigo_de_barras AS [Código De Barras], l.numero_de_lote AS [Número De Lote], m.nombre AS Nombre, m.descripcion AS Descripción, l.cantidad AS Cantidad, l.fecha_caducidad AS [Fecha De Caducidad], l.activo AS Activo, l.realizado_por AS [Realizado Por] FROM lote l INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento;
GO
/****** Object:  View [dbo].[ViewLaboratorio]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[ViewLaboratorio] AS
SELECT 
    id_laboratorio AS ID,
    nombre AS Nombre,
    activo AS Activo,
    realizado_por AS [Realizado Por]
FROM 
    laboratorio;
GO
/****** Object:  View [dbo].[ViewCliente]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[ViewCliente] AS
SELECT 
    id_cliente,
    nombre,
    direccion,
    telefono,
    email,
    fecha_registro,
    activo
FROM cliente;

GO
/****** Object:  View [dbo].[ViewTicket]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[ViewTicket] AS
SELECT 
    v.id_venta,
    v.fecha_de_salida,
    v.precio_venta_total AS total,
    ISNULL(c.nombre, 'PÚBLICO GENERAL') AS cliente,
    m.nombre AS medicamento,
    v.cantidad,
    v.realizado_por
FROM venta v
INNER JOIN lote l ON v.id_lote = l.id_lote
INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 7/10/2025 9:22:03 AM ******/
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
/****** Object:  Table [dbo].[proveedor]    Script Date: 7/10/2025 9:22:03 AM ******/
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
ALTER TABLE [dbo].[medicamento] ADD  DEFAULT ((0)) FOR [cantidad]
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
/****** Object:  StoredProcedure [dbo].[sp_ActualizarCliente]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_ActualizarCliente]
    @id_cliente INT,
    @nombre NVARCHAR(100),
    @direccion NVARCHAR(200) = NULL,
    @telefono NVARCHAR(20) = NULL,
    @email NVARCHAR(100) = NULL,
    @activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validación 1: Cliente debe existir
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('El cliente especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validación 2: Nombre es requerido
        IF LEN(ISNULL(@nombre, '')) = 0
        BEGIN
            RAISERROR('El nombre del cliente es obligatorio.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validación 3: Email válido si se proporciona
        IF @email IS NOT NULL AND @email <> ''
        BEGIN
            IF @email NOT LIKE '%_@__%.__%'
            BEGIN
                RAISERROR('El formato del email no es válido.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- Validación 4: Email único (excluyendo el actual cliente)
            IF EXISTS (SELECT 1 FROM cliente WHERE email = @email AND id_cliente <> @id_cliente)
            BEGIN
                RAISERROR('Ya existe otro cliente con este email.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        -- Validación 5: Teléfono válido si se proporciona
        IF @telefono IS NOT NULL AND @telefono <> ''
        BEGIN
            -- Eliminar caracteres no numéricos
            SET @telefono = REPLACE(REPLACE(REPLACE(REPLACE(@telefono, ' ', ''), '-', ''), '(', ''), ')', '')
            
            IF ISNUMERIC(@telefono) = 0 OR LEN(@telefono) < 10
            BEGIN
                RAISERROR('El teléfono debe contener al menos 10 dígitos numéricos.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- Validación 6: Teléfono único (excluyendo el actual cliente)
            IF EXISTS (SELECT 1 FROM cliente WHERE telefono = @telefono AND id_cliente <> @id_cliente)
            BEGIN
                RAISERROR('Ya existe otro cliente con este teléfono.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        -- Validación 7: No desactivar si tiene ventas activas
        DECLARE @activo_actual BIT;
        SELECT @activo_actual = activo FROM cliente WHERE id_cliente = @id_cliente;
        
        IF @activo_actual = 1 AND @activo = 0
        BEGIN
            -- Usar el nombre correcto de la columna de fecha (ajusta según tu esquema)
            IF EXISTS (SELECT 1 FROM venta WHERE id_cliente = @id_cliente AND fecha_de_salida >= DATEADD(MONTH, -6, GETDATE()))
            BEGIN
                RAISERROR('No se puede desactivar un cliente con ventas recientes (últimos 6 meses).', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        -- Actualizar el cliente (solo con los campos de la tabla)
        UPDATE cliente SET
            nombre = @nombre,
            direccion = @direccion,
            telefono = @telefono,
            email = @email,
            activo = @activo
        WHERE id_cliente = @id_cliente;
        
        -- Retornar mensaje de éxito
        SELECT 'Cliente actualizado correctamente.' AS mensaje;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarCompra]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ActualizarCompra]
    @id_compra INT,
    @id_lote INT,
    @cantidad INT,
    @realizado_por NVARCHAR(100),
    @fecha_de_entrada DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar fecha futura
        IF @fecha_de_entrada > GETDATE()
        BEGIN
            RAISERROR('No se permiten compras con fecha futura.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Obtener datos actuales
        DECLARE @cantidadAnterior INT, @id_lote_actual INT;
        SELECT @cantidadAnterior = cantidad, @id_lote_actual = id_lote 
        FROM compra 
        WHERE id_compra = @id_compra;
        
        -- Validar cambio de lote
        IF @id_lote_actual != @id_lote
        BEGIN
            RAISERROR('No se permite cambiar el lote de una compra existente.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Calcular ventas totales para este lote
        DECLARE @ventas INT;
        SELECT @ventas = ISNULL(SUM(cantidad), 0) 
        FROM venta 
        WHERE id_lote = @id_lote;
        
        -- Validar cantidad no menor a ventas
        IF @cantidad < @ventas
        BEGIN
            RAISERROR('No se puede reducir la cantidad por debajo de las ventas registradas (%d unidades vendidas).', 16, 1, @ventas);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Calcular diferencia
        DECLARE @diferencia INT = @cantidad - @cantidadAnterior;
        
        -- Actualizar cantidad en lote
        UPDATE lote 
        SET cantidad = cantidad + @diferencia 
        WHERE id_lote = @id_lote;
        
        -- Obtener costo actualizado
        DECLARE @costo FLOAT, @id_medicamento INT;
        SELECT @costo = m.costo, @id_medicamento = l.id_medicamento 
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;
        
        -- Actualizar compra
        UPDATE compra
        SET cantidad = @cantidad,
            fecha_de_entrada = @fecha_de_entrada,
            realizado_por = @realizado_por,
            costo_total = @cantidad * @costo
        WHERE id_compra = @id_compra;
        
        -- Actualizar cantidad total en medicamento (optimizado)
        UPDATE m
        SET m.cantidad = (SELECT SUM(l.cantidad) FROM lote l WHERE l.id_medicamento = @id_medicamento AND l.activo = 1)
        FROM medicamento m
        WHERE m.id_medicamento = @id_medicamento;
        
        COMMIT TRANSACTION;
        SELECT 'Compra actualizada correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarLaboratorio]    Script Date: 7/10/2025 9:22:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarLaboratorio]
    @id INT,
    @nombre VARCHAR(100),
    @activo BIT,
    @realizado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si hay otro laboratorio con el mismo nombre
    IF EXISTS (
        SELECT 1 FROM laboratorio
        WHERE nombre = @nombre AND id_laboratorio <> @id
    )
    BEGIN
        RAISERROR ('Ya existe otro laboratorio con ese nombre.', 16, 1);
        RETURN;
    END

    -- Actualizar datos
    UPDATE laboratorio
    SET nombre = @nombre,
        activo = @activo,
        realizado_por = @realizado_por
    WHERE id_laboratorio = @id;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarLote]    Script Date: 7/10/2025 9:22:03 AM ******/
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
    @activo BIT,
    @realizado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar que no exista otro lote con el mismo número para el mismo medicamento (excluyendo el actual)
        IF EXISTS (
            SELECT 1 FROM lote 
            WHERE numero_de_lote = @numero_de_lote 
              AND id_medicamento = @id_medicamento 
              AND id_lote != @id_lote
        )
        BEGIN
            RAISERROR('Ya existe otro lote con el mismo número para este medicamento.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Validar que no se pueda cambiar el número de lote a uno que ya existe para otro medicamento
        IF EXISTS (
            SELECT 1 FROM lote 
            WHERE numero_de_lote = @numero_de_lote 
              AND id_medicamento != @id_medicamento
              AND id_lote != @id_lote
        )
        BEGIN
            RAISERROR('Este número de lote ya está asociado a otro medicamento diferente.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. No permitir desactivar un lote que tiene ventas asociadas
        DECLARE @estado_actual BIT;
        SELECT @estado_actual = activo FROM lote WHERE id_lote = @id_lote;

        IF EXISTS (
            SELECT 1 FROM venta 
            WHERE id_lote = @id_lote
        ) AND @activo = 0 AND @estado_actual = 1
        BEGIN
            RAISERROR('No se puede desactivar un lote que tiene ventas asociadas.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. No permitir activar un lote con fecha de caducidad vencida
        IF @fecha_caducidad < CAST(GETDATE() AS DATE) AND @activo = 1
        BEGIN
            RAISERROR('No se puede activar un lote con fecha de caducidad vencida.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el lote (sin fecha_modificacion)
        UPDATE lote
        SET numero_de_lote = @numero_de_lote,
            fecha_caducidad = @fecha_caducidad,
            id_medicamento = @id_medicamento,
            activo = @activo,
            realizado_por = @realizado_por
        WHERE id_lote = @id_lote;

        COMMIT TRANSACTION;
        SELECT 'Lote modificado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarMedicamento]    Script Date: 7/10/2025 9:22:04 AM ******/
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
    @activo BIT,
    @realizado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el código de barras sea numérico y de longitud 8, 12 o 13
    IF @codigo_de_barras NOT LIKE '[0-9]%' OR 
       LEN(@codigo_de_barras) NOT IN (8, 12, 13)
    BEGIN
        SELECT 'Error: El código de barras debe contener solo números y tener 8, 12 o 13 dígitos (EAN-8, UPC-A o EAN-13).' AS mensaje;
        RETURN;
    END

    -- Validar duplicado por código de barras
    IF EXISTS (
        SELECT 1 FROM medicamento 
        WHERE codigo_de_barras = @codigo_de_barras 
        AND id_medicamento <> @id_medicamento
    )
    BEGIN
        SELECT 'Error: Ya existe otro medicamento con el mismo código de barras.' AS mensaje;
        RETURN;
    END

    -- Validar duplicado por nombre y laboratorio
    IF EXISTS (
        SELECT 1 FROM medicamento 
        WHERE nombre = @nombre AND id_laboratorio = @id_laboratorio 
        AND id_medicamento <> @id_medicamento
    )
    BEGIN
        SELECT 'Error: Ya existe otro medicamento con el mismo nombre y laboratorio.' AS mensaje;
        RETURN;
    END

    -- Actualizar
    UPDATE medicamento
    SET nombre = @nombre,
        descripcion = @descripcion,
        costo = @costo,
        precio_maximo_publico = @precio_maximo_publico,
        precio_venta = @precio_venta,
        codigo_de_barras = @codigo_de_barras,
        id_laboratorio = @id_laboratorio,
        activo = @activo,
        realizado_por = @realizado_por
    WHERE id_medicamento = @id_medicamento;

    IF @@ROWCOUNT > 0
        SELECT 'Medicamento modificado correctamente.' AS mensaje;
    ELSE
        SELECT 'No se modificó el medicamento.' AS mensaje;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarVenta]    Script Date: 7/10/2025 9:22:04 AM ******/
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
    @fecha_de_salida DATETIME,
    @id_cliente INT = NULL  -- Nuevo parámetro para el cliente
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Resultado INT = 0;
    DECLARE @Mensaje NVARCHAR(200) = 'No se pudo actualizar la venta';
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar existencia de la venta
        IF NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = @id_venta)
        BEGIN
            SET @Mensaje = 'La venta especificada no existe.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Validar existencia del nuevo lote
        IF NOT EXISTS (SELECT 1 FROM lote WHERE id_lote = @id_lote)
        BEGIN
            SET @Mensaje = 'El lote especificado no existe.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Validar existencia del cliente si se proporciona
        IF @id_cliente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente AND activo = 1)
        BEGIN
            SET @Mensaje = 'El cliente especificado no existe o no está activo.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Validación: cantidad debe ser mayor a 0
        IF @cantidad <= 0
        BEGIN
            SET @Mensaje = 'La cantidad debe ser mayor a cero.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Obtener datos anteriores de la venta
        DECLARE @id_lote_anterior INT, @cantidadAnterior INT;
        SELECT @cantidadAnterior = cantidad, @id_lote_anterior = id_lote
        FROM venta WHERE id_venta = @id_venta;

        DECLARE @cantidad_disponible INT;

        -- Manejo de cambios en el lote y cantidad
        IF @id_lote = @id_lote_anterior
        BEGIN
            -- Mismo lote: ajustar diferencia de cantidad
            SET @cantidad_disponible = (SELECT cantidad FROM lote WHERE id_lote = @id_lote);
            IF (@cantidad - @cantidadAnterior) > @cantidad_disponible
            BEGIN
                SET @Mensaje = 'Stock insuficiente para la modificación.';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
                RETURN;
            END

            UPDATE lote
            SET cantidad = cantidad - (@cantidad - @cantidadAnterior)
            WHERE id_lote = @id_lote;
        END
        ELSE
        BEGIN
            -- Lote diferente: restaurar stock anterior y descontar del nuevo
            UPDATE lote
            SET cantidad = cantidad + @cantidadAnterior
            WHERE id_lote = @id_lote_anterior;

            -- Verificar stock del nuevo lote
            IF @cantidad > (SELECT cantidad FROM lote WHERE id_lote = @id_lote)
            BEGIN
                SET @Mensaje = 'No hay suficiente stock en el nuevo lote.';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
                RETURN;
            END

            -- Descontar del nuevo lote
            UPDATE lote
            SET cantidad = cantidad - @cantidad
            WHERE id_lote = @id_lote;
        END

        -- Obtener precios y costos del nuevo lote
        DECLARE @costo FLOAT, @precio FLOAT;
        SELECT @costo = m.costo, @precio = m.precio_venta
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;

        -- Calcular nuevos totales
        DECLARE @precio_total FLOAT = @cantidad * @precio;
        DECLARE @ganancia FLOAT = @precio_total - (@cantidad * @costo);

        -- Actualizar la venta (incluyendo el cliente)
        UPDATE venta
        SET 
            cantidad = @cantidad,
            fecha_de_salida = @fecha_de_salida,
            realizado_por = @realizado_por,
            precio_venta_total = @precio_total,
            costo_venta = @cantidad * @costo,
            ganancia_total = @ganancia,
            id_lote = @id_lote,
            id_cliente = @id_cliente  -- Actualizar el cliente
        WHERE id_venta = @id_venta;

        COMMIT TRANSACTION;
        SET @Resultado = 1;
        SET @Mensaje = 'Venta actualizada correctamente.';
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = ERROR_MESSAGE();
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarCliente]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_EliminarCliente]
    @id_cliente INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validación 1: Cliente debe existir
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('El cliente especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validación 2: No se puede eliminar si tiene ventas asociadas
        IF EXISTS (SELECT 1 FROM venta WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('No se puede eliminar un cliente con ventas asociadas.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminación lógica (solo lo desactiva)
        UPDATE cliente
        SET activo = 0
        WHERE id_cliente = @id_cliente;

        SELECT 'Cliente desactivado correctamente.' AS mensaje;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarCompra]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para eliminar una compra
CREATE PROCEDURE [dbo].[sp_EliminarCompra]
    @id_compra INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si tiene ventas asociadas
        DECLARE @id_lote INT;
        SELECT @id_lote = id_lote FROM compra WHERE id_compra = @id_compra;
        
        IF EXISTS (SELECT 1 FROM venta WHERE id_lote = @id_lote)
        BEGIN
            RAISERROR('No se puede eliminar la compra porque tiene ventas asociadas.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Obtener datos de la compra
        DECLARE @cantidad INT, @id_medicamento INT;
        SELECT @cantidad = cantidad FROM compra WHERE id_compra = @id_compra;
        SELECT @id_medicamento = id_medicamento FROM lote WHERE id_lote = @id_lote;
        
        -- Eliminar la compra
        DELETE FROM compra WHERE id_compra = @id_compra;
        
        -- Actualizar cantidad en lote
        UPDATE lote
        SET cantidad = cantidad - @cantidad
        WHERE id_lote = @id_lote;
        
        -- Actualizar cantidad total en medicamento (optimizado)
        UPDATE m
        SET m.cantidad = (SELECT SUM(l.cantidad) FROM lote l WHERE l.id_medicamento = @id_medicamento AND l.activo = 1)
        FROM medicamento m
        WHERE m.id_medicamento = @id_medicamento;
        
        COMMIT TRANSACTION;
        SELECT 'Compra eliminada correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarLaboratorio]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_EliminarLaboratorio]
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si hay medicamentos asociados
    IF EXISTS (SELECT 1 FROM medicamento WHERE id_laboratorio = @id)
    BEGIN
        RAISERROR ('No se puede eliminar el laboratorio porque tiene medicamentos asociados.', 16, 1);
        RETURN;
    END

    -- Marcar como inactivo
    UPDATE laboratorio SET activo = 0 WHERE id_laboratorio = @id;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarLote]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para desactivar un lote

CREATE PROCEDURE [dbo].[sp_EliminarLote]
    @id_lote INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el lote tiene compras asociadas
        IF EXISTS (SELECT 1 FROM compra WHERE id_lote = @id_lote)
        BEGIN
            RAISERROR('Error: No se puede desactivar el lote porque tiene compras asociadas.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el lote tiene ventas asociadas
        IF EXISTS (SELECT 1 FROM venta WHERE id_lote = @id_lote)
        BEGIN
            RAISERROR('Error: No se puede desactivar el lote porque tiene ventas asociadas.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el lote ya está desactivado
        DECLARE @estado_actual BIT;
        SELECT @estado_actual = activo FROM lote WHERE id_lote = @id_lote;
        
        IF @estado_actual = 0
        BEGIN
            RAISERROR('El lote ya se encuentra desactivado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Desactivar el lote
        UPDATE lote
        SET activo = 0
        WHERE id_lote = @id_lote;

        COMMIT TRANSACTION;
        SELECT 'Lote desactivado correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarMedicamento]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para marcar un medicamento como inactivo
CREATE PROCEDURE [dbo].[sp_EliminarMedicamento]
    @id_medicamento INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE medicamento
    SET activo = 0
    WHERE id_medicamento = @id_medicamento;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarVenta]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_InsertarCliente]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsertarCliente]
    @nombre NVARCHAR(100),
    @direccion NVARCHAR(200) = NULL,
    @telefono NVARCHAR(20) = NULL,
    @email NVARCHAR(100) = NULL,
    @activo BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validación 1: Nombre es requerido
        IF LEN(ISNULL(@nombre, '')) = 0
        BEGIN
            RAISERROR('El nombre del cliente es obligatorio.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validación 2: Email válido si se proporciona
        IF @email IS NOT NULL AND @email <> ''
        BEGIN
            IF @email NOT LIKE '%_@__%.__%'
            BEGIN
                RAISERROR('El formato del email no es válido.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- Validación 3: Email único
            IF EXISTS (SELECT 1 FROM cliente WHERE email = @email)
            BEGIN
                RAISERROR('Ya existe un cliente con este email.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        -- Validación 4: Teléfono válido si se proporciona
        IF @telefono IS NOT NULL AND @telefono <> ''
        BEGIN
            -- Eliminar caracteres no numéricos
            SET @telefono = REPLACE(REPLACE(REPLACE(REPLACE(@telefono, ' ', ''), '-', ''), '(', ''), ')', '')
            
            IF ISNUMERIC(@telefono) = 0 OR LEN(@telefono) < 10
            BEGIN
                RAISERROR('El teléfono debe contener al menos 10 dígitos numéricos.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
			IF EXISTS (SELECT 1 FROM cliente WHERE telefono = @telefono)
            BEGIN
                RAISERROR('Ya existe un cliente con este telefono.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        -- Insertar el nuevo cliente
        INSERT INTO cliente (
            nombre, 
            direccion, 
            telefono, 
            email, 
            activo, 
            fecha_registro
        )
        VALUES (
            @nombre,
            @direccion,
            @telefono,
            @email,
            @activo,
            GETDATE()
        );
        
        -- Retornar mensaje de éxito con el ID generado
        DECLARE @id_cliente INT = SCOPE_IDENTITY();
        SELECT 'Cliente creado correctamente. ID: ' + CAST(@id_cliente AS NVARCHAR(10)) AS mensaje;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarCompra]    Script Date: 7/10/2025 9:22:04 AM ******/
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
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar fecha futura
        IF @fecha_de_entrada > GETDATE()
        BEGIN
            RAISERROR('No se permiten compras con fecha futura.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Obtener costo del medicamento (optimizado)
        DECLARE @costo FLOAT, @id_medicamento INT;
        
        SELECT @costo = m.costo, @id_medicamento = l.id_medicamento
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;
        
        IF @costo IS NULL
        BEGIN
            RAISERROR('No se encontró el medicamento para el lote especificado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Actualizar cantidad del lote
        UPDATE lote
        SET cantidad = ISNULL(cantidad, 0) + @cantidad
        WHERE id_lote = @id_lote;
        
        -- Insertar compra
        DECLARE @costo_total FLOAT = @cantidad * @costo;
        
        INSERT INTO compra (id_lote, cantidad, costo_total, fecha_de_entrada, realizado_por)
        VALUES (@id_lote, @cantidad, @costo_total, @fecha_de_entrada, @realizado_por);
        
        -- Actualizar cantidad total en medicamento (optimizado)
        UPDATE m
        SET m.cantidad = (SELECT SUM(l.cantidad) FROM lote l WHERE l.id_medicamento = @id_medicamento AND l.activo = 1)
        FROM medicamento m
        WHERE m.id_medicamento = @id_medicamento;
        
        COMMIT TRANSACTION;
        SELECT 'Compra registrada correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarLaboratorio]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarLaboratorio]
    @nombre VARCHAR(100),
    @activo BIT,
    @realizado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si ya existe un laboratorio con ese nombre
    IF EXISTS (SELECT 1 FROM laboratorio WHERE nombre = @nombre)
    BEGIN
        RAISERROR ('El laboratorio ya existe.', 16, 1);
        RETURN;
    END

    -- Insertar nuevo laboratorio
    INSERT INTO laboratorio (nombre, activo, realizado_por)
    VALUES (@nombre, @activo, @realizado_por);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarLote]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento almacenado para insertar un nuevo lote
CREATE PROCEDURE [dbo].[sp_InsertarLote]
    @numero_de_lote VARCHAR(50),
    @fecha_caducidad DATE,
    @id_medicamento INT,
    @activo BIT,
    @realizado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si ya existe un lote con el mismo número para este medicamento
    IF EXISTS (
        SELECT 1 FROM lote 
        WHERE numero_de_lote = @numero_de_lote AND id_medicamento = @id_medicamento
    )
    BEGIN
        RAISERROR('Ya existe un lote con ese número para el medicamento.', 16, 1);
        RETURN;
    END
	IF EXISTS (
		SELECT 1 FROM lote 
		WHERE numero_de_lote = @numero_de_lote AND id_medicamento <> @id_medicamento
	)
	BEGIN
		RAISERROR('Este número de lote ya está asociado a otro medicamento diferente.', 16, 1);
		RETURN;
	END

    -- Si la fecha de caducidad ya pasó, el lote se inserta como inactivo
    IF @fecha_caducidad < CAST(GETDATE() AS DATE)
        SET @activo = 0;

    INSERT INTO lote (numero_de_lote, fecha_caducidad, id_medicamento, activo, realizado_por)
    VALUES (@numero_de_lote, @fecha_caducidad, @id_medicamento, @activo, @realizado_por);

    SELECT 'Lote insertado correctamente.' AS mensaje;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarMedicamento]    Script Date: 7/10/2025 9:22:04 AM ******/
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
    @activo BIT,
    @realizado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar código de barras (solo números y longitud permitida)
    IF @codigo_de_barras NOT LIKE '[0-9]%' OR 
       LEN(@codigo_de_barras) NOT IN (8, 12, 13)
    BEGIN
        SELECT 'Error: El código de barras debe contener solo números y tener 8, 12 o 13 dígitos (EAN-8, UPC-A o EAN-13).' AS mensaje;
        RETURN;
    END

    -- Validar si ya existe un medicamento con el mismo código de barras
    IF EXISTS (
        SELECT 1 FROM medicamento WHERE codigo_de_barras = @codigo_de_barras
    )
    BEGIN
        SELECT 'Error: Ya existe un medicamento con el mismo código de barras.' AS mensaje;
        RETURN;
    END

    -- Validar si ya existe un medicamento con el mismo nombre y laboratorio
    IF EXISTS (
        SELECT 1 FROM medicamento 
        WHERE nombre = @nombre AND id_laboratorio = @id_laboratorio
    )
    BEGIN
        SELECT 'Error: Ya existe un medicamento con el mismo nombre y laboratorio.' AS mensaje;
        RETURN;
    END

    -- Insertar el medicamento
    INSERT INTO medicamento 
    (nombre, descripcion, costo, precio_maximo_publico, precio_venta, codigo_de_barras, id_laboratorio, fecha_de_registro, activo, realizado_por)
    VALUES 
    (@nombre, @descripcion, @costo, @precio_maximo_publico, @precio_venta, @codigo_de_barras, @id_laboratorio, @fecha_de_registro, @activo, @realizado_por);
	IF @@ROWCOUNT = 1
		SELECT 'Medicamento insertado correctamente.' AS mensaje;
	ELSE
		SELECT 'Error: No se insertó el medicamento.' AS mensaje;



END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarVenta]    Script Date: 7/10/2025 9:22:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para insertar una nueva venta
CREATE PROCEDURE [dbo].[sp_InsertarVenta]
    @id_lote INT,
    @cantidad INT,
    @realizado_por NVARCHAR(100),
    @fecha_de_salida DATE,
    @id_cliente INT = NULL  -- Parámetro opcional para el cliente
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Resultado INT = 0;
    DECLARE @Mensaje NVARCHAR(200) = 'No se pudo registrar la venta';
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación: Lote debe existir y estar activo
        IF NOT EXISTS (SELECT 1 FROM lote WHERE id_lote = @id_lote)
        BEGIN
            SET @Mensaje = 'El lote especificado no existe.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Validación: cantidad debe ser mayor a 0
        IF @cantidad <= 0
        BEGIN
            SET @Mensaje = 'La cantidad debe ser mayor a cero.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Validación: cantidad disponible suficiente
        IF @cantidad > (SELECT cantidad FROM lote WHERE id_lote = @id_lote)
        BEGIN
            SET @Mensaje = 'La cantidad vendida excede el stock disponible.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Validación: Si se proporciona un cliente, debe existir
        IF @id_cliente IS NOT NULL AND NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente AND activo = 1)
        BEGIN
            SET @Mensaje = 'El cliente especificado no existe o no está activo.';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END

        -- Obtener precios y costos
        DECLARE @costo FLOAT, @precio FLOAT;

        SELECT @costo = m.costo, @precio = m.precio_venta
        FROM lote l
        INNER JOIN medicamento m ON l.id_medicamento = m.id_medicamento
        WHERE l.id_lote = @id_lote;

        DECLARE @precio_total FLOAT = @cantidad * @precio;
        DECLARE @ganancia FLOAT = @precio_total - (@cantidad * @costo);

        -- Insertar venta con el cliente (puede ser NULL)
        INSERT INTO venta (
            id_lote, 
            cantidad, 
            precio_venta_total, 
            costo_venta, 
            ganancia_total, 
            fecha_de_salida, 
            realizado_por,
            id_cliente  -- Nuevo campo
        )
        VALUES (
            @id_lote, 
            @cantidad, 
            @precio_total, 
            @cantidad * @costo, 
            @ganancia, 
            @fecha_de_salida, 
            @realizado_por,
            @id_cliente  -- Nuevo valor (puede ser NULL)
        );

        -- Actualizar stock del lote
        UPDATE lote SET cantidad = cantidad - @cantidad WHERE id_lote = @id_lote;

        COMMIT TRANSACTION;
        SET @Resultado = 1;
        SET @Mensaje = 'Venta registrada correctamente.';
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = ERROR_MESSAGE();
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerBalanceAnterior]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerCompras]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasEntreFechas]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasMes]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasMesActual]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerComprasMesAnterior]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerInventarioActual]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentas]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasEntreFechas]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasMes]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasMesActual]    Script Date: 7/10/2025 9:22:04 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ObtenerVentasMesAnterior]    Script Date: 7/10/2025 9:22:04 AM ******/
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
