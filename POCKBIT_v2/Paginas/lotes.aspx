﻿<%@ Page Title="Lotes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="lotes.aspx.cs" Inherits="POCKBIT_v2.Paginas.lotes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="text-center mb-4">
        <h2>Lotes De Medicamentos</h2>
    </div>
    <asp:Literal ID="ltlAlert" runat="server"></asp:Literal>

    <div class="card-row">
        <div class="card">
            <div class="card-body p-3">
                <div class="row mb-4">
                    <!-- COL 9: FORMULARIO -->
                    <div class="col-md-9">
                        <div class="row mb-3">
                            <!-- ID -->
                            <div class="col-md-4">
                                <label class="form-control-label">ID:</label>
                                <asp:Label ID="lblId" runat="server" CssClass="form-control"></asp:Label>
                            </div>
                            <!-- Código de Barras -->
                            <div class="col-md-4">
                                <label class="form-control-label">Código de Barras:</label>
                                <asp:TextBox ID="txtCodigoB" runat="server" Placeholder="Código de Barras" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtCodigoB_TextChanged"></asp:TextBox>
                            </div>
                            <!-- Botón Escanear -->
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="button" onclick="iniciarEscaneo()" class="btn btn-secondary w-100">
                                    📷 Escanear
                                </button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <!-- Número de Lote -->
                            <div class="col-md-4">
                                <label class="form-control-label">Número de Lote:</label>
                                <asp:TextBox ID="txtNumeroLote" runat="server" Placeholder="Número de lote" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col md-4">
                                <label class="form-control-label">Fecha de caducidad:</label>
                                <input type="date" id="txtFechaCaducidad" runat="server" class="form-control" />
                            </div>
                            <!-- Estado -->
                            <div class="col-md-4">
                                <label class="form-control-label">Estado:</label>
                                <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Activo" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Inactivo" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 d-flex flex-column justify-content-between">
                        <label>Vista Escáner:</label>
                        <div id="reader" style="width: 100%; height: 100%; min-height: 250px; border: 1px solid #ccc; border-radius: 6px;"></div>
                    </div>
                </div>
                <!-- FILA DE BOTONES -->
                <div class="row mb-3 text-center">
                    <div class="col-md-3">
                        <asp:Button ID="btnInsertar" runat="server" Text="Insertar" CssClass="btn btn-success w-100" OnClick="btnInsertar_Click" />
                    </div>
                    <div class="col-md-3">
                        <asp:Button ID="btnModificar" runat="server" Text="Modificar" CssClass="btn btn-info w-100" OnClick="btnModificar_Click" />
                    </div>
                    <div class="col-md-3">
                        <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-danger w-100" OnClick="btnEliminar_Click" />
                    </div>
                    <div class="col-md-3">
                        <asp:Button ID="btnExportarExcel" runat="server" Text="Exportar a Excel" CssClass="btn btn-primary w-100" OnClick="btnExportarExcel_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <br />
    <div class="table-responsive rounded-3">
        <asp:GridView ID="GVLotes" runat="server" CssClass="table custom-table" AutoGenerateColumns="False" DataKeyNames="id_lote" DataSourceID="SqlDataSourceLotes" AllowSorting="True" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="GVLotes_SelectedIndexChanged" OnRowDataBound="GVLotes_RowDataBound" AllowPaging="True">
            <AlternatingRowStyle BackColor="White"></AlternatingRowStyle>
            <Columns>
                <asp:CommandField ShowSelectButton="True" ButtonType="Button"></asp:CommandField>
                <asp:BoundField DataField="id_lote" HeaderText="ID" SortExpression="id_lote" InsertVisible="False" ReadOnly="True"></asp:BoundField>
                <asp:BoundField DataField="codigo_de_barras" HeaderText="Código De Barras" SortExpression="codigo_de_barras"></asp:BoundField>
                <asp:BoundField DataField="numero_de_lote" HeaderText="Número De Lote" SortExpression="numero_de_lote"></asp:BoundField>
                <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre"></asp:BoundField>
                <asp:BoundField DataField="descripcion" HeaderText="Descripción" SortExpression="descripcion"></asp:BoundField>
                <asp:BoundField DataField="cantidad" HeaderText="Cantidad" SortExpression="cantidad">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="fecha_caducidad" HeaderText="Fecha De Caducidad" SortExpression="fecha_caducidad" DataFormatString="{0:yyyy-MM-dd}"></asp:BoundField>
                <asp:CheckBoxField DataField="activo" HeaderText="Activo" SortExpression="activo"></asp:CheckBoxField>
                <asp:BoundField DataField="realizado_por" HeaderText="Realizado Por" SortExpression="realizado_por"></asp:BoundField>
            </Columns>
            <EditRowStyle BackColor="#2461BF"></EditRowStyle>
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"></FooterStyle>
            <HeaderStyle BackColor="#03c3ec" Font-Bold="True" ForeColor="White"></HeaderStyle>
            <PagerStyle HorizontalAlign="Center" BackColor="#2461BF" ForeColor="White"></PagerStyle>
            <RowStyle BackColor="#EFF3FB"></RowStyle>
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333"></SelectedRowStyle>
            <SortedAscendingCellStyle BackColor="#F5F7FB"></SortedAscendingCellStyle>
            <SortedAscendingHeaderStyle BackColor="#6D95E1"></SortedAscendingHeaderStyle>
            <SortedDescendingCellStyle BackColor="#E9EBEF"></SortedDescendingCellStyle>
            <SortedDescendingHeaderStyle BackColor="#4870BE"></SortedDescendingHeaderStyle>
        </asp:GridView>
    </div>
    <asp:SqlDataSource runat="server" ID="SqlDataSourceLotes" ConnectionString='<%$ ConnectionStrings:DefaultConnection %>' SelectCommand="SELECT lote.id_lote, medicamento.codigo_de_barras, lote.numero_de_lote, medicamento.nombre, medicamento.descripcion, lote.cantidad, lote.fecha_caducidad, lote.activo, lote.realizado_por FROM laboratorio INNER JOIN medicamento ON laboratorio.id_laboratorio = medicamento.id_laboratorio INNER JOIN lote ON medicamento.id_medicamento = lote.id_medicamento WHERE (laboratorio.activo = 1) ORDER BY lote.id_lote DESC"></asp:SqlDataSource>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <script>
        function iniciarEscaneo() {
            const html5QrCode = new Html5Qrcode("reader");
            const qrConfig = { fps: 10, qrbox: 250 };

            html5QrCode.start(
                { facingMode: "environment" },
                qrConfig,
                (decodedText) => {
                    // Establecer el valor decodificado en el campo de código de barras
                    const input = document.getElementById('<%= txtCodigoB.ClientID %>');
                    input.value = decodedText;

                    html5QrCode.stop().then(() => {
                        // Limpiar el área de escaneo
                        document.getElementById("reader").innerHTML = "";
                    });

                    // Forzar blur y luego __doPostBack
                    input.focus();
                    setTimeout(() => {
                        input.blur(); // Esto activa el evento TextChanged si es manual
                        __doPostBack('<%= txtCodigoB.UniqueID %>', ''); // Forzar postback para manejar el evento
                    }, 300);
                },
                (errorMessage) => {
                    // Puedes mostrar un error si el escaneo no es exitoso
                }
            ).catch(err => {
                console.error("Error al acceder a la cámara", err);
            });
        }
    </script>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <script>
        function iniciarEscaneo() {
            const html5QrCode = new Html5Qrcode("reader");
            const qrConfig = { fps: 10, qrbox: 250 };

            html5QrCode.start(
                { facingMode: "environment" },
                qrConfig,
                (decodedText) => {
                    // Establecer el valor decodificado en el campo de código de barras
                    const input = document.getElementById('<%= txtCodigoB.ClientID %>');
                    input.value = decodedText;

                    html5QrCode.stop().then(() => {
                        // Limpiar el área de escaneo
                        document.getElementById("reader").innerHTML = "";
                    });

                    // Forzar blur y luego __doPostBack
                    input.focus();
                    setTimeout(() => {
                        input.blur(); // Esto activa el evento TextChanged si es manual
                        __doPostBack('<%= txtCodigoB.UniqueID %>', ''); // Forzar postback para manejar el evento
                    }, 300);
                },
                (errorMessage) => {
                    // Puedes mostrar un error si el escaneo no es exitoso
                }
            ).catch(err => {
                console.error("Error al acceder a la cámara", err);
            });
        }
    </script>
</asp:Content>